<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"cliente".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Mis citas</h2><a class="btn btn-success btn-sm mb-2" href="cita_nueva.jsp">+ Nueva cita</a>
<table class="table table-striped"><tr><th>Propiedad</th><th>Fecha</th><th>Estado</th></tr>
<%
Connection con=null;java.sql.PreparedStatement ps=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT p.titulo,ci.fecha_hora,ci.estado FROM cita ci INNER JOIN propiedad p ON ci.id_propiedad=p.id_propiedad WHERE ci.id_cliente=? ORDER BY ci.fecha_hora DESC");
ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
while(rs.next()){ %><tr><td><%=rs.getString(1)%></td><td><%=rs.getTimestamp(2)%></td><td><%=rs.getString(3)%></td></tr><% }
}catch(Exception e){%><tr><td colspan="3"><%=e.getMessage()%></td></tr><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
</table>
<%@ include file="../includes/footer.jspf" %>
