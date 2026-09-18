-- =====================================================
-- InmoNova - 05_neon_postgres.sql (PostgreSQL / Neon)
-- Esquema completo + semillas + 8 demos. Idempotente.
-- Uso: Neon -> SQL Editor -> base "inmonova" -> pegar todo -> Run
-- NO requiere CREATE DATABASE (Neon ya da la base "inmonova").
-- Cumple PDF: 1:1, 1:N, N:M, UNIQUE, PK/FK, ON DELETE/UPDATE
-- Lecturas compatibles con MySQL: estado/activo/destacada son
-- SMALLINT (no BOOLEAN) para que rs.getInt() sirva en ambas BD.
-- =====================================================

-- ---------- CATALOGOS ----------
CREATE TABLE IF NOT EXISTS rol(
  id_rol INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL UNIQUE,
  descripcion VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS ciudad(
  id_ciudad INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  departamento VARCHAR(80) NOT NULL
);
CREATE TABLE IF NOT EXISTS tipo_propiedad(
  id_tipo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS caracteristica(
  id_caracteristica INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL UNIQUE
);

-- ---------- USUARIOS (1:1 parte 1) ----------
CREATE TABLE IF NOT EXISTS usuario(
  id_usuario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  correo VARCHAR(120) NOT NULL UNIQUE,
  clave_hash CHAR(64) NOT NULL,
  salt VARCHAR(32) NOT NULL,
  estado SMALLINT NOT NULL DEFAULT 1,
  intentos INT NOT NULL DEFAULT 0,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------- N:M usuario <-> rol ----------
CREATE TABLE IF NOT EXISTS usuario_rol(
  id_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id_usuario, id_rol),
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_rol) REFERENCES rol(id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------- 1:1 parte 2 ----------
CREATE TABLE IF NOT EXISTS perfil(
  id_perfil INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  nombres VARCHAR(80) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  documento VARCHAR(20) NULL UNIQUE,
  telefono VARCHAR(20),
  direccion VARCHAR(150),
  foto VARCHAR(255),
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS inmobiliaria(
  id_inmobiliaria INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  nombre_empresa VARCHAR(120) NOT NULL,
  nit VARCHAR(20) NOT NULL UNIQUE,
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------- 1:N ----------
CREATE TABLE IF NOT EXISTS propiedad(
  id_propiedad INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_inmobiliaria INT NOT NULL,
  id_ciudad INT NOT NULL,
  id_tipo INT NOT NULL,
  titulo VARCHAR(150) NOT NULL,
  descripcion TEXT,
  precio NUMERIC(14,2) NOT NULL,
  direccion VARCHAR(150),
  matricula_inmobiliaria VARCHAR(40) NOT NULL UNIQUE,
  estado VARCHAR(20) NOT NULL DEFAULT 'disponible',
  destacada SMALLINT DEFAULT 0,
  activo SMALLINT DEFAULT 1,
  FOREIGN KEY(id_inmobiliaria) REFERENCES inmobiliaria(id_inmobiliaria) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_ciudad) REFERENCES ciudad(id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_tipo) REFERENCES tipo_propiedad(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS imagen_propiedad(
  id_imagen INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_propiedad INT NOT NULL,
  url VARCHAR(255) NOT NULL,
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------- N:M propiedad <-> caracteristica ----------
CREATE TABLE IF NOT EXISTS propiedad_caracteristica(
  id_propiedad INT NOT NULL,
  id_caracteristica INT NOT NULL,
  cantidad INT DEFAULT 1,
  PRIMARY KEY(id_propiedad, id_caracteristica),
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_caracteristica) REFERENCES caracteristica(id_caracteristica) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS cita(
  id_cita INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_propiedad INT NOT NULL,
  id_cliente INT NOT NULL,
  fecha_hora TIMESTAMP NOT NULL,
  estado VARCHAR(20) DEFAULT 'pendiente',
  UNIQUE(id_propiedad, fecha_hora),
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS solicitud(
  id_solicitud INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_propiedad INT NOT NULL,
  id_cliente INT NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  estado VARCHAR(20) DEFAULT 'radicada',
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY(id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS documento_solicitud(
  id_doc INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_solicitud INT NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  ruta VARCHAR(255) NOT NULL,
  FOREIGN KEY(id_solicitud) REFERENCES solicitud(id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS favorito(
  id_usuario INT NOT NULL,
  id_propiedad INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id_usuario, id_propiedad),
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS auditoria(
  id_auditoria INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_usuario INT NULL,
  accion VARCHAR(100) NOT NULL,
  detalle VARCHAR(255),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ---------- SEMILLAS ----------
INSERT INTO rol(nombre, descripcion) VALUES
('administrador','Acceso total'),('inmobiliaria','Agente que publica'),
('cliente','Compra/arrienda'),('visitante','No autenticado')
ON CONFLICT(nombre) DO NOTHING;
INSERT INTO ciudad(nombre, departamento) VALUES
('Bucaramanga','Santander'),('Floridablanca','Santander'),('Giron','Santander'),
('Piedecuesta','Santander'),('Bogota','Cundinamarca'),('Medellin','Antioquia'),
('Cali','Valle'),('Barranquilla','Atlantico'),('Cartagena','Bolivar'),('Santa Marta','Magdalena')
ON CONFLICT(nombre) DO NOTHING;
INSERT INTO tipo_propiedad(nombre) VALUES
('casa'),('apartamento'),('local'),('oficina'),('terreno')
ON CONFLICT(nombre) DO NOTHING;
INSERT INTO caracteristica(nombre) VALUES
('piscina'),('parqueadero'),('ascensor'),('gimnasio'),('balcon'),
('cocina integral'),('zona BBQ'),('porteria 24h'),('deposito'),('terraza')
ON CONFLICT(nombre) DO NOTHING;

-- Usuarios demo (claves reales con salt, listas para login):
-- admin@inmonova.com / Admin123*  |  demo@inmonova.com / Demo123*
INSERT INTO usuario(correo, clave_hash, salt, estado) VALUES
('admin@inmonova.com','5D8E2D7070658B4E62E96122660AFA1EE3C60AC5DC22B848B8D31A0A92','neonadmin1',1),
('demo@inmonova.com','438F3243E5D7DE55245FF52D18CB968BAC9ADD5F3257D727BF197C18DC906442','demosalt99',1)
ON CONFLICT(correo) DO NOTHING;
INSERT INTO usuario_rol(id_usuario, id_rol)
SELECT u.id_usuario, r.id_rol FROM usuario u, rol r
WHERE u.correo='admin@inmonova.com' AND r.nombre='administrador'
ON CONFLICT DO NOTHING;
INSERT INTO usuario_rol(id_usuario, id_rol)
SELECT u.id_usuario, r.id_rol FROM usuario u, rol r
WHERE u.correo='demo@inmonova.com' AND r.nombre='inmobiliaria'
ON CONFLICT DO NOTHING;
INSERT INTO perfil(id_usuario, nombres, apellidos, telefono)
SELECT id_usuario, 'Admin', 'InmoNova', '3000000001' FROM usuario WHERE correo='admin@inmonova.com'
ON CONFLICT DO NOTHING;
INSERT INTO perfil(id_usuario, nombres, apellidos, telefono)
SELECT id_usuario, 'Demo', 'Inmobiliaria', '3001234567' FROM usuario WHERE correo='demo@inmonova.com'
ON CONFLICT DO NOTHING;
INSERT INTO inmobiliaria(id_usuario, nombre_empresa, nit)
SELECT id_usuario, 'Demo Propiedades S.A.S', 'NIT900123456' FROM usuario WHERE correo='demo@inmonova.com'
ON CONFLICT DO NOTHING;

-- ---------- 8 PROPIEDADES DEMO ----------
INSERT INTO propiedad(id_inmobiliaria,id_ciudad,id_tipo,titulo,descripcion,precio,direccion,matricula_inmobiliaria,estado,destacada,activo)
SELECT i.id_inmobiliaria, c.id_ciudad, t.id_tipo, v.titulo, v.descripcion, v.precio, v.direccion, v.matricula, 'disponible', v.destacada, 1
FROM inmobiliaria i, (VALUES
 ('Bucaramanga','casa','Casa campestre El Tejar','Amplia casa de 2 pisos con jardín, 4 alcobas y estudio. Conjunto cerrado con piscina.',485000000,'Km 3 vía Piedecuesta','MI-DEMO-001',1),
 ('Floridablanca','apartamento','Apartamento Cañaveral piso 12','Apartamento moderno con vista panorámica, 3 alcobas, balcón y cocina integral.',320000000,'Cll 30 # 25-40, Cañaveral','MI-DEMO-002',1),
 ('Cartagena','apartamento','Apartamento Bocagrande vista al mar','Apartamento con vista a la bahía, 2 alcobas, balcón amplio y piscina comunitaria.',385000000,'Cra 1 # 12-50, Bocagrande','MI-DEMO-003',0),
 ('Bogota','oficina','Oficina Chapinero amoblada','Oficina lista para operar, 2 salas de juntas, fibra óptica y recepción.',450000000,'Cra 13 # 54-20, Of 301','MI-DEMO-004',1),
 ('Piedecuesta','terreno','Lote campestre Ruitoque','Lote plano de 1200 m² en condominio campestre con portería 24h.',260000000,'Cond. Ruitoque, lote 18','MI-DEMO-005',0),
 ('Medellin','apartamento','Apartaestudio Laureles','Acogedor apartaestudio cerca al metro, perfecto para inversión y renta corta.',215000000,'Cra 76 # 35-10, Ap 502','MI-DEMO-006',0),
 ('Cali','casa','Casa Granada con piscina','Casa remodelada con piscina privada, terraza BBQ y 3 parqueaderos.',620000000,'Av 9N # 15-60','MI-DEMO-007',1),
 ('Barranquilla','local','Local norte Barranquilla','Local en centro comercial del norte, vitrina amplia y depósito.',295000000,'Cll 98 # 52-120, L-14','MI-DEMO-008',0)
) AS v(ciudad, tipo, titulo, descripcion, precio, direccion, matricula, destacada)
INNER JOIN ciudad c ON c.nombre=v.ciudad
INNER JOIN tipo_propiedad t ON t.nombre=v.tipo
INNER JOIN usuario u ON u.correo='demo@inmonova.com' AND i.id_usuario=u.id_usuario
ON CONFLICT(matricula_inmobiliaria) DO NOTHING;

-- ---------- FOTOS ----------
INSERT INTO imagen_propiedad(id_propiedad, url)
SELECT p.id_propiedad, v.url FROM propiedad p,
(VALUES ('MI-DEMO-001','https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600'),
 ('MI-DEMO-002','https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600'),
 ('MI-DEMO-003','https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600'),
 ('MI-DEMO-004','https://images.unsplash.com/photo-1497366216548-37526070297c?w=600'),
 ('MI-DEMO-005','https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600'),
 ('MI-DEMO-006','https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600'),
 ('MI-DEMO-007','https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600'),
 ('MI-DEMO-008','https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=600')
) AS v(matricula, url)
WHERE p.matricula_inmobiliaria=v.matricula
AND NOT EXISTS (SELECT 1 FROM imagen_propiedad WHERE id_propiedad=p.id_propiedad);

-- ---------- CARACTERISTICAS N:M ----------
INSERT INTO propiedad_caracteristica(id_propiedad, id_caracteristica)
SELECT p.id_propiedad, ca.id_caracteristica FROM propiedad p, caracteristica ca,
(VALUES ('MI-DEMO-001','piscina'),('MI-DEMO-001','parqueadero'),('MI-DEMO-001','zona BBQ'),
 ('MI-DEMO-002','ascensor'),('MI-DEMO-002','balcon'),('MI-DEMO-002','cocina integral'),('MI-DEMO-002','gimnasio'),
 ('MI-DEMO-003','balcon'),('MI-DEMO-003','piscina'),
 ('MI-DEMO-004','ascensor'),('MI-DEMO-004','porteria 24h'),
 ('MI-DEMO-005','porteria 24h'),
 ('MI-DEMO-007','piscina'),('MI-DEMO-007','terraza'),('MI-DEMO-007','zona BBQ')
) AS v(matricula, caracteristica)
WHERE p.matricula_inmobiliaria=v.matricula AND ca.nombre=v.caracteristica
ON CONFLICT DO NOTHING;

-- Verificación: SELECT matricula_inmobiliaria, titulo FROM propiedad WHERE matricula_inmobiliaria LIKE 'MI-DEMO-%';
