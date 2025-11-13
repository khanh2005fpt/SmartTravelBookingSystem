<%-- 
    Document   : booking-list
    Created on : Staff Booking List Page
    Author     : System
    Description: Displays list of bookings with search and management functionality
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Booking - Meland Travel</title>
    
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
        
        .page-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .icon {
            font-size: 2.5em;
            margin-bottom: 15px;
        }
        
        .stat-card.pending .icon { color: #ffc107; }
        .stat-card.completed .icon { color: #17a2b8; }
        .stat-card.total .icon { color: #6f42c1; }
        
        .stat-card .number {
            font-size: 2em;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-card .label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .search-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .search-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }
        
        .form-group label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .bookings-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .table {
            margin: 0;
        }
        
        .table thead th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #495057;
            padding: 20px 15px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-top: 1px solid #e9ecef;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .status-completed { background: #d1ecf1; color: #0c5460; }
        
        .btn-action {
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            margin-right: 5px;
        }
        
        .btn-view {
            background: #17a2b8;
            color: white;
        }
        
        .btn-view:hover {
            background: #138496;
            color: white;
            text-decoration: none;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4em;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .stats-cards {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .search-form {
                grid-template-columns: 1fr;
            }
            
            .table-responsive {
                font-size: 0.9em;
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
            <h1><i class="fa fa-calendar-check"></i> Quản lý Booking</h1>
            <p>Quản lý và theo dõi tất cả các đặt chỗ của khách hàng</p>
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

        <!-- Statistics Cards -->
        <div class="stats-cards">
            <div class="stat-card pending">
                <div class="icon"><i class="fa fa-clock"></i></div>
                <div class="number">${incompleteCount}</div>
                <div class="label">Chưa hoàn thành</div>
            </div>
            <div class="stat-card completed">
                <div class="icon"><i class="fa fa-flag-checkered"></i></div>
                <div class="number">${completedCount}</div>
                <div class="label">Đã hoàn thành</div>
            </div>
            <div class="stat-card total">
                <div class="icon"><i class="fa fa-list"></i></div>
                <div class="number">${totalCount}</div>
                <div class="label">Tổng cộng</div>
            </div>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <h5><i class="fa fa-search"></i> Tìm kiếm Booking</h5>
            <form action="${pageContext.request.contextPath}/staff/bookings" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                
                <div class="form-group">
                    <label for="customerName">Tên khách hàng</label>
                    <input type="text" class="form-control" id="customerName" name="customerName" 
                           value="${searchCustomerName}" placeholder="Nhập tên khách hàng...">
                </div>
                
                <div class="form-group">
                    <label for="status">Trạng thái</label>
                    <select class="form-control" id="status" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="INCOMPLETE" ${searchStatus == 'INCOMPLETE' ? 'selected' : ''}>Chưa hoàn thành</option>
                        <option value="COMPLETED" ${searchStatus == 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="dateFrom">Từ ngày</label>
                    <input type="date" class="form-control" id="dateFrom" name="dateFrom" value="${searchDateFrom}">
                </div>
                
                <div class="form-group">
                    <label for="dateTo">Đến ngày</label>
                    <input type="date" class="form-control" id="dateTo" name="dateTo" value="${searchDateTo}">
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                    <a href="${pageContext.request.contextPath}/staff/bookings" class="btn btn-secondary ml-2">
                        <i class="fa fa-refresh"></i> Làm mới
                    </a>
                </div>
            </form>
        </div>

        <!-- Bookings Table -->
        <div class="bookings-table">
            <c:choose>
                <c:when test="${not empty bookings}">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khách hàng</th>
                                    <th>Tour</th>
                                    <th>Ngày khởi hành</th>
                                    <th>Số người</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày đặt</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td><strong>#${booking.bookingId}</strong></td>
                                        <td>
                                            <div class="customer-info">
                                                <strong>${booking.customerName}</strong>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty booking.tourName}">
                                                    <span class="tour-name">${booking.tourName}</span>
                                                    <small class="text-muted d-block">Tour trọn gói</small>
                                                </c:when>
                                                <c:when test="${not empty booking.customTourName}">
                                                    <span class="tour-name">${booking.customTourName}</span>
                                                    <small class="text-muted d-block">Tour lẻ</small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Không xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${booking.departureDate}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td>
                                            <span class="badge badge-info">
                                                ${booking.adultQuantity + booking.childQuantity} người
                                            </span>
                                            <small class="text-muted d-block">
                                                ${booking.adultQuantity} NL, ${booking.childQuantity} TE
                                            </small>
                                        </td>
                                        <td>
                                            <strong class="text-success">
                                                <fmt:formatNumber value="${booking.price}" type="currency" 
                                                                currencySymbol="₫" groupingUsed="true" />
                                            </strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.status == 'PENDING' || booking.status == 'CONFIRMED'}">
                                                    <span class="status-badge status-pending">Chưa hoàn thành</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'COMPLETED'}">
                                                    <span class="status-badge status-completed">Đã hoàn thành</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${booking.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/staff/bookings?action=detail&id=${booking.bookingId}" 
                                               class="btn-action btn-view" title="Xem chi tiết">
                                                <i class="fa fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fa fa-calendar-times"></i>
                        <h4>Không có booking nào</h4>
                        <p>
                            <c:choose>
                                <c:when test="${not empty searchCustomerName or not empty searchStatus or not empty searchDateFrom or not empty searchDateTo}">
                                    Không tìm thấy booking nào phù hợp với tiêu chí tìm kiếm.
                                </c:when>
                                <c:otherwise>
                                    Chưa có booking nào trong hệ thống.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${not empty searchCustomerName or not empty searchStatus or not empty searchDateFrom or not empty searchDateTo}">
                            <a href="${pageContext.request.contextPath}/staff/bookings" class="btn btn-primary mt-3">
                                <i class="fa fa-refresh"></i> Xem tất cả booking
                            </a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
        
        // Set max date for date inputs to today
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('dateFrom').setAttribute('max', today);
            document.getElementById('dateTo').setAttribute('max', today);
        });
    </script>
</body>
</html>