<%-- 
    Document   : booking-detail
    Created on : Staff Booking Detail Page
    Author     : System
    Description: Displays detailed booking information with status management
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Flight" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Booking #${booking.bookingId} - Meland Travel</title>
    
    <!-- Include common CSS -->
    <jsp:include page="../common/css.jsp" />
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 30px;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .page-header h1 {
            margin: 0;
            font-weight: 600;
        }
        
        .page-header .breadcrumb {
            background: transparent;
            padding: 0;
            margin: 10px 0 0 0;
        }
        
        .page-header .breadcrumb-item a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
        }
        
        .page-header .breadcrumb-item.active {
            color: white;
        }
        
        .booking-detail-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .detail-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .detail-card h5 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #6c757d;
            flex: 0 0 40%;
        }
        
        .detail-value {
            flex: 1;
            text-align: right;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9em;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .status-completed { background: #d1ecf1; color: #0c5460; }
        
        .price-highlight {
            font-size: 1.5em;
            font-weight: 700;
            color: #28a745;
        }
        
        .status-management {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .status-form .form-group {
            margin-bottom: 20px;
        }
        
        .status-form label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 10px;
            display: block;
        }
        
        .status-form select {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            width: 100%;
            transition: all 0.3s ease;
        }
        
        .status-form select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
        }
        
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .tour-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
        }
        
        .tour-info h6 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .customer-info {
            background: #e3f2fd;
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
        }
        
        .customer-info h6 {
            color: #1976d2;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .info-item:last-child {
            margin-bottom: 0;
        }
        
        .info-label {
            font-weight: 500;
            color: #6c757d;
        }
        
        .info-value {
            font-weight: 600;
            color: #495057;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .booking-detail-container {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .detail-card {
                padding: 20px;
            }
            
            .detail-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .detail-value {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="currentPage" value="bookings" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-calendar-check"></i> Chi tiết Booking #${booking.bookingId}</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/bookings">
                            <i class="fa fa-list"></i> Danh sách Booking
                        </a>
                    </li>
                    <li class="breadcrumb-item active">Chi tiết #${booking.bookingId}</li>
                </ol>
            </nav>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa fa-check-circle"></i> ${sessionScope.successMessage}
                <button type="button" class="close" data-dismiss="alert">
                    <span>&times;</span>
                </button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa fa-exclamation-circle"></i> ${errorMessage}
                <button type="button" class="close" data-dismiss="alert">
                    <span>&times;</span>
                </button>
            </div>
        </c:if>

        <div class="booking-detail-container">
            <!-- Booking Details -->
            <div class="detail-card">
                <h5><i class="fa fa-info-circle"></i> Thông tin Booking</h5>
                
                <div class="detail-row">
                    <span class="detail-label">Mã Booking:</span>
                    <span class="detail-value"><strong>#${booking.bookingId}</strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Trạng thái:</span>
                    <span class="detail-value">
                        <c:choose>
                            <c:when test="${booking.status == 'PENDING'}">
                                <span class="status-badge status-pending">Chờ xử lý</span>
                            </c:when>
                            <c:when test="${booking.status == 'CONFIRMED'}">
                                <span class="status-badge status-confirmed">Đã xác nhận</span>
                            </c:when>
                            <c:when test="${booking.status == 'COMPLETED'}">
                                <span class="status-badge status-completed">Hoàn thành</span>
                            </c:when>
                            <c:when test="${booking.status == 'CANCELLED'}">
                                <span class="status-badge status-cancelled">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${booking.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Ngày đặt:</span>
                    <span class="detail-value">
                        <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Ngày khởi hành:</span>
                    <span class="detail-value">
                        <fmt:formatDate value="${booking.departureDate}" pattern="dd/MM/yyyy" />
                    </span>
                </div>
                
                <c:if test="${not empty booking.endDate}">
                    <div class="detail-row">
                        <span class="detail-label">Ngày kết thúc:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${booking.endDate}" pattern="dd/MM/yyyy" />
                        </span>
                    </div>
                </c:if>
                
                <div class="detail-row">
                    <span class="detail-label">Số người lớn:</span>
                    <span class="detail-value"><strong>${booking.adultQuantity}</strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Số trẻ em:</span>
                    <span class="detail-value"><strong>${booking.childQuantity}</strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Tổng số người:</span>
                    <span class="detail-value">
                        <strong>${booking.adultQuantity + booking.childQuantity} người</strong>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Tổng tiền:</span>
                    <span class="detail-value price-highlight">
                        <fmt:formatNumber value="${booking.price}" type="currency" 
                                        currencySymbol="₫" groupingUsed="true" />
                    </span>
                </div>

                <!-- Customer Information -->
                <div class="customer-info">
                    <h6><i class="fa fa-user"></i> Thông tin khách hàng</h6>
                    <div class="info-item">
                        <span class="info-label">Tên khách hàng:</span>
                        <span class="info-value">${booking.customerName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">ID Profile:</span>
                        <span class="info-value">#${booking.profileId}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">ID Customer:</span>
                        <span class="info-value">#${booking.customerId}</span>
                    </div>
                </div>

                <!-- Tour Information -->
                <div class="tour-info">
                    <h6><i class="fa fa-map-marker"></i> Thông tin Tour</h6>
                    <c:choose>
                        <c:when test="${not empty booking.tourName}">
                            <div class="info-item">
                                <span class="info-label">Loại tour:</span>
                                <span class="info-value">Tour trọn gói</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Tên tour:</span>
                                <span class="info-value">${booking.tourName}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">ID Tour:</span>
                                <span class="info-value">#${booking.tourId}</span>
                            </div>
                        </c:when>
                        <c:when test="${not empty booking.customTourName}">
                            <div class="info-item">
                                <span class="info-label">Loại tour:</span>
                                <span class="info-value">Tour tùy chỉnh</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Tên tour:</span>
                                <span class="info-value">${booking.customTourName}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">ID Custom Tour:</span>
                                <span class="info-value">#${booking.customTourId}</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="info-item">
                                <span class="info-label">Thông tin tour:</span>
                                <span class="info-value text-muted">Không xác định</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Flight Information -->
                <c:if test="${not empty flight}">
                    <div class="flight-info" style="background: #fff3e0; border-radius: 10px; padding: 20px; margin: 15px 0;">
                        <h6><i class="fa fa-plane"></i> Thông tin Vé Bay</h6>
                        <div class="info-item">
                            <span class="info-label">ID Flight:</span>
                            <span class="info-value"><strong>#${flight.flightId}</strong></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Mã chuyến bay:</span>
                            <span class="info-value"><strong>${flight.flightNumber}</strong></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Hãng hàng không:</span>
                            <span class="info-value">
                                <c:if test="${not empty flight.airline}">
                                    ${flight.airline.airlineName}
                                    <c:if test="${not empty flight.airline.iataCode}">
                                        (${flight.airline.iataCode})
                                    </c:if>
                                </c:if>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Điểm khởi hành:</span>
                            <span class="info-value">${flight.departure}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Điểm đến:</span>
                            <span class="info-value">${flight.destination}</span>
                        </div>
                        <c:if test="${not empty flight.destinationIsland}">
                            <div class="info-item">
                                <span class="info-label">Đảo đến:</span>
                                <span class="info-value">${flight.destinationIsland.islandName}</span>
                            </div>
                        </c:if>
                        <div class="info-item">
                            <span class="info-label">Loại chuyến bay:</span>
                            <span class="info-value">${flight.flightType}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Hạng vé:</span>
                            <span class="info-value">${flight.flightClass}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Giá cơ bản:</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${flight.basePrice}" type="currency" 
                                                currencySymbol="₫" groupingUsed="true" />
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Vé còn lại:</span>
                            <span class="info-value">${flight.ticketAvailable} vé</span>
                        </div>
                        <c:if test="${flight.hasSchedule}">
                            <div class="info-item">
                                <span class="info-label">Lịch trình:</span>
                                <span class="info-value" style="color: #28a745;">
                                    <i class="fa fa-check-circle"></i> Đã có lịch trình
                                </span>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>

<%--            <!-- Status Management -->--%>
<%--            <div class="status-management">--%>
<%--                <h5><i class="fa fa-cogs"></i> Quản lý trạng thái</h5>--%>
<%--                --%>
<%--                <form action="${pageContext.request.contextPath}/staff/bookings" method="post" class="status-form">--%>
<%--                    <input type="hidden" name="action" value="updateStatus">--%>
<%--                    <input type="hidden" name="bookingId" value="${booking.bookingId}">--%>
<%--                    --%>
<%--                    <div class="form-group">--%>
<%--                        <label for="newStatus">Trạng thái mới:</label>--%>
<%--                        <select class="form-control" id="newStatus" name="newStatus" required>--%>
<%--                            <option value="">-- Chọn trạng thái --</option>--%>
<%--                            <option value="PENDING" ${booking.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>--%>
<%--                            <option value="CONFIRMED" ${booking.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>--%>
<%--                            <option value="COMPLETED" ${booking.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>--%>
<%--                            <option value="CANCELLED" ${booking.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>--%>
<%--                        </select>--%>
<%--                    </div>--%>
<%--                    --%>
<%--                    <button type="submit" class="btn btn-update" onclick="return confirmStatusUpdate()">--%>
<%--                        <i class="fa fa-save"></i> Cập nhật trạng thái--%>
<%--                    </button>--%>
<%--                </form>--%>
<%--                --%>
<%--                <hr class="my-4">--%>
<%--                --%>
<%--                <div class="text-center">--%>
<%--                    <a href="${pageContext.request.contextPath}/staff/bookings" class="btn-back">--%>
<%--                        <i class="fa fa-arrow-left mr-2"></i> Quay lại danh sách--%>
<%--                    </a>--%>
<%--                </div>--%>
<%--            </div>--%>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
        
        // Confirm status update
        function confirmStatusUpdate() {
            const newStatus = document.getElementById('newStatus').value;
            const currentStatus = '${booking.status}';
            
            if (!newStatus) {
                alert('Vui lòng chọn trạng thái mới!');
                return false;
            }
            
            if (newStatus === currentStatus) {
                alert('Trạng thái mới phải khác với trạng thái hiện tại!');
                return false;
            }
            
            const statusNames = {
                'PENDING': 'Chờ xử lý',
                'CONFIRMED': 'Đã xác nhận',
                'COMPLETED': 'Hoàn thành',
                'CANCELLED': 'Đã hủy'
            };
            
            return confirm(`Bạn có chắc chắn muốn thay đổi trạng thái booking này thành "${statusNames[newStatus]}"?`);
        }
        
        // Disable current status option
        document.addEventListener('DOMContentLoaded', function() {
            const currentStatus = '${booking.status}';
            const selectElement = document.getElementById('newStatus');
            
            // Add visual indication for current status
            for (let option of selectElement.options) {
                if (option.value === currentStatus) {
                    option.text += ' (Hiện tại)';
                    option.style.fontWeight = 'bold';
                    option.style.color = '#6c757d';
                }
            }
        });
    </script>
</body>
</html>