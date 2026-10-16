package com.manufacturing.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/manufacturing_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASSWORD = "apple6969";

    private static final String H2_URL = "jdbc:h2:./database/manufacturing_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;DB_CLOSE_DELAY=-1";
    private static final String H2_USER = "sa";
    private static final String H2_PASSWORD = "";

    private static boolean useH2 = false;
    private static boolean loggedActiveConnection = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ignored) {
        }
        try {
            Class.forName("org.h2.Driver");
        } catch (ClassNotFoundException ignored) {
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!useH2) {
            try {
                Connection mysqlConn = DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD);
                if (!loggedActiveConnection) {
                    System.out.println(">>> [JDBC SUCCESS] Connected to real MySQL Server 8.4 on port 3306 (manufacturing_db)!");
                    loggedActiveConnection = true;
                }
                return mysqlConn;
            } catch (SQLException e) {
                System.out.println("MySQL connection on port 3306 failed (" + e.getMessage() + "). Falling back to embedded H2 database...");
                useH2 = true;
            }
        }

        return DriverManager.getConnection(H2_URL, H2_USER, H2_PASSWORD);
    }

    public static String getActiveDatabaseType() {
        return useH2 ? "H2 Database" : "MySQL Server (Port 3306)";
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
