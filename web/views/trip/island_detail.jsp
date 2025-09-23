<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="vi">
    <head>
        <%@ include file="/views/common/css.jsp" %>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <!-- Header -->
        <%@ include file="/views/common/navbar.jsp" %>
        
        <!-- Main Content -->
        <main class="container py-5">
            <!-- Island Overview -->
            <section class="mb-5">
                <div class="row">
                    <div class="col-md-6 mb-4 mb-md-0">
                        <img src="https://via.placeholder.com/600x400" alt="Island Image" class="img-fluid rounded shadow">
                    </div>
                    <div class="col-md-6">
                        <h2 class="h2 mb-4">Đảo Phú Quốc</h2>
                        <p class="text-muted mb-4">
                            Phú Quốc là hòn đảo lớn nhất Việt Nam, nổi tiếng với những bãi biển cát trắng, nước biển trong xanh và những khu rừng nhiệt đới xanh mướt. Đây là điểm đến lý tưởng cho những ai yêu thích thiên nhiên và muốn trải nghiệm văn hóa địa phương.
                        </p>
                        <div class="d-flex align-items-center mb-4">
                            <span class="text-warning">★★★★★</span>
                            <span class="ms-2 text-muted">(4.8/5 từ 1200 đánh giá)</span>
                        </div>
                        <button class="btn btn-primary px-4">Đặt tour ngay</button>
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