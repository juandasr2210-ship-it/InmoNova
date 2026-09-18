# InmoNova
Parcial Programación en Java -  Sprints Inmobiliaria

## Base de datos en línea (Neon PostgreSQL)
1. En Neon → SQL Editor → base `inmonova` → pegar y ejecutar `sql/05_neon_postgres.sql` (no requiere CREATE DATABASE).
2. Copiar `postgresql-42.7.x.jar` a `C:\xampp\tomcat\lib` y reiniciar Tomcat.
3. En `WEB-INF/web.xml` poner (ver bloque comentado Neon):
   - `db.url` = `jdbc:postgresql://TU_ENDPOINT.neon.tech:5432/inmonova?sslmode=require`
   - `db.user` / `db.pass` de Neon, `db.driver` = `org.postgresql.Driver`
4. Abrir `http://localhost:8080/InmoNova/catalogo.jsp` (debe listar las 8 demos).
5. Para volver a local, restaurar los valores MySQL. Cuentas demo online: `admin@inmonova.com / Admin123*`, `demo@inmonova.com / Demo123*`. 
