<%-- 
    Document   : hotel-list
    Created on : Staff Hotel List Page
    Author     : System
    Description: Displays paginated list of hotels with search and management functionality
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Hotel" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách sạn - Meland Travel</title>
    
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
        
        .search-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .hotel-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .hotel-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .hotel-card-body {
            padding: 25px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        
        .hotel-title {
            font-size: 1.4em;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .hotel-description {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.6;
            flex: 1;
        }
        
        .hotel-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .hotel-rating {
            font-size: 1.1em;
            font-weight: 600;
            color: #ffc107;
        }
        
        .hotel-island {
            background: #e9ecef;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            color: #495057;
        }
        
        .hotel-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }
        
        .btn-action {
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
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
        }
        
        .pagination {
            justify-content: center;
            margin: 0;
        }
        
        .page-link {
            border-radius: 8px;
            margin: 0 3px;
            border: none;
            color: #667eea;
            font-weight: 500;
        }
        
        .page-link:hover {
            background: #667eea;
            color: white;
        }
        
        .page-item.active .page-link {
            background: #667eea;
            border-color: #667eea;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        
        .empty-state i {
            font-size: 4em;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .hotel-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .hotel-actions {
                width: 100%;
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="hotels" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-building"></i> Quản lý Khách sạn</h1>
            <p>Quản lý và theo dõi tất cả các khách sạn</p>
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

        <!-- Search Section -->
        <div class="search-section">
            <div class="row">
                <div class="col-md-8">
                    <form action="${pageContext.request.contextPath}/staff/hotels" method="get" class="d-flex">
                        <input type="hidden" name="action" value="list">
                        <input type="text" name="search" class="form-control" 
                               placeholder="Tìm kiếm khách sạn theo tên..." 
                               value="${param.search}" style="border-radius: 8px;">
                        <button type="submit" class="btn btn-primary ml-2" style="border-radius: 8px;">
                            <i class="fa fa-search"></i> Tìm kiếm
                        </button>
                    </form>
                </div>
                <div class="col-md-4 text-right">
                    <a href="${pageContext.request.contextPath}/staff/hotels?action=create" 
                       class="btn btn-success" style="border-radius: 8px; white-space: nowrap;">
                        <i class="fa fa-plus"></i> Tạo Khách sạn mới
                    </a>
                </div>
            </div>
        </div>

        <!-- Hotels List -->
        <c:choose>
            <c:when test="${not empty hotels}">
                <div class="row">
                    <c:forEach var="hotel" items="${hotels}">
                        <div class="col-lg-6 col-xl-4 mb-3">
                            <div class="hotel-card">
                                <div class="hotel-card-body">
                                    <h5 class="hotel-title">${hotel.hotelName}</h5>
                                    <p class="hotel-description">
                                        <c:choose>
                                            <c:when test="${not empty hotel.roomType}">
                                                Loại phòng: ${hotel.roomType}
                                                <c:if test="${not empty hotel.countryName}">
                                                    - Quốc gia: ${hotel.countryName}
                                                </c:if>
                                            </c:when>
                                            <c:when test="${not empty hotel.countryName}">
                                                Quốc gia: ${hotel.countryName}
                                            </c:when>
                                            <c:otherwise>
                                                Thông tin khách sạn
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <div class="hotel-meta">
                                        <div class="hotel-rating">
                                            <i class="fa fa-star"></i> ${hotel.rating != null ? hotel.rating : 'N/A'}/5
                                        </div>
                                        <div class="hotel-island">
                                            <i class="fa fa-map-pin"></i> ${not empty hotel.countryName ? hotel.countryName : 'Đảo ID: '.concat(hotel.islandId)}
                                        </div>
                                    </div>
                                    
                                    <div class="hotel-actions">
                                        <a href="${pageContext.request.contextPath}/staff/hotels?action=view&id=${hotel.hotelId}" 
                                           class="btn-action btn-view">
                                            <i class="fa fa-eye"></i> Xem
                                        </a>
                                        <a href="${pageContext.request.contextPath}/staff/hotels?action=edit&id=${hotel.hotelId}" 
                                           class="btn-action btn-edit">
                                            <i class="fa fa-edit"></i> Sửa
                                        </a>
                                        <a href="#" onclick="confirmDelete(${hotel.hotelId}, '${hotel.hotelName}')" 
                                           class="btn-action btn-delete">
                                            <i class="fa fa-trash"></i> Xóa
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-wrapper">
                        <nav aria-label="Hotel pagination">
                            <ul class="pagination">
                                <!-- Previous Page -->
                                <c:if test="${currentPage > 1}">
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
                                ${currentPage * pageSize > totalHotels ? totalHotels : currentPage * pageSize} 
                                trong tổng số ${totalHotels} khách sạn
                            </small>
                        </div>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fa fa-building"></i>
                    <h3>Không có khách sạn nào</h3>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${not empty param.search}">
                                Không tìm thấy khách sạn nào với từ khóa "${param.search}"
                            </c:when>
                            <c:otherwise>
                                Chưa có khách sạn nào được tạo. Hãy tạo khách sạn đầu tiên!
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/staff/hotels?action=create" 
                       class="btn btn-primary mt-3">
                        <i class="fa fa-plus"></i> Tạo Khách sạn mới
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
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa khách sạn "<span id="hotelNameToDelete"></span>"?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="hotelIdToDelete">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(hotelId, hotelName) {
            document.getElementById('hotelIdToDelete').value = hotelId;
            document.getElementById('hotelNameToDelete').textContent = hotelName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/hotels';
            $('#deleteModal').modal('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    </script>
</body>
</html>