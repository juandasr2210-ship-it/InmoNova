<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/conexion.jspf" %>
<%@ include file="includes/seguridad.jspf" %>
<%
// HU3: login seguro. Si ya hay sesion, redirigir a su panel.
if (idSesion != null) {
    if ("administrador".equals(rolSesion)) response.sendRedirect(request.getContextPath()+"/admin/dashboard.jsp");
    else if ("inmobiliaria".equals(rolSesion)) response.sendRedirect(request.getContextPath()+"/inmobiliaria/dashboard.jsp");
    else response.sendRedirect(request.getContextPath()+"/cliente/dashboard.jsp");
    return;
}
String msg = "", ok = request.getParameter("ok");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String correo = request.getParameter("correo");
    String clave  = request.getParameter("clave");
    if (correo==null||clave==null||correo.trim().isEmpty()||clave.isEmpty()) {
        msg = "Correo y contraseña son obligatorios.";
    } else if (!esEmail(correo.trim().toLowerCase())) {
        msg = "Formato de correo inválido.";
    } else {
        Connection con=null; PreparedStatement ps=null,pa=null; ResultSet rs=null;
        try{
            con=abrirConexion(application);
            ps=con.prepareStatement("SELECT id_usuario,correo,clave_hash,salt,estado,intentos FROM usuario WHERE correo=?");
            ps.setString(1, correo.trim().toLowerCase());
            rs=ps.executeQuery();
            if(rs.next()){
                if(rs.getInt("estado")==0){ msg="Cuenta inactiva. Contacta al administrador."; }
                else{
                    String calc = hashConSalt(rs.getString("salt"), clave);
                    if(calc.equals(rs.getString("clave_hash"))){
                        int idu=rs.getInt("id_usuario");
                        // reset intentos + rol principal
                        PreparedStatement pu=con.prepareStatement("UPDATE usuario SET intentos=0 WHERE id_usuario=?");
                        pu.setInt(1,idu); pu.executeUpdate(); pu.close();
                        PreparedStatement pr=con.prepareStatement("SELECT r.nombre FROM usuario_rol ur INNER JOIN rol r ON ur.id_rol=r.id_rol WHERE ur.id_usuario=? LIMIT 1");
                        pr.setInt(1,idu); ResultSet rr=pr.executeQuery();
                        String rol="cliente"; if(rr.next()) rol=rr.getString(1); rr.close(); pr.close();
                        session.setAttribute("usuario_id", idu);
                        session.setAttribute("usuario_correo", rs.getString("correo"));
                        session.setAttribute("usuario_rol", rol);
                        pa=con.prepareStatement("INSERT INTO auditoria(id_usuario,accion) VALUES(?,'login')");
                        pa.setInt(1,idu); pa.executeUpdate();
                        if("administrador".equals(rol)) response.sendRedirect("admin/dashboard.jsp");
                        else if("inmobiliaria".equals(rol)) response.sendRedirect("inmobiliaria/dashboard.jsp");
                        else response.sendRedirect("cliente/dashboard.jsp");
                        return;
                    } else {
                        PreparedStatement pi=con.prepareStatement("UPDATE usuario SET intentos=intentos+1 WHERE id_usuario=?");
                        pi.setInt(1,rs.getInt("id_usuario")); pi.executeUpdate(); pi.close();
                        msg="Credenciales incorrectas.";
                    }
                }
            } else msg="Credenciales incorrectas.";
        }catch(Exception e){ msg="Error BD: "+e.getMessage(); }
        finally{ try{if(rs!=null)rs.close();}catch(Exception x){} try{if(ps!=null)ps.close();}catch(Exception x){} try{if(pa!=null)pa.close();}catch(Exception x){} try{if(con!=null)con.close();}catch(Exception x){} }
    }
}
%>
<%@ include file="includes/header.jspf" %>
<div class="row justify-content-center"><div class="col-12 col-md-5">
<h2>Iniciar sesión</h2>
<% if("1".equals(ok)){ %><div class="alert alert-success">Cuenta creada. ¡Ingresa ahora!</div><% } %>
<% if(!msg.isEmpty()){ %><div class="alert alert-danger"><%= msg %></div><% } %>
<form method="post" action="login.jsp">
  <div class="mb-2"><label>Correo</label><input class="form-control" name="correo" type="email" required></div>
  <div class="mb-2"><label>Contraseña</label><input class="form-control" name="clave" type="password" required minlength="6"></div>
  <button class="btn btn-primary w-100">Ingresar</button>
</form>
<p class="mt-2">¿Sin cuenta? <a href="registro.jsp">Regístrate</a></p>
</div></div>
<%@ include file="includes/footer.jspf" %>
