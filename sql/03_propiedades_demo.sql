-- =====================================================
-- InmoNova - 03_propiedades_demo.sql
-- 8 propiedades listas para verse en catalogo + index
-- Idempotente: se puede importar varias veces (INSERT IGNORE / NOT EXISTS)
-- Requiere: sql/01_schema_inmonova.sql ya importado
-- Uso: phpMyAdmin -> BD inmonova -> Importar -> este archivo
-- Demo login agente: demo@inmonova.com / Demo123*
--   (hash SHA-256 MAYUS de 'demosalt99Demo123*')
-- =====================================================
USE inmonova;

-- Catálogos por si faltan
INSERT IGNORE INTO rol(nombre, descripcion) VALUES
('administrador','Acceso total'),('inmobiliaria','Agente que publica'),
('cliente','Compra/arrienda'),('visitante','No autenticado');
INSERT IGNORE INTO ciudad(nombre, departamento) VALUES
('Bucaramanga','Santander'),('Floridablanca','Santander'),('Giron','Santander'),
('Piedecuesta','Santander'),('Bogota','Cundinamarca'),('Medellin','Antioquia'),
('Cali','Valle'),('Barranquilla','Atlantico'),('Cartagena','Bolivar'),('Santa Marta','Magdalena');
INSERT IGNORE INTO tipo_propiedad(nombre) VALUES
('casa'),('apartamento'),('local'),('oficina'),('terreno');
INSERT IGNORE INTO caracteristica(nombre) VALUES
('piscina'),('parqueadero'),('ascensor'),('gimnasio'),('balcon'),
('cocina integral'),('zona BBQ'),('porteria 24h'),('deposito'),('terraza');

-- Usuario agente demo (si no existe)
INSERT IGNORE INTO usuario(correo, clave_hash, salt, estado) VALUES
('demo@inmonova.com','438F3243E5D7DE55245FF52D18CB968BAC9ADD5F3257D727BF197C18DC906442','demosalt99',1);
SET @uid = (SELECT id_usuario FROM usuario WHERE correo='demo@inmonova.com');
INSERT IGNORE INTO usuario_rol(id_usuario, id_rol)
SELECT @uid, id_rol FROM rol WHERE nombre='inmobiliaria';
INSERT IGNORE INTO perfil(id_usuario, nombres, apellidos, telefono) VALUES
(@uid, 'Demo', 'Inmobiliaria', '3001234567');
INSERT INTO inmobiliaria(id_usuario, nombre_empresa, nit)
SELECT @uid, 'Demo Propiedades S.A.S', 'NIT900123456'
WHERE NOT EXISTS (SELECT 1 FROM inmobiliaria WHERE id_usuario=@uid);
SET @inm = (SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario=@uid);

-- ---------- 8 PROPIEDADES ----------
INSERT IGNORE INTO propiedad(id_inmobiliaria,id_ciudad,id_tipo,titulo,descripcion,precio,direccion,matricula_inmobiliaria,estado,destacada,activo) VALUES
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Bucaramanga'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='casa'),
 'Casa campestre El Tejar','Amplia casa de 2 pisos con jardín, 4 alcobas y estudio. Conjunto cerrado con piscina.',485000000,'Km 3 vía Piedecuesta','MI-DEMO-001','disponible',1,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Floridablanca'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='apartamento'),
 'Apartamento Cañaveral piso 12','Apartamento moderno con vista panorámica, 3 alcobas, balcón y cocina integral.',320000000,'Cll 30 # 25-40, Cañaveral','MI-DEMO-002','disponible',1,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Cartagena'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='apartamento'),
 'Apartamento Bocagrande vista al mar','Apartamento con vista a la bahía, 2 alcobas, balcón amplio y piscina comunitaria.',385000000,'Cra 1 # 12-50, Bocagrande','MI-DEMO-003','disponible',0,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Bogota'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='oficina'),
 'Oficina Chapinero amoblada','Oficina lista para operar, 2 salas de juntas, fibra óptica y recepción.',450000000,'Cra 13 # 54-20, Of 301','MI-DEMO-004','disponible',1,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Piedecuesta'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='terreno'),
 'Lote campestre Ruitoque','Lote plano de 1200 m² en condominio campestre con portería 24h.',260000000,'Cond. Ruitoque, lote 18','MI-DEMO-005','disponible',0,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Medellin'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='apartamento'),
 'Apartaestudio Laureles','Acogedor apartaestudio cerca al metro, perfecto para inversión y renta corta.',215000000,'Cra 76 # 35-10, Ap 502','MI-DEMO-006','disponible',0,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Cali'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='casa'),
 'Casa Granada con piscina','Casa remodelada con piscina privada, terraza BBQ y 3 parqueaderos.',620000000,'Av 9N # 15-60','MI-DEMO-007','disponible',1,1),
