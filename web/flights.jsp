<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Danh sách chuyến bay</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    </head>
    <body class="container mt-4">

        <h2 class="text-center">Danh sách chuyến bay</h2>

        <!-- Hiển thị lỗi -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger text-center">
                ${errorMessage}
            </div>
        </c:if>

        <!-- Form Search theo số hiệu -->
        <form method="get" action="flights" class="mb-3 d-flex align-items-center">
            <label class="me-2">Tìm theo số hiệu:</label>
            <select name="searchFlightNumber" class="form-select w-auto me-2" onchange="this.form.submit()">
                <option value="">-- Tất cả --</option>
                <c:forEach var="num" items="${flightNumbers}">
                    <option value="${num}" ${num == searchFlightNumber ? "selected" : ""}>${num}</option>
                </c:forEach>
            </select>
            <noscript><button type="submit" class="btn btn-primary">Tìm</button></noscript>
        </form>

        <!-- Form Search theo Hãng -->
        <form method="get" action="flights" class="mb-3 d-flex align-items-center">
            <label class="me-2">Tìm theo hãng bay:</label>
            <select name="searchAirlineId" class="form-select w-auto me-2" onchange="this.form.submit()">
                <option value="">-- Tất cả --</option>
                <c:forEach var="a" items="${airlines}">
                    <option value="${a.airlineId}" ${a.airlineId == searchAirlineId ? "selected" : ""}>
                        ${a.airlineName}
                    </option>
                </c:forEach>
            </select>
            <noscript><button type="submit" class="btn btn-primary">Tìm</button></noscript>
        </form>



        <!-- Button mở modal Add -->
        <button class="btn btn-primary mb-3"
                data-bs-toggle="modal" data-bs-target="#flightModal"
                onclick="openAddModal()">+ Thêm chuyến bay</button>

        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Số hiệu</th>
                    <th>Hãng</th>
                    <th>Nơi đi</th>
                    <th>Nơi đến</th>
                    <th>Khởi hành</th>
                    <th>Đến</th>
                    <th>Giá vé</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="f" items="${flights}">
                    <tr>
                        <td>${f.flightId}</td>
                        <td>${f.flightNumber}</td>
                        <td>
                            <c:forEach var="a" items="${airlines}">
                                <c:if test="${a.airlineId == f.airlineId}">
                                    ${a.airlineName}
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>${f.departure}</td>
                        <td>${f.destination}</td>
                        <td>${f.departureTime}</td>
                        <td>${f.arrivalTime}</td>
                        <td>${f.price}</td>
                        <td>
                            <button class="btn btn-sm btn-warning"
                                    data-bs-toggle="modal" data-bs-target="#flightModal"
                                    onclick="openEditModal(
                                    ${f.flightId},
                                                    '${f.flightNumber}',
                                    ${f.airlineId},
                                                    '${f.departure}',
                                                    '${f.destination}',
                                                    '${f.destinationIslandId}',
                                                    '${f.departureTime}',
                                                    '${f.arrivalTime}',
                                    ${f.price}
                                            )">
                                Sửa
                            </button>
                            <button class="btn btn-sm btn-danger"
                                    onclick="openDeleteModal(${f.flightId})">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="text-center">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="flights?page=${i}" class="btn btn-sm ${i == currentPage ? 'btn-dark' : 'btn-outline-dark'}">${i}</a>
            </c:forEach>
        </div>

        <!-- Modal Add/Update -->
        <div class="modal fade" id="flightModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="flightForm" method="post" action="flights">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTitle">Thêm chuyến bay</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="flightId" id="flightId">

                            <div class="row mb-3">
                                <div class="col">
                                    <label>Số hiệu</label>
                                    <input type="text" class="form-control" name="flightNumber" id="flightNumber" required>
                                </div>
                                <div class="col">
                                    <label>Hãng bay</label>
                                    <select class="form-control" name="airlineId" id="airlineId" required>
                                        <option value="">-- Chọn hãng --</option>
                                        <c:forEach var="a" items="${airlines}">
                                            <option value="${a.airlineId}">${a.airlineName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col">
                                    <label>Nơi đi</label>
                                    <input type="text" class="form-control" name="departure" id="departure" required>
                                </div>
                                <div class="col">
                                    <label>Nơi đến</label>
                                    <input type="text" class="form-control" name="destination" id="destination" required>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col">
                                    <label>Đảo (Destination)</label>
                                    <select class="form-control" name="destinationIslandId" id="destinationIslandId">
                                        <option value="">-- Không chọn --</option>
                                        <c:forEach var="is" items="${islands}">
                                            <option value="${is.islandId}">${is.islandName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col">
                                    <label>Giá vé</label>
                                    <input type="number" step="0.01" min="0" class="form-control" name="price" id="price" required>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col">
                                    <label>Khởi hành</label>
                                    <input type="datetime-local" class="form-control" name="departureTime" id="departureTime" required>
                                </div>
                                <div class="col">
                                    <label>Đến</label>
                                    <input type="datetime-local" class="form-control" name="arrivalTime" id="arrivalTime" required>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Xác nhận Xóa -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn xóa chuyến bay này không?
                    </div>
                    <div class="modal-footer">
                        <a id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        function openAddModal() {
                                            document.getElementById("modalTitle").innerText = "Thêm chuyến bay";
                                            document.getElementById("formAction").value = "add";
                                            document.getElementById("flightForm").reset();
                                            document.getElementById("flightId").value = "";
                                            document.getElementById("flightNumber").readOnly = false;
                                            document.getElementById("flightNumber").style.backgroundColor = "white";
                                        }

                                        function openEditModal(id, number, airlineId, departure, destination, islandId, depTime, arrTime, price) {
                                            document.getElementById("modalTitle").innerText = "Cập nhật chuyến bay";
                                            document.getElementById("formAction").value = "update";
                                            document.getElementById("flightId").value = id;

                                            document.getElementById("flightNumber").value = number;
                                            document.getElementById("flightNumber").readOnly = true;
                                            document.getElementById("flightNumber").style.backgroundColor = "#e9ecef";

                                            document.getElementById("airlineId").value = airlineId;
                                            document.getElementById("departure").value = departure;
                                            document.getElementById("destination").value = destination;
                                            document.getElementById("destinationIslandId").value = (islandId !== 'null' ? islandId : '');
                                            document.getElementById("price").value = price;

                                            document.getElementById("departureTime").value = depTime.replace(" ", "T");
                                            document.getElementById("arrivalTime").value = arrTime.replace(" ", "T");
                                        }

                                        function openDeleteModal(flightId) {
                                            let deleteBtn = document.getElementById("confirmDeleteBtn");
                                            deleteBtn.href = "flights?action=delete&id=" + flightId;
                                            let deleteModal = new bootstrap.Modal(document.getElementById("deleteModal"));
                                            deleteModal.show();
                                        }
        </script>

    </body>
</html>
