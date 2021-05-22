------------------------
--
-- Connect as "SYS"
--
------------------------

DROP USER aq_admin CASCADE;

--Creamos la cuenta administrador
CREATE USER aq_admin IDENTIFIED BY aq_admin
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

ALTER USER aq_admin QUOTA UNLIMITED ON users;

--asignamos los roles
GRANT aq_administrator_role TO aq_admin;
GRANT connect TO aq_admin;
GRANT create type TO aq_admin;
GRANT create procedure TO aq_admin;

------------------------
--
-- Connect as "aq_admin"
--
------------------------
--Creamos un objeto que almacenara los datos del pedido
CREATE TYPE orders_message_type AS OBJECT (
order_id NUMBER(15),
Product_code VARCHAR2(10),
Customer_id VARCHAR2(10),
order_details VARCHAR2(4000),
price NUMBER(4,2),
region_code VARCHAR2(100));
/

--Creamos la tabla de colas con nombre orders_msg_qt, el cual cargara el objeto orders_message_type
BEGIN
 DBMS_AQADM.CREATE_QUEUE_TABLE (queue_table =>        'orders_msg_qt',
                                queue_payload_type => 'orders_message_type',
                                multiple_consumers => TRUE);
END;
/

--creamos la cola con nombre orders_msg_queue, que contendrá la tabla de cola
--definimos que el tipo de cola será normal, sin intentos máximos
--sin reintentos de retardo, con retención de tiempo de 1209600
--sin seguimiento de dependencia
--comentario prueba de objeto tipo cola, sin auto commit
BEGIN
 DBMS_AQADM.CREATE_QUEUE (queue_name =>     'orders_msg_queue',
                          queue_table =>    'orders_msg_qt',
                          queue_type =>     DBMS_AQADM.NORMAL_QUEUE,
                          max_retries =>    0,
                          retry_delay =>    0,
                          retention_time => 1209600,
                          dependency_tracking => FALSE,
                          comment =>        'Test Object Type Queue',
                          auto_commit =>    FALSE);
END;
/

--Corremos la pila que creamos
BEGIN
 DBMS_AQADM.START_QUEUE('orders_msg_queue');
END;
/

-- need administrator privileges to add
-- subscriber
-- realizamos las subscripciones en caso que la region del pedido sea US_ORDERS
-- Agregamos la susbscripcion a la cola
BEGIN
  DBMS_AQADM.ADD_SUBSCRIBER(
    Queue_name => 'orders_msg_queue',
    Subscriber => sys.aq$_agent('US_ORDERS', null, null),
    Rule       => 'tab.user_data.region_code = ''USA''');
END;
/

--La función convierte los dolares a euro, y el orden lo almacenamos en nuestro objeto
CREATE OR REPLACE FUNCTION fn_Dollars_to_Euro(src IN orders_message_type)
RETURN orders_message_type
AS
  Target orders_message_type;
BEGIN
  Target :=
    aq_admin.orders_message_type(
      src.order_id,
      src.product_code, src.customer_id,
      src.order_details, src.price*.5,
      src.region_code);
  RETURN Target;
END fn_Dollars_to_Euro;
/

--creamos la transformación de dolar a euro con el nombre DOLLAR_TO_EURO
--el cual usara la funcion FN_DOLLARS_TO_EURO para hacer la converción y asignación al objeto
BEGIN
  DBMS_TRANSFORM.CREATE_TRANSFORMATION(
    schema =>      'AQ_ADMIN',
    name =>        'DOLLAR_TO_EURO',
    from_schema => 'AQ_ADMIN',
    from_type =>   'ORDERS_MESSAGE_TYPE',
    to_schema =>   'AQ_ADMIN',
    to_type =>     'ORDERS_MESSAGE_TYPE',
    transformation => 'AQ_ADMIN.FN_DOLLARS_TO_EURO(SOURCE.USER_DATA)');
END;
/

--realizamos las subscripciones en caso que la region del pedido sea EUROPE_ORDERS
--ejecutamos la transformación Agregamos la susbscripcion a la cola
BEGIN
  DBMS_AQADM.ADD_SUBSCRIBER(
    Queue_name => 'orders_msg_queue',
    Subscriber => sys.aq$_agent('EUROPE_ORDERS', null, null),
    Rule       => 'tab.user_data.region_code = ''EUROPE''',
    Transformation =>  'DOLLAR_TO_EURO');
END;
/

------------------------
--
-- Connect as "SYS"
--
------------------------

DROP USER aq_user CASCADE;
--
--create aq_user user account
CREATE USER aq_user IDENTIFIED BY aq_user DEFAULT
TABLESPACE users
TEMPORARY TABLESPACE temp;

--grant roles to aq_user
GRANT aq_user_role TO aq_user;
GRANT connect TO aq_user;

--permitimos que el usuario normal pueda ejecutar el objeto desde el XE
--grant EXECUTE on message_type to aq_user
GRANT EXECUTE ON aq_admin.orders_message_type TO aq_user;

