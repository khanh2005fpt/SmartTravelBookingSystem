<%-- 
    Document   : tour-itinerary
    Created on : Staff Tour Itinerary Management Page
    Author     : System
    Description: Form for creating and managing tour itineraries
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Tour" %>
<%@ page import="model.TourItinerary" %>
<%@ page import="model.TourActivities" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch trình Tour - ${tour.tourName} - Meland Travel</title>
    
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
           background: linear-gradient(180deg, #0077b6, #00b4d8);
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
        
        .tour-tabs {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .tab-navigation {
            display: flex;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .tab-item {
            flex: 1;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
            font-weight: 500;
        }
        
        .tab-item:hover {
            background: #e9ecef;
        }
        
        .tab-item.active {
            background: white;
            border-bottom-color: #00ACD4;
            color: #007CB9;
        }
        
        .tab-content {
            display: block;
            padding: 30px;
        }
        
        .tab-pane {
            display: none;
        }
        
        .tab-pane.active {
            display: block;
        }
        
        .itinerary-form {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .day-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .day-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .day-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #333;
        }
        
        .activity-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid #00ACD4;
        }
        
        .activity-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .activity-title {
            font-weight: 600;
            color: #333;
        }
        
        .activity-description {
            color: #666;
            font-size: 0.9em;
        }
        
        .btn-add-day {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-add-day:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        
        .btn-add-activity {
            background: linear-gradient(180deg, #0077b6, #00b4d8);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            font-size: 0.9em;
        }
        
        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.8em;
        }
        .breadcrumb {
            margin: 0;
            background: none;
            padding: 10px;
        }
        
        .breadcrumb-item a {
            color: #00ACD4;
            text-decoration: none;
        }
        
        .breadcrumb-item a:hover {
            text-decoration: underline;
        }
        
        .breadcrumb-item.active {
            color: #6c757d;
        }
        
        /* Management tab specific styles */
        .manage-itinerary-content .day-section {
            margin-bottom: 25px;
        }

        .day-actions {
            display: flex;
            gap: 10px;
        }

        .day-actions .btn {
            padding: 5px 12px;
            font-size: 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .day-actions .btn-warning {
       background: linear-gradient(180deg, #f59e0b, #fbbf24);;
            color: white;
        }

        .day-actions .btn-warning:hover {
            background: #ed8936;
        }

        .day-actions .btn-danger {
            background: linear-gradient(180deg, #c0392b, #e74c3c);
            color: white;
        }

        .day-actions .btn-danger:hover {
            background: #f56565;
        }

        .activities-list {
            margin: 15px 0;
        }

        .activity-actions {
            display: flex;
            gap: 5px;
        }
        .btn-tourList{
             background: linear-gradient(180deg, #0077b6, #00b4d8);
              color: white;
              padding: 8px 16px;
    border-radius: 8px;
        }
        .btn-saveItinerary{
              background: linear-gradient(180deg, #0077b6, #00b4d8);
              color: white;
              padding: 8px 16px;
    border-radius: 8px;
        }
        .btn-addActivity{
             background: linear-gradient(180deg, #0077b6, #00b4d8);
              color: white;
              padding: 8px 16px;
    border-radius: 8px;
        }
        .activity-actions .btn-xs {
            padding: 3px 8px;
            font-size: 11px;
            border-radius: 3px;
            border: none;
            cursor: pointer;
        }

        .activity-actions .btn-info {
               background: linear-gradient(180deg, #0077b6, #00b4d8);

            color: white;
        }

        .activity-actions .btn-info:hover {
            background: #4299e1;
        }

        .day-footer {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e2e8f0;
        }

        .day-footer .btn-success {
            background: #48bb78;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
        }

        .day-footer .btn-success:hover {
            background: #38a169;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        
        .tour-info-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 12px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
    <!-- Include sidebar -->
    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fa fa-calendar-alt"></i> Lịch trình Tour</h1>
            <p>Tạo và quản lý lịch trình chi tiết cho tour</p>
        </div>

        <!-- Breadcrumb Navigation -->
        <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/views/staff/index.jsp">
                        <i class="fa fa-home"></i> Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/staff/tours?action=list">
                        <i class="fa fa-map-marker"></i> Quản lý Tour
                    </a>
                </li>
                <li class="breadcrumb-item active">Lịch trình Tour</li>
            </ol>
        </nav>

        <!-- Success Message -->
        <c:if test="${not empty successMessage}">
            <div class="success-message">
                <i class="fa fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>

        <!-- Tour Information -->
        <c:if test="${not empty tour}">
            <div class="tour-info-card">
                <h4><i class="fa fa-info-circle"></i> Thông tin Tour</h4>
                <div class="row">
                    <div class="col-md-6">
                        <strong>Tên Tour:</strong> ${tour.tourName}
                    </div>
                    <div class="col-md-6">
                        <strong>ID Tour:</strong> #${tour.tourId}
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Tab Navigation -->
        <div class="tour-tabs">
            <div class="tab-navigation">
                <div class="tab-item active" data-tab="overview">
                    <i class="fa fa-eye"></i> Tổng quan
                </div>
                <div class="tab-item" data-tab="create-itinerary">
                    <i class="fa fa-plus"></i> Tạo lịch trình
                </div>
                <div class="tab-item" data-tab="manage-itinerary">
                    <i class="fa fa-edit"></i> Quản lý lịch trình
                </div>
            </div>

            <div class="tab-content">
                <!-- Overview Tab -->
                <div class="tab-pane active" id="overview">
                    <h3><i class="fa fa-calendar-check"></i> Lịch trình hiện tại</h3>
                    
                    <c:choose>
                        <c:when test="${not empty tourItineraries}">
                            <c:forEach var="itinerary" items="${tourItineraries}">
                                <div class="day-section">
                                    <div class="day-header">
                                        <div class="day-title">
                                            <i class="fa fa-calendar"></i> Ngày ${itinerary.dayNumber}: ${itinerary.title}
                                        </div>
                                        <div>
                                            <button class="btn btn-sm btn-warning" onclick="editItinerary(${itinerary.itineraryId})">
                                                <i class="fa fa-edit"></i> Sửa
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteItinerary(${itinerary.itineraryId})">
                                                <i class="fa fa-trash"></i> Xóa
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty itinerary.activities}">
                                        <c:forEach var="activity" items="${itinerary.activities}">
                                            <div class="activity-item">
                                                <div class="activity-header">
                                                    <div class="activity-title">
                                                        ${activity.activityOrder}. ${activity.activityTitle}
                                                    </div>
                                                </div>
                                                <div class="activity-description">
                                                    ${activity.description}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center" style="padding: 40px;">
                                <i class="fa fa-calendar-times" style="font-size: 3em; color: #ccc; margin-bottom: 20px;"></i>
                                <h4>Chưa có lịch trình</h4>
                                <p class="text-muted">Hãy tạo lịch trình đầu tiên cho tour này</p>
                                <button class="btn-add-day" onclick="switchTab('create-itinerary')">
                                    <i class="fa fa-plus"></i> Tạo lịch trình ngay
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Create Itinerary Tab -->
                <div class="tab-pane" id="create-itinerary">
                    <h3><i class="fa fa-plus-circle"></i> Tạo lịch trình mới</h3>
                    
                    <form id="itineraryForm" method="post" action="${pageContext.request.contextPath}/staff/tours">
                        <input type="hidden" name="action" value="create-itinerary">
                        <input type="hidden" name="tourId" value="${tour.tourId}">
                        
                        <div id="itinerary-days">
                            <!-- Days will be added dynamically -->
                        </div>
                        
                        <div class="text-center" style="margin: 30px 0;">
                            <button type="button" class="btn-add-day" onclick="addDay()">
                                <i class="fa fa-plus"></i> Thêm ngày
                            </button>
                        </div>
                        
                        <div class="text-center">
                            <button type="submit" class="btn btn-saveItinerary btn-lg">
                                <i class="fa fa-save"></i> Lưu lịch trình
                            </button>
                            <button type="button" class="btn btn-secondary btn-lg ml-3" onclick="switchTab('overview')">
                                <i class="fa fa-times"></i> Hủy
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Manage Itinerary Tab -->
                <div class="tab-pane" id="manage-itinerary">
                    <h3><i class="fa fa-cogs"></i> Quản lý lịch trình</h3>
                    <p class="text-muted">Chỉnh sửa và cập nhật lịch trình tour</p>
                    
                    <!-- Content will be loaded dynamically -->
                    <div id="manage-content">
                        <c:choose>
                            <c:when test="${not empty tourItineraries}">
                                <div class="manage-itinerary-content">
                                    <c:forEach var="itinerary" items="${tourItineraries}">
                                        <div class="day-section" data-itinerary-id="${itinerary.itineraryId}">
                                            <div class="day-header">
                                                <div class="day-title">
                                                    <i class="fa fa-calendar"></i> Ngày ${itinerary.dayNumber}: ${itinerary.title}
                                                </div>
                                                <div class="day-actions">
                                                    <button class="btn btn-sm btn-warning" onclick="editItinerary(${itinerary.itineraryId})">
                                                        <i class="fa fa-edit"></i> Sửa
                                                    </button>
                                                    <button class="btn btn-sm btn-danger" onclick="deleteItinerary(${itinerary.itineraryId})">
                                                        <i class="fa fa-trash"></i> Xóa
                                                    </button>
                                                </div>
                                            </div>
                                            
                                            <c:if test="${not empty itinerary.activities}">
                                                <div class="activities-list">
                                                    <c:forEach var="activity" items="${itinerary.activities}">
                                                        <div class="activity-item" data-activity-id="${activity.activityId}">
                                                            <div class="activity-header">
                                                                <div class="activity-title">
                                                                    <i class="fa fa-clock"></i> ${activity.activityTitle}
                                                                </div>
                                                                <div class="activity-actions">
                                                                    <button class="btn btn-xs btn-info" onclick="editActivity(${activity.activityId})">
                                                                        <i class="fa fa-edit"></i>
                                                                    </button>
                                                                    <button class="btn btn-xs btn-danger" onclick="deleteActivity(${activity.activityId})">
                                                                        <i class="fa fa-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <div class="activity-description">
                                                                ${activity.description}
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                            
                                            <div class="day-footer">
                                                <button class="btn btn-sm btn-addActivity" onclick="addActivityToDay(${itinerary.itineraryId})">
                                                    <i class="fa fa-plus"></i> Thêm hoạt động
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    
                                    <div class="text-center mt-4">
                                        <button class="btn-add-day" onclick="addNewDay()">
                                            <i class="fa fa-plus"></i> Thêm ngày mới
                                        </button>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center" style="padding: 40px;">
                                    <i class="fa fa-calendar-times" style="font-size: 3em; color: #ccc; margin-bottom: 20px;"></i>
                                    <h4>Chưa có lịch trình</h4>
                                    <p class="text-muted">Hãy tạo lịch trình đầu tiên cho tour này</p>
                                    <button class="btn-add-day" onclick="switchTab('create-itinerary')">
                                        <i class="fa fa-plus"></i> Tạo lịch trình ngay
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="text-center" style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/staff/tours?action=view&id=${tour.tourId}" 
               class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Quay lại chi tiết tour
            </a>
            <a href="${pageContext.request.contextPath}/staff/tours?action=list" 
               class="btn btn-tourList ml-3">
                <i class="fa fa-list"></i> Danh sách tour
            </a>
        </div>
    </div>

    <!-- Include common scripts -->
    <jsp:include page="../common/script.jsp" />

    <script>
        let dayCounter = 0;
        
        // Initialize dayCounter based on existing itineraries
        document.addEventListener('DOMContentLoaded', function() {
            // Find the highest day number from existing itineraries
            const existingDays = document.querySelectorAll('.day-section[data-itinerary-id]');
            let maxDayNumber = 0;
            
            existingDays.forEach(function(daySection) {
                const dayTitle = daySection.querySelector('.day-title');
                if (dayTitle) {
                    const dayText = dayTitle.textContent;
                    const dayMatch = dayText.match(/Ngày (\d+):/);
                    if (dayMatch) {
                        const dayNumber = parseInt(dayMatch[1]);
                        if (dayNumber > maxDayNumber) {
                            maxDayNumber = dayNumber;
                        }
                    }
                }
            });
            
            // Set dayCounter to the next available day number
            dayCounter = maxDayNumber;
            
            // Check if we're on create tab and no days exist
            const createTab = document.getElementById('create-itinerary');
            const itineraryDays = document.getElementById('itinerary-days');
            
            if (itineraryDays && itineraryDays.children.length === 0) {
                addDay(); // Add first day automatically
            }
        });

        // Tab switching functionality
        function switchTab(tabName) {
            // Remove active class from all tabs and panes
            document.querySelectorAll('.tab-item').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
            
            // Add active class to selected tab and pane with null checks
            const targetTab = document.querySelector('[data-tab="' + tabName + '"]');
            const targetPane = document.getElementById(tabName);
            
            if (targetTab) {
                targetTab.classList.add('active');
            } else {
                console.error('Tab with data-tab="' + tabName + '" not found');
            }
            
            if (targetPane) {
                targetPane.classList.add('active');
            } else {
                console.error('Tab pane with id="' + tabName + '" not found');
            }
        }

        // Add event listeners to tabs
        document.querySelectorAll('.tab-item').forEach(tab => {
            tab.addEventListener('click', function() {
                const tabName = this.getAttribute('data-tab');
                switchTab(tabName);
            });
        });

        // Add new day to itinerary
        function addDay() {
            dayCounter++;
            const dayHtml = '<div class="day-section" id="day-' + dayCounter + '">' +
                '<div class="day-header">' +
                    '<div class="day-title">' +
                        '<i class="fa fa-calendar"></i> Ngày ' + dayCounter +
                    '</div>' +
                    '<button type="button" class="btn-remove" onclick="removeDay(' + dayCounter + ')">' +
                        '<i class="fa fa-trash"></i> Xóa ngày' +
                    '</button>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label class="form-label">Tiêu đề ngày:</label>' +
                    '<input type="text" class="form-control" name="dayTitle_' + dayCounter + '" ' +
                           'placeholder="Ví dụ: Khám phá thành phố" required>' +
                    '<input type="hidden" name="dayNumber_' + dayCounter + '" value="' + dayCounter + '">' +
                '</div>' +
                '<div class="activities-container" id="activities-' + dayCounter + '">' +
                    '<h5><i class="fa fa-list"></i> Hoạt động trong ngày</h5>' +
                '</div>' +
                '<button type="button" class="btn-add-activity" onclick="addActivity(' + dayCounter + ')">' +
                    '<i class="fa fa-plus"></i> Thêm hoạt động' +
                '</button>' +
            '</div>';
            
            document.getElementById('itinerary-days').insertAdjacentHTML('beforeend', dayHtml);
            addActivity(dayCounter); // Add first activity automatically
        }

        // Remove day from itinerary
        function removeDay(dayNumber) {
            if (confirm('Bạn có chắc chắn muốn xóa ngày này?')) {
                document.getElementById('day-' + dayNumber).remove();
            }
        }

        // Add activity to a day
        function addActivity(dayNumber) {
            const activitiesContainer = document.getElementById('activities-' + dayNumber);
            const activityCount = activitiesContainer.querySelectorAll('.activity-item').length + 1;
            
            const activityHtml = '<div class="activity-item">' +
                '<div class="form-group">' +
                    '<label class="form-label">Hoạt động ' + activityCount + ':</label>' +
                    '<input type="text" class="form-control" name="activityTitle_' + dayNumber + '_' + activityCount + '" ' +
                           'placeholder="Tên hoạt động" required>' +
                    '<input type="hidden" name="activityOrder_' + dayNumber + '_' + activityCount + '" value="' + activityCount + '">' +
                '</div>' +
                '<div class="form-group">' +
                    '<label class="form-label">Mô tả:</label>' +
                    '<textarea class="form-control" name="activityDescription_' + dayNumber + '_' + activityCount + '" ' +
                              'rows="3" placeholder="Mô tả chi tiết hoạt động"></textarea>' +
                '</div>' +
                '<button type="button" class="btn-remove" onclick="removeActivity(this)">' +
                    '<i class="fa fa-trash"></i> Xóa hoạt động' +
                '</button>' +
            '</div>';
            
            activitiesContainer.insertAdjacentHTML('beforeend', activityHtml);
        }

        // Remove activity
        function removeActivity(button) {
            if (confirm('Bạn có chắc chắn muốn xóa hoạt động này?')) {
                button.closest('.activity-item').remove();
            }
        }

        // Management functions for existing itineraries
        function editItinerary(itineraryId) {
            // Redirect to edit itinerary page
            var tourId = '<c:out value="${tour.tourId}" />';
            window.location.href = '<c:out value="${pageContext.request.contextPath}" />' + '/staff/tours?action=edit-itinerary&id=' + itineraryId + '&tourId=' + tourId;
        }

        function deleteItinerary(itineraryId) {
            if (confirm('Bạn có chắc chắn muốn xóa ngày này khỏi lịch trình?')) {
                // Send delete request to server
                var tourId = '<c:out value="${tour.tourId}" />';
                window.location.href = '<c:out value="${pageContext.request.contextPath}" />' + '/staff/tours?action=deleteItinerary&id=' + itineraryId + '&tourId=' + tourId;
            }
        }

        function editActivity(activityId) {
            // Get the tour ID from the current URL or form
            var tourId = '<c:out value="${tour.tourId}" />';
            
            // Redirect to edit activity page
            window.location.href = '<c:out value="${pageContext.request.contextPath}" />' + 
                                 '/staff/tours?action=edit-activity&id=' + activityId + '&tourId=' + tourId;
        }

        function deleteActivity(activityId) {
            if (confirm('Bạn có chắc chắn muốn xóa hoạt động này?')) {
                // Send delete request to server
                var tourId = '<c:out value="${tour.tourId}" />';
                window.location.href = '<c:out value="${pageContext.request.contextPath}" />' + '/staff/tours?action=deleteActivity&id=' + activityId + '&tourId=' + tourId;
            }
        }

        function addActivityToDay(itineraryId) {
            // Redirect to add activity to itinerary page
            var tourId = '<c:out value="${tour.tourId}" />';
            window.location.href = '<c:out value="${pageContext.request.contextPath}" />' + 
                                 '/staff/tours?action=add-activity-to-itinerary&id=' + itineraryId + '&tourId=' + tourId;
        }

        function addNewDay() {
            // Switch to create tab to add new day
            switchTab('create-itinerary');
        }

        // JavaScript variables from server-side data
        const fromCreate = '<c:out value="${param.fromCreate}" />' === 'true';
        const hasSuccessMessage = '<c:out value="${not empty successMessage}" />' === 'true';

        // Show success message if redirected from tour creation
        if (fromCreate) {
            document.addEventListener('DOMContentLoaded', function() {
                // Only show JavaScript success message if there's no server-side success message
                if (!hasSuccessMessage) {
                    // Show success notification
                    const successMsg = document.createElement('div');
                    successMsg.className = 'success-message';
                    successMsg.innerHTML = '<i class="fa fa-check-circle"></i> Tour đã được tạo thành công! Bây giờ hãy tạo lịch trình cho tour.';
                    const mainContent = document.querySelector('.main-content');
                    const tourTabs = document.querySelector('.tour-tabs');
                    if (mainContent && tourTabs) {
                        mainContent.insertBefore(successMsg, tourTabs);
                    }
                }
                
                // Auto switch to create itinerary tab
                setTimeout(function() {
                    switchTab('create-itinerary');
                }, 1000);
            });
        }
    </script>
</body>
</html>