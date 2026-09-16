<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Panel Inmobiliaria</h2>
<a class="btn btn-success mb-3" href="propiedad_nueva.jsp">+ Nueva propiedad</a>
<a class="btn btn-outline-primary mb-3" href="citas.jsp">Ver citas</a>
<a class="btn btn-outline-primary mb-3" href="solicitudes.jsp">Ver solicitudes</a>
<%
Connection con=null;PreparedStatement ps=null;ResultSet rs=null;
try{con=abrirConexion(application);
ps=con.prepareStatement("SELECT p.id_propiedad,p.titulo,p.precio,p.estado,c.nombre AS ciudad FROM propiedad p INNER JOIN inmobiliaria i ON p.id_inmobiliaria=i.id_inmobiliaria INNER JOIN ciudad c ON p.id_ciudad=c.id_ciudad WHERE i.id_usuario=? AND p.activo=1");
ps.setInt(1,(Integer)session.getAttribute("usuario_id"));rs=ps.executeQuery();
%><table class="table table-striped"><tr><th>Título</th><th>Ciudad</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr><%
while(rs.next()){ %><tr><td><%= rs.getString("titulo") %></td><td><%= rs.getString("ciudad") %></td><td><%= rs.getBigDecimal("precio") %></td><td><%= rs.getString("estado") %></td>
<td><a class="btn btn-sm btn-primary" href="propiedad_editar.jsp?id=<%=rs.getInt(1)%>">Editar</a> <a class="btn btn-sm btn-info" href="imagenes.jsp?id=<%=rs.getInt(1)%>">Fotos</a> <a class="btn btn-sm btn-danger" onclick="return confirm('¿Dar de baja?')" href="propiedad_eliminar.jsp?id=<%=rs.getInt(1)%>">Baja</a></td></tr><% }
%></table><% }catch(Exception e){ %><div class="alert alert-info"><%= e.getMessage() %></div><% }
finally{try{if(rs!=null)rs.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}} %>
<%@ include file="../includes/footer.jspf" %>
