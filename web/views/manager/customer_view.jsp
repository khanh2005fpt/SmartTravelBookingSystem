<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View User</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f8f7fc;
            margin: 0;
            padding: 30px;
        }

        .container {
            width: 60%;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #5a2fc2;
            margin-bottom: 25px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            font-weight: bold;
            color: #333;
        }

        input[type="text"], input[type="email"], select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background-color: #f9f9f9;
            color: #333;
        }

        input[readonly], select[disabled] {
            background-color: #f3f3f3;
            color: #666;
            cursor: not-allowed;
        }

        .back-btn {
            display: inline-block;
            text-decoration: none;
            text-align: center;
            background-color: #5a2fc2;
            color: white;
            padding: 10px;
            border-radius: 6px;
            font-size: 15px;
            width: 150px;
            margin: 20px auto 0;
        }

        .back-btn:hover {
            background-color: #7a4ef3;
        }
    </style>
</head>
<body>

<%
    User u = (User) request.getAttribute("user");
    List<String[]> roles = (List<String[]>) request.getAttribute("roles");
    List<String> statuses = (List<String>) request.getAttribute("statuses");
%>

<div class="container">
    <h2>👤 Customer Details</h2>

    <form>
        <label>Username:</label>
        <input type="text" value="<%=u != null ? u.getUsername() : ""%>" readonly>

        <label>Full Name:</label>
        <input type="text" value="<%=u != null ? u.getFullName() : ""%>" readonly>

        <label>Email:</label>
        <input type="email" value="<%=u != null ? u.getEmail() : ""%>" readonly>

        <label>Phone:</label>
        <input type="text" value="<%=u != null ? u.getPhone() : ""%>" readonly>

        <label>Role:</label>
        <input type="text" value="<%=u != null ? u.getRole() : ""%>" readonly>
        
        <label>Status:</label>
        <input type="text" value="<%=u != null ? u.getStatus() : ""%>" readonly>

      <a class="back-btn" href="<%=request.getContextPath()%>/manager/user?action=list">← Back to List</a>
       
               
    </form>
</div>

</body>
</html>
