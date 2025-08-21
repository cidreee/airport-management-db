-- Vistas -----------------------------------------------------

# Vuelos del dia
CREATE VIEW vista_vuelos_del_dia AS
SELECT 
	v.vuelo_id,
    a.nombre AS nombrea_aerolinea,
    r.aeropuerto_origen,
    r.aeropuerto_destino,
    TIME(v.fecha_salida) AS hora_salida,
    TIME(v.fecha_llegada_estimada) AS hora_llegada,
    v.puerta_embarque, 
    v.estado
FROM vuelos v
JOIN aerolineas a using(aerolinea_id)
JOIN rutas r USING(ruta_id)
WHERE DATE(v.fecha_salida) = CURDATE()
	AND v.estado IN ('programado', 'retrasado');

# Pasajeros frecuentes
CREATE VIEW vista_pasajeros_frecuentes AS
SELECT 
	p.pasajero_id,
    p.nombre,
    p.nacionalidad,
    p.email,
    p.programa_fidelidad,
    COUNT(r.reservacion_id) AS total_vuelos_este_año
FROM reservaciones r
JOIN pasajeros p USING(pasajero_id)
JOIN vuelos v USING(vuelo_id)
WHERE r.estado = 'utilizada'
  AND v.fecha_salida >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.pasajero_id
HAVING total_vuelos_este_año > 10;
    
# Aeronaves en mantenimiento
CREATE VIEW vista_aeronaves_en_mantenimiento AS
SELECT 
    ma.aeronave_id,
    a.modelo,
    ma.fecha_inicio,
    ma.fecha_estimada_retorno,
    ma.descripcion
FROM mantenimiento_aeronaves ma
JOIN aeronaves a USING (aeronave_id)
WHERE ma.estado = 'En mantenimiento';

-- stored procedures ------------------------------------------------------------------------

# Asignar tripulacion
DELIMITER //

CREATE PROCEDURE asignar_tripulacion(IN fecha_vuelo DATE, IN ruta INT)
BEGIN
  DECLARE vuelo_id_sel INT;

  SELECT vuelo_id INTO vuelo_id_sel
  FROM vuelos
  WHERE ruta_id = ruta AND DATE(fecha_salida) = fecha_vuelo
  LIMIT 1;

  INSERT INTO tripulacion_vuelo (vuelo_id, empleado_id, rol)
  SELECT vuelo_id_sel, empleado_id, 'Piloto principal'
  FROM tripulacion
  WHERE puesto = 'piloto' AND horas_de_vuelo < 100
  ORDER BY horas_de_vuelo ASC
  LIMIT 1;

  INSERT INTO tripulacion_vuelo (vuelo_id, empleado_id, rol)
  SELECT vuelo_id_sel, empleado_id, 'Azafata'
  FROM tripulacion
  WHERE puesto = 'azafata' AND horas_de_vuelo < 100
  ORDER BY horas_de_vuelo ASC
  LIMIT 3;
END //

DELIMITER ;

# Check in automatico
DELIMITER //

CREATE PROCEDURE check_in_automatico(IN vuelo_id_in INT)
BEGIN
  DECLARE fin INT DEFAULT 0;
  DECLARE res_id INT;
  DECLARE clase_reserva VARCHAR(20);
  DECLARE asiento_nuevo VARCHAR(5);
  DECLARE usados TEXT DEFAULT '';
  DECLARE cur CURSOR FOR 
    SELECT reservacion_id, clase FROM reservaciones 
    WHERE vuelo_id = vuelo_id_in AND estado != 'confirmada';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

  OPEN cur;
  loop_reservas: LOOP
    FETCH cur INTO res_id, clase_reserva;
    IF fin = 1 THEN
      LEAVE loop_reservas;
    END IF;

    -- Asiento aleatorio con letra aleatoria A-F y número 1–30
    SET asiento_nuevo = CONCAT(FLOOR(1 + (RAND() * 30)), CHAR(65 + FLOOR(RAND() * 6)));

    WHILE usados LIKE CONCAT('%,', asiento_nuevo, ',%') DO
      SET asiento_nuevo = CONCAT(FLOOR(1 + (RAND() * 30)), CHAR(65 + FLOOR(RAND() * 6)));
    END WHILE;

    SET usados = CONCAT(usados, ',', asiento_nuevo, ',');

    -- Actualiza la reservación
    UPDATE reservaciones
    SET estado = 'confirmada', asiento = asiento_nuevo
    WHERE reservacion_id = res_id;
  END LOOP;
  CLOSE cur;
