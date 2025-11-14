<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Đảo Du Lịch - Meland Travel</title>
        <jsp:include page="../common/css.jsp"/>

        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Poppins', sans-serif;
            }
            .main-content {
                margin-left: 250px;
                padding: 30px;
                min-height: 100vh;
            }
            .page-header {
                background: linear-gradient(135deg,#667eea 0%,#764ba2 100%);
                color:white;
                padding:25px;
                border-radius:15px;
                margin-bottom:25px;
            }
            .table-container {
                background:white;
                padding:25px;
                border-radius:15px;
                box-shadow:0 5px 15px rgba(0,0,0,0.1);
            }
            table th {
                background-color:#667eea;
                color:white;
                text-align:center;
                vertical-align:middle;
            }
            table td {
                vertical-align:middle;
            }
            .btn-action {
                margin-right:5px;
                border-radius:8px;
                font-weight:600;
            }
            .search-bar {
                background:white;
                padding:20px;
                border-radius:15px;
                box-shadow:0 2px 10px rgba(0,0,0,0.05);
                margin-bottom:25px;
            }
            .btn-add {
                background:linear-gradient(135deg,#28a745 0%,#20c997 100%);
                color:white;
                font-weight:600;
            }
            .btn-add:hover {
                background:linear-gradient(135deg,#218838 0%,#17a2b8 100%);
                color:white;
            }
            .island-img {
                width:80px;
                height:60px;
                object-fit:cover;
                border-radius:8px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="sidebar.jsp">
            <jsp:param name="page" value="islands"/>
        </jsp:include>

        <div class="main-content">
            <div class="page-header">
                <h1><i class="fa fa-globe-asia"></i> Quản lý Đảo Du Lịch</h1>
                <p>Xem, thêm, chỉnh sửa hoặc xóa thông tin đảo</p>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success"><i class="fa fa-check-circle"></i> ${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ${errorMessage}</div>
            </c:if>

            <!-- Form tìm kiếm -->
            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/staff/islands" method="get" class="row g-3">
                    <input type="hidden" name="action" value="search">

                    <div class="col-md-3">
                        <label class="form-label fw-bold">Tìm kiếm</label>
                        <input type="text" class="form-control" name="islandName" value="${searchIslandName}" placeholder="Nhập tên đảo">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold">Quốc gia</label>
                        <select class="form-control" name="country">
                            <option value="">-- Chọn quốc gia --</option>
                            <c:forEach var="country" items="${countries}">
                                <option value="${country.countryName}" ${searchCountry == country.countryName ? 'selected' : ''}>
                                    ${country.countryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold">Mùa du lịch</label>
                        <select class="form-control" name="season">
                            <option value="">-- Chọn mùa --</option>
                            <option value="Xuân" ${searchSeason == 'Xuân' ? 'selected' : ''}>Xuân</option>
                            <option value="Hạ" ${searchSeason == 'Hạ' ? 'selected' : ''}>Hạ</option>
                            <option value="Thu" ${searchSeason == 'Thu' ? 'selected' : ''}>Thu</option>
                            <option value="Đông" ${searchSeason == 'Đông' ? 'selected' : ''}>Đông</option>
                        </select>
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100"><i class="fa fa-search"></i> Tìm kiếm</button>
                    </div>
                </form>
            </div>

            <!-- Nút thêm mới -->
            <div class="text-end mb-3">
                <a href="${pageContext.request.contextPath}/staff/islands?action=create" class="btn btn-add">
                    <i class="fa fa-plus-circle"></i> Thêm Đảo Mới
                </a>
            </div>

            <!-- Danh sách -->
            <div class="table-container">
                <table class="table table-hover table-bordered align-middle">
                    <thead>
                        <tr>
                            <th>ID</th><th>Ảnh</th><th>Tên Đảo</th><th>Quốc Gia</th>
                            <th>Mùa Đẹp Nhất</th><th>Trạng Thái</th><th>Hoạt Động</th><th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty islands}">
                                <c:forEach var="island" items="${islands}">
                                    <tr>
                                        <td class="text-center">#${island.islandId}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty island.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}/views/home/images/islands/${island.imageUrl}"
                                                         alt="${island.islandName}" class="island-img">
                                                </c:when>
                                                <c:otherwise><i class="fa fa-image text-muted"></i></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><strong>${island.islandName}</strong></td>
                                        <td>${island.countryName}</td>
                                        <td>${island.bestSeason}</td>
                                        <td class="text-center">
                                            <c:set var="status" value="${island.approvalStatus}"/>
                                            <c:set var="statusLower" value="${fn:toLowerCase(fn:trim(status))}"/>
                                            <c:choose>
                                                <c:when test="${statusLower == 'pending'}">
                                                    <span class="badge bg-info text-white">Chờ Duyệt</span>
                                                </c:when>
                                                <c:when test="${statusLower == 'approved'}">
                                                    <span class="badge bg-success text-white">Đã Duyệt</span>
                                                </c:when>
                                                <c:when test="${statusLower == 'rejected'}">
                                                    <span class="badge bg-danger text-white">Từ Chối</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary text-white">Không Xác Định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${island.activities}</td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/staff/islands?action=detail&id=${island.islandId}"
                                               class="btn btn-info btn-sm btn-action"><i class="fa fa-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/staff/islands?action=edit&id=${island.islandId}"
                                               class="btn btn-warning btn-sm btn-action"><i class="fa fa-edit"></i></a>
                                            <a href="#" onclick="confirmDelete(${island.islandId}, '${island.islandName}')"
                                               class="btn btn-danger btn-sm btn-action"><i class="fa fa-trash"></i></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" class="text-center text-muted py-4">
                                        <i class="fa fa-exclamation-circle"></i> Không có dữ liệu hiển thị
                                    </td></tr>
                                </c:otherwise>
                            </c:choose>
                    </tbody>
                </table>
                <div class="text-end text-muted fw-semibold">Tổng số đảo: ${totalIslands}</div>
            </div>
        </div>

        <!-- Modal xóa -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog"><div class="modal-content">
                    <div class="modal-header"><h5 class="modal-title">Xác nhận xóa đảo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa đảo "<span id="islandNameToDelete"></span>"?</p>
                        <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                    </div>
                    <div class="modal-footer">
                        <form id="deleteForm" action="${pageContext.request.contextPath}/staff/islands" method="post">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="islandId" id="islandIdToDelete">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-danger">Xóa</button>
                        </form>
                    </div>
                </div></div>
        </div>

        <jsp:include page="../common/script.jsp"/>
        <script>
            function confirmDelete(id, name) {
                document.getElementById("islandIdToDelete").value = id;
                document.getElementById("islandNameToDelete").textContent = name;
                $('#deleteModal').modal('show');
            }
        </script>
    </body>
</html>
