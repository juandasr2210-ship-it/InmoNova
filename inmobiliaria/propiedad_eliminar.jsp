<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
// Baja lógica: activo=0 (no se borra físico por integridad con citas/solicitudes)
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
String sid=request.getParameter("id");
if(sid==null){ response.sendRedirect("dashboard.jsp"); return; }
try{
  Class.forName(application.getInitParameter("db.driver")==null?"com.mysql.cj.jdbc.Driver":application.getInitParameter("db.driver"));
  java.sql.Connection con=java.sql.DriverManager.getConnection(application.getInitParameter("db.url"),application.getInitParameter("db.user"),application.getInitParameter("db.pass"));
  java.sql.PreparedStatement ps=con.prepareStatement("UPDATE propiedad p INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria SET p.activo=0 WHERE p.id_propiedad=? AND i.id_usuario=?");
  ps.setInt(1,Integer.parseInt(sid));ps.setInt(2,(Integer)session.getAttribute("usuario_id"));ps.executeUpdate();ps.close();con.close();
}catch(Exception e){ session.setAttribute("flash","Error baja: "+e.getMessage()); }
response.sendRedirect("dashboard.jsp");
%>
