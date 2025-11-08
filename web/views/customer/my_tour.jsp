    <!DOCTYPE html>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <%
    User currentUser = (User) session.getAttribute("user");

    if (currentUser != null) {
        int roleId = currentUser.getRoleId();

        if (roleId != 1 && roleId != 3) {
            session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
            response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
            return;
        }
    }
    %>
    <html lang="vi">
        <head>
           <%@ include file="/views/common/css.jsp" %>
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

        <body>
            <%@ include file="/views/common/navbar.jsp" %>
            <!-- END nav -->

            <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('${pageContext.request.contextPath}/views/home/images/bg_4.jpg');">
                <div class="overlay"></div>
                <div class="container">
                    <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
                        <div class="col-md-9 ftco-animate pb-5 text-center">
                            <p class="breadcrumbs"><span class="mr-2"><a href="${pageContext.request.contextPath}/SearchIslandController">Trang chủ <i class="fa fa-chevron-right"></i></a></span> <span>Đặt chỗ của tôi<i class="fa fa-chevron-right"></i></span></p>
                            <h1 class="mb-0 bread">Giới thiệu</h1>
                        </div>
                    </div>
                </div>
            </section>

 <!-- MAIN CONTENT -->
    <div class="container py-5" style="max-width: 1800px;">
        <div class="row justify-content-center">

            <!-- LEFT: TOUR DETAILS -->
            <div class="col-lg-6">

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
                        <h5 class="card-title text-primary fw-bold mb-3">Dịch vụ đã chọn</h5>
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

                <!-- Itinerary - Fixed Accordion -->
                <h5 class="text-primary fw-bold mb-3">Lịch trình mẫu</h5>
                <div class="accordion" id="itineraryAccordion">
                    <c:set var="currentDay" value="-1"/>
                    <c:forEach var="i" items="${itinerary}" varStatus="status">
                        <c:if test="${i.dayNumber != currentDay}">
                            <c:if test="${currentDay != -1}">
                                </div></div></div> <!-- body → collapse → item -->
                            </c:if>
                            <div class="accordion-item border-0 shadow-sm mb-3 rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-light fw-semibold" type="button"
                                            data-bs-toggle="collapse" data-bs-target="#collapse${i.dayNumber}">
                                        Ngày ${i.dayNumber}
                                    </button>
                                </h2>
                                <div id="collapse${i.dayNumber}" class="accordion-collapse collapse">
                                    <div class="accordion-body">
                        </c:if>

                        <div class="d-flex mb-2 align-items-start">
                            <span class="fw-semibold text-secondary me-2">${i.timeOfDay}:</span>
                            <div><span class="text-primary fw-semibold">${i.activity}</span></div>
                        </div>

                        <c:set var="currentDay" value="${i.dayNumber}"/>
                        <c:if test="${status.last}">
                                    </div></div></div> <!-- body → collapse → item -->
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <!-- RIGHT: VIDEO + ABOUT -->
     <div class="col-lg-6">
                 <section class="ftco-section ftco-about img"style="background-image: url('${pageContext.request.contextPath}/views/home/images/island_Bg.jpg');">
                <div class="overlay"></div>
                <div class="container py-md-5">
                    <div class="row py-md-5">
                        <div class="col-md d-flex align-items-center justify-content-center">
                           <a href="https://vimeo.com/1103281572" class="icon-video popup-vimeo d-flex align-items-center justify-content-center mb-4">
                        <span class="fa fa-play"></span>
                    </a>

                        </div>
                    </div>
                </div>
            </section>

            <section class="ftco-section ftco-about ftco-no-pt img">
                <div class="container">
                    <div class="row d-flex">
                        <div class="col-md-12 about-intro">
                            <div class="row">
                                <div class="col-md-6 d-flex align-items-stretch">
                                    <div class="img d-flex w-100 align-items-center justify-content-center" style="background-image: url('${pageContext.request.contextPath}/views/home/images/about-1.jpg');">
                                    </div>
                                </div>
                                <div class="col-md-6 pl-md-5 py-5">
                                    <div class="row justify-content-start pb-3">
                                        <div class="col-md-12 heading-section ftco-animate">
                                            <span class="subheading">Về chúng tôi</span>
                                            <h2 class="mb-4">Hãy để chuyến đi của bạn đáng nhớ và an toàn cùng chúng tôi</h2>
                                             <p>IslandBooking là nền tảng du lịch thông minh kết nối hành trình của bạn qua 11 quốc gia Đông Nam Á, từ những bãi biển trong xanh của Việt Nam, hòn đảo huyền thoại ở Indonesia đến nền văn hóa sôi động của Thái Lan,Chúng tôi mang đến cho bạn trải nghiệm đặt tour tiện lợi, an toàn và chân thực nhất</p>
                                            <p><a href="${pageContext.request.contextPath}/SearchIslandController" class="btn btn-primary">Đặt điểm đến của bạn</a></p>
                                          
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        </div>

    </div>

    <%@ include file="/views/common/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Loader -->
    <div id="ftco-loader" class="show fullscreen">
        <svg class="circular" width="48px" height="48px">
            <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/>
            <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/>
        </svg>
    </div>

    <%@ include file="/views/common/script.jsp" %>
        </body>
    </html>