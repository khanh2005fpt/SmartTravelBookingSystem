
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
        <title>${empty flightSchedule? 'Thêm' : 'Chỉnh sửa'} Vé máy bay - Meland Travel</title>

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
            <jsp:param name="page" value="flights_schedules "/>
        </jsp:include>

        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fa fa-utensils"></i> 
                    ${empty  schedule ? 'Thêm thông tin lịch trình chuyến bay' : 'Chỉnh sửa thông tin lịch trình chuyến bay'}
                </h1>
                <p>${empty schedule ? 'Thêm những lịch trình chuyến bay trong hệ thống' : 'Cập nhật thông tin lịch trình chuyến bay'}</p>
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
                        ${empty schedule ? 'Thông tin lịch trình chuyến bay mới' : 'Chỉnh sửa thông tin lịch trình chuyến bay'}
                    </h3>
                </div>
                <form action="${pageContext.request.contextPath}/staff/flight/schedules" 
                      method="post"    
                      id="flight_scheduleForm" 
                      novalidate>
               <input type="hidden" id="action" value="${param.action}">
                    <input type="hidden" name="action" value="${empty  schedule ? 'create' : 'update'}">
 
                    <c:if test="${ schedule!= null}">
                        <input type="hidden" name="scheduleId" value="${ schedule.scheduleId}">
                    </c:if> 

                    <div class="form-content">
                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-info-circle"></i> Thông tin cơ bản
                            </h4>

                            <div class="form-row">
         <div class="form-group">
             <c:choose>
                 <c:when test="${param.action == 'create'}">
                     <label for="flightId">Mã định danh chuyến bay *</label>
                     <select class="form-control ${not empty errors.flightId ? 'is-invalid' : ''}" 
                             id="flightId" 
                             name="flightId"
                             required>
                         <option value="">Chọn mã định danh...</option>
                         <c:forEach var="f" items="${flights}">
                             <option value="${f.flightId}"
                                     data-departure="${f.departure}"
                                     data-destination="${f.destination}"
                                     data-flight-type="${f.flightType}"
                                     <c:if test="${schedule != null && schedule.flight.flightId == f.flightId}">
                                         selected
                                     </c:if>>
                                 Mã số ${f.flightId} : ${f.departure} → ${f.destination} (${f.flightType})
                             </option>
                         </c:forEach>
                     </select>
                 </c:when>

                 <c:otherwise>
                     <div class="mb-3">
                         <label><i class="fa fa-map-pin"></i> Mã lịch trình</label>
                         <input type="text" 
                                class="form-control" 
                                value="Đang chỉnh sửa Mã lịch trình chuyến bay số ${schedule.scheduleId}" 
                                readonly>
                     </div>
                                   <input type="hidden" name="flightId" value="${schedule.scheduleId}">
                 </c:otherwise>

             </c:choose>
             <input type="hidden" id="flightType" name="flightType" value="">

             <c:if test="${not empty errorFlightId}">
                 <div class="invalid-feedback">${errorFlightId}</div>
             </c:if>
                        </div>


                                <div class="form-group">
                                    <!-- Notes -->
                                    <label for="notes">Notes<span class="required">*</span></label>
                                    <textarea name="notes" id="notes" rows="6" class="form-control w-50" 
                                        >${param.notes != null ? param.notes : (schedule != null ? schedule.notes : 
                                        'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.')}</textarea>
                                </div>

                            </div>
                            <div class="form-row">



                                <div class="form-group">
                                    <label  for="departureAirport">Sân bay khởi hành<span class="required">*</span></label>
                                    <select class="form-control" name="departureAirport" id="departureAirport" required>
                                        <option value="">--Chọn sân bay---</option>
                                        <option value="Nội Bài (HAN)"${(schedule!=null && schedule.departureAirport=='Nội Bài (HAN)') || param.departureAirport=='Nội Bài (HAN)' ? 'selected' : ''}>Nội Bài (HAN)</option>
                                        <option value="Tân Sơn Nhất (SGN)"${(schedule!=null && schedule.departureAirport=='Tân Sơn Nhất (SGN)') || param.departureAirport=='Tân Sơn Nhất (SGN)' ? 'selected' : ''}>Tân Sơn Nhất (SGN)</option>
                                    </select>

                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorDepartureAirport}">
                                        <div class="invalid-feedback">${errorDepartureAirport}</div>
                                    </c:if>
                                </div>

                                <div class="form-group">
                                    <!-- Arrival Airport -->
                                    <label for="arrivalAirport">Sân bay đến<span class="required">*</span></label>
                                    <select class="form-control" id="arrivalAirport" name="arrivalAirport" required>
                                        <option value="">Chọn sân bay....</option>
                                        <option value="Phú Quốc (PQC)"${( schedule!=null && schedule.arrivalAirport=='Phú Quốc (PQC)') || param.arrivalAirport=='Phú Quốc (PQC)' ? 'selected' : ''}>Phú Quốc (PQC)</option>
                                        <option value="Langkawi (LGK)"${( schedule!=null && schedule.arrivalAirport=='Langkawi (LGK)') || param.arrivalAirport=='Langkawi (LGK)' ? 'selected' : ''}>Langkawi (LGK)</option>
                                        <option value="Phuket (HKT)"${( schedule!=null && schedule.arrivalAirport=='Phuket (HKT)') || param.arrivalAirport=='Phuket (HKT)' ? 'selected' : ''}>Phuket (HKT)</option>
                                        <option value="Bali (DPS)"${( schedule!=null && schedule.arrivalAirport=='Bali (DPS)') || param.arrivalAirport=='Bali (DPS)' ? 'selected' : ''}>Bali (DPS)</option>
                                        <option value="Boracay (MPH)"${(schedule!=null && schedule.arrivalAirport=='Boracay (MPH)') || param.arrivalAirport=='Boracay (MPH)' ? 'selected' : ''}>Boracay (MPH)</option>
                                        <option value="Sihanoukville (KOS)"${(schedule!=null && schedule.arrivalAirport=='Sihanoukville (KOS)') || param.arrivalAirport=='Sihanoukville (KOS)' ? 'selected' : ''}>Sihanoukville (KOS)</option>
                                        <option value="Tioman (TOD)"${(schedule!=null && schedule.arrivalAirport=='Tioman (TOD)') || param.arrivalAirport=='Tioman (TOD)' ? 'selected' : ''}>Tioman (TOD)</option>
                                        <option value="Koh Samui (USM)"${( schedule!=null && schedule.arrivalAirport=='Koh Samui (USM)') || param.arrivalAirport=='Koh Samui (USM)' ? 'selected' : ''}>Koh Samui (USM)</option>
                                        <option value="Nusa Penida (NDP)"${( schedule!=null && schedule.arrivalAirport=='Nusa Penida (NDP)') || param.arrivalAirport=='Nusa Penida (NDP)' ? 'selected' : ''}>Nusa Penida (NDP)</option>
                                        <option value="Palawan (PPS)"${( schedule!=null && schedule.arrivalAirport=='Palawan (PPS)') || param.arrivalAirport=='Palawan (PPS)' ? 'selected' : ''}>Palawan (PPS)</option>
                                        
                                    </select>

                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorArrivalAirport}">
                                        <div class="invalid-feedback">${errorArrivalAirport}</div>
                                    </c:if>

                                </div>     

                            </div>

                        </div>

                        <!-- Location Information Section -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-map-marker-alt"></i>1. Thông tin về thời gian chuyến bay
                            </h4>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="departureTime">Giờ khởi hành <span class="required">*</span></label>
                                    <input type="time" 
                                           class="form-control" 
                                           id="departureTime" 
                                           name="departureTime"
                                           value="${param.departureTime != null ? param.departureTime : (schedule != null ? schedule.departureTime : '')}">


                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorDepartureTime}">
                                        <div class="invalid-feedback">${errorDepartureTime}</div>
                                    </c:if>

                                </div>
                                <div class="form-group">
                                    <label for="arrivalTime">Giờ hạ cánh <span class="required">*</span></label>
                                    <input type="time" 
                                           class="form-control" 
                                           id="arrivalTime" 
                                           name="arrivalTime"
                                           value="${param.arrivalTime != null ? param.arrivalTime : (schedule != null ? schedule.arrivalTime : '')}">

                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorArrivalTime}">
                                        <div class="invalid-feedback">${errorArrivalTime}</div>
                                    </c:if>

                                </div>

                            </div>
                            <h4 class="section-title text-info">
                                <i class="fa fa-map-marker-alt"></i>2. Thông tin về thời gian Khứ Hồi (Nếu có)
                            </h4>
                            <div class="form-row">  

                                <div class="form-group">
                                    <label for="returnDepartureTime">Giờ khởi hành về <span class="required">*</span></label>
                                   <input type="time" 
                                          class="form-control" 
                                          id="returnDepartureTime" 
                                          name="returnDepartureTime" 
                                           value="${param.returnDepartureTime != null ? param.returnDepartureTime : (schedule != null ? schedule.returnDepartureTime: '')}">

                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorReturnDepartureTime}">
                                        <div class="invalid-feedback">${errorReturnDepartureTime}</div>
                                    </c:if>

                                </div>

                                <div class="form-group">
                                    <label for="returnArrivalTime">Giờ hạ cánh về <span class="required">*</span></label>
                                    <input type="time" 
                                           class="form-control" 
                                           id="returnArrivalTime" 
                                           name="returnArrivalTime"
                                           value="${param.returnArrivalTime != null ? param.returnArrivalTime : (schedule != null ? schedule.returnArrivalTime : '')}">
                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorReturnArrivalTime}">
                                        <div class="invalid-feedback">${errorReturnArrivalTime}</div>
                                    </c:if>

                                </div>

                            </div>
                        </div>              

                        <!----------Transit ------------------>
                        <div class="form-section">
                            <h4 class="section-title text-info">
                                <i class="fa fa-map-marker-alt"></i>3. Thông tin về sân bay quá cảnh(Nếu có)
                            </h4>

                            <div class="form-row">  

                                <div class="form-group">
                                    <label for="transitAirport">Sân bay quả cảnh<span class="required">*</span></label>
                                    <select class="form-control" name="transitAirport" id="transitAirport">
                                        <option value="">Chọn sân bay...</option>
                                        <option value="Kuala Lumpur (KUL)"${(schedule != null && schedule.transitAirport=='Kuala Lumpur (KUL)') || param.transitAirport=='Kuala Lumpur (KUL)' ? 'selected' : ''}>Kuala Lumpur (KUL)</option>
                                        <option value="Bangkok (BKK)"${(schedule != null && schedule.transitAirport=='Bangkok (BKK)') || param.transitAirport=='Bangkok (BKK)' ? 'selected' : ''}>Bangkok (BKK)</option>
                                        <option value="Jakarta (CGK)"${(schedule != null && schedule.transitAirport=='Jakarta (CGK)') || param.transitAirport=='Jakarta (CGK)' ? 'selected' : ''}>Jakarta (CGK)</option>
                                        <option value="Manila (MNL)"${(schedule!= null && schedule.transitAirport=='Manila (MNL)') || param.transitAirport=='Manila (MNL)' ? 'selected' : ''}>Manila (MNL)</option>
                                        <option value="Phnom Penh (PNH)"${(schedule != null && schedule.transitAirport=='Phnom Penh (PNH)') || param.transitAirport=='Phnom Penh (PNH)' ? 'selected' : ''}>Phnom Penh (PNH)</option>
                                    </select>

                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorTransitAirport}">
                                        <div class="invalid-feedback">${errorTransitAirport}</div>
                                    </c:if>

                                </div>

                                <div class="form-group">
                                    <label for="transitDuration">Thời gian quá cảnh<span class="required">*</span></label>
                                    <input type="text" class="form-control" name="transitDuration" id="transitDuration" 
                                           placeholder="e.g. 1h20"
                                           value="${schedule!= null ? schedule.transitDuration : (param.transitDuration != null ? param.transitDuration : '')}" 
                                           >
                                    <!-- hien thi loi khi validate o ben server -->  
                                    <c:if test="${not empty errorTransitDuration}">
                                        <div class="invalid-feedback">${errorTransitDuration}</div>
                                    </c:if>

                                </div>

                            </div>

                        </div>


                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/staff/flight/schedules?action=list" class="btn-action btn-secondary">
                                <i class="fa fa-times"></i> Hủy
                            </a>
                            <button type="submit" class="btn-action btn-primary">
                                <i class="fa fa-save"></i> 
                                ${empty schedule ? 'Tạo thông tin lịch trình chuyến bay' : 'Cập nhật'}
                            </button>
                        </div>
                </form>
            </div>

        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />
    <script>
        $('#flight_scheduleForm').on('submit', function (e) {
            let isValid = true;

            // Xóa lỗi cũ
            $('.form-control').removeClass('is-invalid');
            $('.invalid-feedback').remove();

            // ===== Validate các trường cơ bản =====
            const flightId = $('#flightId').val();
            const action = document.getElementById('action').value;
            const notes = $('#notes').val().trim();
            const departureAirport = $('#departureAirport').val() || '';
            const arrivalAirport = $('#arrivalAirport').val() || '';
            const departureTime = $('#departureTime').val();
            const arrivalTime = $('#arrivalTime').val();
            const returnDepartureTime = $('#returnDepartureTime').val() || '';
            const returnArrivalTime = $('#returnArrivalTime').val() || '';
            const transitAirport = $('#transitAirport').val();
            const transitDuration = $('#transitDuration').val().trim();
            

            if (action === 'create') { // chỉ validate khi tạo mới
           if (!flightId) {
        showFieldError('#flightId', 'Xin vui lòng chọn mã định danh chuyến bay');
        isValid = false;
              }
            }
            if (!notes) {
                showFieldError('#notes', 'Vui lòng nhập ghi chú');
                isValid = false;
            } else if (notes.length < 5) {
                showFieldError('#notes', 'Ghi chú phải dài ít nhất 5 ký tự');
                isValid = false;
            } else if (!/^[a-zA-ZÀ-ỹ0-9\s,.\-()!?]+$/.test(notes)) {
                showFieldError('#notes', 'Ghi chú chỉ được chứa chữ, số và dấu câu thông thường');
                isValid = false;
            }

            if (!departureAirport) {
                showFieldError('#departureAirport', 'Vui lòng chọn sân bay khởi hành');
                isValid = false;
            }

            if (!arrivalAirport) {
                showFieldError('#arrivalAirport', 'Vui lòng chọn sân bay hạ cánh');
                isValid = false;
            }

            if (!departureTime) {
                showFieldError('#departureTime', 'Vui lòng hãy chọn thời gian khởi hành');
                isValid = false;
            }

            if (!arrivalTime) {
                showFieldError('#arrivalTime', 'Vui lòng hãy chọn thời gian hạ cánh');
                isValid = false;
            }

            // ===== Kiểm tra mapping giữa chuyến bay & sân bay =====
            if (flightId) {
                const airportMapping = {
                    'Hà Nội': 'Nội Bài (HAN)',
                    'Ha Noi': 'Nội Bài (HAN)',
                    'TP Ho Chi Minh': 'Tân Sơn Nhất (SGN)',
                    'TP Hồ Chí Minh': 'Tân Sơn Nhất (SGN)'
                };

                const selectedOption = $('#flightId option:selected');

                // --- sân bay khởi hành ----
                const expectedDepartureFull = selectedOption.data('departure') || '';
                const expectedDepartureCity = expectedDepartureFull.split(' (')[0].trim();
                const validDepartureAirport = airportMapping[expectedDepartureCity];

                if (validDepartureAirport && departureAirport !== validDepartureAirport) {
                    showFieldError(
                            '#departureAirport',
                            `Vui lòng chọn đúng sân bay tương ứng với điểm khởi hành`
                            );
                    isValid = false;
                }

                // --- sân bay hạ cánh -----
                const expectedDestinationFull = selectedOption.data('destination') || '';
                const expectedDestinationCity = expectedDestinationFull.split(' (')[0].trim();
                const arrivalCity = arrivalAirport.split(' (')[0].trim();

                if (arrivalCity && arrivalCity !== expectedDestinationCity) {
                    showFieldError(
                            '#arrivalAirport',
                            `Sân bay hạ cánh phải khớp với điểm đến của chuyến bay`
                            );
                    isValid = false;
                }

                // --- Nếu là chuyến khứ hồi thì bắt nhập giờ khứ hồi ---
                const flightType = selectedOption.data('flightType') || '';

               if (flightType === 'Khứ hồi') {
    $('#returnDepartureTime, #returnArrivalTime').prop('disabled', false);
    // Validate luôn
    if (!returnDepartureTime) {
        showFieldError('#returnDepartureTime', 'Vui lòng nhập giờ khởi hành chuyến về');
        isValid = false;
    }
    if (!returnArrivalTime) {
        showFieldError('#returnArrivalTime', 'Vui lòng nhập giờ hạ cánh chuyến về');
        isValid = false;
    }
} else {
    $('#returnDepartureTime, #returnArrivalTime').prop('disabled', true).val('');
}

            }
            // ===== Transit airport & duration (không bắt buộc) =====
            if (transitAirport) {
                // Nếu transitAirport nhập, transitDuration bắt buộc
                if (!transitDuration) {
                    showFieldError('#transitDuration', 'Vui lòng nhập thời gian quá cảnh');
                    isValid = false;
                } else if (!/^(\d+h(\d{1,2})?|\d+\s*(phút|m))$/i.test(transitDuration)) {
                    showFieldError('#transitDuration', 'Thời gian quá cảnh phải theo định dạng 1h20 hoặc 10 phút');
                    isValid = false;
                }
            }

        if (transitDuration) {
    // Nếu transitDuration nhập mà transitAirport trống
    if (!transitAirport) {
        showFieldError('#transitAirport', 'Vui lòng chọn sân bay quá cảnh');
        isValid = false;
    } else if (!/^(\d+[hH](\d{1,2})?\s*(phút|m)?|\d+\s*(phút|m))$/i.test(transitDuration.trim())) {
        showFieldError('#transitDuration', 'Thời gian quá cảnh phải theo định dạng 1h, 1h20, 1h45 phút, 45 phút, 30m, ...');
        isValid = false;
    }
}

            // ===== Cuộn đến lỗi đầu tiên =====
            if (!isValid) {
                e.preventDefault();
                const firstInvalid = $('.is-invalid').first();
                if (firstInvalid.length > 0) {
                    $('html, body').animate({
                        scrollTop: firstInvalid.offset().top - 100
                    }, 600, function () {
                        firstInvalid.focus();
                    });
                }
            }
        });
        
          // ===== Cập nhật hidden flightType khi chọn flight =====
    $('#flightId').on('change', function () {
        const flightType = $('#flightId option:selected').data('flight-type') || '';
        $('#flightType').val(flightType);
    });

    // Khi load lại trang (edit), giữ nguyên flightType
    const initialFlightType = $('#flightId option:selected').data('flight-type');
    if (initialFlightType) {
        $('#flightType').val(initialFlightType);
    }


        // ===== Helper hiển thị lỗi =====
        function showFieldError(fieldSelector, message) {
            const field = $(fieldSelector);
            field.addClass('is-invalid');
            field.after('<div class="invalid-feedback">' + message + '</div>');
        }
        
    
    </script>

</body>
</html>