-- Consultas obligatorias PDF (probar en phpMyAdmin, ya usadas en JSP)
-- 1) INNER JOIN 3+ tablas (index.jsp, catalogo.jsp)
SELECT p.titulo, c.nombre AS ciudad, t.nombre AS tipo, i.nombre_empresa FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad INNER JOIN tipo_propiedad t ON p.id_tipo=t.id_tipo INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria WHERE p.activo=1;
-- 2) N:M caracteristicas (detalle.jsp)
SELECT p.titulo, ca.nombre FROM propiedad p INNER JOIN propiedad_caracteristica pc ON p.id_propiedad=pc.id_propiedad INNER JOIN caracteristica ca ON pc.id_caracteristica=ca.id_caracteristica WHERE p.id_propiedad=1;
-- 3) N:M roles (admin/usuarios.jsp)
SELECT u.correo, r.nombre FROM usuario u INNER JOIN usuario_rol ur ON u.id_usuario=ur.id_usuario INNER JOIN rol r ON ur.id_rol=r.id_rol;
-- 4) LEFT JOIN sin citas (admin/reportes.jsp)
SELECT p.id_propiedad, p.titulo FROM propiedad p LEFT JOIN cita ci ON p.id_propiedad=ci.id_propiedad WHERE ci.id_cita IS NULL;
-- 5) GROUP BY + HAVING (admin/reportes.jsp)
SELECT c.nombre, p.estado, COUNT(*) total FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad GROUP BY c.nombre, p.estado HAVING COUNT(*)>=1;
