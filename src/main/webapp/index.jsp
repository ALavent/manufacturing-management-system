<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Creator & Management System - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311b92 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 42px 36px;
            border-radius: 16px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.35);
            width: 420px;
            max-width: 100%;
        }

        .header-logo {
            text-align: center;
            margin-bottom: 24px;
        }

        .header-logo h1 {
            font-size: 24px;
            font-weight: 800;
            color: #1e293b;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }

        .header-logo p {
            color: #64748b;
            font-size: 14px;
        }

        .conn-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 24px;
            text-align: center;
        }

        .conn-dot {
            width: 8px;
            height: 8px;
            background: #0284c7;
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 8px #0284c7;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            background: #f8fafc;
            transition: all 0.2s ease;
        }

        input:focus {
            outline: none;
            border-color: #6366f1;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
            margin-top: 10px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
        }

        .error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .info-box {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            padding: 14px 16px;
            border-radius: 8px;
            margin-top: 24px;
            font-size: 13px;
            color: #475569;
            line-height: 1.5;
        }

        .info-box strong {
            color: #1e293b;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="header-logo">
            <h1>🛠️ Database Creator</h1>
            <p>No-Code Table Builder & Management Interface</p>
        </div>

        <div class="conn-badge">
            <span class="conn-dot"></span>
            Connected to Database via JDBC and ODBC Interface
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter username" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter password" required>
            </div>

            <button type="submit" class="btn">Sign In to Dashboard</button>
        </form>

        <div class="info-box">
            <strong>Default Demo Credentials:</strong><br>
            Username: <code>admin</code> &nbsp;|&nbsp; Password: <code>admin123</code><br>
            Username: <code>user</code> &nbsp;&nbsp;|&nbsp; Password: <code>user123</code>
        </div>
    </div>
</body>
</html>
