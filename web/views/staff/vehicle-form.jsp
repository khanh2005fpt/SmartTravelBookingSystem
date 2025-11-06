<%-- 
    Document   : vehicle-form
    Created on : Staff Vehicle Form Page
    Author     : System
    Description: Create/Edit vehicle form
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.IslandVehicle" %>
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
            <c:when test="${not empty vehicle && vehicle.vehicleId > 0}">
                Chỉnh sửa Phương tiện - Meland Travel
            </c:when>
            <c:otherwise>
                Thêm Phương tiện mới - Meland Travel
            </c:otherwise>
        </c:choose>
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
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
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
        
        .form-text {
            font-size: 0.875em;
            color: #6c757d;
            margin-top: 5px;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        
        .image-upload-section {
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .image-upload-section:hover {
            border-color: #667eea;
            background: #f0f4ff;
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
        
        .btn-upload {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-upload:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .image-preview {
            margin-top: 20px;
            display: none;
        }
        
        .preview-image {
            max-width: 100%;
            max-height: 300px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .remove-image {
            background: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            margin-top: 10px;
            cursor: pointer;
            font-size: 0.9em;
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
         background: linear-gradient(180deg, #0077b6, #00b4d8);
            color: white;
        }
        
        .btn-primary:hover {
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        
        .loading-spinner {
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
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
            
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-action {
                min-width: auto;
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
        <jsp:param name="page" value="vehicles" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fa fa-car"></i>
                <c:choose>
                    <c:when test="${not empty vehicle && vehicle.vehicleId > 0}">
                        Chỉnh sửa Phương tiện
                    </c:when>
                    <c:otherwise>
                        Thêm Phương tiện mới
                    </c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${not empty vehicle && vehicle.vehicleId > 0}">
                        Cập nhật thông tin phương tiện
                    </c:when>
                    <c:otherwise>
                        Tạo phương tiện mới trong hệ thống
                    </c:otherwise>
                </c:choose>
            </p>
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

        <!-- Vehicle Form -->
        <div class="form-container">
            <div class="form-header">
                <h2 class="form-title">
                    <i class="fa fa-edit"></i>
                    <c:choose>
                        <c:when test="${not empty vehicle && vehicle.vehicleId > 0}">
                            Chỉnh sửa: ${vehicle.vehicleName}
                        </c:when>
                        <c:otherwise>
                            Thông tin Phương tiện
                        </c:otherwise>
                    </c:choose>
                </h2>
            </div>

            <form id="vehicleForm" action="${pageContext.request.contextPath}/staff/vehicles" method="post" enctype="multipart/form-data" novalidate>
                <input type="hidden" name="action" value="${empty vehicle ? 'create' : 'update'}">
                <c:if test="${not empty vehicle}">
                    <input type="hidden" name="id" value="${vehicle.vehicleId}">
                </c:if>

                <div class="form-content">
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-info-circle"></i> Thông tin cơ bản
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="vehicleType">Loại phương tiện <span class="required">*</span></label>
                                <select class="form-control ${not empty errorVehicleType ? 'is-invalid' : ''}" id="vehicleType" name="vehicleType" required>
                                    <option value="">Chọn loại phương tiện</option>
                                    <option value="Ô tô" ${vehicle.vehicleType == 'Ô tô' ? 'selected' : ''}>Ô tô</option>
                                    <option value="Xe tay ga" ${vehicle.vehicleType == 'Xe tay ga' ? 'selected' : ''}>Xe tay ga</option>
                                    <option value="Xe máy" ${vehicle.vehicleType == 'Xe máy' ? 'selected' : ''}>Xe máy</option>
                                    <option value="Xe đạp" ${vehicle.vehicleType == 'Xe đạp' ? 'selected' : ''}>Xe đạp</option>
                                    <option value="Xe điện" ${vehicle.vehicleType == 'Xe điện' ? 'selected' : ''}>Xe điện</option>
                                    <option value="Khác" ${vehicle.vehicleType == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                                <c:if test="${not empty errorVehicleType}">
                                    <div class="invalid-feedback">${errorVehicleType}</div>
                                </c:if>
                            </div>
                            
                            <div class="form-group">
                                <label for="modelName">Tên/Model phương tiện <span class="required">*</span></label>
                                <input type="text" 
                                       class="form-control ${not empty errorModelName ? 'is-invalid' : ''}" 
                                       id="modelName" 
                                       name="modelName" 
                                       value="${vehicle.modelName}"
                                       required
                                       placeholder="Nhập tên hoặc model phương tiện (VD: Honda Wave, Toyota Vios)">
                                <c:if test="${not empty errorModelName}">
                                    <div class="invalid-feedback">${errorModelName}</div>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="capacity">Sức chứa <span class="required">*</span></label>
                                <input type="number" 
                                       class="form-control <c:if test='${not empty errorCapacity}'>is-invalid</c:if>" 
                                       id="capacity" 
                                       name="capacity" 
                                       value="${vehicle.capacity}"
                                       min="1"
                                       max="100"
                                       required
                                       placeholder="Số người">
                                <div class="form-text">Số lượng người tối đa có thể sử dụng</div>
                                <c:if test="${not empty errorCapacity}">
                                    <div class="invalid-feedback">${errorCapacity}</div>
                                </c:if>
                            </div>
                            
                            <div class="form-group">
                                <label for="pricePerDay">Giá thuê/ngày <span class="required">*</span></label>
                                <input type="number" 
                                       class="form-control ${not empty errorPricePerDay ? 'is-invalid' : ''}" 
                                       id="pricePerDay" 
                                       name="pricePerDay" 
                                       value="${vehicle.pricePerDay}"
                                       min="0"
                                       step="1000"
                                       required
                                       placeholder="Giá thuê (VNĐ)">
                                <div class="form-text">Giá thuê theo ngày (VNĐ)</div>
                                <c:if test="${not empty errorPricePerDay}">
                                    <div class="invalid-feedback">${errorPricePerDay}</div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Location Information Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fa fa-map-marker-alt"></i> Thông tin vị trí
                        </h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="islandId">Đảo <span class="required">*</span></label>
                                <select class="form-control <c:if test='${not empty errorIslandId}'>is-invalid</c:if>" id="islandId" name="islandId" required>
                                    <option value="">Chọn đảo</option>
                                    <c:forEach var="island" items="${islands}">
                                        <option value="${island.islandId}" ${vehicle != null && vehicle.islandId != null && vehicle.islandId == island.islandId ? 'selected' : ''}>
                                            ${island.islandName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty errorIslandId}">
                                    <div class="invalid-feedback">${errorIslandId}</div>
                                </c:if>
                            </div>
                            
                            <div class="form-group">
                                <label for="availability">Số lượng có sẵn <span class="required">*</span></label>
                                <input type="number" 
                                       class="form-control <c:if test='${not empty errorAvailability}'>is-invalid</c:if>" 
                                       id="availability" 
                                       name="availability" 
                                       value="${vehicle.availability}"
                                       min="0"
                                       max="1000"
                                       required
                                       placeholder="Số lượng phương tiện có sẵn">
                                <div class="form-text">Số lượng phương tiện hiện có sẵn để cho thuê</div>
                                <c:if test="${not empty errorAvailability}">
                                    <div class="invalid-feedback">${errorAvailability}</div>
                                </c:if>
                            </div>
                        </div>
                    </div>


                            <br>
                            <button type="button" class="remove-image" onclick="removeImage()">
                                <i class="fa fa-times"></i> Xóa hình ảnh
                            </button>
                        </div>
                        
                        <!-- Current image display for edit mode -->
                        <c:if test="${not empty vehicle && not empty vehicle.vehicleImageUrl}">
                            <div class="current-image" id="currentImage">
                                <h4>Hình ảnh hiện tại:</h4>
                                <img src="${pageContext.request.contextPath}/${vehicle.vehicleImageUrl}" 
                                     alt="${vehicle.vehicleName}" 
                                     class="preview-image">
                                <br>
                                <button type="button" class="remove-image" onclick="removeCurrentImage()">
                                    <i class="fa fa-times"></i> Xóa hình ảnh hiện tại
                                </button>
                                <input type="hidden" id="removeCurrentImage" name="removeCurrentImage" value="false">
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/staff/vehicles?action=list" class="btn-action btn-secondary">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn-action btn-primary">
                        <i class="fa fa-save"></i>
                        <c:choose>
                            <c:when test="${not empty vehicle && vehicle.vehicleId > 0}">
                                Cập nhật
                            </c:when>
                            <c:otherwise>
                                Tạo mới
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fa fa-spinner fa-spin fa-2x"></i>
            <p>Đang xử lý...</p>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Form validation
        (function() {
            'use strict';
            
            const form = document.getElementById('vehicleForm');
            
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                // Custom validation
                validateForm();
                
                if (form.checkValidity()) {
                    showLoading();
                }
                
                form.classList.add('was-validated');
            }, false);
            
            function validateForm() {
                // Validate model name
                const modelName = document.getElementById('modelName');
                if (modelName.value.trim().length < 2) {
                    setInvalid(modelName, 'Tên/Model phương tiện phải có ít nhất 2 ký tự');
                } else {
                    setValid(modelName);
                }
                
                // Validate capacity
                const capacity = document.getElementById('capacity');
                if (capacity.value < 1 || capacity.value > 100) {
                    setInvalid(capacity, 'Sức chứa phải từ 1 đến 100 người');
                } else {
                    setValid(capacity);
                }
                
                // Validate price
                const pricePerDay = document.getElementById('pricePerDay');
                if (pricePerDay.value < 0) {
                    setInvalid(pricePerDay, 'Giá thuê không được âm');
                } else {
                    setValid(pricePerDay);
                }
                
                // Validate availability
                const availability = document.getElementById('availability');
                if (availability.value < 0 || availability.value > 1000) {
                    setInvalid(availability, 'Số lượng có sẵn phải từ 0 đến 1000');
                } else {
                    setValid(availability);
                }
            }
            
            function setInvalid(element, message) {
                element.classList.add('is-invalid');
                const feedback = element.parentNode.querySelector('.invalid-feedback');
                if (feedback) {
                    feedback.textContent = message;
                }
            }
            
            function setValid(element) {
                element.classList.remove('is-invalid');
            }
        })();



        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Format price input
        document.getElementById('pricePerDay').addEventListener('input', function(e) {
            // Remove non-numeric characters except for decimal point
            let value = e.target.value.replace(/[^\d]/g, '');
            e.target.value = value;
        });
    </script>
</body>
</html>