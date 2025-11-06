<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.Service" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Service Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            :root {
                --primary: #4a69bd;
                --primary-dark: #3c6382;
                --secondary: #38ada9;
                --secondary-dark: #079992;
                --danger: #e74c3c;
                --success: #27ae60;
                --light: #f8f9fa;
                --dark: #343a40;
                --gray: #6c757d;
                --border: #dee2e6;
                --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                --radius: 12px;
                --transition: all 0.3s ease;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                padding: 20px;
                color: var(--dark);
            }

                 .container {
    margin-left: 270px;
    padding: 30px;
    max-width: 100%; 
    background-color: #ffffffb3;
    border-radius: 20px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

            h2 {
                text-align: center;
                margin: 30px 0 20px;
                font-size: 2.2rem;
                color:  #00ACD4;
                font-weight: 600;
                position: relative;
            }

            h2::after {
                content: '';
                width: 80px;
                height: 4px;
                background: var(--secondary);
                display: block;
                margin: 12px auto 0;
                border-radius: 2px;
            }

            /* SEARCH CARD */
            .search-card {
                background: white;
                margin: 20px auto;
                padding: 24px;
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                max-width: 1000px;
            }

            .search-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 16px;
                align-items: end;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .form-group label {
                font-weight: 600;
                color: var(--gray);
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .form-group input,
            .form-group select {
                padding: 10px 12px;
                border: 1.5px solid var(--border);
                border-radius: 8px;
                font-size: 0.95rem;
                transition: var(--transition);
            }

            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(74, 105, 189, 0.15);
            }

            .price-range {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .price-range input {
                width: 100px;
            }

            .btn-group {
                display: flex;
                gap: 12px;
                margin-top: 12px;
                flex-wrap: wrap;
                justify-content: flex-start;
            }

            .btn {
                padding: 11px 18px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: var(--transition);
                text-decoration: none;
                font-size: 0.95rem;
                justify-content: center;
            }

            .btn-search {
                  background: linear-gradient(180deg, #0077b6, #00b4d8);
                color: white;
                border: none;
            }

            .btn-search:hover {
                background: #007CB9;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(56, 173, 169, 0.3);
            }

            .btn-reset {
                background: white;
                color: #00ACD4;;
                border: 1.5px solid var(--primary);
            }

            .btn-reset:hover {
                  background: linear-gradient(180deg, #0077b6, #00b4d8);
                color: white;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(74, 105, 189, 0.2);
            }

            /* TABLE CARD */
            .table-card {
                background: white;
                margin: 30px auto;
                border-radius: var(--radius);
                overflow: hidden;
                box-shadow: var(--shadow);
                max-width: 1000px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th {
                background: var(--primary);
                color: white;
                padding: 16px 12px;
                text-align: center;
                font-weight: 600;
                font-size: 0.95rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            td {
                padding: 14px 12px;
                text-align: center;
                border-bottom: 1px solid var(--border);
                font-size: 0.95rem;
            }

            tr:hover {
                background-color: #f8f9fc;
            }

            .status-active {
                color: var(--success);
                font-weight: 700;
                font-size: 0.9rem;
            }

            .status-inactive {
                color: var(--danger);
                font-weight: 700;
                font-size: 0.9rem;
            }

            .btn-update {
                background: var(--primary);
                color: white;
                padding: 7px 14px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 0.85rem;
                font-weight: 500;
                transition: var(--transition);
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .btn-update:hover {
                background: var(--primary-dark);
                transform: translateY(-1px);
            }

            .badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                color: white;
            }

            .badge-hotel {
                background: #e67e22;
            }
            .badge-flight {
                background: #3498db;
            }
            .badge-vehicle {
                background: #9b59b6;
            }
            .badge-place {
                background: #1abc9c;
            }

            /* PAGINATION */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin: 30px 0;
                flex-wrap: wrap;
            }

            .pagination a, .pagination span {
                min-width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0 12px;
                color: var(--primary);
                text-decoration: none;
                border: 1.5px solid var(--primary);
                border-radius: 8px;
                font-weight: 500;
                transition: var(--transition);
            }

            .pagination a:hover {
                background: var(--primary);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(74, 105, 189, 0.2);
            }

            .pagination a.active {
                background: var(--primary);
                color: white;
                font-weight: 600;
            }

            .pagination span {
                color: var(--gray);
                border: none;
                cursor: default;
            }

            .no-data {
                text-align: center;
                padding: 40px;
                color: var(--gray);
                font-style: italic;
            }

            .no-data i {
                font-size: 3rem;
                color: #ddd;
                margin-bottom: 12px;
                display: block;
            }

            /* RESPONSIVE */
            @media (max-width: 768px) {
                .search-grid {
                    grid-template-columns: 1fr;
                }
                .price-range {
                    flex-direction: column;
                    align-items: stretch;
                }
                .price-range input {
                    width: 100%;
                }
                .btn-group {
                    justify-content: center;
                }
                table, .table-card {
                    font-size: 0.9rem;
                }
                th, td {
                    padding: 10px 6px;
                }
            }
            .table_service th{
                  background: linear-gradient(180deg, #0077b6, #00b4d8);
         color: white;
            }
        </style>
    </head>
    <body>
         <!-- Include Sidebar -->
    <%@ include file="/views/staff/sidebar.jsp" %>

        <!-- Header -->
  

        <div class="container">
            <h2><i class="fas fa-cogs"></i> Service Management</h2>

            <!-- SEARCH & FILTER CARD -->
            <div class="search-card">
                <form action="<%= request.getContextPath() %>/manager/service" method="get" style="display:inline-block; width:100%;">
                    <input type="hidden" name="action" value="search"/>
                    <div class="search-grid">
                        <div class="form-group">
                            <label><i class="fas fa-search"></i> Name</label>
                            <input type="text" name="name" placeholder="Enter service name"
                                   value="<%= request.getAttribute("search_name") != null ? request.getAttribute("search_name") : "" %>" />
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-building"></i> Type</label>
                            <select name="type">
                                <option value="All">All Types</option>
                                <option value="Hotel" <%= "Hotel".equals(request.getAttribute("search_type")) ? "selected" : "" %>>Hotel</option>
                                <option value="Flight" <%= "Flight".equals(request.getAttribute("search_type")) ? "selected" : "" %>>Flight</option>
                                <option value="Vehicle" <%= "Vehicle".equals(request.getAttribute("search_type")) ? "selected" : "" %>>Vehicle</option>
                                <option value="Place" <%= "Place".equals(request.getAttribute("search_type")) ? "selected" : "" %>>Place</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-dollar-sign"></i> Price Range</label>
                            <div class="price-range">
                                <input type="number" name="priceMin" placeholder="From"
                                       value="<%= request.getAttribute("search_priceMin") != null ? request.getAttribute("search_priceMin") : "" %>" />
                                <span>-</span>
                                <input type="number" name="priceMax" placeholder="To"
                                       value="<%= request.getAttribute("search_priceMax") != null ? request.getAttribute("search_priceMax") : "" %>" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-power-off"></i> Status</label>
                            <select name="status">
                                <option value="All">All Status</option>
                                <option value="Active" <%= "Active".equals(request.getAttribute("search_status")) ? "selected" : "" %>>Active</option>
                                <option value="Inactive" <%= "Inactive".equals(request.getAttribute("search_status")) ? "selected" : "" %>>Inactive</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-sort"></i> Sort</label>
                            <select name="sort">
                                <option value="">Default</option>
                                <option value="asc" <%= "asc".equals(request.getAttribute("sort")) ? "selected" : "" %>>Price (Low to High)</option>
                                <option value="desc" <%= "desc".equals(request.getAttribute("sort")) ? "selected" : "" %>>Price (High to Low)</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin-top:8px;">
                            <div class="btn-group">
                                <button type="submit" class="btn btn-search">
                                    <i class="fas fa-search"></i> Search
                                </button>
                                <a href="<%= request.getContextPath() %>/manager/service?action=list" class="btn btn-reset">
                                    <i class="fas fa-undo"></i> Reset Filter
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- SERVICES TABLE CARD -->
            <div class="table-card">
                <table>
                    <thead >
                        <tr class="table_service">
                            <th>ID</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Service> list = (List<Service>) request.getAttribute("services");
                            if (list != null && !list.isEmpty()) {
                                for (Service s : list) {
                                    String badgeClass = "";
                                    switch (s.getType()) {
                                        case "Hotel": badgeClass = "badge-hotel"; break;
                                        case "Flight": badgeClass = "badge-flight"; break;
                                        case "Vehicle": badgeClass = "badge-vehicle"; break;
                                        case "Place": badgeClass = "badge-place"; break;
                                        default: badgeClass = "badge"; break;
                                    }
                        %>
                        <tr>
                            <td><strong>#<%= s.getServiceId() %></strong></td>
                            <td><%= s.getName() %></td>
                            <td>
                                <span class="badge <%= badgeClass %>"><%= s.getType() %></span>
                            </td>
                            <td><strong><%= String.format("%,.0f", s.getPrice()) %> ₫</strong></td>
                            <td class="<%= s.getStatus().equalsIgnoreCase("Active") ? "status-active" : "status-inactive" %>">
                                ● <%= s.getStatus() %>
                            </td>
                            <td>
                                <form action="<%= request.getContextPath() %>/manager/service" method="get" style="display:inline;">
                                    <input type="hidden" name="action" value="detail"/>
                                    <input type="hidden" name="id" value="<%= s.getServiceId() %>"/>
                                    <input type="hidden" name="type" value="<%= s.getType() %>"/>
                                    <button type="submit" class="btn-update" style="   background-color: #00ACD4;">
                                        <i class="fas fa-eye"></i> View Detail
                                    </button>
                                </form>
                            </td>

                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" class="no-data">
                                <i class="fas fa-inbox"></i>
                                No services found matching your criteria.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- PAGINATION -->
            <div class="pagination">
                <%
                    int pageCurrent = (int) request.getAttribute("page");
                    int totalPages = (int) request.getAttribute("totalPages");

                    String queryString = "&action=search";
                    if (request.getAttribute("search_name") != null)
                        queryString += "&name=" + request.getAttribute("search_name");
                    if (request.getAttribute("search_type") != null)
                        queryString += "&type=" + request.getAttribute("search_type");
                    if (request.getAttribute("search_priceMin") != null)
                        queryString += "&priceMin=" + request.getAttribute("search_priceMin");
                    if (request.getAttribute("search_priceMax") != null)
                        queryString += "&priceMax=" + request.getAttribute("search_priceMax");
                    if (request.getAttribute("search_status") != null)
                        queryString += "&status=" + request.getAttribute("search_status");
                    if (request.getAttribute("sort") != null)
                        queryString += "&sort=" + request.getAttribute("sort");

                    if (pageCurrent > 1) {
                %>
                <a href="?page=<%= pageCurrent - 1 %><%= queryString %>"><i class="fas fa-chevron-left"></i></a>
                    <%
                        }

                        int startPage = Math.max(1, pageCurrent - 2);
                        int endPage = Math.min(totalPages, pageCurrent + 2);

                        if (startPage > 1) {
                    %>
                <a href="?page=1<%= queryString %>">1</a>
                <% if (startPage > 2) { %> <span>...</span> <% }
            }

            for (int i = startPage; i <= endPage; i++) {
                if (i == pageCurrent) {
                %>
                <a href="?page=<%= i %><%= queryString %>" class="active"><%= i %></a>
                <%
                        } else {
                %>
                <a href="?page=<%= i %><%= queryString %>"><%= i %></a>
                <%
                        }
                    }

                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1) { %> <span>...</span> <% }
                %>
                <a href="?page=<%= totalPages %><%= queryString %>"><%= totalPages %></a>
                <%
                    }

                    if (pageCurrent < totalPages) {
                %>
                <a href="?page=<%= pageCurrent+ 1 %><%= queryString %>"><i class="fas fa-chevron-right"></i></a>
                    <%
                        }
                    %>
            </div>
        </div>

    </body>
</html>