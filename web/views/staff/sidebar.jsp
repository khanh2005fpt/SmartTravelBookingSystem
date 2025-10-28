<%-- 
    Document   : sidebar
    Created on : Staff Sidebar Component
    Author     : System
    Description: Modular sidebar component for staff pages navigation
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User staffUser = (User) session.getAttribute("user");
    String currentPage = request.getParameter("page");
    if (currentPage == null) {
        currentPage = "";
    }
%>

<style>
.staff-sidebar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
    position: fixed;
    top: 0;
    left: 0;
    width: 250px;
    z-index: 1000;
    overflow-y: auto;
}

.sidebar-header {
    padding: 20px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    background: rgba(0,0,0,0.1);
}

.sidebar-header h4 {
    color: white;
    margin: 0;
    font-weight: 600;
}

.sidebar-header .staff-info {
    color: rgba(255,255,255,0.8);
    font-size: 0.9em;
    margin-top: 5px;
}

.sidebar-nav {
    padding: 20px 0;
}

.nav-item {
    margin: 5px 15px;
}

.nav-link {
    display: flex;
    align-items: center;
    padding: 12px 20px;
    color: rgba(255,255,255,0.8);
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.3s ease;
    font-weight: 500;
}

.nav-link:hover {
    background: rgba(255,255,255,0.1);
    color: white;
    text-decoration: none;
    transform: translateX(5px);
}

.nav-link.active {
    background: rgba(255,255,255,0.2);
    color: white;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.nav-link i {
    margin-right: 12px;
    width: 20px;
    text-align: center;
    font-size: 1.1em;
}

.nav-parent {
    cursor: pointer;
    position: relative;
}

.nav-parent .expand-icon {
    position: absolute;
    right: 20px;
    top: 50%;
    transform: translateY(-50%);
    transition: transform 0.3s ease;
}

.nav-parent.expanded .expand-icon {
    transform: translateY(-50%) rotate(90deg);
}

.nav-children {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease;
    background: rgba(0,0,0,0.1);
    margin: 0 15px;
    border-radius: 8px;
}

.nav-children.expanded {
    max-height: 300px;
}

.nav-child {
    margin: 0;
}

.nav-child .nav-link {
    padding: 10px 20px 10px 40px;
    font-size: 0.9em;
    border-radius: 0;
}

.nav-child:first-child .nav-link {
    border-radius: 8px 8px 0 0;
}

.nav-child:last-child .nav-link {
    border-radius: 0 0 8px 8px;
}

.sidebar-footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    padding: 20px;
    border-top: 1px solid rgba(255,255,255,0.1);
    background: rgba(0,0,0,0.1);
}

.logout-btn {
    width: 100%;
    padding: 10px;
    background: rgba(220, 53, 69, 0.8);
    color: white;
    border: none;
    border-radius: 6px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.logout-btn:hover {
    background: rgba(220, 53, 69, 1);
    transform: translateY(-2px);
}

@media (max-width: 768px) {
    .staff-sidebar {
        transform: translateX(-100%);
        transition: transform 0.3s ease;
    }
    
    .staff-sidebar.show {
        transform: translateX(0);
    }
}
</style>

<div class="staff-sidebar">
    <!-- Sidebar Header -->
    <div class="sidebar-header">
        <h4><i class="fa fa-user-tie"></i> Quản lý nhân viên</h4>
        <% if (staffUser != null) { %>
            <div class="staff-info">
                Xin chào, <%= staffUser.getUsername() %>
            </div>
        <% } %>
    </div>

    <!-- Navigation Menu -->
    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/staff/tours" 
               class="nav-link <%= "tours".equals(currentPage) ? "active" : "" %>">
                <i class="fa fa-map-marker"></i>
                Quản lý Tour
            </a>
        </div>

        <div class="nav-item">
            <div class="nav-link nav-parent expanded" id="servicesParent">
                <i class="fa fa-cogs"></i>
                Quản lý Dịch vụ
                <i class="fa fa-chevron-right expand-icon"></i>
            </div>
            <div class="nav-children expanded" id="servicesChildren">
                <div class="nav-child">
                    <a href="${pageContext.request.contextPath}/staff/hotels" 
                       class="nav-link <%= "hotels".equals(currentPage) ? "active" : "" %>">
                        <i class="fa fa-building"></i>
                        Quản lý Khách sạn
                    </a>
                </div>
                <div class="nav-child">
                    <a href="${pageContext.request.contextPath}/staff/vehicles" 
                       class="nav-link <%= "vehicles".equals(currentPage) ? "active" : "" %>">
                        <i class="fa fa-car"></i>
                        Quản lý Phương tiện
                    </a>
                </div>
                <div class="nav-child">
                    <a href="${pageContext.request.contextPath}/staff/flights" 
                       class="nav-link <%= "flights".equals(currentPage) ? "active" : "" %>">
                        <i class="fa fa-cutlery"></i>
                        Quản lý vé máy bay
                    </a>
                </div>
                <div class="nav-child">
                    <a href="${pageContext.request.contextPath}/staff/places" 
                       class="nav-link <%= "places".equals(currentPage) ? "active" : "" %>">
                        <i class="fa fa-map-pin"></i>
                        Quản lý Địa điểm
                    </a>
                </div>
            </div>
        </div>

        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/staff/bookings" 
               class="nav-link <%= "bookings".equals(currentPage) ? "active" : "" %>">
                <i class="fa fa-calendar-check-o"></i>
                Quản lý Booking
            </a>
        </div>

        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/staff/payments" 
               class="nav-link <%= "payments".equals(currentPage) ? "active" : "" %>">
                <i class="fa fa-credit-card"></i>
                Quản lý Thanh toán
            </a>
        </div>
    </nav>

    <!-- Sidebar Footer -->
    <div class="sidebar-footer">
        <form action="${pageContext.request.contextPath}/logout" method="post" style="margin: 0;">
            <button type="submit" class="logout-btn">
                <i class="fa fa-sign-out"></i> Đăng xuất
            </button>
        </form>
    </div>
</div>

<!-- Mobile Toggle Button -->
<button class="btn btn-primary d-md-none" id="sidebarToggle" 
        style="position: fixed; top: 20px; left: 20px; z-index: 1001;">
    <i class="fa fa-bars"></i>
</button>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.staff-sidebar');
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show');
        });
        
        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function(e) {
            if (window.innerWidth <= 768 && 
                !sidebar.contains(e.target) && 
                !sidebarToggle.contains(e.target)) {
                sidebar.classList.remove('show');
            }
        });
    }
    
    // Handle expandable navigation
    const servicesParent = document.getElementById('servicesParent');
    const servicesChildren = document.getElementById('servicesChildren');
    
    if (servicesParent && servicesChildren) {
        servicesParent.addEventListener('click', function() {
            // Toggle expanded class
            servicesParent.classList.toggle('expanded');
            servicesChildren.classList.toggle('expanded');
        });
    }
});
</script>