<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html lang="vi">
    <head>
        <%@ include file="/views/common/css.jsp" %>
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Bootstrap 5 -->

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body>
        <%@ include file="/views/common/navbar.jsp" %>

        <div class="container" style="max-width: 1400px;">
            <div class="row" style="margin-top: 120px">
                <!-- Cột nội dung tour -->
                <div class="col-lg-7">

                    <!-- Card tổng tour -->
                    <div class="card shadow-lg rounded mb-4 border">
                        <div class="card-body bg-light">

                            <!-- Tiêu đề tour -->
                            <h1 class="font-weight-bold mb-3 text-primary ">${tour.tourName}</h1>

                            <!-- Đánh giá -->
                            <div class="d-flex align-items-center mb-4">
                                <span class="badge bg-primary px-3 py-2 text-white">9.4 Tuyệt vời</span>
                                <span class="ml-2 text-muted">(18 đánh giá)</span>
                            </div>

                            <!-- Hình ảnh chính -->
                            <div class="mb-4" style="width:100%; height:500px; overflow:hidden;">
                                <img src="${tour.tourImageUrl}" 
                                     alt="${tour.tourName}" 
                                     class="img-fluid w-100 h-100 rounded shadow-sm border border-primary">
                            </div>

                            <!-- Mô tả tour -->
                            <h4 class="mb-3 border-bottom pb-2 text-primary">Mô tả tour</h4>
                            <p class="text-justify">${tour.description}</p>

                            <!-- Chương trình tour -->
                            <!-- Dịch vụ đi kèm -->
                            <h4 class="mt-4 mb-3 border-bottom pb-2 text-primary">Dịch vụ đi kèm</h4>
                            <div class="row row-cols-1 row-cols-md-2 g-3">
                                <div class="col">
                                    <div class="card h-100 shadow-sm border-0">
                                        <div class="card-body d-flex align-items-center">
                                            <i class="bi bi-bus-front-fill fs-3 text-primary me-3"></i>
                                            <div>
                                                <h6 class="fw-bold mb-1">Xe đưa đón tận nơi</h6>
                                                <p class="text-muted mb-0">Đưa đón sân bay, khách sạn và điểm du lịch bằng xe đời mới.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="card h-100 shadow-sm border-0">
                                        <div class="card-body d-flex align-items-center">
                                            <i class="bi bi-h-square-fill fs-3 text-primary me-3"></i>
                                            <div>
                                                <h6 class="fw-bold mb-1">Khách sạn tiêu chuẩn 3-4 sao</h6>
                                                <p class="text-muted mb-0">Phòng sạch đẹp, tiện nghi, gần trung tâm và các điểm tham quan.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="card h-100 shadow-sm border-0">
                                        <div class="card-body d-flex align-items-center">
                                            <i class="bi bi-emoji-smile-fill fs-3 text-primary me-3"></i>
                                            <div>
                                                <h6 class="fw-bold mb-1">Hướng dẫn viên nhiệt tình</h6>
                                                <p class="text-muted mb-0">HDV chuyên nghiệp, am hiểu địa phương, hỗ trợ suốt hành trình.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="card h-100 shadow-sm border-0">
                                        <div class="card-body d-flex align-items-center">
                                            <i class="bi bi-shield-check fs-3 text-primary me-3"></i>
                                            <div>
                                                <h6 class="fw-bold mb-1">Bảo hiểm du lịch</h6>
                                                <p class="text-muted mb-0">Bảo vệ an toàn cho khách trong suốt chuyến đi.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="card h-100 shadow-sm border-0">
                                        <div class="card-body d-flex align-items-center">
                                            <i class="bi bi-cup-straw fs-3 text-primary me-3"></i>
                                            <div>
                                                <h6 class="fw-bold mb-1">Ẩm thực địa phương</h6>
                                                <p class="text-muted mb-0">Thưởng thức đặc sản vùng biển tươi ngon, hấp dẫn.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="card h-100 shadow-sm border-0">
                                        <div class="card-body d-flex align-items-center">
                                            <i class="bi bi-ticket-perforated-fill fs-3 text-primary me-3"></i>
                                            <div>
                                                <h6 class="fw-bold mb-1">Vé tham quan trọn gói</h6>
                                                <p class="text-muted mb-0">Bao gồm toàn bộ vé vào cổng các địa điểm trong chương trình.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h4 class="mt-4 mb-3 border-bottom pb-2 text-primary">Chương trình tour</h4>
                            <div class="accordion" id="itineraryAccordion">
                                <c:forEach var="iti" items="${itineraries}">
                                    <div class="accordion-item mb-2 shadow-sm rounded">
                                        <h2 class="accordion-header" id="heading${iti.dayNumber}">
                                            <button class="accordion-button collapsed fw-bold text-dark" type="button" 
                                                    data-bs-toggle="collapse" 
                                                    data-bs-target="#collapse${iti.dayNumber}" 
                                                    aria-expanded="false" 
                                                    aria-controls="collapse${iti.dayNumber}">
                                                Ngày ${iti.dayNumber}: ${iti.title}
                                            </button>
                                        </h2>
                                        <div id="collapse${iti.dayNumber}" 
                                             class="accordion-collapse collapse" 
                                             aria-labelledby="heading${iti.dayNumber}" 
                                             data-bs-parent="#accordionExample">

                                            <div class="accordion-body">
                                                <ul class="list-group list-group-flush">
                                                    <c:forEach var="act" items="${iti.activities}">
                                                        <li class="list-group-item">
                                                            <strong>${act.activityOrder}. ${act.activityTitle}</strong><br>
                                                            <small class="text-muted">${act.description}</small>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>

                                        </div>
                                    </div>
                                </c:forEach>

                            </div>


                            <!-- Thông tin cần lưu ý -->
                            <h4 class="mt-4 mb-3 border-bottom pb-2 text-primary">Thông tin cần lưu ý</h4>
                            <ul class="list-group shadow-sm rounded border border-primary">
                                <li class="list-group-item">
                                    <i class="bi bi-airplane-fill text-primary mr-2"></i>
                                    Vận chuyển: Vé máy bay khứ hồi, xe đưa đón, tàu cao tốc/phà ra đảo …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-building text-primary mr-2"></i>
                                    Khách sạn & lưu trú: Tiêu chuẩn 2-4 sao, phụ thu phòng đơn nếu đi lẻ …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-cup-hot text-primary mr-2"></i>
                                    Ăn uống: Bữa ăn theo chương trình, đặc sản địa phương, nước uống …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-people-fill text-primary mr-2"></i>
                                    Hướng dẫn viên & dịch vụ: HDV tiếng Việt/Anh, bảo hiểm, vé tham quan …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-wallet2 text-primary mr-2"></i>
                                    Chi phí không bao gồm: Hành lý ký gửi, ăn uống ngoài chương trình, chi phí cá nhân …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-exclamation-triangle-fill text-primary mr-2"></i>
                                    Điều kiện hủy & thay đổi: Chính sách hoàn/huỷ, phí đổi ngày/đổi tên …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-file-earmark-text-fill text-primary mr-2"></i>
                                    Giấy tờ & thủ tục: CMND/CCCD, hộ chiếu còn hạn, visa (nếu cần) …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-sun-fill text-primary mr-2"></i>
                                    Lưu ý đặc biệt: Ảnh hưởng thời tiết, sức khỏe cho hoạt động biển, trẻ em/người già cần giám hộ …
                                </li>
                            </ul>



                        </div> <!-- /card-body -->
                    </div> <!-- /card -->

                </div> <!-- /col-lg-8 -->



                <!-- Cột sidebar -->
                <div class="col-lg-5">
                    <div class="card shadow-sm p-4">
                        <h3 class="text-primary mb-4">📅 Chọn Ngày Khởi Hành</h3>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="request"/> 
                        </c:if>


                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <form action="BookingController" method="post">
                                    <input type="hidden" name="tourId" value="${tour.tourId}">
                                    <input type="hidden" name="price" value="${tour.price}">

                                    <div class="mb-3">
                                        <label class="form-label">Ngày khởi hành</label>
                                        <input type="date" class="form-control" name="departureDate" required>
                                    </div>

                                    <div class="row">
                                        <div class="col">
                                            <label class="form-label">Người lớn (>15 tuổi)</label>
                                            <input type="number" class="form-control" name="adultQty" min="1" value="1" required>
                                        </div>
                                        <div class="col">
                                            <label class="form-label">Trẻ em (≤15 tuổi)</label>
                                            <input type="number" class="form-control" name="childQty" min="0" value="0" required>
                                        </div>
                                    </div>

                                    <h5 class="mt-4 text-primary">Giá Tour</h5>
                                    <h4 class="text-primary fw-bold mb-3">
                                        <fmt:setLocale value="vi_VN" />
                                        <fmt:formatNumber value="${tour.price}" type="number" groupingUsed="true"/> VNĐ
                                    </h4>

                                    <button type="submit" class="btn btn-primary btn-block fw-bold">
                                        <i class="bi bi-check-circle"></i> Đặt Tour Ngay
                                    </button>
                                </form>
                            </c:when>

                            <c:otherwise>
                                <div class="alert alert-warning">
                                    Bạn cần <a href="${pageContext.request.contextPath}/views/home/login.jsp" class="text-primary fw-bold">đăng nhập</a> để đặt tour.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/views/common/footer.jsp" %>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <%@ include file="/views/common/script.jsp" %>
    </body>
</html>