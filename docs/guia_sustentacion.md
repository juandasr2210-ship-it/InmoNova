# Guía sustentación (2-3 min por persona, 40+30+30)

1. **Modelo (30pts)**: abre `docs/MER.svg`. Señala 1:1 (`perfil.id_usuario UNIQUE`), 1:N (`imagen FK CASCADE`), N:M (`usuario_rol PK compuesta`). Muestra 3 UNIQUE y el `DDL` con `ON DELETE/UPDATE`. Ejecuta las 5 consultas de `docs/consultas_obligatorias.sql` en phpMyAdmin.
2. **App + roles (40pts)**: demo en vivo: visitante ve landing sin contacto completo → registra cliente (duplicado muestra mensaje, no excepción) → login redirige a su panel → URL `/admin/` sin rol → denegado. Agente crea propiedad + foto. Cliente agenda cita duplicada → horario ocupado. Admin muestra reportes GROUP BY y auditoría. Recalca: hash+salt, sesión, validación servidor (no solo ocultar menú).
3. **Scrum (30pts)**: muestra `docs/scrum/*`, commits Git y link/captura Padlet. Explica qué hiciste cada sprint y qué mejorarías.
Frases clave: "baja lógica", "cadena centralizada en web.xml", "PK compuesta evita duplicados".
