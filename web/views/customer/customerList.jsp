<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Customer List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

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
            margin: 20px auto;
        }

        .content-card {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .customer-table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .customer-table th, .customer-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .customer-table th {
            background-color: var(--light-color);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            color: white;
            min-width: 90px;
            text-align: center;
        }
        .status-active { background-color: var(--success-color); }
        .status-inactive { background-color: var(--danger-color); }

        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            background-color: var(--secondary-color);
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background-color 0.2s;
        }
        .action-link:hover {
            background-color: var(--dark-color);
        }

    </style>
</head>
<body>

    <%@ include file="../common/navbar.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fa-solid fa-users"></i> Danh sách khách hàng</h1>

        <div class="content-card">
            <table class="customer-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th style="text-align:center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${customers}">
                        <tr>
                            <td>#${c.userId}</td>
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
                            <td style="text-align:center;">
                                <a href="customer?action=detail&id=${c.userId}" class="action-link">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>

</body>
</html>
