<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/conexion.jspf" %>
<%
String sid=request.getParameter("id");
Connection con=null; PreparedStatement ps=null,ps2=null,ps3=null; ResultSet rs=null,rc=null,ri=null;
try{
 con=abrirConexion(application);
 ps=con.prepareStatement("SELECT p.*,c.nombre AS ciudad,t.nombre AS tipo,i.nombre_empresa FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad INNER JOIN tipo_propiedad t ON p.id_tipo=t.id_tipo INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria WHERE p.id_propiedad=?");
 ps.setInt(1,Integer.parseInt(sid)); rs=ps.executeQuery();
 if(rs.next()){
%>
<h2><%= rs.getString("titulo") %></h2>
<p><span class="badge bg-info"><%= rs.getString("tipo") %></span> <span class="badge bg-secondary"><%= rs.getString("ciudad") %></span></p>
<p class="fs-4 text-primary fw-bold">$ <%= rs.getBigDecimal("precio") %></p>
<p><%= rs.getString("descripcion")==null?"Sin descripción":rs.getString("descripcion") %></p>
<p><b>Matrícula:</b> <%= rs.getString("matricula_inmobiliaria") %> | <b>Inmobiliaria:</b> <%= rs.getString("nombre_empresa") %></p>
<h5>Características (relación N:M)</h5><ul>
<% ps2=con.prepareStatement("SELECT ca.nombre,pc.cantidad FROM propiedad_caracteristica pc INNER JOIN caracteristica ca ON pc.id_caracteristica=ca.id_caracteristica WHERE pc.id_propiedad=?"); ps2.setInt(1,rs.getInt("id_propiedad")); rc=ps2.executeQuery(); boolean hc=false; while(rc.next()){hc=true; %><li><%= rc.getString("nombre") %> (x<%= rc.getInt("cantidad") %>)</li><% } if(!hc){ %><li class="text-muted">Sin características registradas</li><% } %>
</ul>
<% String rol=(String)session.getAttribute("usuario_rol"); if(rol==null){ %>
<div class="alert alert-warning">Inicia sesión para agendar visita o ver contacto completo. <a href="login.jsp">Ingresar</a></div>
<% } else { %><a class="btn btn-success" href="<%= "cliente".equals(rol)?"cliente/dashboard.jsp":"inmobiliaria/dashboard.jsp" %>">Ir a mi panel</a><% } %>
<% } else { %><div class="alert alert-danger">Propiedad no encontrada</div><% }
}catch(Exception e){ %><div class="alert alert-danger">Error: <%= e.getMessage() %></div><% }
finally{ try{if(rs!=null)rs.close();}catch(Exception x){} try{if(rc!=null)rc.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(ps2!=null)ps2.close();}catch(Exception x){} try{if(con!=null)con.close();}catch(Exception x){} } %>
<%@ include file="includes/footer.jspf" %>
