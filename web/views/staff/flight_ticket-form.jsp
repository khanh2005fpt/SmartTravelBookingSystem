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
    <title>${empty flight ? 'Thêm' : 'Chỉnh sửa'} Vé máy bay - Meland Travel</title>
    
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
        <jsp:param name="page" value="flights_tickets" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fa fa-utensils"></i> 
                ${empty  flight ? 'Thêm thông tin vé máy bay' : 'Chỉnh sửa thông tin vé máy bay '}
            </h1>
            <p>${empty flight ? 'Thêm những vé máy bay mới trong hệ thống' : 'Cập nhật thông tin vé máy bay'}</p>
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

        <!-- Flight Form -->
        <div class="form-container">
            <div class="form-header">
                <h3 class="form-title">
                    <i class="fa fa-edit"></i> 
                    ${empty flight ? 'Thông tin vé máy bay mới' : 'Chỉnh sửa thông tin vé máy bay'}
                </h3>
            </div>

            <form action="${pageContext.request.contextPath}/staff/flight/tickets" 
                  method="post" 
                  enctype="multipart/form-data" 
                  id="flight_ticketForm" 
                  novalidate>
              <input type="hidden" name="action" value="${empty flight ? 'create' : 'update'}">
              <p>Debug action = ${empty flight ? 'create' : 'update'}</p>
                
                <c:if test="${not empty flight}">
                    <input type="hidden" name="id" value="${flight.flightId}">
                </c:if>

                <div class="form-content">
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-info-circle"></i> Thông tin cơ bản
                        </h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="restaurantName">Mã chuyến bay <span class="required">*</span></label>
                                <input type="text" 
                                       class="form-control ${not empty errors.flightNumber ? 'is-invalid' : ''}" 
                                       id="flightNumber" 
                                       name="flightNumber" 
                                       value="${flight != null ? flight.flightNumber :param.flightNumber}"
                                       placeholder="Nhập mã chuyến bay"
                                       maxlength="6"
                                       required>
                                 <c:if test="${not empty errors.flightNumber}">
                                    <div class="invalid-feedback">${errors.flightNumber}</div>
                                </c:if>
                                <div class="form-text">Tối đa 6 ký tự</div>
                           
                            </div>
                                       
                                     
                            
                            <div class="form-group">
                                <label for="airlineName" >Hãng hàng không <span class="required">*</span></label>
                                
                                 <select class="form-control ${not empty errors.airlineId ? 'is-invalid' : ''}" 
                                        id="airlineId" 
                                        name="airlineId" 
                                        required>
                                    <option value="">Chọn hãng bay...</option>
                                    <c:forEach var="airline" items="${airlineNames}">
                                        <option value="${airline.airlineId}" 
                                                ${(flight!= null && flight.airlineId == airline.airlineId) || param.airlineId == airline.airlineId ? 'selected' : ''}>
                                            ${airline.airlineName}
                                        </option>
                                    </c:forEach>
                                </select>
                                 <c:if test="${not empty errors.airlineId}">
                                    <div class="invalid-feedback">${errors.airlineId}</div>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                   <label for="priceRange">Nơi khởi hành<span class="required">*</span></label>
                              <select class="form-control  ${not empty errors.departure ? 'is-invalid' : ''}"  " id="departure" name="departure" required>
                                    <option value="">Chọn nơi khởi hành ...</option>
                             
                                    <option value="Ha Noi" ${(flight.departure!=null && flight.departure == 'Ha Noi') || param.departure == 'Ha Noi'? 'selected' : ''}>Ha Noi</option>
                                    <option value="TP Ho Chi Minh" ${(flight.departure!=null && flight.departure == 'TP Ho Chi Minh') || param.departure == 'TP Ho Chi Minh'? 'selected' : ''}>TP Ho Chi Minh</option> 

                                </select>
                                 <c:if test="${not empty errors.departure}">
                                    <div class="invalid-feedback">${errors.departure}</div>
                                </c:if>
                                        <div class="form-text">Khởi hành tại 2 thành phố lớn Việt Nam</div>
                            </div>
   
                                    <div class="form-group">
                                <label for="islandId">Điểm đến du lịch <span class="required">*</span></label>
                                <select class="form-control" id="islandId" name="islandId" required>
                                    <option value="">Chọn đảo...</option>
                                    <c:forEach var="island" items="${islands}">
                                        <option value="${island.islandId}" ${restaurant.islandId == island.islandId ? 'selected' : ''}>
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

                    <!-- Location Information Section -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-map-marker-alt"></i> Thông tin chi tiết 
                        </h4>
                        
                        <div class="form-row">
                             
                            <div class="form-group">
                                <label for="priceRange">Mức giá <span class="required">*</span></label>
                                <select class="form-control" id="priceRange" name="priceRange" required>
                                    <option value="">-- Chọn mức giá --</option>
                                    <option value="">Tất cả mức giá</option>
                <option value="0-1000000" ${param.priceRange == '0-1000000' ? 'selected' : ''}>Dưới 1.000.000₫</option>
                <option value="1000000-3000000" ${param.priceRange == '1000000-3000000' ? 'selected' : ''}>1.000.000₫ - 3.000.000₫</option>
                <option value="3000000-5000000" ${param.priceRange == '3000000-5000000' ? 'selected' : ''}>3.000.000₫ - 5.000.000₫</option>
                <option value="5000000+" ${param.priceRange == '5000000+' ? 'selected' : ''}>Trên 5.000.000₫</option>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="ticketAvailable">Số vé còn lại</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="ticketAvailable" 
                                       name="ticketAvailable" 
                                       value="${flight.ticketAvailable}"
                                       placeholder="Nhập số vé">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                            <div class="form-row">  
                                    <div class="form-group">
                                            <label for="flightType">Loại chuyến bay</label>
                                <select class="form-control" id="flightType" name="flightType" required>
                                    <option value="">-- Chọn loại chuyến bay --</option>
                                    <option value="Một chiều" ${param.flightType == 'Một chiều' ? 'selected' : ''}>Một chiều</option>
                                    <option value="Khứ hồi" ${param.flightType == 'Khứ hồi' ? 'selected' : ''}>Khứ hồi</option>
                                </select>
                               </div>
                                 <div class="form-group">
                                     <label for="flightClass">Hạng ghế</label>
                                     <select class="form-control" id="flightClass" name="flightClass" required>
                                         <option value="">-- Chọn hạng ghế --</option>
                                         <option value="Phổ thông" ${param.flightClass == 'Phổ thông' ? 'selected' : ''}>Phổ thông</option>
                                         <option value="Thương gia" ${param.flightClass == 'Thương gia' ? 'selected' : ''}>Thương gia</option>
                                         <option value="Hạng nhất" ${param.flightClass == 'Hạng nhất' ? 'selected' : ''}>Hạng nhất</option>
                                     </select>
                                 </div>

                                
                                
                                  </div>
                                       
                    </div>

              

                    <!-- Image Upload Section -->
                                <!-- Image Upload Section -->
