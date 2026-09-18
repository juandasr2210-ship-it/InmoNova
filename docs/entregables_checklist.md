# Checklist entregables — InmoNova ✅/⬜

- [x] **Código fuente**: 30 JSP/JSPF, `WEB-INF/web.xml`, `sql/01` + `02`, `src/` legacy. Git: 3 commits (Sprint 1/2/3).
- [x] **Docs Scrum**: `docs/scrum/product_backlog.md`, `sprint1/2/3.md` (planning+review+retro).
- [x] **Modelo**: `docs/MER.pdf`, `docs/relacional.pdf` (+ `.svg` y exportadores `.html`) y documento completo `docs/InmoNova_Docs.pdf`.
- [x] **Diccionario + consultas**: `docs/diccionario_datos.md`, `docs/consultas_obligatorias.sql` (5 consultas).
- [x] **Pruebas**: `docs/pruebas.md`.
- [x] **Padlet**: tablero https://padlet.com/juandasr2210/scrum-s023o8bc00b6jj6vhgqj + captura `docs/padlet_captura.jpeg` + PDFs `docs/scrum/Sprint_1/2/3_InmoNova.pdf`.
- [x] **Repo público**: https://github.com/juandasr2210-ship-it/InmoNova (ver sección Publicar).
- [ ] **En línea**: `docs/despliegue_online.md` (Railway + Render).
- [ ] **Sustentación**: `docs/guia_sustentacion.md` (ensayar 5 min por persona).

## Publicar (ejecutar una vez creado el repo vacío en GitHub)
```powershell
& "C:\Program Files\Git\bin\git.exe" remote add origin https://github.com/TU_USUARIO/InmoNova.git
& "C:\Program Files\Git\bin\git.exe" branch -M main
& "C:\Program Files\Git\bin\git.exe" push -u origin main
```
Verifica: tu GitHub muestra README + 3 commits.

## Verificación 2026-09-16 (ejecutada en tu máquina)
- Git local: 4 commits en `main`, árbol limpio, **sin remote** (pendiente que crees el repo en GitHub).
- Código: 26 `.jsp` + `includes/*.jspf` + `WEB-INF/web.xml` + `sql/01` y `02` presentes.
- XAMPP: MySQL apagado (error 2002) y puerto 8080 cerrado → enciende MySQL y Tomcat en el panel XAMPP y abre `http://localhost:8080/InmoNova/`.
- Faltan (requieren tu cuenta/navegador): `docs/MER.pdf`, `docs/relacional.pdf`, `docs/padlet_captura.png`, push a GitHub, despliegue en línea.
