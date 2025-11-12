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
        <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('${pageContext.request.contextPath}/views/home/images/island_Bg.jpg');">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
                    <div class="col-md-9 ftco-animate pb-5 text-center">
                        <p class="breadcrumbs"><span class="mr-2"><a href="SearchIslandController">Trang chủ <i class="fa fa-chevron-right"></i></a></span> <span>Khách sạn <i class="fa fa-chevron-right"></i></span></p>
                        <h1 class="mb-0 bread">Chi tiết tour</h1>
                    </div>
                </div>
            </div>
        </section>
        <div class="container" style="max-width: 1600px;">
            <div class="row" style="margin-top: 120px">
                <!-- Cột nội dung tour -->
                <div class="col-lg-8">

                    <!-- Card tổng tour -->
                    <div class="card shadow-lg rounded mb-4 border">
                        <div class="card-body bg-light">

                            <!-- Tiêu đề tour -->
                            <h1 class="font-weight-bold mb-3 text-primary ">${tour.tourName}</h1>


                            <!-- Hình ảnh chính -->
                            <div class="mb-4" style="width:100%; height:500px; overflow:hidden;">
                                <img src="${tour.tourImageUrl}" 
                                     alt="${tour.tourName}" 
                                     class="img-fluid w-100 h-100 rounded shadow-sm border border-primary">
                            </div>
                            <!-- Mô tả tour -->
                            <h4 class="mb-3 fw-bold border-bottom pb-2 text-primary">Mô tả tour</h4>
                            <p class="text-justify">${tour.description}</p>

                            <!-- Chương trình tour -->
                            <h4 class="mt-4 mb-3 fw-bold border-bottom pb-2 text-primary">Chương trình tour</h4>
                            <div class="accordion" id="itineraryAccordion">
                                <c:forEach var="iti" items="${itineraries}">
                                    <div class="accordion-item mb-2 shadow-sm rounded">
                                        <h2 class="accordion-header" id="heading${iti.dayNumber}">
                                            <button class="accordion-button collapsed fw-bold text-dark" type="button" 
                                                    data-bs-toggle="collapse" 
                                                    data-bs-target="#collapse${iti.dayNumber}" 
                                                    aria-expanded="false" 
                                                    aria-controls="collapse${iti.dayNumber}">
                                                🌅 Ngày ${iti.dayNumber}: ${iti.title}
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



                        </div> <!-- /card-body -->
                    </div> <!-- /card -->

                </div> <!-- /col-lg-8 -->



                <!-- Cột sidebar -->
                <div class="col-lg-4">

                    <div class="card shadow-sm p-4">

                        <h4 class="fw-bold text-primary mb-3">📅 Chọn Ngày Khởi Hành</h4>
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
                                    <!-- Gửi giá gốc về Controller -->


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

                                    <!-- Tính giá sau khi giảm -->
                                    <c:set var="discountedPrice" value="${tour.price}" />

                                    <c:choose>
                                        <c:when test="${sessionScope.profile_customer.membershipLevel == 'BRONZE'}">
                                            <c:set var="discountedPrice" value="${tour.price}" />
                                        </c:when>
                                        <c:when test="${sessionScope.profile_customer.membershipLevel == 'SILVER'}">
                                            <c:set var="discountedPrice" value="${tour.price * 0.90}" />
                                        </c:when>
                                        <c:when test="${sessionScope.profile_customer.membershipLevel == 'GOLD'}">
                                            <c:set var="discountedPrice" value="${tour.price * 0.85}" />
                                        </c:when>
                                        <c:when test="${sessionScope.profile_customer.membershipLevel == 'PLATINUM'}">
                                            <c:set var="discountedPrice" value="${tour.price * 0.80}" />
                                        </c:when>
                                    </c:choose>

                                    <!-- ===== HIỂN THỊ GIÁ TOUR ===== -->
                                    <h5 class="mt-4 text-primary">Giá Tour</h5>
                                    <h4 class="text-primary fw-bold mb-3">
                                        <fmt:setLocale value="vi_VN" />

                                        <!-- Nếu có giảm giá thì hiển thị 2 dòng (lt: "<")-->
                                        <c:if test="${discountedPrice lt tour.price}"> 
                                            <span style="text-decoration: line-through; color: #888; font-size: 20px" >
                                                <fmt:formatNumber value="${tour.price}" type="number" groupingUsed="true"/> VNĐ
                                            </span><br>
                                            <span style="color: #d97706; font-weight: bold;">
                                                <fmt:formatNumber value="${discountedPrice}" type="number" groupingUsed="true"/> VNĐ
                                            </span>
                                            <small style="color: #d97706;">(Ưu đãi hạng ${sessionScope.profile_customer.membershipLevel})</small>
                                        </c:if>

                                        <!-- Nếu không có giảm giá -->
                                        <c:if test="${discountedPrice eq tour.price}">
                                            <fmt:formatNumber value="${tour.price}" type="number" groupingUsed="true"/> VNĐ
                                        </c:if>
                                    </h4>
                                    <input type="hidden" name="discountedPrice" value="${discountedPrice}">

                                    <button type="submit" class="btn btn-primary btn-block fw-bold">
                                        <i class="bi bi-check-circle"></i> Đặt Tour Ngay
                                    </button>
                                </form>
                            </c:when>


                            <c:otherwise>
                                <div class="alert alert-warning">
                                    Bạn cần 
                                    <c:url var="loginURL" value="/views/account/login.jsp">
                                        <c:param name="redirect" value="${pageContext.request.contextPath}/TourDetailController?tourid=${tourId}" />
                                    </c:url>
                                    <a href="${loginURL}" class="text-primary fw-bold">đăng nhập</a> để đặt tour.
                                </div>
                            </c:otherwise>



                        </c:choose>
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
            <div class="text-center mt-4 mb-4">
                <a href="javascript:history.back()" class="btn btn-outline-primary rounded-pill px-4">
                    Quay lại trang trước
                </a>
            </div>
        </div>

        <%@ include file="/views/common/footer.jsp" %>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <%@ include file="/views/common/script.jsp" %>
    </body>
</html>
