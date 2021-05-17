--
-- 
--JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*Auditoria de cambio de sueldos*/
CREATE OR REPLACE TRIGGER audit_emp_01
  AFTER DELETE OR UPDATE
  ON emp
  FOR EACH ROW
DECLARE
  tipo VARCHAR2(1);
BEGIN
  IF DELETING = TRUE THEN
    tipo := 'D';
  ELSE
    tipo := 'U';
  END IF;

  INSERT INTO auditemp(changed_type, changed_by, datestamp, empno, oldsal, oldcomm, newsal, newcomm)
         VALUES  (tipo, USER, SYSDATE, :NEW.empno, :OLD.sal, :OLD.comm, :NEW.sal, :NEW.comm);
END audit_emp_01;