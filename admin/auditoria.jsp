<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"administrador".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Auditoría (HU13)</h2>
<table class="table table-sm table-striped"><tr><th>Fecha</th><th>Usuario</th><th>Acción</th><th>Detalle</th></tr>
<%
Connection con=null;java.sql.Statement st=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);st=con.createStatement();
rs=st.executeQuery("SELECT a.fecha,u.correo,a.accion,a.detalle FROM auditoria a LEFT JOIN usuario u ON a.id_usuario=u.id_usuario ORDER BY a.id_auditoria DESC LIMIT 100");
while(rs.next()){ %><tr><td><%=rs.getTimestamp(1)%></td><td><%=rs.getString(2)==null?"-":rs.getString(2)%></td><td><%=rs.getString(3)%></td><td><%=rs.getString(4)==null?"":rs.getString(4)%></td></tr><% }
}catch(Exception e){%><tr><td colspan="4"><%=e.getMessage()%></td></tr><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(st!=null)st.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
</table>
<%@ include file="../includes/footer.jspf" %>
