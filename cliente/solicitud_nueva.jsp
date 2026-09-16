<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"cliente".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Radicar solicitud compra/arriendo (HU10)</h2>
<%
String msg="",msgOk="";
if("POST".equalsIgnoreCase(request.getMethod())){
  try{
    Connection c2=abrirConexion(application);
    java.sql.PreparedStatement p=c2.prepareStatement("INSERT INTO solicitud(id_propiedad,id_cliente,tipo) VALUES(?,?,?)");
    p.setInt(1,Integer.parseInt(request.getParameter("id_propiedad")));p.setInt(2,(Integer)session.getAttribute("usuario_id"));p.setString(3,request.getParameter("tipo"));
    p.executeUpdate();p.close();c2.close();msgOk="Solicitud radicada ✅ <a href='solicitudes.jsp'>Ver estado</a>";
  }catch(Exception e){ msg="Error: "+e.getMessage(); }
}
%>
<% if(!msg.isEmpty()){ %><div class="alert alert-danger"><%=msg%></div><% } %><% if(!msgOk.isEmpty()){ %><div class="alert alert-success"><%=msgOk%></div><% } %>
<form method="post" class="col-md-6">
 <div class="mb-2"><label>Propiedad</label><select class="form-select" name="id_propiedad"><% { Connection c=null;java.sql.Statement s=null;java.sql.ResultSet r=null; try{c=abrirConexion(application);s=c.createStatement();r=s.executeQuery("SELECT id_propiedad,titulo FROM propiedad WHERE activo=1");while(r.next()){ %><option value="<%=r.getInt(1)%>"><%=r.getString(2)%></option><% }}catch(Exception e){}finally{try{if(r!=null)r.close();}catch(Exception x){}try{if(s!=null)s.close();}catch(Exception x){}try{if(c!=null)c.close();}catch(Exception x){}} } %></select></div>
 <div class="mb-2"><label>Tipo</label><select class="form-select" name="tipo"><option value="arriendo">Arriendo</option><option value="compra">Compra</option></select></div>
 <button class="btn btn-success">Radicar</button>
</form>
<%@ include file="../includes/footer.jspf" %>
