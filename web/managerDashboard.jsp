<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - SmartTravel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        :root {
            --sidebar-width: 250px;
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --bg-light: #f4f7f6;
            --text-dark: #333;
            --sidebar-bg: #2c3e50;
            --active-color: #1abc9c;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-light);
            color: var(--text-dark);
            display: flex; /* Kích hoạt Flexbox cho layout chính */
            min-height: 100vh;
        }

        /* ------------------- Sidebar (Menu) ------------------- */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--sidebar-bg);
            color: #ecf0f1;
            padding: 20px 0;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
        }

        .sidebar h3 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--active-color);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 10px;
            font-weight: 600;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-item-group h4 {
            color: rgba(255, 255, 255, 0.6);
            padding: 10px 20px;
            margin-top: 15px;
            font-size: 0.85rem;
            text-transform: uppercase;
            font-weight: 700;
        }

        .sidebar-menu a {
            display: block;
            padding: 12px 20px 12px 25px;
            text-decoration: none;
            color: #ecf0f1;
            font-size: 15px;
            transition: background 0.2s, color 0.2s;
            border-left: 5px solid transparent;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background-color: #34495e;
            color: var(--active-color);
            border-left: 5px solid var(--active-color);
        }

        .sidebar-menu i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        /* ------------------- Main Content ------------------- */
        .main-content {
            flex-grow: 1; /* Cho phép vùng nội dung chiếm hết không gian còn lại */
            padding: 20px;
        }

        .header {
            background: #fff;
            padding: 15px 30px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
            color: var(--primary-color);
        }
        
        .user-info {
            font-size: 14px;
            color: var(--secondary-color);
        }

        .content-frame {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            /* Dùng để nhúng nội dung động (ví dụ: iframe) */
        }
        
        /* Placeholder styling for demo */
        .placeholder {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--secondary-color);
            font-size: 1.2rem;
            border: 2px dashed var(--border-color);
            border-radius: 6px;
        }
    </style>
</head>
<body>
    
    <div class="sidebar">
        <h3><i class="fas fa-tools"></i> MANAGER PANEL</h3>
        
        <ul class="sidebar-menu">
            
            <li class="menu-item-group"><h4>1. Quản lý Booking</h4></li>
            <li><a href="<c:url value="/manager/bookings"/>" class="active"><i class="fas fa-calendar-check"></i> Xem danh sách Booking</a></li>
            <li><a href="<c:url value="/manager/bookings/action"/>"><i class="fas fa-edit"></i> Xử lý & Xác nhận/Hủy</a></li>
            <li><a href="<c:url value="/manager/bookings/status"/>"><i class="fas fa-chart-line"></i> Giám sát Trạng thái</a></li>
            
            <li class="menu-item-group"><h4>2. Quản lý Dịch vụ/Tour</h4></li>
            <li><a href="<c:url value="/manager/tours"/>"><i class="fas fa-globe-asia"></i> Thêm/Sửa/Xóa Tour</a></li>
            <li><a href="<c:url value="/manager/tours/update"/>"><i class="fas fa-calendar-alt"></i> Cập nhật Lịch trình/Tình trạng</a></li>
            
            <li class="menu-item-group"><h4>3. Quản lý Thanh toán</h4></li>
            <li><a href="<c:url value="/manager/payments/history"/>"><i class="fas fa-history"></i> Xem lịch sử giao dịch</a></li>
            <li><a href="<c:url value="/manager/payments/refund"/>"><i class="fas fa-undo-alt"></i> Xử lý Vấn đề Thanh toán</a></li>
            
            <li class="menu-item-group"><h4>4. Quản lý Khách hàng</h4></li>
            <li><a href="<c:url value="/manager/customer"/>"><i class="fas fa-users"></i> Xem thông tin Khách hàng</a></li>
            
            <li class="menu-item-group"><h4>5. Tạo Báo cáo</h4></li>
            <li><a href="<c:url value="/admin/report"/>"><i class="fas fa-chart-pie"></i> Tạo báo cáo Doanh số</a></li>
            
            <li class="menu-item-group"><h4>6. Giám sát Staff</h4></li>
            <li><a href="<c:url value="/manager/staff/monitor"/>"><i class="fas fa-user-secret"></i> Giám sát Hoạt động Staff</a></li>
            <li><a href="<c:url value="/manager/staff/performance"/>"><i class="fas fa-award"></i> Đánh giá Hiệu suất Staff</a></li>
            
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Quản lý Tổng quan</h1>
            <div class="user-info">
                Xin chào, **${sessionScope.user.fullName}** | 
                <a href="<c:url value="/logout"/>" style="color: #e74c3c;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
            </div>
        </div>
        
        <div class="content-frame">
            <div class="placeholder">
                Vui lòng chọn chức năng từ menu bên trái.
            </div>
            
            </div>
        
    </div>

</body>
</html>