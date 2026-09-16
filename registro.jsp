<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/conexion.jspf" %>
<%@ include file="includes/seguridad.jspf" %>
<%
// HU2: registro con correo UNICO validado. Captura error duplicado, no muestra excepcion Java.
String msg="", tipo="danger";
if("POST".equalsIgnoreCase(request.getMethod())){
  String correo=request.getParameter("correo"), clave=request.getParameter("clave"),
         clave2=request.getParameter("clave2"), nombres=request.getParameter("nombres"),
         apellidos=request.getParameter("apellidos"), rolSel=request.getParameter("rol");
  if(rolSel==null||(!rolSel.equals("cliente")&&!rolSel.equals("inmobiliaria"))) rolSel="cliente";
  correo=correo==null?"":correo.trim().toLowerCase();
  if(!esEmail(correo)) msg="Correo inválido.";
  else if(clave==null||clave.length()<6) msg="La clave debe tener mínimo 6 caracteres.";
  else if(!clave.equals(clave2)) msg="Las contraseñas no coinciden.";
  else if(nombres==null||nombres.trim().isEmpty()||apellidos==null||apellidos.trim().isEmpty()) msg="Nombres y apellidos obligatorios.";
  else{
    Connection con=null; PreparedStatement ps=null,psR=null,psP=null; ResultSet gk=null;
    try{
      con=abrirConexion(application);
      con.setAutoCommit(false);
      String salt=generarSalt(), hash=hashConSalt(salt, clave);
      ps=con.prepareStatement("INSERT INTO usuario(correo,clave_hash,salt) VALUES(?,?,?)", Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,correo); ps.setString(2,hash); ps.setString(3,salt);
      ps.executeUpdate(); gk=ps.getGeneratedKeys(); gk.next(); int idu=gk.getInt(1);
      psR=con.prepareStatement("INSERT INTO usuario_rol(id_usuario,id_rol) SELECT ?,id_rol FROM rol WHERE nombre=?");
      psR.setInt(1,idu); psR.setString(2,rolSel); psR.executeUpdate();
      psP=con.prepareStatement("INSERT INTO perfil(id_usuario,nombres,apellidos,telefono) VALUES(?,?,?,?)");
      psP.setInt(1,idu); psP.setString(2,nombres.trim()); psP.setString(3,apellidos.trim());
      psP.setString(4,request.getParameter("telefono"));
      psP.executeUpdate();
      if("inmobiliaria".equals(rolSel)){
        PreparedStatement pi=con.prepareStatement("INSERT INTO inmobiliaria(id_usuario,nombre_empresa,nit) VALUES(?,?,?)");
        pi.setInt(1,idu); pi.setString(2,nombres.trim()+" "+apellidos.trim()+" S.A.S");
        pi.setString(3,"NIT"+System.currentTimeMillis()); pi.executeUpdate(); pi.close();
      }
      con.commit();
      response.sendRedirect("login.jsp?ok=1"); return;
    }catch(SQLIntegrityConstraintViolationException dup){
      try{if(con!=null)con.rollback();}catch(Exception x){}
      // UNIQUE usuario.correo -> mensaje claro, no stacktrace
      msg="El correo ya se encuentra registrado. Usa otro o <a href='login.jsp'>ingresa aquí</a>.";
    }catch(Exception e){
      try{if(con!=null)con.rollback();}catch(Exception x){}
      if(e.getMessage()!=null&&e.getMessage().contains("Duplicate")) msg="El correo ya se encuentra registrado.";
      else msg="Error: "+e.getMessage();
    }finally{ try{if(gk!=null)gk.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(psR!=null)psR.close();}catch(Exception x){} try{if(psP!=null)psP.close();}catch(Exception x){} try{if(con!=null){con.setAutoCommit(true);con.close();}}catch(Exception x){} }
  }
}
%>
<%@ include file="includes/header.jspf" %>
<div class="row justify-content-center"><div class="col-12 col-md-6">
<h2>Crear cuenta</h2>
<% if(!msg.isEmpty()){ %><div class="alert alert-<%= tipo %>"><%= msg %></div><% } %>
<form method="post" action="registro.jsp">
  <div class="row"><div class="col-md-6 mb-2"><label>Nombres*</label><input class="form-control" name="nombres" required></div>
  <div class="col-md-6 mb-2"><label>Apellidos*</label><input class="form-control" name="apellidos" required></div></div>
  <div class="mb-2"><label>Correo* (único)</label><input class="form-control" name="correo" type="email" required></div>
  <div class="mb-2"><label>Teléfono</label><input class="form-control" name="telefono" pattern="[0-9+ ]{7,15}" title="Solo números 7-15 dígitos"></div>
  <div class="row"><div class="col-md-6 mb-2"><label>Contraseña* (min 6)</label><input class="form-control" name="clave" type="password" required minlength="6"></div>
  <div class="col-md-6 mb-2"><label>Confirmar*</label><input class="form-control" name="clave2" type="password" required></div></div>
  <div class="mb-2"><label>Quiero registrarme como</label><select class="form-select" name="rol"><option value="cliente">Cliente</option><option value="inmobiliaria">Inmobiliaria / Agente</option></select></div>
  <button class="btn btn-success w-100">Registrarme</button>
</form>
</div></div>
<%@ include file="includes/footer.jspf" %>
