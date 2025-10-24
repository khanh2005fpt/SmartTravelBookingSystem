<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Customer Detail</title>

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
            max-width: 800px;
            margin: 40px auto;
        }

        .content-card {
            background-color: white;
            padding: 30px;
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
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
            font-size: 0.95rem;
        }

        th {
            background-color: var(--light-color);
            font-weight: 600;
            width: 35%;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
            min-width: 90px;
            text-align: center;
        }

        .status-active { background-color: var(--success-color); }
        .status-inactive { background-color: var(--danger-color); }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 25px;
            padding: 10px 18px;
            background-color: var(--secondary-color);
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.95rem;
            transition: background-color 0.2s;
        }
        .back-btn:hover {
            background-color: var(--dark-color);
        }
    </style>
</head>
<body>

    <%@ include file="../common/navbar.jsp" %>

    <main class="main-content">
        <div class="content-card">
            <h1 class="page-title"><i class="fa-solid fa-user"></i> Thông tin khách hàng</h1>

            <table>
                <tr><th>ID</th><td>#${customer.userId}</td></tr>
                <tr><th>Username</th><td>${customer.username}</td></tr>
                <tr><th>Full Name</th><td>${customer.fullName}</td></tr>
                <tr><th>Email</th><td>${customer.email}</td></tr>
                <tr><th>Phone</th><td>${customer.phone}</td></tr>
                <tr><th>Role</th><td>${customer.role}</td></tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <c:choose>
                            <c:when test="${customer.status == 'ACTIVE'}">
                                <span class="status-badge status-active">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr><th>Created At</th><td>${customer.createdAt}</td></tr>
            </table>

            <div style="text-align:center;">
                <a href="customer?action=list" class="back-btn">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>

</body>
</html>
