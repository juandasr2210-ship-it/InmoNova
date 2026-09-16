<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"cliente".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Panel Cliente</h2><p>Hola <b><%= session.getAttribute("usuario_correo") %></b> | <a href="../perfil.jsp">Mi perfil (1:1)</a></p>
<p><a class="btn btn-sm btn-primary" href="../catalogo.jsp">Buscar propiedades</a> <a class="btn btn-sm btn-success" href="cita_nueva.jsp">Agendar visita</a> <a class="btn btn-sm btn-info" href="citas.jsp">Mis citas</a> <a class="btn btn-sm btn-warning" href="favoritos.jsp">Favoritos</a> <a class="btn btn-sm btn-secondary" href="solicitudes.jsp">Mis solicitudes</a></p>
<div class="row"><div class="col-md-6"><h5>Mis próximas citas</h5>
<%
Connection con=null;java.sql.PreparedStatement ps=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT ci.fecha_hora,ci.estado,p.titulo FROM cita ci INNER JOIN propiedad p ON ci.id_propiedad=p.id_propiedad WHERE ci.id_cliente=? ORDER BY ci.fecha_hora DESC LIMIT 5");
ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
while(rs.next()){ %><div>📅 <%= rs.getTimestamp(1) %> - <%= rs.getString(3) %> (<%= rs.getString(2) %>)</div><% }
}catch(Exception e){ %><div class="alert alert-warning"><%= e.getMessage() %></div><% }
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
</div><div class="col-md-6"><h5>Mis solicitudes</h5>
<%
Connection c2=null;java.sql.PreparedStatement p2=null;java.sql.ResultSet r2=null;
try{c2=abrirConexion(application);
p2=c2.prepareStatement("SELECT s.estado,p.titulo FROM solicitud s INNER JOIN propiedad p ON s.id_propiedad=p.id_propiedad WHERE s.id_cliente=? LIMIT 5");
p2.setInt(1,(Integer)session.getAttribute("usuario_id"));r2=p2.executeQuery();
while(r2.next()){ %><div>📄 <%= r2.getString(2) %> - <b><%= r2.getString(1) %></b></div><% }
}catch(Exception e){ %><div class="alert alert-warning"><%= e.getMessage() %></div><% }
finally{try{if(r2!=null)r2.close();}catch(Exception x){}try{if(p2!=null)p2.close();}catch(Exception x){}try{if(c2!=null)c2.close();}catch(Exception x){}} %>
</div></div>
<%@ include file="../includes/footer.jspf" %>
