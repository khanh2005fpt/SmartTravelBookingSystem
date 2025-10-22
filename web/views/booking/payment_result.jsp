<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        </style>
    </head>
    <body>
        <div class="result-container">
            <c:choose>
                <c:when test="${result eq 'Success'}">
                    <div class="success-icon">
                        ✅
                    </div>
                    <h2>Thanh toán thành công!</h2>
                    <p class="text-success">Cảm ơn bạn đã đặt tour du lịch cùng chúng tôi.</p>
                </c:when>
                <c:otherwise>
                    <div class="fail-icon">
                        ❌
                    </div>
                    <h2>Thanh toán thất bại!</h2>
                    <p class="text-danger">Giao dịch của bạn không hợp lệ hoặc đã bị hủy.</p>
                </c:otherwise>
            </c:choose>

            <hr>

            <h5>Thông tin thanh toán</h5>
            <table class="table table-bordered mt-3 text-start">
                <tr>
                    <th>Mã đặt tour (Booking ID)</th>
                    <td>${payment.bookingId}</td>
                </tr>
                <tr>
                    <th>Số tiền</th>
                    <td><fmt:formatNumber value="${payment.amount}" type="number" groupingUsed="true"/> VNĐ
                    </td>
                </tr>
                <tr>
                    <th>Trạng thái</th>
                    <td>
                        <c:choose>
                            <c:when test="${payment.status eq 'Success'}">
                                <span class="badge bg-success">Thành công</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">Thất bại</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>

            <a href="${pageContext.request.contextPath}/SearchIslandController" class="btn btn-primary btn-back">
                Quay lại trang chủ
            </a>
        </div>
    </body>
</html>
