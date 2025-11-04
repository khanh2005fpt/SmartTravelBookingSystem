<%-- 
    Document   : restaurant-form
    Created on : Staff Restaurant Form Page
    Author     : System
    Description: Create/Edit restaurant form
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Restaurant" %>
<%@ page import="model.Island" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty restaurant ? 'Thêm' : 'Chỉnh sửa'} Nhà hàng - Meland Travel</title>
    
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
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .form-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .form-title {
            font-size: 1.25em;
            font-weight: 600;
            color: #333;
            margin: 0;
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
            font-size: 1.1em;
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
            box-sizing: border-box;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .form-control.is-invalid {
            border-color: #dc3545;
        }
        
        .invalid-feedback {
            display: block;
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 5px;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        
        .image-upload-section {
            text-align: center;
            padding: 30px;
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            background: #fafafa;
            transition: all 0.3s ease;
        }
        
        .image-upload-section:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .image-preview {
            max-width: 100%;
            max-height: 300px;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .upload-placeholder {
            color: #6c757d;
            font-size: 1.1em;
            margin-bottom: 15px;
        }
        
        .upload-placeholder i {
            font-size: 3em;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        
        .file-input-wrapper {
            position: relative;
            display: inline-block;
        }
        
        .file-input {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        
        .file-input-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .file-input-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .form-actions {
            padding: 25px;
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn-action {
            padding: 12px 30px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 140px;
            justify-content: center;
            cursor: pointer;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #218838 0%, #1e7e34 100%);
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
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .rating-input {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .rating-stars {
            display: flex;
            gap: 5px;
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
            font-weight: 600;
            color: #333;
            min-width: 30px;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .form-content {
                padding: 20px;
            }
            
            .form-section {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-action {
                width: 100%;
                max-width: 200px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="restaurants" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fa fa-utensils"></i> 
                ${empty restaurant ? 'Thêm Nhà hàng Mới' : 'Chỉnh sửa Nhà hàng'}
            </h1>
            <p>${empty restaurant ? 'Tạo nhà hàng mới trong hệ thống' : 'Cập nhật thông tin nhà hàng'}</p>
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
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <!-- Restaurant Form -->
        <div class="form-container">
            <div class="form-header">
                <h3 class="form-title">
                    <i class="fa fa-edit"></i> 
                    ${empty restaurant ? 'Thông tin nhà hàng mới' : 'Chỉnh sửa thông tin nhà hàng'}
                </h3>
            </div>

            <form action="${pageContext.request.contextPath}/staff/restaurants" 
                  method="post" 
                  enctype="multipart/form-data" 
                  id="restaurantForm" 
                  novalidate>
                
                <input type="hidden" name="action" value="${empty restaurant ? 'create' : 'update'}">
                <c:if test="${not empty restaurant}">
                    <input type="hidden" name="id" value="${restaurant.restaurantId}">
                </c:if>

                <div class="form-content">
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-info-circle"></i> Thông tin cơ bản
                        </h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="restaurantName">Tên nhà hàng <span class="required">*</span></label>
                                <input type="text" 
                                       class="form-control" 
                                       id="restaurantName" 
                                       name="restaurantName" 
                                       value="${restaurant.restaurantName}"
                                       placeholder="Nhập tên nhà hàng"
                                       required>
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="cuisineType">Loại ẩm thực <span class="required">*</span></label>
                                <select class="form-control" id="cuisineType" name="cuisineType" required>
                                    <option value="">Chọn loại ẩm thực</option>
                                    <option value="Việt Nam" ${restaurant.cuisineType == 'Việt Nam' ? 'selected' : ''}>Việt Nam</option>
                                    <option value="Thái Lan" ${restaurant.cuisineType == 'Thái Lan' ? 'selected' : ''}>Thái Lan</option>
                                    <option value="Nhật Bản" ${restaurant.cuisineType == 'Nhật Bản' ? 'selected' : ''}>Nhật Bản</option>
                                    <option value="Hàn Quốc" ${restaurant.cuisineType == 'Hàn Quốc' ? 'selected' : ''}>Hàn Quốc</option>
                                    <option value="Trung Quốc" ${restaurant.cuisineType == 'Trung Quốc' ? 'selected' : ''}>Trung Quốc</option>
                                    <option value="Ý" ${restaurant.cuisineType == 'Ý' ? 'selected' : ''}>Ý</option>
                                    <option value="Pháp" ${restaurant.cuisineType == 'Pháp' ? 'selected' : ''}>Pháp</option>
                                    <option value="Hải sản" ${restaurant.cuisineType == 'Hải sản' ? 'selected' : ''}>Hải sản</option>
                                    <option value="Chay" ${restaurant.cuisineType == 'Chay' ? 'selected' : ''}>Chay</option>
                                    <option value="Quốc tế" ${restaurant.cuisineType == 'Quốc tế' ? 'selected' : ''}>Quốc tế</option>
                                    <option value="Khác" ${restaurant.cuisineType == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="rating">Đánh giá</label>
                                <div class="rating-input">
                                    <div class="rating-stars" id="ratingStars">
                                        <i class="fa fa-star rating-star" data-rating="1"></i>
                                        <i class="fa fa-star rating-star" data-rating="2"></i>
                                        <i class="fa fa-star rating-star" data-rating="3"></i>
                                        <i class="fa fa-star rating-star" data-rating="4"></i>
                                        <i class="fa fa-star rating-star" data-rating="5"></i>
                                    </div>
                                    <span class="rating-value" id="ratingValue">0</span>
                                    <input type="hidden" id="rating" name="rating" value="${restaurant.rating}">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="priceRange">Mức giá <span class="required">*</span></label>
                                <select class="form-control" id="priceRange" name="priceRange" required>
                                    <option value="">Chọn mức giá</option>
                                    <option value="Bình dân" ${restaurant.priceRange == 'Bình dân' ? 'selected' : ''}>Bình dân</option>
                                    <option value="Trung bình" ${restaurant.priceRange == 'Trung bình' ? 'selected' : ''}>Trung bình</option>
                                    <option value="Cao cấp" ${restaurant.priceRange == 'Cao cấp' ? 'selected' : ''}>Cao cấp</option>
                                    <option value="Sang trọng" ${restaurant.priceRange == 'Sang trọng' ? 'selected' : ''}>Sang trọng</option>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Location Information Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-map-marker-alt"></i> Thông tin vị trí
                        </h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="islandId">Đảo <span class="required">*</span></label>
                                <select class="form-control" id="islandId" name="islandId" required>
                                    <option value="">Chọn đảo</option>
                                    <c:forEach var="island" items="${islands}">
                                        <option value="${island.islandId}" ${restaurant.islandId == island.islandId ? 'selected' : ''}>
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
                                       value="${restaurant.address}"
                                       placeholder="Nhập địa chỉ nhà hàng">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-phone"></i> Thông tin liên hệ
                        </h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phoneNumber">Số điện thoại</label>
                                <input type="tel" 
                                       class="form-control" 
                                       id="phoneNumber" 
                                       name="phoneNumber" 
                                       value="${restaurant.phoneNumber}"
                                       placeholder="Nhập số điện thoại">
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="capacity">Sức chứa <span class="required">*</span></label>
                                <input type="number" 
                                       class="form-control" 
                                       id="capacity" 
                                       name="capacity" 
                                       value="${restaurant.capacity}"
                                       placeholder="Nhập sức chứa (số người)"
                                       min="1"
                                       required>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="openingHours">Giờ mở cửa</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="openingHours" 
                                       name="openingHours" 
                                       value="${restaurant.openingHours}"
                                       placeholder="Ví dụ: 08:00 - 22:00">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Description Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-align-left"></i> Mô tả nhà hàng
                        </h4>
                        
                        <div class="form-group">
                            <label for="description">Mô tả chi tiết</label>
                            <textarea class="form-control" 
                                      id="description" 
                                      name="description" 
                                      rows="5"
                                      placeholder="Nhập mô tả về nhà hàng, món ăn đặc trưng, không gian...">${restaurant.description}</textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="specialties">Món đặc sản</label>
                            <textarea class="form-control" 
                                      id="specialties" 
                                      name="specialties" 
                                      rows="3"
                                      placeholder="Nhập các món đặc sản của nhà hàng (ví dụ: Phở bò, Bún chả, Bánh mì...)">${restaurant.specialties}</textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>

                    <!-- Image Upload Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-image"></i> Hình ảnh nhà hàng
                        </h4>
                        
                        <div class="image-upload-section">
                            <c:choose>
                                <c:when test="${not empty restaurant.restaurantImageUrl}">
                                    <img src="${pageContext.request.contextPath}/${restaurant.restaurantImageUrl}" 
                                         alt="Restaurant Image" 
                                         class="image-preview" 
                                         id="imagePreview">
                                </c:when>
                                <c:otherwise>
                                    <div class="upload-placeholder" id="uploadPlaceholder">
                                        <i class="fa fa-cloud-upload-alt"></i>
                                        <p>Chọn hình ảnh nhà hàng</p>
                                        <small>Định dạng: JPG, PNG, GIF (Tối đa 5MB)</small>
                                    </div>
                                    <img src="#" alt="Preview" class="image-preview" id="imagePreview" style="display: none;">
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="file-input-wrapper">
                                <input type="file" 
                                       class="file-input" 
                                       id="restaurantImage" 
                                       name="restaurantImage" 
                                       accept="image/*"
                                       onchange="previewImage(this)">
                                <button type="button" class="file-input-button">
                                    <i class="fa fa-upload"></i> Chọn hình ảnh
                                </button>
                            </div>
                            
                            <c:if test="${not empty restaurant.restaurantImageUrl}">
                                <input type="hidden" name="currentImageUrl" value="${restaurant.restaurantImageUrl}">
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/staff/restaurants?action=list" class="btn-action btn-secondary">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn-action btn-primary">
                        <i class="fa fa-save"></i> 
                        ${empty restaurant ? 'Tạo nhà hàng' : 'Cập nhật'}
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Rating functionality
        const ratingStars = document.querySelectorAll('.rating-star');
        const ratingValue = document.getElementById('ratingValue');
        const ratingInput = document.getElementById('rating');
        
        // Initialize rating
        let currentRating = ${not empty restaurant.rating ? restaurant.rating : 0};
        updateRatingDisplay(currentRating);
        
        ratingStars.forEach(star => {
            star.addEventListener('click', function() {
                currentRating = parseInt(this.dataset.rating);
                updateRatingDisplay(currentRating);
                ratingInput.value = currentRating;
            });
            
            star.addEventListener('mouseover', function() {
                const hoverRating = parseInt(this.dataset.rating);
                updateRatingDisplay(hoverRating);
            });
        });
        
        document.getElementById('ratingStars').addEventListener('mouseleave', function() {
            updateRatingDisplay(currentRating);
        });
        
        function updateRatingDisplay(rating) {
            ratingStars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
            ratingValue.textContent = rating;
        }

        // Image preview functionality
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const placeholder = document.getElementById('uploadPlaceholder');
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    if (placeholder) {
                        placeholder.style.display = 'none';
                    }
                };
                
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Form validation
        document.getElementById('restaurantForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Clear previous validation
            document.querySelectorAll('.form-control').forEach(input => {
                input.classList.remove('is-invalid');
            });
            
            // Validate required fields
            const requiredFields = ['restaurantName', 'cuisineType', 'islandId', 'priceRange', 'capacity'];
            
            requiredFields.forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    field.nextElementSibling.textContent = 'Trường này là bắt buộc';
                    isValid = false;
                }
            });
            
            // Validate capacity
            const capacity = document.getElementById('capacity');
            if (capacity.value) {
                const capacityValue = parseInt(capacity.value);
                if (capacityValue <= 0) {
                    capacity.classList.add('is-invalid');
                    capacity.nextElementSibling.textContent = 'Sức chứa phải lớn hơn 0';
                    isValid = false;
                } else if (capacityValue > 1000) {
                    capacity.classList.add('is-invalid');
                    capacity.nextElementSibling.textContent = 'Sức chứa không được vượt quá 1000 người';
                    isValid = false;
                }
            }
            
            // Validate phone number format
            const phoneNumber = document.getElementById('phoneNumber');
            if (phoneNumber.value && !isValidPhone(phoneNumber.value)) {
                phoneNumber.classList.add('is-invalid');
                phoneNumber.nextElementSibling.textContent = 'Số điện thoại không hợp lệ';
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
        

        
        function isValidPhone(phone) {
            const phoneRegex = /^[0-9+\-\s()]{10,15}$/;
            return phoneRegex.test(phone);
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Price range validation
        document.getElementById('priceRange').addEventListener('change', function() {
            if (!this.value) {
                this.classList.add('is-invalid');
                this.nextElementSibling.textContent = 'Vui lòng chọn mức giá';
            } else {
                this.classList.remove('is-invalid');
                this.nextElementSibling.textContent = '';
            }
        });
    </script>
</body>
</html>