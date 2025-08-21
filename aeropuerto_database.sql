CREATE DATABASE aeropuerto
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE TABLE aerolineas(
	aerolinea_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    codigo_IATA CHAR(2) NOT NULL,
    pais_origen VARCHAR(50),
    fecha_fundacion DATE,
    sitio_web VARCHAR(100) -- URL del sitio
);

CREATE TABLE aeronaves(
	aeronave_id INT PRIMARY KEY AUTO_INCREMENT,
    aerolinea_id INT NOT NULL,
    modelo VARCHAR(50),
    capacidad_pasajeros INT,
    capacidad_carga DECIMAL(10,2), -- en kg
    fecha_fabricacion DATE,
    FOREIGN KEY (aerolinea_id) REFERENCES aerolineas(aerolinea_id)
);

CREATE TABLE rutas(
	ruta_id INT PRIMARY KEY AUTO_INCREMENT,
    aeropuerto_origen CHAR(3), -- codigo IATA
    aeropuerto_destino CHAR(3), -- codigo IATA
    distancia_km INT, -- km
    tiempo_estimado INT -- duracion promedio en minutos
);

CREATE TABLE vuelos(
	vuelo_id INT PRIMARY KEY AUTO_INCREMENT,
    aerolinea_id INT NOT NULL,
    ruta_id INT NOT NULL,
    aeronave_id INT NOT NULL,
    fecha_salida TIMESTAMP NOT NULL,
    fecha_llegada_estimada TIMESTAMP NOT NULL,
    fecha_llegada_real TIMESTAMP NULL,
    puerta_embarque VARCHAR(2),
    estado ENUM('programado', 'en vuelo', 'aterrizado', 'cancelado', 'retrasado'),    
    FOREIGN KEY (aerolinea_id) REFERENCES aerolineas(aerolinea_id),
    FOREIGN KEY (ruta_id) REFERENCES rutas(ruta_id),
    FOREIGN KEY (aeronave_id) REFERENCES aeronaves(aeronave_id)
);

CREATE TABLE pasajeros(
	pasajero_id INT PRIMARY KEY AUTO_INCREMENT,
    pasaporte INT,
    nombre VARCHAR(50),
    fecha_nacimiento DATE,
    nacionalidad VARCHAR(50),
    telefono VARCHAR(20),
    email VARCHAR(100),
    programa_fidelidad VARCHAR(100)
);

CREATE TABLE tripulacion(
	empleado_id INT PRIMARY KEY AUTO_INCREMENT,
    aerolinea_id INT NOT NULL,
    licencia VARCHAR(50), -- numero de licencia profesional
    nombre VARCHAR(50), -- primer nombre
    apellido VARCHAR(50), -- apellido completo
    puesto ENUM('piloto', 'copiloto', 'azafata', 'ingeniero', 'jefe de cabina'),
    fecha_de_contratacion DATE,
    horas_de_vuelo INT, -- total acumulado
    FOREIGN KEY (aerolinea_id) REFERENCES aerolineas(aerolinea_id)
);

CREATE TABLE reservaciones(
	reservacion_id INT PRIMARY KEY AUTO_INCREMENT,
    vuelo_id INT NOT NULL,
    pasajero_id INT NOT NULL,
    clase ENUM('primera', 'business', 'turista', 'premium'),
    asiento VARCHAR(4), -- num de asiento ejemplo 12A
    fecha_de_reservacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('confirmada', 'en espera', 'cancelada', 'utilizada'),
    precio DECIMAL(10,2),
    metodo_pago ENUM('tarjeta', 'efectivo', 'transferencia'),
    FOREIGN KEY (vuelo_id) REFERENCES vuelos(vuelo_id),
    FOREIGN KEY (pasajero_id) REFERENCES pasajeros(pasajero_id)
);

CREATE TABLE tripulacion_vuelo(
	vuelo_id INT NOT NULL,
    empleado_id INT NOT NULL,
    rol TEXT,
    PRIMARY KEY (vuelo_id, empleado_id),
    FOREIGN KEY (vuelo_id) REFERENCES vuelos(vuelo_id),
    FOREIGN KEY (empleado_id) REFERENCES tripulacion(empleado_id)   
);

CREATE TABLE mantenimiento_aeronaves (
    mantenimiento_id INT PRIMARY KEY AUTO_INCREMENT,
    aeronave_id INT NOT NULL,
    fecha_inicio DATE,
    fecha_estimada_retorno DATE,
    estado ENUM('en mantenimiento', 'funcional', 'fuera de servicio'),
    descripcion VARCHAR(255),
    FOREIGN KEY (aeronave_id) REFERENCES aeronaves(aeronave_id)
);

-- Actualizacion de tabla para triggers
ALTER TABLE aeronaves 
ADD COLUMN estado VARCHAR(30) DEFAULT 'Activo';

CREATE TABLE notificaciones (
  notificacion_id INT AUTO_INCREMENT PRIMARY KEY,
  pasajero_id INT,
  vuelo_id INT,
  mensaje VARCHAR(255),
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pasajero_id) REFERENCES pasajeros(pasajero_id),
  FOREIGN KEY (vuelo_id) REFERENCES vuelos(vuelo_id)
);

ALTER TABLE pasajeros ADD vuelos_utilizados INT DEFAULT 0;

CREATE TABLE pagos (
  pago_id INT AUTO_INCREMENT PRIMARY KEY,
  reservacion_id INT,
  monto DECIMAL(10,2),
  metodo_pago VARCHAR(30),
  fecha_pago DATETIME DEFAULT NOW(),
  FOREIGN KEY (reservacion_id) REFERENCES reservaciones(reservacion_id)
);
-- Hasta aquí lo mandé

ALTER TABLE vuelos ADD asientos_disponibles INT DEFAULT 180;


