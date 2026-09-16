<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id");
if(oid==null){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/conexion.jspf" %>
<h2>Mi perfil (relación 1:1 usuario→perfil)</h2>
<%
String msg="";
if("POST".equalsIgnoreCase(request.getMethod())){
  Connection cu=null;PreparedStatement pu=null;
  try{cu=abrirConexion(application);
    pu=cu.prepareStatement("UPDATE perfil SET nombres=?,apellidos=?,documento=?,telefono=?,direccion=? WHERE id_usuario=?");
    pu.setString(1,request.getParameter("nombres")); pu.setString(2,request.getParameter("apellidos"));
    pu.setString(3,request.getParameter("documento")); pu.setString(4,request.getParameter("telefono"));
    pu.setString(5,request.getParameter("direccion")); pu.setInt(6,(Integer)session.getAttribute("usuario_id"));
    pu.executeUpdate(); msg="Perfil actualizado ✅";
  }catch(Exception e){ msg="Error: "+e.getMessage(); }
  finally{try{if(pu!=null)pu.close();}catch(Exception x){}try{if(cu!=null)cu.close();}catch(Exception x){}}
}
Connection con=null;PreparedStatement ps=null;ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT * FROM perfil WHERE id_usuario=?");ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
if(rs.next()){
%>
<% if(!msg.isEmpty()){ %><div class="alert alert-info"><%= msg %></div><% } %>
<form method="post" class="col-md-6">
 <div class="mb-2"><label>Nombres</label><input class="form-control" name="nombres" value="<%= rs.getString("nombres") %>" required></div>
 <div class="mb-2"><label>Apellidos</label><input class="form-control" name="apellidos" value="<%= rs.getString("apellidos") %>" required></div>
 <div class="mb-2"><label>Documento (UNIQUE)</label><input class="form-control" name="documento" value="<%= rs.getString("documento")==null?"":rs.getString("documento") %>"></div>
 <div class="mb-2"><label>Teléfono</label><input class="form-control" name="telefono" value="<%= rs.getString("telefono")==null?"":rs.getString("telefono") %>"></div>
 <div class="mb-2"><label>Dirección</label><input class="form-control" name="direccion" value="<%= rs.getString("direccion")==null?"":rs.getString("direccion") %>"></div>
 <button class="btn btn-primary">Guardar</button>
</form>
<% }}catch(Exception e){ %><div class="alert alert-danger"><%= e.getMessage() %></div><% }
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<%@ include file="includes/footer.jspf" %>
