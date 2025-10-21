<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"> 

    <style>
        /* ==================================== */
        /* BASE & LAYOUT */
        /* ==================================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Inter", "Segoe UI", sans-serif;
        }

        :root {
            --primary-color: #007bff;
            --primary-dark: #0056b3;
            --bg-light: #f6f8fb;
            --text-dark: #333;
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            --border-color: #e5e5e5;
        }

        body {
            background: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* Giả định có sidebar bên trái 230px, main nội dung */
        main {
            margin-left: 230px; 
            padding: 30px;
        }
        
        /* Tiện ích */
        .d-flex { display: flex; align-items: center; }
        .justify-content-between { justify-content: space-between; }
        .mb-4 { margin-bottom: 24px; }
        .text-center { text-align: center; }
        .w-auto { width: auto !important; }

        /* CARD NỘI DUNG */
        .content-card {
            background: #fff;
            border-radius: 16px; /* Bo góc mềm mại hơn */
            box-shadow: var(--card-shadow); 
            padding: 30px; /* Tăng padding */
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 25px;
            color: #2c3e50;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 15px;
        }

        .page-title i {
            color: var(--primary-color);
            margin-right: 10px;
        }

        /* ==================================== */
        /* FORM & BUTTONS */
        /* ==================================== */

        /* Input/Select */
        .form-control, .form-select {
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 8px; /* Bo góc mềm mại */
            transition: all 0.3s ease;
            font-size: 15px;
            background-color: #fff;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
            outline: none;
        }

        /* Khối Tìm kiếm */
        form.input-group {
            display: flex;
            gap: 10px;
            width: 450px; /* Cố định chiều rộng */
        }
        
        /* Button chung */
        .btn, .btn-add, .action-btn {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-primary, .btn-add {
            background-color: var(--primary-color);
            color: #fff;
        }

        .btn-primary:hover, .btn-add:hover {
            background-color: var(--primary-dark);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.2);
        }

        /* ==================================== */
        /* BẢNG DỮ LIỆU */
        /* ==================================== */
        table {
            width: 100%;
            border-collapse: separate; /* Dùng separate để tạo khoảng cách cho border-radius */
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 12px;
            overflow: hidden; /* Cần để bo góc cho bảng */
        }

        thead {
            background: #eef2f7; /* Màu nền nhẹ nhàng */
        }

        th, td {
            padding: 15px 15px; /* Tăng padding */
            text-align: left;
        }

        th {
            font-weight: 600;
            color: #555;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            background: #fff;
            border-bottom: 1px solid var(--border-color);
        }

        tbody tr:hover {
            background: #f0f5ff; /* Hiệu ứng hover nổi bật */
        }

        /* Loại bỏ border dưới cuối cùng */
        tbody tr:last-child {
            border-bottom: none;
        }

        /* TRẠNG THÁI */
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px; /* Hình con nhộng */
            font-weight: 600;
            font-size: 13px;
            display: inline-block;
        }

        .status-ACTIVE {
            background: #e6ffed;
            color: #28a745;
        }

        .status-LOCKED {
            background: #fde6e6;
            color: #dc3545;
        }
        
        /* NÚT HÀNH ĐỘNG TRONG BẢNG */
        .action-btn {
            width: 34px;
            height: 34px;
            padding: 0;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%; /* Hình tròn */
            margin: 0 3px;
            font-size: 14px;
        }

        .btn-view { background: #17a2b8; }
        .btn-view:hover { background: #138496; }

        .btn-edit { background: #ffc107; }
        .btn-edit:hover { background: #e0a800; }
        .btn-edit i { color: #fff; } /* Icon chỉnh sửa thường có màu tối, đổi thành trắng */

        .btn-ban { background: #dc3545; } /* Đổi màu ban sang đỏ cảnh báo */
        .btn-ban:hover { background: #c82333; }

        .btn-active { background: #28a745; }
        .btn-active:hover { background: #1e7e34; }

        /* ==================================== */
        /* PHÂN TRANG */
        /* ==================================== */
        .pagination {
            display: flex;
            gap: 4px;
            list-style: none;
            margin-top: 30px;
            justify-content: center;
        }

        .page-item a {
            display: block;
            padding: 8px 14px;
            text-decoration: none;
            border-radius: 6px;
            border: 1px solid #ddd;
            color: var(--primary-color);
            font-weight: 500;
        }

        .page-item a:hover {
            background: #f0f5ff;
            border-color: var(--primary-color);
        }

        .page-item.active a {
            background: var(--primary-color);
            color: #fff;
            border-color: var(--primary-color);
        }

        /* ==================================== */
        /* MODAL CHI TIẾT */
        /* ==================================== */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); /* Nền tối hơn */
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 10000;
        }
        .modal-overlay.show { display: flex; }

        .modal-card {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            width: 450px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            animation: fadeIn 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94); /* Animation mượt hơn */
        }

        .modal-card h2 {
            margin-bottom: 20px;
            color: var(--primary-color);
            font-size: 22px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .modal-card table {
            margin-top: 0;
            width: 100%;
            border-collapse: collapse;
            border-radius: 0;
            overflow: hidden;
        }
        
        .modal-card table tr:hover {
             background: transparent;
        }

        .modal-card th, .modal-card td {
            padding: 8px 0;
            border-bottom: 1px dashed #f0f0f0; /* Thay border solid bằng dashed nhẹ nhàng */
        }

        .modal-card th {
            text-align: left;
            color: #777;
            width: 40%;
            font-weight: 500;
            background: transparent;
        }

        .modal-card td {
            font-weight: 600;
            color: #222;
        }

        .btn-close {
            margin-top: 25px;
            background: #6c757d; /* Màu xám cho nút đóng */
            color: #fff;
            padding: 10px 20px;
            display: block;
            margin-left: auto;
        }
        .btn-close:hover { background: #5a6268; }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-30px);}
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

        <div class="d-flex justify-content-between mb-4">
            <form class="input-group" method="get" action="user">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="form-control" placeholder="🔍 Tìm kiếm tên hoặc email..." value="${keyword}">
                <button class="btn btn-primary" type="submit">Tìm kiếm</button>
            </form>

            <div class="d-flex" style="gap:15px;">
                <select class="form-select w-auto" onchange="filterByStatus(this)">
                    <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                    <option value="LOCKED" ${selectedStatus == 'LOCKED' ? 'selected' : ''}>Đã khóa</option>
                </select>

                <a href="user?action=add" class="btn-add">
                    <i class="fa-solid fa-user-plus"></i> Thêm người dùng
                </a>
            </div>
        </div>
        
        <c:if test="${not empty message}">
             <div class="alert alert-${type}" style="padding:15px; margin-bottom: 20px; border-radius: 8px; background: #d4edda; color: #155724;">
                 ${message}
             </div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên đăng nhập</th>
                    <th>Họ và tên</th>
                    <th>Email</th>
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
                    <td><span class="status-badge status-${u.status}">${u.status == 'ACTIVE' ? 'Hoạt động' : 'Đã khóa'}</span></td>
                    <td class="text-center">
                        <a href="javascript:void(0)" onclick="showDetail(${u.userId})" class="action-btn btn-view" title="Xem chi tiết">
                            <i class="fa-solid fa-eye"></i>
                        </a>

                        <a href="user?action=edit&id=${u.userId}" class="action-btn btn-edit" title="Chỉnh sửa">
                            <i class="fa-solid fa-pen"></i>
                        </a>

                        <c:choose>
                            <c:when test="${u.status == 'ACTIVE'}">
                                <a href="user?action=ban&id=${u.userId}" class="action-btn btn-ban" title="Khóa tài khoản" onclick="return confirm('Bạn có chắc chắn muốn KHÓA tài khoản ${u.username}?');">
                                    <i class="fa-solid fa-lock"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="user?action=activate&id=${u.userId}" class="action-btn btn-active" title="Mở khóa tài khoản" onclick="return confirm('Bạn có chắc chắn muốn MỞ KHÓA tài khoản ${u.username}?');">
                                    <i class="fa-solid fa-unlock"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty users}">
                 <tr>
                    <td colspan="6" class="text-center" style="padding: 20px; color: #777;">Không tìm thấy người dùng nào.</td>
                </tr>
            </c:if>
            </tbody>
        </table>

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

    <div class="modal-overlay" id="userDetailModal">
        <div class="modal-card">
            <h2><i class="fa-solid fa-circle-info"></i> Chi tiết người dùng</h2>
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
        // Bộ lọc trạng thái
        function filterByStatus(select) {
            const status = select.value;
            // Giả sử chuyển hướng về trang 1 khi lọc
            window.location.href = 'user?action=filter&status=' + status + '&page=1'; 
        }

        // Hiển thị chi tiết qua AJAX
        async function showDetail(id) {
            // Hiển thị loading/block UI nếu cần
            document.getElementById('d-id').innerText = 'Đang tải...';
            document.getElementById('userDetailModal').classList.add('show');
            
            try {
                const res = await fetch('user?action=detail&id=' + id);
                if (!res.ok) {
                    throw new Error('Không tìm thấy người dùng');
                }
                const u = await res.json();
                
                // Cập nhật dữ liệu vào Modal
                document.getElementById('d-id').innerText = u.userId || 'N/A';
                document.getElementById('d-username').innerText = u.username || 'N/A';
                document.getElementById('d-fullname').innerText = u.fullName || 'N/A';
                document.getElementById('d-email').innerText = u.email || 'N/A';
                document.getElementById('d-phone').innerText = u.phone || 'N/A';
                
                const statusText = u.status === 'ACTIVE' ? 'Hoạt động' : (u.status === 'LOCKED' ? 'Đã khóa' : 'N/A');
                document.getElementById('d-status').innerText = statusText;
                
            } catch (error) {
                console.error(error);
                alert('Lỗi: Không thể tải chi tiết người dùng.');
                closeModal();
            }
        }

        function closeModal() {
            document.getElementById('userDetailModal').classList.remove('show');
        }
    </script>
</body>
</html>