(@inm,(SELECT id_ciudad FROM ciudad WHERE nombre='Barranquilla'),(SELECT id_tipo FROM tipo_propiedad WHERE nombre='local'),
 'Local norte Barranquilla','Local en centro comercial del norte, vitrina amplia y depósito.',295000000,'Cll 98 # 52-120, L-14','MI-DEMO-008','disponible',0,1);

-- ---------- FOTOS (1 por propiedad, sin duplicar) ----------
SET @p1=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-001');
SET @p2=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-002');
SET @p3=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-003');
SET @p4=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-004');
SET @p5=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-005');
SET @p6=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-006');
SET @p7=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-007');
SET @p8=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-008');
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p1,'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p1);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p2,'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p2);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p3,'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p3);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p4,'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p4);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p5,'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p5);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p6,'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p6);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p7,'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p7);
INSERT INTO imagen_propiedad(id_propiedad,url) SELECT @p8,'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=600' WHERE NOT EXISTS(SELECT 1 FROM imagen_propiedad WHERE id_propiedad=@p8);

-- ---------- CARACTERISTICAS N:M ----------
INSERT IGNORE INTO propiedad_caracteristica(id_propiedad,id_caracteristica) VALUES
(@p1,(SELECT id_caracteristica FROM caracteristica WHERE nombre='piscina')),
(@p1,(SELECT id_caracteristica FROM caracteristica WHERE nombre='parqueadero')),
(@p1,(SELECT id_caracteristica FROM caracteristica WHERE nombre='zona BBQ')),
(@p2,(SELECT id_caracteristica FROM caracteristica WHERE nombre='ascensor')),
(@p2,(SELECT id_caracteristica FROM caracteristica WHERE nombre='balcon')),
(@p2,(SELECT id_caracteristica FROM caracteristica WHERE nombre='cocina integral')),
(@p2,(SELECT id_caracteristica FROM caracteristica WHERE nombre='gimnasio')),
(@p3,(SELECT id_caracteristica FROM caracteristica WHERE nombre='balcon')),
(@p3,(SELECT id_caracteristica FROM caracteristica WHERE nombre='piscina')),
(@p4,(SELECT id_caracteristica FROM caracteristica WHERE nombre='ascensor')),
(@p4,(SELECT id_caracteristica FROM caracteristica WHERE nombre='porteria 24h')),
(@p5,(SELECT id_caracteristica FROM caracteristica WHERE nombre='porteria 24h')),
(@p7,(SELECT id_caracteristica FROM caracteristica WHERE nombre='piscina')),
(@p7,(SELECT id_caracteristica FROM caracteristica WHERE nombre='terraza')),
(@p7,(SELECT id_caracteristica FROM caracteristica WHERE nombre='zona BBQ'));

-- Verificación: debe mostrar 8 filas
-- SELECT matricula_inmobiliaria, titulo, precio FROM propiedad WHERE matricula_inmobiliaria LIKE 'MI-DEMO-%';