<div class="form-section">
  <h4 class="section-title">
    <i class="fa fa-image"></i> Hình ảnh đảo và logo hãng bay
  </h4>
  
  <div class="form-row">

    <!-- Logo hãng bay -->
    <div class="form-group">
      <div class="image-upload-section">
        <c:choose>
          <c:when test="${not empty airline.logoUrl}">
            <img src="${pageContext.request.contextPath}/${airline.logoUrl}" 
                 alt="Logo Hãng Bay" 
                 class="image-preview" 
                 id="imageLogoPreview">
          </c:when>
          <c:otherwise>
            <div class="upload-placeholder" id="logoPlaceholder">
              <i class="fa fa-cloud-upload-alt"></i>
              <p>Chọn hình ảnh logo hãng bay</p>
              <small>Định dạng: JPG, PNG, GIF (Tối đa 5MB)</small>
            </div>
            <img src="#" alt="Preview" class="image-preview" id="imageLogoPreview" style="display: none;">
          </c:otherwise>
        </c:choose>

        <div class="file-input-wrapper">
          <input type="file" 
                 class="file-input" 
                 id="logoImage" 
                 name="logoImage" 
                 accept="image/*"
                 onchange="previewImage(this, 'imageLogoPreview', 'logoPlaceholder')">
          <button type="button" class="file-input-button">
            <i class="fa fa-upload"></i> Chọn hình ảnh 
          </button>
        </div>
      </div>
    </div>

    <!-- Ảnh đảo du lịch -->
    <div class="form-group">
      <div class="image-upload-section">
        <c:choose>
          <c:when test="${not empty flight.destinationImageUrl}">
            <img src="${pageContext.request.contextPath}/${flight.destinationImageUrl}" 
                 alt="Ảnh Đảo Du Lịch" 
                 class="image-preview" 
                 id="imageBannerPreview">
          </c:when>
          <c:otherwise>
            <div class="upload-placeholder" id="bannerPlaceholder">
              <i class="fa fa-cloud-upload-alt"></i>
              <p>Chọn hình ảnh đảo du lịch</p>
              <small>Định dạng: JPG, PNG, GIF (Tối đa 5MB)</small>
            </div>
            <img src="#" alt="Preview" class="image-preview" id="imageBannerPreview" style="display: none;">
          </c:otherwise>
        </c:choose>

        <div class="file-input-wrapper">
          <input type="file" 
                 class="file-input" 
                 id="flightImage" 
                 name="flightImage" 
                 accept="image/*"
                 onchange="previewImage(this, 'imageBannerPreview', 'bannerPlaceholder')">
          <button type="button" class="file-input-button">
            <i class="fa fa-upload"></i> Chọn hình ảnh
          </button>
        </div>
      </div>
    </div>

  </div>
