<%-- 
    Document   : add-activity-to-itinerary
    Created on : Staff Add Activity to Itinerary Page
    Author     : System
    Description: Add new activity to existing itinerary form
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm hoạt động - Meland Travel</title>
    
    <!-- Include common CSS -->
    <jsp:include page="../common/css.jsp" />
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 30px;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .page-header h1 {
            margin: 0;
            font-weight: 600;
        }
        
        .page-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }
        
        .breadcrumb-nav {
            background: white;
            padding: 15px 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .breadcrumb {
            margin: 0;
            background: none;
            padding: 0;
        }
        
        .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-item a:hover {
            color: #764ba2;
        }
        
        .breadcrumb-item.active {
            color: #6c757d;
            font-weight: 500;
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px 30px;
            border-bottom: none;
        }
        
        .form-header h4 {
            margin: 0;
            font-weight: 600;
            font-size: 1.5em;
        }
        
        .form-header small {
            opacity: 0.9;
            font-size: 0.9em;
        }
        
        .form-body {
            padding: 30px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,.25);
        }
        
        .required {
            color: #dc3545;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            border: none;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }
        
        .form-text {
            font-size: 0.875em;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .action-buttons {
            border-top: 1px solid #e9ecef;
            padding: 25px 30px;
            background: #f8f9fa;
        }
        
        .itinerary-info {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .itinerary-info h6 {
            color: #1976d2;
            margin: 0 0 5px 0;
            font-weight: 600;
        }
        
        .itinerary-info p {
            margin: 0;
            color: #424242;
            font-size: 0.9em;
        }
        
        .char-counter {
            font-size: 0.8em;
            color: #6c757d;
            text-align: right;
            margin-top: 5px;
        }
        
        .char-counter.warning {
            color: #fd7e14;
        }
        
        .char-counter.danger {
            color: #dc3545;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .form-body {
                padding: 20px;
            }
            
            .action-buttons {
                padding: 20px;
            }
        }
    </style>
</head>
    <%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }
if (currentUser != null) {
    int roleId = currentUser.getRoleId();

    if (roleId != 1 && roleId != 4) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>



<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp" />
    
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-plus-circle me-3"></i>Thêm hoạt động mới</h1>
            <p>Thêm hoạt động vào lịch trình tour</p>
        </div>
        
        <!-- Breadcrumb -->
        <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/tours">Quản lý Tour</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/tours?action=itinerary&id=${tour.tourId}">Lịch trình Tour</a></li>
                <li class="breadcrumb-item active">Thêm hoạt động</li>
            </ol>
        </nav>
        
        <!-- Display Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="success" scope="session" />
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session" />
        </c:if>
        
        <!-- Form Container -->
        <div class="form-container">
            <div class="form-header">
                <h4><i class="fas fa-calendar-plus me-2"></i>Thêm hoạt động mới</h4>
                <small>Điền thông tin hoạt động cần thêm vào lịch trình</small>
            </div>
            
            <div class="form-body">
                <!-- Itinerary Information -->
                <div class="itinerary-info">
                    <h6><i class="fas fa-info-circle me-2"></i>Thông tin lịch trình</h6>
                    <p><strong>Tour:</strong> ${tour.tourName}</p>
                    <p><strong>Ngày ${itinerary.dayNumber}:</strong> ${itinerary.title}</p>
                </div>
                
                <!-- Add Activity Form -->
                <form action="${pageContext.request.contextPath}/staff/tours" method="post" id="addActivityForm">
                    <input type="hidden" name="action" value="create-activity">
                    <input type="hidden" name="itineraryId" value="${itinerary.itineraryId}">
                    <input type="hidden" name="tourId" value="${tour.tourId}">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="activityOrder" class="form-label">
                                    Thứ tự hoạt động <span class="required">*</span>
                                </label>
                                <input type="number" class="form-control" id="activityOrder" name="activityOrder" 
                                       value="${nextOrder}" min="1" required>
                                <div class="form-text">Thứ tự của hoạt động trong ngày (bắt đầu từ 1)</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="activityTitle" class="form-label">
                            Tên hoạt động <span class="required">*</span>
                        </label>
                        <input type="text" class="form-control" id="activityTitle" name="activityTitle" 
                               maxlength="200" required>
                        <div class="char-counter" id="titleCounter">0/200 ký tự</div>
                        <div class="form-text">Tên ngắn gọn và mô tả hoạt động</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">
                            Mô tả chi tiết <span class="required">*</span>
                        </label>
                        <textarea class="form-control" id="description" name="description" rows="5" 
                                  maxlength="1000" required></textarea>
                        <div class="char-counter" id="descCounter">0/1000 ký tự</div>
                        <div class="form-text">Mô tả chi tiết về hoạt động, địa điểm, thời gian</div>
                    </div>
                </form>
            </div>
            
            <div class="action-buttons">
                <button type="submit" form="addActivityForm" class="btn btn-primary me-2">
                    <i class="fas fa-save me-2"></i>Thêm hoạt động
                </button>
                <a href="${pageContext.request.contextPath}/staff/tours?action=itinerary&id=${tour.tourId}" 
                   class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
            </div>
        </div>
    </div>
    
    <!-- Include common JS -->
    <jsp:include page="../common/script.jsp" />
    
    <script>
        $(document).ready(function() {
            // Character counter for activity title
            $('#activityTitle').on('input', function() {
                const current = $(this).val().length;
                const max = 200;
                const counter = $('#titleCounter');
                
                counter.text(current + '/' + max + ' ký tự');
                
                if (current > max * 0.9) {
                    counter.addClass('danger').removeClass('warning');
                } else if (current > max * 0.8) {
                    counter.addClass('warning').removeClass('danger');
                } else {
                    counter.removeClass('warning danger');
                }
            });
            
            // Character counter for description
            $('#description').on('input', function() {
                const current = $(this).val().length;
                const max = 1000;
                const counter = $('#descCounter');
                
                counter.text(current + '/' + max + ' ký tự');
                
                if (current > max * 0.9) {
                    counter.addClass('danger').removeClass('warning');
                } else if (current > max * 0.8) {
                    counter.addClass('warning').removeClass('danger');
                } else {
                    counter.removeClass('warning danger');
                }
            });
            
            // Form validation
            $('#addActivityForm').on('submit', function(e) {
                let isValid = true;
                let errorMessage = '';
                
                // Validate activity title
                const title = $('#activityTitle').val().trim();
                if (title.length === 0) {
                    isValid = false;
                    errorMessage += 'Tên hoạt động không được để trống.\n';
                } else if (title.length > 200) {
                    isValid = false;
                    errorMessage += 'Tên hoạt động không được vượt quá 200 ký tự.\n';
                }
                
                // Validate description
                const description = $('#description').val().trim();
                if (description.length === 0) {
                    isValid = false;
                    errorMessage += 'Mô tả hoạt động không được để trống.\n';
                } else if (description.length > 1000) {
                    isValid = false;
                    errorMessage += 'Mô tả hoạt động không được vượt quá 1000 ký tự.\n';
                }
                
                // Validate activity order
                const order = parseInt($('#activityOrder').val());
                if (isNaN(order) || order < 1) {
                    isValid = false;
                    errorMessage += 'Thứ tự hoạt động phải là số nguyên dương.\n';
                }
                
                if (!isValid) {
                    e.preventDefault();
                    alert('Vui lòng kiểm tra lại thông tin:\n\n' + errorMessage);
                    return false;
                }
                
                // Show loading state
                const submitBtn = $(this).find('button[type="submit"]');
                submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...');
                
                return true;
            });
            
            // Auto-focus on first input
            $('#activityTitle').focus();
        });
    </script>
</body>
</html>