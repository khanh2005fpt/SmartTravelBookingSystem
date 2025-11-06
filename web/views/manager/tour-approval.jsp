<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Tour" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Duyệt Tour - Manager Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .main-content {
            margin-left: 260px; /* phù hợp với chiều rộng sidebar */
            padding: 40px;
        }
        .table th {
            background-color: #1e3a8a;
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
    </style>
</head>

<body>
    <!-- ✅ Import sidebar chung dành cho Manager -->
  

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <h2 class="mb-4 text-primary"><i class="bi bi-check2-circle"></i> Duyệt Tour Du Lịch</h2>

            <%
                List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                if (tours == null || tours.isEmpty()) {
            %>
                <div class="alert alert-info text-center">
                    Hiện không có tour nào đang chờ duyệt.
                </div>
            <%
                } else {
            %>
            <table class="table table-bordered table-striped align-middle shadow-sm">
                <thead>
                    <tr class="text-center">
                        <th>ID</th>
                        <th>Tên tour</th>
                        <th>Đảo</th>
                        <th>Mô tả</th>
                        <th>Giá (VNĐ)</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Tour t : tours) {
                    %>
                    <tr>
                        <td class="text-center"><%= t.getTourId() %></td>
                        <td><%= t.getTourName() %></td>
                        <td><%= t.getIslandName() != null ? t.getIslandName() : "N/A" %></td>
                        <td><%= t.getDescription() %></td>
                        <td class="text-end"><%= String.format("%,d", t.getPrice()) %></td>
                        <td class="text-center">
                            <% if ("APPROVED".equalsIgnoreCase(t.getApprovalStatus())) { %>
                                <span class="badge badge-approved">APPROVED</span>
                            <% } else if ("REJECTED".equalsIgnoreCase(t.getApprovalStatus())) { %>
                                <span class="badge badge-rejected">REJECTED</span>
                            <% } else { %>
                                <span class="badge badge-pending">PENDING</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/manager/tour-approval?action=approve&id=<%=t.getTourId()%>"
                               class="btn btn-success btn-sm"><i class="bi bi-check-lg"></i> Duyệt</a>
                            <a href="${pageContext.request.contextPath}/manager/tour-approval?action=reject&id=<%=t.getTourId()%>"
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
