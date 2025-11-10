<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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
                        <p class="breadcrumbs fw-bold" style="font-size: 20px;"><span class="mr-2"><a href="${pageContext.request.contextPath}/SearchIslandController">Trang chủ <i class="fa fa-chevron-right"></i></a></span> <span class="small">Đặt chỗ của tôi<i class="fa fa-chevron-right"></i></span></p>

                    </div>
                </div>
            </div>
        </section>

        <!-- MAIN CONTENT -->
        <div class="container py-5" style="max-width: 1800px;">
            <div class="row justify-content-center">
                <div class="col-md-9 ftco-animate  text-center">

                    <h1 class="mb-0 bread">Hành trình gần đây – mỗi điểm đến là một câu chuyện</h1>
                </div>

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
                                    <span class="badge bg-primary text-white ms-2 price-badge">
                                        <fmt:formatNumber value="${tour.totalPrice + 0}" type="number" groupingUsed="true"/> VND


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
                    <h5 class="text-primary fw-bold mb-3"> <i class="bi bi-calendar-week me-2"></i> Lịch trình chuyến tour</h5>
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
                                <span class="fw-bold text-secondary me-2"><i class="bi bi-geo-alt-fill text-danger me-2"></i>${i.timeOfDay}:</span>
                                <div><span class="text-primary " style="font-size: 15px;">${i.activity}</span></div>
                            </div>

                            <c:set var="currentDay" value="${i.dayNumber}"/>
                            <c:if test="${status.last}">
                            </div></div></div> <!-- body → collapse → item -->
                        </c:if>
                    </c:forEach>

            <!-- Flight Schedule after booking -->
               <h5 class="text-primary fw-bold mb-3 mt-3"> <i class="bi bi-airplane-fill me-2"></i> Lịch trình chuyến bay</h5>
            <div class="row mb-2">
                <!-- Chuyến đi -->
                <c:choose>
                    <c:when test="${not empty flightSchedules}">
                        <div class="col-lg-12 col-md-6 col-sm-6">
                            <div class="card shadow-sm border-0 rounded-3 flight-card h-100">
                                <div class="card-body p-2 ">
                                    <div class="card-header d-flex flex-column align-items-center"
                                         style="background: linear-gradient(135deg, #2196f3, #1976d2);
                                         color: #ffffff;
                                         border: none;
                                         border-radius: 10px;
                                         padding: 16px 16px;
                                         max-height: 100%;">
                                        <h6 class="fw-bold mb-1" style="font-size: 20px;">
                                            ${flightSchedules.flight.flightNumber} - ${flightSchedules.planeModel}
                                        </h6>
                                        <p class="small mb-0" style="opacity: 0.8;">
                                            ${flightSchedules.departureAirport} → ${flightSchedules.arrivalAirport}
                                        </p>
                                    </div>
                                    <!-- Giờ khởi hành -->
                                    <div class="row text-center border-top border-bottom py-2 my-2">
                                        <div class="col-5">
                                            <h6 class="fw-bold mb-0" style="color: #1976d2;">${flightSchedules.departureTime}</h6>
                                            <small>${flightSchedules.departureAirport}</small>
                                        </div>
                                        <div class="col-2 d-flex align-items-center justify-content-center">
                                            <i class="fa fa-plane" style="color: #1976d2;"></i>
                                        </div>
                                        <div class="col-5">
                                            <h6 class="fw-bold mb-0" style="color: #1976d2;">${flightSchedules.arrivalTime}</h6>
                                            <small>${flightSchedules.arrivalAirport}</small>
                                        </div>
                                    </div>
                                    <!-- Chiều về -->
                                    <c:if test="${not empty flightSchedules.returnDepartureTime}">
                                        <div class="row text-center border-top border-bottom py-2 my-2 bg-light rounded-3">
                                            <div class="col-5">
                                                <h6 class="text-secondary fw-bold mb-0">${flightSchedules.returnDepartureTime}</h6>
                                                <small>${flightSchedules.arrivalAirport}</small>
                                            </div>
                                            <div class="col-2 d-flex align-items-center justify-content-center">
                                                <i class="fa fa-plane text-secondary" style="transform: rotate(180deg);"></i>
                                            </div>
                                            <div class="col-5">
                                                <h6 class="text-secondary fw-bold mb-0">${flightSchedules.returnArrivalTime}</h6>
                                                <small>${flightSchedules.departureAirport}</small>
                                            </div>
                                        </div>
                                    </c:if>
                                    <!-- Transit -->
                                    <c:if test="${not empty flightSchedules.transitAirport}">
                                        <p class="small mb-2">
                                            <i class="bi bi-clock-history me-1" style="color: #1976d2; font-size: 1.1rem;"></i>
                                            Trung chuyển tại: <strong>${flightSchedules.transitAirport}</strong> - <strong>(${flightSchedules.transitDuration})</strong>
                                        </p>
                                    </c:if>
                                    <!-- Notes -->
                                    <c:if test="${not empty flightSchedules.cabinBaggage}">
                                        <p class="small fst-italic mb-3">
                                            <i class="bi bi-suitcase me-1" style="color: #1976d2; font-size: 1.05rem;"></i>
                                            Hành lý xách tay cho phép : <strong>${flightSchedules.cabinBaggage}</strong> - <strong>${flightSchedules.flight.flightClass}</strong>
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty flightSchedules.seatCapacity}">
                                        <p class="small fst-italic mb-3">
                                            <i class="bi bi-person-lines-fill me-1" style="color: #1976d2; font-size: 1.05rem;"></i>
                                            Sức chứa : <strong>${flightSchedules.seatCapacity} ghế </strong>
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty flightSchedules.notes}">
                                        <p class="small fst-italic mb-3">
                                            <i class="bi bi-chat-left-text me-1" style="color: #1976d2; font-size: 1.05rem;"></i>
                                            ${flightSchedules.notes}
                                        </p>
                                    </c:if>
                                    <hr class="my-3" style="border-top: 1px solid #ddd;">
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state d-flex flex-column align-content-center align-items-center">
                            <i class="fa fa-map-marker"></i>
                            <h3>Không có lịch trình máy bay nào</h3>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>


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