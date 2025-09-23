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
                    <div class="col-md-6">
                        <div class="position-relative overflow-hidden rounded-3 shadow-sm">
                            <img src="${island.imageUrl}" alt="${island.islandName}" class="img-fluid w-100 object-fit-cover"
                                 style="transition: transform 0.4s ease-in-out; height: 300px;">
                            <div class="position-absolute top-0 start-0 w-100 h-100" 
                                 style="background: linear-gradient(to bottom, rgba(0,0,0,0.1), rgba(0,0,0,0.3)); transition: opacity 0.3s;"
                                 onmouseover="this.style.opacity = '0.8'" onmouseout="this.style.opacity = '1'"></div>
                        </div>
                    </div>

                    <!-- Island Information -->
                    <div class="col-md-6">
                        <h2 class="display-5 fw-bold text-primary mb-3">${island.islandName}</h2>
                        <p class="text-muted mb-4 lead" style="line-height: 1.6;">${island.description}</p>

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
                                    <span class="text-muted">${island.bestSeason}</span>
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

                        <a href="BookingServlet?islandId=${island.islandId}" 
                           class="btn btn-primary btn-lg fw-medium shadow-sm d-inline-flex align-items-center"
                           style="transition: all 0.3s ease;">
                            <i class="bi bi-cart-plus-fill me-2"></i>Đặt tour ngay
                        </a>
                    </div>
                </div>
            </section>

            <!-- Tours Section -->
            <section class="mb-5">
                <h2 class="h3 mb-4">Các tour du lịch</h2>
                <div class="row">
                    <!-- Tour Card 1 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="https://via.placeholder.com/300x200" alt="Tour Image" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Tour khám phá 4 đảo</h3>
                                <p class="card-text text-muted">Trải nghiệm lặn ngắm san hô, câu cá và thưởng thức hải sản tươi ngon tại 4 hòn đảo đẹp nhất Phú Quốc.</p>
                                <p class="text-primary fw-bold">2.500.000 VNĐ/người</p>
                                <button class="btn btn-primary w-100">Xem chi tiết</button>
                            </div>
                        </div>
                    </div>
                    <!-- Tour Card 2 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="https://via.placeholder.com/300x200" alt="Tour Image" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Tour Sunset Vinpearl</h3>
                                <p class="card-text text-muted">Ngắm hoàng hôn tuyệt đẹp tại Vinpearl, kết hợp tham quan công viên chủ đề và ẩm thực cao cấp.</p>
                                <p class="text-primary fw-bold">1.800.000 VNĐ/người</p>
                                <button class="btn btn-primary w-100">Xem chi tiết</button>
                            </div>
                        </div>
                    </div>
                    <!-- Tour Card 3 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="https://via.placeholder.com/300x200" alt="Tour Image" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Tour làng chài Rạch Vẹm</h3>
                                <p class="card-text text-muted">Khám phá cuộc sống làng chài, thưởng thức hải sản tươi sống và chèo thuyền kayak.</p>
                                <p class="text-primary fw-bold">1.200.000 VNĐ/người</p>
                                <button class="btn btn-primary w-100">Xem chi tiết</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Services Section -->

            <!-- Hotels Section -->
            <section class="mb-5">
                <h2 class="h3 mb-4">Khách sạn nổi bật</h2>
                <div class="row">
                    <!-- Hotel 1 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="web/views/home/images/hotels/vinpearl_pq_main.jpg" 
                                 alt="Vinpearl Resort Phu Quoc" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Vinpearl Resort Phú Quốc</h3>
                                <p class="card-text text-muted">Khu nghỉ dưỡng 5 sao với hồ bơi lớn, bãi biển riêng và tiện nghi cao cấp.</p>
                                <p class="text-primary fw-bold">Giá từ 3.000.000 VNĐ/đêm</p>
                                <button class="btn btn-outline-primary w-100">Đặt phòng</button>
                            </div>
                        </div>
                    </div>
                    <!-- Hotel 2 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="web/views/home/images/hotels/salinda_pq.jpg" 
                                 alt="Salinda Resort" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Salinda Resort</h3>
                                <p class="card-text text-muted">Resort boutique nổi tiếng với phong cách sang trọng và ẩm thực tinh tế.</p>
                                <p class="text-primary fw-bold">Giá từ 2.500.000 VNĐ/đêm</p>
                                <button class="btn btn-outline-primary w-100">Đặt phòng</button>
                            </div>
                        </div>
                    </div>
                    <!-- Hotel 3 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="web/views/home/images/hotels/mango_bay.jpg" 
                                 alt="Mango Bay Resort" class="card-img-top">
                            <div class="card-body">
                                <h3 class="h5 card-title">Mango Bay Resort</h3>
                                <p class="card-text text-muted">Không gian gần gũi thiên nhiên, bungalow gỗ hướng biển lãng mạn.</p>
                                <p class="text-primary fw-bold">Giá từ 1.800.000 VNĐ/đêm</p>
                                <button class="btn btn-outline-primary w-100">Đặt phòng</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Vehicles Section -->
            <section class="mb-5">
                <h2 class="h3 mb-4">Thuê xe du lịch</h2>
                <div class="row">
                    <!-- Vehicle 1 -->
                    <div class="col-md-4 mb-4">
                        <div class="card shadow-sm">
                            <img src="web/views/home/images/vehicles/scooter.jpg" 
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
                            <img src="web/views/home/images/vehicles/car.jpg" 
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
                            <img src="web/views/home/images/vehicles/bus.jpg" 
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