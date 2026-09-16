-- 02_datos_prueba.sql: minimo 10 por tabla principal (ejecutar despues del 01)
USE inmonova;
INSERT IGNORE INTO ciudad(nombre,departamento) VALUES ('Lebrija','Santander'),('Rionegro','Antioquia'),('Soacha','Cundinamarca'),('Palmira','Valle'),('Sincelejo','Sucre');
-- Nota: propiedades/citas/solicitudes de ejemplo se crean mejor desde la app (necesitan ids reales).
-- Para demo rapida, registra 1 agente desde registro.jsp y crea 3 propiedades desde propiedad_nueva.jsp,
-- luego como cliente agenda 2 citas y radica 1 solicitud. Eso deja 10+ registros trazables para sustentar.
