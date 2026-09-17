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
<div class="row g-4">
<div class="col-12 col-lg-7">
<div class="panel-card p-2">
<% ps3=con.prepareStatement("SELECT url FROM imagen_propiedad WHERE id_propiedad=?"); ps3.setInt(1,rs.getInt("id_propiedad")); ri=ps3.executeQuery(); boolean hi=false; while(ri.next()){ hi=true; %>
<img src="<%= ri.getString(1) %>" class="img-fluid rounded-4 mb-2" alt="foto inmueble" loading="lazy">
<% } if(!hi){ %><img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=900" class="img-fluid rounded-4" alt="foto inmueble"><% } %>
</div>
</div>
<div class="col-12 col-lg-5">
<div class="panel-card">
<h2 class="fw-bold"><%= rs.getString("titulo") %></h2>
<p><span class="badge badge-nova"><%= rs.getString("tipo") %></span> <span class="badge badge-city"><%= rs.getString("ciudad") %></span></p>
<p class="price fs-3">$ <%= rs.getBigDecimal("precio") %></p>
<p class="text-muted"><%= rs.getString("descripcion")==null?"Sin descripción":rs.getString("descripcion") %></p>
<p class="small"><b>Matrícula:</b> <%= rs.getString("matricula_inmobiliaria") %><br><b>Inmobiliaria:</b> <%= rs.getString("nombre_empresa") %></p>
<h5 class="mt-3">Características</h5><ul class="mb-3">
<% ps2=con.prepareStatement("SELECT ca.nombre,pc.cantidad FROM propiedad_caracteristica pc INNER JOIN caracteristica ca ON pc.id_caracteristica=ca.id_caracteristica WHERE pc.id_propiedad=?"); ps2.setInt(1,rs.getInt("id_propiedad")); rc=ps2.executeQuery(); boolean hc=false; while(rc.next()){hc=true; %><li><%= rc.getString("nombre") %> (x<%= rc.getInt("cantidad") %>)</li><% } if(!hc){ %><li class="text-muted">Sin características registradas</li><% } %>
</ul>
<% String rol=(String)session.getAttribute("usuario_rol"); if(rol==null){ %>
<div class="alert alert-warning">Inicia sesión para agendar visita o ver contacto completo. <a href="login.jsp">Ingresar</a></div>
<% } else if("cliente".equals(rol)){ %>
<div class="d-flex gap-2 flex-wrap">
<a class="btn btn-success" href="cliente/cita_nueva.jsp?id_prop=<%= rs.getInt("id_propiedad") %>">📅 Agendar visita</a>
<a class="btn btn-outline-primary" href="cliente/favoritos.jsp?add=<%= rs.getInt("id_propiedad") %>">⭐ Favorito</a>
<a class="btn btn-outline-secondary" href="cliente/solicitud_nueva.jsp">📄 Solicitar</a>
</div>
<% } else { %><a class="btn btn-success" href="inmobiliaria/dashboard.jsp">Ir a mi panel</a><% } %>
</div></div></div>
<% } else { %><div class="alert alert-danger">Propiedad no encontrada</div><% }
}catch(Exception e){ %><div class="alert alert-danger">Error: <%= e.getMessage() %></div><% }
finally{ try{if(rs!=null)rs.close();}catch(Exception x){} try{if(rc!=null)rc.close();}catch(Exception x){} try{if(ri!=null)ri.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(ps2!=null)ps2.close();}catch(Exception x){} try{if(ps3!=null)ps3.close();}catch(Exception x){} try{if(con!=null)con.close();}catch(Exception x){} } %>
<%@ include file="includes/footer.jspf" %>
