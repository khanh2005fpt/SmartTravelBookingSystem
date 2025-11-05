<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Log Hệ Thống</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f5f6fa;
            margin: 0;
        }
        .main-content {
            padding: 40px 50px;
            margin-left: 250px;
            margin-top: 80px;
        }
        h1 {
            color: #5a2fc2;
            margin-bottom: 25px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        h1::before {
            content: "📜";
            font-size: 28px;
        }
        .search-bars {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }
        input[type="text"], select {
            padding: 10px 14px;
            font-size: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            outline: none;
        }
        button {
            background: #5a2fc2;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }
        button:hover { background: #3f1ea4; }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 14px 16px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        th { background: #5a2fc2; color: white; font-weight: 600; }
        tr:hover { background: #f8f5ff; }

        .method {
            padding: 5px 12px;
            border-radius: 6px;
            color: white;
            font-weight: 600;
            display: inline-block;
        }
        .GET { background: #27ae60; }
        .POST { background: #5a2fc2; }
        .PUT { background: #f39c12; }
        .DELETE { background: #c0392b; }

        .role-badge {
            padding: 5px 10px;
            border-radius: 6px;
            background: #f1eefc;
            color: #2d3436;
            font-weight: 600;
            display: inline-block;
            border: 1px solid #d3c6f5;
        }
        a.detail {
            color: #5a2fc2;
            text-decoration: none;
            font-weight: 600;
        }
        a.detail:hover { text-decoration: underline; }

        .no-data {
            text-align: center;
            color: #555;
            font-style: italic;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
   <!-- Include Sidebar -->
       <%@ include file="/views/staff/sidebar.jsp" %>

<div class="main-content">
    <h1>Log Hệ Thống</h1>

    <!-- Thanh tìm kiếm -->
    <div class="search-bars">
        <!-- Search theo User -->
        <form action="logs" method="get">
            <input type="text" name="searchUser"
                   placeholder="Tìm theo tên hoặc email người dùng..."
                   value="${keywordUser}">
            <button type="submit">Tìm User</button>
        </form>

        <!-- Search theo Action -->
        <form action="logs" method="get">
            <select name="searchAction">
                <option value="ALL">-- Chọn Action --</option>
                <c:forEach var="a" items="${actions}">
                    <option value="${a}" ${selectedAction == a ? 'selected' : ''}>${a}</option>
                </c:forEach>
            </select>
            <button type="submit">Lọc Action</button>
        </form>

        <!-- Search theo Role -->
        <form action="logs" method="get">
            <select name="searchRole">
                <option value="ALL">-- Chọn Vai Trò --</option>
                <c:forEach var="r" items="${roles}">
                    <option value="${r.roleName}" ${selectedRole == r.roleName ? 'selected' : ''}>${r.roleName}</option>
                </c:forEach>
            </select>
            <button type="submit">Lọc Role</button>
        </form>
    </div>

    <!-- Bảng logs -->
    <c:choose>
        <c:when test="${not empty logs}">
            <table>
                <tr>
                    <th>Người dùng</th>
                    <th>Vai trò</th>
                    <th>Action</th>
                    <th>Method</th>
                    <th>Timestamp</th>
                    <th>Chi tiết</th>
                </tr>
                <c:forEach var="log" items="${logs}">
                    <tr>
                        <td>${log.username}</td>
                        <td>
                            <span class="role-badge">${log.roleName}</span>
                        </td>
                        <td>${log.action}</td>
                        <td><span class="method ${log.method}">${log.method}</span></td>
                        <td>${log.timestamp}</td>
                        <td><a class="detail" href="logs?id=${log.logId}">Xem</a></td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <div class="no-data">Không có dữ liệu phù hợp</div>
        </c:otherwise>
    </c:choose>
</div>


</body>
</html>
