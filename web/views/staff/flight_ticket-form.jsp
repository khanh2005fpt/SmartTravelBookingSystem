
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

                    <c:if test="${flight != null}">
                        <input type="hidden" name="flightId" value="${flight.flightId}">
                    </c:if>

                    <div class="form-content">
                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-info-circle"></i> Thông tin cơ bản
                            </h4>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="iataCode">Chọn Mã chuyến bay <span class="required">*</span></label>
                                    <select class="form-control ${not empty errors.airlineId ? 'is-invalid' : ''}" 
                                            id="iataCode" 
                                            name="airlineId" 
                                            required>
                                        <option value="">Chọn Mã chuyến bay ...</option>
                                        <c:forEach var="airline" items="${airlines}">
                                            <option value="${airline.airlineId}"
                                                    data-iata="${airline.iataCode}"
                                                    ${ (flight != null && flight.airline.airlineId == airline.airlineId)
                                                       || param.airlineId == airline.airlineId ? 'selected' : '' }>
                                                        ${airline.iataCode} - ${airline.airlineName}
                                                    </option>

                                            </c:forEach>
                                        </select>
                                        <!-- hien thi loi khi validate o ben server -->      
                                        <c:if test="${not empty errorFlightNumber}">
                                            <div class="invalid-feedback">${errorFlightNumber}</div>
                                        </c:if>

                                        <c:if test="${not empty errorAirlineId}">
                                            <div class="invalid-feedback">${errorAirlineId}</div>
                                        </c:if>
                                    </div>

                                    <!-- input ẩn để lưu và gửi iataCode -->
                                    <input type="hidden" id="flightNumber" name="flightNumber"/>


                                    <div class="form-group">
                                        <label for="destinationIslandId">Điểm đến du lịch <span class="required">*</span></label>
                                        <select class="form-control" id="destinationIslandId" name="destinationIslandId" required>
                                            <option value="">Chọn đảo...</option>
                                            <c:forEach var="island" items="${islands}">
                                                <option value="${island.islandId}"
                                                        ${ (flight!=null && flight.destinationIsland.islandId == island.islandId)
                                                           || param.destinationIslandId == island.islandId
                                                           ? 'selected' : '' }>
                                                            ${island.islandName}
                                                        </option>
                                                </c:forEach>
                                            </select>

                                            <!-- hien thi loi khi validate o ben server -->  
                                            <c:if test="${not empty errorDestinationIslandId}">
                                                <div class="invalid-feedback">${errorDestinationIslandId}</div>
                                            </c:if>
                                        </div>

                                    </div>
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="flightClass">Nơi khởi hành <span class="required">*</span></label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="departure" 
                                                   name="departure" 
                                                   value="${flight !=null ? flight.departure:param.departure }"
                                                   placeholder="Nhập nơi khởi hành ...">

                                            <!-- hien thi loi khi validate o ben server -->  
                                            <c:if test="${not empty errorDeparture}">
                                                <div class="invalid-feedback">${errorDeparture}</div>
                                            </c:if>
                                            <div class="form-text"><i class="fa fa-map-pin"></i> Khởi hành tại 2 thành phố lớn ở Việt Nam </div> 
                                        </div>
                                        <div class="form-group">
                                            <label for="ticketAvailable">Số vé còn lại <span class="required">*</span></label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="ticketAvailable" 
                                                   name="ticketAvailable" 
                                                   value="${flight !=null ? flight.ticketAvailable:param.ticketAvailable}"
                                                   placeholder="Nhập số lượng vé">

                                            <!-- hien thi loi khi validate o ben server -->  
                                            <c:if test="${not empty errorTicketAvailable}">
                                                <div class="invalid-feedback">${errorTicketAvailable}</div>
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
                                            <label for="basePrice" class="form-label">
                                                Giá vé chuyến bay  <span class="required">*</span>
                                            </label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                                <input type="number" 
                                                       class="form-control ${not empty errors.basePrice ? 'is-invalid' : ''}" 
                                                       id="basePrice" 
                                                       name="basePrice" 
                                                       value="${flight != null ? flight.basePrice : param.basePrice}"
                                                       placeholder="0"
                                                       min="0"
                                                       step="1000"
                                                       required>
                                            </div>
                                            <!-- hien thi loi khi validate o ben server -->  
                                            <c:if test="${not empty errorBasePrice}">
                                                <div class="invalid-feedback">${errorBasePrice}</div>
                                            </c:if>
                                            <div class="form-text"><i class="fa fa-money" aria-hidden="true"></i> Giá tính bằng VNĐ, phải là số không âm và lớn hơn 0</div>
                                        </div>


                                    </div>
                                    <div class="form-row">  
                                        <div class="form-group">
                                            <label for="flightType">Loại chuyến bay</label>
                                            <select class="form-control" id="flightType" name="flightType" required>
                                                <option value="">--Chọn loại chuyến bay --</option>
                                                <option value="Một chiều" ${(flight!=null && flight.flightType=='Một chiều')|| param.flightType == 'Một chiều' ? 'selected' : ''}>Một chiều</option>
                                                <option value="Khứ hồi" ${ (flight!=null && flight.flightType=='Khứ hồi') ||param.flightType == 'Khứ hồi' ? 'selected' : ''}>Khứ hồi</option>
                                            </select>

                                            <!-- hien thi loi khi validate o ben server -->   
                                            <c:if test="${not empty errorFlightType}">
                                                <div class="invalid-feedback">${errorFlightType}</div>
                                            </c:if>

                                        </div>



                                        <div class="form-group">
                                            <label for="flightClass">Hạng ghế</label>
                                            <select class="form-control ${not empty errors.flightClass? 'is-invalid' : ''}"  id="flightClass" name="flightClass" required>
                                                <option value="">-- Chọn hạng ghế vé--</option>
                                                <option value="Phổ thông" ${(flight!=null && flight.flightClass=='Phổ thông')|| param.flightClass == 'Phổ thông' ? 'selected' : ''}>Phổ thông</option>
                                                <option value="Thương gia" ${(flight!=null && flight.flightClass=='Thương gia')|| param.flightClass == 'Thương gia' ? 'selected' : ''}>Thương gia</option>
                                                <option value="Hạng nhất" ${ (flight!=null && flight.flightClass=='Hạng nhất')|| param.flightClass == 'Hạng nhất' ? 'selected' : ''}>Hạng nhất</option>
                                            </select>


                                            <!-- hien thi loi khi validate o ben server -->  
                                            <c:if test="${not empty errorFlightClass}">
                                                <div class="invalid-feedback">${errorFlightClass}</div>
                                            </c:if>

                                        </div>

                                    </div>
                                </div>              

                                <!---------- Ảnh đảo du lịch ------------------>
                                <div class="form-section">

                                    <h4><i class="fa fa-image"></i> Hình ảnh chuyến bay du lịch</h4>


                                    <div class="row">


                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="tourImageFile" class="form-label">
                                                    Tải lên hình ảnh chuyến bay
                                                </label>
                                                <input type="file" 
                                                       class="form-control ${not empty flight.destinationImageUrl ? 'is-invalid' : ''}" 
                                                       id="flightImageFile" 
                                                       name="flightImageFile" 
                                                       accept="image/*"
                                                       onchange="previewImage(this)">

                                                <c:if test="${not empty errorFlightImage}">
                                                    <div class="invalid-feedback">${errorFlightImage}</div>
                                                </c:if>
                                                <div class="form-text">Chọn file hình ảnh (JPG, PNG, GIF). Tối đa 5MB</div>
                                            </div> 

                                        </div> 

                                        <!---------- Xem trước ảnh------------------>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label">Xem trước ảnh </label>
                                                <div class="image-preview-container">
                                                    <img id="imagePreview" 
                                                         src="${flight != null && flight.destinationImageUrl != null ? pageContext.request.contextPath.concat('/').concat(flight.destinationImageUrl) : ''}" 
                                                         alt="Preview" 
                                                         style="max-width: 100%; max-height: 200px; display: ${flight != null && flight.destinationImageUrl != null ? 'block' : 'none'}; border: 1px solid #ddd; border-radius: 4px;">
                                                    <div id="noImageText" style="display: ${flight != null && flight.destinationImageUrl != null ? 'none' : 'block'}; color: #6c757d; font-style: italic;">
                                                        Chưa có hình ảnh
                                                    </div>
                                                </div>  
                                            </div>

                                        </div>
                                    </div>
                                </div>


                                <!-- Hidden field to store current image URL for edit mode -->
                                <c:if test="${flight != null && flight.destinationImageUrl != null}">
                                    <input type="hidden" name="currentImageUrl" value="${flight.destinationImageUrl}">
                                </c:if>                
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
            </div>

            <!-- Include common scripts -->
            <jsp:include page="../common/script.jsp" />

            <script>

                // Form validation
                $('#flight_ticketForm').on('submit', function (e) {
                    let isValid = true;

                    // Xóa trạng thái lỗi cũ
                    $('.form-control').removeClass('is-invalid');
                    $('.invalid-feedback').remove();

                    // --- validate các trường ---
                    const iataCode = $('#iataCode').val();
                    if (!iataCode) {
                        showFieldError('#iataCode', 'Xin vui lòng chọn mã chuyến bay');
                        isValid = false;
                    }

                    // ----- Validate departure -----
                    const departure = $('#departure').val().trim();
                    const validDepartures = [
                        'Hà Nội',
                        'Ha Noi',
                        'TP Hồ Chí Minh',
                        'TP Ho Chi Minh'
                    ];

                    if (!departure) {
                        showFieldError('#departure', 'Xin vui lòng nhập nơi khởi hành');
                        isValid = false;
                    } else if (!validDepartures.includes(departure)) {
                        showFieldError('#departure', 'Chỉ chấp nhận: Hà Nội, Ha Noi, TP Hồ Chí Minh hoặc Tp Ho Chi Minh');
                        isValid = false;
                    }


                    // ----- Validate islandId-----
                    const destinationIslandId = $('#destinationIslandId').val();
                    if (!destinationIslandId) {
                        showFieldError('#destinationIslandId', 'Vui lòng chọn điểm đến du lịch');
                        isValid = false;
                    }
                    // ----- Validate basePrice-----
                    const basePrice = $('#basePrice').val().trim();
                    if (!basePrice) {
                        showFieldError('#basePrice', 'Vui lòng nhập giá vé');
                        isValid = false;
                    } else if (isNaN(basePrice) || Number(basePrice) <= 0) {
                        showFieldError('#basePrice', 'Giá vé phải là số hợp lệ và lớn hơn 0');
                        isValid = false;
                    }
                    // ----- Validate  ticketAvailable-----
                    const ticketAvailable = $('#ticketAvailable').val().trim();
                    if (!ticketAvailable) {
                        showFieldError('#ticketAvailable', 'Xin hãy nhập số vé');
                        isValid = false;
                    } else if (Number(ticketAvailable) <= 0) {
                        showFieldError('#ticketAvailable', 'Số vé phải là số hợp lệ và lớn hơn 0');
                        isValid = false;
                    }
                    // -----  Validate flightType-----
                    const flightType = $('#flightType').val();
                    if (!flightType) {
                        showFieldError('#flightType', 'Vui lòng hãy chọn loại vé');
                        isValid = false;
                    }
                    //-----  validate flightClass-----
                    const flightClass = $('#flightClass').val();
                    if (!flightClass) {
                        showFieldError('#flightClass', 'Vui lòng hãy chọn hạng ghế');
                        isValid = false;
                    }


                    // ----- Validate Ảnh chuyến bay du lịch -----
                    const formAction = document.querySelector('input[name="action"]').value;
                    const bannerInput = document.getElementById('flightImageFile');

                    // Chỉ bắt buộc khi tạo mới (create)
                    if (formAction === 'create') {
                        if (!bannerInput.files || bannerInput.files.length === 0) {
                            showFieldError('#flightImageFile', 'Vui lòng chọn ảnh chuyến bay du lịch');
                            isValid = false;
                        }
                    }




                    // --- Cuộn đến lỗi đầu tiên ---
                    if (!isValid) {
                        e.preventDefault(); // Ngăn submit

                        // Tìm ô lỗi đầu tiên
                        const firstInvalid = $('.is-invalid').first();

                        if (firstInvalid.length > 0) {
                            // Cuộn mượt đến vị trí lỗi đầu tiên
                            $('html, body').animate({
                                scrollTop: firstInvalid.offset().top - 100
                            }, 600, function () {
                                // Focus vào ô lỗi đầu tiên sau khi cuộn xong
                                firstInvalid.focus();
                            });
                        }
                    }
                });


                // ----- Hàm helper -----
                function showFieldError(fieldSelector, message) {
                    const field = $(fieldSelector);
                    field.addClass('is-invalid');
                    field.after('<div class="invalid-feedback">' + message + '</div>');
                }

                // Chuẩn hóa (xóa dấu, lowercase, bỏ khoảng trắng đầu/cuối)
                function removeVietnameseTones(str) {
                    return str
                            .normalize('NFD')
                            .replace(/[\u0300-\u036f]/g, '')
                            .replace(/đ/g, 'd')
                            .replace(/Đ/g, 'D')
                            .trim();
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
                        reader.onload = function (e) {
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
                // xử lý input lấy data-iata ở iataCode
                document.addEventListener('DOMContentLoaded', function () {
                    const iataSelect = document.getElementById('iataCode');
                    const flightNumberInput = document.getElementById('flightNumber');

                    // Gán lại giá trị iataCode vào flightNumber khi trang load (nếu có selected)
                    const selected = iataSelect.options[iataSelect.selectedIndex];
                    if (selected) {
                        const iata = selected.getAttribute('data-iata');
                        flightNumberInput.value = iata || '';
                    }

                    // Khi người dùng chọn lại airline
                    iataSelect.addEventListener('change', function () {
                        const selected = this.options[this.selectedIndex];
                        const iata = selected.getAttribute('data-iata');
                        flightNumberInput.value = iata || '';
                    });
                });



            </script>
        </body>
    </html>