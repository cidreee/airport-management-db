-- Aerolineas
INSERT INTO aerolineas (nombre, codigo_IATA, pais_origen, fecha_fundacion, sitio_web) VALUES
('FlyLuchón', 'FL', 'México', '2010-04-15', 'https://flyluchon.mx'),
('TacoAir', 'TA', 'México', '2005-09-10', 'https://tacoair.com'),
('AlaDelta', 'AD', 'Argentina', '2001-02-11', 'https://aladelta.ar'),
('GuacamayaJet', 'GJ', 'Colombia', '2012-11-21', 'https://guacamayajet.co'),
('NeblinaSky', 'NS', 'Chile', '2014-03-18', 'https://neblinasky.cl'),
('MoleWings', 'MW', 'México', '2016-06-12', 'https://molewings.mx'),
('TequilaAir', 'TQ', 'México', '2008-12-25', 'https://tequilaair.mx'),
('LlamaWings', 'LW', 'Perú', '2013-09-29', 'https://llamawings.pe'),
('CondorSur', 'CS', 'Uruguay', '2017-07-07', 'https://condorsur.uy'),
('TamaleJet', 'TJ', 'México', '2019-04-04', 'https://tamalejet.mx');

-- Aeronaves

INSERT INTO aeronaves (aerolinea_id, modelo, capacidad_pasajeros, capacidad_carga, fecha_fabricacion) VALUES
(1, 'Boeing 737 Max Fiesta', 180, 20000.50, '2018-06-30'),
(2, 'Airbus A320 Tortilla', 160, 18000.75, '2015-02-21'),
(3, 'Embraer 190 Mate', 100, 12500.00, '2017-03-11'),
(4, 'ATR 72 Guacamaya', 70, 8000.00, '2019-08-22'),
(5, 'Cessna 208 Neblina', 12, 1500.00, '2020-10-10'),
(6, 'Boeing 747 Mole Edition', 400, 30000.00, '2010-01-15'),
(7, 'Airbus A321 Tequilero', 190, 19500.00, '2014-04-04'),
(8, 'LlamaFlyer XL', 90, 10000.00, '2016-06-16'),
(9, 'CondorMax 500', 120, 15500.00, '2021-09-09'),
(10, 'Jetstream Tamalero', 50, 4000.00, '2013-11-11');

-- Rutas
INSERT INTO rutas (aeropuerto_origen, aeropuerto_destino, distancia_km, tiempo_estimado) VALUES
('MEX', 'CUN', 1600, 125),
('GDL', 'MTY', 670, 80),
('CUN', 'GDL', 1900, 145),
('MTY', 'TIJ', 2300, 190),
('TIJ', 'MEX', 2800, 210),
('MEX', 'LIM', 4200, 300),
('GDL', 'BOG', 3800, 270),
('CUN', 'EZE', 7400, 530),
('MTY', 'SCL', 6000, 460),
('TIJ', 'MIA', 3500, 240);

-- Vuelos
INSERT INTO vuelos (aerolinea_id, ruta_id, aeronave_id, fecha_salida, fecha_llegada_estimada, fecha_llegada_real, puerta_embarque, estado) VALUES
(1, 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), NULL, 'A1', 'programado'),
(2, 2, 2, NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR), NULL, 'B2', 'retrasado'),
(3, 3, 3, NOW(), DATE_ADD(NOW(), INTERVAL 3 HOUR), NULL, 'C3', 'programado'),
(4, 4, 4, NOW(), DATE_ADD(NOW(), INTERVAL 4 HOUR), NULL, 'D4', 'cancelado'),
(5, 5, 5, NOW(), DATE_ADD(NOW(), INTERVAL 5 HOUR), NULL, 'E5', 'en vuelo'),
(6, 6, 6, NOW(), DATE_ADD(NOW(), INTERVAL 6 HOUR), NULL, 'F6', 'programado'),
(7, 7, 7, NOW(), DATE_ADD(NOW(), INTERVAL 7 HOUR), NULL, 'G7', 'aterrizado'),
(8, 8, 8, NOW(), DATE_ADD(NOW(), INTERVAL 8 HOUR), NULL, 'H8', 'programado'),
(9, 9, 9, NOW(), DATE_ADD(NOW(), INTERVAL 9 HOUR), NULL, 'I9', 'retrasado'),
(10, 10, 10, NOW(), DATE_ADD(NOW(), INTERVAL 10 HOUR), NULL, 'J0', 'programado');



