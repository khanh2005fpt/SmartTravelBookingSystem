<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Island" %> // Đã đổi từ model.Tour sang model.Island

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Duyệt Đảo - Manager Panel</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            /* === CSS ĐÃ ĐỒNG BỘ TỪ tour-approval.jsp === */
            body {
                background-color: #f5f7fa;
                font-family: 'Segoe UI', sans-serif;
            }
            .main-content {
                margin-left: 260px; /* phù hợp với chiều rộng sidebar */
                padding: 40px;
            }
            .table th {
                background-color: #00ACD4;
                color: #fff;
            }
            .badge-pending {
                background-color: #f59e0b;
            }
            .badge-approved {
                background-color: #10b981;
            }
            .badge-rejected {
                background-color: #ef4444;
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

            .container-fluid {
                padding: 30px;
                max-width: 100%;
                margin-right: auto;
                background-color: #ffffffb3;
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }
        </style>
    </head>

    <body>
        <%@ include file="/views/staff/sidebar.jsp" %>

        <div class="main-content">

            <div class="page-header ">
                <h1> <i class="bi bi-globe"></i> Quản lý trạng thái Đảo</h1>
                <p class="flights-title text-white">
                    Danh sách duyệt Đảo: <span class="flights-count text-white small">

                    </span>
                </p>
            </div>

            <div class="container-fluid">
                <h2 class="mb-4 text-primary"><i class="bi bi-check2-circle"></i> Duyệt Đảo Du Lịch</h2>

                <%
                    // Lấy danh sách Đảo
                    List<Island> islands = (List<Island>) request.getAttribute("islands");
                    if (islands == null || islands.isEmpty()) {
                %>
                <div class="alert alert-info text-center">
                    Hiện không có Đảo nào đang chờ duyệt.
                </div>
                <%
                    } else {
                %>
                <table class="table table-bordered table-striped align-middle shadow-sm">
                    <thead>
                        <tr class="text-center">
                            <th>ID</th>
                            <th>Tên Đảo</th>
                            <th>Quốc gia</th>
                            <th>Mô tả Ngắn</th>
                            <th>Vị trí</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Island i : islands) { // Đổi t thành i và tours thành islands
                        %>
                        <tr>
                            <td class="text-center"><%= i.getIslandId() %></td>
                            <td><%= i.getIslandName() %></td>
                            <td><%= i.getCountryName() != null ? i.getCountryName() : "N/A" %></td>
                            
                            <td><%= i.getShortDescription() %></td>
                            
                            <td class="text-center"><%= i.getLocation() %></td>
                            
                            <td class="text-center">
                                <% if ("APPROVED".equalsIgnoreCase(i.getApprovalStatus())) { %>
                                <span class="badge badge-approved">APPROVED</span>
                                <% } else if ("REJECTED".equalsIgnoreCase(i.getApprovalStatus())) { %>
                                <span class="badge badge-rejected">REJECTED</span>
                                <% } else { %>
                                <span class="badge badge-pending">PENDING</span>
                                <% } %>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/manager/island-approval?action=approve&id=<%=i.getIslandId()%>"
                                   class="btn btn-success btn-sm"><i class="bi bi-check-lg"></i> Duyệt</a>
                                <a href="${pageContext.request.contextPath}/manager/island-approval?action=reject&id=<%=i.getIslandId()%>"
                                   class="btn btn-danger btn-sm"><i class="bi bi-x-lg"></i> Từ chối</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <%
                    }
                %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>