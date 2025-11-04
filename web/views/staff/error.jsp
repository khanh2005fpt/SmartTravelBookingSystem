<%-- 
    Document   : error
    Created on : Staff Error Page
    Author     : System
    Description: Error handling page for staff section
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Meland Travel Staff</title>
    
    <!-- Include common CSS -->
    <jsp:include page="../common/css.jsp" />
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
        }
        
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            padding: 50px;
            text-align: center;
            max-width: 600px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .error-icon {
            font-size: 6em;
            margin-bottom: 30px;
            color: #dc3545;
            animation: pulse 2s infinite;
        }
        
        .error-code {
            font-size: 4em;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        
        .error-title {
            font-size: 2em;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 1.1em;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: left;
            border-left: 4px solid #dc3545;
        }
        
        .error-details h5 {
            color: #333;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .error-details p {
            color: #666;
            margin: 5px 0;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 140px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary-action {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-secondary-action {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary-action:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .btn-warning-action {
            background: #ffc107;
            color: #212529;
        }
        
        .btn-warning-action:hover {
            background: #e0a800;
            color: #212529;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .error-suggestions {
            background: #e7f3ff;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #007bff;
        }
        
        .error-suggestions h5 {
            color: #007bff;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .error-suggestions ul {
            text-align: left;
            color: #333;
            margin: 0;
            padding-left: 20px;
        }
        
        .error-suggestions li {
            margin-bottom: 8px;
        }
        
        .error-time {
            color: #999;
            font-size: 0.9em;
            margin-top: 20px;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 30px 20px;
                margin: 10px;
            }
            
            .error-icon {
                font-size: 4em;
            }
            
            .error-code {
                font-size: 3em;
            }
            
            .error-title {
                font-size: 1.5em;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-action {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <!-- Determine error type and display appropriate content -->
        <c:choose>
            <c:when test="${pageContext.errorData.statusCode == 404}">
                <div class="error-icon">
                    <i class="fa fa-search"></i>
                </div>
                <div class="error-code">404</div>
                <h1 class="error-title">Không tìm thấy trang</h1>
                <p class="error-message">
                    Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.
                </p>
            </c:when>
            
            <c:when test="${pageContext.errorData.statusCode == 403}">
                <div class="error-icon">
                    <i class="fa fa-lock"></i>
                </div>
                <div class="error-code">403</div>
                <h1 class="error-title">Truy cập bị từ chối</h1>
                <p class="error-message">
                    Bạn không có quyền truy cập vào trang này.
                </p>
            </c:when>
            
            <c:when test="${pageContext.errorData.statusCode == 500}">
                <div class="error-icon">
                    <i class="fa fa-exclamation-triangle"></i>
                </div>
                <div class="error-code">500</div>
                <h1 class="error-title">Lỗi máy chủ</h1>
                <p class="error-message">
                    Đã xảy ra lỗi trong quá trình xử lý yêu cầu của bạn.
                </p>
            </c:when>
            
            <c:otherwise>
                <div class="error-icon">
                    <i class="fa fa-exclamation-circle"></i>
                </div>
                <div class="error-code">
                    ${pageContext.errorData.statusCode != null ? pageContext.errorData.statusCode : 'ERROR'}
                </div>
                <h1 class="error-title">Đã xảy ra lỗi</h1>
                <p class="error-message">
                    ${not empty errorMessage ? errorMessage : 'Một lỗi không xác định đã xảy ra.'}
                </p>
            </c:otherwise>
        </c:choose>

        <!-- Error Details (only show in development mode) -->
        <c:if test="${param.debug == 'true' || pageContext.errorData != null}">
            <div class="error-details">
                <h5><i class="fa fa-info-circle"></i> Chi tiết lỗi</h5>
                <c:if test="${pageContext.errorData.statusCode != null}">
                    <p><strong>Mã lỗi:</strong> ${pageContext.errorData.statusCode}</p>
                </c:if>
                <c:if test="${pageContext.errorData.requestURI != null}">
                    <p><strong>URL:</strong> ${pageContext.errorData.requestURI}</p>
                </c:if>
                <c:if test="${pageContext.errorData.servletName != null}">
                    <p><strong>Servlet:</strong> ${pageContext.errorData.servletName}</p>
                </c:if>
                <c:if test="${pageContext.exception != null}">
                    <p><strong>Exception:</strong> ${pageContext.exception.class.simpleName}</p>
                    <p><strong>Message:</strong> ${pageContext.exception.message}</p>
                </c:if>
            </div>
        </c:if>

        <!-- Error Suggestions -->
        <div class="error-suggestions">
            <h5><i class="fa fa-lightbulb"></i> Gợi ý giải quyết</h5>
            <ul>
                <c:choose>
                    <c:when test="${pageContext.errorData.statusCode == 404}">
                        <li>Kiểm tra lại URL bạn đã nhập</li>
                        <li>Sử dụng menu điều hướng để tìm trang cần thiết</li>
                        <li>Quay lại trang chủ và tìm kiếm từ đó</li>
                    </c:when>
                    <c:when test="${pageContext.errorData.statusCode == 403}">
                        <li>Đăng nhập với tài khoản có quyền phù hợp</li>
                        <li>Liên hệ quản trị viên để được cấp quyền</li>
                        <li>Kiểm tra lại vai trò của tài khoản</li>
                    </c:when>
                    <c:when test="${pageContext.errorData.statusCode == 500}">
                        <li>Thử lại sau vài phút</li>
                        <li>Kiểm tra kết nối mạng</li>
                        <li>Liên hệ bộ phận kỹ thuật nếu lỗi tiếp tục</li>
                    </c:when>
                    <c:otherwise>
                        <li>Làm mới trang và thử lại</li>
                        <li>Kiểm tra kết nối internet</li>
                        <li>Liên hệ hỗ trợ kỹ thuật nếu cần</li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="javascript:history.back()" class="btn-action btn-secondary-action">
                <i class="fa fa-arrow-left"></i> Quay lại
            </a>
            
            <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn-action btn-primary-action">
                <i class="fa fa-home"></i> Trang chủ
            </a>
            
            <a href="javascript:location.reload()" class="btn-action btn-warning-action">
                <i class="fa fa-refresh"></i> Thử lại
            </a>
        </div>

        <!-- Error Time -->
        <div class="error-time">
            <i class="fa fa-clock"></i> 
            Thời gian: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss"/>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        $(document).ready(function() {
            // Add some interactive effects
            $('.error-icon').hover(
                function() {
                    $(this).addClass('fa-spin');
                },
                function() {
                    $(this).removeClass('fa-spin');
                }
            );
            
            // Auto-redirect for certain errors (optional)
            <c:if test="${param.autoRedirect == 'true'}">
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/staff/dashboard';
                }, 10000); // Redirect after 10 seconds
                
                // Show countdown
                let countdown = 10;
                const countdownElement = $('<div class="error-time mt-3"><i class="fa fa-clock"></i> Tự động chuyển hướng sau <span id="countdown">10</span> giây</div>');
                $('.error-time').after(countdownElement);
                
                const timer = setInterval(function() {
                    countdown--;
                    $('#countdown').text(countdown);
                    if (countdown <= 0) {
                        clearInterval(timer);
                    }
                }, 1000);
            </c:if>
            
            // Log error for analytics (if needed)
            if (typeof gtag !== 'undefined') {
                gtag('event', 'exception', {
                    'description': 'Error ${pageContext.errorData.statusCode != null ? pageContext.errorData.statusCode : "Unknown"}',
                    'fatal': false
                });
            }
        });
    </script>
</body>
</html>