<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Solicitudes recibidas (HU11: aprobar/rechazar)</h2>
<%
if(request.getParameter("id")!=null){
  Connection cu=null;java.sql.PreparedStatement pu=null;
  try{cu=abrirConexion(application);pu=cu.prepareStatement("UPDATE solicitud s INNER JOIN propiedad p ON s.id_propiedad=p.id_propiedad INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria SET s.estado=? WHERE s.id_solicitud=? AND i.id_usuario=?");
  pu.setString(1,request.getParameter("est"));pu.setInt(2,Integer.parseInt(request.getParameter("id")));pu.setInt(3,(Integer)session.getAttribute("usuario_id"));pu.executeUpdate();}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(pu!=null)pu.close();}catch(Exception x){}try{if(cu!=null)cu.close();}catch(Exception x){}}
}
Connection con=null;java.sql.PreparedStatement ps=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT s.id_solicitud,p.titulo,s.tipo,s.estado,u.correo FROM solicitud s INNER JOIN propiedad p ON s.id_propiedad=p.id_propiedad INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria INNER JOIN usuario u ON s.id_cliente=u.id_usuario WHERE i.id_usuario=? ORDER BY s.id_solicitud DESC");
ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
%><table class="table table-striped"><tr><th>#</th><th>Propiedad</th><th>Cliente</th><th>Tipo</th><th>Estado</th><th>Acción</th></tr><%
while(rs.next()){ %><tr><td><%=rs.getInt(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getString(5)%></td><td><%=rs.getString(3)%></td><td><%=rs.getString(4)%></td>
<td><a class="btn btn-sm btn-success" href="solicitudes.jsp?id=<%=rs.getInt(1)%>&est=aprobada">Aprobar</a> <a class="btn btn-sm btn-danger" href="solicitudes.jsp?id=<%=rs.getInt(1)%>&est=rechazada">Rechazar</a></td></tr><% }
%></table><%}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<%@ include file="../includes/footer.jspf" %>
