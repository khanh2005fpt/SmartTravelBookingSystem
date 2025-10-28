<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

                        <form action="PaymentController" method="post">
                            <input type="hidden" name="tourId" value="${tour.tourId}" />
                            <input type="hidden" name="customTourId" value="${customtour.customTourId}" />
                            <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                            <input type="hidden" name="totalBill" value="${booking.totalPrice}">
                            <input type="hidden" name="adultQuantity" value="${booking.adultQuantity}" />
                            <input type="hidden" name="childQuantity" value="${booking.childQuantity}" />
                            <input type="hidden" name="departureDate" value="${booking.departureDate}" />

                            <div class="mb-3">
                                <label>Họ và tên</label>
                                <input type="text" class="form-control" name="fullname"
                                       value="${sessionScope.user.fullName}">
                            </div>

                            <div class="mb-3">
                                <label>Email</label>
                                <input type="email" class="form-control" name="email"
                                       value="${sessionScope.user.email}">
                            </div>

                            <div class="mb-3">
                                <label>Số điện thoại</label>
                                <input type="text" class="form-control" name="phone"
                                       value="${sessionScope.user.phone}">
                            </div>

                            <div class="mb-3">
                                <label>Địa chỉ</label>
                                <input type="text" class="form-control" name="address"
                                       value="${sessionScope.profile_customer.address}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Phương thức thanh toán</label>
                                <div class="list-group">
                                    <label class="list-group-item d-flex align-items-center">
                                        <input type="radio" class="form-check-input me-2" name="payment" value="vnpay" checked required>
                                        <img src="https://vnpay.vn/favicon.ico" alt="VNPAY" width="24" class="me-2">
                                        VNPAY QR
                                    </label>
                                </div>
                            </div>

                            <div class="alert alert-info small">
                                💡 Bạn sẽ được chuyển đến cổng VNPAY để hoàn tất thanh toán.
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="javascript:history.back()" class="btn btn-outline-secondary">Quay lại</a>
                                <button type="submit" class="btn btn-success">Thanh toán ngay</button>
                            </div>
                        </form>

                    </div>
                </div>

                <!-- Thông tin tour -->
                <div class="col-md-6">
                    <div class="card shadow p-4">
                        <h4 class="mb-3 text-primary fw-bold">📌 Thông tin Tour</h4>

                        <!-- Ảnh tour -->



                        <ul class="list-group mb-3">
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Tên tour</b></span>
                                <c:choose>
                                    <c:when test="${not empty tour}">
                                        <span>${tour.tourName}</span>
                                    </c:when>
                                    <c:when test="${not empty customtour}">
                                        <span>${customtour.tourName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-danger">Không có dữ liệu tour</span>
                                    </c:otherwise>
                                </c:choose>
                            </li>

                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Ngày khởi hành</b></span>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty booking.departureDate}">
                                            <fmt:formatDate value="${booking.departureDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatDate value="${tour.startDate}" pattern="dd/MM/yyyy"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>

                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Người lớn</b></span>
                                <span>${booking.adultQuantity}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><b>Trẻ em</b></span>
                                <span>${booking.childQuantity}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between bg-light">
                                <span><b>Tổng tiền</b></span>
                                <span class="fw-bold text-danger">
                                    <fmt:setLocale value="vi_VN" />
                                    <fmt:formatNumber value="${booking.totalPrice}" type="number" groupingUsed="true"/> VNĐ
                                </span>
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
