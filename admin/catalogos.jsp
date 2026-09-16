<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"administrador".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Catálogos (tipos, ciudades, características)</h2>
<%
String msg="";
if("POST".equalsIgnoreCase(request.getMethod())){
  String tabla=request.getParameter("tabla"), nombre=request.getParameter("nombre");
  if(nombre!=null&&!nombre.trim().isEmpty()){
    Connection ca=null;java.sql.PreparedStatement pa=null;
    try{ca=abrirConexion(application);
      if("tipo".equals(tabla)) pa=ca.prepareStatement("INSERT INTO tipo_propiedad(nombre) VALUES(?)");
      else if("ciudad".equals(tabla)) pa=ca.prepareStatement("INSERT INTO ciudad(nombre,departamento) VALUES(?,'Santander')");
      else pa=ca.prepareStatement("INSERT INTO caracteristica(nombre) VALUES(?)");
      pa.setString(1,nombre.trim().toLowerCase());pa.executeUpdate();msg="Agregado ✅";
    }catch(Exception e){ msg="Error (¿duplicado UNIQUE?): "+e.getMessage(); }
    finally{try{if(pa!=null)pa.close();}catch(Exception x){}try{if(ca!=null)ca.close();}catch(Exception x){}}
  }
}
%>
<% if(!msg.isEmpty()){ %><div class="alert alert-info"><%=msg%></div><% } %>
<form method="post" class="row g-2 col-md-8"><div class="col-md-4"><select class="form-select" name="tabla"><option value="tipo">Tipo</option><option value="ciudad">Ciudad</option><option value="car">Característica</option></select></div>
<div class="col-md-5"><input class="form-control" name="nombre" required placeholder="Nombre nuevo"></div><div class="col-md-3"><button class="btn btn-success">Agregar</button></div></form>
<%@ include file="../includes/footer.jspf" %>
