<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Access Denied - SmartBooking</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
          <jsp:include page="../common/css.jsp" />
        <style>
            body {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .access-denied-container {
                max-width: 500px;
                width: 95%;
                background: #ffffff;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                padding: 40px 30px;
                text-align: center;
                animation: fadeIn 0.7s ease-in-out;
            }

            .icon-wrapper {
                width: 100px;
                height: 100px;
                background: #f8d7da;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 25px;
            }

            .icon-wrapper svg {
                width: 50px;
                height: 50px;
                stroke: #dc3545;
            }

            h1 {
                color: #dc3545;
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 20px;
            }

            .error-message {
                background: #fff3cd;
                border: 1px solid #ffeeba;
                border-radius: 10px;
                padding: 20px;
                color: #856404;
                font-size: 1rem;
                line-height: 1.5;
                margin-bottom: 25px;
                text-align: center;
                
            }

            .error-message strong {
                display: block;
                margin-bottom: 8px;
                font-size: 1.1rem;
            }

            .btn-back {
                display: inline-block;
                padding: 12px 28px;
                background-color: #0d6efd;
                color: #fff;
                font-weight: 600;
                border-radius: 8px;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .btn-back:hover {
                background-color: #0b5ed7;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(-20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @media (max-width: 576px) {
                .access-denied-container {
                    padding: 30px 20px;
                }

                h1 {
                    font-size: 1.6rem;
                }

                .icon-wrapper {
                    width: 80px;
                    height: 80px;
                }

                .icon-wrapper svg {
                    width: 40px;
                    height: 40px;
                }
            }
        </style>
    </head>
    <body>
        <div class="access-denied-container">
            <div class="icon-wrapper">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>
         
            <h1>Access Denied</h1>

            <div class="error-message text-center">
    <strong>
        <i class="bi bi-exclamation-triangle-fill" style="margin-right:5px; color:#856404;"></i>
        Hệ thống thông báo!
    </strong>
    <br>
    ${sessionScope.errorMess != null ? sessionScope.errorMess : "Vui lòng quay lại đăng nhập để tiếp tục."}
</div>

            <a href="${pageContext.request.contextPath}/views/account/login.jsp" class="btn-back">
           <i class="fa fa-arrow-left"></i> Quay lại đăng nhập

            </a>
        </div>
    </body>
</html>
