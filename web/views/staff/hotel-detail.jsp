<%-- 
    Document   : hotel-view
    Created on : Staff Hotel View Page
    Author     : System
    Description: Detailed view of a specific hotel
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Hotel" %>
<%@ page import="model.Island" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Khách sạn - ${hotel.hotelName} - Meland Travel</title>
    
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
        
        .hotel-details-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .hotel-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .hotel-title {
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .hotel-subtitle {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .hotel-content {
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
        
        .rating-highlight {
            font-size: 1.8em;
            color: #ffc107;
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
            
            .hotel-content {
                padding: 25px;
            }
            
            .hotel-title {
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
        <jsp:param name="page" value="hotels" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-eye"></i> Chi tiết Khách sạn</h1>
            <p>Xem thông tin chi tiết của khách sạn</p>
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
                    <a href="${pageContext.request.contextPath}/staff/hotels?action=list">
                        <i class="fa fa-building"></i> Quản lý Khách sạn
                    </a>
                </li>
                <li class="breadcrumb-item active">Chi tiết Khách sạn</li>
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

        <!-- Hotel Details -->
        <c:choose>
            <c:when test="${not empty hotel}">
                <div class="hotel-details-container">
                    <!-- Hotel Header -->
                    <div class="hotel-header">
                        <h1 class="hotel-title">${hotel.hotelName}</h1>
                        <p class="hotel-subtitle">
                            <i class="fa fa-map-pin"></i> 
                            ${not empty hotel.countryName ? hotel.countryName : 'Đảo ID: '.concat(hotel.islandId)}
                        </p>
                    </div>

                    <!-- Hotel Content -->
                    <div class="hotel-content">
                        <!-- Basic Information -->
                        <div class="info-section">
                            <h3><i class="fa fa-info-circle"></i> Thông tin cơ bản</h3>
                            <div class="info-grid">
                                <div class="info-card">
                                    <div class="info-label">ID Khách sạn</div>
                                    <div class="info-value">#${hotel.hotelId}</div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Tên Khách sạn</div>
                                    <div class="info-value">${hotel.hotelName}</div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Loại phòng</div>
                                    <div class="info-value">
                                        ${not empty hotel.roomType ? hotel.roomType : 'Chưa cập nhật'}
                                    </div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Đánh giá</div>
                                    <div class="info-value rating-highlight">
                                        <i class="fa fa-star"></i> ${hotel.rating != null ? hotel.rating : 'N/A'}/5
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Location Information -->
                        <div class="info-section">
                            <h3><i class="fa fa-map-marker"></i> Thông tin vị trí</h3>
                            <div class="info-grid">
                                <div class="info-card">
                                    <div class="info-label">Vị trí</div>
                                    <div class="info-value">
                                        ${not empty hotel.countryName ? hotel.countryName : 'Chưa cập nhật vị trí'}
                                    </div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Quốc gia</div>
                                    <div class="info-value">
                                        ${not empty hotel.countryName ? hotel.countryName : 'Chưa cập nhật'}
                                    </div>
                                </div>
                                <div class="info-card">
                                    <div class="info-label">Đảo</div>
                                    <div class="info-value">
                                        Đảo ID: ${hotel.islandId}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Hotel Image -->
                        <div class="info-section">
                            <h3><i class="fa fa-image"></i> Hình ảnh Khách sạn</h3>
                            <div class="hotel-image-container">
                                <c:choose>
                                    <c:when test="${not empty hotel.hotelImageUrl}">
                                        <img src="${pageContext.request.contextPath}/${hotel.hotelImageUrl}" 
                                             alt="${hotel.hotelName}" 
                                             class="hotel-image"
                                             style="max-width: 100%; max-height: 400px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); display: block; margin: 0 auto;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-image-placeholder" 
                                             style="background: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 40px; text-align: center; color: #6c757d;">
                                            <i class="fa fa-image" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
                                            <p style="margin: 0; font-style: italic;">Chưa có hình ảnh cho khách sạn này</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Additional Information -->
                        <div class="info-section">
                            <h3><i class="fa fa-info"></i> Thông tin bổ sung</h3>
                            <div class="description-content">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>ID Khách sạn:</strong><br>
                                        ${hotel.hotelId}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>ID Đảo:</strong><br>
                                        ${hotel.islandId}</p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Hình ảnh khách sạn:</strong><br>
                                        <c:choose>
                                            <c:when test="${not empty hotel.hotelImageUrl}">
                                                <a href="${hotel.hotelImageUrl}" target="_blank">Xem hình ảnh</a>
                                            </c:when>
                                            <c:otherwise>
                                                Chưa cập nhật
                                            </c:otherwise>
                                        </c:choose>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Xếp hạng sao:</strong><br>
                                        <c:choose>
                                            <c:when test="${hotel.rating != null && hotel.rating > 0}">
                                                <c:forEach begin="1" end="${hotel.rating.intValue()}">
                                                    <i class="fa fa-star" style="color: #ffc107;"></i>
                                                </c:forEach>
                                                (${hotel.rating.intValue()} sao)
                                            </c:when>
                                            <c:otherwise>
                                                Chưa xếp hạng
                                            </c:otherwise>
                                        </c:choose>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/staff/hotels?action=list" 
                           class="btn-action btn-secondary-action">
                            <i class="fa fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/hotels?action=edit&id=${hotel.hotelId}" 
                           class="btn-action btn-warning-action">
                            <i class="fa fa-edit"></i> Chỉnh sửa
                        </a>
                        <a href="#" onclick="confirmDelete(${hotel.hotelId}, '${hotel.hotelName}')" 
                           class="btn-action btn-danger-action">
                            <i class="fa fa-trash"></i> Xóa khách sạn
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning">
                    <i class="fa fa-exclamation-triangle"></i> 
                    Không tìm thấy thông tin khách sạn.
                    <a href="${pageContext.request.contextPath}/staff/hotels?action=list" class="alert-link">
                        Quay lại danh sách khách sạn
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