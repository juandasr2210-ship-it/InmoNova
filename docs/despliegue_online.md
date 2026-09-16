# Despliegue en línea (puntos adicionales)
## BD online (elige 1)
- **Railway**: New → Database → MySQL → copia MYSQL_URL. Importa `01_schema` con DBeaver/TablePlus.
- **Aiven/FreeSQL**: crea MySQL gratis, importa SQL.
## App online
- **Render**: New → Web Service → sube este repo (Docker Tomcat) o usa `war`. Variable `db.url` = URL pública.
- Solo cambia `WEB-INF/web.xml` (`db.url/user/pass`), no cada JSP (cadena centralizada = requisito PDF).
## Local ya funciona
`http://localhost:8080/InmoNova/` con XAMPP (Apache+MySQL+Tomcat).
