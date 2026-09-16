<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"cliente".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Mis solicitudes</h2><a class="btn btn-success btn-sm mb-2" href="solicitud_nueva.jsp">+ Nueva</a>
<table class="table table-striped"><tr><th>#</th><th>Propiedad</th><th>Tipo</th><th>Estado</th></tr>
<%
Connection con=null;java.sql.PreparedStatement ps=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT s.id_solicitud,p.titulo,s.tipo,s.estado FROM solicitud s INNER JOIN propiedad p ON s.id_propiedad=p.id_propiedad WHERE s.id_cliente=? ORDER BY s.id_solicitud DESC");
ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
while(rs.next()){ %><tr><td><%=rs.getInt(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getString(3)%></td><td><span class="badge bg-info"><%=rs.getString(4)%></span></td></tr><% }
}catch(Exception e){%><tr><td colspan="4"><%=e.getMessage()%></td></tr><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
</table>
<%@ include file="../includes/footer.jspf" %>
