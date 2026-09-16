<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"cliente".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Agendar visita (HU9)</h2>
<%
String msg="",msgOk=""; String pre=request.getParameter("id_prop");
if("POST".equalsIgnoreCase(request.getMethod())){
  try{
    int idProp=Integer.parseInt(request.getParameter("id_propiedad"));
    String fh=request.getParameter("fecha_hora").replace("T"," ")+":00";
    Connection c2=abrirConexion(application);
    try{
      java.sql.PreparedStatement p=c2.prepareStatement("INSERT INTO cita(id_propiedad,id_cliente,fecha_hora) VALUES(?,?,?)");
      p.setInt(1,idProp);p.setInt(2,(Integer)session.getAttribute("usuario_id"));p.setString(3,fh);p.executeUpdate();p.close();
      msgOk="Cita solicitada ✅ <a href='citas.jsp'>Ver mis citas</a>";
    }catch(java.sql.SQLIntegrityConstraintViolationException dup){ msg="Ese horario ya está ocupado (UNIQUE propiedad+fecha). Elige otro."; }
    finally{try{c2.close();}catch(Exception x){}}
  }catch(Exception e){ msg="Error: "+e.getMessage(); }
}
%>
<% if(!msg.isEmpty()){ %><div class="alert alert-danger"><%=msg%></div><% } %><% if(!msgOk.isEmpty()){ %><div class="alert alert-success"><%=msgOk%></div><% } %>
<form method="post" class="col-md-6">
 <div class="mb-2"><label>Propiedad</label><select class="form-select" name="id_propiedad" required>
 <% { Connection c=null;java.sql.Statement s=null;java.sql.ResultSet r=null; try{c=abrirConexion(application);s=c.createStatement();r=s.executeQuery("SELECT p.id_propiedad,p.titulo FROM propiedad p WHERE p.activo=1 AND p.estado='disponible'");while(r.next()){ %><option value="<%=r.getInt(1)%>" <%=String.valueOf(r.getInt(1)).equals(pre)?"selected":""%>><%=r.getInt(1)%> - <%=r.getString(2)%></option><% }}catch(Exception e){}finally{try{if(r!=null)r.close();}catch(Exception x){}try{if(s!=null)s.close();}catch(Exception x){}try{if(c!=null)c.close();}catch(Exception x){}} } %>
 </select></div>
 <div class="mb-2"><label>Fecha y hora*</label><input class="form-control" type="datetime-local" name="fecha_hora" required></div>
 <button class="btn btn-success">Solicitar cita</button>
</form>
<%@ include file="../includes/footer.jspf" %>
