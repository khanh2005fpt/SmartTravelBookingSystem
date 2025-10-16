<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa người dùng</title>
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
            --success-color: #28a745; /* Màu xanh lá cho nút Cập nhật */
            --success-dark: #1e7e34;
            --bg-light: #f6f8fb;
            --text-dark: #333;
            --card-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            --border-color: #ddd;
        }

        body {
            background: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
        }
        
        /* CARD CONTAINER */
        .container {
            width: 100%;
            max-width: 550px; 
            margin: 60px auto;
            background: #fff;
            border-radius: 16px; 
            box-shadow: var(--card-shadow); 
            padding: 40px; 
        }
        
        /* TIÊU ĐỀ */
        h2 {
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 30px;
            font-size: 24px;
            font-weight: 700;
        }
        
        /* ==================================== */
        /* FORM ELEMENTS */
        /* ==================================== */
        .form-group {
            margin-bottom: 18px;
        }
        
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #555;
            font-size: 15px;
        }

        input, select {
            width: 100%;
            padding: 12px 15px; 
            border: 1px solid var(--border-color);
            border-radius: 8px; 
            transition: all 0.3s ease;
            font-size: 15px;
            background-color: #fff;
        }

        input:focus, select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.15); 
            outline: none;
        }
        
        /* Input chỉ đọc (Readonly) */
        input[readonly] {
            background-color: #eee; /* Màu nền xám để phân biệt */
            color: #777;
            cursor: not-allowed;
            font-style: italic;
        }

        /* NÚT SUBMIT/UPDATE */
        button {
            margin-top: 25px;
            width: 100%;
            padding: 14px; 
            border: none;
            border-radius: 8px;
            background: var(--success-color); 
            color: #fff;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3); /* Bóng đổ xanh lá */
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        button:hover {
            background: var(--success-dark);
            box-shadow: 0 6px 12px rgba(40, 167, 69, 0.4);
        }
        
        /* LINK QUAY LẠI */
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #6c757d; 
            text-decoration: none;
            font-weight: 500;
            transition: 0.2s;
        }
        .back-link i {
            margin-right: 5px;
        }
        .back-link:hover {
            color: var(--primary-color);
        }
        
        /* THÔNG BÁO LỖI */
        .alert {
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            background: #f8d7da; 
            color: #721c24; 
            border: 1px solid #f5c6cb;
        }
        
        /* Tùy chỉnh bố cục cho Vai trò & Trạng thái */
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
    </style>
</head>
<body>
<div class="container">
    <h2><i class="fa-solid fa-user-pen"></i> Chỉnh sửa thông tin người dùng</h2>

    <c:if test="${not empty error}">
        <div class="alert">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/user?action=update" method="post">
        <input type="hidden" name="userId" value="${user.userId}">

        <div class="form-group">
            <label>ID Người dùng</label>
            <input type="text" value="#${user.userId}" readonly>
        </div>
        
        <div class="form-group">
            <label>Tên đăng nhập</label>
            <input type="text" value="${user.username}" readonly>
        </div>

        <div class="form-group">
            <label>Họ và tên</label>
            <input type="text" name="fullName" value="${user.fullName}" placeholder="Nhập họ và tên đầy đủ">
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="${user.email}" placeholder="Ví dụ: ten@example.com">
        </div>

        <div class="form-group">
            <label>Số điện thoại</label>
            <input type="text" name="phone" value="${user.phone}" placeholder="Nhập số điện thoại">
        </div>
        
        <div class="form-row">
             <div class="form-group">
                <label>Vai trò</label>
                <select name="roleId" required>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.roleId}" ${r.roleId == user.roleId ? 'selected' : ''}>${r.roleName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                    <option value="LOCKED" ${user.status == 'LOCKED' ? 'selected' : ''}>Bị khóa</option>
                </select>
            </div>
        </div>

        <button type="submit">
            <i class="fa-solid fa-arrow-up-from-bracket"></i> Cập nhật thông tin
        </button>
        
        <a href="${pageContext.request.contextPath}/admin/user?action=list" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
        </a>
    </form>
</div>
</body>
</html>