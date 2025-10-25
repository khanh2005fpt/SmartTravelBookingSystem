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
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
                        <a href="${pageContext.request.contextPath}/staff/dashboard">
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
                                <label for="placeType">Loại địa điểm <span class="required">*</span></label>
                                <select class="form-control" id="placeType" name="placeType" required>
                                    <option value="">Chọn loại địa điểm</option>
                                    <option value="Tourist" ${place.placeType == 'Tourist' ? 'selected' : ''}>Du lịch</option>
                                    <option value="Historical" ${place.placeType == 'Historical' ? 'selected' : ''}>Lịch sử</option>
                                    <option value="Natural" ${place.placeType == 'Natural' ? 'selected' : ''}>Thiên nhiên</option>
                                    <option value="Cultural" ${place.placeType == 'Cultural' ? 'selected' : ''}>Văn hóa</option>
                                    <option value="Entertainment" ${place.placeType == 'Entertainment' ? 'selected' : ''}>Giải trí</option>
                                    <option value="Religious" ${place.placeType == 'Religious' ? 'selected' : ''}>Tôn giáo</option>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="rating">Đánh giá</label>
                                <div class="rating-input">
                                    <input type="hidden" id="ratingValue" name="rating" value="${place.rating != null ? place.rating : 5}">
                                    <div id="ratingStars">
                                        <i class="fa fa-star rating-star" data-rating="1"></i>
                                        <i class="fa fa-star rating-star" data-rating="2"></i>
                                        <i class="fa fa-star rating-star" data-rating="3"></i>
                                        <i class="fa fa-star rating-star" data-rating="4"></i>
                                        <i class="fa fa-star rating-star" data-rating="5"></i>
                                    </div>
                                    <span class="rating-value" id="ratingDisplay">${place.rating != null ? place.rating : 5}/5</span>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="entryFee">Giá vé (₫)</label>
                                <input type="number" 
                                       class="form-control" 
                                       id="entryFee" 
                                       name="entryFee" 
                                       value="${place.entryFee}"
                                       placeholder="0"
                                       min="0"
                                       step="1000">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="openingHours">Giờ mở cửa</label>
                            <input type="text" 
                                   class="form-control" 
                                   id="openingHours" 
                                   name="openingHours" 
                                   value="${place.openingHours}"
                                   placeholder="Ví dụ: 8:00 - 17:00">
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>

                    <!-- Location Information -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-map-marker-alt"></i> Thông tin vị trí
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="islandId">Đảo <span class="required">*</span></label>
                                <select class="form-control" id="islandId" name="islandId" required>
                                    <option value="">Chọn đảo</option>
                                    <c:forEach var="island" items="${islands}">
                                        <option value="${island.islandId}" ${place.islandId == island.islandId ? 'selected' : ''}>
                                            ${island.islandName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="address">Địa chỉ</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="address" 
                                       name="address" 
                                       value="${place.address}"
                                       placeholder="Nhập địa chỉ chi tiết">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-phone"></i> Thông tin liên hệ
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">Số điện thoại</label>
                                <input type="tel" 
                                       class="form-control" 
                                       id="phone" 
                                       name="phone" 
                                       value="${place.phone}"
                                       placeholder="Nhập số điện thoại">
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       name="email" 
                                       value="${place.email}"
                                       placeholder="Nhập địa chỉ email">
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

                    <!-- Image Upload -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-image"></i> Hình ảnh
                        </h3>
                        
                        <div class="image-upload-section" id="imageUploadSection">
                            <div class="upload-icon">
                                <i class="fa fa-cloud-upload-alt"></i>
                            </div>
                            <div class="upload-text">
                                <p><strong>Kéo thả hình ảnh vào đây hoặc</strong></p>
                                <button type="button" class="upload-btn" onclick="document.getElementById('placeImage').click()">
                                    Chọn hình ảnh
                                </button>
                            </div>
                            <input type="file" 
                                   id="placeImage" 
                                   name="placeImage" 
                                   class="file-input" 
                                   accept="image/*">
                            <small class="text-muted">Định dạng: JPG, PNG, GIF. Kích thước tối đa: 5MB</small>
                        </div>
                        
                        <div class="image-preview" id="imagePreview" style="display: none;">
                            <img id="previewImg" src="" alt="Preview" class="preview-image">
                            <br>
                            <span class="remove-image" onclick="removeImage()">
                                <i class="fa fa-times"></i> Xóa hình ảnh
                            </span>
                        </div>
                        
                        <c:if test="${not empty place && not empty place.placeImageUrl}">
                            <div class="image-preview" id="currentImage">
                                <p><strong>Hình ảnh hiện tại:</strong></p>
                                <img src="${pageContext.request.contextPath}/${place.placeImageUrl}" 
                                     alt="${place.placeName}" 
                                     class="preview-image">
                                <br>
                                <span class="remove-image" onclick="removeCurrentImage()">
                                    <i class="fa fa-times"></i> Xóa hình ảnh hiện tại
                                </span>
                                <input type="hidden" id="removeCurrentImage" name="removeCurrentImage" value="false">
                            </div>
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
        // Rating functionality
        const ratingStars = document.querySelectorAll('.rating-star');
        const ratingValue = document.getElementById('ratingValue');
        const ratingDisplay = document.getElementById('ratingDisplay');
        
        let currentRating = ${place.rating != null ? place.rating : 5};
        
        function updateRatingDisplay(rating) {
            ratingStars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
            ratingValue.value = rating;
            ratingDisplay.textContent = rating + '/5';
        }
        
        ratingStars.forEach((star, index) => {
            star.addEventListener('click', () => {
                currentRating = index + 1;
                updateRatingDisplay(currentRating);
            });
            
            star.addEventListener('mouseover', () => {
                updateRatingDisplay(index + 1);
            });
        });
        
        document.getElementById('ratingStars').addEventListener('mouseleave', () => {
            updateRatingDisplay(currentRating);
        });
        
        // Initialize rating display
        updateRatingDisplay(currentRating);

        // Image upload functionality
        const imageUploadSection = document.getElementById('imageUploadSection');
        const placeImageInput = document.getElementById('placeImage');
        const imagePreview = document.getElementById('imagePreview');
        const previewImg = document.getElementById('previewImg');

        // Drag and drop functionality
        imageUploadSection.addEventListener('dragover', (e) => {
            e.preventDefault();
            imageUploadSection.classList.add('dragover');
        });

        imageUploadSection.addEventListener('dragleave', () => {
            imageUploadSection.classList.remove('dragover');
        });

        imageUploadSection.addEventListener('drop', (e) => {
            e.preventDefault();
            imageUploadSection.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                handleImageFile(files[0]);
            }
        });

        placeImageInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handleImageFile(e.target.files[0]);
            }
        });

        function handleImageFile(file) {
            if (!file.type.startsWith('image/')) {
                alert('Vui lòng chọn file hình ảnh!');
                return;
            }
            
            if (file.size > 5 * 1024 * 1024) {
                alert('Kích thước file không được vượt quá 5MB!');
                return;
            }

            const reader = new FileReader();
            reader.onload = (e) => {
                previewImg.src = e.target.result;
                imagePreview.style.display = 'block';
                
                // Hide current image if exists
                const currentImage = document.getElementById('currentImage');
                if (currentImage) {
                    currentImage.style.display = 'none';
                }
            };
            reader.readAsDataURL(file);
        }

        function removeImage() {
            placeImageInput.value = '';
            imagePreview.style.display = 'none';
            
            // Show current image if exists
            const currentImage = document.getElementById('currentImage');
            if (currentImage) {
                currentImage.style.display = 'block';
            }
        }

        function removeCurrentImage() {
            document.getElementById('removeCurrentImage').value = 'true';
            document.getElementById('currentImage').style.display = 'none';
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
                { id: 'placeType', message: 'Vui lòng chọn loại địa điểm' },
                { id: 'islandId', message: 'Vui lòng chọn đảo' }
            ];
            
            requiredFields.forEach(field => {
                const input = document.getElementById(field.id);
                if (!input.value.trim()) {
                    input.classList.add('is-invalid');
                    input.nextElementSibling.textContent = field.message;
                    isValid = false;
                }
            });
            
            // Validate email format
            const emailInput = document.getElementById('email');
            if (emailInput.value && !isValidEmail(emailInput.value)) {
                emailInput.classList.add('is-invalid');
                emailInput.nextElementSibling.textContent = 'Định dạng email không hợp lệ';
                isValid = false;
            }
            
            // Validate phone format
            const phoneInput = document.getElementById('phone');
            if (phoneInput.value && !isValidPhone(phoneInput.value)) {
                phoneInput.classList.add('is-invalid');
                phoneInput.nextElementSibling.textContent = 'Số điện thoại không hợp lệ';
                isValid = false;
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

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function isValidPhone(phone) {
            const phoneRegex = /^[0-9+\-\s()]{10,15}$/;
            return phoneRegex.test(phone);
        }

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
    </script>
</body>
</html>