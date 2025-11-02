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
    <a href="${pageContext.request.contextPath}/admin/dashboard-user">
        <i class="fa-solid fa-chart-line"></i> Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/admin/user?action=list" class="active">
        <i class="fa-solid fa-users"></i> Quản lý người dùng
    </a>



    <a href="${pageContext.request.contextPath}/admin/logs">
        <i class="fa-solid fa-clipboard-list"></i> Nhật ký hệ thống
    </a>




</nav>
