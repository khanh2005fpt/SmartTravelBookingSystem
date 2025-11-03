<%-- 
    Document   : vehicle-view
    Created on : Staff Vehicle View Page
    Author     : System
    Description: View vehicle details
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.IslandVehicle" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Phương tiện - Meland Travel</title>
    
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
        
        .vehicle-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .vehicle-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .vehicle-title {
            font-size: 1.5em;
            font-weight: 700;
            color: #333;
            margin: 0 0 10px 0;
        }
        
        .vehicle-subtitle {
            color: #6c757d;
            margin: 0;
        }
        
        .vehicle-content {
            padding: 0;
        }
        
        .vehicle-image-section {
            position: relative;
            height: 400px;
            overflow: hidden;
        }
        
        .vehicle-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .vehicle-image-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            color: white;
            padding: 30px;
        }
        
        .vehicle-price {
            font-size: 2em;
            font-weight: 700;
            margin: 0;
        }
        
        .vehicle-price-unit {
            font-size: 0.6em;
            opacity: 0.8;
        }
        
        .vehicle-details {
            padding: 30px;
        }
        
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
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
            font-weight: 600;
            margin: 0 0 20px 0;
            font-size: 1.2em;
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
            font-weight: 500;
            text-align: right;
        }
        
        .vehicle-type-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
        }
        
        .capacity-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 6px 12px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 0.9em;
        }
        
        .description-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            margin-top: 20px;
        }
        
        .description-section h3 {
            color: #333;
            font-weight: 600;
            margin: 0 0 15px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .description-text {
            color: #495057;
            line-height: 1.6;
            margin: 0;
        }
        
        .action-buttons {
            background: white;
            padding: 25px;
            border-top: 1px solid #dee2e6;
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
            min-width: 140px;
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
            background: linear-gradient(135deg, #ffc107 0%, #ff8f00 100%);
            color: #212529;
        }
        
        .btn-edit:hover {
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
        
        .no-image {
            height: 400px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 4em;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .details-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-action {
                min-width: auto;
            }
            
            .vehicle-image-section {
                height: 250px;
            }
            
            .vehicle-price {
                font-size: 1.5em;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="page" value="vehicles" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-car"></i> Chi tiết Phương tiện</h1>
            <p>Thông tin chi tiết về phương tiện</p>
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

        <!-- Vehicle Details -->
        <c:if test="${not empty vehicle}">
            <div class="vehicle-container">
                <!-- Vehicle Header -->
                <div class="vehicle-header">
                    <h1 class="vehicle-title">${vehicle.vehicleName}</h1>
                    <p class="vehicle-subtitle">
                        <c:if test="${not empty vehicle.brand}">
                            ${vehicle.brand}
                            <c:if test="${not empty vehicle.model}"> - ${vehicle.model}</c:if>
                        </c:if>
                    </p>
                </div>

                <!-- Vehicle Content -->
                <div class="vehicle-content">
                    <!-- Vehicle Image -->
                    <div class="vehicle-image-section">
                        <c:choose>
                            <c:when test="${not empty vehicle.vehicleImageUrl}">
                                <img src="${pageContext.request.contextPath}/${vehicle.vehicleImageUrl}" 
                                     alt="${vehicle.vehicleName}" 
                                     class="vehicle-image">
                                <div class="vehicle-image-overlay">
                                    <div class="vehicle-price">
                                        <fmt:formatNumber value="${vehicle.pricePerDay}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                        <span class="vehicle-price-unit">/ngày</span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-image">
                                    <i class="fa fa-car"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Vehicle Details -->
                    <div class="vehicle-details">
                        <div class="details-grid">
                            <!-- Basic Information -->
                            <div class="detail-section">
                                <h3><i class="fa fa-info-circle"></i> Thông tin cơ bản</h3>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-tag"></i> Tên phương tiện
                                    </span>
                                    <span class="detail-value">${vehicle.vehicleName}</span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-car"></i> Loại phương tiện
                                    </span>
                                    <span class="detail-value">
                                        <span class="vehicle-type-badge">
                                            ${vehicle.vehicleType}
                                        </span>
                                    </span>
                                </div>
                                
                                <c:if test="${not empty vehicle.brand}">
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-industry"></i> Hãng xe
                                        </span>
                                        <span class="detail-value">${vehicle.brand}</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty vehicle.model}">
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-cog"></i> Model
                                        </span>
                                        <span class="detail-value">${vehicle.model}</span>
                                    </div>
                                </c:if>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-users"></i> Sức chứa
                                    </span>
                                    <span class="detail-value">
                                        <span class="capacity-badge">${vehicle.capacity} người</span>
                                    </span>
                                </div>
                            </div>

                            <!-- Location & Pricing -->
                            <div class="detail-section">
                                <h3><i class="fa fa-map-marker-alt"></i> Vị trí & Giá cả</h3>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-island-tropical"></i> Đảo
                                    </span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${not empty vehicle.islandName}">
                                                ${vehicle.islandName}
                                            </c:when>
                                            <c:otherwise>
                                                Đảo ID: ${vehicle.islandId}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">
                                        <i class="fa fa-dollar-sign"></i> Giá thuê
                                    </span>
                                    <span class="detail-value" style="color: #28a745; font-weight: 700; font-size: 1.1em;">
                                        <fmt:formatNumber value="${vehicle.pricePerDay}" type="currency" currencySymbol="₫" groupingUsed="true"/>/ngày
                                    </span>
                                </div>
                                
                                <c:if test="${not empty vehicle.contactInfo}">
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-phone"></i> Thông tin liên hệ
                                        </span>
                                        <span class="detail-value">${vehicle.contactInfo}</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty vehicle.location}">
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-map-pin"></i> Địa điểm
                                        </span>
                                        <span class="detail-value">${vehicle.location}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Description -->
                        <c:if test="${not empty vehicle.description}">
                            <div class="description-section">
                                <h3><i class="fa fa-align-left"></i> Mô tả</h3>
                                <p class="description-text">${vehicle.description}</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/staff/vehicles?action=list" class="btn-action btn-back">
                        <i class="fa fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/vehicles?action=edit&id=${vehicle.vehicleId}" class="btn-action btn-edit">
                        <i class="fa fa-edit"></i> Chỉnh sửa
                    </a>
                    <a href="#" onclick="confirmDelete(${vehicle.vehicleId}, '${vehicle.vehicleName}')" class="btn-action btn-delete">
                        <i class="fa fa-trash"></i> Xóa
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Vehicle not found -->
        <c:if test="${empty vehicle}">
            <div class="vehicle-container">
                <div class="vehicle-details" style="text-align: center; padding: 60px;">
                    <i class="fa fa-exclamation-triangle" style="font-size: 4em; color: #ffc107; margin-bottom: 20px;"></i>
                    <h3>Không tìm thấy phương tiện</h3>
                    <p>Phương tiện bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                    <a href="${pageContext.request.contextPath}/staff/vehicles?action=list" class="btn-action btn-back">
                        <i class="fa fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
            </div>
        </c:if>
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
                    <p>Bạn có chắc chắn muốn xóa phương tiện "<span id="vehicleNameToDelete"></span>"?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="vehicleIdToDelete">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(vehicleId, vehicleName) {
            document.getElementById('vehicleIdToDelete').value = vehicleId;
            document.getElementById('vehicleNameToDelete').textContent = vehicleName;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/vehicles';
            $('#deleteModal').modal('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    </script>
</body>
</html>