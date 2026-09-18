<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"administrador".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Usuarios y roles (HU4 - N:M)</h2>
<%
if(request.getParameter("uid")!=null){
  Connection cu=null;java.sql.PreparedStatement pu=null;
  try{cu=abrirConexion(application);
    if(request.getParameter("act")!=null){ pu=cu.prepareStatement("UPDATE usuario SET estado=? WHERE id_usuario=?");pu.setInt(1,"1".equals(request.getParameter("act"))?1:0);pu.setInt(2,Integer.parseInt(request.getParameter("uid")));pu.executeUpdate();pu.close(); }
    if(request.getParameter("addrol")!=null){ java.sql.PreparedStatement q=cu.prepareStatement("SELECT 1 FROM usuario_rol ur INNER JOIN rol r ON ur.id_rol=r.id_rol WHERE ur.id_usuario=? AND r.nombre=?");q.setInt(1,Integer.parseInt(request.getParameter("uid")));q.setString(2,request.getParameter("addrol"));java.sql.ResultSet rq=q.executeQuery(); boolean ya=rq.next(); rq.close(); q.close(); if(!ya){ pu=cu.prepareStatement("INSERT INTO usuario_rol(id_usuario,id_rol) SELECT ?,id_rol FROM rol WHERE nombre=?");pu.setInt(1,Integer.parseInt(request.getParameter("uid")));pu.setString(2,request.getParameter("addrol"));pu.executeUpdate();pu.close(); } }
    if(request.getParameter("delrol")!=null){ pu=cu.prepareStatement("DELETE FROM usuario_rol WHERE id_usuario=? AND id_rol=(SELECT id_rol FROM rol WHERE nombre=?)");pu.setInt(1,Integer.parseInt(request.getParameter("uid")));pu.setString(2,request.getParameter("delrol"));pu.executeUpdate();pu.close(); }
  }catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}finally{try{if(cu!=null)cu.close();}catch(Exception x){}}
}
Connection con=null;java.sql.Statement st=null;java.sql.ResultSet rs=null;java.sql.PreparedStatement pr=null;
try{con=abrirConexion(application);st=con.createStatement();
rs=st.executeQuery("SELECT u.id_usuario,u.correo,u.estado FROM usuario u ORDER BY u.id_usuario");
%><table class="table table-sm table-striped"><tr><th>ID</th><th>Correo</th><th>Estado</th><th>Roles</th><th>Acciones</th></tr><%
pr=con.prepareStatement("SELECT r.nombre FROM usuario_rol ur INNER JOIN rol r ON ur.id_rol=r.id_rol WHERE ur.id_usuario=?");
while(rs.next()){ int id=rs.getInt(1); String roles=""; pr.setInt(1,id); java.sql.ResultSet rr=pr.executeQuery(); while(rr.next()){ if(!roles.isEmpty()) roles+=","; roles+=rr.getString(1); } rr.close(); if(roles.isEmpty()) roles="-"; %>
<tr><td><%=id%></td><td><%=rs.getString(2)%></td><td><%=rs.getInt(3)==1?"Activo":"Inactivo"%></td><td><%=roles%></td>
<td><a class="btn btn-sm btn-warning" href="usuarios.jsp?uid=<%=id%>&act=<%=rs.getInt(3)==1?0:1%>"><%=rs.getInt(3)==1?"Desactivar":"Activar"%></a>
<a class="btn btn-sm btn-success" href="usuarios.jsp?uid=<%=id%>&addrol=cliente">+cliente</a>
<a class="btn btn-sm btn-info" href="usuarios.jsp?uid=<%=id%>&addrol=inmobiliaria">+agente</a></td></tr><% }
%></table><%}catch(Exception e){%><div class="alert alert-danger"><%=e.getMessage()%></div><%}
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(st!=null)st.close();}catch(Exception x){}try{if(pr!=null)pr.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<%@ include file="../includes/footer.jspf" %>
