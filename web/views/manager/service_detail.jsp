<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Detail</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #4a69bd;
            --secondary: #38ada9;
            --light: #f8f9fa;
            --dark: #2f3640;
            --border: #dee2e6;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --radius: 12px;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            color: var(--dark);
            padding: 40px;
            min-height: 100vh;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        h2 {
            text-align: center;
            color: var(--primary);
            font-size: 1.8rem;
            margin-bottom: 30px;
            position: relative;
        }

        h2::after {
            content: '';
            width: 70px;
            height: 3px;
            background: var(--secondary);
            display: block;
            margin: 10px auto 0;
            border-radius: 2px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            padding: 10px 0;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: 600;
            color: #555;
        }

        .value {
            text-align: right;
            font-weight: 500;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--primary);
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            margin-top: 30px;
            transition: all 0.2s ease;
        }

        .btn-back:hover {
            background: #3b518f;
            transform: translateY(-1px);
        }

        .icon-type {
            font-size: 1.3rem;
            margin-right: 8px;
        }

        .section {
            margin-bottom: 25px;
        }
    </style>
</head>
<body>

<div class="container">
    <%
        int id = (int) request.getAttribute("id");
        String type = (String) request.getAttribute("type");
        Map<String, Object> data = (Map<String, Object>) request.getAttribute("data");
    %>

    <h2>
        <i class="fas fa-info-circle"></i> Chi tiết dịch vụ — <%= type %>
    </h2>

    <div class="section">
        <div class="detail-item">
            <span class="label">Service ID:</span>
            <span class="value">#<%= id %></span>
        </div>

        <% if (data != null && !data.isEmpty()) { %>

            <% if ("Hotel".equalsIgnoreCase(type)) { %>
                <div class="detail-item"><span class="label">Hotel Name:</span><span class="value"><%= data.get("name") %></span></div>
                <div class="detail-item"><span class="label">Price per Night:</span><span class="value"><%= data.get("price") %> ₫</span></div>
                <div class="detail-item"><span class="label">Rooms Available:</span><span class="value"><%= data.get("rooms") %></span></div>
                <div class="detail-item"><span class="label">Rating:</span><span class="value"><%= data.get("rating") %> ★</span></div>

            <% } else if ("Flight".equalsIgnoreCase(type)) { %>
                <div class="detail-item"><span class="label">Flight Number:</span><span class="value"><%= data.get("flightNumber") %></span></div>
                <div class="detail-item"><span class="label">Departure:</span><span class="value"><%= data.get("departure") %></span></div>
                <div class="detail-item"><span class="label">Destination:</span><span class="value"><%= data.get("destination") %></span></div>
                <div class="detail-item"><span class="label">Ticket Price:</span><span class="value"><%= data.get("price") %> ₫</span></div>
                <div class="detail-item"><span class="label">Tickets Available:</span><span class="value"><%= data.get("tickets") %></span></div>

            <% } else if ("Vehicle".equalsIgnoreCase(type)) { %>
                <div class="detail-item"><span class="label">Model Name:</span><span class="value"><%= data.get("modelName") %></span></div>
                <div class="detail-item"><span class="label">Price per Day:</span><span class="value"><%= data.get("price") %> ₫</span></div>
                <div class="detail-item"><span class="label">Availability:</span><span class="value"><%= data.get("available") %></span></div>

            <% } else if ("Place".equalsIgnoreCase(type)) { %>
                <div class="detail-item"><span class="label">Place Name:</span><span class="value"><%= data.get("placeName") %></span></div>
                <div class="detail-item"><span class="label">Ticket Price:</span><span class="value"><%= data.get("price") %> ₫</span></div>
                <div class="detail-item"><span class="label">Has Ticket:</span><span class="value"><%= ((Boolean) data.get("hasTicket")) ? "Yes" : "No" %></span></div>
            <% } %>

        <% } else { %>
            <p style="text-align:center; color:#888; margin-top:20px;">No data found for this service.</p>
        <% } %>
    </div>

    <div style="text-align:center;">
        <a href="<%= request.getContextPath() %>/manager/service?action=list" class="btn-back">
            <i class="fas fa-arrow-left"></i> Back to List
        </a>
    </div>
</div>

</body>
</html>
