<%-- 
    Document   : index
    Created on : Staff Dashboard Page
    Author     : System
    Description: Main dashboard page for staff with overview and quick actions
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Tour" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Meland Travel Staff</title>
    
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
        
        .welcome-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .welcome-header h1 {
            margin: 0;
            font-weight: 700;
            font-size: 2.5em;
        }
        
        .welcome-header p {
            margin: 15px 0 0 0;
            opacity: 0.9;
            font-size: 1.1em;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .stat-icon {
            font-size: 3em;
            margin-bottom: 15px;
            color: #667eea;
        }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9em;
        }
        
        .quick-actions {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .quick-actions h3 {
            color: #333;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-btn {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .action-btn:hover {
            background: #667eea;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            border-color: #667eea;
        }
        
        .action-btn i {
            font-size: 1.5em;
            width: 40px;
            text-align: center;
        }
        
        .action-btn-text {
            flex: 1;
        }
        
        .action-btn-title {
            font-weight: 600;
            margin-bottom: 3px;
        }
        
        .action-btn-desc {
            font-size: 0.85em;
            opacity: 0.8;
        }
        
        .recent-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .recent-section h3 {
            color: #333;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .recent-tour {
            display: flex;
            align-items: center;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .recent-tour:hover {
            background: #f8f9fa;
            border-color: #667eea;
        }
        
        .recent-tour-info {
            flex: 1;
        }
        
        .recent-tour-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .recent-tour-meta {
            font-size: 0.85em;
            color: #666;
        }
        
        .recent-tour-price {
            font-weight: 700;
            color: #28a745;
            font-size: 1.1em;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }
        
        .empty-state i {
            font-size: 3em;
            color: #dee2e6;
            margin-bottom: 15px;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .welcome-header {
                padding: 25px;
                text-align: center;
            }
            
            .welcome-header h1 {
                font-size: 2em;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
            
            .action-grid {
                grid-template-columns: 1fr;
            }
            
            .recent-tour {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="dashboard" />
    </jsp:include>

    <div class="main-content">
        <!-- Welcome Header -->
        <div class="welcome-header">
            <h1><i class="fa fa-tachometer-alt"></i> Dashboard</h1>
            <p>Chào mừng bạn đến với hệ thống quản lý Meland Travel</p>
            <p><i class="fa fa-clock"></i> Hôm nay: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, dd/MM/yyyy"/></p>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i class="fa fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa fa-map-marker"></i>
                </div>
                <div class="stat-number">${totalTours != null ? totalTours : 0}</div>
                <div class="stat-label">Tổng số Tour</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa fa-island-tropical"></i>
                </div>
                <div class="stat-number">${totalIslands != null ? totalIslands : 0}</div>
                <div class="stat-label">Số Đảo</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa fa-users"></i>
                </div>
                <div class="stat-number">${totalBookings != null ? totalBookings : 0}</div>
                <div class="stat-label">Đặt Tour</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa fa-money-bill-wave"></i>
                </div>
                <div class="stat-number">
                    <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" 
                                    type="currency" currencySymbol="₫" groupingUsed="true"/>
                </div>
                <div class="stat-label">Doanh thu</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <h3><i class="fa fa-bolt"></i> Thao tác nhanh</h3>
            <div class="action-grid">
                <a href="${pageContext.request.contextPath}/staff/tours?action=create" class="action-btn">
                    <i class="fa fa-plus"></i>
                    <div class="action-btn-text">
                        <div class="action-btn-title">Tạo Tour mới</div>
                        <div class="action-btn-desc">Thêm tour du lịch mới</div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/staff/tours?action=list" class="action-btn">
                    <i class="fa fa-list"></i>
                    <div class="action-btn-text">
                        <div class="action-btn-title">Quản lý Tour</div>
                        <div class="action-btn-desc">Xem và chỉnh sửa tour</div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/staff/bookings?action=list" class="action-btn">
                    <i class="fa fa-calendar-check"></i>
                    <div class="action-btn-text">
                        <div class="action-btn-title">Đặt Tour</div>
                        <div class="action-btn-desc">Quản lý đặt tour</div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/staff/customers?action=list" class="action-btn">
                    <i class="fa fa-users"></i>
                    <div class="action-btn-text">
                        <div class="action-btn-title">Khách hàng</div>
                        <div class="action-btn-desc">Quản lý khách hàng</div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/staff/reports" class="action-btn">
                    <i class="fa fa-chart-bar"></i>
                    <div class="action-btn-text">
                        <div class="action-btn-title">Báo cáo</div>
                        <div class="action-btn-desc">Xem báo cáo thống kê</div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/staff/settings" class="action-btn">
                    <i class="fa fa-cog"></i>
                    <div class="action-btn-text">
                        <div class="action-btn-title">Cài đặt</div>
                        <div class="action-btn-desc">Cấu hình hệ thống</div>
                    </div>
                </a>
            </div>
        </div>

        <!-- Recent Tours -->
        <div class="recent-section">
            <h3><i class="fa fa-clock"></i> Tour gần đây</h3>
            <c:choose>
                <c:when test="${not empty recentTours}">
                    <c:forEach var="tour" items="${recentTours}">
                        <div class="recent-tour">
                            <div class="recent-tour-info">
                                <div class="recent-tour-name">${tour.tourName}</div>
                                <div class="recent-tour-meta">
                                    <i class="fa fa-map-pin"></i> ${not empty tour.islandName ? tour.islandName : 'Đảo ID: '.concat(tour.islandId)}
                                    <c:if test="${not empty tour.createdAt}">
                                        | <i class="fa fa-calendar"></i> 
                                        <fmt:formatDate value="${tour.createdAt}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                </div>
                            </div>
                            <div class="recent-tour-price">
                                <fmt:formatNumber value="${tour.price}" type="currency" 
                                                currencySymbol="₫" groupingUsed="true"/>
                            </div>
                        </div>
                    </c:forEach>
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/staff/tours?action=list" 
                           class="btn btn-outline-primary">
                            <i class="fa fa-eye"></i> Xem tất cả tour
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fa fa-map-marker"></i>
                        <h5>Chưa có tour nào</h5>
                        <p>Hãy tạo tour đầu tiên để bắt đầu!</p>
                        <a href="${pageContext.request.contextPath}/staff/tours?action=create" 
                           class="btn btn-primary mt-2">
                            <i class="fa fa-plus"></i> Tạo Tour mới
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- System Information -->
        <div class="recent-section">
            <h3><i class="fa fa-info-circle"></i> Thông tin hệ thống</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="recent-tour">
                        <div class="recent-tour-info">
                            <div class="recent-tour-name">Phiên bản hệ thống</div>
                            <div class="recent-tour-meta">Meland Travel Management v1.0</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="recent-tour">
                        <div class="recent-tour-info">
                            <div class="recent-tour-name">Trạng thái hệ thống</div>
                            <div class="recent-tour-meta">
                                <span class="badge badge-success">
                                    <i class="fa fa-check"></i> Hoạt động bình thường
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        $(document).ready(function() {
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
            
            // Add animation to stat cards
            $('.stat-card').each(function(index) {
                $(this).delay(index * 100).animate({
                    opacity: 1
                }, 500);
            });
            
            // Add hover effects to action buttons
            $('.action-btn').hover(
                function() {
                    $(this).find('i').addClass('fa-bounce');
                },
                function() {
                    $(this).find('i').removeClass('fa-bounce');
                }
            );
        });
        
        // Update time every minute
        setInterval(function() {
            const now = new Date();
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: '2-digit', 
                day: '2-digit' 
            };
            const timeString = now.toLocaleDateString('vi-VN', options);
            // Update if there's a time element
        }, 60000);
    </script>
</body>
</html>