END //

DELIMITER ;

-- CALL check_in_automatico(1);

-- SELECT * 
-- FROM reservaciones 
-- WHERE vuelo_id = 1;

# Estadisticas de puntualidaidad
DELIMITER //

CREATE PROCEDURE estadisticas_puntualidad(IN mes INT, IN anio INT)
BEGIN
  SELECT 
    a.nombre AS aerolinea,
    COUNT(*) AS total_vuelos,
    SUM(CASE WHEN v.estado = 'retrasado' THEN 1 ELSE 0 END) AS vuelos_retrasados,
    SUM(CASE WHEN v.estado = 'programado' OR v.estado = 'en vuelo' OR v.estado = 'aterrizado' THEN 1 ELSE 0 END) AS vuelos_a_tiempo,
    ROUND(SUM(CASE WHEN v.estado = 'retrasado' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS porcentaje_retrasos,
    ROUND(SUM(CASE WHEN v.estado = 'programado' OR v.estado = 'en vuelo' OR v.estado = 'aterrizado' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS porcentaje_a_tiempo
  FROM vuelos v
  JOIN aerolineas a ON v.aerolinea_id = a.aerolinea_id
  WHERE MONTH(v.fecha_salida) = mes AND YEAR(v.fecha_salida) = anio
  GROUP BY a.nombre;
END //

DELIMITER ;

-- CALL estadisticas_puntualidad(6, 2025);

-- Triggers ---------------------------------------------------------------------

# Actualizar estado de la aeronave
DELIMITER //

CREATE TRIGGER trigger_estado_aeronave_mantenimiento
AFTER INSERT ON mantenimiento_aeronaves
FOR EACH ROW
BEGIN
  IF NEW.estado = 'en mantenimiento' THEN
    UPDATE aeronaves 
    SET estado = 'Mantenimiento'
    WHERE aeronave_id = NEW.aeronave_id;

  ELSEIF NEW.estado = 'funcional' THEN
    UPDATE aeronaves 
    SET estado = 'Activo'
    WHERE aeronave_id = NEW.aeronave_id;

  ELSEIF NEW.estado = 'fuera de servicio' THEN
    UPDATE aeronaves 
    SET estado = 'Inactiva'
    WHERE aeronave_id = NEW.aeronave_id;
  END IF;
END //

DELIMITER ;

-- SELECT aeronave_id, modelo, estado 
-- FROM aeronaves 
-- WHERE aeronave_id = 2;

/*
INSERT INTO mantenimiento_aeronaves (
  aeronave_id, fecha_inicio, fecha_estimada_retorno, estado, descripcion
)
VALUES (
  2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'en mantenimiento', 'Revisión general antes de vuelo'
);
 
SELECT aeronave_id, modelo, estado 
FROM aeronaves 
WHERE aeronave_id = 2; 
*/

# Notificacion de correos
DELIMITER //

CREATE TRIGGER trigger_notificar_retraso
AFTER UPDATE ON vuelos
FOR EACH ROW
BEGIN
  DECLARE diferencia_min INT DEFAULT 0;

  -- Verifica si se acaba de registrar la hora real de llegada
  IF NEW.fecha_llegada_real IS NOT NULL AND OLD.fecha_llegada_real IS NULL THEN

    -- Asegúrate que ambas fechas no sean NULL y estén en formato DATETIME
    SET diferencia_min = TIMESTAMPDIFF(MINUTE, NEW.fecha_llegada_estimada, NEW.fecha_llegada_real);

    IF diferencia_min IS NOT NULL AND ABS(diferencia_min) > 15 THEN
      INSERT INTO notificaciones (pasajero_id, vuelo_id, mensaje)
      SELECT r.pasajero_id, NEW.vuelo_id,
             CONCAT('Estimado pasajero, su vuelo ', NEW.vuelo_id, 
                    ' presenta un retraso de ', ABS(diferencia_min), 
                    ' minutos. Disculpe las molestias.')
      FROM reservaciones r
      WHERE r.vuelo_id = NEW.vuelo_id;
    END IF;
  END IF;
END //

DELIMITER ;




-- Simular llegada con 30 minutos de retraso
UPDATE vuelos 
SET fecha_llegada_real = DATE_ADD(fecha_llegada_estimada, INTERVAL 30 MINUTE)
WHERE vuelo_id = 3;

SELECT * FROM notificaciones WHERE vuelo_id = 3;

# Actualizacion de programa de fidelidad
DELIMITER //

CREATE TRIGGER trg_actualizar_fidelidad
AFTER INSERT ON reservaciones
FOR EACH ROW
BEGIN
  IF NEW.estado = 'utilizada' THEN

    -- Aumentar contador
    UPDATE pasajeros
    SET vuelos_utilizados = vuelos_utilizados + 1
    WHERE pasajero_id = NEW.pasajero_id;

    -- Actualizar nivel
    UPDATE pasajeros
    SET programa_fidelidad = 
      CASE 
        WHEN vuelos_utilizados >= 15 THEN 'Diamante'
        WHEN vuelos_utilizados >= 10 THEN 'Oro'
        WHEN vuelos_utilizados >= 5 THEN 'Plata'
        ELSE 'Básico'
      END
    WHERE pasajero_id = NEW.pasajero_id;
  END IF;
END //

DELIMITER ;

SELECT pasajero_id, nombre, vuelos_utilizados, programa_fidelidad 
FROM pasajeros 
ORDER BY pasajero_id;

-- Transacciones ---------------------------------------------------------

# Proceso de reservacion 
DELIMITER //

CREATE PROCEDURE hacer_reservacion(
  IN p_vuelo_id INT,
  IN p_pasajero_id INT,
  IN p_clase VARCHAR(20),
  IN p_asiento VARCHAR(5),
  IN p_precio DECIMAL(10,2),
  IN p_metodo_pago VARCHAR(30)
)
BEGIN
  DECLARE asientos INT;
  DECLARE res_id INT;

  START TRANSACTION;

  SELECT asientos_disponibles INTO asientos FROM vuelos WHERE vuelo_id = p_vuelo_id;

  IF asientos > 0 THEN
    INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago)
    VALUES (p_vuelo_id, p_pasajero_id, p_clase, p_asiento, 'confirmada', p_precio, p_metodo_pago);

    SET res_id = LAST_INSERT_ID();

    UPDATE vuelos SET asientos_disponibles = asientos_disponibles - 1 WHERE vuelo_id = p_vuelo_id;

    INSERT INTO pagos (reservacion_id, monto, metodo_pago)
    VALUES (res_id, p_precio, p_metodo_pago);

    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END //

DELIMITER ;
-- Ejemplo de uso 
CALL hacer_reservacion(1, 1, 'turista', '12A', 2500.00, 'tarjeta');

# Check in
DELIMITER //

CREATE PROCEDURE realizar_checkin(IN p_reservacion_id INT)
BEGIN
  DECLARE v_vuelo_id INT;
  DECLARE v_pasajero_id INT;
  DECLARE v_asientos INT;
  DECLARE v_pasaporte_ok INT DEFAULT 0;

  -- Obtener vuelo y pasajero
  SELECT vuelo_id, pasajero_id
  INTO v_vuelo_id, v_pasajero_id
  FROM reservaciones
  WHERE reservacion_id = p_reservacion_id;

  -- Verificar asientos disponibles
  SELECT asientos_disponibles INTO v_asientos
  FROM vuelos
  WHERE vuelo_id = v_vuelo_id;

  -- Verificar pasaporte válido
  SELECT COUNT(*) INTO v_pasaporte_ok
  FROM pasajeros
  WHERE pasajero_id = v_pasajero_id AND pasaporte IS NOT NULL;

  START TRANSACTION;
  IF v_asientos > 0 AND v_pasaporte_ok = 1 THEN
    -- Descontar asiento
    UPDATE vuelos
    SET asientos_disponibles = asientos_disponibles - 1
    WHERE vuelo_id = v_vuelo_id;

    -- Confirmar reservación
    UPDATE reservaciones
    SET estado = 'confirmada'
    WHERE reservacion_id = p_reservacion_id;

    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END //

DELIMITER ;

-- Ejemplo de uso
CALL realizar_checkin(1); -- Usa el ID de la reservación que quieras procesar


