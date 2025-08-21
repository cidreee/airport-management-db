CREATE USER 'admin_aeropuerto'@'localhost' IDENTIFIED BY 'AdminPassword123!'; # Usuario administrador del sistema
GRANT ALL PRIVILEGES ON aeropuerto.* TO 'admin_aeropuerto'@'localhost';

CREATE USER 'operaciones_vuelo'@'localhost' IDENTIFIED BY 'VueloSeguro2024!'; # Usuario de operaciones de vuelo
GRANT SELECT, INSERT, UPDATE ON aeropuerto.vuelos TO 'operaciones_vuelo'@'localhost';
GRANT SELECT, INSERT, UPDATE ON aeropuerto.tripulacion TO 'operaciones_vuelo'@'localhost';
GRANT SELECT, INSERT, UPDATE ON aeropuerto.tripulacion_vuelo TO 'operaciones_vuelo'@'localhost';
GRANT SELECT, INSERT, UPDATE ON aeropuerto.mantenimiento_aeronaves TO 'operaciones_vuelo'@'localhost';

CREATE USER 'atencion_cliente'@'localhost' IDENTIFIED BY 'ClienteFeliz2024!'; # Usuario para atención al cliente
GRANT SELECT ON aeropuerto.vuelos TO 'atencion_cliente'@'localhost';
GRANT SELECT, INSERT, UPDATE ON aeropuerto.pasajeros TO 'atencion_cliente'@'localhost';
GRANT SELECT, INSERT, UPDATE ON aeropuerto.reservaciones TO 'atencion_cliente'@'localhost';
GRANT SELECT, INSERT ON aeropuerto.notificaciones TO 'atencion_cliente'@'localhost';

CREATE USER 'pagos_user'@'localhost' IDENTIFIED BY 'PagoSeguro2024!'; # Usuario para sistema de pagos
GRANT SELECT, INSERT ON aeropuerto.pagos TO 'pagos_user'@'localhost';
GRANT SELECT ON aeropuerto.reservaciones TO 'pagos_user'@'localhost';

CREATE USER 'analitica'@'localhost' IDENTIFIED BY 'DatosSeguros2024!'; # Usuario de analítica / BI
GRANT SELECT ON aeropuerto.* TO 'analitica'@'localhost';
