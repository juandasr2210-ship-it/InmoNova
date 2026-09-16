<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Citas de mis propiedades</h2>
<%
if(request.getParameter("id")!=null&&request.getParameter("est")!=null){
  Connection cu=null;java.sql.PreparedStatement pu=null;
  try{cu=abrirConexion(application);pu=cu.prepareStatement("UPDATE cita ci INNER JOIN propiedad p ON ci.id_propiedad=p.id_propiedad INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria SET ci.estado=? WHERE ci.id_cita=? AND i.id_usuario=?");
  pu.setString(1,request.getParameter("est"));pu.setInt(2,Integer.parseInt(request.getParameter("id")));pu.setInt(3,(Integer)session.getAttribute("usuario_id"));pu.executeUpdate();}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(pu!=null)pu.close();}catch(Exception x){}try{if(cu!=null)cu.close();}catch(Exception x){}}
}
Connection con=null;java.sql.PreparedStatement ps=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT ci.id_cita,p.titulo,ci.fecha_hora,ci.estado FROM cita ci INNER JOIN propiedad p ON ci.id_propiedad=p.id_propiedad INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria WHERE i.id_usuario=? ORDER BY ci.fecha_hora DESC");
ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
%><table class="table table-striped"><tr><th>Propiedad</th><th>Fecha</th><th>Estado</th><th>Acción</th></tr><%
while(rs.next()){ %><tr><td><%=rs.getString(2)%></td><td><%=rs.getTimestamp(3)%></td><td><%=rs.getString(4)%></td>
<td><a class="btn btn-sm btn-success" href="citas.jsp?id=<%=rs.getInt(1)%>&est=confirmada">Confirmar</a> <a class="btn btn-sm btn-danger" href="citas.jsp?id=<%=rs.getInt(1)%>&est=cancelada">Cancelar</a></td></tr><% }
%></table><%}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<%@ include file="../includes/footer.jspf" %>
