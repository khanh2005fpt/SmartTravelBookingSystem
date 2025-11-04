<%-- 
    Document   : edit-itinerary
    Created on : Staff Edit Itinerary Page
    Author     : System
    Description: Edit tour itinerary form
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa lịch trình - Meland Travel</title>
    
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
        
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-right: 10px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 8px;
        }
        
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        
        .tour-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        
        .tour-info h3 {
            margin: 0 0 10px 0;
            color: #333;
        }
        
        .tour-info p {
            margin: 5px 0;
            color: #666;
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp" />
    
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-edit"></i> Chỉnh sửa lịch trình</h1>
            <p>Cập nhật thông tin lịch trình tour</p>
        </div>
        
        <!-- Display Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>
        
        <!-- Tour Information -->
        <c:if test="${not empty tour}">
            <div class="tour-info">
                <h3><i class="fas fa-map-marked-alt"></i> Thông tin tour</h3>
                <p><strong>Tên tour:</strong> <c:out value="${tour.tourName}"/></p>
                <p><strong>Mã tour:</strong> <c:out value="${tour.tourId}"/></p>
            </div>
        </c:if>
        
        <!-- Edit Form -->
        <div class="form-container">
            <h2><i class="fas fa-calendar-day"></i> Thông tin lịch trình</h2>
            
            <form action="${pageContext.request.contextPath}/staff/tours" method="post" id="editItineraryForm">
                <input type="hidden" name="action" value="update-itinerary">
                <input type="hidden" name="itineraryId" value="${itinerary.itineraryId}">
                <input type="hidden" name="tourId" value="${itinerary.tourId}">
                
                <div class="form-group">
                    <label for="dayNumber">
                        <i class="fas fa-calendar-alt"></i> Ngày thứ <span class="text-danger">*</span>
                    </label>
                    <input type="number" 
                           class="form-control" 
                           id="dayNumber" 
                           name="dayNumber" 
                           value="${itinerary.dayNumber}"
                           min="1" 
                           max="30"
                           required>
                    <small class="form-text text-muted">Nhập số ngày trong lịch trình (1-30)</small>
                </div>
                
                <div class="form-group">
                    <label for="title">
                        <i class="fas fa-heading"></i> Tiêu đề ngày <span class="text-danger">*</span>
                    </label>
                    <input type="text" 
                           class="form-control" 
                           id="title" 
                           name="title" 
                           value="<c:out value='${itinerary.title}'/>"
                           maxlength="200" 
                           required>
                    <small class="form-text text-muted">Nhập tiêu đề mô tả cho ngày này (tối đa 200 ký tự)</small>
                    <div class="character-count">
                        <span id="titleCount">0</span>/200 ký tự
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Cập nhật lịch trình
                    </button>
                    <a href="${pageContext.request.contextPath}/staff/tours?action=itinerary&id=${itinerary.tourId}" 
                       class="btn btn-secondary">
                        <i class="fas fa-times"></i> Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Include common JS -->
    <jsp:include page="../common/script.jsp" />
    
    <script>
        $(document).ready(function() {
            // Character counter for title
            const titleInput = $('#title');
            const titleCount = $('#titleCount');
            
            function updateTitleCount() {
                const length = titleInput.val().length;
                titleCount.text(length);
                
                if (length > 180) {
                    titleCount.css('color', '#dc3545');
                } else if (length > 150) {
                    titleCount.css('color', '#ffc107');
                } else {
                    titleCount.css('color', '#28a745');
                }
            }
            
            titleInput.on('input', updateTitleCount);
            updateTitleCount(); // Initial count
            
            // Form validation
            $('#editItineraryForm').on('submit', function(e) {
                const dayNumber = parseInt($('#dayNumber').val());
                const title = $('#title').val().trim();
                
                if (dayNumber < 1 || dayNumber > 30) {
                    e.preventDefault();
                    alert('Số ngày phải từ 1 đến 30');
                    $('#dayNumber').focus();
                    return false;
                }
                
                if (title.length === 0) {
                    e.preventDefault();
                    alert('Tiêu đề ngày không được để trống');
                    $('#title').focus();
                    return false;
                }
                
                if (title.length > 200) {
                    e.preventDefault();
                    alert('Tiêu đề ngày không được vượt quá 200 ký tự');
                    $('#title').focus();
                    return false;
                }
                
                // Show loading state
                const submitBtn = $(this).find('button[type="submit"]');
                submitBtn.prop('disabled', true);
                submitBtn.html('<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...');
            });
            
            // Auto-focus on first input
            $('#dayNumber').focus();
        });
    </script>
</body>
</html>