
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
            <!-- image of register page -->   

            <div class="left-panel col-lg-7 p-0">
                <div class="img-regis">
                    <img src="${pageContext.request.contextPath}/views/home/images/register_pic1.jpg" alt="Island">
                </div>
            </div>





            <!-- content of register page -->   
            <div class="right-panel col-lg-5">
                <a href="index.jsp" class="btn-home">
                    <i class="fa fa-home"></i> Trang Chủ
                </a>
             
                <div class="register-container">
                    <div class="logo"> 
                        <h1> 🏝️  Island Travel</h1>
                        <p>Khám phá thiên đường biển đảo</p>
                    </div>

                    <!--Thong bao loi -->         
           <%
    String error = (String) session.getAttribute("errorMess");
    if (error != null) {
%>
    <div id="errorAlert" class="alert alert-danger" role="alert">
        <%= error %>
    </div>
    <script>
        // Sau 5 giây thì ẩn alert
        setTimeout(function () {
            var alertBox = document.getElementById("errorAlert");
            if (alertBox) {
                alertBox.style.display = "none";
            }
        }, 3000);
    </script>
<%
        // Xóa thông báo để tránh bị hiển thị lại khi reload trang
        session.removeAttribute("errorMess");
    }
%>


                    <!--Form dang ky -->

                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="form-group">
                            <span class="icon">👤</span>
                            <input type="text" id="username" name="username" placeholder="Tên đăng nhập">
                        </div>

                        <div class="form-group">
                            <span class="icon">🔒</span>
                            <input type="password" id="password" name="password" placeholder="Tối thiểu 8-20 kí tự" >
                        </div>

                        <div class="form-group">
                            <span class="icon">🔐</span>
                            <input type="password" id="rePassword" name="rePassword" placeholder="Nhập lại mật khẩu" >
                        </div>

                        <div class="form-group">
                            <span class="icon">📧</span>
                            <input type="email" id="email" name="email" placeholder="Email" >
                        </div>

                        <div class="form-group">
                            <span class="icon">👤</span>
                            <input type="text" id="fullName" name="fullName" placeholder="Họ và tên" >
                        </div>

                        <div class="form-group">
                            <span class="icon">📱</span>
                            <input type="tel" id="phone" name="phoneNumber" placeholder="Số diện thoại" >
                        </div>

                        <div class="check_box">
                            <input type="checkbox" id="terms" required>
                            <label for="terms">Tôi đồng ý với <a href="Service_Terms.jsp" target="_blank">những điều khoản dịch vụ </a></label>
                        </div>
                        <button  type="submit" class="register-btn">Đăng Ký</button>

                    </form>
                    <div class="login-link">
                        <p>Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
                    </div>
                </div>



            </div>


            <!-- Bootstrap JS and jquery (bundle đã gồm Popper.js) -->
            <script src="${pageContext.request.contextPath}/views/home/js/jquery-3.6.0.min.js"></script>
            <script src="${pageContext.request.contextPath}/views/home/js/bootstrap.bundle.min.js"></script>



            <!-- thong bao loi javaScript -->
            <script>

            </script>

    </body>
</html>
