<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Font Awesome -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<%
    HttpSession sess = request.getSession(false);
    User currentUser = (User) (sess != null ? sess.getAttribute("user") : null);
    int roleId = (currentUser != null) ? currentUser.getRoleId() : 0;

    String roleName = "Khách";
    if (roleId == 1) roleName = "Quản trị viên";
    else if (roleId == 2) roleName = "Quản lý Booking";
    else if (roleId == 4) roleName = "Nhân viên";

    String currentPage = request.getParameter("page");
    if (currentPage == null) {
        currentPage = "";
    }
%>

<style>
    html, body {
        overflow-x: hidden;
    }

.main-sidebar {
    width: 260px;
    background: linear-gradient(180deg, #0077b6, #00b4d8);
    min-height: 100vh; 
    color: white;
    position: fixed;
    left: 0;
    top: 0;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    box-sizing: border-box;
    overflow-y: auto;   
    overflow-x: hidden;
    border-right: 1px solid rgba(255, 255, 255, 0.2);
    transition: transform 0.3s ease;
    z-index: 999;
}



    .main-sidebar.show {
        transform: translateX(0);
    }

    @media (max-width: 768px) {
        .main-sidebar {
            transform: translateX(-100%);
        }
    }

    .sidebar-header {
        padding: 20px;
        text-align: center;
        border-bottom: 1px solid rgba(255,255,255,0.2);
    }

      .sidebar-header h3 {
    margin: 0 0 15px;
    font-size: 22px;
    font-weight: 800;
    letter-spacing: 0.5px;
    color: #ffffff;
    text-shadow: 0 1px 3px rgba(0,0,0,0.3);
}
    .sidebar-header p {
    margin: 5px 0;
    font-size: 15px;
    color: rgba(255,255,255,0.95);
    font-weight: 400;
    line-height: 1.4;
}

.sidebar-header b {
    color: #f1f9ff; 
    font-weight: 600;
}
   

    .sidebar-nav {
        flex-grow: 1;
        padding: 15px 0;
    }

    .nav-item {
        margin: 5px 20px;
    }

    .nav-link {
        display: flex;
        align-items: center;
        color: rgba(255,255,255,0.9);
        text-decoration: none;
        padding: 10px 12px;
        border-radius: 8px;
        transition: all 0.2s ease;
        font-weight: 500;
    }

    .nav-link i {
        margin-right: 10px;
        font-size: 16px;
    }

    .nav-link:hover {
        background: rgba(255,255,255,0.15);
        transform: translateX(5px);
        color: white;
    }

    .nav-link.active {
        background: rgba(255,255,255,0.25);
        color: #fff;
        font-weight: 600;
    }

    .nav-parent {
        cursor: pointer;
    }

    .nav-child {
        display: none;
        margin-left: 20px;
    }

    .nav-child.expanded {
        display: block;
        animation: fadeIn 0.3s ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-5px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .sidebar-footer {
        padding: 20px;
        text-align: center;
        border-top: 1px solid rgba(255,255,255,0.2);
        background: rgba(0,0,0,0.1);
    }

    .logout-btn {
       background-color: #007CB9; 
  color: white;
  font-weight: 500;
  border: none;
  padding: 10px 15px;
  border-radius: 6px;
  width: 100%;
  text-align: left;
  transition: background-color 0.2s ease;
    }

    .logout-btn:hover {
    background-color: #00ACD4; 
  color: #fff;
    }
</style>

<!-- Sidebar -->
<div class="main-sidebar">
    <div class="sidebar-header">
    <h3> Trang Quản lý MelandBooking</h3>
    <% if (currentUser != null) { %>
        <p>Xin chào, <b><%= currentUser.getUsername() %></b></p>
        <p>Vai trò: <b><%= roleName %></b></p>
    <% } %>
</div>


    <nav class="sidebar-nav">
    <% if (roleId == 1) { %>
        <!-- Admin -->
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard-user"
               class="nav-link <%= "dashboard-user".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-bar-chart-line-fill"></i> Dashboard
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/user?action=list"
               class="nav-link <%= "user".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-people-fill"></i> Quản lý Tài khoản
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/logs"
               class="nav-link <%= "logs".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-clock-history"></i> Nhật ký Log
            </a>
        </div>

        <!-- Manager -->
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/manager/service"
               class="nav-link <%= "service".equals(currentPage) ? "active" : "" %>">
               <i class="bi bi-grid"></i> Quản lý Dịch vụ chung
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/manager/revenue"
               class="nav-link <%= "revenue".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-coin"></i> Tổng doanh thu
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/manager/report"
               class="nav-link <%= "report".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-graph-up-arrow"></i> Báo cáo
            </a>
        </div>

        <!-- Staff -->
        <div class="nav-item nav-parent" id="servicesParent">
            <a class="nav-link">
                <i class="bi bi-briefcase-fill"></i> Dịch vụ 
                <i class="bi bi-caret-down-fill" style="margin-left:auto;"></i>
            </a>
        </div>
        <div class="nav-child" id="servicesChildren">
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/tours"
                   class="nav-link <%= "tours".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-map-fill"></i> Quản lý Tour
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/hotels"
                   class="nav-link <%= "hotels".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-building"></i> Quản lý Khách sạn
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/vehicles"
                   class="nav-link <%= "vehicles".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-car-front-fill"></i> Quản lý Phương tiện
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/places"
                   class="nav-link <%= "places".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-geo-alt-fill"></i> Quản lý Địa điểm
                </a>
            </div>
        </div>

        <div class="nav-item nav-parent" id="flightsParent">
            <a class="nav-link">
                <i class="bi bi-airplane-fill"></i> Chuyến bay 
                <i class="bi bi-caret-down-fill" style="margin-left:auto;"></i>
            </a>
        </div>
        <div class="nav-child" id="flightsChildren">
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/flight/tickets"
                   class="nav-link <%= "flights_tickets".equals(currentPage) ? "active" : "" %>">
                 <i class="bi bi-ticket-detailed"></i> Vé máy bay
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/flight/schedules"
                   class="nav-link <%= "flights_schedules".equals(currentPage) ? "active" : "" %>">
                   <i class="bi bi-calendar-check"> </i> Lịch trình chuyến bay
                </a>
            </div>
        </div>
                  <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/bookings"
                   class="nav-link <%= "flights_tickets".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-calendar2-check-fill"></i> Quản lý Booking
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/payments"
                   class="nav-link <%= "payments".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-credit-card-2-front-fill"></i> Quản lý Thanh toán
                </a>
            </div>
                    
                    

                    
                    
    <% } else if (roleId == 2) { %>
        <!-- Manager -->
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/manager/service"
               class="nav-link <%= "service".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-bell-fill"></i> Quản lý Dịch vụ
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/manager/revenue"
               class="nav-link <%= "revenue".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-coin"></i> Tổng doanh thu
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/manager/report"
               class="nav-link <%= "report".equals(currentPage) ? "active" : "" %>">
                <i class="bi bi-graph-up-arrow"></i> Báo cáo
            </a>
        </div>

    <% } else if (roleId == 4) { %>
        <!-- Staff riêng -->
         <div class="nav-item nav-parent" id="servicesParent">
            <a class="nav-link">
                <i class="bi bi-briefcase-fill"></i> Dịch vụ 
                <i class="bi bi-caret-down-fill" style="margin-left:auto;"></i>
            </a>
        </div>
        <div class="nav-child" id="servicesChildren">
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/tours"
                   class="nav-link <%= "tours".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-map-fill"></i> Quản lý Tour
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/hotels"
                   class="nav-link <%= "hotels".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-building"></i> Quản lý Khách sạn
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/vehicles"
                   class="nav-link <%= "vehicles".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-car-front-fill"></i> Quản lý Phương tiện
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/places"
                   class="nav-link <%= "places".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-geo-alt-fill"></i> Quản lý Địa điểm
                </a>
            </div>
        </div>

        <div class="nav-item nav-parent" id="flightsParent">
            <a class="nav-link">
                <i class="bi bi-airplane-fill"></i> Chuyến bay 
                <i class="bi bi-caret-down-fill" style="margin-left:auto;"></i>
            </a>
        </div>
        <div class="nav-child" id="flightsChildren">
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/flight/tickets"
                   class="nav-link <%= "flights_tickets".equals(currentPage) ? "active" : "" %>">
                 <i class="bi bi-ticket-detailed"></i> Vé máy bay
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/flight/schedules"
                   class="nav-link <%= "flights_schedules".equals(currentPage) ? "active" : "" %>">
                   <i class="bi bi-calendar-check"> </i> Lịch trình chuyến bay
                </a>
            </div>
        </div>
                  <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/bookings"
                   class="nav-link <%= "flights_tickets".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-calendar2-check-fill"></i> Quản lý Booking
                </a>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/staff/payments"
                   class="nav-link <%= "payments".equals(currentPage) ? "active" : "" %>">
                    <i class="bi bi-credit-card-2-front-fill"></i> Quản lý Thanh toán
                </a>
            </div>
                    
    <% } %>
</nav>

    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/logout" method="post" style="margin:0 ;">
            <button type="submit" class="logout-btn">
                <i class="fa fa-sign-out"></i> Đăng xuất
            </button>
        </a>
    </div>
</div>

<!-- Sidebar Toggle Button -->
<button id="sidebarToggle" style="position:fixed;top:15px;left:6px;background:#0077b6;color:white;border:none;padding:8px 12px;border-radius:6px;z-index:1000;">
    ☰
</button>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.staff-sidebar');
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show');
        });
        
        // Đóng sidebar khi click ra ngoài (trên mobile)
        document.addEventListener('click', function(e) {
            if (window.innerWidth <= 768 && 
                !sidebar.contains(e.target) && 
                !sidebarToggle.contains(e.target)) {
                sidebar.classList.remove('show');
            }
        });
    }
    
    // Dịch vụ dropdown
    const servicesParent = document.getElementById('servicesParent');
    const servicesChildren = document.getElementById('servicesChildren');
    
    if (servicesParent && servicesChildren) {
        servicesParent.addEventListener('click', function(e) {
            servicesParent.classList.toggle('expanded');
            servicesChildren.classList.toggle('expanded');
        });
    }

    // Flights dropdown
    const flightsParent = document.getElementById('flightsParent');
    const flightsChildren = document.getElementById('flightsChildren');

    if (flightsParent && flightsChildren) {
        flightsParent.addEventListener('click', function(e) {
            e.stopPropagation();
            flightsParent.classList.toggle('expanded');
            flightsChildren.classList.toggle('expanded');
        });
    }

    // Ngăn dropdown bị đóng khi click vào link con
    const navChildLinks = document.querySelectorAll('.nav-child > .nav-link');
    navChildLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    });
});
</script>
