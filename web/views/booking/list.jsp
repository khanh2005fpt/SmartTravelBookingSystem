<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Booking</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        :root {
            --primary-color: #007bff;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --completed-color: #6c757d; /* Thêm màu cho trạng thái completed */
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --body-bg: #f4f7f6;
            --border-color: #dee2e6;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--body-bg);
            margin: 0;
            color: var(--dark-color);
            line-height: 1.5;
        }

        .main-content {
            padding: 20px;
            max-width: 1200px;
            margin: 20px auto;
        }

        .content-card {
            background-color: white;
            padding: 25px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        /* --- Filter Toolbar --- */
        .filter-toolbar {
            display: flex;
            flex-wrap: wrap; /* Cho phép xuống hàng trên mobile */
            gap: 15px;
            align-items: center;
            margin-bottom: 25px;
        }

        .form-input, .form-select {
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: 1rem;
            flex-grow: 1; /* Cho phép input co giãn */
            min-width: 200px;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.2s;
        }
        .btn:hover {
            opacity: 0.85;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        /* --- Booking Table --- */
        .booking-table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            border-radius: var(--border-radius);
            overflow: hidden; /* Giúp bo góc table hoạt động */
        }

        .booking-table th, .booking-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .booking-table th {
            background-color: var(--light-color);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            color: #6c757d;
        }
        
        .booking-table tr:last-child td {
            border-bottom: none; /* Bỏ border dòng cuối */
        }

        .booking-table tr:hover {
            background-color: #f8f9fa;
        }

        .action-column {
            text-align: center;
        }

        /* --- Status Badges --- */
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            color: white;
            min-width: 90px;
            text-align: center;
            text-transform: capitalize;
        }
        .status-confirmed { background-color: var(--success-color); }
        .status-pending { background-color: var(--warning-color); color: var(--dark-color); }
        .status-cancelled { background-color: var(--danger-color); }
        .status-completed { background-color: var(--completed-color); }


        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            background-color: var(--info-color);
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background-color 0.2s;
        }
        .action-link:hover {
            background-color: #117a8b;
        }

        /* --- Pagination --- */
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
        
        /* --- Responsive for small screens --- */
        @media (max-width: 768px) {
            .filter-toolbar {
                flex-direction: column;
                align-items: stretch; /* Kéo dài các item cho bằng nhau */
            }
        }

    </style>
</head>
<body>
    <%@ include file="../common/navbar.jsp" %>

    <main class="main-content">
        <h1 class="page-title"><i class="fa-solid fa-clipboard-list"></i> Danh sách Booking</h1>

        <div class="content-card">

            <form action="${pageContext.request.contextPath}/booking" method="get" class="filter-toolbar">
                <input type="hidden" name="action" value="list">
                
                <input type="text" name="keyword" class="form-input" 
                       placeholder="Nhập tên khách hàng để tìm..." 
                       value="${param.keyword}">

                <select name="status" class="form-select" onchange="this.form.submit()">
                    <option value="">-- Lọc theo trạng thái --</option>
                    <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                    <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                </select>

                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                </button>
                <a href="${pageContext.request.contextPath}/booking?action=list" class="btn btn-secondary">
                    <i class="fa-solid fa-rotate-right"></i> Reset
                </a>
            </form>

            <table class="booking-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>Trạng thái</th>
                        <th>Ngày đặt</th>
                        <th class="action-column">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty items}">
                            <c:forEach var="b" items="${items}">
                                <tr>
                                    <td>#${b.bookingId}</td>
                                    <td>${not empty b.customerName ? b.customerName : "-"}</td>
                                    <td>
                                        <span class="status-badge status-${b.status.name().toLowerCase()}">
                                            ${b.status.name()}
                                        </span>
                                    </td>
                                    <td>${not empty b.bookingDate ? b.bookingDate : "-"}</td>
                                    <td class="action-column">
                                        <a href="${pageContext.request.contextPath}/booking?action=detail&id=${b.bookingId}" class="action-link">
                                            <i class="fa-solid fa-eye"></i> Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" style="text-align:center; padding: 40px;">
                                    Không tìm thấy booking nào phù hợp.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="pagination">
            <c:if test="${totalPages > 1}">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <%-- Thêm các tham số tìm kiếm và lọc vào link phân trang --%>
                    <c:url value="/booking" var="pageUrl">
                        <c:param name="action" value="list" />
                        <c:param name="page" value="${i}" />
                        <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                        <c:if test="${not empty param.status}"><c:param name="status" value="${param.status}" /></c:if>
                    </c:url>
                
                    <c:choose>
                        <c:when test="${i == page}">
                            <strong>${i}</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageUrl}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </c:if>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>
</body>
</html>