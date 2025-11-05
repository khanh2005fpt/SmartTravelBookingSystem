<%-- 
    Document   : hotel-form
    Created on : Staff Hotel Form Page
    Author     : System
    Description: Form for creating and editing hotels
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Hotel" %>
<%@ page import="model.Island" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<<<<<<< HEAD
<%@ page import="model.User" %>
=======

>>>>>>> ba008d48be94080198e049925e83a146b0a834e3
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${hotel != null ? 'Chỉnh sửa Khách sạn' : 'Tạo Khách sạn mới'} - Meland Travel</title>
    
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
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section h4 {
            color: #333;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        
        .required {
            color: #dc3545;
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
        
        .form-text {
            color: #6c757d;
            font-size: 0.875em;
            margin-top: 5px;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        
        .btn-group-form {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
        }
        
        .btn-form {
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 120px;
        }
        
        .btn-primary-form {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary-form:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-secondary-form {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary-form:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .input-group {
            position: relative;
        }
        
        .input-group-text {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-right: none;
            border-radius: 10px 0 0 10px;
            padding: 12px 15px;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }
        
        .input-group .form-control:focus {
            border-left: 2px solid #667eea;
        }
        
        .star-rating {
            display: flex;
            gap: 5px;
            align-items: center;
        }
        
        .star-rating input[type="radio"] {
            display: none;
        }
        
        .star-rating label {
            font-size: 1.5em;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .star-rating label:hover,
        .star-rating label.active {
            color: #ffc107;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .form-container {
                padding: 25px;
            }
            
            .btn-group-form {
                flex-direction: column;
            }
            
            .btn-form {
                width: 100%;
            }
        }
    </style>
</head>
<<<<<<< HEAD
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
=======
>>>>>>> ba008d48be94080198e049925e83a146b0a834e3
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="hotels" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fa ${hotel != null ? 'fa-edit' : 'fa-plus'}"></i> 
                ${hotel != null ? 'Chỉnh sửa Khách sạn' : 'Tạo Khách sạn mới'}
            </h1>
            <p>${hotel != null ? 'Cập nhật thông tin khách sạn' : 'Thêm khách sạn mới vào hệ thống'}</p>
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

        <!-- Form Container -->
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/staff/hotels" method="post" id="hotelForm" enctype="multipart/form-data" novalidate>
                <input type="hidden" name="action" value="${hotel != null ? 'update' : 'create'}">
                <c:if test="${hotel != null}">
                    <input type="hidden" name="id" value="${hotel.hotelId}">
                </c:if>

                <!-- Basic Information Section -->
                <div class="form-section">
                    <h4><i class="fa fa-info-circle"></i> Thông tin cơ bản</h4>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label for="hotelName" class="form-label">
                                    Tên Khách sạn <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control ${not empty errors.hotelName ? 'is-invalid' : ''}" 
                                       id="hotelName" 
                                       name="hotelName" 
                                       value="${hotel != null ? hotel.hotelName : param.hotelName}"
                                       placeholder="Nhập tên khách sạn..."
                                       maxlength="255"
                                       required>
                                <c:if test="${not empty errors.hotelName}">
                                    <div class="invalid-feedback">${errors.hotelName}</div>
                                </c:if>
                                <div class="form-text">Tối đa 255 ký tự</div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="islandId" class="form-label">
                                    Đảo <span class="required">*</span>
                                </label>
                                <select class="form-control ${not empty errors.islandId ? 'is-invalid' : ''}" 
                                        id="islandId" 
                                        name="islandId" 
                                        required>
                                    <option value="">Chọn đảo...</option>
                                    <c:forEach var="island" items="${islands}">
                                        <option value="${island.islandId}" 
                                                ${(hotel != null && hotel.islandId != null && hotel.islandId == island.islandId) || (param.islandId != null && param.islandId == island.islandId) ? 'selected' : ''}>
                                            ${island.islandName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty errors.islandId}">
                                    <div class="invalid-feedback">${errors.islandId}</div>
                                </c:if>
                            </div>
                        </div>
                    </div>



                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="roomType" class="form-label">
                                    Loại phòng
                                </label>
                                <select class="form-control ${not empty errors.roomType ? 'is-invalid' : ''}" id="roomType" name="roomType">
                                    <option value="">Chọn loại phòng...</option>
                                    <option value="Tiêu chuẩn" ${(hotel != null && hotel.roomType == 'Tiêu chuẩn') || param.roomType == 'Tiêu chuẩn' ? 'selected' : ''}>Tiêu chuẩn</option>
                                    <option value="Cao cấp" ${(hotel != null && hotel.roomType == 'Cao cấp') || param.roomType == 'Cao cấp' ? 'selected' : ''}>Cao cấp</option>
                                    <option value="Hạng sang" ${(hotel != null && hotel.roomType == 'Hạng sang') || param.roomType == 'Hạng sang' ? 'selected' : ''}>Hạng sang</option>
                                    <option value="Gia đình" ${(hotel != null && hotel.roomType == 'Gia đình') || param.roomType == 'Gia đình' ? 'selected' : ''}>Gia đình</option>
                                </select>
                                <c:if test="${not empty errors.roomType}">
                                    <div class="invalid-feedback">${errors.roomType}</div>
                                </c:if>
                                <div class="form-text">Loại phòng chính của khách sạn</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="countryName" class="form-label">
                                    Quốc gia
                                </label>
                                <input type="text" 
                                       class="form-control ${not empty errors.countryName ? 'is-invalid' : ''}" 
                                       id="countryName" 
                                       name="countryName" 
                                       value="${hotel != null ? hotel.countryName : param.countryName}"
                                       placeholder="Nhập tên quốc gia..."
                                       maxlength="100">
                                <c:if test="${not empty errors.countryName}">
                                    <div class="invalid-feedback">${errors.countryName}</div>
                                </c:if>
                                <div class="form-text">Quốc gia nơi khách sạn tọa lạc</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Rating Section -->
                <div class="form-section">
                    <h4><i class="fa fa-star"></i> Đánh giá và Xếp hạng</h4>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="rating" class="form-label">
                                    Đánh giá (1-5)
                                </label>
                                <input type="number" 
                                       class="form-control ${not empty errors.rating ? 'is-invalid' : ''}" 
                                       id="rating" 
                                       name="rating" 
                                       value="${hotel != null ? hotel.rating : param.rating}"
                                       placeholder="0.0"
                                       min="0"
                                       max="5"
                                       step="0.1">
                                <c:if test="${not empty errors.rating}">
                                    <div class="invalid-feedback">${errors.rating}</div>
                                </c:if>
                                <div class="form-text">Đánh giá từ 0 đến 5 sao</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    Xếp hạng sao
                                </label>
                                <div class="star-rating ${not empty errors.starRating ? 'is-invalid' : ''}">
                                    <c:forEach begin="1" end="5" var="star">
                                        <input type="radio" 
                                               id="star${star}" 
                                               name="starRating" 
                                               value="${star}"
                                               ${(hotel != null && hotel.rating != null && hotel.rating >= star && hotel.rating < star + 1) || param.starRating == star ? 'checked' : ''}>
                                        <label for="star${star}" class="fa fa-star"></label>
                                    </c:forEach>
                                </div>
                                <c:if test="${not empty errors.starRating}">
                                    <div class="invalid-feedback">${errors.starRating}</div>
                                </c:if>
                                <div class="form-text">Xếp hạng sao của khách sạn (1-5 sao)</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contact Information Section -->
                <div class="form-section">
                    <h4><i class="fa fa-phone"></i> Thông tin liên hệ</h4>
                    
                    <div class="row">

                </div>

                <!-- Image Upload Section -->
                <div class="form-section">
                    <h4><i class="fa fa-image"></i> Hình ảnh khách sạn</h4>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="hotelImageFile" class="form-label">
                                    Tải lên hình ảnh khách sạn
                                </label>
                                <input type="file" 
                                       class="form-control ${not empty errors.hotelImageUrl ? 'is-invalid' : ''}" 
                                       id="hotelImageFile" 
                                       name="hotelImageFile" 
                                       accept="image/*"
                                       onchange="previewImage(this)">
                                <c:if test="${not empty errors.hotelImageUrl}">
                                    <div class="invalid-feedback">${errors.hotelImageUrl}</div>
                                </c:if>
                                <div class="form-text">Chọn file hình ảnh (JPG, PNG, GIF). Tối đa 5MB</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Xem trước</label>
                                <div class="image-preview-container">
                                    <img id="imagePreview" 
                                         src="${hotel != null && hotel.hotelImageUrl != null ? pageContext.request.contextPath.concat('/').concat(hotel.hotelImageUrl) : ''}" 
                                         alt="Preview" 
                                         style="max-width: 100%; max-height: 200px; display: ${hotel != null && hotel.hotelImageUrl != null ? 'block' : 'none'}; border: 1px solid #ddd; border-radius: 4px;">
                                    <div id="noImageText" style="display: ${hotel != null && hotel.hotelImageUrl != null ? 'none' : 'block'}; color: #6c757d; font-style: italic;">
                                        Chưa có hình ảnh
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hidden field to store current image URL for edit mode -->
                    <c:if test="${hotel != null && hotel.hotelImageUrl != null}">
                        <input type="hidden" name="currentImageUrl" value="${hotel.hotelImageUrl}">
                    </c:if>
                </div>

                <!-- Form Actions -->
                <div class="btn-group-form">
                    <a href="${pageContext.request.contextPath}/staff/hotels?action=list" 
                       class="btn-form btn-secondary-form">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn-form btn-primary-form">
                        <i class="fa ${hotel != null ? 'fa-save' : 'fa-plus'}"></i> 
                        ${hotel != null ? 'Cập nhật' : 'Tạo Khách sạn'}
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>

        $(document).ready(function() {
            // Star rating functionality
            $('.star-rating label').on('click', function() {
                const rating = $(this).prev('input').val();
                $('.star-rating label').removeClass('active');
                $('.star-rating label').each(function(index) {
                    if (index < rating) {
                        $(this).addClass('active');
                    }
                });
            });
            
            // Initialize star rating display
            const currentRating = $('input[name="starRating"]:checked').val();
            if (currentRating) {
                $('.star-rating label').each(function(index) {
                    if (index < currentRating) {
                        $(this).addClass('active');
                    }
                });
            }
            
            // Form validation
            $('#hotelForm').on('submit', function(e) {
                let isValid = true;
                
                // Clear previous validation states
                $('.form-control').removeClass('is-invalid');
                $('.invalid-feedback').remove();
                
                // Validate hotel name
                const hotelName = $('#hotelName').val().trim();
                if (!hotelName) {
                    showFieldError('#hotelName', 'Tên khách sạn là bắt buộc');
                    isValid = false;
                } else if (hotelName.length > 255) {
                    showFieldError('#hotelName', 'Tên khách sạn không được vượt quá 255 ký tự');
                    isValid = false;
                }
                
                // Validate island
                const islandId = $('#islandId').val();
                if (!islandId) {
                    showFieldError('#islandId', 'Vui lòng chọn đảo');
                    isValid = false;
                }
                
                // Validate rating if provided
                const rating = $('#rating').val();
                if (rating && (parseFloat(rating) < 0 || parseFloat(rating) > 5)) {
                    showFieldError('#rating', 'Đánh giá phải từ 0 đến 5');
                    isValid = false;
                }
                
                // Only prevent submission if validation fails
                if (!isValid) {
                    e.preventDefault();
                    // Scroll to first error
                    const firstError = $('.is-invalid').first();
                    if (firstError.length) {
                        $('html, body').animate({
                            scrollTop: firstError.offset().top - 100
                        }, 500);
                    }
                }
                // If validation passes, allow normal form submission
            });
            
            // Real-time validation
            $('#hotelName').on('input', function() {
                const value = $(this).val().trim();
                if (value && value.length <= 255) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            

            
            $('#rating').on('input', function() {
                const value = $(this).val();
                if (!value || (parseFloat(value) >= 0 && parseFloat(value) <= 5)) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            
            $('#islandId').on('change', function() {
                const value = $(this).val();
                if (value) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            

            
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
        });
        
        function showFieldError(fieldSelector, message) {
            const field = $(fieldSelector);
            field.addClass('is-invalid');
            field.after('<div class="invalid-feedback">' + message + '</div>');
        }
        
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function isValidUrl(url) {
            try {
                new URL(url);
                return true;
            } catch (e) {
                return false;
            }
        }
        
        // Image preview function
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const noImageText = document.getElementById('noImageText');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Validate file size (5MB max)
                if (file.size > 5 * 1024 * 1024) {
                    alert('File quá lớn! Vui lòng chọn file nhỏ hơn 5MB.');
                    input.value = '';
                    preview.style.display = 'none';
                    noImageText.style.display = 'block';
                    return;
                }
                
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file hình ảnh!');
                    input.value = '';
                    preview.style.display = 'none';
                    noImageText.style.display = 'block';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    noImageText.style.display = 'none';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
                noImageText.style.display = 'block';
            }
        }
    </script>
</body>
</html>