package util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;

public class PasswordUtil {

    // Hash simple (compatibilidad). Devuelve HEX en MAYUSCULAS.
    public static String hashSHA256(String base) {
        if (base == null) {
            throw new IllegalArgumentException("La contraseña no puede ser nula");
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(base.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder(64);
            for (byte b : hash) {
                hexString.append(String.format("%02X", b));
            }
            return hexString.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Error al generar hash SHA-256", ex);
        }
    }

    // --- Nuevo: SHA-256 con salt (exigido por el PDF) ---
    public static String generarSalt() {
        SecureRandom r = new SecureRandom();
        byte[] b = new byte[8];
        r.nextBytes(b);
        StringBuilder sb = new StringBuilder(16);
        for (byte x : b) {
            sb.append(String.format("%02x", x));
        }
        return sb.toString();
    }

    public static String hashConSalt(String salt, String clave) {
        if (salt == null || clave == null) {
            throw new IllegalArgumentException("Salt y clave son obligatorios");
        }
        return hashSHA256(salt + clave);
    }
}