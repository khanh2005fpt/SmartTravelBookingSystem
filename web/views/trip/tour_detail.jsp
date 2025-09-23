<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
            <%@ include file="/views/common/css.jsp" %>

    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Một số style custom để giống giao diện iVIVU */
        .badge-rating { font-size: 1rem; }
        .price-old { text-decoration: line-through; color: #6c757d; }
        .price-current { color: #dc3545; font-size: 1.5rem; font-weight: bold; }
        .feature-list i { margin-right: 8px; color: #007bff; }
        .itinerary-day { margin-bottom: 1.5rem; }
        .itinerary-day h5 { font-weight: bold; }
        .section-title { margin-top: 2rem; margin-bottom: 1rem; font-weight: bold; font-size: 1.25rem; }
    </style>
</head>
<body class="bg-light">

 <%@ include file="/views/common/navbar.jsp" %>

<div class="container mt-4 mb-5">
    <div class="row">
        <div class="col-lg-8">
            <!-- Tiêu đề & đánh giá -->
            <h1 class="fw-bold">Tour Singapore - Malaysia 4N3Đ: Sentosa - Genting - Động Batu - Tháp Đôi Petronas</h1>
            <div class="d-flex align-items-center mb-3">
                <span class="badge bg-success badge-rating">9.4 Tuyệt vời</span>
                <span class="ms-2">(18 đánh giá)</span>
            </div>

            <!-- Hình ảnh / slider -->
            <div id="tourCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="path_to_image1.jpg" class="d-block w-100 rounded" alt="ảnh 1">
                    </div>
                    <div class="carousel-item">
                        <img src="path_to_image2.jpg" class="d-block w-100 rounded" alt="ảnh 2">
                    </div>
                    <div class="carousel-item">
                        <img src="path_to_image3.jpg" class="d-block w-100 rounded" alt="ảnh 3">
                    </div>
                    <!-- Thêm ảnh nếu có -->
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#tourCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                    <span class="visually-hidden">Trước</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#tourCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                    <span class="visually-hidden">Tiếp</span>
                </button>
            </div>

            <!-- Mô tả ngắn / thông tin tour -->
            <div class="section-title">Tour Trọn Gói bao gồm</div>
            <ul class="list-unstyled feature-list">
                <li><i class="fas fa-plane"></i> Vé máy bay khứ hồi</li>
                <li><i class="fas fa-hotel"></i> Khách sạn 3-4 sao</li>
                <li><i class="fas fa-utensils"></i> Bữa ăn theo chương trình</li>
                <li><i class="fas fa-bus"></i> Xe đưa đón & tham quan</li>
                <li><i class="fas fa-map-marker-alt"></i> Vé tham quan các điểm</li>
                <li><i class="fas fa-user-friends"></i> HDV đồng hành</li>
                <li><i class="fas fa-shield-alt"></i> Bảo hiểm du lịch quốc tế</li>
            </ul>

            <!-- Chương trình tour -->
            <div class="section-title">Chương trình tour</div>
            <div class="itinerary-day">
                <h5>Ngày 1: HCM &rarr; Singapore (Ăn Trưa, Tối)</h5>
                <p>Trưởng đoàn đón quý khách tại cột số 10, cổng D2 sân bay Tân Sơn Nhất, làm thủ tục chuyến bay đi Singapore. … (nội dung chi tiết …)</p>
            </div>
            <div class="itinerary-day">
                <h5>Ngày 2: Singapore &rarr; Kuala Lumpur (Ăn Sáng, Trưa, Tối)</h5>
                <p>Gardens by the Bay …</p>
            </div>
            <div class="itinerary-day">
                <h5>Ngày 3: Kuala Lumpur – Cao Nguyên Genting (Ăn Sáng, Trưa)</h5>
                <p>Quảng trường Độc Lập …</p>
            </div>
            <div class="itinerary-day">
                <h5>Ngày 4: Kuala Lumpur – HCM (Ăn Sáng)</h5>
                <p>Trả phòng khách sạn, tham quan mua sắm, sau đó ra sân bay về Việt Nam.</p>
            </div>

            <!-- Thông tin cần lưu ý -->
            <div class="section-title">Thông tin cần lưu ý</div>
            <ul>
                <li>Vận chuyển: Vé máy bay khứ hồi, xe đưa đón tham quan theo chương trình …</li>
                <li>Khách sạn: tiêu chuẩn 3-4 sao địa phương …</li>
                <li>Bữa ăn theo chương trình, hướng dẫn viên tiếng Việt …</li>
                <li>Phụ thu phòng đơn, hành lý gửi, chi phí phát sinh …</li>
                <li>Điều kiện hủy, thay đổi …</li>
            </ul>

        </div>  <!-- col-lg-8 -->

        <div class="col-lg-4">
            <div class="card shadow">
                <div class="card-body">
                    <div class="section-title">Lịch khởi hành & Giá Tour</div>
                    <form>
                        <div class="mb-3">
                            <label class="form-label">Ngày khởi hành</label>
                            <select class="form-select">
                                <option value="">Tất cả</option>
                                <option value="2025-10-26">26/10/2025</option>
                                <option value="2025-11-23">23/11/2025</option>
                                <option value="2025-12-06">06/12/2025</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Người lớn (> 9 tuổi)</label>
                            <input type="number" class="form-control" value="2" min="1">
                            <small class="text-muted">Giá: 8.990.000 đ/người</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Trẻ em (2-9 tuổi)</label>
                            <input type="number" class="form-control" value="0" min="0">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Trẻ nhỏ (< 2 tuổi)</label>
                            <input type="number" class="form-control" value="0" min="0">
                        </div>

                        <hr>
                        <p class="price-old">21.980.000 đ</p>
                        <p class="price-current">17.980.000 đ</p>

                        <button type="submit" class="btn btn-warning w-100 fw-bold">Yêu cầu đặt</button>
                    </form>
                </div>
            </div>
        </div>  <!-- col-lg-4 -->
    </div>
</div>

  <%@ include file="/views/common/footer.jsp" %>



        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <%@ include file="/views/common/script.jsp" %>
</body>
</html>
