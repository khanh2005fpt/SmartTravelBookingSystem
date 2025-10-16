<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm người dùng</title>
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
            max-width: 550px; /* Tăng kích thước tối đa lên 550px */
            margin: 60px auto;
            background: #fff;
            border-radius: 16px; /* Bo góc mềm mại hơn */
            box-shadow: var(--card-shadow); 
            padding: 40px; /* Tăng padding */
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

        input[type="checkbox"] + label {
            display: inline-block;
            margin-left: 8px;
            font-weight: 400;
        }

        input, select {
            width: 100%;
            padding: 12px 15px; /* Tăng padding */
            border: 1px solid var(--border-color);
            border-radius: 8px; /* Bo góc mềm mại */
            transition: all 0.3s ease;
            font-size: 15px;
            background-color: #fff;
        }

        input:focus, select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.15); /* Thêm bóng đổ focus nhẹ */
            outline: none;
        }

        /* NÚT SUBMIT */
        button {
            margin-top: 25px;
            width: 100%;
            padding: 14px; /* Tăng padding */
            border: none;
            border-radius: 8px;
            background: var(--primary-color);
            color: #fff;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        button:hover {
            background: var(--primary-dark);
            box-shadow: 0 6px 12px rgba(0, 123, 255, 0.4);
        }
        
        /* LINK QUAY LẠI */
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #6c757d; /* Màu xám trung tính */
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
            background: #f8d7da; /* Nền đỏ nhạt */
            color: #721c24; /* Chữ đỏ đậm */
            border: 1px solid #f5c6cb;
        }
        
        .required-star {
            color: #dc3545; /* Màu đỏ cho dấu sao bắt buộc */
            margin-left: 4px;
        }
        
    </style>
</head>
<body>
<div class="container">
    <h2><i class="fa-solid fa-user-plus"></i> Thêm người dùng mới</h2>

    <c:if test="${not empty error}">
        <div class="alert">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/user?action=add" method="post">
        
        <div class="form-group">
            <label>Tên đăng nhập <span class="required-star">*</span></label>
            <input type="text" name="username" value="${param.username}" placeholder="Nhập tên đăng nhập" required>
        </div>

        <div class="form-group">
            <label>Mật khẩu <span class="required-star">*</span></label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>
        </div>

        <div class="form-group">
            <label>Email <span class="required-star">*</span></label>
            <input type="email" name="email" value="${param.email}" placeholder="Ví dụ: ten@example.com" required>
        </div>
        
        <div class="form-group">
            <label>Họ và tên</label>
            <input type="text" name="fullName" value="${param.fullName}" placeholder="Nhập họ và tên đầy đủ">
        </div>

        <div class="form-group">
            <label>Số điện thoại</label>
            <input type="text" name="phone" value="${param.phone}" placeholder="Nhập số điện thoại">
        </div>
        
        <div style="display: flex; gap: 20px;">
             <div class="form-group" style="flex: 1;">
                <label>Vai trò</label>
                <select name="roleId" required>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.roleId}" ${param.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="flex: 1;">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                    <option value="LOCKED" ${param.status == 'LOCKED' ? 'selected' : ''}>Bị khóa</option>
                </select>
            </div>
        </div>

        <button type="submit">
            <i class="fa-solid fa-save"></i> Lưu & Thêm người dùng
        </button>

        <a href="${pageContext.request.contextPath}/admin/user?action=list" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
        </a>
    </form>
</div>
</body>
</html>