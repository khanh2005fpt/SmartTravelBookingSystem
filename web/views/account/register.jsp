
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
        <%@ include file="/views/common/css.jsp" %>
    </head>
    
             <!-- lay thong tin user và athorized -->
        
    <%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }
if (currentUser != null) {
    int roleId = currentUser.getRoleId();

    if (roleId != 1 && roleId != 3) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>
   <body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            
            <!-- Cột hình ảnh -->
            <div class="right-panel col-lg-7 d-none d-lg-block p-0">
                <img src="${pageContext.request.contextPath}/views/home/images/register_pic1.jpg" 
                     alt="Island" class="w-100 h-100 object-fit-cover">
            </div>

            <!-- Cột form -->
            <div class="col-lg-5 d-flex flex-column justify-content-center align-items-center p-4 bg-light">
                
                <!-- Nút về trang chủ -->
            <div class="d-flex justify-content-end mb-5" style="max-width: 480px; width: 100%;">
                    <a href="${pageContext.request.contextPath}/views/home/index.jsp" class="btn btn-outline-primary ">
                        <i class="fa fa-home"></i> Trang Chủ
                    </a>
                    
                </div>

                <div class="register-container mb-5">
                    <!-- Logo -->
                    <div class="text-center_register mb-5  logo">
                        <h1 class="fw-bold ">🏝️ Island Travel</h1>
                        <p class="text-muted ml-4">Khám phá thiên đường biển đảo</p>
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

                    <!-- Form đăng ký -->
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="mb-4 input-group">
                            <span class="input-group-text">👤</span>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Tên đăng nhập">
                        </div>

                        <div class="mb-4 input-group">
                            <span class="input-group-text">🔒</span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Tối thiểu 8-20 kí tự">
                        </div>

                        <div class="mb-4 input-group">
                            <span class="input-group-text">🔐</span>
                            <input type="password" class="form-control" id="rePassword" name="rePassword" placeholder="Nhập lại mật khẩu">
                        </div>

                        <div class="mb-4 input-group">
                            <span class="input-group-text">📧</span>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Email">
                        </div>

                        <div class="mb-4 input-group">
                            <span class="input-group-text">👤</span>
                            <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Họ và tên">
                        </div>

                        <div class="mb-4 input-group">
                            <span class="input-group-text">📱</span>
                            <input type="tel" class="form-control" id="phone" name="phoneNumber" maxlength="11" placeholder="Số điện thoại">
                        </div>

                        <!-- Checkbox -->
                        <div class="form-check mb-4 ml-3">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label" for="terms">
                                Tôi đồng ý với <a href=" ${pageContext.request.contextPath}/views/home/service_terms.jsp" target="_blank">điều khoản dịch vụ</a>
                            </label>
                        </div>

                            <button type="submit" class="btn w-100 text-white" style="background:#007BFF ">Đăng Ký</button>
                    </form>

                    <!-- Link đăng nhập -->
                    <div class="login-link text-center mt-3 text_login">
                        <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/views/account/login.jsp">Đăng nhập</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
          
                        
        <%@ include file="/views/common/script.jsp" %>
</body>

</html>
        