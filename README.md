# 🏭 Manufacturing Management System & Visual Database Builder

A modern, interactive web-based Database Management System interface using **Java Servlets**, **JDBC**, and **MySQL** to perform real-time **DDL**, **DML**, and **DQL** operations without requiring manual SQL writing.

![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Java](https://img.shields.io/badge/Java-17%20%7C%2026-orange)
![Database](https://img.shields.io/badge/Database-MySQL%208.4%20%7C%20H2-blue)
![Connectivity](https://img.shields.io/badge/Connectivity-JDBC%20%7C%20ODBC-purple)

---

## 🌟 Key Features

- ✨ **Visual No-Code Table Creator**: Create custom tables simply by typing column names, choosing types (`INT`, `VARCHAR`, `DECIMAL`, `DATE`, `TEXT`), setting constraints (`Primary Key`, `Auto Increment`, `Not Null`), and typing initial rows in an interactive grid.
- 🔍 **Real-Time SQL Preview**: Dynamic syntax engine generates safe, backtick-escaped SQL statements live as you configure table schemas.
- 📂 **Database Explorer & Inline Data Inserter**: Select any existing database table (`products`, `orders`, `suppliers`, custom tables), inspect records, and insert new data directly from an inline form.
- 💻 **Advanced Raw SQL Terminal**: Direct query editor supporting DQL (`SELECT`), DML (`INSERT`, `UPDATE`, `DELETE`), and DDL (`CREATE`, `ALTER`, `DROP`).
- 🔐 **Authentication System**: Role-based access control with session management.
- 🔌 **Dual Database Engine Support**: Connects directly to **MySQL Server 8.4** on port `3306` with automatic zero-configuration fallback to an embedded **H2** database.
- ⚡ **1-Click Launch Scripts**: Pre-configured Windows batch files for instant setup.

---

## 🛠️ Technologies Used

- **Backend**: Java Servlets 6.0, JDBC (Type 4 Pure Java Driver), Embedded Apache Tomcat 10
- **Frontend**: JSP, HTML5, CSS3 (Modern Glassmorphic UI), JavaScript (ES6 Fetch API)
- **Database**: MySQL Server 8.4 (`com.mysql.cj.jdbc.Driver`), H2 Embedded Engine (`org.h2.Driver`)
- **JSON Processing**: Google Gson
- **Build Tool**: Apache Maven

---

## 🚀 Quick Start (Windows)

### 1. Start MySQL Server (Port 3306)
Double-click:
```bat
start_mysql.bat
```
*(Runs MySQL Server 8.4 on port 3306).*

### 2. Start the Web Application (Port 8085)
Double-click:
```bat
start_app.bat
```
Or run in PowerShell/Terminal:
```powershell
mvn compile exec:java
```

### 3. Access in Browser
Visit: **[http://localhost:8085/](http://localhost:8085/)**

---

## 🔑 Default Credentials

| Username | Password | Role |
| :--- | :--- | :--- |
| `admin` | `admin123` | Administrator |
| `user` | `user123` | Standard User |

---

## 📂 Project Structure

```
dbms project/
├── .gitignore
├── pom.xml                                    # Maven configuration & dependencies
├── README.md                                  # Project documentation
├── start_mysql.bat                            # 1-click script to launch MySQL 8.4
├── start_app.bat                              # 1-click script to launch web server
├── mysql_cli.bat                              # 1-click script to open MySQL CLI
├── database/
│   └── schema.sql                             # Initial database schema & seed data
└── src/
    └── main/
        ├── java/com/manufacturing/
        │   ├── ServerRunner.java              # Embedded Tomcat server bootstrap
        │   ├── db/
        │   │   └── DatabaseConnection.java    # JDBC connection manager (MySQL + H2 fallback)
        │   ├── model/
        │   │   └── User.java                  # User data model
        │   └── servlet/
        │       ├── LoginServlet.java          # Authentication controller
        │       ├── LogoutServlet.java         # Session cleanup controller
        │       ├── QueryServlet.java          # Raw SQL execution endpoint
        │       └── TableBuilderServlet.java   # No-code visual schema builder endpoint
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml                    # Deployment descriptor
            ├── index.jsp                      # Login page
            └── dashboard.jsp                  # Main interactive visual dashboard
```

---

## 🔌 JDBC and ODBC Connectivity Architecture

1. **JDBC (Java Database Connectivity)**:
   - Uses the official MySQL Connector/J **Type 4 Direct JDBC driver**.
   - Connects directly to `jdbc:mysql://localhost:3306/manufacturing_db`.
   - Uses parameterized `PreparedStatement` to ensure SQL injection protection.

2. **ODBC (Open Database Connectivity)**:
   - Configured via Windows ODBC Data Source Administrator (`odbcad32.exe`).
   - Create a System DSN named `ManufacturingDSN` pointing to MySQL or Oracle XE.
   - Allows external reporting and desktop applications (Excel, Power BI, Python `pyodbc`) to query the same database tables.

---

## 📄 License

This project is created for educational and academic demonstration purposes.
