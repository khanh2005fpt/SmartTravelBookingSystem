<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <%@ include file="/views/common/css.jsp" %>

        <title>Thanh toán Tour - Demo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <div class="container py-5">
            <div class="row">
                <!-- Form thông tin cá nhân -->
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
                                <select class="form-select">
                                    <option selected disabled>-- Chọn phương thức --</option>
                                    <option value="cash">💵 Thanh toán khi đi tour</option>
                                    <option value="credit">💳 Thẻ tín dụng/ghi nợ</option>
                                    <option value="momo">📱 Ví MoMo</option>
                                    <option value="bank">🏦 Chuyển khoản ngân hàng</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-success w-100">Thanh toán ngay</button>
                        </form>
                    </div>
                </div>

                <!-- Thông tin tour -->
                <div class="col-md-6">
                    <div class="card shadow p-4">
                        <h4 class="mb-3 text-primary fw-bold">📌 Thông tin Tour</h4>
                        <ul class="list-group mb-3">
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Tên tour</b></span>
                                <span>Đà Nẵng - Hội An</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Ngày khởi hành</b></span>
                                <span>2025-10-15</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Số người lớn</b></span>
                                <span>2</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Số trẻ em</b></span>
                                <span>1</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Tổng tiền</b></span>
                                <span class="fw-bold text-danger">12,500,000 VND</span>
                            </li>
                        </ul>
                        <p class="text-muted">💡 Vui lòng kiểm tra kỹ thông tin trước khi thanh toán.</p>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
