<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.*, model.BookingListItem, model.BookingStatus" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Management</title>
    <style>
        :root {
            --primary: #6c63ff;
            --primary-dark: #594ff0;
            --accent: #9f99ff;
            --bg: #f5f4ff;
            --text-dark: #2b2b2b;
            --text-light: #6b6b6b;
            --white: #ffffff;
        }

        body {
            font-family: "Segoe UI", sans-serif;
            background-color: var(--bg);
            margin: 0;
            padding: 20px;
        }
        .container {
            margin-left: 270px;
            padding: 30px;
            max-width: 100%;
            margin-right: auto;
            margin-top: 80px;
            background-color: #ffffffb3;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }


        h2 {
            color: var(--primary-dark);
            text-align: center;
            font-size: 28px;
            margin-bottom: 30px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* ---------- SEARCH BAR ---------- */
        .search-bar {
            background-color: var(--white);
            padding: 15px 20px;
            border-radius: 10px;
            width: 90%;
            margin: 0 auto 25px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(108, 99, 255, 0.1);
        }

        input[type="text"], select {
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            margin-right: 10px;
            outline: none;
            transition: 0.3s;
        }

        input[type="text"]:focus, select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 5px rgba(108, 99, 255, 0.3);
        }

        button {
            background-color: var(--primary);
            border: none;
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
            font-weight: 500;
        }

        button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-1px);
        }

        /* ---------- TABLE ---------- */
        table {
            width: 90%;
            margin: 0 auto;
            border-collapse: collapse;
            background: var(--white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(108, 99, 255, 0.1);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
            color: var(--text-dark);
        }
         .page-header {
                background: linear-gradient(180deg, #0077b6, #00b4d8);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .page-header h1 {
                margin: 0;
                font-weight: 600;
            }

            .page-header p {
                margin: 10px 0 0 0;
                opacity: 0.9;
            }

        th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tr:hover {
            background-color: rgba(108, 99, 255, 0.07);
        }

        td a {
            text-decoration: none;
            color: var(--primary);
            font-weight: 600;
        }

        td a:hover {
            text-decoration: underline;
        }

        /* ---------- STATUS COLORS ---------- */
        .status-PENDING { color: #e67e22; font-weight: bold; }
        .status-APPROVED { color: #6c63ff; font-weight: bold; }
        .status-COMPLETED { color: #27ae60; font-weight: bold; }
        .status-CANCELLED { color: #e74c3c; font-weight: bold; }
        .status-REJECTED { color: #8e44ad; font-weight: bold; }

        /* ---------- PAGINATION ---------- */
        .pagination {
            text-align: center;
            margin-top: 30px;
        }

        .pagination a {
            color:#00ACD4;
            padding: 8px 12px;
            border: 1px solid #007CB9;
            margin: 0 4px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
        }
        .btn-action{
           background: linear-gradient(180deg, #0077b6, #00b4d8);
       color: white;

        }

        .pagination a.active {
            background-color:  #00ACD4;
            color: white;
            border-color: #007CB9;
        }

        .pagination a:hover {
            background-color: #007CB9;
            color: white;
        }

        /* ---------- RESPONSIVE ---------- */
        @media (max-width: 768px) {
            table, .search-bar {
                width: 100%;
            }
            th, td {
                font-size: 13px;
                padding: 8px;
            }
            input, select, button {
                margin-bottom: 8px;
            }
        }
        .booking-table th{
           background: #00ACD4;
    color: white; 
        }
        .view_detailed{
         color: #ff7b00;

        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <%@ include file="/views/staff/sidebar.jsp" %>
    
    <div class="container">

                <div class="page-header ">
                <h1>  <i class="bi bi-calendar-check"></i> Booking Management</h1>
                <p class="flights-title text-white">
                    Danh sách booking : <span class="flights-count text-white small">
                      
                    </span>
                </p>
            </div>



<!-- ===================== SEARCH / FILTER BAR ===================== -->
<div class="search-bar">

    <!-- Search by customer -->
    <form action="<%=request.getContextPath()%>/manager/booking" method="get" style="display:inline-block;">
        <input type="hidden" name="action" value="searchName">
        <input type="text" name="keyword" placeholder="Search by customer name..."
               value="<%=request.getAttribute("searchType") != null && request.getAttribute("searchType").equals("name") ? request.getAttribute("searchValue") : ""%>">
        <button type="submit" class="btn-action">🔍 Search</button>
    </form>

    <!-- Filter by status -->
    <form action="<%=request.getContextPath()%>/manager/booking" method="get" style="display:inline-block;">
        <input type="hidden" name="action" value="searchStatus">
        <select name="status">
            <option value="">-- Filter by Status --</option>
            <option value="PENDING">Pending</option>
            <option value="APPROVED">Approved</option>
            <option value="COMPLETED">Completed</option>
            <option value="CANCELLED">Cancelled</option>
            <option value="REJECTED">Rejected</option>
        </select>
        <button type="submit"  class="btn-action">Filter</button>
    </form>

    <!-- Filter by Tour / Sort -->
    <form action="<%=request.getContextPath()%>/manager/booking" method="get" style="display:inline-block;">
        <input type="hidden" name="action" value="filterTour">

        <select name="tour">
            <option value="">-- Select Tour / Service --</option>
            <%
                List<String> tours = (List<String>) request.getAttribute("tours");
                if (tours != null) {
                    String selectedTour = (String) request.getAttribute("selectedTour");
                    for (String t : tours) {
                        boolean selected = selectedTour != null && selectedTour.equals(t);
            %>
                        <option value="<%=t%>" <%= selected ? "selected" : "" %>><%=t%></option>
            <%
                    }
                }
            %>
        </select>

        <select name="sort">
            <option value="">-- Sort by Price --</option>
            <option value="ASC" <%= "ASC".equals(request.getAttribute("sortOrder")) ? "selected" : "" %>>Low → High</option>
            <option value="DESC" <%= "DESC".equals(request.getAttribute("sortOrder")) ? "selected" : "" %>>High → Low</option>
        </select>

        <button type="submit"  class="btn-action">Apply</button>
    </form>

    <!-- Reset -->
    <form action="<%=request.getContextPath()%>/manager/booking" method="get" style="display:inline-block;">
        <input type="hidden" name="action" value="list">
        <button type="submit"  class="btn-action">🔄 Reset</button>
    </form>
</div>

<!-- ===================== BOOKING TABLE ===================== -->
<table >
    <tr class="booking-table">
        <th>#</th>
        <th>Customer</th>
        <th>Tour / Service</th>
        <th>Status</th>
        <th>Price (₫)</th>
        <th>Total Amount (₫)</th>
        <th>Booking Date</th>
        <th>View Detail</th>
    </tr>

<%
    List<BookingListItem> bookings = (List<BookingListItem>) request.getAttribute("listBookings");
    if (bookings != null && !bookings.isEmpty()) {
        int index = 1;
        for (BookingListItem b : bookings) {
%>
    <tr>
        <td><%= index++ %></td>
        <td><%= b.getCustomerName() %></td>
        <td><%= b.getServices() == null ? "N/A" : b.getServices() %></td>
        <td class="status-<%=b.getStatus() == null ? "" : b.getStatus()%>">
            <%= b.getStatus() == null ? "N/A" : b.getStatus() %>
        </td>
        <td><%= b.getPrice() == null ? "0" : String.format("%,d", b.getPrice()) %></td>
        <td><%= b.getTotalAmount() == null ? "0" : String.format("%,.0f", b.getTotalAmount()) %></td>
        <td><%= b.getBookingDate() == null ? "N/A" : b.getBookingDate().toLocalDate() %></td>
        <td>
            <a href="<%=request.getContextPath()%>/manager/booking?action=detail&id=<%=b.getBookingId()%>" class="view_detailed">🔍 View</a>
        </td>
    </tr>
<%
        }
    } else {
%>
    <tr><td colspan="8" style="text-align:center; color:var(--text-light);">No bookings found.</td></tr>
<%
    }
%>
</table>

<!-- ===================== PAGINATION ===================== -->
<div class="pagination">
<%
    Integer pageCurrent = (Integer) request.getAttribute("currentPage");
    if (pageCurrent == null || pageCurrent < 1) pageCurrent = 1;
    int prevPage = Math.max(1, pageCurrent - 1);
    int nextPage = pageCurrent + 1;
%>

    <a href="<%= pageCurrent > 1 
                ? request.getContextPath() + "/manager/booking?page=" + prevPage 
                : "#" %>"
       class="<%= pageCurrent == 1 ? "disabled" : "" %>">« Prev</a>

    <a href="#" class="active"><%= pageCurrent %></a>

    <a href="<%= request.getContextPath() + "/manager/booking?page=" + nextPage %>">Next »</a>
</div>


</body>
</html>
