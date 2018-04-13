/*6. Create 4 users, assign them the tablespace " avianca "; 2 of them should have the clerk profile and the
remaining the development profile, all the users should be allow to connect to the database*/

CREATE USER CLERKUSER1
IDENTIFIED BY out_standing1
DEFAULT TABLESPACE avianca
PROFILE CLERKPROFILE;
	
CREATE USER CLERKUSER2
IDENTIFIED BY out_standing1
DEFAULT TABLESPACE avianca
PROFILE CLERKPROFILE;

CREATE USER DEVELUSER1
IDENTIFIED BY out_standing1
DEFAULT TABLESPACE avianca
PROFILE DEVELPROFILE;
	
CREATE USER DEVELUSER2
IDENTIFIED BY out_standing1
DEFAULT TABLESPACE avianca
PROFILE DEVELPROFILE;

GRANT CREATE SESSION TO clerk1;
GRANT CREATE SESSION TO clerk2;
GRANT CREATE SESSION TO development1;
GRANT CREATE SESSION TO development2;

/*7. Lock one user associate with clerk profile*/

ALTER USER clerk1 ACCOUNT LOCK;

/*8. Create tables with its columns according to your normalization*/

CREATE TABLE 
    Aviones (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        Tipo VARCHAR2(255),
        Matricula VARCHAR2(255),
        Serial VARCHAR2(255),
        Edad VARCHAR2(255));
		
CREATE TABLE 
    Empleados (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Nombres VARCHAR2(255),
        Apellidos VARCHAR2(255),
        Sexo VARCHAR2(50),
        F_Nacimiento DATE,
        Antiguedad_Anos NUMBER(5,2),
        F_Ultimo_Entrenamiento DATE,
        Direccion VARCHAR2(255),
        Correo VARCHAR2(255),
        Celular VARCHAR2(255),
        Horas_Descanso NUMBER (5,2),
        Estado VARCHAR2(50),
        Ubicacion_Actual VARCHAR2(255));
        
CREATE TABLE 
    Pilotos (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_Empleado INTEGER,
        Nivel_Ingles VARCHAR2(50),
        Horas_vuelo INTERVAL DAY (0) TO SECOND(0),
        Tipo_Licencia VARCHAR2(5),
        Cargo VARCHAR2(50)
		CONSTRAINT check_Nivel_Ingles
		CHECK (Nivel_Ingles IN('Nivel 1 Pre-elementary','Nivel 2 Elementary','Nivel 3 Pre-Operational','Nivel 4 Operational','Nivel 5 Extended','Nivel 6 Expert'))
		CONSTRAINT check_Tipo_Licencia
		CHECK (Tipo_Licencia IN('CPL','CPL IFR','CPL ME','ATPL'))
		);
        
CREATE TABLE 
    Aeropuertos (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_Ciudad INTEGER,
        Nombre VARCHAR2(255),
        Abreviatura VARCHAR2(10),
        Latitud NUMBER(15,10),
        Longitud NUMBER(15,10));
        
CREATE TABLE 
    Ciudades (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Nombre VARCHAR2(255),
        Pais VARCHAR2(255));
        
CREATE TABLE 
    Log (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        timestamp TIMESTAMP,
        Hora_UTC INTERVAL DAY (0) TO SECOND(0),
        Latitud NUMBER(15,10),
        Longitud NUMBER(15,10),
        Altitud NUMBER(10,2),
        Velocidad NUMBER(10,2),
        Direccion NUMBER(10,2),
        I_Vuelo INTEGER);
        
CREATE TABLE 
    Check_In (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_Vuelo INTEGER,
        Nombres VARCHAR2(255),
        APellidos VARCHAR2(255),
        Documento VARCHAR2(20),
        Tipo_Documento VARCHAR2(50),
        Codigo_Confirmacion_Checkin VARCHAR2(50),
        Nombre_Contacto VARCHAR2(255),
        Id_Ciudad_Contacto INTEGER,
        Correo_Contacto VARCHAR2(255),
        Telefono_Contacto VARCHAR2(255)
		CONSTRAINT check_Tipo_Documento
		CHECK (Tipo_Documento IN('Cédula','Pasaporte','DNI','Cédula Extranjería'))
		);
        
CREATE TABLE 
    Rutas (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_Aeropuerto_Origen INTEGER,
        Id_Aeropuerto_Destino INTEGER,
        Distancia NUMBER(10,2),
        Frecuencia_Semanal INTEGER,
        Id_Avion_Requerido INTEGER,
        Promedio_Horas NUMBER(10,2),
        Cantidad_Tripulantes INTEGER,
        Nombre_Ruta VARCHAR2(255)
		CONSTRAINT check_Frecuencia_Semanal
		CHECK (Frecuencia_Semanal IN(8,2))
		);
        
