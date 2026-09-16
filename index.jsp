<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/conexion.jspf" %>

<!-- HU1: landing atractiva, buscador rapido + destacadas -->
<section class="hero text-center mb-4">
  <h1 class="display-5 fw-bold">Encuentra tu hogar con InmoNova</h1>
  <p>Casas, apartamentos, locales, oficinas y terrenos en Santander y Colombia</p>
  <form class="row g-2 justify-content-center" action="catalogo.jsp" method="get">
    <div class="col-12 col-md-3"><input class="form-control" name="q" placeholder="¿Qué buscas? Ej: casa Bucaramanga"></div>
    <div class="col-6 col-md-2">
      <select class="form-select" name="tipo">
        <option value="">Tipo</option><option value="casa">Casa</option><option value="apartamento">Apartamento</option>
        <option value="local">Local</option><option value="oficina">Oficina</option><option value="terreno">Terreno</option>
      </select>
    </div>
    <div class="col-6 col-md-2">
      <select class="form-select" name="ciudad">
        <option value="">Ciudad</option><option>Bucaramanga</option><option>Floridablanca</option><option>Giron</option>
      </select>
    </div>
    <div class="col-12 col-md-2 d-grid"><button class="btn btn-primary">Buscar</button></div>
  </form>
</section>

<h3>✨ Publicaciones destacadas</h3>
<div class="row">
<%
Connection con=null; PreparedStatement ps=null; ResultSet rs=null;
try{
  con=abrirConexion(application);
  // INNER JOIN 3+ tablas (PDF consulta obligatoria): propiedad+ciudad+tipo+inmobiliaria
  ps=con.prepareStatement("SELECT p.id_propiedad,p.titulo,p.precio,p.direccion,c.nombre AS ciudad,t.nombre AS tipo,i.nombre_empresa FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad INNER JOIN tipo_propiedad t ON p.id_tipo=t.id_tipo INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria WHERE p.activo=1 AND p.estado='disponible' ORDER BY p.destacada DESC LIMIT 6");
  rs=ps.executeQuery();
  boolean hay=false;
  while(rs.next()){ hay=true;
%>
  <div class="col-12 col-md-4 mb-3">
    <div class="card card-prop h-100">
      <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600" class="card-img-top" alt="inmueble">
      <div class="card-body">
        <span class="badge bg-success"><%= rs.getString("tipo") %> - <%= rs.getString("ciudad") %></span>
        <h5 class="mt-2"><%= rs.getString("titulo") %></h5>
        <p class="text-muted mb-1"><%= rs.getString("direccion") %> | <%= rs.getString("nombre_empresa") %></p>
        <p class="fw-bold text-primary">$ <%= rs.getBigDecimal("precio") %></p>
        <a class="btn btn-outline-primary btn-sm" href="detalle.jsp?id=<%= rs.getInt("id_propiedad") %>">Ver detalle</a>
      </div>
    </div>
  </div>
<% }
  if(!hay){ %>
  <div class="alert alert-info">Aún no hay propiedades. Importa el SQL y registra una inmobiliaria. <a href="registro.jsp">Crear cuenta</a></div>
<% }
}catch(Exception e){ %>
  <div class="alert alert-warning">BD no disponible (¿creaste <b>inmonova</b> en phpMyAdmin e importaste <b>sql/01_schema_inmonova.sql</b>?). Error: <%= e.getMessage() %></div>
<% } finally{ try{if(rs!=null)rs.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(con!=null)con.close();}catch(Exception x){} } %>
</div>

<div class="row mt-4">
  <div class="col-md-4"><h5>🔍 Busca y filtra</h5><p>Por ciudad, tipo, precio y características.</p></div>
  <div class="col-md-4"><h5>📅 Agenda visitas</h5><p>Sin cruces de agenda (UNIQUE propiedad+fecha).</p></div>
  <div class="col-md-4"><h5>🔒 Acceso por rol</h5><p>Cliente, inmobiliaria y administrador con paneles distintos.</p></div>
</div>

<%@ include file="includes/footer.jspf" %>
