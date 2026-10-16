package com.manufacturing.servlet;

import com.google.gson.Gson;
import com.manufacturing.db.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

@WebServlet("/query")
public class QueryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String queryType = request.getParameter("queryType");
        String sqlQuery = request.getParameter("query");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        try (Connection conn = DatabaseConnection.getConnection()) {
            Statement stmt = conn.createStatement();

            if ("DQL".equals(queryType)) {
                // SELECT queries
                ResultSet rs = stmt.executeQuery(sqlQuery);
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();

                List<String> columns = new ArrayList<>();
                for (int i = 1; i <= columnCount; i++) {
                    columns.add(metaData.getColumnName(i));
                }

                List<List<Object>> rows = new ArrayList<>();
                while (rs.next()) {
                    List<Object> row = new ArrayList<>();
                    for (int i = 1; i <= columnCount; i++) {
                        row.add(rs.getObject(i));
                    }
                    rows.add(row);
                }

                result.put("success", true);
                result.put("columns", columns);
                result.put("data", rows);
                result.put("rowCount", rows.size());

            } else if ("DML".equals(queryType)) {
                // INSERT, UPDATE, DELETE
                int affectedRows = stmt.executeUpdate(sqlQuery);
                result.put("success", true);
                result.put("message", "Query executed successfully");
                result.put("affectedRows", affectedRows);

            } else if ("DDL".equals(queryType)) {
                // CREATE, ALTER, DROP
                stmt.execute(sqlQuery);
                result.put("success", true);
                result.put("message", "DDL command executed successfully");
            }

        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }

        Gson gson = new Gson();
        out.print(gson.toJson(result));
        out.flush();
    }
}
