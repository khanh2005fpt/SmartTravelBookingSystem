<%-- 
    Document   : tour-services
    Created on : Staff Tour Services Management Page
    Author     : System
    Description: Manage services for a specific tour
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Tour" %>
<%@ page import="model.TourService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Dịch vụ Tour - ${tour.tourName} - Meland Travel</title>
    
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
        
        .services-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .services-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .section-header {
            padding: 25px 30px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .section-header h3 {
            margin: 0;
            color: #333;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-content {
            padding: 30px;
            max-height: 600px;
            overflow-y: auto;
        }
        
        .service-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .service-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .service-type-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        
        .service-type-hotel {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .service-type-restaurant {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .service-type-place {
            background: #e8f5e8;
            color: #388e3c;
        }
        
        .service-type-vehicle {
            background: #fce4ec;
            color: #c2185b;
        }
        
        .service-type-airline {
            background: #e0f7fa;
            color: #007b8f;
        }
        
        .service-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .service-description {
            color: #666;
            font-size: 0.9em;
            line-height: 1.4;
            margin-bottom: 10px;
        }
        
        .service-price {
            color: #28a745;
            font-weight: 600;
            font-size: 1.1em;
            margin-bottom: 15px;
        }
        
        .service-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .btn-add-service {
            background: #28a745;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            font-size: 0.9em;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-add-service:hover {
            background: #218838;
            transform: translateY(-1px);
        }
        
        .btn-remove-service {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            font-size: 0.9em;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-remove-service:hover {
            background: #c82333;
            transform: translateY(-1px);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 3em;
            margin-bottom: 15px;
            opacity: 0.5;
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
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .tour-info-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .tour-info-card h4 {
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .tour-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .tour-detail-item {
            text-align: center;
        }
        
        .tour-detail-label {
            color: #666;
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        
        .tour-detail-value {
            color: #333;
            font-weight: 600;
            font-size: 1.1em;
        }
        
        @media (max-width: 1200px) {
            .services-container {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .section-content {
                padding: 20px;
            }
            
            .tour-details {
                grid-template-columns: 1fr;
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
            <h1><i class="fa fa-cogs"></i> Quản lý Dịch vụ Tour</h1>
            <p>Thêm và quản lý các dịch vụ cho tour</p>
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
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/staff/tours?action=view&id=${tour.tourId}">
                        Chi tiết Tour
                    </a>
                </li>
                <li class="breadcrumb-item active">Quản lý Dịch vụ</li>
            </ol>
        </nav>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="fa fa-check-circle"></i> ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-circle"></i> ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Tour Information -->
        <c:if test="${not empty tour}">
            <div class="tour-info-card">
                <h4><i class="fa fa-info-circle"></i> Thông tin Tour</h4>
                <div class="tour-details">
                    <div class="tour-detail-item">
                        <div class="tour-detail-label">Tên Tour</div>
                        <div class="tour-detail-value">${tour.tourName}</div>
                    </div>
                    <div class="tour-detail-item">
                        <div class="tour-detail-label">ID Tour</div>
                        <div class="tour-detail-value">#${tour.tourId}</div>
                    </div>
                    <div class="tour-detail-item">
                        <div class="tour-detail-label">Giá Tour</div>
                        <div class="tour-detail-value">
                            <fmt:formatNumber value="${tour.price}" type="currency" 
                                            currencySymbol="₫" groupingUsed="true"/>
                        </div>
                    </div>
                    <div class="tour-detail-item">
                        <div class="tour-detail-label">Đảo</div>
                        <div class="tour-detail-value">${tour.islandName}</div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Services Management -->
        <div class="services-container">
            <!-- Current Services -->
            <div class="services-section">
                <div class="section-header">
                    <h3><i class="fa fa-list"></i> Dịch vụ hiện tại</h3>
                </div>
                <div class="section-content">
                    <c:choose>
                        <c:when test="${not empty currentServices}">
                            <!-- Danh sách dịch vụ hiện tại (không gồm Vé máy bay) -->
                            <c:forEach var="service" items="${currentServices}">
                                <c:if test="${service.serviceType ne 'FLIGHT' && service.serviceType ne 'AIRLINE'}">
                                    <div class="service-card" data-service-type="${service.serviceType}">
                                        <div class="service-type-badge service-type-${service.serviceType.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${service.serviceType == 'Hotel'}">Khách sạn</c:when>
                                                <c:when test="${service.serviceType == 'Place'}">Địa điểm</c:when>
                                                <c:when test="${service.serviceType == 'Vehicle'}">Phương tiện</c:when>
                                                <c:when test="${service.serviceType == 'Restaurant'}">Nhà hàng</c:when>
                                                <c:otherwise>${service.serviceType}</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="service-name">
                                            ${not empty service.serviceName ? service.serviceName : 'Dịch vụ ID: '.concat(service.serviceId)}
                                        </div>
                                        <c:if test="${not empty service.serviceDescription}">
                                            <div class="service-description">
                                                ${service.serviceDescription}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty service.servicePrice}">
                                            <div class="service-price">
                                                <fmt:formatNumber value="${service.servicePrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </div>
                                        </c:if>
                                        <div class="service-actions">
                                            <small class="text-muted">
                                                <i class="fa fa-calendar"></i>
                                                <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                            <form method="post" action="${pageContext.request.contextPath}/staff/tours" style="display: inline; margin-left: auto;">
                                                <input type="hidden" name="action" value="remove-service">
                                                <input type="hidden" name="tourId" value="${tour.tourId}">
                                                <input type="hidden" name="tourServiceId" value="${service.tourServiceId}">
                                                <button type="submit" class="btn-remove-service" onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này?')">
                                                    <i class="fa fa-trash"></i> Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <!-- Vé máy bay hiện tại -->
                            <hr style="margin: 20px 0;">
                            <h4 style="display:flex;align-items:center;gap:8px;"><i class="fa fa-plane"></i> Vé máy bay</h4>
                            <c:set var="flightCount" value="0"/>
                            <c:forEach var="service" items="${currentServices}">
                                <c:if test="${service.serviceType == 'FLIGHT' || service.serviceType == 'AIRLINE'}">
                                    <c:set var="flightCount" value="${flightCount + 1}"/>
                                    <div class="service-card" data-service-type="FLIGHT">
                                        <div class="service-type-badge service-type-airline">Vé máy bay</div>
                                        <div class="service-name">
                                            ${not empty service.serviceName ? service.serviceName : 'Vé máy bay ID: '.concat(service.serviceId)}
                                        </div>
                                        <c:if test="${not empty service.serviceDescription}">
                                            <div class="service-description">
                                                ${service.serviceDescription}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty service.servicePrice}">
                                            <div class="service-price">
                                                <fmt:formatNumber value="${service.servicePrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </div>
                                        </c:if>
                                        <div class="service-actions">
                                            <small class="text-muted">
                                                <i class="fa fa-calendar"></i>
                                                <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                            <form method="post" action="${pageContext.request.contextPath}/staff/tours" style="display: inline; margin-left: auto;">
                                                <input type="hidden" name="action" value="remove-service">
                                                <input type="hidden" name="tourId" value="${tour.tourId}">
                                                <input type="hidden" name="tourServiceId" value="${service.tourServiceId}">
                                                <button type="submit" class="btn-remove-service" onclick="return confirm('Bạn có chắc chắn muốn xóa vé máy bay này?')">
                                                    <i class="fa fa-trash"></i> Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${flightCount == 0}">
                                <div class="empty-state">
                                    <i class="fa fa-plane"></i>
                                    <p>Chưa có vé máy bay nào trong tour này</p>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fa fa-cogs"></i>
                                <p>Chưa có dịch vụ nào được thêm vào tour này</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Available Services -->
            <div class="services-section">
                <div class="section-header">
                    <h3><i class="fa fa-plus-circle"></i> Dịch vụ có sẵn</h3>
                    <div style="margin-top: 15px;">
                        <label for="serviceTypeFilter" style="margin-right: 10px; font-weight: 600;">Lọc theo loại:</label>
                        <select id="serviceTypeFilter" class="form-control" style="display: inline-block; width: auto; min-width: 200px;">
                            <option value="all">Tất cả</option>
                            <option value="Hotel">Khách sạn</option>
                            <option value="Place">Địa điểm</option>
                            <option value="Vehicle">Phương tiện</option>
                            <option value="Restaurant">Nhà hàng</option>
                            <option value="FLIGHT">Vé máy bay</option>
                        </select>
                    </div>
                </div>
                <div class="section-content">
                    <c:choose>
                        <c:when test="${not empty availableServices}">
                            <!-- Danh sách dịch vụ khả dụng (không gồm Vé máy bay) -->
                            <c:forEach var="service" items="${availableServices}">
                                <c:if test="${service.serviceType ne 'FLIGHT'}">
                                    <div class="service-card" data-service-type="${service.serviceType}">
                                        <div class="service-type-badge service-type-${service.serviceType.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${service.serviceType == 'Hotel'}">Khách sạn</c:when>
                                                <c:when test="${service.serviceType == 'Place'}">Địa điểm</c:when>
                                                <c:when test="${service.serviceType == 'Vehicle'}">Phương tiện</c:when>
                                                <c:when test="${service.serviceType == 'Restaurant'}">Nhà hàng</c:when>
                                                <c:otherwise>${service.serviceType}</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="service-name">
                                            ${not empty service.serviceName ? service.serviceName : 'Dịch vụ ID: '.concat(service.serviceId)}
                                        </div>
                                        <c:if test="${not empty service.serviceDescription}">
                                            <div class="service-description">
                                                ${service.serviceDescription}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty service.servicePrice}">
                                            <div class="service-price">
                                                <fmt:formatNumber value="${service.servicePrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </div>
                                        </c:if>
                                        <div class="service-actions">
                                            <form method="post" action="${pageContext.request.contextPath}/staff/tours" style="display: inline;">
                                                <input type="hidden" name="action" value="add-service">
                                                <input type="hidden" name="tourId" value="${tour.tourId}">
                                                <input type="hidden" name="serviceType" value="${service.serviceType}">
                                                <input type="hidden" name="serviceId" value="${service.serviceId}">
                                                <button type="submit" class="btn-add-service">
                                                    <i class="fa fa-plus"></i> Thêm vào tour
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <!-- Vé máy bay khả dụng -->
                            <hr style="margin: 20px 0;">
                            <h4 style="display:flex;align-items:center;gap:8px;"><i class="fa fa-plane"></i> Vé máy bay khả dụng</h4>
                            <c:set var="availableFlightCount" value="0"/>
                            <c:forEach var="service" items="${availableServices}">
                                <c:if test="${service.serviceType == 'FLIGHT'}">
                                    <c:set var="availableFlightCount" value="${availableFlightCount + 1}"/>
                                    <div class="service-card" data-service-type="FLIGHT">
                                        <div class="service-type-badge service-type-airline">Vé máy bay</div>
                                        <div class="service-name">
                                            ${not empty service.serviceName ? service.serviceName : 'Vé máy bay ID: '.concat(service.serviceId)}
                                        </div>
                                        <c:if test="${not empty service.serviceDescription}">
                                            <div class="service-description">
                                                ${service.serviceDescription}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty service.servicePrice}">
                                            <div class="service-price">
                                                <fmt:formatNumber value="${service.servicePrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </div>
                                        </c:if>
                                        <div class="service-actions">
                                            <form method="post" action="${pageContext.request.contextPath}/staff/tours" style="display: inline;">
                                                <input type="hidden" name="action" value="add-service">
                                                <input type="hidden" name="tourId" value="${tour.tourId}">
                                                <input type="hidden" name="serviceType" value="${service.serviceType}">
                                                <input type="hidden" name="serviceId" value="${service.serviceId}">
                                                <button type="submit" class="btn-add-service">
                                                    <i class="fa fa-plus"></i> Thêm vào tour
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${availableFlightCount == 0}">
                                <div class="empty-state">
                                    <i class="fa fa-plane"></i>
                                    <p>Không có vé máy bay khả dụng cho đảo này</p>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fa fa-exclamation-triangle"></i>
                                <p>Không có dịch vụ nào khả dụng cho đảo này</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/staff/tours?action=view&id=${tour.tourId}" 
               class="btn btn-secondary" style="margin-right: 10px;">
                <i class="fa fa-arrow-left"></i> Quay lại chi tiết tour
            </a>
            <a href="${pageContext.request.contextPath}/staff/tours?action=list" 
               class="btn btn-primary">
                <i class="fa fa-list"></i> Danh sách tour
            </a>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);

        // Add hover effects to service cards
        $(document).ready(function() {
            $('.service-card').hover(
                function() {
                    $(this).css({
                        'transform': 'translateY(-2px)',
                        'box-shadow': '0 5px 15px rgba(0,0,0,0.1)'
                    });
                },
                function() {
                    $(this).css({
                        'transform': 'translateY(0)',
                        'box-shadow': 'none'
                    });
                }
            );
            
            // Filter services by type in "Available Services" section
            $('#serviceTypeFilter').on('change', function() {
                var selectedType = $(this).val();
                var $availableSection = $('.services-section').eq(1); // Second section (Available Services)
                var $serviceCards = $availableSection.find('.service-card');
                var $hrElements = $availableSection.find('hr');
                var $flightHeaders = $availableSection.find('h4:contains("Vé máy bay")').parent();
                
                if (selectedType === 'all') {
                    $serviceCards.show();
                    $hrElements.show();
                    $flightHeaders.show();
                } else {
                    $serviceCards.each(function() {
                        var serviceType = $(this).attr('data-service-type');
                        var shouldShow = false;
                        
                        if (selectedType === 'FLIGHT') {
                            shouldShow = (serviceType === 'FLIGHT' || serviceType === 'AIRLINE');
                        } else {
                            shouldShow = (serviceType === selectedType);
                        }
                        
                        if (shouldShow) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                    
                    // Show/hide flight section header
                    if (selectedType === 'FLIGHT') {
                        $hrElements.show();
                        $flightHeaders.show();
                    } else {
                        $hrElements.hide();
                        $flightHeaders.hide();
                    }
                }
            });
        });
    </script>
</body>
</html>