-- Pasajeros
INSERT INTO pasajeros (pasaporte, nombre, fecha_nacimiento, nacionalidad, telefono, email, programa_fidelidad) VALUES
(10000001, 'Juan Tamal', '1990-07-20', 'Mexicana', '+52-4491234567', 'juan.tamal@mail.com', 'SúperTacoPlus'),
(10000002, 'Lupita Voladora', '1985-03-15', 'Mexicana', '+52-3335558899', 'lupita.fly@mail.com', 'TacoVIP'),
(10000003, 'Pedro Nube', '1975-01-30', 'Peruana', '+51-123456789', 'pedro.nube@correo.pe', 'LlamaElite'),
(10000004, 'Sofía Jet', '1993-09-09', 'Argentina', '+54-1122334455', 'sofia.jet@aladelta.com', 'MateFlyer'),
(10000005, 'Carlos Alas', '1980-12-12', 'Colombiana', '+57-3015551122', 'carlos.alas@gj.co', 'GuacaPlus'),
(10000006, 'María Cielo', '2000-04-01', 'Chilena', '+56-987654321', 'maria.cielo@ns.cl', 'SkyStar'),
(10000007, 'Luis Turbo', '1995-05-05', 'Mexicana', '+52-5588223344', 'luis.turbo@mole.mx', 'MoleExpress'),
(10000008, 'Ana Ala', '1998-02-20', 'Uruguaya', '+598-99887766', 'ana.ala@cs.uy', 'CondorOne'),
(10000009, 'Diana Jetpack', '1989-06-06', 'Colombiana', '+57-302998877', 'diana.jetpack@gj.co', 'GuacaVIP'),
(10000010, 'Chava Veloz', '2001-11-11', 'Mexicana', '+52-9995556666', 'chava.veloz@tamale.mx', 'TamalePremier');

-- Reservaciones
INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago) VALUES
(1, 1, 'turista', '18A', 'confirmada', 2599.99, 'tarjeta'),
(2, 2, 'business', '3C', 'en espera', 7499.50, 'transferencia'),
(3, 3, 'primera', '1A', 'confirmada', 9500.00, 'tarjeta'),
(4, 4, 'turista', '20B', 'cancelada', 1800.00, 'efectivo'),
(5, 5, 'premium', '5D', 'utilizada', 6500.00, 'tarjeta'),
(6, 6, 'turista', '22F', 'utilizada', 2100.00, 'efectivo'),
(7, 7, 'business', '4B', 'confirmada', 7200.00, 'transferencia'),
(8, 8, 'turista', '17C', 'confirmada', 2999.00, 'tarjeta'),
(9, 9, 'primera', '1C', 'en espera', 10200.00, 'efectivo'),
(10, 10, 'premium', '6A', 'confirmada', 5600.00, 'tarjeta');

--  Pasajero 5 (Carlos Alas) - 11 vuelos utilizados
INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago) VALUES
(1, 5, 'turista', '12A', 'utilizada', 2000.00, 'efectivo'),
(2, 5, 'business', '3B', 'utilizada', 2500.00, 'tarjeta'),
(3, 5, 'premium', '4C', 'utilizada', 3000.00, 'transferencia'),
(4, 5, 'turista', '22A', 'utilizada', 2200.00, 'efectivo'),
(5, 5, 'business', '1B', 'utilizada', 2700.00, 'efectivo'),
(6, 5, 'turista', '15C', 'utilizada', 2100.00, 'tarjeta'),
(7, 5, 'primera', '2A', 'utilizada', 9000.00, 'tarjeta'),
(8, 5, 'turista', '13D', 'utilizada', 2300.00, 'efectivo'),
(9, 5, 'business', '5A', 'utilizada', 3100.00, 'efectivo'),
(10, 5, 'premium', '3D', 'utilizada', 3500.00, 'transferencia'),
(1, 5, 'turista', '14F', 'utilizada', 2600.00, 'tarjeta');

--  Pasajero 6 (María Cielo) - 12 vuelos utilizados
INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago) VALUES
(1, 6, 'turista', '12C', 'utilizada', 2000.00, 'tarjeta'),
(2, 6, 'business', '3C', 'utilizada', 2500.00, 'tarjeta'),
(3, 6, 'primera', '1A', 'utilizada', 9500.00, 'efectivo'),
(4, 6, 'turista', '20B', 'utilizada', 1800.00, 'transferencia'),
(5, 6, 'premium', '5D', 'utilizada', 6500.00, 'efectivo'),
(6, 6, 'turista', '22F', 'utilizada', 2100.00, 'tarjeta'),
(7, 6, 'business', '4B', 'utilizada', 7200.00, 'transferencia'),
(8, 6, 'turista', '17C', 'utilizada', 2999.00, 'tarjeta'),
(9, 6, 'primera', '1C', 'utilizada', 10200.00, 'efectivo'),
(10, 6, 'premium', '6A', 'utilizada', 5600.00, 'tarjeta'),
(1, 6, 'turista', '11B', 'utilizada', 3100.00, 'efectivo'),
(2, 6, 'turista', '10A', 'utilizada', 2900.00, 'tarjeta');

