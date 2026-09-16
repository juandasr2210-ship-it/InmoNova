package controller;

import config.Conexion;
import util.PasswordUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        if (correo == null || correo.trim().isEmpty() || clave == null || clave.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            return;
        }
        correo = correo.trim().toLowerCase();

        // 1) Buscar usuario por correo (trae salt + hash). Asi soporta SHA-256 CON salt.
        String sqlUser = "SELECT id_usuario, correo, clave_hash, salt, estado FROM usuario WHERE correo = ?";
        String sqlRol = "SELECT r.nombre FROM usuario_rol ur INNER JOIN rol r ON ur.id_rol = r.id_rol "
                      + "WHERE ur.id_usuario = ? LIMIT 1";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlUser)) {

            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
                    return;
                }
                if (rs.getInt("estado") == 0) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=inactivo");
                    return;
                }
                String calc = PasswordUtil.hashConSalt(rs.getString("salt"), clave);
                if (!calc.equals(rs.getString("clave_hash"))) {
                    try (PreparedStatement pi = conn.prepareStatement(
                            "UPDATE usuario SET intentos = intentos + 1 WHERE id_usuario = ?")) {
                        pi.setInt(1, rs.getInt("id_usuario"));
                        pi.executeUpdate();
                    }
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
                    return;
                }

                int idUsuario = rs.getInt("id_usuario");
                String correoDb = rs.getString("correo");

                String rol = "cliente";
                try (PreparedStatement pr = conn.prepareStatement(sqlRol)) {
                    pr.setInt(1, idUsuario);
                    try (ResultSet rr = pr.executeQuery()) {
                        if (rr.next()) {
                            rol = rr.getString(1);
                        }
                    }
                }

                try (PreparedStatement pu = conn.prepareStatement(
                        "UPDATE usuario SET intentos = 0 WHERE id_usuario = ?")) {
                    pu.setInt(1, idUsuario);
                    pu.executeUpdate();
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("usuario_id", idUsuario);
                session.setAttribute("usuario_correo", correoDb);
                session.setAttribute("usuario_rol", rol);

                String ctx = request.getContextPath();
                if ("administrador".equals(rol)) {
                    response.sendRedirect(ctx + "/admin/dashboard.jsp");
                } else if ("inmobiliaria".equals(rol)) {
                    response.sendRedirect(ctx + "/inmobiliaria/dashboard.jsp");
                } else {
                    response.sendRedirect(ctx + "/cliente/dashboard.jsp");
                }
            }
        } catch (Exception e) {
            getServletContext().log("Error en AuthServlet", e);
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=bd");
        }
    }
}