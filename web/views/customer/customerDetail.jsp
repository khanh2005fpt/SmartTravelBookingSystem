<html>
    <head>
        <title>Customer Detail</title>
        <style>
            table {
                border-collapse: collapse;
                margin: 20px auto;
                width: 60%;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
                width: 30%;
            }
            h2 {
                text-align: center;
            }
        </style>
    </head>
    <body>
           <%@ include file="/views/staff/sidebar.jsp" %>
        <h2>Thông tin khách hàng</h2>
        <table>
            <tr><th>ID</th><td>${customer.userId}</td></tr>
            <tr><th>Username</th><td>${customer.username}</td></tr>
            <tr><th>Full Name</th><td>${customer.fullName}</td></tr>
            <tr><th>Email</th><td>${customer.email}</td></tr>
            <tr><th>Phone</th><td>${customer.phone}</td></tr>
            <tr><th>Role</th><td>${customer.role}</td></tr>
            <tr><th>Status</th><td>${customer.status}</td></tr>
            <tr><th>Created At</th><td>${customer.createdAt}</td></tr>
        </table>

        <div style="text-align:center; margin-top:20px;">
            <a href="customer?action=list">Back to List</a>
        </div>
    </body>
</html>
