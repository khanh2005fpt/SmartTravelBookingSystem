<%-- 
    Document   : place-form
    Created on : Staff Place Form Page
    Author     : System
    Description: Create/Edit place form
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Place" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty place}">Chỉnh sửa Địa điểm</c:when>
            <c:otherwise>Thêm Địa điểm mới</c:otherwise>
        </c:choose>
        - Meland Travel
    </title>
    
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
           background: linear-gradient(180deg, #0077b6, #00b4d8);
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .breadcrumb {
            margin: 0;
            background: none;
            padding: 0;
        }
        
        .breadcrumb-item a {
            color: #00ACD4;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-item a:hover {
            color: #007CB9;
            text-decoration: underline;
        }
        
        .breadcrumb-item.active {
            color: #6c757d;
            font-weight: 600;
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        
        .form-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .form-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #333;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-content {
            padding: 30px;
        }
        
        .form-section {
            margin-bottom: 35px;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }
        
        .section-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #333;
            margin: 0 0 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-row.single {
            grid-template-columns: 1fr;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .required {
            color: #dc3545;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: white;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .form-control.is-invalid {
            border-color: #dc3545;
        }
        
        .form-control.is-invalid:focus {
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        .invalid-feedback {
            display: block;
            width: 100%;
            margin-top: 5px;
            font-size: 0.875em;
            color: #dc3545;
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .image-upload-section {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            background: white;
            transition: all 0.3s ease;
        }
        
        .image-upload-section:hover {
            border-color: #667eea;
            background: #f8f9fa;
        }
        
        .image-upload-section.dragover {
            border-color: #667eea;
            background: #e3f2fd;
        }
        
        .upload-icon {
            font-size: 3em;
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .upload-text {
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .file-input {
            display: none;
        }
        
        .upload-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .upload-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .image-preview {
            margin-top: 20px;
            text-align: center;
        }
        
        .preview-image {
            max-width: 300px;
            max-height: 200px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            object-fit: cover;
        }
        
        .remove-image {
            display: inline-block;
            margin-top: 10px;
            color: #dc3545;
            cursor: pointer;
            font-weight: 600;
        }
        
        .remove-image:hover {
            text-decoration: underline;
        }
        
        .form-actions {
            background: #f8f9fa;
            padding: 25px;
            border-top: 1px solid #dee2e6;
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 12px 25px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 1em;
            cursor: pointer;
        }
        
        .btn-primary {
              background: linear-gradient(180deg, #0077b6, #00b4d8);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .rating-input {
            display: flex;
            gap: 5px;
            align-items: center;
        }
        
        .rating-star {
            font-size: 1.5em;
            color: #dee2e6;
            cursor: pointer;
            transition: color 0.2s ease;
        }
        
        .rating-star.active,
        .rating-star:hover {
            color: #ffc107;
        }
        
        .rating-value {
            margin-left: 10px;
            font-weight: 600;
            color: #333;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-action {
                justify-content: center;
            }
        }
    </style>
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

    if (roleId != 1 && roleId != 4) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="places" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fa fa-map-marked-alt"></i>
                <c:choose>
                    <c:when test="${not empty place}">Chỉnh sửa Địa điểm</c:when>
                    <c:otherwise>Thêm Địa điểm mới</c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${not empty place}">Cập nhật thông tin địa điểm</c:when>
                    <c:otherwise>Tạo địa điểm du lịch mới</c:otherwise>
                </c:choose>
            </p>
        </div>

        <!-- Breadcrumb -->
        <div class="breadcrumb-nav">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/views/staff/index.jsp">
                            <i class="fa fa-home"></i> Trang chủ
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/places?action=list">
                            <i class="fa fa-map-marked-alt"></i> Quản lý Địa điểm
                        </a>
                    </li>
                    <li class="breadcrumb-item active">
                        <i class="fa fa-edit"></i>
                        <c:choose>
                            <c:when test="${not empty place}">Chỉnh sửa</c:when>
                            <c:otherwise>Thêm mới</c:otherwise>
                        </c:choose>
                    </li>
                </ol>
            </nav>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i class="fa fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errors}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-circle"></i> Vui lòng kiểm tra lại thông tin:
                <ul style="margin: 10px 0 0 20px;">
                    <c:forEach var="error" items="${errors}">
                        <li>${error}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- Place Form -->
        <form action="${pageContext.request.contextPath}/staff/places" 
              method="post" 
              enctype="multipart/form-data" 
              id="placeForm" 
              novalidate>
            
            <input type="hidden" name="action" value="${not empty place ? 'update' : 'create'}">
            <c:if test="${not empty place}">
                <input type="hidden" name="id" value="${place.placeId}">
            </c:if>
            
            <div class="form-container">
                <div class="form-header">
                    <h2 class="form-title">
                        <i class="fa fa-info-circle"></i>
                        <c:choose>
                            <c:when test="${not empty place}">Cập nhật thông tin địa điểm</c:when>
                            <c:otherwise>Thông tin địa điểm mới</c:otherwise>
                        </c:choose>
                    </h2>
                </div>

                <div class="form-content">
                    <!-- Basic Information -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-info-circle"></i> Thông tin cơ bản
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="placeName">Tên địa điểm <span class="required">*</span></label>
                                <input type="text" 
                                       class="form-control" 
                                       id="placeName" 
                                       name="placeName" 
                                       value="${place.placeName}"
                                       placeholder="Nhập tên địa điểm"
                                       required>
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="islandId">Đảo <span class="required">*</span></label>
                                <select class="form-control" id="islandId" name="islandId" required>
                                    <option value="">Chọn đảo</option>
                                    <c:forEach var="island" items="${islands}">
                                        <option value="${island.islandId}" ${place != null && place.islandId != null && place.islandId == island.islandId ? 'selected' : ''}>
                                            ${island.islandName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="location">Vị trí / Địa chỉ <span class="required">*</span></label>
                            <input type="text" 
                                   class="form-control" 
                                   id="location" 
                                   name="location" 
                                   value="${place.location}"
                                   placeholder="Nhập vị trí hoặc địa chỉ chi tiết"
                                   required>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>

                    <!-- Ticket Information -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-ticket-alt"></i> Thông tin vé
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="hasTicket">Có vé tham quan</label>
                                <div class="form-check">
                                    <input type="checkbox" 
                                           class="form-check-input" 
                                           id="hasTicket" 
                                           name="hasTicket" 
                                           value="true"
                                           ${place != null && place.hasTicket != null && place.hasTicket == true ? 'checked' : ''}
                                           onchange="toggleTicketPrice()">
                                    <label class="form-check-label" for="hasTicket">
                                        Địa điểm này có thu phí vé tham quan
                                    </label>
                                </div>
                            </div>
                            
                            <div class="form-group" id="ticketPriceGroup" style="${place != null && place.hasTicket != null && place.hasTicket == true ? '' : 'display: none;'}">
                                <label for="ticketPrice">Giá vé (₫)</label>
                                <input type="number" 
                                       class="form-control" 
                                       id="ticketPrice" 
                                       name="ticketPrice" 
                                       value="${place.ticketPrice}"
                                       placeholder="0"
                                       min="0"
                                       step="1000">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-align-left"></i> Mô tả
                        </h3>
                        
                        <div class="form-group">
                            <label for="description">Mô tả chi tiết</label>
                            <textarea class="form-control" 
                                      id="description" 
                                      name="description" 
                                      rows="5"
                                      placeholder="Nhập mô tả chi tiết về địa điểm...">${place.description}</textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>

                    <!-- Image Upload Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-image"></i> Hình ảnh địa điểm
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="placeImageFile" class="form-label">
                                    Tải lên hình ảnh địa điểm
                                </label>
                                <input type="file" 
                                       class="form-control" 
                                       id="placeImageFile" 
                                       name="placeImageFile" 
                                       accept="image/*"
                                       onchange="previewImage(this, 'placeImagePreview')">
                                <div class="form-text">Chọn file hình ảnh (JPG, PNG, GIF). Tối đa 10MB</div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Xem trước</label>
                                <div class="image-preview-container">
                                    <img id="placeImagePreview" 
                                         src="${place != null && place.placeImageUrl != null && !place.placeImageUrl.isEmpty() ? pageContext.request.contextPath.concat('/').concat(place.placeImageUrl) : ''}" 
                                         alt="Preview" 
                                         class="preview-image"
                                         style="display: ${place != null && place.placeImageUrl != null && !place.placeImageUrl.isEmpty() ? 'block' : 'none'};">
                                    <div id="noPlaceImageText" style="display: ${place != null && place.placeImageUrl != null && !place.placeImageUrl.isEmpty() ? 'none' : 'block'}; color: #6c757d; font-style: italic;">
                                        Chưa có hình ảnh
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Hidden field to store current image URL for edit mode -->
                        <c:if test="${place != null && place.placeImageUrl != null && !place.placeImageUrl.isEmpty()}">
                            <input type="hidden" name="currentImageUrl" value="${place.placeImageUrl}">
                        </c:if>
                    </div>

                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn-action btn-primary">
                        <i class="fa fa-save"></i>
                        <c:choose>
                            <c:when test="${not empty place}">Cập nhật</c:when>
                            <c:otherwise>Tạo địa điểm</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/staff/places?action=list" class="btn-action btn-secondary">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Ticket price toggle functionality
        function toggleTicketPrice() {
            const hasTicketCheckbox = document.getElementById('hasTicket');
            const ticketPriceGroup = document.getElementById('ticketPriceGroup');
            const ticketPriceInput = document.getElementById('ticketPrice');
            
            if (hasTicketCheckbox.checked) {
                ticketPriceGroup.style.display = 'block';
                ticketPriceInput.required = true;
            } else {
                ticketPriceGroup.style.display = 'none';
                ticketPriceInput.required = false;
                ticketPriceInput.value = '';
            }
        }

        // Form validation
        document.getElementById('placeForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Clear previous validation
            document.querySelectorAll('.form-control').forEach(input => {
                input.classList.remove('is-invalid');
            });
            
            // Validate required fields
            const requiredFields = [
                { id: 'placeName', message: 'Vui lòng nhập tên địa điểm' },
                { id: 'islandId', message: 'Vui lòng chọn đảo' },
                { id: 'location', message: 'Vui lòng nhập vị trí' }
            ];
            
            requiredFields.forEach(field => {
                const input = document.getElementById(field.id);
                if (!input.value.trim()) {
                    input.classList.add('is-invalid');
                    input.nextElementSibling.textContent = field.message;
                    isValid = false;
                }
            });
            
            // Validate ticket price if has ticket is checked
            const hasTicketCheckbox = document.getElementById('hasTicket');
            const ticketPriceInput = document.getElementById('ticketPrice');
            if (hasTicketCheckbox.checked) {
                if (!ticketPriceInput.value.trim() || isNaN(ticketPriceInput.value) || parseInt(ticketPriceInput.value) < 0) {
                    ticketPriceInput.classList.add('is-invalid');
                    ticketPriceInput.nextElementSibling.textContent = 'Vui lòng nhập giá vé hợp lệ';
                    isValid = false;
                }
            }
            
            if (!isValid) {
                e.preventDefault();
                // Scroll to first error
                const firstError = document.querySelector('.is-invalid');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });



        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Real-time validation
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                }
            });
            
            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid') && this.value.trim()) {
                    this.classList.remove('is-invalid');
                }
            });
        });

        // Image preview function
        function previewImage(input, previewId) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById(previewId);
                    const noImageText = document.getElementById('noPlaceImageText');
                    if (preview) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    if (noImageText) {
                        noImageText.style.display = 'none';
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>