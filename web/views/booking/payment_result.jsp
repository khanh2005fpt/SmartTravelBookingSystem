<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Payment" %>
<%
    Payment payment = (Payment) request.getAttribute("payment");
    String result = (String) request.getAttribute("result");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header text-white <%=( "success".equals(result) ? "bg-success" : "bg-danger" )%>">
            <h3 class="card-title mb-0">
                <%=( "success".equals(result) ? "✅ Thanh toán thành công" : "❌ Thanh toán thất bại" )%>
            </h3>
        </div>
        <div class="card-body">
            <% if (payment != null) { %>
                <p><strong>Mã Booking:</strong> <%= payment.getBookingId() %></p>
                <p><strong>Số tiền:</strong> <%= String.format("%,.0f", payment.getAmount()) %> VNĐ</p>
                 <p><strong>Trạng thái:</strong> <%= payment.getStatus() %></p>
            <% } else { %>
                <p>Không có thông tin thanh toán.</p>
            <% } %>
            <hr>
            <a href="index.jsp" class="btn btn-primary">Quay về trang chủ</a>
        </div>
    </div>
</div>
</body>
</html>
