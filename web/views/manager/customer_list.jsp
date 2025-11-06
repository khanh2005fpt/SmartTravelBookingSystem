<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Danh sách khách hàng</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #5a2fc2;
            --primary-hover: #7a4ef3;
            --bg: #f8f7fc;
            --card: #ffffff;
            --text: #2d3748;
            --text-light: #718096;
            --border: #e2e8f0;
            --success: #48bb78;
            --danger: #f56565;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --radius: 12px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.6;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn {
            background: var(--primary);
            color: white;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #718096;
        }

        .btn-secondary:hover {
            background: #4a5568;
        }

        /* Toolbar */
        .toolbar {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        /* Search & Filter Section */
        .controls {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
            margin-bottom: 30px;
            padding: 20px;
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .control-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .control-group label {
            font-size: 14px;
            color: var(--text-light);
            font-weight: 500;
        }

        .input-wrapper {
            display: flex;
            gap: 8px;
        }

        input[type="text"], select {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            transition: border 0.2s;
        }

        input[type="text"]:focus, select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(90, 47, 194, 0.1);
        }

        .btn-search {
            background: var(--primary);
            color: white;
            border: none;
            padding: 0 14px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-search:hover {
            background: var(--primary-hover);
        }

        /* Table */
        .table-container {
            background: var(--card);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: var(--primary);
            color: white;
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
        }

        tr:hover {
            background-color: #f8f5ff;
        }

        .status-active {
            color: var(--success);
            font-weight: 600;
        }

        .status-inactive {
            color: var(--danger);
            font-weight: 600;
        }

        .action-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-light);
            font-style: italic;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .pagination a {
            padding: 8px 14px;
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text);
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s;
        }

        .pagination a:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .pagination a.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            font-weight: 600;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: stretch;
            }

            .toolbar {
                justify-content: center;
            }

            .controls {
                grid-template-columns: 1fr;
            }

            h2 {
                font-size: 1.5rem;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<div class="container">

    <!-- Header -->
    <div class="header">
        <h2>DANH SÁCH KHÁCH HÀNG</h2>
        <div class="toolbar">
            <!-- Nút Back to Dashboard (chỉ hiển thị nếu không phải dashboard) -->
            <%
                String requestURI = request.getRequestURI();
                if (!requestURI.contains("dashboard")) {
            %>
                <a href="<%=request.getContextPath()%>/manager/dashboard" class="btn btn-secondary">
                    ← Back to Dashboard
                </a>
            <%
                }
            %>
            
        </div>
    </div>

    <!-- Search & Filter -->
    <div class="controls">
        <!-- Search by Username -->
        <div class="control-group">
            <label>Tìm theo Username</label>
            <form action="<%=request.getContextPath()%>/manager/user" method="get" style="display:flex;gap:8px;width:100%;">
                <input type="hidden" name="action" value="searchUsername">
                <div class="input-wrapper">
                    <input type="text" name="keyword" placeholder="Nhập username...">
                    <button type="submit" class="btn-search">🔍</button>
                </div>
            </form>
        </div>

        <!-- Search by Full Name -->
        <div class="control-group">
            <label>Tìm theo Họ tên</label>
            <form action="<%=request.getContextPath()%>/manager/user" method="get" style="display:flex;gap:8px;width:100%;">
                <input type="hidden" name="action" value="searchFullName">
                <div class="input-wrapper">
                    <input type="text" name="keyword" placeholder="Nhập họ tên...">
                    <button type="submit" class="btn-search">🔍</button>
                </div>
            </form>
        </div>

        <!-- Search by Email -->
        <div class="control-group">
            <label>Tìm theo Email</label>
            <form action="<%=request.getContextPath()%>/manager/user" method="get" style="display:flex;gap:8px;width:100%;">
                <input type="hidden" name="action" value="searchEmail">
                <div class="input-wrapper">
                    <input type="text" name="keyword" placeholder="Nhập email...">
                    <button type="submit" class="btn-search">🔍</button>
                </div>
            </form>
        </div>



        <!-- Filter by Status -->
        <div class="control-group">
            <label>Lọc theo Trạng thái</label>
            <form action="<%=request.getContextPath()%>/manager/user" method="get" style="display:flex;gap:8px;width:100%;">
                <input type="hidden" name="action" value="searchStatus">
                <div class="input-wrapper">
                    <select name="status">
                        <option value="">-- Chọn trạng thái --</option>
                        <%
                            List<String> statuses = (List<String>) request.getAttribute("statuses");
                            if (statuses != null) {
                                for (String s : statuses) {
                        %>
                            <option value="<%=s%>"><%=s%></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <button type="submit" class="btn-search">Áp dụng</button>
                </div>
            </form>
        </div>
    </div>

    <!-- User Table -->
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Điện thoại</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users != null && !users.isEmpty()) {
                        int i = 1;
                        for (User u : users) {
                %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= u.getUsername() %></td>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() %></td>
                        <td><%= u.getRole() %></td>
                        <td class="<%= "active".equalsIgnoreCase(u.getStatus()) ? "status-active" : "status-inactive" %>">
                            <%= u.getStatus() %>
                        </td>
                        <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 19) : "N/A" %></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/manager/user?action=view&id=<%=u.getUserId()%>" class="action-link">✏️ view</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="9" class="empty-state">Không tìm thấy người dùng nào.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="pagination">
        <%
            Integer currentPage = (Integer) request.getAttribute("page");
            Integer totalPages = (Integer) request.getAttribute("totalPages");
            if (currentPage == null) currentPage = 1;
            if (totalPages == null) totalPages = 1;

            if (currentPage > 1) {
        %>
            <a href="<%=request.getContextPath()%>/manager/user?page=<%=currentPage - 1%>">« Trước</a>
        <%
            }

            // Hiển thị trang gần đó
            int start = Math.max(1, currentPage - 2);
            int end = Math.min(totalPages, currentPage + 2);
            for (int p = start; p <= end; p++) {
                if (p == currentPage) {
        %>
                    <a class="active"><%=p%></a>
        <%
                } else {
        %>
                    <a href="<%=request.getContextPath()%>/manager/user?page=<%=p%>"><%=p%></a>
        <%
                }
            }

            if (currentPage < totalPages) {
        %>
            <a href="<%=request.getContextPath()%>/manager/user?page=<%=currentPage + 1%>">Tiếp »</a>
        <%
            }
        %>
    </div>

</div>

</body>
</html>