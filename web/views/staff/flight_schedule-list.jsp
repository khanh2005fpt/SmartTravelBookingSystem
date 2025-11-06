
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý chuyến bay - MelandBooking Travel</title>

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

            .controls-section {
                background: white;
                padding: 25px;
                border-radius: 15px;
                margin-bottom: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }

            .search-filters {
                display: flex;
                gap: 15px;
                align-items: end;
                flex-wrap: wrap;
            }

            .filter-group {
                flex: 1;
                min-width: 200px;
            }

            .filter-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 600;
                color: #333;
            }

            .form-control {
                border-radius: 8px;
                border: 2px solid #e9ecef;
                padding: 10px 15px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

            .btn-searchSchedule {
                background: linear-gradient(180deg, #0077b6, #00b4d8);
                color: white;
                border: none;
                padding: 10px 25px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                height: fit-content;
            }

            .btn-searchSchedule:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
                color: white;
            }

            .btn-add {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 10px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-add:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
                color: white;
                text-decoration: none;
            }

            .restaurants-container {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .restaurants-header {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                padding: 20px 25px;
                border-bottom: 1px solid #dee2e6;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .restaurants-title {
                font-size: 1.25em;
                font-weight: 600;
                color: #333;
                margin: 0;
            }

            .restaurants-count {
                background: #667eea;
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.9em;
                font-weight: 600;
            }

            .table-responsive {
                max-height: 600px;
                overflow-y: auto;
            }

            .restaurants-table {
                width: 100%;
                margin: 0;
            }

            .restaurants-table th {
                background: #f8f9fa;
                color: #333;
                font-weight: 600;
                padding: 15px;
                border: none;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .restaurants-table td {
                padding: 15px;
                border-bottom: 1px solid #f1f3f4;
                vertical-align: middle;
            }

            .restaurants-table tbody tr {
                transition: all 0.3s ease;
            }

            .restaurants-table tbody tr:hover {
                background-color: #f8f9fa;
                transform: scale(1.01);
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .restaurant-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                border: 2px solid #e9ecef;
            }

            .restaurant-name {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }

            .restaurant-cuisine {
                color: #6c757d;
                font-size: 0.9em;
            }

            .restaurant-rating {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .rating-stars {
                color: #ffc107;
            }

            .rating-value {
                font-weight: 600;
                color: #333;
            }

            .restaurant-price {
                font-weight: 700;
                color: #28a745;
                font-size: 1.1em;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }

            .btn-action {
                padding: 6px 12px;
                border-radius: 6px;
                border: none;
                font-size: 0.85em;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .btn-view {
                background: #17a2b8;
                color: white;
            }

            .btn-view:hover {
                background: #138496;
                color: white;
                text-decoration: none;
            }

            .btn-edit {
                background: #ffc107;
                color: #212529;
            }

            .btn-edit:hover {
                background: #e0a800;
                color: #212529;
                text-decoration: none;
            }

            .btn-delete {
                background: #dc3545;
                color: white;
            }

            .btn-delete:hover {
                background: #c82333;
                color: white;
                text-decoration: none;
            }

            .pagination-wrapper {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                margin-top: 30px;
                width: 100%;
            }

            .pagination {
                justify-content: center;
                margin: 0;
            }

            .page-link {
                border-radius: 8px;
                margin: 0 3px;
                border: none;
                color: #00ACD4;
                font-weight: 500;
            }

            .page-link:hover {
                background: #007CB9;
                color: white;
            }

            .page-item.active .page-link {
                background: #00ACD4;
                border-color: #007CB9;
            }
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 4em;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .empty-state h3 {
                margin-bottom: 10px;
                color: #495057;
            }

            .alert {
                border-radius: 10px;
                border: none;
                padding: 15px 20px;
                margin-bottom: 20px;
            }

            .flight-card {
                transition: all 0.25s ease;
                border-radius: 12px;
                padding-bottom: 10px;
                height: 100%;

            }

            .flight-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.12);
            }

            /* Giãn cách dọc giữa các hàng card */
            .row.flight-list-row {
                margin-top: 10px;
                margin-bottom: 10px;
                row-gap: 40px !important;   /* Khoảng cách giữa các hàng */
            }

            /* Đảm bảo 4 card / hàng ở màn hình lớn */
            .col-lg-3 {
                flex: 0 0 25%;
                max-width: 25%;
            }

            /* Giữ căn giữa nếu thiếu card ở hàng cuối */
            .row.flight-list-row {
                justify-content: flex-start;  /* hoặc center nếu muốn căn giữa */
            }

            .text-flight {
                color: #1976d2 !important;
            }




            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 20px;
                }

                .search-filters {
                    flex-direction: column;
                }

                .filter-group {
                    min-width: 100%;
                }

                .restaurants-table {
                    font-size: 0.9em;
                }

                .restaurants-table th,
                .restaurants-table td {
                    padding: 10px 8px;
                }

                .action-buttons {
                    flex-direction: column;
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
            <jsp:param name="page" value="flightSchedules" />
        </jsp:include>

        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header ">
                <h1><i class="fa fa-plane"></i></i> Quản lý chuyến bay MelanBooking</h1>
                <p class="flights-title text-white">
                    <i class="fa fa-list"></i> Danh sách lịch trình chuyến bay : <span class="flights-count text-white small">
                        ${not empty flightSchedules ? flightSchedules.size() : 0}  lịch trình
                    </span>
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

            <!-- Search and Filter Controls -->
            <div class="controls-section">
                <form action="${pageContext.request.contextPath}/staff/flight/schedules" method="get" class="search-filters">
                    <input type="hidden" name="action" value="search">

                    <div class="filter-group">
                        <label for="search">Tìm kiếm</label>
                        <input type="text" 
                               class="form-control" 
                               id="search" 
                               name="search" 
                               value="${param.search}"
                               placeholder="Sân bay khởi hành và đến , Transit....">
                    </div>

                    <div class="filter-group">
                        <label for="flightType">Loại chuyến bay</label>
                        <select class="form-control" id="flightType" name="flightType" >
                            <option value="">--Chọn loại chuyến bay --</option>
                            <option value="Một chiều" ${(flightflightSchedules!=null && flightflightSchedules.flight.flightType=='Một chiều')|| param.flightType == 'Một chiều' ? 'selected' : ''}>Một chiều</option>
                            <option value="Khứ hồi" ${(flightflightSchedules!=null && flightflightSchedules.flight.flightType =='Khứ hồi') || param.flightType == 'Khứ hồi' ? 'selected' : ''}>Khứ hồi</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label for="departureTimeRange">Khung giờ khởi hành</label>
                        <select class="form-control" id="departureTimeRange" name="departureTimeRange">
                            <option value="">-- Tất cả khung giờ --</option>

                            <option value="00:00-03:00" ${param.departureTimeRange == '00:00-03:00' ? 'selected' : ''}>
                                00:00 - 03:00 
                            </option>

                            <option value="03:00-06:00" ${param.departureTimeRange == '03:00-06:00' ? 'selected' : ''}>
                                03:00 - 06:00 
                            </option>

                            <option value="06:00-09:00" ${param.departureTimeRange == '06:00-09:00' ? 'selected' : ''}>
                                06:00 - 09:00 
                            </option>

                            <option value="09:00-12:00" ${param.departureTimeRange == '09:00-12:00' ? 'selected' : ''}>
                                09:00 - 12:00 
                            </option>

                            <option value="12:00-15:00" ${param.departureTimeRange == '12:00-15:00' ? 'selected' : ''}>
                                12:00 - 15:00 
                            </option>

                            <option value="15:00-18:00" ${param.departureTimeRange == '15:00-18:00' ? 'selected' : ''}>
                                15:00 - 18:00 
                            </option>

                            <option value="18:00-21:00" ${param.departureTimeRange == '18:00-21:00' ? 'selected' : ''}>
                                18:00 - 21:00 
                            </option>

                            <option value="21:00-23:59" ${param.departureTimeRange == '21:00-23:59' ? 'selected' : ''}>
                                21:00 - 23:59 
                            </option>
                        </select>

                    </div>
                    <button type="submit" class="btn-searchSchedule">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                    <!-- Thông tin + nút thêm vé -->
                    <div class="d-flex align-items-center ms-auto gap-3" style="margin-top: 25px; margin-right: 10px;">
                        <a href="${pageContext.request.contextPath}/staff/flight/schedules?action=create" class="btn btn-add btn-success btn-sm d-flex align-items-center"
                           style="height: 50px;">
                            <i class="fa fa-plus me-2"></i> Thêm lịch trình cho chuyến bay
                        </a>

                    </div>                    
                </form>
            </div>


            <!-- flightSchedules List ------------------------------------->

            <div class="row g-3 flight-list-row">
                <c:choose>
                    <c:when test="${not empty flightSchedules}">
                        <c:forEach var="s" items="${flightSchedules}">
                            <div class="col-lg-3 col-md-4 col-sm-6">
                                <div class="card shadow-sm border-0 rounded-3 flight-card h-100">
                                    <div class="card-body p-3 ">
                                        <div class="card-header d-flex flex-column align-items-center"
                                             style="background: linear-gradient(135deg, #2196f3, #1976d2);
                                             color: #ffffff;
                                             border: none;
                                             border-radius: 10px;
                                             padding: 16px 16px;">
                                            <h6 class="fw-bold mb-1" style="font-size: 18px;">
                                                ${s.flight.flightNumber} - ${s.planeModel}
                                            </h6>
                                            <p class="small mb-0" style="opacity: 0.8;">
                                                ${s.departureAirport} → ${s.arrivalAirport}
                                            </p>
                                        </div>


                                        <!-- Giờ khởi hành -->
                                        <div class="row text-center border-top border-bottom py-2 my-2">
                                            <div class="col-5">
                                                <h6 class="fw-bold mb-0" style="color: #1976d2;">${s.departureTime}</h6>
                                                <small>${s.departureAirport}</small>
                                            </div>
                                            <div class="col-2 d-flex align-items-center justify-content-center">
                                                <i class="fa fa-plane" style="color: #1976d2;"></i>
                                            </div>
                                            <div class="col-5">
                                                <h6 class="fw-bold mb-0" style="color: #1976d2;">${s.arrivalTime}</h6>
                                                <small>${s.arrivalAirport}</small>
                                            </div>
                                        </div>


                                        <!-- Chiều về -->
                                        <c:if test="${not empty s.returnDepartureTime}">
                                            <div class="row text-center border-top border-bottom py-2 my-2 bg-light rounded-3">
                                                <div class="col-5">
                                                    <h6 class="text-secondary fw-bold mb-0">${s.returnDepartureTime}</h6>
                                                    <small>${s.arrivalAirport}</small>
                                                </div>
                                                <div class="col-2 d-flex align-items-center justify-content-center">
                                                    <i class="fa fa-plane text-secondary" style="transform: rotate(180deg);"></i>
                                                </div>
                                                <div class="col-5">
                                                    <h6 class="text-secondary fw-bold mb-0">${s.returnArrivalTime}</h6>
                                                    <small>${s.departureAirport}</small>
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Transit -->
                                        <c:if test="${not empty s.transitAirport}">
                                            <p class="small mb-2">
                                                <i class="bi bi-clock-history me-1" style="color: #1976d2; font-size: 1.1rem;"></i>
                                                Trung chuyển tại: <strong>${s.transitAirport}</strong> - <strong>(${s.transitDuration})</strong>
                                            </p>
                                        </c:if>

                                        <!-- Notes -->
                                        <c:if test="${not empty s.cabinBaggage}">
                                            <p class="small fst-italic mb-3">
                                                <i class="bi bi-suitcase me-1" style="color: #1976d2; font-size: 1.05rem;"></i>
                                                Hành lý xách tay cho phép : <strong>${s.cabinBaggage} </strong> - <strong>${s.flight.flightClass}</strong>
                                            </p>
                                        </c:if>

                                        <c:if test="${not empty s.seatCapacity}">
                                            <p class="small fst-italic mb-3">
                                                <i class="bi bi-person-lines-fill me-1" style="color: #1976d2; font-size: 1.05rem;"></i>
                                                Sức chứa : <strong>${s.seatCapacity} ghế </strong> 
                                            </p>
                                        </c:if>

                                        <!-- Notes -->
                                        <c:if test="${not empty s.notes}">
                                            <p class="small fst-italic mb-3">
                                                <i class="bi bi-chat-left-text me-1" style="color: #1976d2; font-size: 1.05rem;"></i>
                                                ${s.notes}
                                            </p>
                                        </c:if>
                                        <!-- Vạch ngăn cách trước nút -->
                                        <hr class="my-3" style="border-top: 1px solid #ddd;">
                                        <div class="d-flex justify-content-end mt-4 " style="gap: 12px;">
                                            <a href="${pageContext.request.contextPath}/staff/flight/schedules?action=edit&scheduleId=${s.scheduleId}"
                                               class="btn btn-outline-primary rounded-3 px-3 py-1">
                                                <i class="fa fa-edit me-1"></i> Sửa
                                            </a>

                                            <a href="#"
                                               onclick="confirmDelete(${s.scheduleId}, ${s.flight.flightId}, '${s.flight.flightNumber}')"
                                               class="btn btn-outline-danger rounded-3 px-3 py-1">
                                                <i class="fa fa-trash me-1"></i> Xóa
                                            </a>

                                        </div>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>


                        <!-- Pagination -->
                        <c:if test = "${totalPages>1}">
                            <div class ="pagination-wrapper">
                                <nav aria-label="FlightSchedule pagination">
                                    <ul class="pagination">
                                        <!-- Previous Page -->  
                                        <c:if test="${currentPage>1}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${param.search}">
                                                    <i class="fa fa-chevron-left"></i> Trước
                                                </a>  
                                            </li>
                                        </c:if>

                                        <!-- Page Numbers --> 
                                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}&search=${param.search}">
                                                    ${pageNum}
                                                </a>
                                            </li>
                                        </c:forEach>

                                        <!-- Next Page --> 
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${param.search}">
                                                    Sau <i class="fa fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </c:if>

                                    </ul>

                                </nav>
                                <div class="text-center mt-3">
                                    <small class="text-muted">
                                        Hiển thị ${(currentPage - 1) * pageSize + 1} - 
                                        ${currentPage * pageSize > totalFlightSchedules ? totalFlightSchedules : currentPage * pageSize} 
                                        trong tổng số ${totalFlightSchedules} Lịch trình chuyến bay bay
                                    </small>
                                </div>

                            </div>

                        </c:if>

                    </c:when>
                    <c:otherwise>


                        <div class="empty-state d-flex flex-column align-content-center align-items-center">
                            <i class="fa fa-map-marker"></i>
                            <h3>Không có lịch trình máy bay nào</h3>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty param.search}">
                                        Không tìm thấy lịch trình nào với từ khóa "${param.search}"
                                    </c:when>
                                    <c:otherwise>
                                        Chưa có lịch trình máy bay nào được thêm . Hãy tạo thêm lịch trình đầu tiên!
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <a href="${pageContext.request.contextPath}/staff/flight/schedules?action=create"
                               class="btn btn-add btn-success mt-3">
                                <i class="fa fa-plus"></i> Thêm lịch trình máy bay mới
                            </a>
                        </div>

                    </c:otherwise> 

                </c:choose>


            </div>



            <!-- Include common scripts -->
            <jsp:include page="../common/script.jsp" />

            <!-- Delete Confirmation Modal -->
            <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title ">⚠️ Xác nhận xóa lịch trình chuyến bay</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn xóa lịch trình bay mã số : "<strong id="flightNumberToDelete"></strong>" ?</p>
                            <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <form id="deleteForm" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="scheduleId" id="scheduleIdToDelete">
                                <input type="hidden" name="flightId" id="flightIdToDelete">
                                <button type="submit" class="btn btn-danger">Xóa</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <script>
                function confirmDelete(scheduleId, flightId, flightNumber) {
                    document.getElementById('scheduleIdToDelete').value = scheduleId;
                    document.getElementById('flightIdToDelete').value = flightId;
                    document.getElementById('flightNumberToDelete').textContent = flightNumber;
                    document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/flight/schedules';
                    $('#deleteModal').modal('show');
                }
                // Auto-hide alerts after 5 seconds
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);

                // Enhanced search functionality
                $(document).ready(function () {
                    // Auto-submit search form on select change
                    $('#cuisineType, #islandId').on('change', function () {
                        $(this).closest('form').submit();
                    });

                    // Search input with debounce
                    let searchTimeout;
                    $('#search').on('input', function () {
                        clearTimeout(searchTimeout);
                        searchTimeout = setTimeout(function () {
                            // Auto-submit after 1 second of no typing
                        }, 1000);
                    });
                });
            </script>

            <!-- Modal thông báo action khi thành công -->
            <div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content text-center shadow-lg border-0 rounded-4 overflow-hidden">

                        <!-- Header xanh lá -->
                        <div class="modal-header bg-success text-white justify-content-center py-3">
                            <h5 class="modal-title fw-bold text-uppercase text-white letter-spacing-1" id="successModalLabel">
                                🎉 Thao tác thành công!
                            </h5>
                        </div>

                        <!-- Nội dung -->
                        <div class="modal-body fs-5 text-secondary py-4">
                            ✈️ Lịch trình chuyến bay của bạn đã được <strong class="text-success fw-bold">${param.success}</strong> thành công!<br>
                            <strong class="text-dark">ID Lịch trình chuyến bay:</strong> ${param.scheduleId}
                        </div>

                        <!-- Footer -->
                        <div class="modal-footer justify-content-center border-0 pb-4">
                            <button type="button" class="btn btn-success px-4 fw-semibold" id="btnOk" data-bs-dismiss="modal">
                                <i class="fa fa-check-circle me-2"></i> OK
                            </button>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Script bật modal -->
            <c:if test="${param.success == 'created' || param.success == 'updated' || param.success == 'deleted'}">
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const modal = new bootstrap.Modal(document.getElementById('notificationModal'));
                        modal.show();
                        document.getElementById("btnOk").addEventListener("click", function () {
                            modal.hide();
                        });
                    });
                </script>
            </c:if>
    </body>
</html>