<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/conexion.jspf" %>
<h2 class="sec-title">🏘️ Catálogo público</h2>
<form class="search-card row g-2 mb-4 p-3" method="get">
  <div class="col-md-4"><input class="form-control" name="q" value="<%= request.getParameter("q")==null?"":request.getParameter("q") %>" placeholder="Buscar título o dirección"></div>
  <div class="col-md-3"><select class="form-select" name="tipo"><option value="">Todos los tipos</option><option>casa</option><option>apartamento</option><option>local</option><option>oficina</option><option>terreno</option></select></div>
  <div class="col-md-3"><input class="form-control" name="ciudad" placeholder="Ciudad"></div>
  <div class="col-md-2 d-grid"><button class="btn btn-primary">Filtrar</button></div>
</form>
<div class="row">
<%
String q=request.getParameter("q"), tipo=request.getParameter("tipo"), ciudad=request.getParameter("ciudad");
Connection con=null; PreparedStatement ps=null; ResultSet rs=null;
try{
 con=abrirConexion(application);
 String sql="SELECT p.id_propiedad,p.titulo,p.precio,p.direccion,c.nombre AS ciudad,t.nombre AS tipo,(SELECT url FROM imagen_propiedad WHERE id_propiedad=p.id_propiedad LIMIT 1) AS foto FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad INNER JOIN tipo_propiedad t ON p.id_tipo=t.id_tipo WHERE p.activo=1";
 if(q!=null&&!q.trim().isEmpty()) sql+=" AND (p.titulo LIKE ? OR p.direccion LIKE ?)";
 if(tipo!=null&&!tipo.isEmpty()) sql+=" AND t.nombre=?";
 if(ciudad!=null&&!ciudad.isEmpty()) sql+=" AND c.nombre LIKE ?";
 ps=con.prepareStatement(sql);
 int i=1;
 if(q!=null&&!q.trim().isEmpty()){ ps.setString(i++,"%"+q.trim()+"%"); ps.setString(i++,"%"+q.trim()+"%"); }
 if(tipo!=null&&!tipo.isEmpty()) ps.setString(i++,tipo);
 if(ciudad!=null&&!ciudad.isEmpty()) ps.setString(i++,"%"+ciudad+"%");
 rs=ps.executeQuery();
  int total=0;
  while(rs.next()){ total++;
%>
 <div class="col-12 col-md-4 mb-4"><div class="card prop-card h-100">
   <img src="<%= rs.getString("foto")==null?"https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600":rs.getString("foto") %>" class="card-img-top" alt="inmueble" loading="lazy">
   <div class="card-body">
    <span class="badge badge-nova"><%= rs.getString("tipo") %></span>
    <span class="badge badge-city"><%= rs.getString("ciudad") %></span>
    <h5 class="mt-2 fw-bold"><%= rs.getString("titulo") %></h5>
    <p class="text-muted small mb-1"><%= rs.getString("direccion")==null?"":rs.getString("direccion") %></p>
    <p class="price">$ <%= rs.getBigDecimal("precio") %></p>
    <a href="detalle.jsp?id=<%= rs.getInt("id_propiedad") %>" class="btn btn-sm btn-primary">Detalle →</a>
   </div></div></div>
<% } if(total==0){ %><div class="col-12"><div class="alert alert-info">Sin resultados. Importa <b>sql/03_propiedades_demo.sql</b> en phpMyAdmin o ajusta los filtros.</div></div><% } }catch(Exception e){ %><div class="alert alert-danger">Error BD: <%= e.getMessage() %></div><% }
finally{ try{if(rs!=null)rs.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(con!=null)con.close();}catch(Exception x){} } %>
</div>
<%@ include file="includes/footer.jspf" %>
