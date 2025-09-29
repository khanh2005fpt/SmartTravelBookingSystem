<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <%@ include file="/views/common/css.jsp" %>

        <title>Thanh toán Tour - Demo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <%@ include file="/views/common/navbar.jsp" %>

        <div class="container py-5">
            <div class="row g-4">

                <!-- Thông tin khách hàng -->
                <div class="col-md-6">
                    <div class="card shadow p-4 mb-4">
                        <h4 class="mb-3 text-primary fw-bold">📝 Thông tin khách hàng</h4>

                        <form>
                            <div class="mb-3">
                                <label class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" placeholder="">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" placeholder="">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" placeholder="">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" placeholder="">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Phương thức thanh toán</label>
                                <div class="list-group">
                                    <label class="list-group-item d-flex align-items-center">
                                        <input type="radio" class="form-check-input me-2" name="payment" value="vnpay" checked>
                                        <img src="https://vnpay.vn/favicon.ico" alt="VNPAY" width="24" class="me-2">
                                        VNPAY QR
                                    </label>
                                </div>
                            </div>

                            <!-- Khung hiển thị QR Code -->
                            <div id="vnpay-qr" class="text-center mt-3">
                                <h6 class="text-primary fw-bold">Quét mã QR để thanh toán</h6>
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=ThanhToanVNPAY_Demo" 
                                     alt="VNPAY QR" class="img-fluid border border-2 rounded shadow">
                                <p class="text-muted mt-2 small">💡 Sử dụng app ngân hàng hoặc VNPAY để quét mã QR</p>
                            </div>


                            <div class="d-flex justify-content-between mt-4">
                                <a href="tours.jsp" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-check-circle"></i> Xác nhận thanh toán
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Thông tin tour -->
                <div class="col-md-6">
                    <div class="card shadow p-4">
                        <h4 class="mb-3 text-primary fw-bold">📌 Thông tin Tour</h4>

                        <!-- Ảnh tour -->
                        <div class="mb-3 text-center">
                            <img src="https://picsum.photos/600/300" alt="Tour" class="img-fluid rounded shadow-sm">
                        </div>

                        <ul class="list-group mb-3">
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Tên tour</b></span>
                                <span></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Ngày khởi hành</b></span>
                                <span></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Người lớn</b></span>
                                <span></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Trẻ em</b></span>
                                <span></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between bg-light">
                                <span><b>Tổng tiền</b></span>
                                <span class="fw-bold text-danger"></span>
                            </li>
                        </ul>

                        <div class="alert alert-info">
                            💡 Vui lòng kiểm tra kỹ thông tin trước khi thanh toán.
                        </div>

                        <div class="mt-3 text-muted small">
                            <i class="bi bi-shield-lock-fill text-success"></i> Cam kết bảo mật thông tin và an toàn giao dịch.
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="/views/common/footer.jsp" %>
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <%@ include file="/views/common/script.jsp" %>
    </body>
</html>
