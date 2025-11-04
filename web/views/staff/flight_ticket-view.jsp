
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Restaurant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Nhà hàng - Meland Travel</title>
    
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
        
        .restaurant-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .restaurant-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .restaurant-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #333;
            margin: 0 0 10px 0;
        }
        
        .restaurant-subtitle {
            color: #6c757d;
            margin: 0;
        }
        
        .restaurant-content {
            padding: 30px;
        }
        
        .restaurant-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .detail-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }
        
        .detail-section h3 {
            color: #333;
            font-size: 1.2em;
            font-weight: 600;
            margin: 0 0 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-value {
            color: #333;
            text-align: right;
            flex: 1;
            margin-left: 15px;
        }
        
        .restaurant-image-section {
            grid-column: 1 / -1;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .restaurant-image {
            max-width: 100%;
            max-height: 400px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            object-fit: cover;
        }
        
        .no-image {
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 60px;
            color: #6c757d;
            font-size: 1.1em;
        }
        
        .restaurant-description {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #28a745;
            margin-bottom: 30px;
        }
        
        .restaurant-description h3 {
            color: #333;
            font-size: 1.2em;
            font-weight: 600;
            margin: 0 0 15px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .restaurant-description p {
            color: #495057;
            line-height: 1.6;
            margin: 0;
        }
        
        .rating-display {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .rating-stars {
            color: #ffc107;
            font-size: 1.2em;
        }
        
        .rating-value {
            font-weight: 600;
            color: #333;
            font-size: 1.1em;
        }
        
        .price-display {
            font-size: 1.3em;
            font-weight: 700;
            color: #28a745;
        }
        
        .cuisine-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            padding: 25px;
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
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
            min-width: 120px;
            justify-content: center;
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
            
            .restaurant-details {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .detail-section {
                padding: 20px;
            }
            
            .restaurant-content {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-action {
                width: 100%;
                max-width: 200px;
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
        <jsp:param name="page" value="restaurants" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-utensils"></i> Chi tiết Nhà hàng</h1>
            <p>Xem thông tin chi tiết nhà hàng</p>
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

        <!-- Restaurant Details -->
        <c:choose>
            <c:when test="${not empty restaurant}">
                <div class="restaurant-container">
                    <div class="restaurant-header">
                        <h2 class="restaurant-title">${restaurant.restaurantName}</h2>
                        <p class="restaurant-subtitle">
                            <i class="fa fa-map-marker-alt"></i> 
                            <c:choose>
                                <c:when test="${not empty restaurant.address}">
                                    ${restaurant.address}
                                </c:when>
                                <c:otherwise>
                                    Địa chỉ chưa được cập nhật
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="restaurant-content">
                        <!-- Restaurant Image -->
                        <div class="restaurant-image-section">
                            <c:choose>
                                <c:when test="${not empty restaurant.restaurantImageUrl}">
                                    <img src="${pageContext.request.contextPath}/${restaurant.restaurantImageUrl}" 
                                         alt="${restaurant.restaurantName}" 
                                         class="restaurant-image">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-image">
                                        <i class="fa fa-utensils fa-3x"></i>
                                        <p>Chưa có hình ảnh</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Restaurant Details Grid -->
                        <div class="restaurant-details">
                            <!-- Basic Information -->
                            <div class="detail-section">
                                <h3><i class="fa fa-info-circle"></i> Thông tin cơ bản</h3>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-utensils"></i> Tên nhà hàng
                                    </span>
                                    <span class="detail-value">${restaurant.restaurantName}</span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-tag"></i> Loại ẩm thực
                                    </span>
                                    <span class="detail-value">
                                        <span class="cuisine-badge">
                                            <c:choose>
                                                <c:when test="${restaurant.cuisineType == 'Vietnamese'}">Việt Nam</c:when>
                                                <c:when test="${restaurant.cuisineType == 'Chinese'}">Trung Hoa</c:when>
                                                <c:when test="${restaurant.cuisineType == 'Japanese'}">Nhật Bản</c:when>
                                                <c:when test="${restaurant.cuisineType == 'Korean'}">Hàn Quốc</c:when>
                                                <c:when test="${restaurant.cuisineType == 'Western'}">Âu Mỹ</c:when>
                                                <c:when test="${restaurant.cuisineType == 'Seafood'}">Hải sản</c:when>
                                                <c:when test="${restaurant.cuisineType == 'Vegetarian'}">Chay</c:when>
                                                <c:when test="${restaurant.cuisineType == 'FastFood'}">Thức ăn nhanh</c:when>
                                                <c:otherwise>${restaurant.cuisineType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-star"></i> Đánh giá
                                    </span>
                                    <span class="detail-value">
                                        <div class="rating-display">
                                            <span class="rating-stars">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <c:choose>
                                                        <c:when test="${star <= restaurant.rating}">
                                                            <i class="fa fa-star"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa fa-star-o"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                            <span class="rating-value">${restaurant.rating}/5</span>
                                        </div>
                                    </span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-money-bill-wave"></i> Mức giá
                                    </span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${not empty restaurant.priceRange}">
                                                <span class="price-display">
                                                    ${restaurant.priceRange}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Location Information -->
                            <div class="detail-section">
                                <h3><i class="fa fa-map-marker-alt"></i> Thông tin vị trí</h3>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-map"></i> Địa chỉ
                                    </span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${not empty restaurant.address}">
                                                ${restaurant.address}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-island-tropical"></i> Đảo
                                    </span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${not empty restaurant.islandName}">
                                                ${restaurant.islandName}
                                            </c:when>
                                            <c:otherwise>
                                                Đảo ID: ${restaurant.islandId}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-phone"></i> Số điện thoại
                                    </span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${not empty restaurant.phoneNumber}">
                                                <a href="tel:${restaurant.phoneNumber}" style="color: #667eea; text-decoration: none;">
                                                    ${restaurant.phoneNumber}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                

                            </div>
                        </div>

                        <!-- Restaurant Description -->
                        <c:if test="${not empty restaurant.description}">
                            <div class="restaurant-description">
                                <h3><i class="fa fa-align-left"></i> Mô tả</h3>
                                <p>${restaurant.description}</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/staff/restaurants?action=list" class="btn-action btn-back">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/restaurants?action=edit&id=${restaurant.restaurantId}" class="btn-action btn-edit">
                            <i class="fa fa-edit"></i> Chỉnh sửa
                        </a>
                        <a href="#" onclick="confirmDelete(${restaurant.restaurantId}, '${restaurant.restaurantName}')" class="btn-action btn-delete">
                            <i class="fa fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="restaurant-container">
                    <div class="restaurant-content" style="text-align: center; padding: 60px;">
                        <i class="fa fa-exclamation-triangle fa-3x" style="color: #ffc107; margin-bottom: 20px;"></i>
                        <h3>Không tìm thấy nhà hàng</h3>
                        <p style="color: #6c757d; margin-bottom: 30px;">Nhà hàng bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <a href="${pageContext.request.contextPath}/staff/restaurants?action=list" class="btn-action btn-back">
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
    </script>
</body>
</html>