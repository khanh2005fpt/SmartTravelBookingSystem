<%-- 
    Document   : edit-activity
    Created on : Staff Edit Activity Page
    Author     : System
    Description: Edit tour activity form
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hoạt động - Meland Travel</title>
    
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
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="tours" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-edit"></i> Chỉnh sửa hoạt động</h1>
            <p>Cập nhật thông tin hoạt động trong lịch trình tour</p>
        </div>

        <!-- Breadcrumb -->
        <div class="breadcrumb-nav">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/dashboard">
                            <i class="fa fa-home"></i> Trang chủ
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/tours">
                            <i class="fa fa-map"></i> Quản lý Tour
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/tours?action=itinerary&id=${tour.tourId}">
                            <i class="fa fa-list"></i> Lịch trình Tour
                        </a>
                    </li>
                    <li class="breadcrumb-item active">
                        <i class="fa fa-edit"></i> Chỉnh sửa hoạt động
                    </li>
                </ol>
            </nav>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa fa-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa fa-check-circle"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Form Container -->
        <div class="form-container">
            <div class="form-header">
                <h4>
                    <i class="fa fa-edit"></i> Chỉnh sửa hoạt động
                </h4>
                <small>Tour: <c:out value="${tour.tourName}"/></small>
            </div>
                
            <div class="form-body">
                <!-- Edit Form -->
                <form action="${pageContext.request.contextPath}/staff/tours" method="post" id="editActivityForm">
                    <input type="hidden" name="action" value="update-activity">
                    <input type="hidden" name="activityId" value="${activity.activityId}">
                    <input type="hidden" name="tourId" value="${tour.tourId}">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label for="activityTitle" class="form-label">
                                    <i class="fa fa-tag"></i> Tên hoạt động <span class="required">*</span>
                                </label>
                                <input type="text" class="form-control" id="activityTitle" 
                                       name="activityTitle" value="<c:out value='${activity.activityTitle}'/>"
                                       required maxlength="255" placeholder="Nhập tên hoạt động...">
                                <div class="form-text">
                                    <i class="fa fa-info-circle"></i> Nhập tên hoạt động (tối đa 255 ký tự)
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-4">
                                <label for="activityOrder" class="form-label">
                                    <i class="fa fa-sort-numeric-up"></i> Thứ tự <span class="required">*</span>
                                </label>
                                <input type="number" class="form-control" id="activityOrder" 
                                       name="activityOrder" value="${activity.activityOrder}" 
                                       required min="1" max="100" placeholder="1">
                                <div class="form-text">
                                    <i class="fa fa-info-circle"></i> Thứ tự hoạt động trong ngày (1-100)
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="activityDescription" class="form-label">
                            <i class="fa fa-align-left"></i> Mô tả hoạt động
                        </label>
                        <textarea class="form-control" id="activityDescription" 
                                  name="description" rows="6" 
                                  maxlength="1000" placeholder="Nhập mô tả chi tiết về hoạt động..."><c:out value="${activity.description}"/></textarea>
                        <div class="form-text">
                            <i class="fa fa-info-circle"></i> Mô tả chi tiết về hoạt động (tối đa 1000 ký tự)
                        </div>
                    </div>
                </form>
            </div>

            <div class="action-buttons">
                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/staff/tours?action=itinerary&id=${tour.tourId}" 
                       class="btn btn-secondary">
                        <i class="fa fa-arrow-left"></i> Quay lại lịch trình
                    </a>
                    
                    <div class="d-flex gap-2">
                        <button type="reset" class="btn btn-outline-secondary" form="editActivityForm">
                            <i class="fa fa-undo"></i> Đặt lại
                        </button>
                        <button type="submit" class="btn btn-primary" form="editActivityForm">
                            <i class="fa fa-save"></i> Cập nhật hoạt động
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include common JS -->
    <jsp:include page="../common/script.jsp" />
    
    <!-- Form Validation and Enhancement -->
    <script>
        $(document).ready(function() {
            // Form validation
            $('#editActivityForm').on('submit', function(e) {
                const title = $('#activityTitle').val().trim();
                const order = $('#activityOrder').val();
                
                if (!title) {
                    e.preventDefault();
                    showAlert('danger', 'Vui lòng nhập tên hoạt động!');
                    $('#activityTitle').focus();
                    return false;
                }
                
                if (!order || order < 1 || order > 100) {
                    e.preventDefault();
                    showAlert('danger', 'Vui lòng nhập thứ tự hợp lệ (1-100)!');
                    $('#activityOrder').focus();
                    return false;
                }
                
                // Show loading state
                const submitBtn = $(this).find('button[type="submit"]');
                submitBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Đang cập nhật...');
                
                return true;
            });
            
            // Character counter for description
            $('#activityDescription').on('input', function() {
                const maxLength = 1000;
                const currentLength = $(this).val().length;
                const remaining = maxLength - currentLength;
                
                let counterHtml = `<i class="fa fa-info-circle"></i> Mô tả chi tiết về hoạt động (${remaining} ký tự còn lại)`;
                if (remaining < 100) {
                    counterHtml = `<i class="fa fa-exclamation-triangle text-warning"></i> Mô tả chi tiết về hoạt động (${remaining} ký tự còn lại)`;
                }
                if (remaining < 0) {
                    counterHtml = `<i class="fa fa-times-circle text-danger"></i> Vượt quá giới hạn ${Math.abs(remaining)} ký tự!`;
                }
                
                $(this).siblings('.form-text').html(counterHtml);
            });
            
            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
            
            // Focus on first input
            $('#activityTitle').focus();
        });
        
        // Helper function to show alerts
        function showAlert(type, message) {
            const iconClass = type === 'success' ? 'check-circle' : 'exclamation-triangle';
            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    <i class="fa fa-${iconClass}"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            // Remove existing alerts
            $('.alert').remove();
            
            // Add new alert before form container
            $('.form-container').before(alertHtml);
            
            // Auto-dismiss after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
        }
    </script>
</body>
</html>