<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh sách chuyến bay</title>
    <style>
        table {
            border-collapse: collapse;
            width: 80%;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        .pagination {
            text-align: center;
            margin: 20px;
        }
        .pagination a {
            margin: 0 5px;
            padding: 6px 12px;
            border: 1px solid #333;
            text-decoration: none;
        }
        .pagination a.active {
            background: #333;
            color: #fff;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Danh sách chuyến bay</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Số hiệu</th>
        <th>Hãng</th>
        <th>Nơi đi</th>
        <th>Nơi đến</th>
        <th>Thời gian khởi hành</th>
        <th>Thời gian đến</th>
        <th>Giá vé</th>
    </tr>
    <c:forEach var="f" items="${flights}">
        <tr>
            <td>${f.flightId}</td>
            <td>${f.flightNumber}</td>
            <td>${f.airlineId}</td>
            <td>${f.departure}</td>
            <td>${f.destination}</td>
            <td>${f.departureTime}</td>
            <td>${f.arrivalTime}</td>
            <td>${f.price}</td>
        </tr>
    </c:forEach>
</table>

<div class="pagination">
    <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="flights?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>
</div>

</body>
</html>