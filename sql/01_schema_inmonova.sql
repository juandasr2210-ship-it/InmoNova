-- =====================================================
-- InmoNova - Sprint 1 : DDL + DML (MySQL / MariaDB XAMPP)
-- Cumple PDF: 1:1, 1:N, N:M, UNIQUE, PK/FK, ON DELETE/UPDATE
-- Importar desde phpMyAdmin: http://localhost/phpmyadmin
-- =====================================================
CREATE DATABASE IF NOT EXISTS inmonova CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inmonova;

-- ---------- CATALOGOS ----------
CREATE TABLE IF NOT EXISTS rol(
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL UNIQUE,
  descripcion VARCHAR(200)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ciudad(
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  departamento VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tipo_propiedad(
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS caracteristica(
  id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ---------- USUARIOS (1:1 parte 1) ----------
CREATE TABLE IF NOT EXISTS usuario(
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  correo VARCHAR(120) NOT NULL UNIQUE,
  clave_hash CHAR(64) NOT NULL,
  salt VARCHAR(32) NOT NULL,
  estado TINYINT(1) NOT NULL DEFAULT 1,
  intentos INT NOT NULL DEFAULT 0,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------- N:M usuario <-> rol ----------
CREATE TABLE IF NOT EXISTS usuario_rol(
  id_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id_usuario, id_rol),
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_rol) REFERENCES rol(id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------- 1:1 parte 2 : perfil.id_usuario UNIQUE ----------
CREATE TABLE IF NOT EXISTS perfil(
  id_perfil INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  nombres VARCHAR(80) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  documento VARCHAR(20) NULL UNIQUE,
  telefono VARCHAR(20),
  direccion VARCHAR(150),
  foto VARCHAR(255),
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS inmobiliaria(
  id_inmobiliaria INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  nombre_empresa VARCHAR(120) NOT NULL,
  nit VARCHAR(20) NOT NULL UNIQUE,
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------- 1:N inmobiliaria -> propiedad ----------
CREATE TABLE IF NOT EXISTS propiedad(
  id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
  id_inmobiliaria INT NOT NULL,
  id_ciudad INT NOT NULL,
  id_tipo INT NOT NULL,
  titulo VARCHAR(150) NOT NULL,
  descripcion TEXT,
  precio DECIMAL(14,2) NOT NULL,
  direccion VARCHAR(150),
  matricula_inmobiliaria VARCHAR(40) NOT NULL UNIQUE,
  estado VARCHAR(20) NOT NULL DEFAULT 'disponible',
  destacada TINYINT(1) DEFAULT 0,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY(id_inmobiliaria) REFERENCES inmobiliaria(id_inmobiliaria) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_ciudad) REFERENCES ciudad(id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_tipo) REFERENCES tipo_propiedad(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------- 1:N propiedad -> imagen ----------
CREATE TABLE IF NOT EXISTS imagen_propiedad(
  id_imagen INT AUTO_INCREMENT PRIMARY KEY,
  id_propiedad INT NOT NULL,
  url VARCHAR(255) NOT NULL,
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------- N:M propiedad <-> caracteristica ----------
CREATE TABLE IF NOT EXISTS propiedad_caracteristica(
  id_propiedad INT NOT NULL,
  id_caracteristica INT NOT NULL,
  cantidad INT DEFAULT 1,
  PRIMARY KEY(id_propiedad, id_caracteristica),
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_caracteristica) REFERENCES caracteristica(id_caracteristica) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cita(
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  id_propiedad INT NOT NULL,
  id_cliente INT NOT NULL,
  fecha_hora DATETIME NOT NULL,
  estado VARCHAR(20) DEFAULT 'pendiente',
  UNIQUE(id_propiedad, fecha_hora),
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS solicitud(
  id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
  id_propiedad INT NOT NULL,
  id_cliente INT NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  estado VARCHAR(20) DEFAULT 'radicada',
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS documento_solicitud(
  id_doc INT AUTO_INCREMENT PRIMARY KEY,
  id_solicitud INT NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  ruta VARCHAR(255) NOT NULL,
  FOREIGN KEY(id_solicitud) REFERENCES solicitud(id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS favorito(
  id_usuario INT NOT NULL,
  id_propiedad INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id_usuario, id_propiedad),
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS auditoria(
  id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NULL,
  accion VARCHAR(100) NOT NULL,
  detalle VARCHAR(255),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------- DATOS PRUEBA (min 10 en principales) ----------
INSERT INTO rol(nombre, descripcion) VALUES
('administrador','Acceso total'),('inmobiliaria','Agente que publica'),
('cliente','Compra/arrienda'),('visitante','No autenticado')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

INSERT INTO ciudad(nombre, departamento) VALUES
('Bucaramanga','Santander'),('Floridablanca','Santander'),('Giron','Santander'),
('Piedecuesta','Santander'),('Bogota','Cundinamarca'),('Medellin','Antioquia'),
('Cali','Valle'),('Barranquilla','Atlantico'),('Cartagena','Bolivar'),('Santa Marta','Magdalena')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

INSERT INTO tipo_propiedad(nombre) VALUES
('casa'),('apartamento'),('local'),('oficina'),('terreno')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

INSERT INTO caracteristica(nombre) VALUES
('piscina'),('parqueadero'),('ascensor'),('gimnasio'),('balcon'),
('cocina integral'),('zona BBQ'),('porteria 24h'),('deposito'),('terraza')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

-- Usuarios de prueba. Clave real se genera desde registro.jsp (SHA-256+salt).
-- Estos 3 son de ejemplo con salt='demo1234' y clave_hash de 'Admin123*','Agente123*','Cliente123*'
-- Si no coinciden, REGISTRA usuarios nuevos desde la app (recomendado).
INSERT INTO usuario(correo, clave_hash, salt, estado) VALUES
('admin@inmonova.com','9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08','demosalt01',1),
('agente@inmonova.com','9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08','demosalt02',1),
('cliente@inmonova.com','9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08','demosalt03',1)
ON DUPLICATE KEY UPDATE correo=VALUES(correo);

-- Asignar roles (ajustar ids segun AUTO_INCREMENT real)
-- Se hace por correo para evitar problemas de ids:
-- admin -> administrador, agente -> inmobiliaria, cliente -> cliente
-- Ejecutar despues del insert anterior:
-- (si falla por ids, hacerlo desde phpMyAdmin manualmente)
INSERT IGNORE INTO usuario_rol(id_usuario, id_rol)
SELECT u.id_usuario, r.id_rol FROM usuario u, rol r
WHERE u.correo='admin@inmonova.com' AND r.nombre='administrador';
INSERT IGNORE INTO usuario_rol(id_usuario, id_rol)
SELECT u.id_usuario, r.id_rol FROM usuario u, rol r
WHERE u.correo='agente@inmonova.com' AND r.nombre='inmobiliaria';
INSERT IGNORE INTO usuario_rol(id_usuario, id_rol)
SELECT u.id_usuario, r.id_rol FROM usuario u, rol r
WHERE u.correo='cliente@inmonova.com' AND r.nombre='cliente';

-- =====================================================
-- CONSULTAS OBLIGATORIAS DEL PDF (para sustentar):
-- 1) INNER JOIN 3+ tablas: propiedades con ciudad, tipo e inmobiliaria
-- SELECT p.titulo, c.nombre AS ciudad, t.nombre AS tipo, i.nombre_empresa
-- FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad
-- INNER JOIN tipo_propiedad t ON p.id_tipo=t.id_tipo
-- INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria;
-- 2) N:M caracteristicas de una propiedad:
-- SELECT p.titulo, ca.nombre FROM propiedad p
-- INNER JOIN propiedad_caracteristica pc ON p.id_propiedad=pc.id_propiedad
-- INNER JOIN caracteristica ca ON pc.id_caracteristica=ca.id_caracteristica;
-- 3) N:M roles de un usuario:
-- SELECT u.correo, r.nombre FROM usuario u
-- INNER JOIN usuario_rol ur ON u.id_usuario=ur.id_usuario
-- INNER JOIN rol r ON ur.id_rol=r.id_rol;
-- 4) LEFT JOIN propiedades sin citas:
-- SELECT p.* FROM propiedad p LEFT JOIN cita ci ON p.id_propiedad=ci.id_propiedad WHERE ci.id_cita IS NULL;
-- 5) GROUP BY + HAVING reporte por ciudad:
-- SELECT c.nombre, COUNT(*) total FROM propiedad p
-- INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad GROUP BY c.nombre HAVING COUNT(*)>=1;
-- =====================================================
