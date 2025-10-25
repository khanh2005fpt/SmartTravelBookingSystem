<%-- 
    Document   : place-list
    Created on : Staff Place List Page
    Author     : System
    Description: List and manage places
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Place" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Địa điểm - Meland Travel</title>
    
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
        
        .places-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .places-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px 25px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .places-title {
            font-size: 1.25em;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        
        .places-count {
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
        
        .places-table {
            width: 100%;
            margin: 0;
        }
        
        .places-table th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
            padding: 15px;
            border: none;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        .places-table td {
            padding: 15px;
            border-bottom: 1px solid #f1f3f4;
            vertical-align: middle;
        }
        
        .places-table tbody tr {
            transition: all 0.3s ease;
        }
        
        .places-table tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .place-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #e9ecef;
        }
        
        .place-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .place-type {
            color: #6c757d;
            font-size: 0.9em;
        }
        
        .place-rating {
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
        
        .place-price {
            font-weight: 700;
            color: #28a745;
            font-size: 1.1em;
        }
        
        .type-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .type-tourist {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .type-historical {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .type-natural {
            background: #e8f5e8;
            color: #388e3c;
        }
        
        .type-cultural {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .type-entertainment {
            background: #fce4ec;
            color: #c2185b;
        }
        
        .type-religious {
            background: #f1f8e9;
            color: #689f38;
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
            
            .places-table {
                font-size: 0.9em;
            }
            
            .places-table th,
            .places-table td {
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
        <jsp:param name="page" value="places" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-map-marked-alt"></i> Quản lý Địa điểm</h1>
            <p>Quản lý danh sách địa điểm du lịch và điểm tham quan</p>
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
            <form action="${pageContext.request.contextPath}/staff/places" method="get" class="search-filters">
                <input type="hidden" name="action" value="list">
                
                <div class="filter-group">
                    <label for="search">Tìm kiếm</label>
                    <input type="text" 
                           class="form-control" 
                           id="search" 
                           name="search" 
                           value="${param.search}"
                           placeholder="Tên địa điểm, mô tả...">
                </div>
                
                <div class="filter-group">
                    <label for="placeType">Loại địa điểm</label>
                    <select class="form-control" id="placeType" name="placeType">
                        <option value="">Tất cả loại</option>
                        <option value="Tourist" ${param.placeType == 'Tourist' ? 'selected' : ''}>Du lịch</option>
                        <option value="Historical" ${param.placeType == 'Historical' ? 'selected' : ''}>Lịch sử</option>
                        <option value="Natural" ${param.placeType == 'Natural' ? 'selected' : ''}>Thiên nhiên</option>
                        <option value="Cultural" ${param.placeType == 'Cultural' ? 'selected' : ''}>Văn hóa</option>
                        <option value="Entertainment" ${param.placeType == 'Entertainment' ? 'selected' : ''}>Giải trí</option>
                        <option value="Religious" ${param.placeType == 'Religious' ? 'selected' : ''}>Tôn giáo</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="islandId">Đảo</label>
                    <select class="form-control" id="islandId" name="islandId">
                        <option value="">Tất cả đảo</option>
                        <c:forEach var="island" items="${islands}">
                            <option value="${island.islandId}" ${param.islandId == island.islandId ? 'selected' : ''}>
                                ${island.islandName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <button type="submit" class="btn-search">
                    <i class="fa fa-search"></i> Tìm kiếm
                </button>
            </form>
        </div>

        <!-- Places List -->
        <div class="places-container">
            <div class="places-header">
                <h3 class="places-title">
                    <i class="fa fa-list"></i> Danh sách Địa điểm
                </h3>
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span class="places-count">
                        ${not empty places ? places.size() : 0} địa điểm
                    </span>
                    <a href="${pageContext.request.contextPath}/staff/places?action=create" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm địa điểm
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty places}">
                    <div class="table-responsive">
                        <table class="places-table table">
                            <thead>
                                <tr>
                                    <th>Hình ảnh</th>
                                    <th>Thông tin địa điểm</th>
                                    <th>Loại</th>
                                    <th>Đánh giá</th>
                                    <th>Giá vé</th>
                                    <th>Đảo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="place" items="${places}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty place.placeImageUrl}">
                                                    <img src="${pageContext.request.contextPath}/${place.placeImageUrl}" 
                                                         alt="${place.placeName}" 
                                                         class="place-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="place-image" style="background: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #6c757d;">
                                                        <i class="fa fa-map-marked-alt"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="place-name">${place.placeName}</div>
                                            <div class="place-type">
                                                <c:if test="${not empty place.address}">
                                                    <i class="fa fa-map-marker-alt"></i> ${place.address}
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="type-badge type-${place.placeType.toLowerCase()}">
                                                <c:choose>
                                                    <c:when test="${place.placeType == 'Tourist'}">Du lịch</c:when>
                                                    <c:when test="${place.placeType == 'Historical'}">Lịch sử</c:when>
                                                    <c:when test="${place.placeType == 'Natural'}">Thiên nhiên</c:when>
                                                    <c:when test="${place.placeType == 'Cultural'}">Văn hóa</c:when>
                                                    <c:when test="${place.placeType == 'Entertainment'}">Giải trí</c:when>
                                                    <c:when test="${place.placeType == 'Religious'}">Tôn giáo</c:when>
                                                    <c:otherwise>${place.placeType}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="place-rating">
                                                <span class="rating-stars">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <c:choose>
                                                            <c:when test="${star <= place.rating}">
                                                                <i class="fa fa-star"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fa fa-star-o"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </span>
                                                <span class="rating-value">${place.rating}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="place-price">
                                                <c:choose>
                                                    <c:when test="${not empty place.entryFee && place.entryFee > 0}">
                                                        <fmt:formatNumber value="${place.entryFee}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #28a745; font-weight: 600;">Miễn phí</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty place.islandName}">
                                                    ${place.islandName}
                                                </c:when>
                                                <c:otherwise>
                                                    Đảo ID: ${place.islandId}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/staff/places?action=view&id=${place.placeId}" 
                                                   class="btn-action btn-view" title="Xem chi tiết">
                                                    <i class="fa fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/staff/places?action=edit&id=${place.placeId}" 
                                                   class="btn-action btn-edit" title="Chỉnh sửa">
                                                    <i class="fa fa-edit"></i>
                                                </a>
                                                <a href="#" onclick="confirmDelete(${place.placeId}, '${place.placeName}')" 
                                                   class="btn-action btn-delete" title="Xóa">
                                                    <i class="fa fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <nav>
                                <ul class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?action=list&page=${currentPage - 1}&search=${param.search}&placeType=${param.placeType}&islandId=${param.islandId}">
                                                <i class="fa fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?action=list&page=${pageNum}&search=${param.search}&placeType=${param.placeType}&islandId=${param.islandId}">
                                                ${pageNum}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?action=list&page=${currentPage + 1}&search=${param.search}&placeType=${param.placeType}&islandId=${param.islandId}">
                                                <i class="fa fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fa fa-map-marked-alt"></i>
                        <h3>Chưa có địa điểm nào</h3>
                        <p>Hiện tại chưa có địa điểm nào trong hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/staff/places?action=create" class="btn-add">
                            <i class="fa fa-plus"></i> Thêm địa điểm đầu tiên
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
                    <p>Bạn có chắc chắn muốn xóa địa điểm "<span id="placeNameToDelete"></span>"?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="placeIdToDelete">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(placeId, placeName) {
            document.getElementById('placeIdToDelete').value = placeId;
            document.getElementById('placeNameToDelete').textContent = placeName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/places';
            $('#deleteModal').modal('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Enhanced search functionality
        $(document).ready(function() {
            // Auto-submit search form on select change
            $('#placeType, #islandId').on('change', function() {
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