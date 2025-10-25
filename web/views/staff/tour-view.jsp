<%-- 
    Document   : tour-view
    Created on : Staff Tour View Page
    Author     : System
    Description: Detailed view of a specific tour
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Tour" %>
<%@ page import="model.Island" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Tour - ${tour.tourName} - Meland Travel</title>
    
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
        
        .tour-details-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .tour-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .tour-title {
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .tour-subtitle {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .tour-content {
            padding: 40px;
        }
        
        .info-section {
            margin-bottom: 40px;
        }
        
        .info-section h3 {
            color: #333;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 1.1em;
            color: #333;
            font-weight: 500;
        }
        
        .price-highlight {
            font-size: 1.8em;
            color: #28a745;
            font-weight: 700;
        }
        
        .description-content {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            line-height: 1.8;
            color: #555;
            font-size: 1.05em;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            padding: 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }
        
        .btn-action {
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 140px;
            text-align: center;
        }
        
        .btn-primary-action {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-warning-action {
            background: #ffc107;
            color: #212529;
        }
        
        .btn-warning-action:hover {
            background: #e0a800;
            color: #212529;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .btn-danger-action {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger-action:hover {
            background: #c82333;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .btn-secondary-action {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary-action:hover {
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
        
        .breadcrumb-nav {
            background: white;
            padding: 15px 25px;
            border-radius: 10px;
            margin-bottom: 20px;
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
        }
        
        .breadcrumb-item a:hover {
            text-decoration: underline;
        }
        
        .breadcrumb-item.active {
            color: #6c757d;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .tour-content {
                padding: 25px;
            }
            
            .tour-title {
                font-size: 2em;
            }
            
            .action-buttons {
                flex-direction: column;
                padding: 20px;
            }
            
            .btn-action {
                width: 100%;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Tour Itinerary Styles */
        .itinerary-timeline {
            position: relative;
        }
        
        .itinerary-day {
            margin-bottom: 30px;
            position: relative;
            padding-left: 30px;
        }
        
        .itinerary-day:before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: -30px;
            width: 2px;
            background: linear-gradient(to bottom, #667eea, #764ba2);
        }
        
        .itinerary-day:last-child:before {
            bottom: 0;
        }
        
        .day-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            gap: 15px;
        }
        
        .day-number {
            position: relative;
            z-index: 2;
            margin-left: -30px;
        }
        
        .day-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
            box-shadow: 0 3px 10px rgba(102, 126, 234, 0.3);
        }
        
        .day-title h4 {
            margin: 0;
            color: #333;
            font-weight: 600;
            font-size: 1.3em;
        }
        
        .day-activities {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-left: 15px;
        }
        
        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .activity-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .activity-item:last-child {
            margin-bottom: 0;
        }
        
        .activity-order {
            flex-shrink: 0;
        }
        
        .activity-number {
            display: inline-block;
            width: 30px;
            height: 30px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 30px;
            font-weight: 600;
            font-size: 0.9em;
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-title {
            margin: 0 0 8px 0;
            color: #333;
            font-weight: 600;
            font-size: 1.1em;
        }
        
        .activity-description {
            margin: 0;
            color: #666;
            line-height: 1.6;
            font-size: 0.95em;
        }
        
        .no-activities {
            text-align: center;
            padding: 20px;
            color: #6c757d;
            font-style: italic;
        }
        
        @media (max-width: 768px) {
            .itinerary-day {
                padding-left: 20px;
            }
            
            .day-number {
                margin-left: -20px;
            }
            
            .day-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .day-activities {
                margin-left: 5px;
                padding: 15px;
            }
            
            .activity-item {
                flex-direction: column;
                gap: 10px;
            }
            
            .activity-order {
                align-self: flex-start;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="tours" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-eye"></i> Chi tiết Tour</h1>
            <p>Xem thông tin chi tiết của tour</p>
        </div>

        <!-- Breadcrumb Navigation -->
        <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/staff/dashboard">
                        <i class="fa fa-home"></i> Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/staff/tours?action=list">
                        <i class="fa fa-map-marker"></i> Quản lý Tour
                    </a>
                </li>
                <li class="breadcrumb-item active">Chi tiết Tour</li>
            </ol>
        </nav>

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

        <!-- Tour Details -->
        <c:choose>
            <c:when test="${not empty tour}">
                <div class="tour-details-container">
                    <!-- Tour Header -->
                    <div class="tour-header">
                        <h1 class="tour-title">${tour.tourName}</h1>
                        <p class="tour-subtitle">
                            <i class="fa fa-map-pin"></i> 
                            ${not empty island ? island.islandName : 'Đảo ID: '.concat(tour.islandId)}
                        </p>
                    </div>

                    <!-- Tour Content -->
                    <div class="tour-content">
                        <!-- Basic Information -->
                        <div class="info-section">
                            <h3><i class="fa fa-info-circle"></i> Thông tin cơ bản</h3>
                            <div class="info-grid">
                                <div class="info-card">
                                    <div class="info-label">ID Tour</div>
                                    <div class="info-value">#${tour.tourId}</div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Tên Tour</div>
                                    <div class="info-value">${tour.tourName}</div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Đảo</div>
                                    <div class="info-value">
                                        ${not empty island ? island.islandName : 'Đảo ID: '.concat(tour.islandId)}
                                    </div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Giá Tour</div>
                                    <div class="info-value price-highlight">
                                        <fmt:formatNumber value="${tour.price}" type="currency" 
                                                        currencySymbol="₫" groupingUsed="true"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tour Image -->
                        <div class="info-section">
                            <h3><i class="fa fa-image"></i> Hình ảnh Tour</h3>
                            <div class="tour-image-container">
                                <c:choose>
                                    <c:when test="${not empty tour.tourImageUrl}">
                                        <img src="${pageContext.request.contextPath}/${tour.tourImageUrl}" 
                                             alt="${tour.tourName}" 
                                             class="tour-image"
                                             style="max-width: 100%; max-height: 400px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); display: block; margin: 0 auto;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-image-placeholder" 
                                             style="background: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 40px; text-align: center; color: #6c757d;">
                                            <i class="fa fa-image" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
                                            <p style="margin: 0; font-style: italic;">Chưa có hình ảnh cho tour này</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="info-section">
                            <h3><i class="fa fa-file-text"></i> Mô tả Tour</h3>
                            <div class="description-content">
                                <c:choose>
                                    <c:when test="${not empty tour.description}">
                                        ${tour.description}
                                    </c:when>
                                    <c:otherwise>
                                        <em class="text-muted">Chưa có mô tả cho tour này.</em>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Tour Itinerary -->
                        <div class="info-section">
                            <h3><i class="fa fa-calendar"></i> Lịch trình Tour</h3>
                            <div class="itinerary-content">
                                <c:choose>
                                    <c:when test="${not empty tourItineraries}">
                                        <div class="itinerary-timeline">
                                            <c:forEach var="itinerary" items="${tourItineraries}" varStatus="status">
                                                <div class="itinerary-day">
                                                    <div class="day-header">
                                                        <div class="day-number">
                                                            <span class="day-badge">Ngày ${itinerary.dayNumber}</span>
                                                        </div>
                                                        <div class="day-title">
                                                            <h4>${itinerary.title}</h4>
                                                        </div>
                                                    </div>
                                                    <div class="day-activities">
                                                        <c:choose>
                                                            <c:when test="${not empty itinerary.activities}">
                                                                <c:forEach var="activity" items="${itinerary.activities}" varStatus="actStatus">
                                                                    <div class="activity-item">
                                                                        <div class="activity-order">
                                                                            <span class="activity-number">${activity.activityOrder}</span>
                                                                        </div>
                                                                        <div class="activity-content">
                                                                            <h5 class="activity-title">${activity.activityTitle}</h5>
                                                                            <c:if test="${not empty activity.description}">
                                                                                <p class="activity-description">${activity.description}</p>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="no-activities">
                                                                    <em class="text-muted">Chưa có hoạt động cho ngày này.</em>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-itinerary" 
                                             style="background: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 40px; text-align: center; color: #6c757d;">
                                            <i class="fa fa-calendar-o" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
                                            <p style="margin: 0; font-style: italic;">Chưa có lịch trình cho tour này</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Additional Information -->
                        <c:if test="${not empty island}">
                            <div class="info-section">
                                <h3><i class="fa fa-map"></i> Thông tin Đảo</h3>
                                <div class="info-grid">
                                    <div class="info-card">
                                        <div class="info-label">Tên Đảo</div>
                                        <div class="info-value">${island.islandName}</div>
                                    </div>
                                    <c:if test="${not empty island.shortDescription}">
                                        <div class="info-card">
                                            <div class="info-label">Mô tả Đảo</div>
                                            <div class="info-value">${island.shortDescription}</div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>

                        <!-- System Information -->
                        <div class="info-section">
                            <h3><i class="fa fa-cog"></i> Thông tin hệ thống</h3>
                            <div class="info-grid">
                                <div class="info-card">
                                    <div class="info-label">Trạng thái</div>
                                    <div class="info-value">
                                        <span class="status-badge status-active">
                                            <i class="fa fa-check"></i> Hoạt động
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/staff/tours?action=list" 
                           class="btn-action btn-secondary-action">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/tours?action=edit&id=${tour.tourId}" 
                           class="btn-action btn-warning-action">
                            <i class="fa fa-edit"></i> Chỉnh sửa
                        </a>
                        <a href="#" onclick="confirmDelete(${tour.tourId}, '${tour.tourName}')" 
                           class="btn-action btn-danger-action">
                            <i class="fa fa-trash"></i> Xóa Tour
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/tours?action=create" 
                           class="btn-action btn-primary-action">
                            <i class="fa fa-plus"></i> Tạo Tour mới
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="tour-details-container">
                    <div class="tour-content text-center" style="padding: 60px;">
                        <i class="fa fa-exclamation-triangle" style="font-size: 4em; color: #ffc107; margin-bottom: 20px;"></i>
                        <h3>Không tìm thấy tour</h3>
                        <p class="text-muted">Tour bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <a href="${pageContext.request.contextPath}/staff/tours?action=list" 
                           class="btn-action btn-primary-action mt-3">
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
                    <p>Bạn có chắc chắn muốn xóa tour "<span id="tourNameToDelete"></span>"?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="tourIdToDelete">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(tourId, tourName) {
            document.getElementById('tourIdToDelete').value = tourId;
            document.getElementById('tourNameToDelete').textContent = tourName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/tours';
            $('#deleteModal').modal('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    </script>
</body>
</html>