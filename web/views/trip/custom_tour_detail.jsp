<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Chi tiết Tour Riêng</title>
        <%@ include file="/views/common/css.jsp" %>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            .hero-card {
                border-radius: 15px;
            }
            .price-badge {
                font-size: 1.2rem;
                padding: 0.5rem 1rem;
            }
            .itinerary-day {
                background-color: #f8f9fa;
                border-left: 4px solid #0d6efd;
            }
            .btn-primary {
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            .table-hover tbody tr:hover {
                background-color: #e9f2ff;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/views/common/navbar.jsp" %>

        <div class="container py-5" style="max-width: 1400px;">
            <div class="row justify-content-center">
                <!-- Header -->
                <div class="col-12 text-center mb-5">
                    <h1 class="display-5 fw-bold text-primary">🌴 Tour Riêng vừa tạo thành công</h1>
                    <p class="text-muted fs-6">Chi tiết tour & lịch trình mẫu — điều chỉnh và đặt ngay bên phải.</p>
                </div>

                <!-- Left Column: Tour Details -->
                <div class="col-lg-8">
                    <!-- Tour Info -->
                    <div class="card hero-card shadow-sm mb-4 p-4">
                        <div class="d-flex align-items-start gap-3">
                            <div class="flex-grow-1">
                                <h3 class="fw-bold mb-2">${tour.tourName}</h3>
                                <p class="mb-1"><i class="bi bi-calendar-event me-2"></i>
                                    <strong>Thời gian:</strong>
                                    <span class="text-muted">${tour.startDate} — ${tour.endDate}</span>
                                </p>
                                <p class="mb-0"><strong>Tổng giá:</strong>
                                    <span class="badge bg-primary ms-2 price-badge">
                                        <fmt:setLocale value="vi_VN"/>
                                        <fmt:formatNumber value="${tour.totalPrice}" type="number" groupingUsed="true"/> VNĐ
                                    </span>
                                </p>
                            </div>
                            <div class="text-end d-none d-md-block">
                                <i class="bi bi-geo-alt-fill text-primary" style="font-size:2.5rem;"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Selected Services -->
                    <div class="card mb-4 shadow-sm p-3">
                        <div class="card-body">
                            <h5 class="card-title text-primary fw-bold mb-3">🧾 Dịch vụ đã chọn</h5>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="py-2">Loại dịch vụ</th>
                                            <th class="py-2">Tên dịch vụ</th>
                                            <th class="py-2 text-end">Giá</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="d" items="${details}">
                                            <tr>
                                                <td>${d.serviceType}</td>
                                                <td>${d.serviceName}</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${d.price}" type="number" groupingUsed="true"/> VND
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Itinerary -->
                    <div class="mb-4">
                        <h5 class="text-primary fw-bold mb-3">🗓️ Lịch trình mẫu</h5>
                        <div class="accordion" id="itineraryAccordion">

                            <c:set var="currentDay" value="-1" />
                            <c:forEach var="i" items="${itinerary}" varStatus="status">

                                <c:if test="${i.dayNumber != currentDay}">
                                    <c:if test="${currentDay != -1}">
                                    </div> <!-- .accordion-body -->
                                </div> <!-- .accordion-collapse -->
                            </div> <!-- .accordion-item -->
                        </c:if>

                        <div class="accordion-item border-0 shadow-sm mb-3 rounded-3">
                            <h2 class="accordion-header" id="heading${i.dayNumber}">
                                <button class="accordion-button collapsed bg-light fw-semibold" type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse${i.dayNumber}"
                                        aria-expanded="false"
                                        aria-controls="collapse${i.dayNumber}">
                                    🌅 Ngày ${i.dayNumber}
                                </button>
                            </h2>

                            <div id="collapse${i.dayNumber}" class="accordion-collapse collapse"
                                 aria-labelledby="heading${i.dayNumber}">
                                <div class="accordion-body">
                                </c:if>

                                <div class="d-flex mb-2 align-items-start">
                                    <span class="fw-semibold text-secondary me-2">
                                        🕒 ${i.timeOfDay}:
                                    </span>
                                    <div>
                                        <span class="text-primary fw-semibold">${i.activity}</span><br/>
                                        <small></small>
                                    </div>
                                </div>

                                <c:set var="currentDay" value="${i.dayNumber}" />

                                <c:if test="${status.last}">
                                </div> <!-- .accordion-body -->
                            </div> <!-- .accordion-collapse -->
                        </div> <!-- .accordion-item -->
                    </c:if>

                </c:forEach>
            </div>
        </div>




    </div>

    <!-- Right Column: Booking -->
    <div class="col-lg-4">
        <div class="card shadow-sm mb-4 p-3">
            <div class="card-body">
                <h4 class="fw-bold text-primary mb-3">📅 Đặt tour</h4>
                <p class="text-muted small">Hoàn tất thông tin và tiến hành đặt chỗ. Bạn sẽ nhận email xác nhận sau khi thanh toán.</p>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <form action="BookingCustomTourController" method="post">
                            <input type="hidden" name="customTourId" value="${tour.customTourId}">
                            <input type="hidden" name="price" value="${tour.totalPrice}">
                            <input type="hidden" name="startDate" value="${tour.startDate}">

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label">Người lớn</label>
                                    <input type="number" class="form-control" name="adultQty" min="1" value="1" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label">Trẻ em</label>
                                    <input type="number" class="form-control" name="childQty" min="0" value="0" required>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="small text-muted">Tổng giá</div>
                                <div class="fw-bold text-primary">
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${tour.totalPrice}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 fw-bold">
                                <i class="bi bi-check-circle me-2"></i> Đặt Tour Ngay
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning mb-0">
                            Bạn cần <a href="${pageContext.request.contextPath}/views/home/login.jsp" class="fw-bold">đăng nhập</a> để đặt tour.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="card p-3 shadow-sm">
            <div class="card-body small text-muted">
                <p class="mb-1"><strong>Lưu ý:</strong></p>
                <ul class="ps-3 mb-0">
                    <li>Giá hiển thị là tổng ước tính. Giá cuối cùng phụ thuộc vào ngày và số lượng khách.</li>
                    <li>Vui lòng kiểm tra kỹ ngày khởi hành trước khi thanh toán.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Back to Home -->
<div class="text-center mt-4">
    <a href="javascript:history.back()" class="btn btn-outline-primary rounded-pill px-4">
        Quay lại trang trước
    </a>
</div>

</div>

<%@ include file="/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<div id="ftco-loader" class="show fullscreen">
    <svg class="circular" width="48px" height="48px">
    <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/>
    <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/>
    </svg>
</div>
<%@ include file="/views/common/script.jsp" %>

</body>
</html>
