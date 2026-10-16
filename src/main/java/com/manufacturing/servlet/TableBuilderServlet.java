package com.manufacturing.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.manufacturing.db.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

@WebServlet("/table-builder")
public class TableBuilderServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        String action = request.getParameter("action");

        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("listTables".equals(action)) {
                List<String> tables = new ArrayList<>();
                DatabaseMetaData metaData = conn.getMetaData();
                try (ResultSet rs = metaData.getTables(null, null, "%", new String[]{"TABLE"})) {
                    while (rs.next()) {
                        String name = rs.getString("TABLE_NAME");
                        if (!name.startsWith("SYSTEM_") && !name.startsWith("INFORMATION_SCHEMA")) {
                            tables.add(name);
                        }
                    }
                }
                result.put("success", true);
                result.put("tables", tables);

            } else if ("getTableData".equals(action)) {
                String tableName = request.getParameter("tableName");
                if (tableName == null || !tableName.matches("^[a-zA-Z0-9_]+$")) {
                    result.put("success", false);
                    result.put("error", "Invalid table name");
                } else {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM `" + tableName + "`");
                    ResultSetMetaData meta = rs.getMetaData();
                    int colCount = meta.getColumnCount();

                    List<String> columns = new ArrayList<>();
                    for (int i = 1; i <= colCount; i++) {
                        columns.add(meta.getColumnName(i));
                    }

                    List<List<Object>> rows = new ArrayList<>();
                    while (rs.next()) {
                        List<Object> row = new ArrayList<>();
                        for (int i = 1; i <= colCount; i++) {
                            row.add(rs.getObject(i));
                        }
                        rows.add(row);
                    }

                    result.put("success", true);
                    result.put("tableName", tableName);
                    result.put("columns", columns);
                    result.put("rows", rows);
                }
            }
        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        out.print(gson.toJson(result));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        StringBuilder jsonBuffer = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        try {
            JsonObject body = gson.fromJson(jsonBuffer.toString(), JsonObject.class);
            String action = body.has("action") ? body.get("action").getAsString() : "createTable";

            try (Connection conn = DatabaseConnection.getConnection()) {
                if ("createTable".equals(action)) {
                    String tableName = body.get("tableName").getAsString().trim();
                    if (!tableName.matches("^[a-zA-Z0-9_]+$")) {
                        throw new IllegalArgumentException("Invalid table name. Use letters, numbers, and underscores.");
                    }

                    JsonArray columns = body.getAsJsonArray("columns");
                    if (columns == null || columns.size() == 0) {
                        throw new IllegalArgumentException("At least one column is required.");
                    }

                    StringBuilder sql = new StringBuilder("CREATE TABLE `").append(tableName).append("` (\n");

                    List<String> colDefs = new ArrayList<>();
                    List<String> insertColNames = new ArrayList<>();

                    for (int i = 0; i < columns.size(); i++) {
                        JsonObject col = columns.get(i).getAsJsonObject();
                        String name = col.get("name").getAsString().trim();
                        String type = col.get("type").getAsString().trim();
                        boolean isPrimary = col.has("isPrimary") && col.get("isPrimary").getAsBoolean();
                        boolean autoIncrement = col.has("autoIncrement") && col.get("autoIncrement").getAsBoolean();
                        boolean notNull = col.has("notNull") && col.get("notNull").getAsBoolean();

                        if (!name.matches("^[a-zA-Z0-9_]+$")) {
                            throw new IllegalArgumentException("Invalid column name: " + name);
                        }

                        StringBuilder colSql = new StringBuilder("  `").append(name).append("` ").append(type);
                        if (isPrimary) {
                            colSql.append(" PRIMARY KEY");
                        }
                        if (autoIncrement) {
                            colSql.append(" AUTO_INCREMENT");
                        }
                        if (notNull) {
                            colSql.append(" NOT NULL");
                        }

                        colDefs.add(colSql.toString());

                        if (!autoIncrement) {
                            insertColNames.add(name);
                        }
                    }

                    sql.append(String.join(",\n", colDefs));
                    sql.append("\n);");

                    String createSql = sql.toString();
                    Statement stmt = conn.createStatement();
                    stmt.execute(createSql);

                    int insertedRowsCount = 0;
                    if (body.has("rows") && body.get("rows").isJsonArray()) {
                        JsonArray rows = body.getAsJsonArray("rows");
                        if (rows.size() > 0 && insertColNames.size() > 0) {
                            StringBuilder insertSql = new StringBuilder("INSERT INTO `");
                            insertSql.append(tableName).append("` (`");
                            insertSql.append(String.join("`, `", insertColNames));
                            insertSql.append("`) VALUES (");

                            String[] placeholders = new String[insertColNames.size()];
                            Arrays.fill(placeholders, "?");
                            insertSql.append(String.join(", ", placeholders)).append(")");

                            PreparedStatement pstmt = conn.prepareStatement(insertSql.toString());

                            for (JsonElement rowElem : rows) {
                                JsonObject rowObj = rowElem.getAsJsonObject();
                                for (int k = 0; k < insertColNames.size(); k++) {
                                    String colName = insertColNames.get(k);
                                    String val = rowObj.has(colName) && !rowObj.get(colName).isJsonNull()
                                            ? rowObj.get(colName).getAsString() : null;
                                    if (val == null || val.trim().isEmpty()) {
                                        pstmt.setNull(k + 1, Types.NULL);
                                    } else {
                                        pstmt.setString(k + 1, val);
                                    }
                                }
                                pstmt.addBatch();
                                insertedRowsCount++;
                            }
                            pstmt.executeBatch();
                        }
                    }

                    result.put("success", true);
                    result.put("message", "Table '" + tableName + "' created successfully with " + insertedRowsCount + " rows!");
                    result.put("tableName", tableName);
                    result.put("sql", createSql);

                } else if ("insertRow".equals(action)) {
                    String tableName = body.get("tableName").getAsString().trim();
                    JsonObject rowValues = body.getAsJsonObject("rowValues");

                    List<String> cols = new ArrayList<>();
                    List<String> vals = new ArrayList<>();
                    List<String> placeholders = new ArrayList<>();

                    for (String key : rowValues.keySet()) {
                        cols.add("`" + key + "`");
                        vals.add(rowValues.get(key).getAsString());
                        placeholders.add("?");
                    }

                    String sql = "INSERT INTO `" + tableName + "` (" + String.join(", ", cols) + ") VALUES (" + String.join(", ", placeholders) + ")";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    for (int i = 0; i < vals.size(); i++) {
                        pstmt.setString(i + 1, vals.get(i));
                    }
                    int affected = pstmt.executeUpdate();

                    result.put("success", true);
                    result.put("message", "Row inserted successfully (" + affected + " row affected).");
                }
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        out.print(gson.toJson(result));
        out.flush();
    }
}
