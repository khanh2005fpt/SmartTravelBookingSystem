
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

            .btn-search {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 10px 25px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                height: fit-content;
            }

            .btn-search:hover {
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

            .pagination-container {
                padding: 20px 25px;
                background: #f8f9fa;
                border-top: 1px solid #dee2e6;
            }

            .pagination {
                margin: 0;
                justify-content: center;
            }

            .page-link {
                border-radius: 8px;
                margin: 0 2px;
                border: 2px solid #e9ecef;
                color: #667eea;
                font-weight: 600;
            }

            .page-link:hover {
                background-color: #667eea;
                border-color: #667eea;
                color: white;
            }

            .page-item.active .page-link {
                background-color: #667eea;
                border-color: #667eea;
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
    <body>
        <!-- Include Sidebar -->
        <jsp:include page="sidebar.jsp">
            <jsp:param name="page" value="flights" />
        </jsp:include>

        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header ">
                <h1><i class="fa fa-utensils  text-left"></i> Quản lý chuyến bay MelanBooking</h1>
               <p class="flights-title text-white">
                                <i class="fa fa-list"></i> Danh sách dịch vụ vé máy bay : <span class="flights-count text-white small">
                ${not empty flights ? flights.size() : 0}  vé máy bay
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
                <form action="${pageContext.request.contextPath}/staff/flight/tickets" method="get" class="search-filters d-flex align-items-center gap-3 flex-wrap">
                    <input type="hidden" name="action" value="search">

                    <!-- Ô tìm kiếm -->
                    <div class="filter-group flex-fill" style="min-width: 180px;">
                        <label for="search" class="form-label mb-1 fw-semibold">Tìm kiếm</label>
                        <input type="text" 
                               class="form-control form-control-sm" 
                               id="search" 
                               name="search" 
                               value="${param.search}"
                               placeholder="Chuyến bay, loại vé, điểm đến , hạng ghế.......">
                    </div>

                    <!-- Filter hãng bay -->
                    <div class="filter-group" style="min-width: 180px;">
                        <label for="airlineId" class="form-label mb-1 fw-semibold">Hãng bay</label>
                        <select class="form-control form-control-sm" id="airlineId" name="airlineId">
                            <option value="">Tất cả các hãng</option>
                            <c:forEach var="airline" items="${airlineNames}">
                                <option value="${airline.airlineId}"
                                    ${param.airlineId != null && param.airlineId == airline.airlineId ? 'selected' : ''}>
                                    ${airline.airlineName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Filter giá -->
                    <div class="filter-group" style="min-width: 180px;">
                        <label for="priceRange" class="form-label mb-1 fw-semibold">Khoảng giá vé</label>
                        <select class="form-control form-control-sm" id="priceRange" name="priceRange">
                            <option value="">Tất cả mức giá</option>
                            <option value="0-1000000" ${param.priceRange == '0-1000000' ? 'selected' : ''}>Dưới 1.000.000₫</option>
                            <option value="1000000-3000000" ${param.priceRange == '1000000-3000000' ? 'selected' : ''}>1.000.000₫ - 3.000.000₫</option>
                            <option value="3000000-5000000" ${param.priceRange == '3000000-5000000' ? 'selected' : ''}>3.000.000₫ - 5.000.000₫</option>
                            <option value="5000000+" ${param.priceRange == '5000000+' ? 'selected' : ''}>Trên 5.000.000₫</option>
                        </select>
                    </div>

                    <!-- Nút tìm kiếm -->
                    <button type="submit" class="btn btn-primary btn-sm d-flex align-items-center" style="height: fit-content; margin-top: 25px;">
                        <i class="fa fa-search me-2"></i> Tìm kiếm
                    </button>

                    <!-- Thông tin + nút thêm vé -->
                    <div class="d-flex align-items-center ms-auto gap-3" style="margin-top: 25px; margin-right: 10px;">
                        <a href="${pageContext.request.contextPath}/staff/flight/tickets?action=create" class="btn btn-add btn-success btn-sm d-flex align-items-center"
                           style="height: 40px;">
                            <i class="fa fa-plus me-2"></i> Thêm vé máy bay
                        </a>

                    </div>
                </form>
            </div>



            <!-- flight List ---------------------------------------------->
            <div class="flight-scroll-container row">
                <c:choose>
                    <c:when test="${not empty flights}">
                        <c:forEach var="flight" items="${flights}">


                            <div class="col-lg-4 col-md-6 mb-4 flight-item">
                                <div class="card flight-card shadow-lg border-0 rounded-4 overflow-hidden"
                                     data-flightId="${flight.flightId}">

                                    <!-- Ảnh + Logo -->
                                    <div class="position-relative flight-card">
                                        <img src="${pageContext.request.contextPath}/${flight.destinationImageUrl}"
                                             alt="${flight.flightNumber}"
                                             class="card-img-top"
                                             style="height:220px; object-fit:cover; border-radius:10px;">
                                        <div class="airline-logo-wrapper">
                                            <img src="${pageContext.request.contextPath}/${flight.airline.logoUrl}"
                                                 alt="${flight.airline.airlineName}"
                                                 class="airline-logo">
                                        </div>
                                    </div>

                                    <div class="card-body d-flex flex-column">
                                        <div class="mb-1" style="text-align:left;">
                                            <h5 class="card-title fw-bold mb-1">
                                                <c:choose>
                                                    <c:when test="${flight.flightType == 'Khứ hồi'}">
                                                        ${flight.departure} ⇌${flight.destination}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${flight.departure} → ${flight.destination}
                                                    </c:otherwise>
                                                </c:choose>
                                            </h5>
                                            <p class="mb-1 ticket_available" style="margin-left: 2px;">
                                                <strong>Số lượng vé:</strong>
                                                <span class="text-success">${flight.ticketAvailable}</span>
                                            </p>
                                            <p class="card-text">
                                                <span class="badge bg-primary text-white px-2 py-1 fs-6">${flight.flightClass}</span>
                                            </p>
                                        </div>

                                                
                                                <div class="flightTicket-actions d-flex flex-column align-items-end text-end mt-2">
                                                    <p class="fw-bold text-danger fs-5 mb-2">
                                                        <fmt:formatNumber value="${flight.basePrice}" type="number" groupingUsed="true" /> VND /Khách
                                                    </p>

                                                    <div>
                                                      
                                                        <a href="${pageContext.request.contextPath}/staff/flight/tickets?action=edit&flightId=${flight.flightId}" 
                                                           class="btn-action btn-edit bg-success text-white ">
                                                            <i class="fa fa-edit"></i> Sửa
                                                        </a>
                                                        <a href="#" onclick="confirmDelete(${flight.flightId}, '${flight.flightNumber}')" 
                                                           class="btn-action btn-delete">
                                                            <i class="fa fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </div>

 
                                    </div>
                                      
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
             

                        <div class="empty-state d-flex flex-column align-content-center align-items-center">
                            <i class="fa fa-map-marker"></i>
                            <h3>Không có vé máy bay nào nào</h3>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty param.search}">
                                        Không tìm thấy vé máy bay nào với từ khóa "${param.search}"
                                    </c:when>
                                    <c:otherwise>
                                        Chưa có vé máy bay nào được thêm . Hãy tạo thêm vé đầu tiên!
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <a href="${pageContext.request.contextPath}/staff/flight/tickets?action=create"
                               class="btn btn-add btn-success mt-3">
                                <i class="fa fa-plus"></i> Thêm vé máy bay mới
                            </a>
                        </div>

                    </c:otherwise>
                </c:choose>
            </div>



        </div>

        <!-- Include common scripts -->
        <jsp:include page="../common/script.jsp" />

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">⚠️ Xác nhận xóa chuyến bay</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa chuyến bay mã số : "<strong id="flightNumberToDelete"></strong>" ?</p>
                        <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <form id="deleteForm" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="flightId" id="flightlIdToDelete">
                            <button type="submit" class="btn btn-danger">Xóa</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
   <script>
        function confirmDelete(flightlId, flightNumber) {
            document.getElementById('flightlIdToDelete').value =flightlId;
            document.getElementById('flightNumberToDelete').textContent = flightNumber;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/flight/tickets';
            $('#deleteModal').modal('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
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
                        ✈️ Vé máy bay của bạn đã được <strong class="text-success fw-bold">${param.success}</strong> thành công!<br>
                        <strong class="text-dark">ID chuyến bay:</strong> ${param.flightId}
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
              document.addEventListener("DOMContentLoaded", function() {
                const modal = new bootstrap.Modal(document.getElementById('notificationModal'));
                modal.show();
                document.getElementById("btnOk").addEventListener("click", function() {
                  modal.hide();
                });
              });
            </script>
        </c:if>

    </body>
</html>