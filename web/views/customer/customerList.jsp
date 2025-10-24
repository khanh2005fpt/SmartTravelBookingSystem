<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Customer List</title>
    <style>
        table { border-collapse: collapse; margin: 20px auto; width: 80%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        h2 { text-align: center; }
    </style>
</head>
<body>
<h2>Danh sách khách hàng</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    <c:forEach var="c" items="${customers}">
        <tr>
            <td>${c.userId}</td>
            <td>${c.fullName}</td>
            <td>${c.email}</td>
            <td>${c.phone}</td>
            <td>${c.status}</td>
            <td><a href="customer?action=detail&id=${c.userId}">View Detail</a></td>
        </tr>
    </c:forEach>
</table>
</body>
</html>