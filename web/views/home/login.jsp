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
        <div class="container-fluid row">
            <!-- image of login page -->  
            <div class="left-panel col-lg-7 p-0">
                <div class="img-login">
                    <img src="${pageContext.request.contextPath}/views/home/images/login_pic.jpg" alt="Island"/>  
                </div>
            </div>

            <!-- content of login page -->
            <div class="right-panel col-lg-5">
                <a href="index.jsp" class="btn-home1">
                    <i class="fa fa-home"> </i> Trang Chủ
                </a>
                <div class="login-container">
                    <div class="logo1">
                        <h1> 🏝️ Island Travel</h1>
                        <p>Khám phá nhịp sống biển đảo</p>
                    </div>

                    <!-- Thông báo lỗi -->
                    <%
                        String error = (String) session.getAttribute("errorMess");
                        if (error != null) {
                    %>
                        <div id="errorAlert" class="alert alert-danger" role="alert">
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

                    <!-- Form đăng nhập -->
                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="form-group1">
                            <label class="form-label"> Tên đăng nhập</label>
                            <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập">
                        </div> 
                        <div class="form-group1">
                            <label for="password" class="form-label"> Mật khẩu</label>
                            <input type="password" id="password" name="pass" placeholder="Nhập mật khẩu">
                        </div>

                        <div class="forget-pass">
                            <div class="check_box">
                                <input type="checkbox" name="remember" id="terms">
                                <label for="terms"> Ghi nhớ đăng nhập</label>
                            </div>
                            <!-- Mở modal -->
                            <a href="#" class="forgot-pass" data-toggle="modal" data-target="#forgetModal"> Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn-login-page">
                            Đăng Nhập 
                        </button>

                        <!-- Đăng nhập bằng google -->
                        <div class="google-login-container">
                            <div class="divider">
                                <span>hoặc đăng nhập với</span>
                            </div>
                            <a href="#" class="btn-google">
                                <i class="fa fa-google"></i>
                                Đăng nhập bằng Google
                            </a>
                        </div>
                        
                        <!-- Chưa có tài khoản -> đăng ký -->
                        <div class="signup-link">
                            Chưa có tài khoản? <a href="register.jsp" class="link-dk">Đăng ký ngay</a>
                        </div>
                    </form>
                </div>    
            </div>
        </div>

       <!-- Modal Quên mật khẩu -->
<div class="modal fade" id="forgetModal" tabindex="-1" role="dialog" aria-labelledby="forgetModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content custom-modal">
      
      <div class="modal-header border-0">
        <h5 class="modal-title text-primary font-weight-bold" id="forgetModalLabel">
          🔑 Quên mật khẩu
        </h5>
        <button type="button" class="close btn-close" data-dismiss="modal" aria-label="Đóng">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      
      <div class="modal-body">
        <p class="text-muted mb-3">
          Vui lòng nhập email để nhận mã OTP khôi phục mật khẩu.
        </p>
        <form action="${pageContext.request.contextPath}/sendOtp" method="post">
          <div class="form-group">
            <input type="email" class="form-control input-custom" id="email" name="email" placeholder="📧 Nhập email của bạn" required>
          </div>
          <button type="submit" class="btn btn-gradient w-100 mt-3">Gửi OTP</button>
        </form>
      </div>
    </div>
  </div>
</div>


        <!-- Bootstrap JS and jquery -->
        <script src="${pageContext.request.contextPath}/views/home/js/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/views/home/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