--  Pasajero 1 (Juan Tamal) - 13 vuelos utilizados
INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago) VALUES
(1, 1, 'turista', '15A', 'utilizada', 2500.00, 'tarjeta'),
(2, 1, 'business', '2B', 'utilizada', 3000.00, 'transferencia'),
(3, 1, 'turista', '16C', 'utilizada', 1900.00, 'efectivo'),
(4, 1, 'primera', '1B', 'utilizada', 8800.00, 'efectivo'),
(5, 1, 'turista', '13C', 'utilizada', 2400.00, 'tarjeta'),
(6, 1, 'business', '4A', 'utilizada', 3100.00, 'transferencia'),
(7, 1, 'turista', '19D', 'utilizada', 2700.00, 'efectivo'),
(8, 1, 'turista', '14A', 'utilizada', 2600.00, 'tarjeta'),
(9, 1, 'turista', '12F', 'utilizada', 2550.00, 'efectivo'),
(10, 1, 'turista', '18C', 'utilizada', 2450.00, 'tarjeta'),
(3, 1, 'turista', '13A', 'utilizada', 2500.00, 'efectivo'),
(2, 1, 'turista', '10C', 'utilizada', 2350.00, 'tarjeta'),
(1, 1, 'turista', '16B', 'utilizada', 2600.00, 'tarjeta');

-- Tripulacion 
INSERT INTO tripulacion (aerolinea_id, licencia, nombre, apellido, puesto, fecha_de_contratacion, horas_de_vuelo) VALUES
(1, 'LIC001', 'Pedro', 'Pilotín', 'piloto', '2010-05-10', 12000),
(2, 'LIC002', 'Sandra', 'Azafatina', 'azafata', '2016-08-22', 5000),
(3, 'LIC003', 'Luis', 'Copilotazo', 'copiloto', '2018-03-01', 3400),
(4, 'LIC004', 'Marta', 'Vueltica', 'azafata', '2019-10-10', 2500),
(5, 'LIC005', 'José', 'Reactor', 'ingeniero', '2015-07-07', 6200),
(6, 'LIC006', 'Julia', 'Cabinera', 'jefe de cabina', '2013-01-15', 9800),
(7, 'LIC007', 'Andrés', 'Motorón', 'ingeniero', '2020-02-20', 1500),
(8, 'LIC008', 'Elena', 'Volandera', 'azafata', '2017-06-12', 4000),
(9, 'LIC009', 'Ricardo', 'Veloz', 'piloto', '2012-04-04', 13500),
(10, 'LIC010', 'Camila', 'Aire', 'copiloto', '2011-09-09', 8000);


-- Piloto con pocas horas
INSERT INTO tripulacion (aerolinea_id, licencia, nombre, apellido, puesto, fecha_de_contratacion, horas_de_vuelo)
VALUES (1, 'PIL-0001', 'Ramón', 'Pérez', 'piloto', '2023-01-01', 80);

-- Copiloto con pocas horas
INSERT INTO tripulacion (aerolinea_id, licencia, nombre, apellido, puesto, fecha_de_contratacion, horas_de_vuelo)
VALUES (1, 'COP-0002', 'Luis', 'García', 'copiloto', '2023-02-01', 90);

-- Azafatas con pocas horas
INSERT INTO tripulacion (aerolinea_id, licencia, nombre, apellido, puesto, fecha_de_contratacion, horas_de_vuelo) VALUES
(1, 'AZF-1001', 'Lucía', 'Ramírez', 'azafata', '2023-01-15', 60),
(1, 'AZF-1002', 'Karen', 'Hernández', 'azafata', '2023-01-20', 50),
(1, 'AZF-1003', 'Rosa', 'Martínez', 'azafata', '2023-01-25', 45);


-- Tripulacion vuelo

INSERT INTO tripulacion_vuelo (vuelo_id, empleado_id, rol) VALUES
(1, 1, 'Capitán del vuelo'),
(1, 3, 'Copiloto oficial'),
(2, 2, 'Líder de cabina'),
(2, 4, 'Asistente de vuelo'),
(3, 5, 'Ingeniero de vuelo'),
(3, 6, 'Jefa de cabina'),
(4, 7, 'Mecánico en ruta'),
(5, 8, 'Azafata'),
(6, 9, 'Piloto senior'),
(6, 10, 'Copiloto de refuerzo');

