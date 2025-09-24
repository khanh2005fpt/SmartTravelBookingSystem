<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<!-- lay thong tin user tu session  -->
<%
    User user = (User)session.getAttribute("user");
%>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">Meland<span>Công ty Du lịch</span></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" 
                aria-controls="ftco-nav" aria-expanded="false" aria-label="Chuyển đổi điều hướng">
            <span class="oi oi-menu"></span> Menu
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
            <link rel="stylesheet" href="views/home/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/style1.css">
        </button>
        <div class="collapse navbar-collapse" id="ftco-nav">
            <ul class="navbar-nav ml-auto align-items-center">
                <li class="nav-item"><a href="index.jsp" class="nav-link">Trang chủ</a></li>
                <li class="nav-item"><a href="about.jsp" class="nav-link">Giới thiệu</a></li>
                <li class="nav-item"><a href="destination.jsp" class="nav-link">Điểm đến</a></li>
                <li class="nav-item"><a href="hotel.jsp" class="nav-link">Khách sạn</a></li>
                <li class="nav-item"><a href="blog.jsp" class="nav-link">Blog</a></li>
                <li class="nav-item"><a href="contact.jsp" class="nav-link">Liên hệ</a></li>


                <!-- neu chua login -->


                <%
                    if (user == null) {
                        // Chưa đăng nhập → Hiện nút login/register
                %>
                <li class="nav-item ml-lg-5 ml-5 " ">
                    <a href="login.jsp" class="btn btn-login1"> 

                        Đăng nhập</a>

                </li>

                <li class="nav-item ml-lg-3">
                    <a href="register.jsp" class="btn btn-register1 "   >Đăng ký</a>
                </li> 


                <%
                    } else {
                        // Đã đăng nhập → Hiện profile dropdown
                %>
                
<li class="nav-item dropdown ml-lg-5">
    <a href="#" 
       class="nav-link dropdown-toggle d-flex align-items-center" 
       id="userDropdown" 
       role="button" 
       data-toggle="dropdown" 
       aria-haspopup="true" 
       aria-expanded="false"
       style="background: #fff; padding: 8px 12px; border-radius: 8px; font-weight: 600; color: #0077b6;">
       
        <i class="bi bi-person-circle mr-2" style="font-size: 20px;"></i>
        <span><%= user != null ? user.getFullName() : "Khách" %> | 0 Điểm</span>
    </a>

    <!-- Menu xổ xuống -->
    <div class="dropdown-menu dropdown-menu-right shadow" aria-labelledby="userDropdown">
        <a class="dropdown-item" href="profile.jsp"><i class="bi bi-person-lines-fill mr-2"></i> Trang cá nhân</a>
        <a class="dropdown-item" href="notifications.jsp"><i class="bi bi-bell mr-2"></i> Thông báo</a>
        <a class="dropdown-item" href="settings.jsp"><i class="bi bi-gear mr-2"></i> Cài đặt</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right mr-2"></i> Đăng xuất</a>
    </div>
</li>
                <%
                    }
                %>


            </ul>
        </div>
    </div>
</nav>