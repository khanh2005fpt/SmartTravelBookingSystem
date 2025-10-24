<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách khách hàng</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <%@include file="/views/common/css.jsp" %>
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --body-bg: #f4f7f6;
            --border-color: #dee2e6;
        }

        body {
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            background-color: var(--body-bg);
            margin: 0;
            color: var(--dark-color);
        }

        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 40px auto;
        }

        .content-card {
            background-color: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--dark-color);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
        }

        th, td {
            border-bottom: 1px solid var(--border-color);
            padding: 12px 14px;
            text-align: left;
        }

        th {
            background-color: var(--light-color);
            font-weight: 600;
        }

        tr:hover {
            background-color: #f0f8ff;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
            min-width: 80px;
            text-align: center;
        }

        .status-active { background-color: var(--success-color); }
        .status-inactive { background-color: var(--danger-color); }

        .filter-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .filter-bar form {
            display: inline-flex;
            gap: 8px;
            align-items: center;
        }

        input[type="text"], select {
            padding: 7px 10px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 0.95rem;
        }

        button {
            padding: 7px 12px;
            border: none;
            border-radius: 6px;
            background-color: var(--primary-color);
            color: white;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        button:hover {
            background-color: #0056b3;
        }

        .action-link {
            text-decoration: none;
            color: var(--primary-color);
            font-weight: 600;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .pagination {
            text-align: center;
            margin-top: 25px;
        }

        .pagination a, .pagination span {
            display: inline-block;
            margin: 0 4px;
            padding: 6px 12px;
            border: 1px solid var(--primary-color);
            border-radius: 6px;
            color: var(--primary-color);
            text-decoration: none;
        }

        .pagination .active {
            background-color: var(--primary-color);
            color: white;
            pointer-events: none;
        }
    </style>
</head>
<body>

<%@ include file="../common/navbar.jsp" %>

<main class="main-content">
    <div class="content-card">
        <h1 class="page-title"><i class="fa-solid fa-users"></i> Danh sách khách hàng</h1>

        <!-- 🔍 Thanh tìm kiếm và lọc -->
        <div class="filter-bar">
            <form action="customer" method="get">
                <input type="hidden" name="action" value="search"/>
                <input type="text" name="keyword" placeholder="Tìm theo tên hoặc email..." value="${param.keyword}"/>
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            </form>

            <form action="customer" method="get">
                <input type="hidden" name="action" value="filter"/>
                <select name="status" onchange="this.form.submit()">
                    <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                    <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                    <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                </select>
            </form>
        </div>

        <!-- 📋 Bảng danh sách khách hàng -->
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty customers}">
                    <c:forEach var="c" items="${customers}">
                        <tr>
                            <td>#${c.userId}</td>
                            <td>${c.username}</td>
                            <td>${c.fullName}</td>
                            <td>${c.email}</td>
                            <td>${c.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'ACTIVE'}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${c.createdAt}</td>
                            <td>
                                <a href="<c:url value="/manager/customer?action=detail&id=${c.userId}"/>" class="action-link">
                                    <i class="fa-solid fa-eye"></i> Xem chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="8" style="text-align:center;">Không tìm thấy khách hàng nào.</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>

        <!-- 📄 Phân trang -->
        <div class="pagination">
            <c:if test="${totalPages > 1}">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="/manager/customer?action=list&page=${i}"/>">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </c:if>
        </div>
    </div>
</main>

<%@ include file="../common/footer.jsp" %>

</body>
</html>
