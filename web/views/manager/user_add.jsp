<%@page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add User</title>
    <style>
        body {
            font-family: "Segoe UI";
            background: #f5f4ff;
            padding: 40px;
        }
        .form-container {
            width: 50%;
            margin: auto;
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(108,99,255,0.2);
        }
        h2 {
            text-align: center;
            color: #6c63ff;
        }
        label {
            font-weight: 500;
            color: #333;
        }
        input, select {
            width: 100%;
            padding: 8px 10px;
            margin: 8px 0 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background: linear-gradient(135deg, #6c63ff, #9f99ff);
            border: none;
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
        }
        button:hover { background: #5848d6; }
        .back { text-decoration:none; color:#6c63ff; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>➕ Add New User</h2>
    <form action="user" method="post">
        <input type="hidden" name="action" value="add">
        <label>Username:</label>
        <input type="text" name="username" required>
        <label>Password:</label>
        <input type="password" name="password" required>
        <label>Full Name:</label>
        <input type="text" name="fullName" required>
        <label>Email:</label>
        <input type="email" name="email" required>
        <label>Phone:</label>
        <input type="text" name="phone">
        <label>Role:</label>
        <select name="roleId">
            <option value="1">Admin</option>
            <option value="2">Booking Manager</option>
            <option value="3">Customer</option>
            <option value="4">Staff</option>
        </select>
        <label>Status:</label>
        <select name="status">
            <option value="ACTIVE">ACTIVE</option>
            <option value="INACTIVE">INACTIVE</option>
        </select>
        <button type="submit">Save</button>
        <a href="user" class="back">← Back</a>
    </form>
</div>
</body>
</html>
