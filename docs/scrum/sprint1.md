# Sprint 1 — Cimientos y acceso (7 días)
## Planning
HU 1,2,3. Estimación: landing 5pts, registro 8pts, login 8pts. Roles: SM (compañero A), Dev Team (A+B), PO Profesor.
## Review (demo)
- `index.jsp` muestra destacadas (INNER JOIN 3 tablas).
- Registro duplicado → "el correo ya se encuentra registrado" (no stacktrace).
- Login cliente→`/cliente/dashboard.jsp`, agente→`/inmobiliaria/`, admin→`/admin/`. URL directa sin sesión → `acceso-denegado.jsp`.
## Retrospective
Bien: conexión centralizada. Mejorar: agregar salt (se hizo), validar formato correo en servidor y cliente.
