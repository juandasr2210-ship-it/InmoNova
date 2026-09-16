<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Editar propiedad</h2>
<%
String sid=request.getParameter("id"); String msg="",msgOk="";
if(sid==null){ %><div class="alert alert-danger">Falta id.</div><%@ include file="../includes/footer.jspf" %><% return; }
if("POST".equalsIgnoreCase(request.getMethod())){
  try{
    Connection con=abrirConexion(application);
    PreparedStatement ps=con.prepareStatement("UPDATE propiedad p INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria SET p.titulo=?,p.descripcion=?,p.precio=?,p.estado=?,p.destacada=? WHERE p.id_propiedad=? AND i.id_usuario=?");
    ps.setString(1,request.getParameter("titulo"));ps.setString(2,request.getParameter("descripcion"));
    ps.setDouble(3,Double.parseDouble(request.getParameter("precio")));ps.setString(4,request.getParameter("estado"));
    ps.setInt(5,request.getParameter("destacada")!=null?1:0);ps.setInt(6,Integer.parseInt(sid));ps.setInt(7,(Integer)session.getAttribute("usuario_id"));
    int n=ps.executeUpdate();ps.close();con.close();
    msgOk=n>0?"Actualizada ✅":"No se actualizó (¿es tuya?)";
  }catch(Exception e){ msg="Error: "+e.getMessage(); }
}
Connection con=null;PreparedStatement ps=null;ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT p.* FROM propiedad p INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria WHERE p.id_propiedad=? AND i.id_usuario=?");
ps.setInt(1,Integer.parseInt(sid));ps.setInt(2,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
if(rs.next()){
%>
<% if(!msg.isEmpty()){ %><div class="alert alert-danger"><%=msg%></div><% } %><% if(!msgOk.isEmpty()){ %><div class="alert alert-success"><%=msgOk%></div><% } %>
<form method="post" class="col-md-6">
 <div class="mb-2"><label>Título</label><input class="form-control" name="titulo" value="<%=rs.getString("titulo")%>" required></div>
 <div class="mb-2"><label>Descripción</label><textarea class="form-control" name="descripcion"><%=rs.getString("descripcion")==null?"":rs.getString("descripcion")%></textarea></div>
 <div class="mb-2"><label>Precio</label><input class="form-control" name="precio" type="number" step="0.01" value="<%=rs.getBigDecimal("precio")%>" required></div>
 <div class="mb-2"><label>Estado</label><select class="form-select" name="estado"><option <%= "disponible".equals(rs.getString("estado"))?"selected":"" %>>disponible</option><option <%= "arrendada".equals(rs.getString("estado"))?"selected":"" %>>arrendada</option><option <%= "vendida".equals(rs.getString("estado"))?"selected":"" %>>vendida</option></select></div>
 <div class="mb-2"><label><input type="checkbox" name="destacada" <%=rs.getInt("destacada")==1?"checked":""%>> Destacada</label></div>
 <button class="btn btn-primary">Guardar</button> <a class="btn btn-secondary" href="dashboard.jsp">Volver</a>
</form>
<% } else { %><div class="alert alert-danger">No encontrada o no es tuya.</div><% } }
catch(Exception e){ %><div class="alert alert-danger"><%=e.getMessage()%></div><% }
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<%@ include file="../includes/footer.jspf" %>
