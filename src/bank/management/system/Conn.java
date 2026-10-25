package bank.management.system;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import javax.swing.JOptionPane;

/**
 * Opens and manages a connection to the local MySQL database.
 * Supports loading credentials from:
 *   1. System environment variables (DB_URL, DB_USER, DB_PASSWORD)
 *   2. JVM system properties (-DDB_USER=... etc.)
 *   3. Local .env file (see .env.example)
 *   4. Safe local defaults (user "root", empty password)
 */
public class Conn {
    public Connection c;
    public Statement s;

    public Conn() {
        Map<String, String> envFile = loadEnvFile();

        String url = getVal("DB_URL", envFile, "jdbc:mysql://localhost:3306/bankmanagementsystem");
        String user = getVal("DB_USER", envFile, "root");
        String password = getVal("DB_PASSWORD", envFile, "");

        // Append connection parameters if not present
        if (!url.contains("allowPublicKeyRetrieval")) {
            url += (url.contains("?") ? "&" : "?") + "allowPublicKeyRetrieval=true&useSSL=false";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try {
                c = DriverManager.getConnection(url, user, password);
                s = c.createStatement();
            } catch (SQLException ex) {
                // If database does not exist, create it automatically
                if (ex.getErrorCode() == 1049 || (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("unknown database"))) {
                    initializeDatabase(url, user, password);
                    c = DriverManager.getConnection(url, user, password);
                    s = c.createStatement();
                } else {
                    throw ex;
                }
            }

            // Ensure required tables exist
            ensureTablesExist();

        } catch (ClassNotFoundException | SQLException e) {
            String errorMsg = "Could not connect to MySQL.\n"
                    + "URL: " + url + "\n"
                    + "User: " + user + "\n\n"
                    + "Error: " + e.getMessage() + "\n\n"
                    + "Please ensure MySQL Server is running and configure credentials in a .env file or environment variables.";
            System.err.println(errorMsg);
            try {
                JOptionPane.showMessageDialog(null, errorMsg, "Database Connection Error", JOptionPane.ERROR_MESSAGE);
            } catch (Exception ignored) {}
            throw new IllegalStateException(errorMsg, e);
        }
    }

    private static String getVal(String key, Map<String, String> envFile, String defaultVal) {
        String val = System.getenv(key);
        if (val == null || val.isBlank()) {
            val = System.getProperty(key);
        }
        if (val == null || val.isBlank()) {
            val = envFile.get(key);
        }
        if (val == null || val.isBlank()) {
            return defaultVal;
        }
        return val.trim();
    }

    private static Map<String, String> loadEnvFile() {
        Map<String, String> map = new HashMap<>();
        File envFile = new File(".env");
        if (!envFile.exists()) {
            envFile = new File("../.env");
        }
        if (envFile.exists() && envFile.isFile()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) {
                        continue;
                    }
                    int eq = line.indexOf('=');
                    if (eq > 0) {
                        String k = line.substring(0, eq).trim();
                        String v = line.substring(eq + 1).trim();
                        if ((v.startsWith("\"") && v.endsWith("\"")) || (v.startsWith("'") && v.endsWith("'"))) {
                            v = v.substring(1, v.length() - 1);
                        }
                        map.put(k, v);
                    }
                }
            } catch (IOException ignored) {}
        }
        return map;
    }

    private void initializeDatabase(String fullUrl, String user, String password) throws SQLException {
        String serverUrl = fullUrl;
        int qIndex = fullUrl.indexOf('?');
        String base = (qIndex != -1) ? fullUrl.substring(0, qIndex) : fullUrl;
        int lastSlash = base.lastIndexOf('/');
        if (lastSlash > "jdbc:mysql://".length()) {
            serverUrl = base.substring(0, lastSlash + 1) + (qIndex != -1 ? fullUrl.substring(qIndex) : "");
        }
        try (Connection rootConn = DriverManager.getConnection(serverUrl, user, password);
             Statement st = rootConn.createStatement()) {
            st.executeUpdate("CREATE DATABASE IF NOT EXISTS bankmanagementsystem");
        }
    }

    private void ensureTablesExist() {
        try {
            s.executeUpdate("CREATE TABLE IF NOT EXISTS signup ("
                    + "formno VARCHAR(20) PRIMARY KEY, "
                    + "name VARCHAR(100), "
                    + "fname VARCHAR(100), "
                    + "dob VARCHAR(30), "
                    + "gender VARCHAR(30), "
                    + "email VARCHAR(150), "
                    + "marital VARCHAR(30), "
                    + "address VARCHAR(255), "
                    + "city VARCHAR(100), "
                    + "pincode VARCHAR(20), "
                    + "state VARCHAR(100))");

            s.executeUpdate("CREATE TABLE IF NOT EXISTS signup2 ("
                    + "formno VARCHAR(20) PRIMARY KEY, "
                    + "religion VARCHAR(60), "
                    + "category VARCHAR(60), "
                    + "income VARCHAR(60), "
                    + "education VARCHAR(100), "
                    + "occupation VARCHAR(100), "
                    + "pan VARCHAR(30), "
                    + "aadhar VARCHAR(30), "
                    + "scitizen VARCHAR(20), "
                    + "eaccount VARCHAR(20))");

            s.executeUpdate("CREATE TABLE IF NOT EXISTS signup3 ("
                    + "formno VARCHAR(20) PRIMARY KEY, "
                    + "atype VARCHAR(100), "
                    + "cardno VARCHAR(30) UNIQUE, "
                    + "pin VARCHAR(20), "
                    + "facility VARCHAR(255))");

            s.executeUpdate("CREATE TABLE IF NOT EXISTS login ("
                    + "formno VARCHAR(20), "
                    + "cardno VARCHAR(30) PRIMARY KEY, "
                    + "pin VARCHAR(20) NOT NULL)");

            s.executeUpdate("CREATE TABLE IF NOT EXISTS bank ("
                    + "pin VARCHAR(20) NOT NULL, "
                    + "date VARCHAR(30), "
                    + "type VARCHAR(30), "
                    + "amount VARCHAR(30))");

            try {
                s.executeUpdate("CREATE INDEX idx_bank_pin ON bank(pin)");
            } catch (SQLException ignored) {
                // Index already exists
            }
        } catch (SQLException e) {
            System.err.println("Notice: Could not automatically verify all tables: " + e.getMessage());
        }
    }
}