</div>

                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/staff/flight/tickets?action=list" class="btn-action btn-secondary">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn-action btn-primary">
                        <i class="fa fa-save"></i> 
                        ${empty flight ? 'Tạo thông tin vé máy bay' : 'Cập nhật'}
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
           // Form validation
       $(document).ready(function () {
    $('#flight_ticketForm').on('submit', function (e) {
        let isValid = true;

        // Clear previous validation states 
        $('.form-control').removeClass('is-invalid');
        $('.invalid-feedback').remove();

        // validate flightNumber
        const flightNumber = $('#flightNumber').val().trim();
        const regex = /^[A-Z]{2}\d{1,4}$/; // 2 chữ cái hoa + 1-4 chữ số
        if (!flightNumber) {
            showFieldError('#flightNumber', 'Mã chuyến bay là bắt buộc');
            isValid = false;
        } else if (!regex.test(flightNumber)) {
            showFieldError('#flightNumber', 'Mã chuyến bay không hợp lệ (ví dụ: VN1234)');
            isValid = false;
        }

        // validate airlineName
        const airlineId = $('#airlineId').val();
        if (!airlineId) {
            showFieldError('#airlineId', 'Xin vui lòng chọn hãng hàng không');
            isValid = false;
        }

        // validate departure
        const departure = $('#departure').val();
        if (!departure) {
            showFieldError('#departure', 'Xin vui lòng chọn nơi khởi hành');
            isValid = false;
        }

        // validate island
        const islandId = $('#islandId').val();
        if (!islandId) {
            showFieldError('#islandId', 'Vui lòng chọn điểm đến du lịch');
            isValid = false;
        }
        
        // validate priceRange
        
        const priceRange = $('#priceRange').val();
        if(!priceRange){
           showFieldError('#priceRange' , 'Vui lòng chọn mức giá vé');
           isValid=false;
        }
        
       // validate ticketAvailable
          const ticketAvailable = $('#ticketAvailable').val().trim();

          if (!ticketAvailable) {
           showFieldError('#ticketAvailable', 'Xin hãy nhập số vé');
            isValid = false;
          } else if (isNaN(ticketAvailable) || Number(ticketAvailable) <= 0) {
            showFieldError('#ticketAvailable', 'Số vé phải là số hợp lệ và lớn hơn 0');
              isValid = false;
          }
      // validate flightType
          const flightType = $('#flightType').val();
          if(!flightType){
              showFieldError('#flightType', 'Vui lòng hãy chọn loại vé');
            isValid = false;
          }
          
        //validate flightClass
          const flightClass = $('#flightClass').val();
          if(!flightClass){
              showFieldError('#flightClass', 'Vui lòng hãy chọn hạng ghế');
            isValid = false;
          }
          
  
          

        // Ngăn submit nếu có lỗi
        if (!isValid) {
            e.preventDefault();
        }
    });
});

function previewImage(input, previewId, placeholderId) {
  const preview = document.getElementById(previewId);
  const placeholder = document.getElementById(placeholderId);

  if (input.files && input.files[0]) {
    const file = input.files[0];

    // Giới hạn dung lượng 5MB
    if (file.size > 5 * 1024 * 1024) {
      alert('File quá lớn! Vui lòng chọn file nhỏ hơn 5MB.');
      input.value = '';
      preview.style.display = 'none';
      placeholder.style.display = 'block';
      return;
    }

    // Chỉ chấp nhận file ảnh
    if (!file.type.startsWith('image/')) {
      alert('Vui lòng chọn file hình ảnh!');
      input.value = '';
      preview.style.display = 'none';
      placeholder.style.display = 'block';
      return;
    }

    const reader = new FileReader();
    reader.onload = function(e) {
      preview.src = e.target.result;
      preview.style.display = 'block';
      placeholder.style.display = 'none';
    };
    reader.readAsDataURL(file);
  } else {
    preview.style.display = 'none';
    placeholder.style.display = 'block';
  }
}


    </script>
</body>
</html>