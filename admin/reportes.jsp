<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"administrador".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Reportes (HU12 - GROUP BY + HAVING + JOINs)</h2>
<div class="row">
<div class="col-md-4"><h5>1. Propiedades por ciudad y estado</h5><ul>
<%
Connection c1=null;java.sql.Statement s1=null;java.sql.ResultSet r1=null;
try{c1=abrirConexion(application);s1=c1.createStatement();
r1=s1.executeQuery("SELECT c.nombre,p.estado,COUNT(*) total FROM propiedad p INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad WHERE p.activo=1 GROUP BY c.nombre,p.estado HAVING COUNT(*)>=1 ORDER BY total DESC");
while(r1.next()){ %><li><%=r1.getString(1)%> / <%=r1.getString(2)%>: <b><%=r1.getInt(3)%></b></li><% }
}catch(Exception e){%><li><%=e.getMessage()%></li><%}finally{try{if(r1!=null)r1.close();}catch(Exception x){}try{if(s1!=null)s1.close();}catch(Exception x){}try{if(c1!=null)c1.close();}catch(Exception x){}} %>
</ul></div>
<div class="col-md-4"><h5>2. Citas por estado</h5><ul>
<%
Connection c2=null;java.sql.Statement s2=null;java.sql.ResultSet r2=null;
try{c2=abrirConexion(application);s2=c2.createStatement();
r2=s2.executeQuery("SELECT estado,COUNT(*) FROM cita GROUP BY estado HAVING COUNT(*)>=1");
while(r2.next()){ %><li><%=r2.getString(1)%>: <b><%=r2.getInt(2)%></b></li><% }
}catch(Exception e){%><li><%=e.getMessage()%></li><%}finally{try{if(r2!=null)r2.close();}catch(Exception x){}try{if(s2!=null)s2.close();}catch(Exception x){}try{if(c2!=null)c2.close();}catch(Exception x){}} %>
</ul></div>
<div class="col-md-4"><h5>3. Solicitudes por inmobiliaria</h5><ul>
<%
Connection c3=null;java.sql.Statement s3=null;java.sql.ResultSet r3=null;
try{c3=abrirConexion(application);s3=c3.createStatement();
r3=s3.executeQuery("SELECT i.nombre_empresa,COUNT(*) total FROM solicitud s INNER JOIN propiedad p ON s.id_propiedad=p.id_propiedad INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria GROUP BY i.nombre_empresa HAVING COUNT(*)>=1");
while(r3.next()){ %><li><%=r3.getString(1)%>: <b><%=r3.getInt(2)%></b></li><% }
}catch(Exception e){%><li><%=e.getMessage()%></li><%}finally{try{if(r3!=null)r3.close();}catch(Exception x){}try{if(s3!=null)s3.close();}catch(Exception x){}try{if(c3!=null)c3.close();}catch(Exception x){}} %>
</ul></div>
</div>
<h5 class="mt-3">4. Propiedades sin citas (LEFT JOIN - consulta obligatoria)</h5>
<%
Connection c4=null;java.sql.Statement s4=null;java.sql.ResultSet r4=null;
try{c4=abrirConexion(application);s4=c4.createStatement();
r4=s4.executeQuery("SELECT p.id_propiedad,p.titulo FROM propiedad p LEFT JOIN cita ci ON p.id_propiedad=ci.id_propiedad WHERE ci.id_cita IS NULL AND p.activo=1 LIMIT 10");
%><ul><% while(r4.next()){ %><li>#<%=r4.getInt(1)%> <%=r4.getString(2)%></li><% } %></ul><%
}catch(Exception e){%><div class="alert alert-warning"><%=e.getMessage()%></div><%}finally{try{if(r4!=null)r4.close();}catch(Exception x){}try{if(s4!=null)s4.close();}catch(Exception x){}try{if(c4!=null)c4.close();}catch(Exception x){}} %>
<%@ include file="../includes/footer.jspf" %>
