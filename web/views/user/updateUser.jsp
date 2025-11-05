<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Cập nhật thông tin người dùng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>

<body class="bg-light">

<div class="container mt-5">
    <h3 class="mb-4 text-primary">Cập nhật thông tin người dùng</h3>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="user" method="post" class="card p-4 shadow-sm">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="userId" value="${user.userId}">

        <div class="mb-3">
            <label class="form-label">Tên đăng nhập (Username)</label>
            <input type="text" name="username" class="form-control" value="${user.username}" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" value="${user.email}" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">Họ và tên</label>
            <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Số điện thoại</label>
            <input type="text" name="phone" class="form-control" value="${user.phone}">
        </div>

        <div class="mb-3">
    <label class="form-label">Vai trò (Role)</label>
    <select name="roleId" class="form-select" required>
        <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Quản trị viên (Admin)</option>
        <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Nhân viên (Staff)</option>
        <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Người dùng (User)</option>
    </select>
</div>

        <div class="mb-3">
            <label class="form-label">Trạng thái</label>
            <select name="status" class="form-select">
                <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                <option value="LOCKED" ${user.status == 'LOCKED' ? 'selected' : ''}>LOCKED</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Cập nhật</button>
        <a href="user?action=list" class="btn btn-secondary">Quay lại</a>
    </form>
</div>

</body>
</html>
