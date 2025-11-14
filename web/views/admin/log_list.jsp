<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Log Hệ Thống</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f5f6fa;
            margin: 0;
        }

        /* =================== LAYOUT CHÍNH =================== */
        .main-content {
            margin-left: 250px;     
            padding: 24px 32px;    
            min-height: 100vh;
        }

        /* =================== HEADER CHÀO MỪNG =================== */
        .welcome-header {
            background: #fff;
            padding: 20px 28px;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 28px;
            border-left: 5px solid #00ACD4;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .welcome-header .info {
            flex: 1;
        }

        .welcome-header h1 {
            color: #00ACD4;
            margin: 0 0 6px 0;
            font-weight: 700;
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .welcome-header p {
            margin: 4px 0;
            color: #555;
            font-size: 14.5px;
            line-height: 1.5;
        }

        .welcome-header p strong {
            color: #00ACD4;
        }

        .welcome-header i {
            color: #0077b6;
        }

        /* Ngày giờ nhỏ gọn bên phải */
        .welcome-header .date {
            text-align: right;
            color: #666;
            font-size: 14px;
            white-space: nowrap;
        }

        /* =================== TIÊU ĐỀ LOG =================== */
        h1.log-title {
            color: #00ACD4;
            margin: 0 0 20px 0;
            font-weight: 700;
            font-size: 26px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h1.log-title::before {
            content: "Nhật ký log";
            font-size: 30px;
        }

        /* =================== THANH TÌM KIẾM =================== */
        .search-bars {
            display: flex;
            gap: 16px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 24px;
            background: #fff;
            padding: 16px 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .search-group {
            display: flex;
            gap: 8px;
            align-items: center;
            min-width: 280px;
        }

        input[type="text"], select {
            padding: 10px 14px;
            font-size: 15px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            outline: none;
            flex: 1;
            transition: border 0.2s;
        }

        input[type="text"]:focus, select:focus {
            border-color: #00ACD4;
        }

        button {
            background: linear-gradient(180deg, #0077b6, #00b4d8);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            white-space: nowrap;
            transition: 0.2s;
        }

        button:hover {
            background: #00ACD4;
            transform: translateY(-1px);
        }

        /* =================== BẢNG LOG =================== */
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 3px 12px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 14px 16px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        th {
            background: linear-gradient(180deg, #0077b6, #00b4d8);
            color: white;
            font-weight: 600;
            font-size: 15px;
        }

        tr:hover {
            background: #f0faff;
        }

        .method {
            padding: 5px 12px;
            border-radius: 6px;
            color: white;
            font-weight: 600;
            font-size: 13px;
            display: inline-block;
        }

        .GET { background: #27ae60; }
        .POST { background: #00ACD4; }
        .PUT { background: #f39c12; }
        .DELETE { background: #c0392b; }

        .role-badge {
            padding: 5px 10px;
            border-radius: 6px;
            background: #e6f7ff;
            color: #00698c;
            font-weight: 600;
            font-size: 13px;
            display: inline-block;
            border: 1px solid #00ACD4;
        }

        a.detail {
            color: #00ACD4;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }

        a.detail:hover {
            text-decoration: underline;
            color: #0077b6;
        }

        .no-data {
            text-align: center;
            color: #777;
            font-style: italic;
            padding: 32px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            font-size: 15px;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .main-content { margin-left: 0; padding: 20px; }
            .welcome-header { flex-direction: column; text-align: center; }
            .welcome-header .date { text-align: center; }
            .search-bars { flex-direction: column; align-items: stretch; }
            .search-group { min-width: 100%; }
        }
    </style>
</head>
<body>
   <!-- Include Sidebar -->
   <%@ include file="/views/staff/sidebar.jsp" %>

   <div class="main-content">

    
      <div class="welcome-header">
          <div class="info">
              <h1><i class="fa fa-tachometer-alt"></i> Quản lý hệ thống</h1>
              <p>Chào mừng bạn đến với hệ thống quản lý <strong>Meland Travel Booking</strong></p>
          </div>
          <div class="date">
              <p><i class="fa fa-calendar-alt"></i> Hôm nay: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, dd/MM/yyyy"/></p>
          </div>
      </div>

      <!-- Tiêu đề Log -->
      <h1 class="log-title">  </h1>

      <!-- Thanh tìm kiếm - ĐÃ ĐƯỢC GOM NHÓM ĐẸP -->
      <div class="search-bars">
          <div class="search-group">
              <input type="text" name="searchUser" placeholder="Tìm theo tên hoặc email..." value="${keywordUser}" form="form-user">
              <button type="submit" form="form-user">Tìm User</button>
          </div>

          <div class="search-group">
              <select name="searchAction" form="form-action">
                  <option value="ALL">-- Chọn Action --</option>
                  <c:forEach var="a" items="${actions}">
                      <option value="${a}" ${selectedAction == a ? 'selected' : ''}>${a}</option>
                  </c:forEach>
              </select>
              <button type="submit" form="form-action">Lọc Action</button>
          </div>

          <div class="search-group">
              <select name="searchRole" form="form-role">
                  <option value="ALL">-- Chọn Vai Trò --</option>
                  <c:forEach var="r" items="${roles}">
                      <option value="${r.roleName}" ${selectedRole == r.roleName ? 'selected' : ''}>${r.roleName}</option>
                  </c:forEach>
              </select>
              <button type="submit" form="form-role">Lọc Role</button>
          </div>
      </div>

      <!-- Form ẩn để submit -->
      <form id="form-user" action="logs" method="get"></form>
      <form id="form-action" action="logs" method="get"></form>
      <form id="form-role" action="logs" method="get"></form>

      <!-- Bảng logs -->
      <c:choose>
          <c:when test="${not empty logs}">
              <table>
                  <tr>
                      <th>Người dùng</th>
                      <th>Vai trò</th>
                      <th>Action</th>
                      <th>Method</th>
                      <th>Timestamp</th>
                      <th>Chi tiết</th>
                  </tr>
                  <c:forEach var="log" items="${logs}">
                      <tr>
                          <td>${log.username}</td>
                          <td><span class="role-badge">${log.roleName}</span></td>
                          <td>${log.action}</td>
                          <td><span class="method ${log.method}">${log.method}</span></td>
                          <td>${log.timestamp}</td>
                          <td><a class="detail" href="logs?id=${log.logId}">Xem</a></td>
                      </tr>
                  </c:forEach>
              </table>
          </c:when>
          <c:otherwise>
              <div class="no-data">Không có dữ liệu phù hợp</div>
          </c:otherwise>
      </c:choose>
   </div>
</body>
</html>