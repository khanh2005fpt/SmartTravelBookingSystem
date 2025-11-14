<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.Island" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
    Island island = (Island) request.getAttribute("islandDetail"); 
    if (island == null) {
        response.sendRedirect("island-approval"); 
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Đảo: <%= island.getIslandName() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .main-content { margin-left: 260px; padding: 40px; }
        .detail-card { 
            background: #fff; 
            padding: 30px; 
            border-radius: 15px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
        }
        .detail-header {
            border-bottom: 2px solid #00ACD4;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    
    <%@ include file="/views/staff/sidebar.jsp" %>

    <div class="main-content">
        <a href="${pageContext.request.contextPath}/manager/island-approval" class="btn btn-secondary mb-4">
            <i class="bi bi-arrow-left"></i> Quay lại Duyệt Đảo
        </a>
        
        <div class="detail-card">
            <div class="detail-header">
                <h2 class="text-primary">Chi Tiết Đảo: <%= island.getIslandName() %></h2>
                <span class="badge bg-secondary">ID: <%= island.getIslandId() %></span>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Quốc gia:</strong> <%= island.getCountryName() %></p>
                    <p><strong>Vị trí:</strong> <%= island.getLocation() %></p>
                    <p><strong>Mùa tốt nhất:</strong> <%= island.getBestSeason() %></p>
                    <p><strong>Trạng thái duyệt:</strong> 
                        <% if ("APPROVED".equalsIgnoreCase(island.getApprovalStatus())) { %>
                            <span class="badge bg-success">APPROVED</span>
                        <% } else if ("REJECTED".equalsIgnoreCase(island.getApprovalStatus())) { %>
                            <span class="badge bg-danger">REJECTED</span>
                        <% } else { %>
                            <span class="badge bg-warning">PENDING</span>
                        <% } %>
                    </p>
                </div>
                <div class="col-md-6 text-center">
                    <img src="<%= island.getImageUrl() %>" alt="<%= island.getIslandName() %>" class="img-fluid rounded shadow-sm" style="max-height: 250px; object-fit: cover;">
                </div>
            </div>
            
            <hr>
            
            <h4>Mô tả Ngắn</h4>
            <p><%= island.getShortDescription() %></p>
            
            <h4>Mô tả Chi tiết</h4>
            <p><%= island.getLongDescription() %></p>

            <h4>Hoạt động</h4>
            <p><%= island.getActivities() %></p>
            
            <hr>
            
            <h4 class="mt-4">Hành động</h4>
            <div class="d-flex justify-content-start">
                <a href="${pageContext.request.contextPath}/manager/island-approval?action=approve&id=<%=island.getIslandId()%>"
                   class="btn btn-success btn-lg me-3"><i class="bi bi-check-lg"></i> Duyệt Ngay</a>
                
                <button onclick="promptForRejectionReasonIsland(<%=island.getIslandId()%>)"
                   class="btn btn-danger btn-lg"><i class="bi bi-x-lg"></i> Từ chối</button>
            </div>
            
            <script>
                // Hàm JS cần thiết cho nút Từ chối trên trang chi tiết
                function promptForRejectionReasonIsland(islandId) {
                    const reason = prompt("Vui lòng nhập lý do từ chối Đảo ID #" + islandId + ":");
                    
                    if (reason) {
                        const encodedReason = encodeURIComponent(reason);
                        // Quay lại Servlet để xử lý
                        const url = "${pageContext.request.contextPath}/manager/island-approval?action=reject&id=" + islandId + "&reason=" + encodedReason;
                        window.location.href = url;
                    } else if (reason === "") {
                        alert("Lý do từ chối không được để trống.");
                    }
                }
            </script>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>