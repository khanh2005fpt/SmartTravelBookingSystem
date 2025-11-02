<%-- 
    Document   : place-view
    Created on : Staff Place View Page
    Author     : System
    Description: View place details
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Place" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Địa điểm - Meland Travel</title>
    
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
        
        .breadcrumb-nav {
            background: white;
            padding: 15px 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .breadcrumb {
            margin: 0;
            background: none;
            padding: 0;
        }
        
        .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-item a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .breadcrumb-item.active {
            color: #6c757d;
            font-weight: 600;
        }
        
        .place-details-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        
        .place-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .place-title {
            font-size: 2em;
            font-weight: 700;
            color: #333;
            margin: 0 0 10px 0;
        }
        
        .place-subtitle {
            color: #6c757d;
            font-size: 1.1em;
            margin: 0;
        }
        
        .place-content {
            padding: 30px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }
        
        .info-section h3 {
            color: #333;
            font-size: 1.3em;
            font-weight: 600;
            margin: 0 0 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-value {
            color: #333;
            font-weight: 500;
            text-align: right;
        }
        
        .place-image-section {
            grid-column: 1 / -1;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .place-image {
            max-width: 100%;
            max-height: 400px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            object-fit: cover;
        }
        
        .no-image {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 60px;
            color: #6c757d;
        }
        
        .no-image i {
            font-size: 4em;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        
        .description-section {
            grid-column: 1 / -1;
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #28a745;
        }
        
        .description-section h3 {
            color: #333;
            font-size: 1.3em;
            font-weight: 600;
            margin: 0 0 15px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .description-content {
            color: #495057;
            line-height: 1.6;
            font-size: 1.05em;
        }
        
        .price-display {
            font-size: 1.3em;
            font-weight: 700;
            color: #28a745;
        }
        
        .free-entry {
            color: #28a745;
            font-weight: 600;
            background: #d4edda;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
        }
        
        .action-buttons {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 12px 25px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 1em;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        
        .btn-edit {
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
            color: #212529;
        }
        
        .btn-edit:hover {
            background: linear-gradient(135deg, #ffb300 0%, #ffa000 100%);
            color: #212529;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        .btn-delete:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
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
            
            .info-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .place-title {
                font-size: 1.5em;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-action {
                justify-content: center;
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
            <h1><i class="fa fa-map-marked-alt"></i> Chi tiết Địa điểm</h1>
            <p>Xem thông tin chi tiết của địa điểm</p>
        </div>

        <!-- Breadcrumb -->
        <div class="breadcrumb-nav">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/dashboard">
                            <i class="fa fa-home"></i> Trang chủ
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/places?action=list">
                            <i class="fa fa-map-marked-alt"></i> Quản lý Địa điểm
                        </a>
                    </li>
                    <li class="breadcrumb-item active">
                        <i class="fa fa-eye"></i> Chi tiết địa điểm
                    </li>
                </ol>
            </nav>
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

        <c:choose>
            <c:when test="${not empty place}">
                <!-- Place Details -->
                <div class="place-details-container">
                    <div class="place-header">
                        <h1 class="place-title">${place.placeName}</h1>
                        <p class="place-subtitle">
                            <i class="fa fa-map-marker-alt"></i> 
                            <c:choose>
                                <c:when test="${not empty place.location}">
                                    ${place.location}
                                </c:when>
                                <c:otherwise>
                                    Vị trí chưa cập nhật
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="place-content">
                        <div class="info-grid">
                            <!-- Basic Information -->
                            <div class="info-section">
                                <h3><i class="fa fa-info-circle"></i> Thông tin cơ bản</h3>
                                
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fa fa-map-marker-alt"></i> Vị trí
                                    </span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty place.location}">
                                                ${place.location}
                                            </c:when>
                                            <c:otherwise>
                                                Chưa cập nhật
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fa fa-ticket-alt"></i> Thông tin vé
                                    </span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${place != null && place.hasTicket != null && place.hasTicket == true}">
                                                <span class="price-display">
                                                    <fmt:formatNumber value="${place.ticketPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="free-entry">Miễn phí</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Island Information -->
                            <div class="info-section">
                                <h3><i class="fa fa-island-tropical"></i> Thông tin đảo</h3>
                                
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fa fa-island-tropical"></i> Đảo
                                    </span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty place.islandName}">
                                                ${place.islandName}
                                            </c:when>
                                            <c:otherwise>
                                                Đảo ID: ${place.islandId}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Description -->
                            <c:if test="${not empty place.description}">
                                <div class="description-section">
                                    <h3><i class="fa fa-align-left"></i> Mô tả</h3>
                                    <div class="description-content">
                                        ${place.description}
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/staff/places?action=list" class="btn-action btn-back">
                        <i class="fa fa-arrow-left"></i> Quay lại danh sách
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/places?action=edit&id=${place.placeId}" class="btn-action btn-edit">
                        <i class="fa fa-edit"></i> Chỉnh sửa
                    </a>
                    <a href="#" onclick="confirmDelete(${place.placeId}, '${place.placeName}')" class="btn-action btn-delete">
                        <i class="fa fa-trash"></i> Xóa
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="place-details-container">
                    <div class="place-content" style="text-align: center; padding: 60px;">
                        <i class="fa fa-exclamation-triangle" style="font-size: 4em; color: #ffc107; margin-bottom: 20px;"></i>
                        <h3>Không tìm thấy địa điểm</h3>
                        <p>Địa điểm bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <a href="${pageContext.request.contextPath}/staff/places?action=list" class="btn-action btn-back">
                            <i class="fa fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
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
    </script>
</body>
</html>