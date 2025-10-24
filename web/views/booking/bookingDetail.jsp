<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Booking Detail #${booking.bookingId}</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        /* Biến màu (giống trang danh sách để nhất quán) */
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

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--body-bg);
            margin: 0;
            color: var(--dark-color);
        }

        .main-content {
            padding: 30px;
            max-width: 800px; /* Thu hẹp lại cho trang chi tiết */
            margin: 20px auto;
        }

        .content-card {
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin: 0 0 30px 0;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        /* Bảng chi tiết được thiết kế lại */
        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .detail-table th, .detail-table td {
            padding: 15px 10px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
            vertical-align: middle;
        }
        
        .detail-table tr:last-child th,
        .detail-table tr:last-child td {
            border-bottom: none;
        }

        .detail-table th {
            width: 35%; /* Cho cột label rộng hơn một chút */
            font-weight: 600;
            color: var(--secondary-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-table td {
            font-weight: 500;
            font-size: 1.05rem;
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

        /* Nút Back to List */
        .back-link-wrapper {
            text-align: center;
            margin-top: 30px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background-color: var(--primary-color);
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .back-link:hover {
            background-color: #0056b3;
        }

    </style>
</head>
<body>

    <%@ include file="../common/navbar.jsp" %>

    <main class="main-content">
        <div class="content-card">
            <h1 class="page-title">
                <i class="fa-solid fa-ticket-alt"></i>
                Chi tiết Booking #${booking.bookingId}
            </h1>

            <table class="detail-table">
                <tr>
                    <th><i class="fa-solid fa-user"></i> User Name</th>
                    <td>${booking.userName}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-concierge-bell"></i> Service Type</th>
                    <td>${booking.serviceType}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-tag"></i> Service Name</th>
                    <td>${booking.serviceName}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-map-marked-alt"></i> Trip Name</th>
                    <td>${booking.tripName}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-calendar-day"></i> Booking Date</th>
                    <td>${booking.bookingDate}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-plane-departure"></i> Check In</th>
                    <td>${booking.checkIn}</td>
                </tr>
                 <tr>
                    <th><i class="fa-solid fa-plane-arrival"></i> Check Out</th>
                    <td>${booking.checkOut}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-dollar-sign"></i> Total Amount</th>
                    <td>${booking.totalAmount}</td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-circle-info"></i> Status</th>
                    <td>
                        <c:choose>
                            <c:when test="${booking.status == 'CONFIRMED'}">
                                <span class="status-badge status-confirmed">Confirmed</span>
                            </c:when>
                            <c:when test="${booking.status == 'PENDING'}">
                                <span class="status-badge status-pending">Pending</span>
                            </c:when>
                            <c:when test="${booking.status == 'CANCELLED'}">
                                <span class="status-badge status-cancelled">Cancelled</span>
                            </c:when>
                            <c:otherwise>
                                <span>${booking.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </div>

        <div class="back-link-wrapper">
            <a href="booking?action=list" class="back-link">
                <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>

</body>
</html>