CREATE TABLE 
    Vuelos (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_Piloto INTEGER,
        Id_Copiloto INTEGER,
        Hora_Estimada_Salida INTERVAL DAY (0) TO SECOND(0),
        Hora_Estimada_Llegada INTERVAL DAY (0) TO SECOND(0),
        Hora_Real_Salida INTERVAL DAY (0) TO SECOND(0),
        Hora_Real_Llegada INTERVAL DAY (0) TO SECOND(0),
        DuracionReal NUMERIC(10,3),
        Id_Avion_Asignado INTEGER,
        Cantidad_Pasajeros INTEGER,
        Id_Ruta INTEGER,
        Numero_Vuelo VARCHAR2(50));
        
CREATE TABLE 
    Auxiliares_Vuelo (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_Empleado INTEGER,
        Id_Itinerario INTEGER);
        
CREATE TABLE 
    Itinerarios (
        Id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,        
        Id_ruta INTEGER,
        Fecha DATE,
        Hora INTERVAL DAY (0) TO SECOND(0));
        

alter table "avianca"."Auxiliares_Vuelo" add constraint FK_AUXILIARES_VUELO_EMPLEADOS foreign key("Id_Empleado") references "Empleados"("ID");
alter table "avianca"."Auxiliares_Vuelo" add constraint FK_AUXILIARES_VUELO_ITINERARIO foreign key("Id_Itinerario") references "Itinerarios"("ID");
alter table "avianca"."Aeropuertos" add constraint FK_AEROPUETO_CIUDAD foreign key("Id_Ciudad") references "Ciudades"("ID");
alter table "avianca"."Itinerarios" add constraint FK_ITINERARIO_RUTA foreign key("Id_ruta") references "Rutas"("ID");
alter table "avianca"."Rutas" add constraint FK_RUTA_AEROPUERTO_ORIGEN foreign key("Id_Aeropuerto_Origen") references "Aeropuertos"("ID");
alter table "avianca"."Rutas" add constraint FK_RUTA_AEROPUERTO_DESTINO foreign key("Id_Aeropuerto_Destino") references "Aeropuertos"("ID");
alter table "avianca"."Rutas" add constraint FK_RUTA_AVION foreign key("Id_Avion_Requerido") references "Aviones"("ID");
alter table "avianca"."Check_In" add constraint FK_CHECK_IN_VUELO foreign key("Id_Vuelo") references "Vuelos"("ID");
alter table "avianca"."Check_In" add constraint FK_CHECK_IN_CIUDAD foreign key("Id_Ciudad_Contacto") references "Ciudades"("ID");
alter table "avianca"."Log" add constraint FK_LOG_VUELOS foreign key("Id_Vuelo") references "Vuelos"("ID");
alter table "avianca"."Pilotos" add constraint FK_PILOTOS_EMPLEADOS foreign key("Id_Empleado") references "Empleados"("ID");
alter table "avianca"."Vuelos" add constraint FK_VUELO_PILOTO foreign key("Id_Piloto") references "Pilotos"("ID");
alter table "avianca"."Vuelos" add constraint FK_VUELO_COPILOTO foreign key("Id_Copiloto") references "Pilotos"("ID");
alter table "avianca"."Vuelos" add constraint FK_VUELO_AVION foreign key("Id_Avion_Asignado") references "Aviones"("ID");
alter table "avianca"."Vuelos" add constraint FK_VUELO_RUTA foreign key("Id_Ruta") references "Rutas"("ID");


INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','N764AV','7887','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','N765AV','7928','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','N766AV','8096','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBD','7175','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBF','7323','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBH','7484','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBI','7514','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBJ','7698','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBK','7799','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBL','7854','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBM','7856','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-251N','PR-OBO','7995','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-253N','N759AV','7770','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-253N','N761AV','7847','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N589AV','2575','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N590EL','2328','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N591EL','2333','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N592EL','2358','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N593EL','2367','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N594EL','2377','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N595EL','2394','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N596EL','2523','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N597EL','2544','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-111','N598EL','2552','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-AVJ','3030','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-AVL','3214','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-ONC','3371','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-OND','3390','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-ONI','3509','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-ONO','3602','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A318-122','PR-ONR','3642','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-112','HC-CKN','1882','15 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-112','HC-CLF','2078','14 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','HC-CSA','3518','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','HC-CSB','3467','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N422AV','4200','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N478TA','2339','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N479TA','2444','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N480TA','3057','11 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N519AV','5119','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N520TA','3248','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N521TA','3276','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N522TA','5219','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-112','N524TA','5280','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N557AV','5057','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N647AV','3647','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N690AV','5944','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N691AV','3691','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N694AV','6068','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N695AV','6099','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N703AV','5406','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N723AV','6167','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N726AV','6174','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-132','N730AV','6132','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N741AV','6617','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N751AV','7284','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','N753AV','7318','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','PR-AVB','4222','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','PR-AVC','4287','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','PR-AVD','4336','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A319-115','PR-ONJ','5193','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','HC-CJM','4379','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','HC-CJV','4547','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','HC-CJW','4487','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','HC-CRU','3408','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','HC-CSF','4100','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','HC-CTR','4599','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N195AV','5195','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N281AV','4281','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N284AV','4284','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N345AV','4345','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N398AV','3988','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N401AV','4001','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N411AV','4011','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N416AV','4167','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N426AV','4026','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N446AV','4046','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N451AV','4051','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N454AV','5454','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N477AV','5477','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N481AV','4381','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N490TA','2282','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N491TA','2301','13 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N492TA','2434','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N493TA','2917','11 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N494TA','3042','11 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N495TA','3103','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N496TA','3113','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N497TA','3378','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N498TA','3418','10 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N499TA','3510','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N536AV','5360','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N538AV','5398','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N562AV','5622','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N567AV','4567','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N603AV','5840','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N632AV','5632','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N664AV','3664','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N680TA','3538','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N683TA','4906','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N684TA','4944','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N685TA','5068','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N686TA','5238','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-233','N687TA','1334','17 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N688TA','5243','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N689TA','5333','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N724AV','6153','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N728AV','6209','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N740AV','6411','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N742AV','6692','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N743AV','6739','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N745AV','6746','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N748AV','6862','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N750AV','7120','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N755AV','7437','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N763AV','4763','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N789AV','4789','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N821AV','4821','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N862AV','4862','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N939AV','4939','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N961AV','3961','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N980AV','3980','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','N992AV','3992','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-AVP','4891','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-AVQ','4913','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-AVR','4941','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-AVU','4942','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OBB','6876','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCA','6125','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCB','6139','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCD','6173','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCH','6528','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCI','6536','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCM','6561','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCN','6598','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCO','6634','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCP','6651','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCQ','6689','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCR','145016','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCT','6800','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCV','6806','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCW','6813','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-OCY','6871','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONK','5278','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONL','5299','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONS','5754','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONT','5841','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONW','6050','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONX','6057','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONY','6103','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A320-214','PR-ONZ','6110','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N568TA','2687','12 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N570TA','3869','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N692AV','5936','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N693AV','6002','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N696AV','6128','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N697AV','6190','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N725AV','6219','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N729AV','6399','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-211','N744AV','6767','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-211','N746AV','6511','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N747AV','6861','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N805AV','6009','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A321-231','N810AV','6294','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N279AV','1279','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N280AV','1400','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N342AV','1342','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N968AV','1009','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N969AV','1016','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N973AV','1073','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N974AV','1208','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','N975AV','1224','6 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','PR-OCG','1608','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','PR-OCJ','1492','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','PR-OCK','1508','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-243','PR-OCX','1657','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-343','N803AV','1357','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Airbus A330-343','N804AV','1378','5 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-4954','1092','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-4955','1114','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-4956-X','1116','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-4999','1126','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-5000','1142','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-5039','1124','4 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-5040','1151','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-5041','1160','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HK-5109-X','1231','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HR-AYJ','1172','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','HR-AYM','1185','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','LV-GUG','1343','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','LV-GUH','1395','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','LV-GUI','1425','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','TG-TRC','1167','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','TG-TRD','1174','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','TG-TRE','1196','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('ATR 72-600','TG-TRF','1199','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N780AV','37502','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N781AV','37503','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N782AV','37504','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N783AV','37505','3 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N784AV','37506','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N785AV','37507','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N786AV','37508','2 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N791AV','37509','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N792AV','37510','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N793AV','37511','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N794AV','39406','1 year')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Boeing 787-8 Dreamliner','N795AV','39407','Brand new')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N935TA','19000205','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N936TA','19000215','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N937TA','19000221','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N938TA','19000228','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N982TA','19000259','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N983TA','19000265','9 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N987TA','19000393','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N988TA','19000399','8 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','N989TA','19000482','7 years')
INSERT INTO Aviones(Tipo,Matricula,Serial,Edad) VALUES('Embraer ERJ-190AR','TI-BCG','19000215','10 years')
