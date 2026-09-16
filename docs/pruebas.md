# Pruebas (manuales + unitarias mínimas)
- [ ] Registro duplicado → mensaje, no excepción.
- [ ] Login malo → error=1; inactivo → error=inactivo.
- [ ] Sin sesión → `/admin/dashboard.jsp` → denegado. Cliente → `/admin/` → denegado.
- [ ] Matrícula duplicada → mensaje UNIQUE. Cita mismo horario → horario ocupado.
- [ ] Reportes cargan con GROUP BY. Auditoría registra login.
- SQL: ejecutar `docs/consultas_obligatorias.sql` las 5 OK.