-- Azafata 1
INSERT INTO tripulacion (aerolinea_id, licencia, nombre, apellido, puesto, fecha_de_contratacion, horas_de_vuelo)
VALUES 
	(1, 'AZF-1201', 'Daniela', 'Ramírez Soto', 'azafata', '2021-06-15', 850),
	(2, 'AZF-1310', 'Laura', 'Gómez Rivas', 'azafata', '2022-03-10', 430),
    (1, 'PIL-0987', 'Carlos', 'Martínez López', 'piloto', '2018-01-22', 1900);


-- Mantenimiento
INSERT INTO mantenimiento_aeronaves (aeronave_id, fecha_inicio, fecha_estimada_retorno, estado, descripcion) VALUES
(2, '2025-05-30', '2025-06-05', 'en mantenimiento', 'Cambio de tren de aterrizaje'),
(6, '2025-05-28', '2025-06-10', 'en mantenimiento', 'Revisión general de motores'),
(9, '2025-05-25', '2025-06-04', 'funcional', 'Inspección completada'),
(10, '2025-05-26', '2025-06-06', 'fuera de servicio', 'Daños estructurales graves');

INSERT INTO mantenimiento_aeronaves (aeronave_id, fecha_inicio, fecha_estimada_retorno, estado, descripcion) VALUES
(1, '2025-06-01', '2025-06-07', 'en mantenimiento', 'Revisión de sistema hidráulico'),
(3, '2025-05-29', '2025-06-03', 'funcional', 'Chequeo de rutina completado'),
(4, '2025-06-01', '2025-06-09', 'en mantenimiento', 'Inspección de alas y superficie'),
(5, '2025-05-27', '2025-06-02', 'en mantenimiento', 'Actualización de software de navegación'),
(7, '2025-06-02', '2025-06-12', 'fuera de servicio', 'Fallo en los sistemas eléctricos'),
(8, '2025-06-01', '2025-06-08', 'en mantenimiento', 'Cambio de frenos principales'),
(1, '2025-04-15', '2025-04-20', 'funcional', 'Mantenimiento previo a auditoría'),
(2, '2025-06-01', '2025-06-04', 'en mantenimiento', 'Revisión del tren de aterrizaje delantero'),
(10, '2025-06-03', '2025-06-15', 'en mantenimiento', 'Reemplazo de ventanillas'),
(9, '2025-05-30', '2025-06-05', 'en mantenimiento', 'Ajuste del sistema de presurización');

-- Prueba para stores procedures
-- Ruta de prueba
INSERT INTO rutas (aeropuerto_origen, aeropuerto_destino, distancia_km, tiempo_estimado)
VALUES ('MEX', 'CUN', 1600, 120);

INSERT INTO aeronaves (aerolinea_id, modelo, capacidad_pasajeros, capacidad_carga, fecha_fabricacion)
VALUES (1, 'Airbus A320', 180, 20000, '2019-08-01');

INSERT INTO vuelos (aerolinea_id, ruta_id, aeronave_id, fecha_salida, fecha_llegada_estimada, puerta_embarque, estado)
VALUES (1, 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), 'A3', 'programado');


-- Vuelos prueba
-- Vuelos adicionales para distintas aerolíneas en JUNIO
INSERT INTO vuelos (aerolinea_id, ruta_id, aeronave_id, fecha_salida, fecha_llegada_estimada, puerta_embarque, estado) VALUES
(1, 2, 1, '2025-06-02 08:00:00', '2025-06-02 10:30:00', 'A2', 'retrasado'),
(2, 3, 2, '2025-06-05 07:00:00', '2025-06-05 09:00:00', 'B3', 'programado'),
(3, 4, 3, '2025-06-10 13:00:00', '2025-06-10 17:00:00', 'C1', 'aterrizado'),
(4, 5, 4, '2025-06-11 10:30:00', '2025-06-11 14:00:00', 'D2', 'cancelado'),
(5, 6, 5, '2025-06-15 06:00:00', '2025-06-15 10:00:00', 'E4', 'retrasado'),
(6, 7, 6, '2025-06-18 09:45:00', '2025-06-18 15:30:00', 'F5', 'en vuelo'),
(7, 8, 7, '2025-06-20 12:00:00', '2025-06-20 18:30:00', 'G2', 'retrasado'),
(8, 9, 8, '2025-06-25 14:30:00', '2025-06-25 21:00:00', 'H3', 'programado'),
(9, 10, 9, '2025-06-27 07:00:00', '2025-06-27 12:00:00', 'I1', 'aterrizado'),
(10, 1, 10, '2025-06-29 11:00:00', '2025-06-29 16:30:00', 'J2', 'retrasado');

