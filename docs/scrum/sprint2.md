# Sprint 2 — Núcleo del negocio
## Planning
HU 5,6,7. CRUD propiedades 13pts, galería 5pts, filtros 5pts, perfil 3pts.
## Review
- `propiedad_nueva.jsp` inserta + N:M + foto default; matrícula duplicada capturada.
- `propiedad_editar/eliminar.jsp` solo dueño (JOIN con `i.id_usuario`), baja lógica `activo=0`.
- `imagenes.jsp` 1:N add/delete. `catalogo.jsp?q,tipo,ciudad`.
## Retrospective
Bien: validación dueño en SQL. Mejorar: paginación y subida real de archivos (Sprint 3 usa URL).
