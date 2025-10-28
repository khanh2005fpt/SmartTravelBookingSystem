<%-- 
    Document   : restaurant-list
    Created on : Staff Restaurant List Page
    Author     : System
    Description: List and manage restaurants
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Restaurant" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Nhà hàng - Meland Travel</title>
    
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
        <jsp:param name="page" value="restaurants" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-utensils"></i> Quản lý vé máy bay</h1>
            <p>Quản lý  dịch vụ vé máy bay và lịch trình chuyến bay</p>
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
    <form action="${pageContext.request.contextPath}/staff/restaurants" method="get" class="search-filters">
        <input type="hidden" name="action" value="list">
        
        <div class="filter-group">
            <label for="search">Tìm kiếm</label>
            <input type="text" 
                   class="form-control" 
                   id="search" 
                   name="search" 
                   value="${param.search}"
                   placeholder="Chuyến bay, loại vé, điểm đến...">
        </div>
        
        <div class="filter-group">
            <label for="airlineName">Hãng bay</label>
            <select class="form-control" id="airlineName" name="airlineName">
                <option value="">Tất cả các hãng</option>
                <option value="Vietnam Airlines" ${param.airlineName == 'Vietnam Airlines' ? 'selected' : ''}>Vietnam Airlines</option>
                <option value="VietJet Air" ${param.airlineName == 'VietJet Air' ? 'selected' : ''}>VietJet Air</option>
                <option value="Bamboo Airways" ${param.airlineName == 'Bamboo Airways' ? 'selected' : ''}>Bamboo Airways</option>
                <option value="Thai Airways" ${param.airlineName == 'Thai Airways' ? 'selected' : ''}>Thai Airways</option>
                <option value="Singapore Airlines" ${param.airlineName == 'Singapore Airlines' ? 'selected' : ''}>Singapore Airlines</option>
                <option value="Malaysia Airlines" ${param.airlineName == 'Malaysia Airlines' ? 'selected' : ''}>Malaysia Airlines</option>
                <option value="Garuda Indonesia" ${param.airlineName == 'Garuda Indonesia' ? 'selected' : ''}>Garuda Indonesia</option>
                <option value="Khác" ${param.airlineName == 'Khác' ? 'selected' : ''}>Khác</option>
            </select>
        </div>
        
        <div class="filter-group">
            <label for="priceRange">Khoảng giá vé</label>
            <select class="form-control" id="priceRange" name="priceRange">
                <option value="">Tất cả mức giá</option>
                <option value="0-1000000" ${param.priceRange == '0-1000000' ? 'selected' : ''}>Dưới 1.000.000₫</option>
                <option value="1000000-3000000" ${param.priceRange == '1000000-3000000' ? 'selected' : ''}>1.000.000₫ - 3.000.000₫</option>
                <option value="3000000-5000000" ${param.priceRange == '3000000-5000000' ? 'selected' : ''}>3.000.000₫ - 5.000.000₫</option>
                <option value="5000000+" ${param.priceRange == '5000000+' ? 'selected' : ''}>Trên 5.000.000₫</option>
            </select>
        </div>
        
        <button type="submit" class="btn-search">
            <i class="fa fa-search"></i> Tìm kiếm
        </button>
    </form>
