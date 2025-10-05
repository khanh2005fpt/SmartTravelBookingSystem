<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<!-- lay thong tin user tu session  -->
<%
    User user = (User)session.getAttribute("user");
%>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/SearchIslandController">Meland<span>Công ty Du lịch</span></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" 
                aria-controls="ftco-nav" aria-expanded="false" aria-label="Chuyển đổi điều hướng">
            <span class="oi oi-menu"></span> Menu
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
            <link rel="stylesheet" href="views/home/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/style1.css">
        </button>
        <div class="collapse navbar-collapse" id="ftco-nav">
            <ul class="navbar-nav ml-auto align-items-center">


                <!-- neu chua login -->


                <li class="nav-item"><a href="${pageContext.request.contextPath}/SearchIslandController" class="nav-link">Trang chủ</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/about.jsp" class="nav-link">Giới thiệu</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/destination.jsp" class="nav-link">Điểm đến</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/blog.jsp" class="nav-link">Blog</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/contact.jsp" class="nav-link">Liên hệ</a></li>
                <!-- Thêm nút đăng nhập / đăng ký -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="dropdown04" data-toggle="dropdown" 
                       aria-haspopup="true" aria-expanded="false">Dịch vụ</a>
                    <div class="dropdown-menu" aria-labelledby="dropdown04">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/home/flight.jsp">Vé máy bay</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/HotelsController">Khách sạn</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/home/transport.jsp">Vé phương tiện di chuyển đến đảo</a>
                    </div>
                </li>




                <%
                    if (user == null) {
                        // Chưa đăng nhập → Hiện nút login/register
                %>
                <li class="nav-item ml-lg-5 ml-5 " ">
                    <a href="${pageContext.request.contextPath}/views/home/login.jsp" class="btn btn-login1"> 

                        Đăng nhập</a>


                </li>




                <li class="nav-item ml-lg-3">
                    <a href="${pageContext.request.contextPath}/views/home/register.jsp" class="btn btn-register1 "   >Đăng ký</a>
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
                    <div class="dropdown-menu dropdown-menu-right shadow w-75" aria-labelledby="userDropdown">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/home/profile.jsp"><i class="bi bi-person-lines-fill mr-2"></i> Trang cá nhân</a>
                        <a class="dropdown-item" href="notifications.jsp"><i class="bi bi-bell mr-2"></i> Thông báo</a>
                        <a class="dropdown-item" href="settings.jsp"><i class="bi bi-gear mr-2"></i> Cài đặt</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item text-danger" href="#" data-toggle="modal" data-target="#logoutModal">
                            <i class="bi bi-box-arrow-right mr-2"></i> Đăng xuất
                        </a>    </div>
                </li>

                <%
                    }
                %>


            </ul>
        </div>
    </div>
</nav>

<!-- Logout Modal -->

<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content logout-box">

            <!-- Body -->
            <div class="logout-body text-center p-4">
                <h2 class="logout-header mb-3">Xác nhận đăng xuất</h2>
                <h5>
                    Nếu bạn đăng xuất, bạn sẽ không thể quản lý các chuyến đi, đặt phòng và ưu đãi du lịch hiện tại.<br>
                    Bạn có chắc chắn muốn thoát khỏi Meland Booking không?
                </h5>
                <div class="mt-4">
                    <button class="btn btn-cancel mr-2" data-dismiss="modal">Không</button>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Có</a>
                </div>
            </div>

        </div>
    </div>
</div>



<style>

    /* -------- Modal Logout -------- */
 
    .logout-box {
        width: 380px;
        max-width: 100%;
        border-radius: 12px;
        margin: auto;
        background: #fff;
        border: none;
        box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        text-align: center;
    }


    .logout-header {
        font-size: 1.5rem;
        font-weight: 800;
        color: #1976d2; /* xanh dương */
    }

    .logout-body h5 {
        font-size: 1rem;
        font-weight: normal;
        color: #000;
    }

  
    .btn-cancel {
        background: #fff;
        color: #1976d2;
        font-weight: 600;
        padding: 8px 20px;
        border: 2px solid #1976d2;
        border-radius: 6px;
        transition: 0.25s;
    }

    .btn-cancel:hover {
        background: #1976d2;
        color: #fff !important;
    }


    .btn-logout {
        background: #1976d2;
        color: #fff;
        font-weight: 600;
        padding: 8px 20px;
        border-radius: 6px;
        border: none;
        transition: 0.25s;
    }

    .btn-logout:hover {
        background: #0d47a1;
        color: #fff !important;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(25,118,210,0.3);

    }

    /* Nền ngoài modal sáng hơn */
    .modal-backdrop.show {
        opacity: 0.3 !important;
    }


    
    
</style> 
