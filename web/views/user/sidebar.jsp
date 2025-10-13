<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    .sidebar {
        width: 230px;
        background-color: #1f2937;
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        padding-top: 70px;
        color: #e5e7eb;
    }

    .sidebar a {
        display: block;
        color: #d1d5db;
        padding: 12px 20px;
        text-decoration: none;
        transition: all 0.2s;
        font-size: 0.95rem;
    }

    .sidebar a:hover {
        background-color: #374151;
        color: white;
    }

    .sidebar .active {
        background-color: #2563eb;
        color: white;
        font-weight: 600;
    }

    .sidebar i {
        margin-right: 10px;
    }
</style>

<nav class="sidebar">
    <a href="dashboard.jsp"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
    <a href="user?action=list" class="active"><i class="fa-solid fa-users"></i> Quản lý người dùng</a>
    <a href="booking?action=list"><i class="fa-solid fa-calendar-check"></i> Quản lý đặt chỗ</a>
    <a href="report?action=view"><i class="fa-solid fa-chart-pie"></i> Báo cáo & Thống kê</a>
    <a href="settings.jsp"><i class="fa-solid fa-gear"></i> Cài đặt hệ thống</a>
</nav>
