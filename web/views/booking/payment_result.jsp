<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Kết quả thanh toán - Smart Booking Travel</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }
            .result-container {
                max-width: 600px;
                margin: 80px auto;
                background: #fff;
                border-radius: 16px;
                padding: 40px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                text-align: center;
            }
            .success-icon {
                color: #28a745;
                font-size: 60px;
            }
            .fail-icon {
                color: #dc3545;
                font-size: 60px;
            }
            .btn-back {
                margin-top: 20px;
                border-radius: 30px;
                padding: 10px 30px;
            }
            h2 {
                margin-top: 20px;
            }
            .info-label {
                font-weight: 600;
                color: #495057;
            }
        </style>
    </head>
            
    <%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }
if (currentUser != null) {
    int roleId = currentUser.getRoleId();

    if (roleId != 1 && roleId != 3) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>
    <body>
        <div class="result-container">

            <!-- KẾT QUẢ THANH TOÁN -->
            <c:choose>
                <c:when test="${bill.status eq 'Success'}">
                    <div class="success-icon">Thành công</div>
                    <h2>Thanh toán thành công!</h2>
                    <p class="text-success">Cảm ơn bạn đã đặt tour du lịch cùng chúng tôi.</p>
                </c:when>
                <c:otherwise>
                    <div class="fail-icon">Thất bại</div>
                    <h2>Thanh toán thất bại!</h2>
                    <p class="text-danger">
                        Giao dịch của bạn không hợp lệ hoặc đã bị hủy.<br>
                        Vui lòng thử lại hoặc liên hệ hỗ trợ.
                    </p>
                </c:otherwise>
            </c:choose>

            <hr>

            <!-- CHỈ HIỂN THỊ HÓA ĐƠN KHI THÀNH CÔNG -->
            <c:if test="${bill.status eq 'Success'}">
                <h5 class="mb-4">Thông tin chi tiết hóa đơn</h5>
                <table class="table table-bordered mt-3 text-start">
                    <tr>
                        <th class="info-label">Mã Bill</th>
                        <td><strong>#${bill.paymentId}</strong></td>
                    </tr>
                    <tr>
                        <th class="info-label">Họ tên khách hàng</th>
                        <td>${bill.fullname}</td>
                    </tr>
                    <tr>
                        <th class="info-label">Số điện thoại</th>
                        <td>${bill.phone}</td>
                    </tr>
                    <tr>
                        <th class="info-label">Tên tour</th>
                        <td><span class="text-primary fw-medium">${bill.tourName}</span></td>
                    </tr>
                    <tr>
                        <th class="info-label">Ngày đặt tour</th>
                        <td><fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                    </tr>
                    <tr>
                        <th class="info-label">Số tiền</th>
                        <td>
                            <strong class="text-danger">
                                <fmt:formatNumber value="${bill.amount}" type="number" groupingUsed="true"/> VNĐ
                            </strong>
                        </td>
                    </tr>
                    <tr>
                        <th class="info-label">Trạng thái</th>
                        <td><span class="badge bg-success px-3 py-2">Thành công</span></td>
                    </tr>
                </table>
            </c:if>

            <!-- NÚT HÀNH ĐỘNG -->
            <div class="d-flex justify-content-center gap-2 flex-wrap">
                <c:if test="${bill.status eq 'Success'}">
                    <a href="${pageContext.request.contextPath}/bill-history.jsp"
                       class="btn btn-outline-secondary btn-back">
                        Xem lịch sử
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/SearchIslandController"
                   class="btn btn-primary btn-back">
                    Quay lại trang chủ
                </a>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
