<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Object oid=session.getAttribute("usuario_id"); String rol=(String)session.getAttribute("usuario_rol");
if(oid==null||!"inmobiliaria".equals(rol)){ response.sendRedirect(request.getContextPath()+"/acceso-denegado.jsp"); return; }
%>
<%@ include file="../includes/header.jspf" %>
<%@ include file="../includes/conexion.jspf" %>
<h2>Nueva propiedad</h2>
<%
String msg="",msgOk="";
if("POST".equalsIgnoreCase(request.getMethod())){
  String titulo=request.getParameter("titulo"), desc=request.getParameter("descripcion"),
    precioS=request.getParameter("precio"), dir=request.getParameter("direccion"),
    mat=request.getParameter("matricula"), ciuS=request.getParameter("id_ciudad"),
    tipoS=request.getParameter("id_tipo");
  String[] cars=request.getParameterValues("car");
  if(titulo==null||titulo.trim().isEmpty()||precioS==null||mat==null||mat.trim().isEmpty()||ciuS==null||tipoS==null){
    msg="Título, precio, matrícula, ciudad y tipo son obligatorios.";
  } else {
    try{
      double precio=Double.parseDouble(precioS);
      if(precio<=0) throw new NumberFormatException();
      int idCiu=Integer.parseInt(ciuS), idTipo=Integer.parseInt(tipoS);
      Connection con=null;PreparedStatement ps=null,pi=null,pc=null;ResultSet gk=null;
      try{
        con=abrirConexion(application);
        // id_inmobiliaria de este agente (1:N)
        PreparedStatement pb=con.prepareStatement("SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario=?");
        pb.setInt(1,(Integer)session.getAttribute("usuario_id"));ResultSet rb=pb.executeQuery();
        if(!rb.next()){ msg="Tu usuario agente no tiene inmobiliaria asociada."; }
        else{
          int idInm=rb.getInt(1); rb.close(); pb.close();
          ps=con.prepareStatement("INSERT INTO propiedad(id_inmobiliaria,id_ciudad,id_tipo,titulo,descripcion,precio,direccion,matricula_inmobiliaria) VALUES(?,?,?,?,?,?,?,?)",Statement.RETURN_GENERATED_KEYS);
          ps.setInt(1,idInm);ps.setInt(2,idCiu);ps.setInt(3,idTipo);ps.setString(4,titulo.trim());
          ps.setString(5,desc);ps.setDouble(6,precio);ps.setString(7,dir);ps.setString(8,mat.trim().toUpperCase());
          ps.executeUpdate();gk=ps.getGeneratedKeys();gk.next();int idProp=gk.getInt(1);
          if(cars!=null){ for(String c:cars){ pc=con.prepareStatement("INSERT INTO propiedad_caracteristica(id_propiedad,id_caracteristica) VALUES(?,?)");pc.setInt(1,idProp);pc.setInt(2,Integer.parseInt(c));pc.executeUpdate();pc.close(); } }
          pi=con.prepareStatement("INSERT INTO imagen_propiedad(id_propiedad,url) VALUES(?,?)");
          pi.setInt(1,idProp);pi.setString(2,"https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600");pi.executeUpdate();
          PreparedStatement pa=con.prepareStatement("INSERT INTO auditoria(id_usuario,accion,detalle) VALUES(?,'crear_propiedad',?)");
          pa.setInt(1,(Integer)session.getAttribute("usuario_id"));pa.setString(2,"Prop "+idProp);pa.executeUpdate();pa.close();
          msgOk="Propiedad creada ✅ <a href='dashboard.jsp'>Volver al panel</a> | <a href='imagenes.jsp?id="+idProp+"'>Gestionar fotos</a>";
        }
      }catch(SQLIntegrityConstraintViolationException dup){ msg="La matrícula ya existe (UNIQUE). Usa otra."; }
      catch(Exception e){ msg="Error: "+e.getMessage(); }
      finally{try{if(gk!=null)gk.close();}catch(Exception x){}try{if(ps!=null)ps.close();}catch(Exception x){}try{if(pi!=null)pi.close();}catch(Exception x){}try{if(con!=null)con.close();}catch(Exception x){}}
    }catch(NumberFormatException n){ msg="Precio inválido (número > 0)."; }
  }
}
%>
<% if(!msg.isEmpty()){ %><div class="alert alert-danger"><%= msg %></div><% } %>
<% if(!msgOk.isEmpty()){ %><div class="alert alert-success"><%= msgOk %></div><% } %>
<form method="post" class="col-md-8">
 <div class="mb-2"><label>Título*</label><input class="form-control" name="titulo" required maxlength="150"></div>
 <div class="mb-2"><label>Descripción</label><textarea class="form-control" name="descripcion"></textarea></div>
 <div class="row"><div class="col-md-4 mb-2"><label>Precio*</label><input class="form-control" name="precio" type="number" step="0.01" min="1" required></div>
 <div class="col-md-4 mb-2"><label>Matrícula* (UNIQUE)</label><input class="form-control" name="matricula" required></div>
 <div class="col-md-4 mb-2"><label>Dirección</label><input class="form-control" name="direccion"></div></div>
 <div class="row"><div class="col-md-6 mb-2"><label>Ciudad*</label><select class="form-select" name="id_ciudad" required>
 <% { Connection c=null;Statement s=null;ResultSet r=null; try{c=abrirConexion(application);s=c.createStatement();r=s.executeQuery("SELECT id_ciudad,nombre FROM ciudad ORDER BY nombre");while(r.next()){ %><option value="<%=r.getInt(1)%>"><%=r.getString(2)%></option><% }}catch(Exception e){}finally{try{if(r!=null)r.close();}catch(Exception x){}try{if(s!=null)s.close();}catch(Exception x){}try{if(c!=null)c.close();}catch(Exception x){}} } %>
 </select></div>
 <div class="col-md-6 mb-2"><label>Tipo*</label><select class="form-select" name="id_tipo" required>
 <% { Connection c=null;Statement s=null;ResultSet r=null; try{c=abrirConexion(application);s=c.createStatement();r=s.executeQuery("SELECT id_tipo,nombre FROM tipo_propiedad");while(r.next()){ %><option value="<%=r.getInt(1)%>"><%=r.getString(2)%></option><% }}catch(Exception e){}finally{try{if(r!=null)r.close();}catch(Exception x){}try{if(s!=null)s.close();}catch(Exception x){}try{if(c!=null)c.close();}catch(Exception x){}} } %>
 </select></div></div>
 <div class="mb-2"><label>Características (N:M)</label><br>
 <% { Connection c=null;Statement s=null;ResultSet r=null; try{c=abrirConexion(application);s=c.createStatement();r=s.executeQuery("SELECT id_caracteristica,nombre FROM caracteristica");while(r.next()){ %>
 <label class="me-3"><input type="checkbox" name="car" value="<%=r.getInt(1)%>"> <%=r.getString(2)%></label>
 <% }}catch(Exception e){}finally{try{if(r!=null)r.close();}catch(Exception x){}try{if(s!=null)s.close();}catch(Exception x){}try{if(c!=null)c.close();}catch(Exception x){}} } %>
 </div>
 <button class="btn btn-success">Guardar</button> <a class="btn btn-secondary" href="dashboard.jsp">Cancelar</a>
</form>
<%@ include file="../includes/footer.jspf" %>
