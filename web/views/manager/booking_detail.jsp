<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="model.BookingListItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Detail</title>
    <style>
        :root {
            --primary: #6c63ff;
            --primary-dark: #574fd6;
            --accent: #9f99ff;
            --bg: #f5f4ff;
            --white: #ffffff;
            --text-dark: #2b2b2b;
            --text-muted: #777;
        }

        body {
            font-family: "Segoe UI", sans-serif;
            background-color: var(--bg);
            margin: 0;
            padding: 40px 0;
        }

        .container {
            width: 70%;
            margin: auto;
            background: var(--white);
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(108, 99, 255, 0.15);
            padding: 40px 50px;
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            text-align: center;
            color: var(--primary-dark);
            font-size: 26px;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        td {
            padding: 12px 18px;
            border-bottom: 1px solid #eee;
            vertical-align: top;
        }

        td.label {
            font-weight: 600;
            width: 30%;
            color: var(--primary-dark);
        }

        td.value {
            color: var(--text-dark);
        }

        .highlight {
            color: var(--primary);
            font-weight: 600;
        }

        .status {
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            display: inline-block;
            text-transform: uppercase;
        }

        .status-PENDING { background-color: #fff3cd; color: #856404; }
        .status-COMPLETED { background-color: #d4edda; color: #155724; }
        .status-CANCELLED { background-color: #f8d7da; color: #721c24; }

        .back-btn {
            text-align: center;
            margin-top: 30px;
        }

        .back-btn a {
            display: inline-block;
            text-decoration: none;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            font-weight: 500;
            padding: 10px 20px;
            border-radius: 8px;
            transition: 0.3s;
            box-shadow: 0 3px 10px rgba(108,99,255,0.25);
        }

        .back-btn a:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .empty {
            text-align: center;
            color: var(--text-muted);
            padding: 40px;
        }
    </style>
</head>
<body>

<div class="container">
<%
    BookingListItem b = (BookingListItem) request.getAttribute("booking");
    if (b == null) {
%>
    <h2>⚠️ Booking not found</h2>
    <p class="empty">The booking ID you requested does not exist or was removed.</p>
<%
    } else {
%>
    <h2>Booking Detail #<%=b.getBookingId()%></h2>

    <table>
        <tr><td class="label">Customer Name:</td><td class="value"><%=b.getCustomerName()%></td></tr>
        <tr><td class="label">Service / Tour:</td><td class="value"><%=b.getServices() == null ? "N/A" : b.getServices()%></td></tr>
        <tr><td class="label">Booking Date:</td><td class="value"><%=b.getBookingDate() == null ? "N/A" : b.getBookingDate()%></td></tr>
        <tr><td class="label">Price:</td><td class="value"><%=b.getPrice() == null ? "0" : String.format("%,d ₫", b.getPrice())%></td></tr>
        <tr><td class="label">Total Amount:</td><td class="value highlight"><%=b.getTotalAmount() == null ? "0" : String.format("%,.0f ₫", b.getTotalAmount())%></td></tr>
        <tr><td class="label">Status:</td>
            <td class="value">
                <%
                    if (b.getStatus() != null) {
                        String s = b.getStatus().name();
                        out.print("<span class='status status-" + s + "'>" + s + "</span>");
                    } else {
                        out.print("N/A");
                    }
                %>
            </td>
        </tr>
    </table>

    <div class="back-btn">
        <a href="<%=request.getContextPath()%>/manager/booking?action=list">← Back to List</a>
    </div>
<%
    }
%>
</div>

</body>
</html>
