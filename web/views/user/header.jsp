<%@ page contentType="text/html;charset=UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

<style>
    .admin-header {
        background: linear-gradient(90deg, #007bff, #0056b3);
        color: white;
        padding: 15px 25px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .admin-header .brand {
        font-size: 1.4rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .admin-header .brand i {
        font-size: 1.6rem;
    }

    .admin-header .user-info {
        font-size: 0.95rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .admin-header .user-info i {
        font-size: 1.2rem;
    }

    .logout-btn {
        color: white;
        text-decoration: none;
        font-weight: 500;
    }

    .logout-btn:hover {
        text-decoration: underline;
    }
</style>

<header class="admin-header">
    <div class="brand">
        <i class="fa-solid fa-gauge"></i>
        <span></span>
    </div>

    <div class="user-info">
        <i class="fa-solid fa-user-shield"></i>
        <span>Administrator</span> |
        <a href="logout" class="logout-btn">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</header>