-- Prueba para inserts
INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago)
VALUES 
(3, 1, 'turista', '21A', 'utilizada', 2300.00, 'tarjeta'),
(4, 1, 'turista', '21B', 'utilizada', 2500.00, 'efectivo'),
(5, 1, 'turista', '21C', 'utilizada', 2100.00, 'transferencia'),
(6, 1, 'turista', '21D', 'utilizada', 2000.00, 'tarjeta');


INSERT INTO reservaciones (vuelo_id, pasajero_id, clase, asiento, estado, precio, metodo_pago) VALUES
(2, 9, 'business', '3C', 'utilizada', 5351.32, 'efectivo'),
(9, 10, 'turista', '4B', 'utilizada', 6230.83, 'efectivo'),
(6, 4, 'primera', '20B', 'utilizada', 7132.59, 'efectivo'),
(4, 9, 'turista', '4F', 'utilizada', 9454.77, 'tarjeta'),
(10, 2, 'primera', '14B', 'utilizada', 4950.42, 'tarjeta'),
(2, 4, 'premium', '8B', 'utilizada', 6700.24, 'tarjeta'),
(4, 2, 'turista', '14A', 'utilizada', 6492.24, 'efectivo'),
(8, 5, 'turista', '29A', 'utilizada', 3648.66, 'efectivo'),
(4, 1, 'turista', '13A', 'utilizada', 8307.11, 'transferencia'),
(3, 8, 'primera', '17B', 'utilizada', 7984.05, 'tarjeta'),
(3, 9, 'business', '2E', 'utilizada', 4382.40, 'efectivo'),
(1, 7, 'turista', '7B', 'utilizada', 3642.47, 'transferencia'),
(4, 6, 'primera', '22F', 'utilizada', 3821.43, 'tarjeta'),
(1, 6, 'business', '3F', 'utilizada', 1877.17, 'efectivo'),
(7, 3, 'primera', '1F', 'utilizada', 6283.99, 'efectivo'),
(10, 1, 'turista', '7C', 'utilizada', 7164.13, 'tarjeta'),
(1, 7, 'primera', '25C', 'utilizada', 4012.71, 'tarjeta'),
(8, 9, 'premium', '21F', 'utilizada', 6317.33, 'efectivo'),
(7, 8, 'turista', '28C', 'utilizada', 2952.01, 'tarjeta'),
(5, 6, 'primera', '21A', 'utilizada', 7179.62, 'tarjeta'),
(4, 7, 'primera', '23A', 'utilizada', 5702.38, 'tarjeta'),
(7, 9, 'premium', '18D', 'utilizada', 2143.65, 'transferencia'),
(9, 2, 'premium', '9E', 'utilizada', 6119.84, 'tarjeta'),
(4, 2, 'business', '27F', 'utilizada', 8507.01, 'tarjeta'),
(7, 9, 'business', '13E', 'utilizada', 6599.67, 'tarjeta'),
(7, 5, 'business', '2D', 'utilizada', 4237.66, 'transferencia'),
(7, 10, 'business', '29C', 'utilizada', 7511.42, 'tarjeta'),
(2, 1, 'premium', '10B', 'utilizada', 3658.42, 'transferencia'),
(3, 3, 'premium', '11D', 'utilizada', 5042.19, 'transferencia'),
(7, 4, 'turista', '21D', 'utilizada', 6281.60, 'efectivo');

INSERT INTO pagos (reservacion_id, monto, metodo_pago, fecha_pago)
VALUES 
(1, 3500.00, 'tarjeta', '2025-06-01 10:45:00'),
(2, 8700.00, 'transferencia', '2025-06-02 13:20:00'),
(3, 5000.00, 'efectivo', '2025-06-02 17:10:00'),
(4, 4100.00, 'tarjeta', '2025-06-03 09:05:00'),
(5, 9700.00, 'tarjeta', '2025-05-28 14:30:00'),
(6, 6500.00, 'efectivo', '2025-05-29 11:40:00'),
(7, 7200.00, 'transferencia', '2025-05-30 08:25:00'),
(8, 3100.00, 'tarjeta', '2025-06-01 12:00:00'),
(9, 8200.00, 'efectivo', '2025-06-01 15:45:00'),
(10, 4400.00, 'tarjeta', '2025-06-03 16:10:00');