</div>


        <!-- Restaurants List -->
        <div class="flights-container">
            <div class="flights-header">
                <h3 class="flights-title">
                    <i class="fa fa-list"></i> Danh sách dịch vụ vé máy bay
                </h3>
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span class="flights-count">
                        ${not empty flights? flights.size() : 0} vé máy bay
                    </span>
                    <a href="${pageContext.request.contextPath}/staff/flights?action=create" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm vé máy bay
                    </a>
                </div>
            </div>

            <c:choose>
                  <c:when test="${not empty flights}">
                                    <c:forEach var="schedule" items="${flights}">
                                        <c:set var="f" value="${schedule.flight}" /> 

                                        <div class="col-lg-4 col-md-6 mb-4 flight-item">
                                            <div class="card flight-card h-100 shadow-lg border-0 rounded-3 overflow-hidden"
                                                 data-flightId="${f.flightId}">

                                                <!-- Ảnh + Logo -->
                                                <div class="position-relative flight-card">
                                                    <img src="${pageContext.request.contextPath}/${f.destinationImageUrl}"
                                                         alt="${f.flightNumber}"
                                                         class="card-img-top"
                                                         style="height:220px; object-fit:cover; border-radius:10px;">
                                                    <div class="airline-logo-wrapper">
                                                        <img src="${pageContext.request.contextPath}/${f.airline.logoUrl}"
                                                             alt="${f.airline.airlineName}"
                                                             class="airline-logo">
                                                    </div>
                                                </div>

                                                <div class="card-body d-flex flex-column">
                                                    <div class="mb-1" style="text-align:left;">
                                                        <h5 class="card-title fw-bold mb-1">
                                                            <c:choose>
                                                                <c:when test="${flightType == 'khuhoi'}">
                                                                    ${f.departure} ⇌${f.destination}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${f.departure} → ${f.destination}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </h5>
                                                        <p class="mb-1 ticket_available" style="margin-left: 2px;">
                                                            <strong>Số lượng vé:</strong>
                                                            <span class="text-success">${f.ticketAvailable}</span>
                                                        </p>
                                                        <p class="card-text">
                                                            <span class="badge bg-primary text-white px-2 py-1 fs-6">${f.flightClass}</span>
                                                        </p>
                                                    </div>
                                                        <div class="d-flex justify-content-between mt-3">
                                                            <p class="mb-2" style="margin-left: 2px;">

                                                                <i class="bi bi-heart heart" data-flight-id="${f.flightId}" style="font-size:1.4rem;"></i>
                                                            </p>
                                                            <p class="fw-bold text-danger fs-5 text-end">
                                                                <fmt:formatNumber value="${f.basePrice}" type="currency" currencySymbol="VND" groupingUsed="true"/> /Khách
                                                            </p>
                                                        </div>

                                                 

                                                    <div class="mt-0 d-flex gap-2">
                                                        <!-- NÚT CHỌN -->
                                                        <button type="button" class="btn btn-primary flex-fill rounded-pill w-100 select-flight-btn"
                                                                data-flight-id="${f.flightId}">
                                                            Xóa
                                                        </button>

                                                        <!-- NÚT XEM CHI TIẾT 
                                                          <button type="button" class="btn btn-success flex-fill rounded-pill w-100"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#flightDetailModal"
                                                                data-flightnumber="${f.flightNumber}"
                                                                data-flightimage="${pageContext.request.contextPath}/${f.destinationImageUrl}"
                                                                data-departureairport="${schedule.departureAirport}"
                                                                data-arrivalairport="${schedule.arrivalAirport}"
                                                                data-departuretime="${f.departureTime != null ? f.departureTime : ''}"
                                                                data-arrivaltime="${f.arrivalTime != null ? f.arrivalTime : ''}"
                                                                data-transitairport="${schedule.transitAirport}"
                                                                data-transitduration="${schedule.transitDuration}"
                                                                data-returndeparturetime="${f.returnDepartureTime != null ? f.returnDepartureTime : ''}"
                                                                data-returnarrivaltime="${f.returnArrivalTime != null ? f.returnArrivalTime : ''}"
                                                                data-planemodel="${schedule.planeModel}"
                                                                data-capacity="${schedule.seatCapacity}"
                                                                data-cabinbaggage="${schedule.cabinBaggage}" 
                                                                data-seatpitch="${schedule.seatPitch}"
                                                                data-notes="${schedule.notes}">
                                                            Xem chi tiết
                                                        </button>
                                                        
                                                        -->
                                                      
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fa fa-utensils"></i>
                        <h3>Chưa có vé máy bay nào</h3>
                        <p>Hiện tại chưa có vé máy bay nào trong hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/staff/flights?action=create" class="btn-add">
                            <i class="fa fa-plus"></i> Thêm vé máy bay đầu tiên
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
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa nhà hàng "<span id="restaurantNameToDelete"></span>"?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="restaurantIdToDelete">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(restaurantId, restaurantName) {
            document.getElementById('restaurantIdToDelete').value = restaurantId;
            document.getElementById('restaurantNameToDelete').textContent = restaurantName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/restaurants';
            $('#deleteModal').modal('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Enhanced search functionality
        $(document).ready(function() {
            // Auto-submit search form on select change
            $('#cuisineType, #islandId').on('change', function() {
                $(this).closest('form').submit();
            });
            
            // Search input with debounce
            let searchTimeout;
            $('#search').on('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function() {
                    // Auto-submit after 1 second of no typing
                }, 1000);
            });
        });
    </script>
</body>
</html>