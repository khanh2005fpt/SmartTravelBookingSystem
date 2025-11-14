<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Booking Management</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    
    <style>
        /* Biến màu cho dễ quản lý */
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --body-bg: #f4f7f6;
            --border-color: #dee2e6;
        }

        /* Reset và cài đặt Body */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--body-bg);
            margin: 0;
            color: var(--dark-color);
        }

        /* Lớp container chính */
        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 20px auto;
        }

        /* Thiết kế cho Card/Panel */
        .content-card {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        /* Tiêu đề trang */
        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Khu vực Filter và Search */
        .filter-bar {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap; /* Cho phép xuống dòng trên màn hình nhỏ */
        }
        
        .filter-bar form {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-bar input[type="text"], .filter-bar select {
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 0.95rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .filter-bar input[type="text"]:focus, .filter-bar select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }

        .filter-bar button {
            padding: 10px 15px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background-color 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .filter-bar button:hover {
            background-color: #0056b3;
        }
        
        /* Thiết kế Bảng dữ liệu */
        .booking-table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            border-radius: 12px;
            overflow: hidden; /* Để bo góc table */
        }

        .booking-table th, .booking-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .booking-table th {
            background-color: var(--light-color);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .booking-table td {
            vertical-align: middle;
        }

        /* Thẻ trạng thái (Status Badges) */
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
        .status-confirmed { background-color: var(--success-color); }
        .status-pending { background-color: var(--warning-color); color: var(--dark-color); }
        .status-cancelled { background-color: var(--danger-color); }

        /* Nút hành động */
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

        /* Phân trang */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 30px;
        }
        .pagination a, .pagination strong {
            display: inline-block;
            padding: 8px 14px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            text-decoration: none;
            color: var(--primary-color);
            background-color: white;
        }
        .pagination a:hover {
            background-color: var(--light-color);
        }
        .pagination strong {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
    </style>
</head>
         <!-- lay thong tin user và athorized -->
        
    <%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }
if (currentUser != null) {
    int roleId = currentUser.getRoleId();

    if (roleId != 1 && roleId != 3) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>
<body>

    <%@ include file="../common/navbar.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fa-solid fa-clipboard-list"></i> Quản lý Booking</h1>

        <div class="content-card">
            <div class="filter-bar">
                <form action="booking" method="get">
                    <input type="hidden" name="action" value="search"/>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên user..."/>
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Tìm</button>
                </form>

                <form action="booking" method="get">
                    <input type="hidden" name="action" value="filterStatus"/>
                    <select name="status" onchange="this.form.submit()">
                        <option value="ALL" ${status == 'ALL' ? 'selected' : ''}>Tất cả Trạng thái</option>
                        <option value="CONFIRMED" ${status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </form>

                <form action="booking" method="get">
                    <input type="hidden" name="action" value="filterServiceType"/>
                    <select name="serviceType" onchange="this.form.submit()">
                        <option value="ALL" ${serviceType == 'ALL' ? 'selected' : ''}>Tất cả Dịch vụ</option>
                        <option value="HOTEL" ${serviceType == 'HOTEL' ? 'selected' : ''}>Hotel</option>
                        <option value="FLIGHT" ${serviceType == 'FLIGHT' ? 'selected' : ''}>Flight</option>
                        <option value="VEHICLE" ${serviceType == 'VEHICLE' ? 'selected' : ''}>Vehicle</option>
                    </select>
                </form>
            </div>
        </div>

        <div class="content-card">
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User Name</th>
                        <th>Service Type</th>
                        <th>Status</th>
                        <th style="text-align:center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>#${b.bookingId}</td>
                            <td>${b.userName}</td>
                            <td>${b.serviceType}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'CONFIRMED'}">
                                        <span class="status-badge status-confirmed">Confirmed</span>
                                    </c:when>
                                    <c:when test="${b.status == 'PENDING'}">
                                        <span class="status-badge status-pending">Pending</span>
                                    </c:when>
                                    <c:when test="${b.status == 'CANCELLED'}">
                                        <span class="status-badge status-cancelled">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${b.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <a href="booking?action=detail&id=${b.bookingId}" class="action-link">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="pagination">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="booking?action=list&page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>

</body>
</html>