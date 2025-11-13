<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                /* Đã chỉnh từ .container để giữ phong cách cũ, nhưng thêm margin-top */
                padding: 30px;
                max-width: 100%;
                margin-right: auto;
                margin-top: 20px; /* Giảm margin-top để hợp lý hơn */
                background-color: #ffffff;
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }
            
            /* Thêm style cho hình ảnh trong modal */
            #modalTourImage {
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
                <h1> <i class="bi bi-calendar-check"></i> Quản lý trạng thái tour</h1>
                <p class="flights-title text-white">
                    Danh sách duyệt tour: <span class="flights-count text-white small">

                    </span>
                </p>
            </div>
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
                                <button type="button" class="btn btn-info btn-sm"
                                        data-bs-toggle="modal"
                                        data-bs-target="#tourDetailModal"
                                        data-tour-id="<%=t.getTourId()%>"
                                        data-tour-name="<%=t.getTourName()%>"
                                        data-description="<%=t.getDescription()%>"
                                        data-price="<%= String.format("%,d", t.getPrice()) %>"
                                        data-island-name="<%=t.getIslandName() != null ? t.getIslandName() : "N/A"%>"
                                       data-image-url="<%=t.getTourImageUrl() != null ? request.getContextPath() + "/" + t.getTourImageUrl() : request.getContextPath() + "/images/default-tour.jpg" %>"

                                    <i class="bi bi-eye"></i> Xem chi tiết
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
                <%--Tourdetail--%>
        <div class="modal fade" id="tourDetailModal" tabindex="-1" aria-labelledby="tourDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="tourDetailModalLabel">Chi tiết Tour: <span id="modalTourName"></span></h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <form id="tourApprovalForm" method="POST" action="${pageContext.request.contextPath}/manager/tour-approval">
                        <input type="hidden" name="id" id="modalTourId">
                        <input type="hidden" name="action" id="modalAction">

                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-5">
                                    <img id="modalTourImage" src="" class="img-fluid rounded shadow-sm border" alt="Hình ảnh Tour">
                                </div>
                                <div class="col-md-7">
                                    <h4 class="text-primary"><span id="modalTourNameDetail"></span></h4>
                                    <p><strong>Đảo:</strong> <span id="modalIslandName"></span></p>
                                    <p><strong>Giá:</strong> <span id="modalPrice"></span> VND</p>

                                    <hr>

                                    <h6>Mô tả Tour</h6>
                                    <p id="modalDescription" class="text-muted small"></p>

                                    <hr>

                                    <div id="rejectionReasonGroup" class="mb-3" style="display:none;">
                                        <label for="rejectionReason" class="form-label"><strong>Lý do Từ chối:</strong></label>
                                        <textarea class="form-control" id="rejectionReason" name="rejectionReason" rows="3" placeholder="Nhập lý do từ chối tour (bắt buộc)" required></textarea>
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
                var tourDetailModal = document.getElementById('tourDetailModal');
                var rejectionReasonGroup = document.getElementById('rejectionReasonGroup');
                var rejectionReasonTextarea = document.getElementById('rejectionReason');
                var btnApprove = document.getElementById('btnApprove');
                var btnReject = document.getElementById('btnReject');
                var tourApprovalForm = document.getElementById('tourApprovalForm');

                // 1. Xử lý khi Modal được mở (lấy dữ liệu tour)
                tourDetailModal.addEventListener('show.bs.modal', function (event) {
                    var button = event.relatedTarget;
                    
                    // Lấy thông tin từ các data-* attributes của nút
                    var tourId = button.getAttribute('data-tour-id');
                    var tourName = button.getAttribute('data-tour-name');
                    var description = button.getAttribute('data-description');
                    var price = button.getAttribute('data-price');
                    var islandName = button.getAttribute('data-island-name');
                    var imageUrl = button.getAttribute('data-image-url');

                    // Cập nhật nội dung modal
                    document.getElementById('modalTourId').value = tourId;
                    document.getElementById('modalTourName').textContent = tourName;
                    document.getElementById('modalTourNameDetail').textContent = tourName;
                    document.getElementById('modalDescription').textContent = description;
                    document.getElementById('modalPrice').textContent = price; 
                    document.getElementById('modalIslandName').textContent = islandName;
                  document.getElementById('modalTourImage').src = imageUrl ? imageUrl : 'path/to/default-image.jpg';
// Dùng hình ảnh mặc định nếu null

                    // Đặt lại trạng thái mặc định của form và nút
                    rejectionReasonGroup.style.display = 'none';
                    rejectionReasonTextarea.required = false;
                    btnReject.textContent = ' Từ chối';
                    btnReject.prepend(document.createElement('i')).className = 'bi bi-x-lg'; // Thêm icon lại
                    
                    // Xóa giá trị cũ trong form
                    document.getElementById('modalAction').value = '';
                    rejectionReasonTextarea.value = '';
                });

                // 2. Xử lý khi nhấn nút Duyệt
                btnApprove.addEventListener('click', function() {
                    document.getElementById('modalAction').value = 'approve';
                    rejectionReasonTextarea.required = false; 
                    tourApprovalForm.submit();
                });

                // 3. Xử lý logic 2 bước cho nút Từ chối
                btnReject.addEventListener('click', function() {
                    // Bước 1: Nếu nhóm lý do đang ẩn, hiển thị nó
                    if (rejectionReasonGroup.style.display === 'none') {
                        rejectionReasonGroup.style.display = 'block';
                        rejectionReasonTextarea.required = true;
                        btnReject.innerHTML = '<i class="bi bi-x-circle-fill"></i> Xác nhận Từ chối'; // Đổi text và icon
                         btnApprove.style.display = 'none';
                        document.getElementById('modalAction').value = 'reject'; 
                    } else {
                        // Bước 2: Nếu nhóm lý do đang hiện, kiểm tra và gửi form
                        if (rejectionReasonTextarea.checkValidity()) {
                            document.getElementById('modalAction').value = 'reject';
                            tourApprovalForm.submit();
                        } else {
                            // Bắt buộc trình duyệt hiển thị lỗi validation
                            rejectionReasonTextarea.reportValidity();
                        }
                    }
                         btnApprove.disabled=false;
                });
                
                // 4. Reset nút Từ chối khi Modal đóng
                tourDetailModal.addEventListener('hidden.bs.modal', function () {
                    btnReject.innerHTML = '<i class="bi bi-x-lg"></i> Từ chối';
                    rejectionReasonGroup.style.display = 'none';
                       btnApprove.style.display = 'inline-block';
                    rejectionReasonTextarea.required = false;
                });
            });
        </script>   
    </body>
</html>