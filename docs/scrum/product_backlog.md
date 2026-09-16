# Product Backlog (PO: Profesor — priorizado)

| # | HU | Prioridad | Sprint | DoD |
|---|----|-----------|--------|-----|
| 1 | Landing atractiva + buscador | Alta | 1 | `index.jsp` responsive, destacadas, link registro/login |
| 2 | Registro correo único validado | Alta | 1 | UNIQUE capturado, mensaje claro, hash+salt |
| 3 | Login/logout + redirección por rol | Alta | 1 | Sesión id+rol, dashboard propio, logout invalida |
| 4 | Asignar/revocar roles | Alta | 3 | `admin/usuarios.jsp` + validación servidor |
| 5 | Perfil 1:1 | Media | 2 | `perfil.jsp` update, documento UNIQUE |
| 6 | CRUD propiedades + fotos + características | Alta | 2 | Crear/editar/baja lógica, 1:N y N:M |
| 7 | Buscar/filtrar | Alta | 2 | `catalogo.jsp?q,tipo,ciudad` con INNER JOIN |
| 8 | Favoritos | Media | 3 | `cliente/favoritos.jsp` PK compuesta |
| 9 | Citas sin cruces | Media | 3 | UNIQUE(propiedad,fecha), confirmar/cancelar |
| 10 | Radicar docs + estado | Media | 3 | `solicitudes.jsp` |
| 11 | Aprobar/rechazar | Media | 3 | `inmobiliaria/solicitudes.jsp` |
| 12 | Reporte ciudad/estado agregación | Media | 3 | GROUP BY+HAVING en `admin/reportes.jsp` |
| 13 | Auditoría | Baja | 3 | `admin/auditoria.jsp` |
