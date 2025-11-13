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
<%@ page import="model.User" %>
<fmt:setLocale value="vi_VN" />
<fmt:setBundle basename="messages" />
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
                background: linear-gradient(180deg, #0077b6, #00b4d8);
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
                background: linear-gradient(180deg, #0077b6, #00b4d8);
            }

            .stat-icon {
                font-size: 3em;
                margin-bottom: 15px;
                color: #00ACD4;
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
                background: #00ACD4;
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

            .btn-view-all {
                background: #00ACD4;
                color: #fff;

                border-radius: 8px;
                padding: 12px 16px;
                font-weight: bold;
                transition: all 0.3s ease;
            }


            .btn-view-all:hover {
                background-color: #007CB9;

                color: #fff;
                border-color:  #007CB9;
                text-decoration: none;
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

    if (roleId ==3 ) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
    %>

    <body>
        <!-- Include Sidebar -->
        <jsp:include page="sidebar.jsp">
            <jsp:param name="page" value="dashboard" />
        </jsp:include>

        <div class="main-content">
            <!-- Welcome Header -->
            <div class="welcome-header">
                
     <div class="dashboard-header d-flex align-items-center justify-content-between">
    <h1><i class="fa fa-tachometer-alt me-2"></i> Dashboard</h1>

    <!-- Chuông thông báo tồn kho -->
    <li class="nav-item dropdown position-relative list-unstyled m-0">
        <a class="nav-link dropdown-toggle" href="#" id="dropdown04" data-toggle="dropdown"
           aria-haspopup="true" aria-expanded="false">
            <i class="fa-solid fa-bell"></i>
            <c:if test="${not empty notifications}">
                <span class="badge badge-danger position-absolute" 
                      style="top: 5px; right: 5px; font-size: 0.8rem;">
                    ${notifications.size()}
                </span>
            </c:if>
        </a>

        <div class="dropdown-menu dropdown-menu-right notification-dropdown" aria-labelledby="dropdown04" style="max-height: 300px; overflow-y: auto;">
            <h6 class="dropdown-header text-info d-flex align-items-center mb-2">
                <i class="fa-solid fa-bell me-2"></i> Thông báo
            </h6>

            <div class="notification-list">
                <c:forEach var="n" items="${notifications}" varStatus="status">
                    <c:if test="${status.index < 10}">
                        <div class="notification-item d-flex">
                            <div class="notification-icon me-2">
                                <c:choose>
                                    <c:when test="${n.type == 'SYSTEM'}">
                                        <i class="fa-solid fa-gear text-warning"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-solid fa-info-circle text-muted"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="notification-content">
                                <strong>${n.title}</strong>
                                <p class="text-muted mb-0">${n.message}</p>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>

                <c:if test="${empty notifications}">
                    <div class="text-center text-muted py-3">Không có thông báo mới nào</div>
                </c:if>
            </div>

            <div class="dropdown-divider my-2"></div>

            <div class="text-center pb-2">
                <button type="button" class="btn btn-sm btn-outline-danger" data-toggle="modal" data-target="#deleteModal">
                    🗑 Xóa tất cả
                </button>
            </div>
        </div>
    </li>
</div>
                
                                               
    <!-- Delete Confirmation Modal ----------------------------------------->
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">⚠️ Xác nhận xóa thông báo</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <strong>Bạn có chắc chắn muốn xóa những thông báo này không? </strong>
                        <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                       <form id="deleteForm" method="post" style="display: inline;" action="${pageContext.request.contextPath}/notifications_servlet">
   
    <input type="hidden" name="action" value="deleteAll">
    <button type="submit" class="btn btn-danger">Xóa</button>
</form>

                    </div>
                </div>
            </div>
        </div>
    
        <script>
         function confirmDelete(notificationId) {
    document.getElementById('notificationIdToDelete').value = notificationId;
    $('#deleteModal').modal('show');
}

        </script>
                
                

                <p>Chào mừng bạn đến với hệ thống quản lý<strong> Meland Travel Booking</strong> </p>
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
                        <i class="fa-solid fa-water"></i>
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
                    <div class="stat-number"style="font-size:35px; ">
                        <fmt:formatNumber value="${totalRevenues != null ? totalRevenues : 0}"
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

                    <a href="${pageContext.request.contextPath}/staff/hotels?action=list" class="action-btn">
                        <i class="fa fa-hotel"></i>

                        <div class="action-btn-text">
                            <div class="action-btn-title">Khách sạn</div>
                            <div class="action-btn-desc">Quản lý thông tin khách sạn</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/staff/flight/tickets?action=list" class="action-btn">
                        <i class="fa fa-plane-departure"></i>
                        <div class="action-btn-text">
                            <div class="action-btn-title">Chuyến bay</div>
                            <div class="action-btn-desc">Quản lý vé máy bay</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/staff/bookings?action=list"class="action-btn">
                        <i class="fa fa-chart-bar"></i>
                        <div class="action-btn-text">
                            <div class="action-btn-title">Booking</div>
                            <div class="action-btn-desc">Xem thông tin booking</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/staff/vehicles?action=list" class="action-btn">
                        <i class="fa fa-car"></i>
                        <div class="action-btn-text">
                            <div class="action-btn-title">Phương tiện</div>
                            <div class="action-btn-desc">Quản lý phương tiện</div>
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
                                            ${tour.createdAt.toLocalDate()}

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
                               class="btn  btn-view-all">
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
            $(document).ready(function () {
                // Auto-hide alerts after 5 seconds
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);

                // Add animation to stat cards
                $('.stat-card').each(function (index) {
                    $(this).delay(index * 100).animate({
                        opacity: 1
                    }, 500);
                });

                // Add hover effects to action buttons
                $('.action-btn').hover(
                        function () {
                            $(this).find('i').addClass('fa-bounce');
                        },
                        function () {
                            $(this).find('i').removeClass('fa-bounce');
                        }
                );
            });

            // Update time every minute
            setInterval(function () {
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