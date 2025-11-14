<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Island" %>

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
                margin-left: 260px;
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
                margin-top: 20px; 
                background-color: #ffffff;
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }
            
            #modalIslandImage {
                max-height: 250px;
                width: 100%;
                object-fit: cover;
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
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Island i : islands) {
                        %>
                        <tr>
                            <td class="text-center"><%= i.getIslandId() %></td>
                            <td><%= i.getIslandName() %></td>
                            <td><%= i.getCountryName() != null ? i.getCountryName() : "N/A" %></td>
                            <td><%= i.getShortDescription() %></td>
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
                                <button type="button" class="btn btn-info btn-sm"
                                        data-bs-toggle="modal"
                                        data-bs-target="#islandDetailModal"
                                        data-island-id="<%=i.getIslandId()%>"
                                        data-island-name="<%=i.getIslandName()%>"
                                        data-short-description="<%=i.getShortDescription()%>"
                                        data-long-description="<%=i.getLongDescription()%>"
                                        data-country-name="<%=i.getCountryName() != null ? i.getCountryName() : "N/A"%>"
                                        data-image-url="<%=i.getImageUrl() != null ? i.getImageUrl() : ""%>"
                                        data-location="<%=i.getLocation()%>"
                                        data-best-season="<%=i.getBestSeason()%>"
                                        data-activities="<%=i.getActivities()%>">
                                    <i class="bi bi-eye"></i> Xem/Duyệt
                                </button>
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

        <div class="modal fade" id="islandDetailModal" tabindex="-1" aria-labelledby="islandDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="islandDetailModalLabel">Chi tiết Đảo: <span id="modalIslandName"></span></h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <form id="islandApprovalForm" method="POST" action="${pageContext.request.contextPath}/manager/island-approval">
                        <input type="hidden" name="id" id="modalIslandId">
                        <input type="hidden" name="action" id="modalAction">

                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-5">
                                    <img id="modalIslandImage" src="" class="img-fluid rounded shadow-sm border" alt="Hình ảnh Đảo">
                                </div>
                                <div class="col-md-7">
                                    <h4 class="text-primary"><span id="modalIslandNameDetail"></span></h4>
                                    <p><strong>Quốc gia:</strong> <span id="modalCountryName"></span></p>
                                    <p><strong>Vị trí:</strong> <span id="modalLocation"></span></p>
                                    <p><strong>Mùa đẹp nhất:</strong> <span id="modalBestSeason"></span></p>
                                    <p><strong>Hoạt động chính:</strong> <span id="modalActivities"></span></p>
                                    
                                    <hr>
                                    
                                    <h6>Mô tả Chi tiết</h6>
                                    <p id="modalLongDescription" class="text-muted small"></p>

                                    <hr>

                                    <div id="rejectionReasonGroup" class="mb-3" style="display:none;">
                                        <label for="rejectionReason" class="form-label"><strong>Lý do Từ chối:</strong></label>
                                        <textarea class="form-control" id="rejectionReason" name="rejectionReason" rows="3" placeholder="Nhập lý do từ chối đảo (bắt buộc)" required></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="button" class="btn btn-danger" id="btnReject">
                                <i class="bi bi-x-lg"></i> Từ chối
                            </button>
                            <button type="button" class="btn btn-success" id="btnApprove">
                                <i class="bi bi-check-lg"></i> Duyệt
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var islandDetailModal = document.getElementById('islandDetailModal');
                var rejectionReasonGroup = document.getElementById('rejectionReasonGroup');
                var rejectionReasonTextarea = document.getElementById('rejectionReason');
                var btnApprove = document.getElementById('btnApprove');
                var btnReject = document.getElementById('btnReject');
                var islandApprovalForm = document.getElementById('islandApprovalForm');

                // 1. Xử lý khi Modal được mở (lấy dữ liệu Đảo)
                islandDetailModal.addEventListener('show.bs.modal', function (event) {
                    var button = event.relatedTarget;
                    
                    // Lấy thông tin từ các data-* attributes của nút
                    var islandId = button.getAttribute('data-island-id');
                    var islandName = button.getAttribute('data-island-name');
                    var longDescription = button.getAttribute('data-long-description');
                    var countryName = button.getAttribute('data-country-name');
                    var imageUrl = button.getAttribute('data-image-url');
                    var location = button.getAttribute('data-location');
                    var bestSeason = button.getAttribute('data-best-season');
                    var activities = button.getAttribute('data-activities');

                    // Cập nhật nội dung modal
                    document.getElementById('modalIslandId').value = islandId;
                    document.getElementById('modalIslandName').textContent = islandName;
                    document.getElementById('modalIslandNameDetail').textContent = islandName;
                    document.getElementById('modalLongDescription').textContent = longDescription;
                    document.getElementById('modalCountryName').textContent = countryName; 
                    document.getElementById('modalIslandImage').src = imageUrl || 'url_den_hinh_mac_dinh.jpg';
                    document.getElementById('modalLocation').textContent = location;
                    document.getElementById('modalBestSeason').textContent = bestSeason;
                    document.getElementById('modalActivities').textContent = activities;


                    // Đặt lại trạng thái mặc định của form và nút
                    rejectionReasonGroup.style.display = 'none';
                    rejectionReasonTextarea.required = false;
                    btnReject.innerHTML = '<i class="bi bi-x-lg"></i> Từ chối';
                    
                    // Xóa giá trị cũ trong form
                    document.getElementById('modalAction').value = '';
                    rejectionReasonTextarea.value = '';
                });

                // 2. Xử lý khi nhấn nút Duyệt
                btnApprove.addEventListener('click', function() {
                    document.getElementById('modalAction').value = 'approve';
                    rejectionReasonTextarea.required = false; 
                    islandApprovalForm.submit();
                });

                // 3. Xử lý logic 2 bước cho nút Từ chối
                btnReject.addEventListener('click', function() {
                    // Bước 1: Nếu nhóm lý do đang ẩn, hiển thị nó
                    if (rejectionReasonGroup.style.display === 'none') {
                        rejectionReasonGroup.style.display = 'block';
                        rejectionReasonTextarea.required = true;
                        btnReject.innerHTML = '<i class="bi bi-x-circle-fill"></i> Xác nhận Từ chối'; // Đổi text và icon
                        document.getElementById('modalAction').value = 'reject'; 
                        btnApprove.style.display='none';
                    } else {
                        // Bước 2: Nếu nhóm lý do đang hiện, kiểm tra và gửi form
                        if (rejectionReasonTextarea.checkValidity()) {
                            document.getElementById('modalAction').value = 'reject';
                            islandApprovalForm.submit();
                        } else {
                            // Bắt buộc trình duyệt hiển thị lỗi validation
                            rejectionReasonTextarea.reportValidity();
                        }
                    }
                });
                
                // 4. Reset nút Từ chối khi Modal đóng
                islandDetailModal.addEventListener('hidden.bs.modal', function () {
                    btnReject.innerHTML = '<i class="bi bi-x-lg"></i> Từ chối';
                    rejectionReasonGroup.style.display = 'none';
                    btnApprove.style.display='inline-block';
                    rejectionReasonTextarea.required = false;
                });
            });
        </script>
    </body>
</html>