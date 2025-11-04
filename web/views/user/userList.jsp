<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>

    <style>
        /* RESET */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", sans-serif;
        }

        body {
            background: #f6f8fb;
            color: #333;
        }

        main {
            margin-left: 230px;
            padding: 30px;
        }

        /* CARD NỘI DUNG */
        .content-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 24px 28px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .page-title i {
            color: #007bff;
            margin-right: 8px;
        }

        /* THANH TÌM KIẾM + LỌC */
        .d-flex { display: flex; align-items: center; }
        .justify-content-between { justify-content: space-between; }
        .mb-3 { margin-bottom: 20px; }

        form.input-group {
            display: flex;
            gap: 8px;
            width: 50%;
        }

        .form-control {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: #007bff;
            outline: none;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-primary {
            background-color: #007bff;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .form-select {
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #fff;
            cursor: pointer;
        }

        /* BẢNG NGƯỜI DÙNG */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }

        thead {
            background: #f0f2f5;
        }

        th, td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #e5e5e5;
        }

        th {
            font-weight: 600;
            color: #333;
        }

        tbody tr:hover {
            background: #f9fafc;
        }

        /* TRẠNG THÁI */
        .status-badge {
            padding: 6px 10px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 13px;
        }

        .status-ACTIVE {
            background: #d1f7d1;
            color: #0a7a0a;
        }

        .status-LOCKED {
            background: #fde1e1;
            color: #b30000;
        }

        /* NÚT HÀNH ĐỘNG */
        .text-center { text-align: center; }

        .action-btn {
            display: inline-block;
            margin: 0 4px;
            padding: 6px 10px;
            border-radius: 6px;
            text-decoration: none;
            color: #fff;
            transition: 0.2s;
        }

        .btn-view { background: #17a2b8; }
        .btn-view:hover { background: #138496; }

        .btn-ban { background: #e74c3c; }
        .btn-ban:hover { background: #c0392b; }

        .btn-active { background: #28a745; }
        .btn-active:hover { background: #1e7e34; }

        /* PHÂN TRANG */
        .pagination {
            display: flex;
            gap: 6px;
            list-style: none;
            margin-top: 20px;
            justify-content: center;
        }

        .page-item a {
            display: block;
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 6px;
            border: 1px solid #ddd;
            color: #007bff;
            transition: 0.2s;
        }

        .page-item a:hover {
            background: #007bff;
            color: #fff;
        }

        .page-item.active a {
            background: #007bff;
            color: #fff;
            border-color: #007bff;
        }

        /* MODAL CHI TIẾT */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        .modal-overlay.show { display: flex; }

        .modal-card {
            background: #fff;
            padding: 24px 32px;
            border-radius: 10px;
            width: 400px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            animation: fadeIn 0.3s ease;
        }

        .modal-card h2 {
            margin-bottom: 16px;
            color: #007bff;
            font-size: 20px;
        }

        .modal-card table {
            width: 100%;
            border-collapse: collapse;
        }

        .modal-card th {
            text-align: left;
            color: #555;
            width: 40%;
            padding: 6px 4px;
        }

        .modal-card td {
            padding: 6px 4px;
            color: #222;
        }

        .btn-close {
            margin-top: 18px;
            background: #007bff;
            color: #fff;
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
        }
        .btn-close:hover { background: #0056b3; }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-10px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>

<body>
    <%@ include file="header.jsp" %>
    <%@ include file="sidebar.jsp" %>

    <main>
        <div class="content-card">
            <h1 class="page-title">
                <i class="fa-solid fa-users"></i> Quản lý người dùng
            </h1>

            <!-- Thanh tìm kiếm + lọc + nút thêm -->
            <div class="d-flex justify-content-between mb-3">
                <form class="input-group" method="get" action="user">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" class="form-control" placeholder="🔍 Tìm kiếm tên hoặc email" value="${keyword}">
                    <button class="btn btn-primary">Tìm</button>
                </form>

                <div class="d-flex" style="gap:10px;">
                    <select class="form-select w-auto" onchange="filterByStatus(this)">
                        <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                        <option value="LOCKED" ${selectedStatus == 'LOCKED' ? 'selected' : ''}>Đã khóa</option>
                    </select>

                    <!-- NÚT THÊM NGƯỜI DÙNG -->
                    <a href="user?action=addForm" class="btn btn-primary" style="white-space:nowrap;">
                        ➕ Thêm người dùng
                    </a>
                </div>
            </div>

            <!-- Bảng người dùng -->
            <table class="table align-middle table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>${u.userId}</td>
                            <td>${u.username}</td>
                            <td>${u.fullName}</td>
                            <td>${u.email}</td>
                            <td>${u.phone}</td>
                            <td><span class="status-badge status-${u.status}">${u.status}</span></td>
                            <td class="text-center">
                                <!-- Nút xem chi tiết -->
                                <a href="javascript:void(0)" onclick="showDetail(${u.userId})" class="action-btn btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <!-- Nút cập nhật -->
                                <a href="user?action=editForm&id=${u.userId}" class="action-btn btn-primary" title="Cập nhật thông tin">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </a>

                                <!-- Nút khóa / mở khóa -->
                                <c:choose>
                                    <c:when test="${u.status == 'ACTIVE'}">
                                        <a href="user?action=ban&id=${u.userId}" class="action-btn btn-ban" title="Khóa tài khoản"
                                           onclick="return confirm('Khóa tài khoản này?');">
                                           <i class="fa-solid fa-lock"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="user?action=activate&id=${u.userId}" class="action-btn btn-active" title="Mở khóa tài khoản"
                                           onclick="return confirm('Mở khóa tài khoản này?');">
                                           <i class="fa-solid fa-unlock"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Phân trang -->
            <nav class="d-flex justify-content-center mt-3">
                <ul class="pagination">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="user?action=list&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </div>
    </main>

    <%@ include file="footer.jsp" %>

    <!-- MODAL XEM CHI TIẾT -->
    <div class="modal-overlay" id="userDetailModal">
        <div class="modal-card">
            <h2>Chi tiết người dùng</h2>
            <table>
                <tr><th>ID</th><td id="d-id"></td></tr>
                <tr><th>Tên đăng nhập</th><td id="d-username"></td></tr>
                <tr><th>Họ và tên</th><td id="d-fullname"></td></tr>
                <tr><th>Email</th><td id="d-email"></td></tr>
                <tr><th>Số điện thoại</th><td id="d-phone"></td></tr>
                <tr><th>Trạng thái</th><td id="d-status"></td></tr>
            </table>
            <button class="btn-close" onclick="closeModal()">Đóng</button>
        </div>
    </div>

    <script>
        function filterByStatus(select) {
            const status = select.value;
            window.location.href = 'user?action=filter&status=' + status;
        }

        async function showDetail(id) {
            const res = await fetch('user?action=detail&id=' + id);
            if (!res.ok) {
                alert('Không tìm thấy người dùng');
                return;
            }
            const u = await res.json();
            document.getElementById('d-id').innerText = u.userId;
            document.getElementById('d-username').innerText = u.username;
            document.getElementById('d-fullname').innerText = u.fullName;
            document.getElementById('d-email').innerText = u.email;
            document.getElementById('d-phone').innerText = u.phone;
            document.getElementById('d-status').innerText = u.status;
            document.getElementById('userDetailModal').classList.add('show');
        }

        function closeModal() {
            document.getElementById('userDetailModal').classList.remove('show');
        }
    </script>
</body>
</html>
