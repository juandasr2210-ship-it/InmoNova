<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/conexion.jspf" %>
<h2>Catálogo público</h2>
<form class="row g-2 mb-3" method="get">
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
 String sql="SELECT p.id_propiedad,p.titulo,p.precio,p.direccion,c.nombre AS ciudad,t.nombre AS tipo FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad INNER JOIN tipo_propiedad t ON p.id_tipo=t.id_tipo WHERE p.activo=1";
 if(q!=null&&!q.trim().isEmpty()) sql+=" AND (p.titulo LIKE ? OR p.direccion LIKE ?)";
 if(tipo!=null&&!tipo.isEmpty()) sql+=" AND t.nombre=?";
 if(ciudad!=null&&!ciudad.isEmpty()) sql+=" AND c.nombre LIKE ?";
 ps=con.prepareStatement(sql);
 int i=1;
 if(q!=null&&!q.trim().isEmpty()){ ps.setString(i++,"%"+q.trim()+"%"); ps.setString(i++,"%"+q.trim()+"%"); }
 if(tipo!=null&&!tipo.isEmpty()) ps.setString(i++,tipo);
 if(ciudad!=null&&!ciudad.isEmpty()) ps.setString(i++,"%"+ciudad+"%");
 rs=ps.executeQuery();
 while(rs.next()){
%>
 <div class="col-12 col-md-4 mb-3"><div class="card h-100"><div class="card-body">
  <h5><%= rs.getString("titulo") %></h5>
  <p><%= rs.getString("ciudad") %> - <%= rs.getString("tipo") %><br>$ <%= rs.getBigDecimal("precio") %></p>
  <a href="detalle.jsp?id=<%= rs.getInt("id_propiedad") %>" class="btn btn-sm btn-primary">Detalle</a>
 </div></div></div>
<% } }catch(Exception e){ %><div class="alert alert-danger">Error BD: <%= e.getMessage() %></div><% }
finally{ try{if(rs!=null)rs.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(con!=null)con.close();}catch(Exception x){} } %>
</div>
<%@ include file="includes/footer.jspf" %>
