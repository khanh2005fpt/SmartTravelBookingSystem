<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
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

        <div class="container py-5">
            <div class="row g-4">
                <!-- Cột nội dung tour -->
                <div class="col-lg-8">

                    <!-- Card tổng tour -->
                    <div class="card shadow-lg rounded mb-4 border-primary">
                        <div class="card-body bg-light">

                            <!-- Tiêu đề tour -->
                            <h1 class="font-weight-bold mb-3 text-primary ">${tour.tourName}</h1>

                            <!-- Đánh giá -->
                            <div class="d-flex align-items-center mb-4">
                                <span class="badge bg-primary px-3 py-2 text-white">9.4 Tuyệt vời</span>
                                <span class="ml-2 text-muted">(18 đánh giá)</span>
                            </div>

                            <!-- Hình ảnh chính -->
                            <div class="mb-4">
                                <img src="${tour.tourImageUrl}" 
                                     alt="${tour.tourName}" 
                                     class="img-fluid w-100 rounded shadow-sm border border-primary">
                            </div>

                            <!-- Mô tả tour -->
                            <h4 class="mb-3 border-bottom pb-2 text-primary">Mô tả tour</h4>
                            <p class="text-justify">${tour.description}</p>

                            <!-- Chương trình tour -->
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
                                             >
                                            <div class="accordion-body">
                                                ${iti.description}
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
                                    Vận chuyển: Vé máy bay khứ hồi, xe đưa đón tham quan theo chương trình …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-building text-primary mr-2"></i>
                                    Khách sạn: tiêu chuẩn 3-4 sao địa phương …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-cup-hot text-primary mr-2"></i>
                                    Bữa ăn theo chương trình, hướng dẫn viên tiếng Việt …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-wallet2 text-primary mr-2"></i>
                                    Phụ thu phòng đơn, hành lý gửi, chi phí phát sinh …
                                </li>
                                <li class="list-group-item">
                                    <i class="bi bi-exclamation-triangle-fill text-primary mr-2"></i>
                                    Điều kiện hủy, thay đổi …
                                </li>
                            </ul>


                        </div> <!-- /card-body -->
                    </div> <!-- /card -->

                </div> <!-- /col-lg-8 -->



                <!-- Cột sidebar -->
                <div class="col-lg-4">
                    <div class="card shadow">
                        <div class="card-body bg-light">
                            <h5 class="mb-3 text-primary">Giá Tour</h5>
                            <h4 class="text-primary font-weight-bold">${tour.price} VNĐ</h4>

                            <form>
                                <div class="form-group mb-3">
                                    <label for="departureDate">Ngày khởi hành</label>
                                    <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                                </div>
                                <div class="form-group mb-3">
                                    <label for="adult">Người lớn (> 9 tuổi)</label>
                                    <input type="number" class="form-control" id="adult" value="2" min="1">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="child">Trẻ em (2-9 tuổi)</label>
                                    <input type="number" class="form-control" id="child" value="0" min="0">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="infant">Trẻ nhỏ (< 2 tuổi)</label>
                                    <input type="number" class="form-control" id="infant" value="0" min="0">
                                </div>
                                <button type="submit" class="btn btn-primary btn-block font-weight-bold">Yêu cầu đặt</button>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="/views/common/footer.jsp" %>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
