package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Centraliza la configuración de la conexión JDBC.
 *
 * Los valores pueden cambiarse sin modificar los servlets usando propiedades
 * de la JVM (-Dinmonova.db.*) o variables de entorno INMONOVA_DB_*.
 */
public final class Conexion {
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL no encontrado", e);
        }
    }

    private static final String URL = value(
            "inmonova.db.url",
            "INMONOVA_DB_URL",
            "jdbc:mysql://localhost:3306/inmonova?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
    private static final String USER = value(
            "inmonova.db.user",
            "INMONOVA_DB_USER",
            "root");
    private static final String PASSWORD = value(
            "inmonova.db.password",
            "INMONOVA_DB_PASSWORD",
            "");

    private Conexion() {
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener conexión JDBC", e);
        }
    }

    private static String value(String property, String environmentVariable, String defaultValue) {
        String configuredValue = System.getProperty(property);
        if (configuredValue == null || configuredValue.trim().isEmpty()) {
            configuredValue = System.getenv(environmentVariable);
        }
        return configuredValue == null || configuredValue.trim().isEmpty()
                ? defaultValue
                : configuredValue;
    }
}