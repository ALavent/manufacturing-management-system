<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Easy Database Table Creator</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f1f5f9;
            color: #1e293b;
        }

        /* Top Navigation Bar */
        .navbar {
            background: linear-gradient(135deg, #312e81 0%, #4338ca 50%, #6d28d9 100%);
            color: white;
            padding: 16px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .navbar h1 {
            font-size: 22px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 12px;
            letter-spacing: -0.3px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .user-badge {
            background: rgba(255, 255, 255, 0.15);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            backdrop-filter: blur(8px);
        }

        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.2s;
        }

        .logout-btn:hover {
            background: rgba(255,255,255,0.35);
            transform: translateY(-1px);
        }

        /* JDBC & ODBC Status Banner */
        .status-banner {
            background: linear-gradient(90deg, #1e1b4b 0%, #312e81 100%);
            color: white;
            padding: 12px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
            font-weight: 600;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .status-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .pulse-dot {
            width: 9px;
            height: 9px;
            background: #22c55e;
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 10px #22c55e;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 8px rgba(34, 197, 94, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(34, 197, 94, 0); }
        }

        .driver-tag {
            background: rgba(255, 255, 255, 0.12);
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-family: monospace;
            letter-spacing: 0.5px;
        }

        /* Container Layout */
        .container {
            max-width: 1400px;
            margin: 28px auto;
            padding: 0 24px;
        }

        /* Tabs Header */
        .tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
            background: white;
            padding: 8px;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.04);
            border: 1px solid #e2e8f0;
        }

        .tab-btn {
            padding: 12px 26px;
            border: none;
            background: transparent;
            cursor: pointer;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            color: #64748b;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tab-btn:hover {
            color: #1e293b;
            background: #f8fafc;
        }

        .tab-btn.active {
            background: linear-gradient(135deg, #4338ca 0%, #6d28d9 100%);
            color: white;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
        }

        /* Tab Contents */
        .tab-content {
            display: none;
            background: white;
            padding: 36px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            border: 1px solid #e2e8f0;
        }

        .tab-content.active {
            display: block;
        }

        .section-header {
            margin-bottom: 28px;
        }

        .section-header h2 {
            font-size: 22px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .section-header p {
            color: #64748b;
            font-size: 14px;
        }

        /* Card Component */
        .card {
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            transition: border-color 0.2s;
        }

        .card:hover {
            border-color: #cbd5e1;
        }

        .card-title {
            font-size: 15px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            color: #334155;
            font-size: 13px;
        }

        input[type="text"], input[type="number"], select, textarea {
            width: 100%;
            padding: 11px 15px;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            color: #0f172a;
            transition: all 0.2s;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12);
        }

        /* Column Builder Grid Row */
        .column-row {
            display: grid;
            grid-template-columns: 2fr 2fr 1fr 1fr 1fr 40px;
            gap: 12px;
            align-items: center;
            margin-bottom: 12px;
            background: white;
            padding: 14px;
            border-radius: 10px;
            border: 1.5px solid #e2e8f0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            cursor: pointer;
            user-select: none;
        }

        .btn-add {
            background: #059669;
            color: white;
            padding: 9px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 700;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-add:hover {
            background: #047857;
            transform: translateY(-1px);
        }

        .btn-remove {
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 8px;
            width: 34px;
            height: 34px;
            cursor: pointer;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .btn-remove:hover {
            background: #dc2626;
            transform: scale(1.05);
        }

        .btn-primary {
            background: linear-gradient(135deg, #4338ca 0%, #6d28d9 100%);
            color: white;
            padding: 15px 36px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 800;
            transition: all 0.2s ease;
            box-shadow: 0 4px 15px rgba(67, 56, 202, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(67, 56, 202, 0.4);
        }

        .results {
            margin-top: 25px;
        }

        .success {
            background: #ecfdf5;
            color: #065f46;
            border: 1.5px solid #a7f3d0;
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .error {
            background: #fef2f2;
            color: #991b1b;
            border: 1.5px solid #fecaca;
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* Data Tables Styling */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 15px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            border: 1.5px solid #e2e8f0;
        }

        th, td {
            padding: 12px 18px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
        }

        th {
            background: #f8fafc;
            font-weight: 700;
            color: #334155;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: #f1f5f9;
        }

        .preview-sql {
            background: #0f172a;
            color: #38bdf8;
            padding: 18px;
            border-radius: 10px;
            font-family: 'JetBrains Mono', 'Consolas', monospace;
            font-size: 13.5px;
            white-space: pre-wrap;
            word-break: break-all;
            margin-top: 10px;
            border: 1px solid #1e293b;
        }

        .data-grid-table th {
            background: #e2e8f0;
        }

        .data-grid-table input {
            padding: 8px 12px;
            border: 1.5px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13px;
        }
    </style>
</head>
<body>

    <!-- Top Navigation Bar -->
    <div class="navbar">
        <h1>🛠️ Easy Database Table Creator</h1>
        <div class="user-info">
            <span class="user-badge">👤 <%= username %> (<%= role %>)</span>
            <a href="logout" class="logout-btn">Sign Out</a>
        </div>
    </div>

    <!-- Connection Status Banner displaying JDBC & ODBC Info -->
    <div class="status-banner">
        <div class="status-left">
            <span class="pulse-dot"></span>
            <span>Connected to Database via <strong>JDBC</strong> and <strong>ODBC</strong> Interface</span>
        </div>
        <div>
            <span class="driver-tag">JDBC: MySQL / H2 Compliant</span>
            &nbsp;
            <span class="driver-tag">ODBC: DSN Active</span>
        </div>
    </div>

    <div class="container">
        <!-- Main Navigation Tabs -->
        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab('creator')">✨ Visual Table Creator</button>
            <button class="tab-btn" onclick="switchTab('explorer'); loadTableList();">📂 Explore & Add Data</button>
            <button class="tab-btn" onclick="switchTab('sql')">💻 Advanced SQL Editor</button>
        </div>

        <!-- TAB 1: VISUAL TABLE CREATOR (NO-CODE) -->
        <div id="creator-tab" class="tab-content active">
            <div class="section-header">
                <h2>Create Table & Enter Column Values</h2>
                <p>Enter table details and column values to automatically construct and execute DDL & DML commands over JDBC/ODBC connection.</p>
            </div>

            <!-- Step 1: Table Name -->
            <div class="card">
                <div class="card-title">1️⃣ Step 1: Table Name</div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label for="table-name">Enter Table Name:</label>
                    <input type="text" id="table-name" placeholder="e.g. Apple, employees, customers" oninput="updateSqlPreview()">
                </div>
            </div>

            <!-- Step 2: Columns Builder -->
            <div class="card">
                <div class="card-title" style="justify-content: space-between;">
                    <span>2️⃣ Step 2: Define Columns & Types</span>
                    <button class="btn-add" onclick="addColumnRow()">+ Add Column</button>
                </div>
                
                <div id="columns-container">
                    <!-- Default columns added on load -->
                </div>
            </div>

            <!-- Step 3: Initial Data Rows Input -->
            <div class="card">
                <div class="card-title" style="justify-content: space-between;">
                    <span>3️⃣ Step 3: Enter Row Values</span>
                    <button class="btn-add" onclick="addDataRow()">+ Add Row of Data</button>
                </div>
                <p style="color: #64748b; font-size: 13px; margin-bottom: 15px;">Fill in values for each column to populate data into your new table:</p>
                <div id="data-rows-container" style="overflow-x: auto;">
                    <!-- Data grid generated dynamically -->
                </div>
            </div>

            <!-- Generated SQL Preview -->
            <div class="card">
                <div class="card-title">🔍 Real-Time Generated SQL Preview</div>
                <div id="sql-preview" class="preview-sql">CREATE TABLE `example` (...);</div>
            </div>

            <button class="btn-primary" onclick="submitCreateTable()">🚀 Create Table & Load Data via JDBC/ODBC</button>

            <div id="creator-results" class="results"></div>
        </div>

        <!-- TAB 2: EXPLORE TABLES & QUICK DATA ENTRY -->
        <div id="explorer-tab" class="tab-content">
            <div class="section-header">
                <h2>Browse Database Tables & Add New Rows</h2>
                <p>Select any table connected via JDBC/ODBC to view its schema, existing rows, and insert new data directly.</p>
            </div>

            <div class="card">
                <div class="form-group" style="margin-bottom: 0;">
                    <label for="table-select">Select Table to View:</label>
                    <select id="table-select" onchange="viewSelectedTable()">
                        <option value="">-- Select Table --</option>
                    </select>
                </div>
            </div>

            <div id="table-view-container"></div>
        </div>

        <!-- TAB 3: ADVANCED SQL QUERY EDITOR -->
        <div id="sql-tab" class="tab-content">
            <div class="section-header">
                <h2>Raw SQL Command Execution</h2>
                <p>Execute custom DQL, DML, or DDL SQL commands over the active JDBC/ODBC driver connection.</p>
            </div>

            <div class="query-section">
                <label for="raw-query-type">Query Type:</label>
                <select id="raw-query-type" style="margin-bottom: 14px;">
                    <option value="DQL">DQL (SELECT)</option>
                    <option value="DML">DML (INSERT / UPDATE / DELETE)</option>
                    <option value="DDL">DDL (CREATE / ALTER / DROP)</option>
                </select>

                <label for="raw-query-text">SQL Command:</label>
                <textarea id="raw-query-text" style="min-height:140px;" placeholder="SELECT * FROM products;"></textarea>
                <button class="btn-primary" style="margin-top:14px;" onclick="executeRawSql()">Execute SQL Statement</button>
            </div>

            <div id="sql-results" class="results"></div>
        </div>
    </div>

    <script>
        window.onload = function() {
            // Add default starter columns
            addColumnRow('id', 'INT', true, true, true);
            addColumnRow('name', 'VARCHAR(100)', false, false, true);
            addColumnRow('amount', 'DECIMAL(10,2)', false, false, false);
            addColumnRow('age', 'INT', false, false, false);
            
            addDataRow();
            addDataRow();
            updateSqlPreview();
        };

        function switchTab(tabName) {
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

            event.currentTarget.classList.add('active');
            document.getElementById(tabName + '-tab').classList.add('active');
        }

        function addColumnRow(defaultName = '', defaultType = 'VARCHAR(100)', defaultPk = false, defaultAi = false, defaultNotNull = false) {
            const container = document.getElementById('columns-container');
            const rowId = 'col-row-' + Date.now() + '-' + Math.floor(Math.random() * 1000);

            const div = document.createElement('div');
            div.className = 'column-row';
            div.id = rowId;
            div.innerHTML = `
                <input type="text" class="col-name" placeholder="Column Name (e.g. price)" value="\${defaultName}" oninput="refreshDataGridHeader(); updateSqlPreview();">
                <select class="col-type" onchange="updateSqlPreview()">
                    <option value="VARCHAR(100)" \${defaultType === 'VARCHAR(100)' ? 'selected' : ''}>Text (VARCHAR 100)</option>
                    <option value="VARCHAR(255)" \${defaultType === 'VARCHAR(255)' ? 'selected' : ''}>Long Text (VARCHAR 255)</option>
                    <option value="INT" \${defaultType === 'INT' ? 'selected' : ''}>Number / Integer (INT)</option>
                    <option value="DECIMAL(10,2)" \${defaultType === 'DECIMAL(10,2)' ? 'selected' : ''}>Decimal / Price (DECIMAL)</option>
                    <option value="DATE" \${defaultType === 'DATE' ? 'selected' : ''}>Date (DATE)</option>
                    <option value="TEXT" \${defaultType === 'TEXT' ? 'selected' : ''}>Description (TEXT)</option>
                </select>
                <label class="checkbox-label"><input type="checkbox" class="col-pk" \${defaultPk ? 'checked' : ''} onchange="updateSqlPreview()"> Primary Key</label>
                <label class="checkbox-label"><input type="checkbox" class="col-ai" \${defaultAi ? 'checked' : ''} onchange="updateSqlPreview()"> Auto Inc</label>
                <label class="checkbox-label"><input type="checkbox" class="col-nn" \${defaultNotNull ? 'checked' : ''} onchange="updateSqlPreview()"> Not Null</label>
                <button class="btn-remove" onclick="removeColumnRow('\${rowId}')">✕</button>
            `;
            container.appendChild(div);
            refreshDataGridHeader();
            updateSqlPreview();
        }

        function removeColumnRow(rowId) {
            const element = document.getElementById(rowId);
            if (element) {
                element.remove();
                refreshDataGridHeader();
                updateSqlPreview();
            }
        }

        function refreshDataGridHeader() {
            const container = document.getElementById('data-rows-container');
            const colNameElements = document.querySelectorAll('.col-name');
            
            let cols = [];
            colNameElements.forEach(el => {
                const name = el.value.trim();
                const isAi = el.closest('.column-row').querySelector('.col-ai').checked;
                if (name && !isAi) {
                    cols.push(name);
                }
            });

            if (cols.length === 0) {
                container.innerHTML = '<p style="color:#94a3b8;">Add non-auto-increment column names above to enter row values.</p>';
                return;
            }

            let html = '<table class="data-grid-table"><thead><tr>';
            cols.forEach(c => {
                html += '<th>' + c + '</th>';
            });
            html += '<th style="width:50px;">Remove</th></tr></thead><tbody id="data-grid-body">';

            // Maintain current rows data if possible
            const existingRows = document.querySelectorAll('.grid-data-row');
            if (existingRows.length > 0) {
                existingRows.forEach(row => {
                    html += '<tr class="grid-data-row">';
                    cols.forEach(c => {
                        const existingInput = row.querySelector('input[data-col="' + c + '"]');
                        const val = existingInput ? existingInput.value : '';
                        html += '<td><input type="text" data-col="' + c + '" value="' + val + '" placeholder="Enter ' + c + '"></td>';
                    });
                    html += '<td><button class="btn-remove" onclick="this.closest(\'tr\').remove()">✕</button></td></tr>';
                });
            } else {
                html += renderDataRowHtml(cols);
                html += renderDataRowHtml(cols);
            }

            html += '</tbody></table>';
            container.innerHTML = html;
        }

        function renderDataRowHtml(cols) {
            let html = '<tr class="grid-data-row">';
            cols.forEach(c => {
                html += '<td><input type="text" data-col="' + c + '" placeholder="Enter ' + c + '"></td>';
            });
            html += '<td><button class="btn-remove" onclick="this.closest(\'tr\').remove()">✕</button></td></tr>';
            return html;
        }

        function addDataRow() {
            const tbody = document.getElementById('data-grid-body');
            if (!tbody) {
                refreshDataGridHeader();
                return;
            }

            const colInputs = document.querySelectorAll('.col-name');
            let cols = [];
            colInputs.forEach(el => {
                const name = el.value.trim();
                const isAi = el.closest('.column-row').querySelector('.col-ai').checked;
                if (name && !isAi) {
                    cols.push(name);
                }
            });

            if (cols.length === 0) return;

            const tr = document.createElement('tr');
            tr.className = 'grid-data-row';
            let html = '';
            cols.forEach(c => {
                html += '<td><input type="text" data-col="' + c + '" placeholder="Enter ' + c + '"></td>';
            });
            html += '<td><button class="btn-remove" onclick="this.closest(\'tr\').remove()">✕</button></td>';
            tr.innerHTML = html;
            tbody.appendChild(tr);
        }

        function updateSqlPreview() {
            const tableName = document.getElementById('table-name').value.trim() || 'my_table';
            const colRows = document.querySelectorAll('.column-row');

            let defs = [];
            colRows.forEach(row => {
                const name = row.querySelector('.col-name').value.trim();
                const type = row.querySelector('.col-type').value;
                const isPk = row.querySelector('.col-pk').checked;
                const isAi = row.querySelector('.col-ai').checked;
                const isNn = row.querySelector('.col-nn').checked;

                if (name) {
                    let stmt = '  `' + name + '` ' + type;
                    if (isPk) stmt += ' PRIMARY KEY';
                    if (isAi) stmt += ' AUTO_INCREMENT';
                    if (isNn) stmt += ' NOT NULL';
                    defs.push(stmt);
                }
            });

            let sql = 'CREATE TABLE `' + tableName + '` (\n';
            sql += defs.length > 0 ? defs.join(',\n') : '  -- add columns above --';
            sql += '\n);';

            document.getElementById('sql-preview').innerText = sql;
        }

        function submitCreateTable() {
            const tableName = document.getElementById('table-name').value.trim();
            const resultsDiv = document.getElementById('creator-results');

            if (!tableName) {
                resultsDiv.innerHTML = '<div class="error">Please enter a Table Name!</div>';
                return;
            }

            const colRows = document.querySelectorAll('.column-row');
            let columns = [];
            colRows.forEach(row => {
                const name = row.querySelector('.col-name').value.trim();
                const type = row.querySelector('.col-type').value;
                const isPrimary = row.querySelector('.col-pk').checked;
                const autoIncrement = row.querySelector('.col-ai').checked;
                const notNull = row.querySelector('.col-nn').checked;

                if (name) {
                    columns.push({ name, type, isPrimary, autoIncrement, notNull });
                }
            });

            if (columns.length === 0) {
                resultsDiv.innerHTML = '<div class="error">Please add at least one column!</div>';
                return;
            }

            // Gather rows of values
            let rows = [];
            const dataRows = document.querySelectorAll('.grid-data-row');
            dataRows.forEach(dRow => {
                let rowObj = {};
                let hasVal = false;
                const inputs = dRow.querySelectorAll('input[data-col]');
                inputs.forEach(input => {
                    const colName = input.getAttribute('data-col');
                    const val = input.value.trim();
                    if (val) hasVal = true;
                    rowObj[colName] = val;
                });
                if (hasVal) {
                    rows.push(rowObj);
                }
            });

            resultsDiv.innerHTML = '<div class="success">Executing table creation over JDBC/ODBC connection...</div>';

            fetch('table-builder', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    action: 'createTable',
                    tableName: tableName,
                    columns: columns,
                    rows: rows
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    resultsDiv.innerHTML = `
                        <div class="success">
                            ✅ <strong>Success!</strong> \${data.message}
                        </div>
                    `;
                    loadTableList();
                } else {
                    resultsDiv.innerHTML = '<div class="error">❌ Error: ' + data.error + '</div>';
                }
            })
            .catch(err => {
                resultsDiv.innerHTML = '<div class="error">❌ Network error: ' + err + '</div>';
            });
        }

        // Explorer & Table Browser Functions
        function loadTableList() {
            fetch('table-builder?action=listTables')
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    const select = document.getElementById('table-select');
                    select.innerHTML = '<option value="">-- Select Table --</option>';
                    data.tables.forEach(t => {
                        select.innerHTML += '<option value="' + t + '">' + t + '</option>';
                    });
                }
            });
        }

        function viewSelectedTable() {
            const tableName = document.getElementById('table-select').value;
            const container = document.getElementById('table-view-container');
            if (!tableName) {
                container.innerHTML = '';
                return;
            }

            container.innerHTML = '<p>Loading table data over JDBC/ODBC connection...</p>';

            fetch('table-builder?action=getTableData&tableName=' + encodeURIComponent(tableName))
            .then(res => res.json())
            .then(data => {
                if (!data.success) {
                    container.innerHTML = '<div class="error">' + data.error + '</div>';
                    return;
                }

                let html = '<div class="card">';
                html += '<div class="card-title">📊 Data for Table: <strong>' + data.tableName + '</strong></div>';
                
                // Add Quick Insert Row Form
                html += '<div style="background:white; padding:18px; border-radius:10px; border:1.5px solid #e2e8f0; margin-bottom:20px;">';
                html += '<h4 style="margin-bottom:14px; color:#1e293b; font-weight:700;">➕ Insert New Row into ' + data.tableName + ':</h4>';
                html += '<div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap:14px; margin-bottom:14px;">';
                
                data.columns.forEach(col => {
                    html += '<div>';
                    html += '<label style="font-size:12px; font-weight:700; color:#475569;">' + col + '</label>';
                    html += '<input type="text" class="new-row-val" data-col="' + col + '" placeholder="Enter ' + col + '">';
                    html += '</div>';
                });
                
                html += '</div>';
                html += '<button class="btn-add" onclick="insertRowIntoTable(\'' + data.tableName + '\')">+ Save Row</button>';
                html += '<div id="insert-row-msg" style="margin-top:10px;"></div>';
                html += '</div>';

                // Display Existing Data Table
                if (data.rows.length === 0) {
                    html += '<p style="color:#64748b;">Table is currently empty.</p>';
                } else {
                    html += '<table><thead><tr>';
                    data.columns.forEach(col => {
                        html += '<th>' + col + '</th>';
                    });
                    html += '</tr></thead><tbody>';

                    data.rows.forEach(row => {
                        html += '<tr>';
                        row.forEach(cell => {
                            html += '<td>' + (cell !== null ? cell : '<span style="color:#94a3b8;">NULL</span>') + '</td>';
                        });
                        html += '</tr>';
                    });

                    html += '</tbody></table>';
                }

                html += '</div>';
                container.innerHTML = html;
            });
        }

        function insertRowIntoTable(tableName) {
            const inputs = document.querySelectorAll('.new-row-val');
            let rowValues = {};
            inputs.forEach(input => {
                const col = input.getAttribute('data-col');
                const val = input.value.trim();
                if (val) {
                    rowValues[col] = val;
                }
            });

            const msgDiv = document.getElementById('insert-row-msg');

            fetch('table-builder', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    action: 'insertRow',
                    tableName: tableName,
                    rowValues: rowValues
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    msgDiv.innerHTML = '<div class="success">' + data.message + '</div>';
                    viewSelectedTable();
                } else {
                    msgDiv.innerHTML = '<div class="error">' + data.error + '</div>';
                }
            });
        }

        function executeRawSql() {
            const type = document.getElementById('raw-query-type').value;
            const query = document.getElementById('raw-query-text').value;
            const resultsDiv = document.getElementById('sql-results');

            if (!query.trim()) {
                resultsDiv.innerHTML = '<div class="error">Please enter an SQL query!</div>';
                return;
            }

            resultsDiv.innerHTML = '<p>Executing query...</p>';

            fetch('query', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'queryType=' + type + '&query=' + encodeURIComponent(query)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (type === 'DQL') {
                        let html = '<div class="success">Query returned ' + data.rowCount + ' rows</div>';
                        if (data.data.length > 0) {
                            html += '<table><thead><tr>';
                            data.columns.forEach(col => html += '<th>' + col + '</th>');
                            html += '</tr></thead><tbody>';
                            data.data.forEach(row => {
                                html += '<tr>';
                                row.forEach(cell => html += '<td>' + (cell !== null ? cell : 'NULL') + '</td>');
                                html += '</tr>';
                            });
                            html += '</tbody></table>';
                        }
                        resultsDiv.innerHTML = html;
                    } else {
                        resultsDiv.innerHTML = '<div class="success">' + data.message + '</div>';
                    }
                } else {
                    resultsDiv.innerHTML = '<div class="error">Error: ' + data.error + '</div>';
                }
            });
        }
    </script>
</body>
</html>
