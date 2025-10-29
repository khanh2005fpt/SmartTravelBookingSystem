
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
        <div class="page-header ">
            <h1><i class="fa fa-utensils  text-left"></i> Quản lý chuyến bay MelanBooking</h1>
            <p>Quản lý lịch trình chuyến bay </p>
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
                   placeholder="Sân bay, Transit,...">
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
    <label for="departureTimeRange">Khung giờ khởi hành</label>
    <select class="form-control" id="departureTimeRange" name="departureTimeRange">
        <option value="">Tất cả khung giờ</option>
        <option value="00:00-01:00" ${param.departureTimeRange == '00:00-01:00' ? 'selected' : ''}>00:00 - 01:00</option>
        <option value="01:00-02:00" ${param.departureTimeRange == '01:00-02:00' ? 'selected' : ''}>01:00 - 02:00</option>
        <option value="02:00-03:00" ${param.departureTimeRange == '02:00-03:00' ? 'selected' : ''}>02:00 - 03:00</option>
        <option value="03:00-04:00" ${param.departureTimeRange == '03:00-04:00' ? 'selected' : ''}>03:00 - 04:00</option>
        <option value="04:00-05:00" ${param.departureTimeRange == '04:00-05:00' ? 'selected' : ''}>04:00 - 05:00</option>
        <option value="05:00-06:00" ${param.departureTimeRange == '05:00-06:00' ? 'selected' : ''}>05:00 - 06:00</option>
        <option value="06:00-07:00" ${param.departureTimeRange == '06:00-07:00' ? 'selected' : ''}>06:00 - 07:00</option>
        <option value="07:00-08:00" ${param.departureTimeRange == '07:00-08:00' ? 'selected' : ''}>07:00 - 08:00</option>
        <option value="08:00-09:00" ${param.departureTimeRange == '08:00-09:00' ? 'selected' : ''}>08:00 - 09:00</option>
        <option value="09:00-10:00" ${param.departureTimeRange == '09:00-10:00' ? 'selected' : ''}>09:00 - 10:00</option>
        <option value="10:00-11:00" ${param.departureTimeRange == '10:00-11:00' ? 'selected' : ''}>10:00 - 11:00</option>
        <option value="11:00-12:00" ${param.departureTimeRange == '11:00-12:00' ? 'selected' : ''}>11:00 - 12:00</option>
        <option value="12:00-13:00" ${param.departureTimeRange == '12:00-13:00' ? 'selected' : ''}>12:00 - 13:00</option>
        <option value="13:00-14:00" ${param.departureTimeRange == '13:00-14:00' ? 'selected' : ''}>13:00 - 14:00</option>
        <option value="14:00-15:00" ${param.departureTimeRange == '14:00-15:00' ? 'selected' : ''}>14:00 - 15:00</option>
        <option value="15:00-16:00" ${param.departureTimeRange == '15:00-16:00' ? 'selected' : ''}>15:00 - 16:00</option>
        <option value="16:00-17:00" ${param.departureTimeRange == '16:00-17:00' ? 'selected' : ''}>16:00 - 17:00</option>
        <option value="17:00-18:00" ${param.departureTimeRange == '17:00-18:00' ? 'selected' : ''}>17:00 - 18:00</option>
        <option value="18:00-19:00" ${param.departureTimeRange == '18:00-19:00' ? 'selected' : ''}>18:00 - 19:00</option>
        <option value="19:00-20:00" ${param.departureTimeRange == '19:00-20:00' ? 'selected' : ''}>19:00 - 20:00</option>
        <option value="20:00-21:00" ${param.departureTimeRange == '20:00-21:00' ? 'selected' : ''}>20:00 - 21:00</option>
        <option value="21:00-22:00" ${param.departureTimeRange == '21:00-22:00' ? 'selected' : ''}>21:00 - 22:00</option>
        <option value="22:00-23:00" ${param.departureTimeRange == '22:00-23:00' ? 'selected' : ''}>22:00 - 23:00</option>
        <option value="23:00-24:00" ${param.departureTimeRange == '23:00-24:00' ? 'selected' : ''}>23:00 - 24:00</option>
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
                    <i class="fa fa-list"></i> Danh sách những lịch trình chuyến bay
                </h3>
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span class="flights-count">
                        ${not empty flights? flights.size() : 0} lịch trình chuyến bay
                    </span>
                    <a href="${pageContext.request.contextPath}/staff/flights?action=create" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm lịch trình chuyến bay
                    </a>
                

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