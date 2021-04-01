--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 06/03/2021
--
-- ----------------------------------------------------------

--
--CREACIÓN DE LAS TABLAS
--
CREATE TABLE usuario
			(id 		VARCHAR2(45),
			 updated_at DATE,
			 created_at DATE,
			 email 		VARCHAR2(60),
			 password 	VARCHAR2(45),
			 first_name VARCHAR2(40),
			 last_name 	VARCHAR2(40)
				);

CREATE TABLE state
			(id 		VARCHAR2(45),
			 updated_at DATE,
			 created_at DATE,
			 name 		VARCHAR2(40)
				);

CREATE TABLE city
			(id 		VARCHAR2(45),
			 updated_at DATE,
			 created_at DATE,
			 state_id	VARCHAR2(45),
			 name 		VARCHAR2(40)
				);			

CREATE TABLE amenity
			(id 		VARCHAR2(45),
			 updated_at DATE,
			 created_at DATE,
			 name 		VARCHAR2(40)
				);

CREATE TABLE place
			(id 				VARCHAR2(45),
			 updated_at 		DATE,
			 created_at 		DATE,
			 user_id			VARCHAR2(45),
			 name 				VARCHAR2(40),
			 city_id			VARCHAR2(45),
			 description		LONG,
			 number_rooms		NUMBER(3),
			 number_bathrooms	NUMBER(3),
			 max_guest			NUMBER(3),
			 price_by_night		NUMBER(8),
			 latitud			NUMBER(13,2),
			 longitude			NUMBER(13,2)
				);

CREATE TABLE review
			(id 				VARCHAR2(45),
			 updated_at 		DATE,
			 created_at 		DATE,
			 user_id			VARCHAR2(45),
			 place_id			VARCHAR2(45),
			 text				LONG
				);

CREATE TABLE placeamenity
			(amenity_id		VARCHAR2(45),
			 place_id		VARCHAR2(45)
			 	);

--
-- ALTERACIÓN PARA DAR NOT NULL
--
ALTER TABLE usuario MODIFY id 						NOT NULL;
ALTER TABLE usuario MODIFY updated_at 				NOT NULL;
ALTER TABLE usuario MODIFY created_at 				NOT NULL;
ALTER TABLE usuario MODIFY email 					NOT NULL;
ALTER TABLE usuario MODIFY password					NOT NULL;

ALTER TABLE state MODIFY id 						NOT NULL;
ALTER TABLE state MODIFY updated_at 				NOT NULL;
ALTER TABLE state MODIFY created_at 				NOT NULL;
ALTER TABLE state MODIFY name 						NOT NULL;

ALTER TABLE city MODIFY id 							NOT NULL;
ALTER TABLE city MODIFY updated_at 					NOT NULL;
ALTER TABLE city MODIFY created_at 					NOT NULL;
ALTER TABLE city MODIFY state_id 					NOT NULL;
ALTER TABLE city MODIFY name 						NOT NULL;

ALTER TABLE amenity MODIFY id 						NOT NULL;
ALTER TABLE amenity MODIFY updated_at 				NOT NULL;
ALTER TABLE amenity MODIFY created_at 				NOT NULL;
ALTER TABLE amenity MODIFY name						NOT NULL;

ALTER TABLE place MODIFY id 						NOT NULL;
ALTER TABLE place MODIFY updated_at 				NOT NULL;
ALTER TABLE place MODIFY created_at 				NOT NULL;
ALTER TABLE place MODIFY user_id 					NOT NULL;
ALTER TABLE place MODIFY name						NOT NULL;
ALTER TABLE place MODIFY city_id					NOT NULL;
ALTER TABLE place MODIFY description 				NOT NULL;
ALTER TABLE place MODIFY number_rooms 				NOT NULL;
ALTER TABLE place MODIFY number_bathrooms 			NOT NULL;
ALTER TABLE place MODIFY max_guest					NOT NULL;
ALTER TABLE place MODIFY price_by_night				NOT NULL;

ALTER TABLE review MODIFY id 						NOT NULL;
ALTER TABLE review MODIFY updated_at 				NOT NULL;
ALTER TABLE review MODIFY created_at 				NOT NULL;
ALTER TABLE review MODIFY user_id 					NOT NULL;
ALTER TABLE review MODIFY place_id					NOT NULL;
ALTER TABLE review MODIFY text						NOT NULL;

ALTER TABLE placeamenity MODIFY amenity_id 			NOT NULL;
ALTER TABLE placeamenity MODIFY place_id			NOT NULL;

--
-- ASIGNAMOS LOS DEFAULTAS A LA TABLA PLACE
--

ALTER TABLE place MODIFY number_rooms 				DEFAULT 0;
ALTER TABLE place MODIFY number_bathrooms 			DEFAULT 0;
ALTER TABLE place MODIFY max_guest 					DEFAULT 0;
ALTER TABLE place MODIFY price_by_night 			DEFAULT 0;

--
-- VALIDACIONES CON CHECK
--

ALTER TABLE place ADD CONSTRAINT validar_nrooms 	CHECK 	  (number_rooms >= 0);
ALTER TABLE place ADD CONSTRAINT validar_nbathrooms CHECK (number_bathrooms >= 0);
ALTER TABLE place ADD CONSTRAINT validar_maxguest 	CHECK 		 (max_guest >= 0);
ALTER TABLE place ADD CONSTRAINT validar_price 		CHECK 	(price_by_night >= 0);

--
-- CREACIÓN DE LLAVES PRIMARIAS
--

ALTER TABLE usuario ADD CONSTRAINT PK_id 			PRIMARY KEY (id);
ALTER TABLE state ADD 	CONSTRAINT PK_idstate 		PRIMARY KEY (id);
ALTER TABLE city ADD 	CONSTRAINT PK_idcity 		PRIMARY KEY (id);
ALTER TABLE amenity ADD CONSTRAINT PK_idamenity 	PRIMARY KEY (id);
ALTER TABLE place ADD 	CONSTRAINT PK_idplace 		PRIMARY KEY (id);
ALTER TABLE review ADD 	CONSTRAINT PK_idreview 		PRIMARY KEY (id);

--
-- CREACIÓN DE LLAVES FORANEAS
--

ALTER TABLE city 		 ADD 	CONSTRAINT FK_state_id 		FOREIGN KEY(state_id) 	REFERENCES 	 state(id);
ALTER TABLE place 		 ADD 	CONSTRAINT FK_user_id 		FOREIGN KEY(user_id) 	REFERENCES usuario(id);
ALTER TABLE place 		 ADD 	CONSTRAINT FK_city_id 		FOREIGN KEY(city_id) 	REFERENCES 	  city(id);
ALTER TABLE review 		 ADD 	CONSTRAINT FK_user_id 		FOREIGN KEY(user_id) 	REFERENCES usuario(id);
ALTER TABLE review		 ADD 	CONSTRAINT FK_place_id 		FOREIGN KEY(place_id) 	REFERENCES 	 place(id);
ALTER TABLE placeamenity ADD 	CONSTRAINT FK_amenity_id 	FOREIGN KEY(amenity_id) REFERENCES amenity(id);
ALTER TABLE placeamenity ADD 	CONSTRAINT FK_place_idam 	FOREIGN KEY(place_id) 	REFERENCES   place(id);