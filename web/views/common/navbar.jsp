<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">Meland<span>Công ty Du lịch</span></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" 
                aria-controls="ftco-nav" aria-expanded="false" aria-label="Chuyển đổi điều hướng">
            <span class="oi oi-menu"></span> Menu
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
              <link rel="stylesheet" href="views/home/css/style.css">
        </button>
        <div class="collapse navbar-collapse" id="ftco-nav">
            <ul class="navbar-nav ml-auto align-items-center">
                <li class="nav-item"><a href="index.jsp" class="nav-link">Trang chủ</a></li>
                <li class="nav-item"><a href="about.jsp" class="nav-link">Giới thiệu</a></li>
                <li class="nav-item"><a href="destination.jsp" class="nav-link">Điểm đến</a></li>
                <li class="nav-item"><a href="hotel.jsp" class="nav-link">Khách sạn</a></li>
                <li class="nav-item"><a href="blog.jsp" class="nav-link">Blog</a></li>
                <li class="nav-item"><a href="contact.jsp" class="nav-link">Liên hệ</a></li>
                
                <!-- Thêm nút đăng nhập / đăng ký -->
                
                <li class="nav-item ml-lg-5">
                    <a href="login.jsp" class="btn btn-login btn-outline-white me-2"> 
                        <i class="bi bi-person"></i>
                        Đăng nhập</a>
                    
                </li>
                <div>
                   <li class="nav-item ml-lg-3">
                    <a href="register.jsp" class="btn btn-primary btn-outline-primary ">Đăng ký</a>
                </li> 
                </div>
                

            </ul>
        </div>
    </div>
</nav>
