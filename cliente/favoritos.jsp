<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"cliente".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
int idu=(Integer)session.getAttribute("usuario_id");
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>⭐ Mis favoritos (HU8)</h2>
<%
if(request.getParameter("add")!=null){
  Connection ca=null;java.sql.PreparedStatement pa=null;
  try{ca=abrirConexion(application);
    java.sql.PreparedStatement q=ca.prepareStatement("SELECT 1 FROM favorito WHERE id_usuario=? AND id_propiedad=?");q.setInt(1,idu);q.setInt(2,Integer.parseInt(request.getParameter("add")));java.sql.ResultSet rq=q.executeQuery();
    if(!rq.next()){ pa=ca.prepareStatement("INSERT INTO favorito(id_usuario,id_propiedad) VALUES(?,?)");pa.setInt(1,idu);pa.setInt(2,Integer.parseInt(request.getParameter("add")));pa.executeUpdate(); }
    rq.close();q.close();}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(pa!=null)pa.close();}catch(Exception x){}try{if(ca!=null)ca.close();}catch(Exception x){}}
}
if(request.getParameter("del")!=null){
  Connection cd=null;java.sql.PreparedStatement pd=null;
  try{cd=abrirConexion(application);pd=cd.prepareStatement("DELETE FROM favorito WHERE id_usuario=? AND id_propiedad=?");pd.setInt(1,idu);pd.setInt(2,Integer.parseInt(request.getParameter("del")));pd.executeUpdate();}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(pd!=null)pd.close();}catch(Exception x){}try{if(cd!=null)cd.close();}catch(Exception x){}}
}
Connection con=null;java.sql.PreparedStatement ps=null;java.sql.ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT p.id_propiedad,p.titulo,p.precio FROM favorito f INNER JOIN propiedad p ON f.id_propiedad=p.id_propiedad WHERE f.id_usuario=?");
ps.setInt(1,idu);rs=ps.executeQuery();
%><div class="row"><% while(rs.next()){ %>
<div class="col-md-4 mb-2"><div class="card"><div class="card-body"><h5><%=rs.getString(2)%></h5><p>$ <%=rs.getBigDecimal(3)%></p>
<a class="btn btn-sm btn-primary" href="../detalle.jsp?id=<%=rs.getInt(1)%>">Ver</a> <a class="btn btn-sm btn-danger" href="favoritos.jsp?del=<%=rs.getInt(1)%>">Quitar</a></div></div></div>
<% } %></div><%}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<p class="mt-3">Para agregar: ve al <a href="../catalogo.jsp">catálogo</a>, abre el detalle y usa el botón favorito (o entra con <code>favoritos.jsp?add=ID</code>).</p>
<%@ include file="../includes/footer.jspf" %>
