    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Reset Password</title>
  <!-- Google Font -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/bootstrap/bootstrap.min.css">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: #f4f6f9;
    }
    .reset-container {
      background: #fff;
      padding: 30px;
      border-radius: 14px;
      box-shadow: 0 6px 18px rgba(0,0,0,0.08);
      width: 340px;
    }
    .reset-container h2 {
      text-align: center;
      margin-bottom: 25px;
      font-size: 30px;
      font-weight: 600;
      color: #222;
      margin-right: 20px;
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
<body>
  <div class="reset-container">
    <h2>🔑Reset Password</h2>
    <form action="${pageContext.request.contextPath}/resetPassword" method="post">
      <!-- OTP -->
      <div class="otp-group">
        <input type="text" maxlength="1" inputmode="numeric" required>
        <input type="text" maxlength="1" inputmode="numeric" required>
        <input type="text" maxlength="1" inputmode="numeric" required>
        <input type="text" maxlength="1" inputmode="numeric" required>
        <input type="text" maxlength="1" inputmode="numeric" required>
        <input type="text" maxlength="1" inputmode="numeric" required>
      </div>
      
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
                        <% session.removeAttribute("errorEmail"); %>
                        <% } %>
       
       
      <!-- Password -->
        
      <!-- lay emai de hien thi -->
      <%
          String email = (String) session.getAttribute("resetEmail");

          %>
          
          
        <div class="form-group">
            <input type="email" id="email" name="email" value="<%= email%>" readonly/>
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
  </div>

  <script>
    // Auto move cursor in OTP inputs
    const otpInputs = document.querySelectorAll(".otp-group input");
    otpInputs.forEach((input, index) => {
      input.addEventListener("input", () => {
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
  </script>
  
   <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/views/home/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/views/home/js/bootstrap.bundle.min.js"></script>
</body>
</html>