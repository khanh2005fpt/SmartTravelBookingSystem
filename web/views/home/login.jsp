<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>

        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700,800,900" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Arizonia&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/animate.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/magnific-popup.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/jquery.timepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/flaticon.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/style1.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/bootstrap/bootstrap.min.css">
    </head>
   <body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            
            <!-- Cột hình ảnh -->
            <div class="col-lg-7 d-none d-lg-block p-0">
                <img src="${pageContext.request.contextPath}/views/home/images/login_pic.jpg" 
                     alt="Island" class="w-100 h-100 object-fit-cover">
            </div>

            <!-- Cột form -->
            <div class="col-lg-5 d-flex flex-column justify-content-center align-items-center p-4 bg-light">
                
                <!-- Nút home -->
                <div class="d-flex justify-content-end  mb-5 " style="max-width: 450px; width: 100%;" >
                    <a href="index.jsp" class="btn btn-outline-primary">
                        <i class="fa fa-home"></i> Trang Chủ
                    </a>
                </div>

                <!-- Form login -->
                <div class="login-container p-4 bg-white rounded shadow">
                    
                    <!-- Logo -->
                    <div class="text-center mb-4">
                        <h1 class="fw-bold text-primary mr-2" style="font-family:'Arizonia', cursive;">
                            🏝️ Island Travel
                        </h1>
                        <p class="text-muted-logo">Khám phá nhịp sống biển đảo</p>
                    </div>

                    <!-- Thông báo lỗi -->
                    <%
                        String error = (String) session.getAttribute("errorMess");
                        if (error != null) {
                    %>
                        <div id="errorAlert" class="alert alert-danger alert_style" role="alert">
                            <%= error %>
                        </div>
                        <script>
                            setTimeout(function () {
                                var alertBox = document.getElementById("errorAlert");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 3000);
                        </script>
                    <%
                            session.removeAttribute("errorMess");
                        }
                    %>

                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        
                        <div class="mb-4">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" >
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="pass" placeholder="Nhập mật khẩu" >
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3 mt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="remember" id="remember">
                                <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                            </div>
                            <a href="#" class="text-decoration-none text-primary" data-bs-toggle="modal" data-bs-target="#forgetModal">
                                Quên mật khẩu?
                            </a>
                        </div>
                        

                        <button type="submit" class="btn btn-primary w-100 mb-3 mt-3">Đăng Nhập</button>

                        <div class="text-center text-muted-option mb-3 mt-2">hoặc đăng nhập với </div>

                        <a href="#" class="btn btn-outline-danger w-100 mb-3 mt-2">
                            <i class="fa fa-google"></i> Đăng nhập bằng Google
                        </a>

                        <div class="text-center">
                            <p>Chưa có tài khoản? 
                                <a href="register.jsp" class="fw-bold text-primary">Đăng ký ngay</a>
                            </p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Quên mật khẩu -->
    <div class="modal fade" id="forgetModal" tabindex="-1" aria-labelledby="forgetModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          
          <div class="modal-header border-0">
            <h5 class="modal-title text-primary fw-bold" id="forgetModalLabel">🔑 Quên mật khẩu</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
          </div>
          
          <div class="modal-body">
            <p class="text-muted mb-3">Vui lòng nhập email để nhận mã OTP khôi phục mật khẩu.</p>
            <form action="${pageContext.request.contextPath}/sendOtp" method="post">
              <div class="mb-3">
                <input type="email" class="form-control" id="email" name="email" placeholder="📧 Nhập email của bạn" required>
              </div>
              <button type="submit" class="btn btn-primary w-100">Gửi OTP</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
 <script src="${pageContext.request.contextPath}/views/home/js/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/views/home/js/bootstrap.bundle.min.js"></script>
</body>
</html>
   