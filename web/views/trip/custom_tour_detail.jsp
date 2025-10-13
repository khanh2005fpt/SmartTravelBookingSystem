<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết tour riêng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <h2 class="fw-bold text-center text-primary mb-4">🌴 Tour riêng vừa tạo thành công!</h2>

    <div class="card shadow-lg p-4 mb-4">
        <h4 class="fw-bold mb-3">${tour.tourName}</h4>
        <p><strong>Ngày đi:</strong> ${tour.startDate}</p>
        <p><strong>Ngày về:</strong> ${tour.endDate}</p>
        <p><strong>Tổng giá:</strong>
            <fmt:setLocale value="vi_VN"/>
            <fmt:formatNumber value="${tour.totalPrice}" type="number"/> VND
        </p>
    </div>

    <h5 class="text-primary fw-bold mb-3">🧾 Dịch vụ đã chọn</h5>
    <table class="table table-bordered bg-white">
        <thead class="table-primary">
            <tr>
                <th>Loại dịch vụ</th>
                <th>ID</th>
                <th>Giá</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="d" items="${details}">
                <tr>
                    <td>${d.serviceType}</td>
                    <td>${d.serviceId}</td>
                    <td><fmt:formatNumber value="${d.price}" type="number"/> VND</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h5 class="text-primary fw-bold mt-4 mb-3">🗓️ Lịch trình mẫu</h5>
    <ul class="list-group">
        <c:forEach var="i" items="${itinerary}">
            <li class="list-group-item">
                <strong>Ngày ${i.dayNumber}:</strong> ${i.activity} tại ${i.location} 
                (${i.startTime} - ${i.endTime})
            </li>
        </c:forEach>
    </ul>

    <div class="text-center mt-4">
        <a href="home" class="btn btn-outline-primary rounded-pill px-4">Về trang chủ</a>
    </div>
</div>

</body>
</html>
