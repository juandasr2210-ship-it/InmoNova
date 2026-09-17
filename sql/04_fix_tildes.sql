-- Fix tildes corruptas por importacion en cp850 (importar con utf8mb4)
-- Uso: "C:\xampp\mysql\bin\mysql.exe" --default-character-set=utf8mb4 -u root inmonova < sql/04_fix_tildes.sql
USE inmonova;
UPDATE propiedad SET titulo='Casa campestre El Tejar', descripcion='Amplia casa de 2 pisos con jardín, 4 alcobas y estudio. Conjunto cerrado con piscina.' WHERE matricula_inmobiliaria='MI-DEMO-001';
UPDATE propiedad SET titulo='Apartamento Cañaveral piso 12', descripcion='Apartamento moderno con vista panorámica, 3 alcobas, balcón y cocina integral.' WHERE matricula_inmobiliaria='MI-DEMO-002';
UPDATE propiedad SET titulo='Apartamento Bocagrande vista al mar', descripcion='Apartamento con vista a la bahía, 2 alcobas, balcón amplio y piscina comunitaria.' WHERE matricula_inmobiliaria='MI-DEMO-003';
UPDATE propiedad SET titulo='Oficina Chapinero amoblada', descripcion='Oficina lista para operar, 2 salas de juntas, fibra óptica y recepción.' WHERE matricula_inmobiliaria='MI-DEMO-004';
UPDATE propiedad SET titulo='Lote campestre Ruitoque', descripcion='Lote plano de 1200 m² en condominio campestre con portería 24h.' WHERE matricula_inmobiliaria='MI-DEMO-005';
UPDATE propiedad SET titulo='Apartaestudio Laureles', descripcion='Acogedor apartaestudio cerca al metro, perfecto para inversión y renta corta.' WHERE matricula_inmobiliaria='MI-DEMO-006';
UPDATE propiedad SET titulo='Casa Granada con piscina', descripcion='Casa remodelada con piscina privada, terraza BBQ y 3 parqueaderos.' WHERE matricula_inmobiliaria='MI-DEMO-007';
UPDATE propiedad SET titulo='Local norte Barranquilla', descripcion='Local en centro comercial del norte, vitrina amplia y depósito.' WHERE matricula_inmobiliaria='MI-DEMO-008';
-- Verificación: debe dar 0 filas (ya sin bytes E294 corruptos)
-- SELECT matricula_inmobiliaria FROM propiedad WHERE HEX(titulo) LIKE '%E294%' OR HEX(descripcion) LIKE '%E294%';
