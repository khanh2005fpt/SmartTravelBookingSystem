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
                        <a href="${pageContext.request.contextPath}/views/home/index.jsp" class="btn btn-outline-primary">
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

                        <!-- Thông báo lỗi  -->


                        <% String error = (String) session.getAttribute("errorMess"); %>
                      

                        <% if (error != null) { %>
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
                        <% session.removeAttribute("errorMess"); %>
                        <% } %>
               <!-- Thông báo lỗi gui email thanh cong -->           
  <% String success = (String) session.getAttribute("successMessage"); %>
                        <% if (success != null) { %>
                        <div id="successAlert" class="alert alert-success alert_style" role="alert">
                            <%= success %>
                        </div>
                        
                        <script>
                            setTimeout(function () {
                                var alertBox = document.getElementById("successAlert");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 3000);
                        </script>
                        <% session.removeAttribute("successMessage"); %>
                        <% } %>


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
                                  <input class="form-check-input" type="checkbox" name="remember" id="remember" 
                   ${rememberedUser != null ? 'checked' : ''}>
            <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                                </div>
                                <a href="#" class="forgot-pass text-primary" data-toggle="modal" data-target="#forgetModal"> Quên mật khẩu?</a>
                            </div>


                            <button type="submit" class="btn btn-primary w-100 mb-3 mt-3  d-flex align-items-center justify-content-center" style="height: 37px;"">Đăng Nhập</button>

                            <div class="text-center text-muted-option mb-3 mt-2">hoặc đăng nhập với </div>

                            <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid

&redirect_uri=http://localhost:9090/SmartBookingTravelSystem/login

&response_type=code

&client_id=552818851773-6psek03psq9r6tnpec86rgs6hrbhqqql.apps.googleusercontent.com

&approval_prompt=force" class="btn btn-google w-100 mb-3 mt-2 d-flex align-items-center justify-content-center" style="height: 50px;">
                               <img src="${pageContext.request.contextPath}/views/home/images/google_logo.png"  alt="Google" style="width:20px; height:20px; margin-right:8px;"> Đăng nhập bằng Google
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
                       <!-- thong bao loi trong modal -->
                        <% String errorEmail = (String) session.getAttribute("errorEmail"); %>
                        <% if (errorEmail != null) { %>
                        <div id="errorAlert" class="alert alert-danger alert_style"><%= errorEmail %></div>
                        <% } %>
                        <script>
                            setTimeout(function () {    
                                var alertBox = document.getElementById("errorAlert");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 3000);
                        </script>


                        <p class="text-muted mb-3">
                            Vui lòng nhập email để nhận mã OTP khôi phục mật khẩu.
                        </p>

                        <form action="${pageContext.request.contextPath}/requestPassword" method="POST">
                            <div class="form-group">
                                <input type="email" class="form-control input-custom" id="email" name="email" placeholder="📧 Nhập email của bạn">
                                <button type="submit" class="btn btn-gradient w-100 mt-3">Gửi OTP</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    <!-- thong bao k ton tai va de trong email
    --> 
     <script>
            document.addEventListener("DOMContentLoaded", function () {
            <% 
                boolean hasError = (session.getAttribute("errorEmail") != null);
        
                if (hasError) { 
            %>
                var myModal = new bootstrap.Modal(document.getElementById('forgetModal'));
                myModal.show();
            <% 
                    // xoa session sau khi hien thi
                    session.removeAttribute("errorEmail");
            
                } 
            %>
            });
        </script>


    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/views/home/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/views/home/js/bootstrap.bundle.min.js"></script>
</body>
</html>
