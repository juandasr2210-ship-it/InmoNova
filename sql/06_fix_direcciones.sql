-- Fix direcciones corruptas por importacion en cp850 (importar con utf8mb4)
-- Uso: "C:\xampp\mysql\bin\mysql.exe" --default-character-set=utf8mb4 -u root inmonova < sql/06_fix_direcciones.sql
USE inmonova;
UPDATE propiedad SET direccion='Km 3 vía Piedecuesta' WHERE matricula_inmobiliaria='MI-DEMO-001';
UPDATE propiedad SET direccion='Cll 30 # 25-40, Cañaveral' WHERE matricula_inmobiliaria='MI-DEMO-002';
-- Verificación: debe dar 0 filas
-- SELECT matricula_inmobiliaria FROM propiedad WHERE HEX(direccion) LIKE '%E294%';
