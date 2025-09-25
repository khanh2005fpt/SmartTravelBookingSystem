<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="vi">
    <head>
        <%@ include file="/views/common/css.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <!-- Header -->
        <%@ include file="/views/common/navbar.jsp" %>

        <!-- Main Content -->
        <main class="container py-5">
            <!-- Island Overview -->
            <section class="my-5 p-4 rounded-3 shadow-lg bg-white">
                <div class="row align-items-center g-4">
                    <!-- Island Image -->
                    <div style="height:500px;" class="col-md-6">
                        <img src="${island.imageUrl}" alt="${island.islandName}" 
                             class="img-fluid w-100 h-100 object-fit-cover rounded-3 shadow-sm">
                    </div>


                    <!-- Island Information -->
                    <div class="col-md-6">
                        <h2 class="display-5 fw-bold text-primary mb-3">${island.islandName}</h2>
                        <p class="text-muted mb-4 lead">${island.description}</p>

                        <ul class="list-unstyled mb-4">
                            <li class="mb-3 d-flex align-items-center">
                                <i class="bi bi-geo-alt-fill text-danger me-3 fs-5"></i>
                                <div>
                                    <strong class="d-block text-dark">Quốc gia</strong>
                                    <span class="text-muted">${island.country}</span>
                                </div>
                            </li>
                            <li class="mb-3 d-flex align-items-center">
                                <i class="bi bi-calendar-event-fill text-success me-3 fs-5"></i>
                                <div>
                                    <strong class="d-block text-dark">Mùa đẹp nhất</strong>
                                    <span class="text-muted">Mùa ${island.bestSeason}</span>
                                </div>
                            </li>
                            <li class="mb-3 d-flex align-items-center">
                                <i class="bi bi-activity text-info me-3 fs-5"></i>
                                <div>
                                    <strong class="d-block text-dark">Hoạt động</strong>
                                    <span class="text-muted">${island.activities}</span>
                                </div>
                            </li>
                        </ul>

                        <a href="#toursSection" 
                           class="btn btn-primary btn-lg fw-medium shadow-sm d-inline-flex align-items-center"
                           style="transition: all 0.3s ease;">
                            <i class="bi bi-cart-plus-fill me-2"></i>Đặt tour ngay
                        </a>
                    </div>
                </div>
            </section>

            <!-- Tours Section -->
            <section id="toursSection" class="mb-5">
                <h2 class="h3 mb-4 text-center fw-bold text-primary">🏝️ Các tour du lịch</h2>
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty tours}">
                            <div class="col-12">
                                <div class="alert alert-warning text-center rounded-3 shadow-sm py-4">
                                    <h5 class="mb-1">😥 Hiện chưa có tour nào</h5>
                                    <p class="mb-0">Vui lòng quay lại sau hoặc liên hệ để được tư vấn.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="tour" items="${tours}">
                                <div class="col-sm-6 col-lg-4 mb-4">
                                    <div class="card h-100 border-0 shadow-lg rounded-3 overflow-hidden">
                                        <!-- Ảnh tour -->
                                        <div class="ratio ratio-16x9">


                                            <img src="${pageContext.request.contextPath}/${tour.tourImageUrl}" 
                                                 alt="${tour.tourName}" 
                                                 class="card-img-top object-fit-cover">


                                        </div>

                                        <!-- Nội dung -->
                                        <div class="card-body d-flex flex-column">
                                            <h3 class="h5 card-title fw-semibold text-dark">
                                                ${tour.tourName}
                                            </h3>
                                            <p class="card-text text-muted small mb-3">
                                                ${tour.description}
                                            </p>


                                            <div class="mt-auto">
                                                <p class="text-primary fw-bold fs-5 mb-2 text-end">
                                                    ${tour.price} VNĐ/người
                                                </p>
                                                <a href="TourDetailController?tourid=${tour.tourId}" 
                                                   class="btn btn-primary w-100 rounded-pill">
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>




            <!-- Hotels Section -->
            <section class="mb-5">
                <h2 class="h3 mb-4 text-center text-primary fw-bold border-bottom pb-2">🏨 Khách sạn nổi bật</h2>
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty hotels}">
                            <c:forEach var="hotel" items="${hotels}">
                                <div class="col-md-4">
                                    <div class="card h-100 shadow-lg border-0 rounded-3 overflow-hidden">
                                        <!-- Ảnh khách sạn -->
                                        <div class="position-relative">
                                            <img src="${pageContext.request.contextPath}/${hotel.hotelImageUrl}"
                                                 alt="${hotel.hotelName}" class="card-img-top" style="height: 220px; object-fit: cover;">
                                            <span class="badge bg-success position-absolute top-0 end-0 m-2 px-3 py-2">
                                                ${hotel.roomType}
                                            </span>
                                        </div>

                                        <!-- Nội dung -->
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title fw-bold text-dark">${hotel.hotelName}</h5>


                                            <!-- Phòng trống -->
                                            <p class="mb-1"><strong>Phòng trống:</strong> 
                                                <span class="text-success">${hotel.roomAvailable}</span>
                                            </p>

                                            <!-- Đánh giá -->
                                            <p class="mb-1">
                                                <strong>Đánh giá:</strong>
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="bi ${i <= hotel.rating ? 'bi-star-fill text-warning' : 'bi-star text-muted'}"></i>
                                                </c:forEach>
                                                <span class="text-muted">(${hotel.rating})</span>
                                            </p> 


                                            <!-- Giá -->
                                            <div class="mt-auto">
                                                <p class="text-danger fw-bold fs-5 mb-2 text-end">
                                                    ${hotel.pricePerNight} VNĐ<span class="text-muted fs-6">/đêm</span>
                                                </p>

                                                <!-- Nút đặt phòng -->
                                                <div class="mt-auto">
                                                    <!-- Button đặt phòng -->
                                                    <button class="btn btn-primary w-100 rounded-pill" 
                                                            data-toggle="modal" data-target="#bookingModal${hotel.hotelId}">
                                                        Đặt phòng ngay
                                                    </button>

                                                    <!-- Modal điền thông tin -->
                                                    <div class="modal fade" id="bookingModal${hotel.hotelId}" tabindex="-1" role="dialog" aria-labelledby="bookingModalLabel${hotel.hotelId}" aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered" role="document">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="bookingModalLabel${hotel.hotelId}">Đặt phòng: ${hotel.hotelName}</h5>
                                                                    <button type="button" class="close" data-dismiss="modal" aria-label="Đóng">
                                                                        <span aria-hidden="true">&times;</span>
                                                                    </button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <form action="${pageContext.request.contextPath}/bookRoom" method="post">
                                                                        <input type="hidden" name="hotelId" value="${hotel.hotelId}">
                                                                        <div class="form-group mb-3">
                                                                            <label for="guestName${hotel.hotelId}">Tên khách hàng</label>
                                                                            <input type="text" class="form-control" id="guestName${hotel.hotelId}" name="guestName" required>
                                                                        </div>
                                                                        <div class="form-group mb-3">
                                                                            <label for="guestEmail${hotel.hotelId}">Email</label>
                                                                            <input type="email" class="form-control" id="guestEmail${hotel.hotelId}" name="guestEmail" required>
                                                                        </div>
                                                                        <div class="form-group mb-3">
                                                                            <label for="checkIn${hotel.hotelId}">Ngày nhận phòng</label>
                                                                            <input type="date" class="form-control" id="checkIn${hotel.hotelId}" name="checkIn" required>
                                                                        </div>
                                                                        <div class="form-group mb-3">
                                                                            <label for="checkOut${hotel.hotelId}">Ngày trả phòng</label>
                                                                            <input type="date" class="form-control" id="checkOut${hotel.hotelId}" name="checkOut" required>
                                                                        </div>
                                                                        <div class="form-group mb-3">
                                                                            <label for="roomCount${hotel.hotelId}">Số phòng</label>
                                                                            <input type="number" class="form-control" id="roomCount${hotel.hotelId}" name="roomCount" min="1" max="${hotel.roomAvailable}" required>
                                                                        </div>
                                                                        <button type="submit" class="btn btn-success w-100">Xác nhận đặt phòng</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center text-muted py-5">
                                <i class="bi bi-house-x fs-1 d-block mb-3"></i>
                                Hiện chưa có khách sạn nào cho đảo này.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>



            <!-- Vehicles Section -->
            <section class="mb-5">
                <h2 class="h3 mb-4">Thuê xe trong đảo</h2>
                <div class="row">
                    <!-- Vehicle 1 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="${pageContext.request.contextPath}/views/home/images/vehicles/scooter.jpg" 
                                 alt="Thuê xe máy" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Xe máy</h3>
                                <p class="card-text text-muted">Tự do khám phá đảo với xe máy đời mới, tiết kiệm chi phí.</p>
                                <p class="text-primary fw-bold">150.000 VNĐ/ngày</p>
                                <button class="btn btn-outline-primary w-100">Thuê ngay</button>
                            </div>
                        </div>
                    </div>
                    <!-- Vehicle 2 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="${pageContext.request.contextPath}/views/home/images/vehicles/car.jpg" 
                                 alt="Thuê ô tô" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Ô tô 4-7 chỗ</h3>
                                <p class="card-text text-muted">Phù hợp gia đình/nhóm nhỏ, có lái hoặc tự lái.</p>
                                <p class="text-primary fw-bold">800.000 VNĐ/ngày</p>
                                <button class="btn btn-outline-primary w-100">Thuê ngay</button>
                            </div>
                        </div>
                    </div>
                    <!-- Vehicle 3 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="${pageContext.request.contextPath}/views/home/images/vehicles/bus.jpg" 
                                 alt="Thuê xe bus" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Xe bus du lịch</h3>
                                <p class="card-text text-muted">Xe bus 16-45 chỗ, đưa đón sân bay, tour theo đoàn.</p>
                                <p class="text-primary fw-bold">2.500.000 VNĐ/ngày</p>
                                <button class="btn btn-outline-primary w-100">Thuê ngay</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mb-5">
                <h2 class="h3 mb-4">Dịch vụ khác</h2>
                <div class="row">
                    <!-- Service Card 1 -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow-sm p-3 d-flex align-items-start">
                            <svg class="me-3" width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                            </svg>
                            <div>
                                <h3 class="h5 card-title">Thuê khách sạn</h3>
                                <p class="card-text text-muted">Đặt phòng tại các khách sạn 5 sao hoặc homestay gần biển với giá ưu đãi.</p>
                            </div>
                        </div>
                    </div>
                    <!-- Service Card 2 -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow-sm p-3 d-flex align-items-start">
                            <svg class="me-3" width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                            <div>
                                <h3 class="h5 card-title">Thuê xe du lịch</h3>
                                <p class="card-text text-muted">Cung cấp dịch vụ thuê xe máy, xe hơi hoặc xe buýt đưa đón tận nơi.</p>
                            </div>
                        </div>
                    </div>
                    <!-- Service Card 3 -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow-sm p-3 d-flex align-items-start">
                            <svg class="me-3" width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <div>
                                <h3 class="h5 card-title">Hướng dẫn viên</h3>
                                <p class="card-text text-muted">Hướng dẫn viên chuyên nghiệp, thông thạo nhiều ngôn ngữ, đồng hành cùng bạn.</p>
                            </div>
                        </div>
                    </div>
                    <!-- Service Card 4 -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow-sm p-3 d-flex align-items-start">
                            <svg class="me-3" width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                            </svg>
                            <div>
                                <h3 class="h5 card-title">Vé tham quan</h3>
                                <p class="card-text text-muted">Đặt vé trước cho các điểm tham quan nổi tiếng như Vinpearl Safari, công viên nước.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

        </main>

        <!-- Footer -->
        <%@ include file="/views/common/footer.jsp" %>



        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <%@ include file="/views/common/script.jsp" %>
    </body>
</html>