------------------------
--
-- Connect as "aq_admin"
--
------------------------
--permitimos que el usuario normal pueda ejecutar el objeto desde el adminitrador de la base de datos
--grant EXECUTE on message_type to aq_user
GRANT EXECUTE ON aq_admin.orders_message_type TO aq_user;

--Le permitimos a nuestro usuario poder tener privilegios de toda la cola
BEGIN
 DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
   privilege => 'ALL',
   queue_name => 'aq_admin.orders_msg_queue',
   grantee => 'aq_user',
   grant_option => FALSE);
END;
/

--permitimos que el usuario pueda ejecutar el objeto
--permitimos que el usuario pueda ejecutar la funcion de conversión dolar a euro
GRANT EXECUTE ON orders_message_type TO aq_user;
GRANT EXECUTE ON fn_Dollars_to_Euro TO aq_user;

------------------------
--
-- Connect as "aq_user"
--
------------------------

DECLARE
  enqueue_options    dbms_aq.enqueue_options_t;-- inicializamos la opciones de encolamiento
  message_properties dbms_aq.message_properties_t;--inicializamos las propiedades de mensaje
  message_handle     RAW(16);--el manejador de los mensajes decimos que sea de 16
  message            aq_admin.orders_message_type; -- inicializamos el objeto
  message_id NUMBER; 
  lista              dbms_aq.AQ$_RECIPIENT_LIST_T; --creamos una lista que contendra nuestro pedido
BEGIN
  message := aq_admin.orders_message_type (1,       -- order id
                                           '325',   -- customer_id
                                           '49',    -- product_code
                                           'Details: Digital Camera. Brand: ABC. Model: XYX' ,
                                           50.2,    -- price
                                           'USA' -- Region
                                          );
  -- default for enqueue options VISIBILITY is 
  -- ON_COMMIT. message has no delay and no -- expiration
  lista(1) := sys.aq$_agent('EUROPE_ORDERS', null, null);
  lista(2) := sys.aq$_agent('US_ORDERS', null, null);
  
  message_properties.CORRELATION    := message.order_id; --pasamos el orden del pedido 
  message_properties.RECIPIENT_LIST := lista; --pasamos la lista
  
  --ponemos en la cola, mandamos la opcion de encolamiento, mandamos las propiedades del mensaje,
  --mandamos el pedido, y por último el manejador del mensaje

  DBMS_AQ.ENQUEUE (queue_name =>         'aq_admin.orders_msg_queue', 
                   enqueue_options =>    enqueue_options,
                   message_properties => message_properties,
                   payload =>            message,
                   msgid =>              message_handle);
  COMMIT; 
END;
/

----------------
--
-- AS aq_admin
--
----------------
--Visualizamos la cola de usuarios
SELECT
    *
FROM
    user_queues
;
--Visualizamos la tabla de colas de usuario
SELECT
  *
FROM
  user_queue_tables
;
--Visualizamos la cola de pedidos
SELECT
    *
FROM
    orders_msg_qt
;

------------------------
--
-- Connect as "aq_user" but in a new different session
--
------------------------

-----------------------------------
SET SERVEROUTPUT ON
-----------------------------------

DECLARE
  dequeue_options    dbms_aq.dequeue_options_t; --Inicializamos las opciones de desencolar
  message_properties dbms_aq.message_properties_t;--Inicializamos la propiedades del mensaje
  message_handle     RAW(16); 
  message            aq_admin.orders_message_type; --inicializamos el objeto
BEGIN
  -- defaults for dequeue_options
  -- Dequeue for the Europe_Orders subscriber
  -- Transformation Dollar_to_Euro is
  -- automatically applied
  dequeue_options.navigation := DBMS_AQ.FIRST_MESSAGE;
  dequeue_options.consumer_name :='US_ORDERS'; --decimos que el pedido se realiza en estados unidos
  -- set immediate visibility
  dequeue_options.VISIBILITY    :=  DBMS_AQ.IMMEDIATE; --se ejecute inmediatamente
  dequeue_options.WAIT          :=  15; --espere 15 segundos para desencolar
  
  --desencolamos el pedido
  DBMS_AQ.DEQUEUE (
    queue_name =>         'aq_admin.orders_msg_queue',
    dequeue_options =>    dequeue_options,
    message_properties => message_properties,
    payload =>            message,
    msgid =>              message_handle);
    
  --mostramos los datos del pedido que desencolamos
  dbms_output.put_line('+---------------+');
  dbms_output.put_line('| MESSAGE PAYLOAD |');
  dbms_output.put_line('+---------------+');
  dbms_output.put_line('- Order ID := ' ||  message.order_id);
  dbms_output.put_line('- Customer ID:= ' ||  message.customer_id);
  dbms_output.put_line('- Product Code:= ' || message.product_code);
  dbms_output.put_line('- Order Details := ' || message.order_details);
  dbms_output.put_line('- Price in Dollars := ' || message.price); 
  dbms_output.put_line('- Region := ' || message.region_code);
  COMMIT;
END;
/
