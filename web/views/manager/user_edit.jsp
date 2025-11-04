<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
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
        }

        button {
            background-color: #5a2fc2;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
        }

        button:hover {
            background-color: #7a4ef3;
        }

        .back-btn {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: #5a2fc2;
        }

        .back-btn:hover {
            text-decoration: underline;
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
    <h2>✏️ Edit User</h2>

    <form action="<%=request.getContextPath()%>/user" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="userId" value="<%=u != null ? u.getUserId() : ""%>">

        <label>Username:</label>
        <input type="text" name="username" value="<%=u != null ? u.getUsername() : ""%>" required>

        <label>Full Name:</label>
        <input type="text" name="fullName" value="<%=u != null ? u.getFullName() : ""%>">

        <label>Email:</label>
        <input type="email" name="email" value="<%=u != null ? u.getEmail() : ""%>" required>

        <label>Phone:</label>
        <input type="text" name="phone" value="<%=u != null ? u.getPhone() : ""%>">

        <label>Role:</label>
        <select name="roleId" required>
            <option value="">-- Select Role --</option>
            <%
                if (roles != null && u != null) {
                    for (String[] r : roles) {
                        String roleId = r[0];
                        String roleName = r[1];
                        boolean selected = (u.getRoleId() + "").equals(roleId);
            %>
                        <option value="<%=roleId%>" <%=selected ? "selected" : ""%>><%=roleName%></option>
            <%
                    }
                }
            %>
        </select>

        <label>Status:</label>
        <select name="status">
            <option value="">-- Select Status --</option>
            <%
                if (statuses != null && !statuses.isEmpty() && u != null) {
                    for (String s : statuses) {
                        boolean selected = s != null && s.equalsIgnoreCase(u.getStatus());
            %>
                        <option value="<%=s%>" <%=selected ? "selected" : ""%>><%=s%></option>
            <%
                    }
                } else {
            %>
                <option value="ACTIVE" <%= u != null && "ACTIVE".equalsIgnoreCase(u.getStatus()) ? "selected" : "" %>>ACTIVE</option>
                <option value="INACTIVE" <%= u != null && "INACTIVE".equalsIgnoreCase(u.getStatus()) ? "selected" : "" %>>INACTIVE</option>
            <%
                }
            %>
        </select>

        <button type="submit">💾 Update</button>
    </form>

    <a class="back-btn" href="<%=request.getContextPath()%>/user?action=list">← Back to List</a>
</div>

</body>
</html>
