<%-- 
    Document   : register
    Created on : Sep 18, 2025, 7:36:43 PM
    Author     : nqagh
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>

        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700,800,900" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Arizonia&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

        <link rel="stylesheet" href="css/animate.css">

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/owl.theme.default.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">

        <link rel="stylesheet" href="css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="css/jquery.timepicker.css">


        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/style1.css">

        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="views/home/css/bootstrap/bootstrap.min.css">

    </head>
    <body>

        <div class="container-fluid row">
            <!-- image of register page -->   

            <div class="left-panel col-md-7 p-0">
                <div class="img-regis">
                    <img src="${pageContext.request.contextPath}/views/home/images/register_pic1.jpg" alt="Island">
                </div>
            </div>

            <!-- content of register page -->   
            <div class="right-panel col-md-5">
                        <a href="index.jsp" class="btn-home">
   <i class="fa fa-home"></i> Trang chủ
</a>
                <div class="register-container">
                    <div class="logo"> 
                      <h1>🏝️ Island Travel</h1>
                    <p>Khám phá thiên đường biển đảo</p>
                    </div>
                   
                    <form action="registerServelt" method="POST">
                        <div class="form-group">
                            <span class="icon">👤</span>
                            <input type="text" id="username" name="username" placeholder="Tên đăng nhập">
                        </div>

                        <div class="form-group">
                            <span class="icon">🔒</span>
                            <input type="password" id="password" name="password" placeholder="Tối thiểu 8-10 kí tự" >
                        </div>

                        <div class="form-group">
                            <span class="icon">🔐</span>
                            <input type="password" id="rePassword" name="rePassword" placeholder="Nhập lại mật khẩu" >
                        </div>

                        <div class="form-group">
                            <span class="icon">📧</span>
                            <input type="email" id="email" name="email" placeholder="email" >
                        </div>

                        <div class="form-group">
                            <span class="icon">👤</span>
                            <input type="text" id="fullName" name="fullName" placeholder="họ và tên" >
                        </div>

                        <div class="form-group">
                            <span class="icon">📱</span>
                            <input type="tel" id="phone" name="phoneNumber" placeholder="Số diện thoại" >
                        </div>

                        <div class=" check_box">
                            <input type="checkbox" id="terms" required>
                            <label for="terms">Tôi đồng ý với <a href="#">những điều khoản dịch vụ</a></label>
                        </div>
                        <button  type="submit" class="register-btn">Đăng Ký</button>
                    </form>
                    <div class="login-link">
                        <p>Đã có tài khoản? <a href="login.">Đăng nhập</a></p>
                    </div>
                </div>
                <a href="index.jsp" class="btn-home">
 

        </div>


        <!-- Bootstrap JS and jquery (bundle đã gồm Popper.js) -->
        <script src="views/home/js/jquery-3.6.0.min.js"></script>
        <script src="views/home/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
