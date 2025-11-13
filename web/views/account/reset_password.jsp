    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ page import="model.User" %>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Reset Password</title>
  <!-- Google Font -->
   <%@ include file="/views/common/css.jsp" %>
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
   background: url("${pageContext.request.contextPath}/views/home/images/island_Bg.jpg") no-repeat center center fixed;
background-size: cover;
    }
    .reset-container {
      background: #fff;
      padding: 30px;
      border-radius: 14px;
       box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      width: 360px;
       border: 1px solid #e0e0e0;
    }
    .reset-container h2 {
      text-align: center;
      margin-bottom: 25px;
      font-size: 30px;
      max-width: 100%;
      color: #222;
      margin-right: 20px;
      height: 40px;
    }
    /* OTP style */
    .otp-group {
      display: flex;
      justify-content: space-between;
      margin-bottom: 25px;
    }
    .otp-group input {
      width: 42px;
      height: 52px;
      font-size: 20px;
      text-align: center;
      border: 1px solid #ccc;
      border-radius: 10px;
      outline: none;
      transition: all 0.2s;
      font-weight: 500;
    }
    .otp-group input:focus {
      border-color: #007bff;
      box-shadow: 0 0 4px rgba(0,123,255,0.3);
    }
    /* Password style */
    .form-group {
      position: relative;
      margin-bottom: 22px;
    }
    .form-group input {
      width: 100%;
      border: none;
      border-bottom: 2px solid #ccc;
      padding: 10px 5px;
      font-size: 15px;
      outline: none;
      background: transparent;
      font-weight: 500;
    }
    .form-group input:focus {
      border-bottom-color: #007bff;
    }
    .form-group label {
      position: absolute;
      top: 10px;
      left: 5px;
      font-size: 14px;
      color: #888;
      pointer-events: none;
      transition: 0.2s ease all;
      font-weight: 400;
    }
    .form-group input:focus + label,
    .form-group input:not(:placeholder-shown) + label {
      top: -10px;
      font-size: 12px;
      color: #007bff;
    }
    /* Button */
    .btn-submit {
      width: 100%;
      padding: 13px;
      border: none;
      border-radius: 8px;
      background: #007bff;
      color: #fff;
      font-size: 15px;
      font-weight: 500;
      cursor: pointer;
      transition: background 0.25s;
      margin-top: 10px;
      letter-spacing: 0.5px;
    }
    .btn-submit:hover {
      background: #0056b3;
    }
  </style>
</head>

         <!-- lay thong tin user và athorized -->
 
<body>
  <div class="reset-container">
    <h2>🔑Reset Password</h2>
    <form action="${pageContext.request.contextPath}/ResetPassword" method="post">
      
    <%
      Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
    
    %>

    <% if (otpVerified == null || !otpVerified) { %>
        <!-- Nhập OTP -->
        <div class="otp-group">
          <input type="text" maxlength="1" inputmode="numeric" class="otp-input">
          <input type="text" maxlength="1" inputmode="numeric" class="otp-input">
          <input type="text" maxlength="1" inputmode="numeric" class="otp-input">
          <input type="text" maxlength="1" inputmode="numeric" class="otp-input">
          <input type="text" maxlength="1" inputmode="numeric" class="otp-input">
          <input type="text" maxlength="1" inputmode="numeric" class="otp-input">
        </div>
        <input type="hidden" id="otp" name="otp">
    <% } else { %>
      
        <input type="hidden" name="otpVerified" value="true">
    <% } %>

       <!-- Thông báo lỗi input -->
       
       <% String error = (String) session.getAttribute("errorPass"); %>
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
                        <% session.removeAttribute("errorPass"); %>
                        <% } %>
       
       
      <!-- Password -->
        
      <!-- lay emai de hien thi -->
      <%
          String emailUser = (String) session.getAttribute("resetEmail");

          %>
          
          
        <div class="form-group">
            <input type="email" id="email" name="email"  value="<%= emailUser %>" readonly/>
        <label for="password">Email</label>
      </div>
      
      <div class="form-group">
        <input type="password" id="password" name="password"  placeholder=" ">
        <label for="password">Mật khẩu mới</label>
      </div>
      <div class="form-group">
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder=" ">
        <label for="confirmPassword">Nhập lại mật khẩu</label>
      </div>
      <button type="submit" class="btn-submit">Xác nhận</button>
    </form>
        <!-- Link quay lại login -->
<div class="text-center  mt-3 ">
  <a href="${pageContext.request.contextPath}/views/account/login.jsp" class="back-link" style="color:#007BFF">
    <i class="fa fa-arrow-left"></i> Quay lại đăng nhập
  </a>
</div>
        
  </div>
        
    
    
<script>
  const otpInputs = document.querySelectorAll(".otp-group input");
  const otpHidden = document.getElementById("otp");

  otpInputs.forEach((input, index) => {
    input.addEventListener("input", () => {
      // Chỉ cho nhập số
      input.value = input.value.replace(/[^0-9]/g, "");

      // Nếu nhập xong thì nhảy sang ô kế tiếp
      if (input.value.length === 1 && index < otpInputs.length - 1) {
        otpInputs[index + 1].focus();
      }
    });

    input.addEventListener("keydown", (e) => {
      if (e.key === "Backspace" && input.value === "" && index > 0) {
        otpInputs[index - 1].focus();
      }
    });
  });

  // Khi submit form thì ghép OTP lại
  document.querySelector("form").addEventListener("submit", function () {
    let otpValue = "";
    otpInputs.forEach(input => otpValue += input.value);
    otpHidden.value = otpValue;
  });
</script>

  
<%@ include file="/views/common/script.jsp" %>
</body>
</html>