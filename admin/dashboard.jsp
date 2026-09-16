<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"administrador".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<h2>Panel Administrador</h2>
<div class="list-group col-md-6">
<a class="list-group-item" href="usuarios.jsp">👥 Usuarios y roles</a>
<a class="list-group-item" href="catalogos.jsp">⚙️ Catálogos (tipos, ciudades, características)</a>
<a class="list-group-item" href="reportes.jsp">📊 Reportes (GROUP BY + HAVING)</a>
<a class="list-group-item" href="auditoria.jsp">📝 Auditoría</a>
<a class="list-group-item" href="../perfil.jsp">👤 Mi perfil</a>
</div>
<%@ include file="../includes/footer.jspf" %>
