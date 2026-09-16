<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
String sid=request.getParameter("id"); if(sid==null){ response.sendRedirect("dashboard.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Galería 1:N - Propiedad #<%= sid %></h2>
<%
if("POST".equalsIgnoreCase(request.getMethod())){
  String url=request.getParameter("url");
  if(url!=null&&!url.trim().isEmpty()){
    Connection c2=null;PreparedStatement p2=null;
    try{c2=abrirConexion(application);p2=c2.prepareStatement("INSERT INTO imagen_propiedad(id_propiedad,url) VALUES(?,?)");p2.setInt(1,Integer.parseInt(sid));p2.setString(2,url.trim());p2.executeUpdate();}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(p2!=null)p2.close();}catch(Exception x){}try{if(c2!=null)c2.close();}catch(Exception x){}}
  }
  if(request.getParameter("del")!=null){
    Connection c3=null;PreparedStatement p3=null;
    try{c3=abrirConexion(application);p3=c3.prepareStatement("DELETE FROM imagen_propiedad WHERE id_imagen=?");p3.setInt(1,Integer.parseInt(request.getParameter("del")));p3.executeUpdate();}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(p3!=null)p3.close();}catch(Exception x){}try{if(c3!=null)c3.close();}catch(Exception x){}}
  }
}
Connection con=null;PreparedStatement ps=null;ResultSet rs=null;
try{con=abrirConexion(application);ps=con.prepareStatement("SELECT id_imagen,url FROM imagen_propiedad WHERE id_propiedad=?");ps.setInt(1,Integer.parseInt(sid));rs=ps.executeQuery();
%><div class="row"><% while(rs.next()){ %>
<div class="col-md-3 mb-3"><div class="card"><img src="<%=rs.getString("url")%>" class="card-img-top" style="height:150px;object-fit:cover"><div class="card-body p-2"><form method="post"><input type="hidden" name="del" value="<%=rs.getInt(1)%>"><button class="btn btn-sm btn-danger">Eliminar</button></form></div></div></div>
<% } %></div><%
}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}}
%>
<form method="post" class="col-md-6"><label>Nueva URL imagen</label><div class="input-group"><input class="form-control" name="url" placeholder="https://..."><button class="btn btn-success">Agregar</button></div></form>
<a class="btn btn-secondary mt-3" href="dashboard.jsp">Volver</a>
<%@ include file="../includes/footer.jspf" %>
