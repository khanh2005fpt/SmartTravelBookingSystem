<%-- 
    Document   : tour-form
    Created on : Staff Tour Form Page
    Author     : System
    Description: Form for creating and editing tours
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Tour" %>
<%@ page import="model.Island" %>
<%@ page import="model.TourService" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${tour != null ? 'Chỉnh sửa Tour' : 'Tạo Tour mới'} - Meland Travel</title>
    
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
        
        /* Service Selection Styles */
        .service-category {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            height: 100%;
        }
        
        .service-category h5 {
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .service-list {
            max-height: 300px;
            overflow-y: auto;
        }
        
        .service-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }
        
        .service-item:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }
        
        .service-item .form-check {
            margin: 0;
        }
        
        .service-item .form-check-input {
            margin-top: 0.25rem;
        }
        
        .service-item .form-check-label {
            margin-left: 1.5rem;
            cursor: pointer;
            width: 100%;
        }
        
        .service-item .badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        
        .no-services {
            text-align: center;
            padding: 30px;
            color: #6c757d;
            font-style: italic;
        }
        
        .no-services i {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }
        
        /* Custom scrollbar for service lists */
        .service-list::-webkit-scrollbar {
            width: 6px;
        }
        
        .service-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }
        
        .service-list::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }
        
        .service-list::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
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
            
            .service-category {
                margin-bottom: 20px;
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
            <h1>
                <i class="fa ${tour != null ? 'fa-edit' : 'fa-plus'}"></i> 
                ${tour != null ? 'Chỉnh sửa Tour' : 'Tạo Tour mới'}
            </h1>
            <p>${tour != null ? 'Cập nhật thông tin tour' : 'Thêm tour mới vào hệ thống'}</p>
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
            <form action="${pageContext.request.contextPath}/staff/tours" method="post" id="tourForm" enctype="multipart/form-data" novalidate>
                <input type="hidden" name="action" value="${tour != null ? 'update' : 'create'}">
                <c:if test="${tour != null}">
                    <input type="hidden" name="id" value="${tour.tourId}">
                </c:if>

                <!-- Basic Information Section -->
                <div class="form-section">
                    <h4><i class="fa fa-info-circle"></i> Thông tin cơ bản</h4>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label for="tourName" class="form-label">
                                    Tên Tour <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control ${not empty errors.tourName ? 'is-invalid' : ''}" 
                                       id="tourName" 
                                       name="tourName" 
                                       value="${tour != null ? tour.tourName : param.tourName}"
                                       placeholder="Nhập tên tour..."
                                       maxlength="255"
                                       required>
                                <c:if test="${not empty errors.tourName}">
                                    <div class="invalid-feedback">${errors.tourName}</div>
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
                                                ${(tour != null && tour.islandId != null && tour.islandId == island.islandId) || (param.islandId != null && param.islandId == island.islandId) ? 'selected' : ''}>
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

                    <div class="form-group">
                        <label for="description" class="form-label">
                            Mô tả <span class="required">*</span>
                        </label>
                        <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}" 
                                  id="description" 
                                  name="description" 
                                  placeholder="Nhập mô tả chi tiết về tour..."
                                  rows="5"
                                  required>${tour != null ? tour.description : param.description}</textarea>
                        <c:if test="${not empty errors.description}">
                            <div class="invalid-feedback">${errors.description}</div>
                        </c:if>
                        <div class="form-text">Mô tả chi tiết về tour, điểm đến, hoạt động...</div>
                    </div>
                </div>

                <!-- Pricing Section -->
                <div class="form-section">
                    <h4><i class="fa fa-money"></i> Thông tin giá</h4>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="price" class="form-label">
                                    Giá tour <span class="required">*</span>
                                </label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">₫</span>
                                    </div>
                                    <input type="number" 
                                           class="form-control ${not empty errors.price ? 'is-invalid' : ''}" 
                                           id="price" 
                                           name="price" 
                                           value="${tour != null ? tour.price : param.price}"
                                           placeholder="0"
                                           min="0"
                                           step="1000"
                                           required>
                                </div>
                                <c:if test="${not empty errors.price}">
                                    <div class="invalid-feedback">${errors.price}</div>
                                </c:if>
                                <div class="form-text">Giá tính bằng VNĐ, phải là số không âm</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="availableQuantity" class="form-label">
                                    Số lượng tour còn lại <span class="required">*</span>
                                </label>
                                <input type="number" 
                                       class="form-control ${not empty errors.availableQuantity ? 'is-invalid' : ''}" 
                                       id="availableQuantity" 
                                       name="availableQuantity" 
                                       value="${tour != null ? tour.availableQuantity : param.availableQuantity}"
                                       placeholder="0"
                                       min="0"
                                       required>
                                <c:if test="${not empty errors.availableQuantity}">
                                    <div class="invalid-feedback">${errors.availableQuantity}</div>
                                </c:if>
                                <div class="form-text">Số lượng tour còn lại có thể đặt</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Image Upload Section -->
                <div class="form-section">
                    <h4><i class="fa fa-image"></i> Hình ảnh tour</h4>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="tourImageFile" class="form-label">
                                    Tải lên hình ảnh tour
                                </label>
                                <input type="file" 
                                       class="form-control ${not empty errors.tourImageUrl ? 'is-invalid' : ''}" 
                                       id="tourImageFile" 
                                       name="tourImageFile" 
                                       accept="image/*"
                                       onchange="previewImage(this)">
                                <c:if test="${not empty errors.tourImageUrl}">
                                    <div class="invalid-feedback">${errors.tourImageUrl}</div>
                                </c:if>
                                <div class="form-text">Chọn file hình ảnh (JPG, PNG, GIF). Tối đa 5MB</div>
                            </div>
                        </div>
                                       
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Xem trước</label>
                                <div class="image-preview-container">
                                    <img id="imagePreview" 
                                         src="${tour != null && tour.tourImageUrl != null ? pageContext.request.contextPath.concat('/').concat(tour.tourImageUrl) : ''}" 
                                         alt="Preview" 
                                         style="max-width: 100%; max-height: 200px; display: ${tour != null && tour.tourImageUrl != null ? 'block' : 'none'}; border: 1px solid #ddd; border-radius: 4px;">
                                    <div id="noImageText" style="display: ${tour != null && tour.tourImageUrl != null ? 'none' : 'block'}; color: #6c757d; font-style: italic;">
                                        Chưa có hình ảnh
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hidden field to store current image URL for edit mode -->
                    <c:if test="${tour != null && tour.tourImageUrl != null}">
                        <input type="hidden" name="currentImageUrl" value="${tour.tourImageUrl}">
                    </c:if>
                </div>

                <!-- Service Selection Section -->
                <div class="form-section">
                    <h4><i class="fa fa-cogs"></i> Dịch vụ tour</h4>
                    <p class="text-muted mb-3">Chọn các dịch vụ sẽ bao gồm trong tour này</p>
                    
                    <div class="row">
                        <!-- Hotels -->
                        <div class="col-md-6 mb-4">
                            <div class="service-category">
                                <h5><i class="fa fa-bed text-primary"></i> Khách sạn</h5>
                                <div class="service-list" id="hotelList">
                                    <c:choose>
                                        <c:when test="${not empty availableHotels}">
                                            <c:forEach var="hotel" items="${availableHotels}">
                                                <div class="service-item">
                                                    <div class="form-check">
                                                        <input class="form-check-input" 
                                                               type="checkbox" 
                                                               name="selectedServices" 
                                                               value="hotel_${hotel.hotelId}"
                                                               id="hotel_${hotel.hotelId}"
                                                               ${selectedServices != null && selectedServices.contains('hotel_'.concat(hotel.hotelId.toString())) ? 'checked' : ''}>
                                                        <label class="form-check-label" for="hotel_${hotel.hotelId}">
                                                            <strong>${hotel.hotelName}</strong>
                                                            <br><small class="text-muted">${hotel.address}</small>
                                                            <br><span class="badge badge-success">${hotel.price} VNĐ/đêm</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-services">
                                                <i class="fa fa-info-circle"></i> Chưa có khách sạn nào. Vui lòng chọn đảo trước.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>



                        <!-- Places -->
                        <div class="col-md-6 mb-4">
                            <div class="service-category">
                                <h5><i class="fa fa-map-marker text-info"></i> Địa điểm</h5>
                                <div class="service-list" id="placeList">
                                    <c:choose>
                                        <c:when test="${not empty availablePlaces}">
                                            <c:forEach var="place" items="${availablePlaces}">
                                                <div class="service-item">
                                                    <div class="form-check">
                                                        <input class="form-check-input" 
                                                               type="checkbox" 
                                                               name="selectedServices" 
                                                               value="place_${place.placeId}"
                                                               id="place_${place.placeId}"
                                                               ${selectedServices != null && selectedServices.contains('place_'.concat(place.placeId.toString())) ? 'checked' : ''}>
                                                        <label class="form-check-label" for="place_${place.placeId}">
                                                            <strong>${place.placeName}</strong>
                                                            <br><small class="text-muted">${place.address}</small>
                                                            <br><span class="badge badge-info">${place.category}</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-services">
                                                <i class="fa fa-info-circle"></i> Chưa có địa điểm nào. Vui lòng chọn đảo trước.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Vehicles -->
                        <div class="col-md-6 mb-4">
                            <div class="service-category">
                                <h5><i class="fa fa-car text-danger"></i> Phương tiện</h5>
                                <div class="service-list" id="vehicleList">
                                    <c:choose>
                                        <c:when test="${not empty availableVehicles}">
                                            <c:forEach var="vehicle" items="${availableVehicles}">
                                                <div class="service-item">
                                                    <div class="form-check">
                                                        <input class="form-check-input" 
                                                               type="checkbox" 
                                                               name="selectedServices" 
                                                               value="vehicle_${vehicle.vehicleId}"
                                                               id="vehicle_${vehicle.vehicleId}"
                                                               ${selectedServices != null && selectedServices.contains('vehicle_'.concat(vehicle.vehicleId.toString())) ? 'checked' : ''}>
                                                        <label class="form-check-label" for="vehicle_${vehicle.vehicleId}">
                                                            <strong>${vehicle.vehicleName}</strong>
                                                            <br><small class="text-muted">${vehicle.vehicleType}</small>
                                                            <br><span class="badge badge-danger">${vehicle.price} VNĐ/ngày</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-services">
                                                <i class="fa fa-info-circle"></i> Chưa có phương tiện nào. Vui lòng chọn đảo trước.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Flights (Vé máy bay) -->
                        <div class="col-md-6 mb-4">
                            <div class="service-category">
                                <h5><i class="fa fa-plane text-primary"></i> Vé máy bay</h5>
                                <div class="service-list" id="flightList">
                                    <div class="no-services">
                                        <i class="fa fa-info-circle"></i> Chưa có vé máy bay nào. Vui lòng chọn đảo trước.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="fa fa-info-circle"></i>
                        <strong>Lưu ý:</strong> Các dịch vụ được hiển thị dựa trên đảo đã chọn. Thay đổi đảo sẽ cập nhật danh sách dịch vụ.
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="btn-group-form">
                    <a href="${pageContext.request.contextPath}/staff/tours?action=list" 
                       class="btn-form btn-secondary-form">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn-form btn-primary-form">
                        <i class="fa ${tour != null ? 'fa-save' : 'fa-plus'}"></i> 
                        ${tour != null ? 'Cập nhật' : 'Tạo Tour'}
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Build selected services map from currentServices (for edit mode)
        var selectedServicesMap = {};
        <c:if test="${not empty currentServices}">
            <c:forEach var="service" items="${currentServices}">
                <c:choose>
                    <c:when test="${service.serviceType == 'Hotel'}">
                        selectedServicesMap['hotel_' + ${service.serviceId}] = true;
                    </c:when>
                    <c:when test="${service.serviceType == 'Place'}">
                        selectedServicesMap['place_' + ${service.serviceId}] = true;
                    </c:when>
                    <c:when test="${service.serviceType == 'Vehicle'}">
                        selectedServicesMap['vehicle_' + ${service.serviceId}] = true;
                    </c:when>
                    <c:when test="${service.serviceType == 'FLIGHT' || service.serviceType == 'AIRLINE'}">
                        selectedServicesMap['flight_' + ${service.serviceId}] = true;
                    </c:when>
                </c:choose>
            </c:forEach>
        </c:if>
        
        $(document).ready(function() {
            // Form validation
            $('#tourForm').on('submit', function(e) {
                let isValid = true;
                
                // Clear previous validation states
                $('.form-control').removeClass('is-invalid');
                $('.invalid-feedback').remove();
                
                // Validate tour name
                const tourName = $('#tourName').val().trim();
                if (!tourName) {
                    showFieldError('#tourName', 'Tên tour là bắt buộc');
                    isValid = false;
                } else if (tourName.length > 255) {
                    showFieldError('#tourName', 'Tên tour không được vượt quá 255 ký tự');
                    isValid = false;
                }
                
                // Validate description
                const description = $('#description').val().trim();
                if (!description) {
                    showFieldError('#description', 'Mô tả là bắt buộc');
                    isValid = false;
                }
                
                // Validate price
                const price = $('#price').val();
                if (!price) {
                    showFieldError('#price', 'Giá là bắt buộc');
                    isValid = false;
                } else if (parseFloat(price) < 0) {
                    showFieldError('#price', 'Giá phải là số không âm');
                    isValid = false;
                }
                
                // Validate island
                const islandId = $('#islandId').val();
                if (!islandId) {
                    showFieldError('#islandId', 'Vui lòng chọn đảo');
                    isValid = false;
                }
                
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
            });
            
            // Real-time validation
            $('#tourName').on('input', function() {
                const value = $(this).val().trim();
                if (value && value.length <= 255) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            
            $('#description').on('input', function() {
                const value = $(this).val().trim();
                if (value) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            
            $('#price').on('input', function() {
                const value = $(this).val();
                if (value && parseFloat(value) >= 0) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                }
            });
            
            $('#islandId').on('change', function() {
                const value = $(this).val();
                if (value) {
                    $(this).removeClass('is-invalid');
                    $(this).siblings('.invalid-feedback').remove();
                    // Load services for selected island
                    loadServicesForIsland(value);
                } else {
                    // Clear services if no island selected
                    clearServiceLists();
                }
            });
            
            // Format price input
            $('#price').on('input', function() {
                let value = $(this).val().replace(/[^\d]/g, '');
                if (value) {
                    // Format with thousands separator for display
                    const formatted = parseInt(value).toLocaleString('vi-VN');
                    // But keep the raw value for form submission
                    $(this).attr('data-formatted', formatted);
                }
            });
            
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
            
            // Load services on page load if island is already selected (for edit mode)
            const initialIslandId = $('#islandId').val();
            if (initialIslandId) {
                loadServicesForIsland(initialIslandId);
            }
        });
        
        function showFieldError(fieldSelector, message) {
            const field = $(fieldSelector);
            field.addClass('is-invalid');
            field.after('<div class="invalid-feedback">' + message + '</div>');
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
        
        // Load services for selected island
        function loadServicesForIsland(islandId) {
            if (!islandId) {
                clearServiceLists();
                return;
            }
            
            // Show loading state
            showServiceLoading();
            
            // Make AJAX request to get services
            $.ajax({
                url: '${pageContext.request.contextPath}/staff/tours',
                type: 'GET',
                data: {
                    action: 'getServices',
                    islandId: islandId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        updateServiceLists(response.data);
                    } else {
                        console.error('Error loading services:', response.message);
                        clearServiceLists();
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX error loading services:', error);
                    clearServiceLists();
                }
            });
        }
        
        // Show loading state for services
        function showServiceLoading() {
            const loadingHtml = '<div class="text-center p-3"><i class="fa fa-spinner fa-spin"></i> Đang tải...</div>';
            $('#hotelList').html(loadingHtml);
            $('#restaurantList').html(loadingHtml);
            $('#placeList').html(loadingHtml);
            $('#vehicleList').html(loadingHtml);
            $('#flightList').html(loadingHtml);
        }
        
        // Clear all service lists
        function clearServiceLists() {
            const noServiceHtml = '<div class="no-services"><i class="fa fa-info-circle"></i> Chưa có dịch vụ nào. Vui lòng chọn đảo trước.</div>';
            $('#hotelList').html(noServiceHtml.replace('dịch vụ', 'khách sạn'));
            $('#restaurantList').html(noServiceHtml.replace('dịch vụ', 'nhà hàng'));
            $('#placeList').html(noServiceHtml.replace('dịch vụ', 'địa điểm'));
            $('#vehicleList').html(noServiceHtml.replace('dịch vụ', 'phương tiện'));
            $('#flightList').html(noServiceHtml.replace('dịch vụ', 'vé máy bay'));
        }
        
        // Update service lists with data
        function updateServiceLists(data) {
            // Update hotels
            updateServiceList('hotelList', data.hotels, 'hotel', function(hotel) {
                var checked = selectedServicesMap['hotel_' + hotel.id] ? 'checked' : '';
                var html = '<div class="service-item">';
                html += '<div class="form-check">';
                html += '<input class="form-check-input" type="checkbox" name="selectedServices" ';
                html += 'value="hotel_' + hotel.id + '" id="hotel_' + hotel.id + '" ' + checked + '>';
                html += '<label class="form-check-label" for="hotel_' + hotel.id + '">';
                html += '<strong>' + (hotel.name || '') + '</strong>';
                html += '<br><small class="text-muted">' + (hotel.address || '') + '</small>';
                html += '<br><span class="badge badge-success">' + (hotel.price || 0) + ' VNĐ/đêm</span>';
                html += '</label>';
                html += '</div>';
                html += '</div>';
                return html;
            }, 'khách sạn');
            

            
            // Update places
            updateServiceList('placeList', data.places, 'place', function(place) {
                var checked = selectedServicesMap['place_' + place.id] ? 'checked' : '';
                var html = '<div class="service-item">';
                html += '<div class="form-check">';
                html += '<input class="form-check-input" type="checkbox" name="selectedServices" ';
                html += 'value="place_' + place.id + '" id="place_' + place.id + '" ' + checked + '>';
                html += '<label class="form-check-label" for="place_' + place.id + '">';
                html += '<strong>' + (place.name || '') + '</strong>';
                html += '<br><small class="text-muted">' + (place.address || '') + '</small>';
                html += '<br><span class="badge badge-info">' + (place.category || '') + '</span>';
                html += '</label>';
                html += '</div>';
                html += '</div>';
                return html;
            }, 'địa điểm');
            
            // Update vehicles
            updateServiceList('vehicleList', data.vehicles, 'vehicle', function(vehicle) {
                var checked = selectedServicesMap['vehicle_' + vehicle.id] ? 'checked' : '';
                var html = '<div class="service-item">';
                html += '<div class="form-check">';
                html += '<input class="form-check-input" type="checkbox" name="selectedServices" ';
                html += 'value="vehicle_' + vehicle.id + '" id="vehicle_' + vehicle.id + '" ' + checked + '>';
                html += '<label class="form-check-label" for="vehicle_' + vehicle.id + '">';
                html += '<strong>' + (vehicle.name || '') + '</strong>';
                html += '<br><small class="text-muted">' + (vehicle.type || '') + '</small>';
                html += '<br><span class="badge badge-danger">' + (vehicle.price || 0) + ' VNĐ/ngày</span>';
                html += '</label>';
                html += '</div>';
                html += '</div>';
                return html;
            }, 'phương tiện');

            // Update flights (Vé máy bay)
            updateServiceList('flightList', data.flights, 'flight', function(flight) {
                var checked = selectedServicesMap['flight_' + flight.id] ? 'checked' : '';
                var html = '<div class="service-item">';
                html += '<div class="form-check">';
                html += '<input class="form-check-input" type="checkbox" name="selectedServices" ';
                html += 'value="flight_' + flight.id + '" id="flight_' + flight.id + '" ' + checked + '>';
                html += '<label class="form-check-label" for="flight_' + flight.id + '">';
                html += '<strong>' + (flight.name || '') + '</strong>';
                if (flight.description) {
                    html += '<br><small class="text-muted">' + flight.description + '</small>';
                }
                if (flight.price) {
                    html += '<br><small class="text-success">' + formatCurrency(flight.price) + '</small>';
                }
                html += '</label>';
                html += '</div>';
                html += '</div>';
                return html;
            }, 'vé máy bay');
        }
        
        // Helper function to update individual service list
        function updateServiceList(listId, items, type, itemRenderer, serviceName) {
            const listElement = $('#' + listId);
            
            if (items && items.length > 0) {
                let html = '';
                items.forEach(function(item) {
                    html += itemRenderer(item);
                });
                listElement.html(html);
            } else {
                listElement.html(`<div class="no-services"><i class="fa fa-info-circle"></i> Chưa có ${serviceName} nào.</div>`);
            }
        }
        
        // Helper function to format currency (VNĐ)
        function formatCurrency(amount) {
            if (!amount && amount !== 0) return '0 ₫';
            return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' ₫';
        }
    </script>
</body>
</html>