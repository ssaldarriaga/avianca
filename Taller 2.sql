/* Punto 1 */
CREATE OR REPLACE VIEW Aviones_Disponibles AS 
    SELECT
        A.*,
        VR.ID ID_VUELO_FILTRO
    FROM
        VUELOS V
            INNER JOIN
        RUTAS R ON (V.ID_RUTA = R.ID)
            INNER JOIN
        (SELECT 
            V.ID,
            R.ID_AEROPUERTO_DESTINO,
            TO_DATE(TO_CHAR(V.HORA_ESTIMADA_LLEGADA - 2/24,'hh24miss'),'hh24miss') HORA_LLEGADA
        FROM 
            VUELOS V
                INNER JOIN
            RUTAS R ON (V.ID_RUTA = R.ID)
        WHERE
            V.ESTADO = 'Confirmado') VR ON (TO_DATE(TO_CHAR(V.HORA_ESTIMADA_SALIDA,'hh24miss'),'hh24miss') <= VR.HORA_LLEGADA AND R.ID_AEROPUERTO_ORIGEN = VR.ID_AEROPUERTO_DESTINO)
            INNER JOIN
        AVIONES A ON (V.ID_AVION_ASIGNADO = A.ID);
    
SELECT * FROM Aviones_Disponibles WHERE ID_VUELO_FILTRO = 2 AND ROWNUM < 2;

/* Punto 2 */
CREATE OR REPLACE PROCEDURE Asignar_tripulacion(id_vuelo IN INTEGER) AS
    AVION INTEGER;
    CAPACIDAD INTEGER;
    DURACION INTEGER;
    PILOTO INTEGER;
    COPILOTO INTEGER;
    NUMERO_AUXILIARES INTEGER;
    ID_CIUDAD INTEGER;
BEGIN
    /* Se consulta el id del avion y la capacidad del mismo */
    SELECT 
        ID, CAPACIDAD INTO AVION, CAPACIDAD 
    FROM 
        Aviones_Disponibles 
    WHERE 
        ID_VUELO_FILTRO = id_vuelo AND ROWNUM <= 1;   
    /* Se consulta el piloto */
    SELECT 
        P.ID INTO PILOTO 
    FROM 
        PILOTOS P 
            INNER JOIN 
        EMPLEADOS E ON (P.ID_EMPLEADO = E.ID AND E.ESTADO = 'ACTIVO' AND E.HORAS_DESCANSO >= 2) 
    WHERE 
        P.ID NOT IN (SELECT ID_PILOTO FROM VUELOS)
        AND
        P.ID NOT IN (SELECT ID_COPILOTO FROM VUELOS)
        AND
        ROWNUM <= 1;
        
    /* Se consulta el copiloto */
    SELECT 
        P.ID INTO COPILOTO 
    FROM 
        PILOTOS P 
            INNER JOIN 
        EMPLEADOS E ON (P.ID_EMPLEADO = E.ID AND E.ESTADO = 'ACTIVO' AND E.HORAS_DESCANSO >= 2) 
    WHERE 
        P.ID <> PILOTO AND ROWNUM <= 1
        AND
        P.ID NOT IN (SELECT ID_COPILOTO FROM VUELOS)
        AND
        P.ID NOT IN (SELECT PILOTO FROM VUELOS);    
    /* SE ASIGNA EL PILOTO Y COPILOTO */

    UPDATE VUELOS SET ID_PILOTO = PILOTO, ID_COPILOTO = COPILOTO WHERE ID = id_vuelo;
    /* Se define la cantidad de auxiliares */
    IF CAPACIDAD BETWEEN 20 AND 49 THEN
       NUMERO_AUXILIARES := 1;
    ELSIF CAPACIDAD BETWEEN 50 AND 99 THEN
        NUMERO_AUXILIARES := 2; 
    ELSE
        NUMERO_AUXILIARES := ROUND(CAPACIDAD / 50);
    END IF;    
    /* Se consulta la duracion real del vuelo */
    SELECT 
        DURACIONREAL INTO DURACION 
    FROM 
        VUELOS 
    WHERE ID = id_vuelo;
    IF DURACION > 6 THEN
        NUMERO_AUXILIARES := NUMERO_AUXILIARES + 1;
    END IF;
    /* SE BUSCA LA CIUDAD DE ORIGEN DEL VUELO */
    SELECT 
        A.ID_CIUDAD INTO ID_CIUDAD
    FROM 
        VUELOS V
            INNER JOIN
        RUTAS R ON (V.ID_RUTA = R.ID AND V.ID = id_vuelo)
            INNER JOIN
        AEROPUERTOS A ON (R.ID_AEROPUERTO_ORIGEN = A.ID); 
        
    /* SE INSERTAN LOS AUXILIARES */
    INSERT INTO AUXILIARES_VUELO (ID_EMPLEADO, ID_VUELO)
    SELECT 
        ID, id_vuelo VUELO
    FROM 
        EMPLEADOS E
    WHERE
        ID NOT IN (SELECT ID_EMPLEADO FROM PILOTOS)
        AND ESTADO = 'ACTIVO'
        AND E.HORAS_DESCANSO >= 2
        AND UBICACION_ACTUAL = ID_CIUDAD
        AND ROWNUM <= NUMERO_AUXILIARES;
END;