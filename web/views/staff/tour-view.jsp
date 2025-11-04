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
<%@ page import="model.User" %>
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
        
        /* Approval Status Styles */
        .approval-status-section {
            margin: 15px 0;
        }
        
        .approval-status {
            display: inline-block;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-approved {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .approval-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
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

                        <!-- Tour Services -->
                        <div class="info-section">
                            <h3><i class="fa fa-cogs"></i> Dịch vụ Tour</h3>
                            <div style="margin-bottom: 20px;">
                                <a href="${pageContext.request.contextPath}/staff/tours?action=manage-services&tourId=${tour.tourId}" 
                                   class="btn btn-primary">
                                    <i class="fa fa-plus"></i> Quản lý dịch vụ
                                </a>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty currentServices}">
                                    <div class="services-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">
                                        <c:forEach var="service" items="${currentServices}">
                                            <div class="service-card" style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 10px; padding: 20px; transition: all 0.3s ease;">
                                                <div class="service-header" style="display: flex; justify-content: between; align-items: center; margin-bottom: 15px;">
                                                    <div class="service-type" style="background: #007bff; color: white; padding: 5px 10px; border-radius: 15px; font-size: 0.8em; font-weight: 600; text-transform: uppercase;">
                                                        ${service.serviceType}
                                                    </div>
                                                </div>
                                                
                                                <div class="service-info">
                                                    <h5 style="margin: 0 0 10px 0; color: #333; font-weight: 600;">
                                                        ${not empty service.serviceName ? service.serviceName : 'Dịch vụ ID: '.concat(service.serviceId)}
                                                    </h5>
                                                    
                                                    <c:if test="${not empty service.serviceDescription}">
                                                        <p style="margin: 0 0 10px 0; color: #666; font-size: 0.9em; line-height: 1.4;">
                                                            ${service.serviceDescription}
                                                        </p>
                                                    </c:if>
                                                    
                                                    <c:if test="${not empty service.servicePrice}">
                                                        <div class="service-price" style="color: #28a745; font-weight: 600; font-size: 1.1em;">
                                                            <fmt:formatNumber value="${service.servicePrice}" type="currency" 
                                                                            currencySymbol="₫" groupingUsed="true"/>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                
                                                <div class="service-actions" style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #dee2e6;">
                                                    <small class="text-muted">
                                                        <i class="fa fa-calendar"></i> 
                                                        Thêm vào: <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-services-placeholder" 
                                         style="background: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 40px; text-align: center; color: #6c757d;">
                                        <i class="fa fa-cogs" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
                                        <p style="margin: 0; font-style: italic;">Chưa có dịch vụ nào được thêm vào tour này</p>
                                        <a href="${pageContext.request.contextPath}/staff/tours?action=manage-services&tourId=${tour.tourId}" 
                                           class="btn btn-outline-primary mt-3">
                                            <i class="fa fa-plus"></i> Thêm dịch vụ đầu tiên
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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

        // Add hover effects to service cards
        $(document).ready(function() {
            $('.service-card').hover(
                function() {
                    $(this).css({
                        'transform': 'translateY(-5px)',
                        'box-shadow': '0 8px 25px rgba(0,0,0,0.15)'
                    });
                },
                function() {
                    $(this).css({
                        'transform': 'translateY(0)',
                        'box-shadow': 'none'
                    });
                }
            );
        });
    </script>
</body>
</html>