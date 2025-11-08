<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html lang="vi">
    <head>

        <%@ include file="/views/common/css.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <body>
        <!-- Header -->
        <%@ include file="/views/common/navbar.jsp" %>
        <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('${pageContext.request.contextPath}/views/home/images/island_Bg.jpg');">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
                    <div class="col-md-9 ftco-animate pb-5 text-center">
                        <h1 class="mb-0 bread">Chi tiết đảo</h1>
                    </div>
                </div>
            </div>
        </section>
        <!-- Main Content -->
        <main class="container" style="max-width: 1400px;">
            <!-- Island Overview -->
            <div class="row" style="margin-top: 90px">
                <section class="my-5 p-4 rounded-3 shadow-lg bg-white" >
                    <div class="row align-items-center g-4">
                        <!-- Island Image -->
                        <div style="height:500px;" class="col-md-6">
                            <img src="${island.imageUrl}" alt="${island.islandName}" 
                                 class="img-fluid w-100 h-100 object-fit-cover rounded-3 shadow-sm">
                        </div>


                        <!-- Island Information -->
                        <div class="col-md-6">
                            <h2 class="display-5 fw-bold text-primary mb-3">${island.islandName}</h2>
                            <p class="text-muted mb-4 lead">${island.longDescription}</p>

                            <ul class="list-unstyled mb-4">
                                <li class="mb-3 d-flex align-items-center">
                                    <i class="bi bi-geo-alt-fill text-danger me-3 fs-5"></i>
                                    <div>
                                        <strong class="d-block text-dark">Vị trí</strong>
                                        <span class="text-muted">${island.location}</span>
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
                                <i class="bi bi-cart-plus-fill me-2"></i>Khám phá tours
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Tours Section -->
                <section id="toursSection" class="mb-5">
                    <h2 class="h2 mb-4 text-center fw-bold text-primary">🏝️ Các tour du lịch</h2>
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
                                                    <div class="d-flex justify-content-between mt-3">
                                                        <p class="mb-2" style="margin-left: 2px;">

                                                            <i class="bi bi-heart heart" data-tour-id="${tour.tourId}" style="font-size:1.4rem;"></i>
                                                        </p>
                                                        <p class="text-primary fw-bold fs-5 mb-2 text-end">
                                                            Giá tour: 
                                                            <fmt:setLocale value="vi_VN" />

                                                            <fmt:formatNumber value="${tour.price}" type="number" groupingUsed="true"/> VND
                                                        </p>
                                                    </div>
                                                    <form action="TourDetailController" method="post" class="search-property-1">
                                                        <button type="submit" class="btn btn-primary w-100 rounded-pill" name="tourid" value="${tour.tourId}">Xem chi tiết</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <!-- Tour riêng le Section -->
                <form action="CreateCustomTourController" method="post" id="customTourForm">
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger text-center fw-semibold rounded-pill py-2 shadow-sm mb-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.errorMessage}
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <input type="hidden" name="islandId" value="${island.islandId}">
                    <input type="hidden" name="flightType" value="${flightType}">
                    <h2 class="h2 mb-4 text-center fw-bold text-primary">🏝️ Tour du lịch riêng lẻ</h2>
                    <div class="alert alert-info text-center fw-semibold rounded-pill py-2 shadow-sm">
                        🔹 Khách hàng có thể chọn nhiều dịch vụ cùng lúc để đặt trong một tour.
                    </div>

                    <!------- Flights Section -------------------------------------------------------------->

                    <section id="flightSection"class="mb-5"  >
                        <h2 class="h2 text-center text-primary fw-bold mb-5">
                            Chuyến bay du lịch  
                        </h2>

                        <!-- NGÀY BẮT ĐẦU & KẾT THÚC -->
                        <div class="d-flex justify-content-center gap-4 mb-3 mt-3 flex-wrap">
                            <div class="text-center">

                                <div class="input-group " style="max-width: 180px;">
                                    <div>
                                        <label for="startDateFlight" class="form-label fw-semibold">Ngày khởi hành</label>
                                        <input type="date" class="form-control rounded-pill text-center"
                                               id="startDateFlight" name="startDateFlight"
                                               value="${param.startDateFlight}">                                    
                                    </div>
                                </div>
                            </div>
                            <div class="text-center">

                                <div class="input-group" style="max-width: 180px;">
                                    <div>
                                        <label for="endDateFlight" class="form-label fw-semibold">Ngày trở về</label>
                                        <input type="date" class="form-control rounded-pill text-center"
                                               id="endDateFlight" name="endDateFlight"
                                               value="${param.endDateFlight}">                                   
                                    </div>
                                </div>
                            </div>
                        </div>


                        <small class="text-danger d-block text-center mb-4">
                            <strong>Chú ý! :</strong> Nếu chọn ngày khởi hành không trùng với ngày bắt đầu của gói Tour , hệ thống sẽ tự động chọn ngày khởi hành theo ngày bắt đầu Tour.
                        </small>

                        <!-- CAM KẾT -->
                        <div class="mt-3 p-4 bg-light rounded-4 shadow-sm mx-auto"id="commitSection" style="max-width: 600px;">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="commitFlight" style="width: 1.4em; height: 1.4em; margin-top: 0.4em;">
                                <label class="form-check-label fw-semibold text-dark" for="commitFlight">
                                    <span class="text-primary">Tôi cam kết:</span> 
                                    Chuyến bay <u>khởi hành phải trùng với ngày bắt đầu tour</u>.<br>
                                    <small class="text-muted">Hệ thống sẽ chỉ hiển thị chuyến bay phù hợp khi bạn xác nhận.</small>
                                </label>
                            </div>
                        </div>



                        <!-- CHỌN LOẠI CHUYẾN -->
                        <div class="card shadow rounded-4 mb-4 ">
                            <div class="card-body p-4 text-center">
                                <div class="d-flex gap-2  btn-group w-100 w-md-auto " role="group">
                                    <a href="${pageContext.request.contextPath}/FlightSearchController?islandId=<c:out value='${island.islandId}'/>&flightType=motchieu"
                                       class="btn btn-primary rounded-pill px-4 py-3 " id="oneWayLink">
                                        <i class="bi bi-arrow-right-circle-fill me-1 "></i> Một chiều
                                    </a>
                                    <a href="${pageContext.request.contextPath}/FlightSearchController?islandId=<c:out value='${island.islandId}'/>&flightType=khuhoi"
                                       class="btn btn-outline-primary rounded-pill px-4 py-3 " id="roundTripLink">
                                        <i class="bi bi-arrow-repeat me-1"></i> Khứ hồi</strong>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <script>
                            document.querySelectorAll('#flightTypeButtons .btn').forEach(btn => {
                                btn.addEventListener('click', () => {
                                    document.querySelectorAll('#flightTypeButtons .btn').forEach(b => b.classList.remove('btn-primary', 'active'));
                                    btn.classList.add('btn-primary', 'active');
                                });
                            });
                        </script>



                        <!-- DANH SÁCH CHUYẾN BAY -->
                        <div class="flight-scroll-container row">
                            <c:choose>
                                <c:when test="${not empty flights}">
                                    <c:forEach var="f" items="${flights}">

                                        <div class="col-lg-4 col-md-6 mb-4 flight-item">
                                            <div class="card flight-card h-100 shadow-lg border-0 rounded-3 overflow-hidden"
                                                 data-flightId="${f.flightId}">

                                                <!-- Ảnh + Logo -->
                                                <div class="position-relative flight-card">
                                                    <img src="${pageContext.request.contextPath}/${f.destinationImageUrl}"
                                                         alt="${f.flightNumber}"
                                                         class="card-img-top"
                                                         style="height:220px; object-fit:cover; border-radius:10px;">
                                                    <div class="airline-logo-wrapper">
                                                        <img src="${pageContext.request.contextPath}/${f.airline.logoUrl}"
                                                             alt="${f.airline.airlineName}"
                                                             class="airline-logo">
                                                    </div>
                                                </div>

                                                <div class="card-body d-flex flex-column">
                                                    <div class="mb-1" style="text-align:left;">
                                                        <h5 class="card-title fw-bold mb-1">
                                                            <c:choose>
                                                                <c:when test="${flightType == 'khuhoi'}">
                                                                    ${f.departure} ⇌${f.destination}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${f.departure} → ${f.destination}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </h5>
                                                        <p class="mb-1 ticket_available" style="margin-left: 2px;">
                                                            <strong>Số lượng vé:</strong>
                                                            <span class="text-success">${f.ticketAvailable}</span>
                                                        </p>
                                                        <p class="card-text">
                                                            <span class="badge bg-success text-white px-2 py-1 fs-6">${f.flightClass}</span>
                                                        </p>
                                                    </div>
                                                    <div class="d-flex justify-content-between mt-3">
                                                        <p class="mb-2" style="margin-left: 2px;">

                                                            <i class="bi bi-heart heart" data-flight-id="${f.flightId}" style="font-size:1.4rem;"></i>
                                                        </p>
                                                        <p class="fw-bold text-danger fs-5 text-end">
                                                            <fmt:formatNumber value="${f.basePrice}" type="currency" currencySymbol="VND" groupingUsed="true"/> /Khách
                                                        </p>
                                                    </div>



                                                    <div class="mt-0 d-flex gap-2">
                                                        <!-- NÚT CHỌN -->
                                                        <button type="button" class="btn btn-primary flex-fill rounded-pill w-100 select-flight-btn"
                                                                data-flight-id="${f.flightId}">
                                                            Chọn
                                                        </button>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                               
                                <c:otherwise>
                                    <div class="col-12 text-center text-muted py-5">

                                        <i class="bi bi-airplane fs-1 d-block mb-3"></i>
                                        <i class="bi bi-search me-2"></i>
                                        Không có <strong>chuyến bay</strong> nào mà bạn vừa tìm kiếm

                                    </div>


                                </c:otherwise>
                            </c:choose>
                        </div>

                        <input type="hidden" id="selectedFlightId" name="selectedFlightId" value="">
                    </section>

                    <!-- Hotels Section -->
                    <section class="mb-5">
                        <h2 class="h3 mb-4 text-center text-primary fw-bold border-bottom pb-2">🏨 Chọn khách sạn</h2>

                        <div class="hotel-scroll-container ">
                            <c:choose>
                                <c:when test="${not empty hotels}">
                                    <c:forEach var="hotel" items="${hotels}">
                                        <div class="hotel-item">
                                            <div class="card hotel-card h-100 shadow-lg border-0 rounded-3 overflow-hidden" data-hotelid="${hotel.hotelId}">
                                                <div class="position-relative">
                                                    <img src="${pageContext.request.contextPath}/${hotel.hotelImageUrl}"
                                                         alt="${hotel.hotelName}" class="card-img-top" style="height: 220px; object-fit: cover;">
                                                    <span class="badge bg-info text-dark position-absolute top-0 start-0 m-2 px-3 py-2 rounded-pill shadow-sm">
                                                        ${hotel.roomType}
                                                    </span>

                                                </div>

                                                <div class="card-body d-flex flex-column">
                                                    <h5 class="card-title fw-bold text-dark">${hotel.hotelName}</h5>
                                                    <p class="mb-1"><strong>Phòng trống:</strong> <span class="text-success">${hotel.roomAvailable}</span></p>
                                                    <p class="mb-1">
                                                        <strong>Đánh giá:</strong>
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i class="bi ${i <= hotel.rating ? 'bi-star-fill text-warning' : 'bi-star text-muted'}"></i>
                                                        </c:forEach>
                                                        <span class="text-muted">(${hotel.rating})</span>
                                                    </p>
                                                    <div class="mt-auto">

                                                        <div class="d-flex justify-content-between mt-3">
                                                            <p class="mb-2" style="margin-left: 2px;">

                                                                <i class="bi bi-heart heart" data-hotel-id="${hotel.hotelId}" style="font-size:1.4rem;"></i>
                                                            </p>
                                                            <p class="text-danger fw-bold fs-5 mb-2 text-end">
                                                                <fmt:setLocale value="vi_VN" />
                                                                <fmt:formatNumber value="${hotel.pricePerNight}" type="number" groupingUsed="true"/> VND
                                                                <span class="text-muted fs-6">/đêm</span>
                                                            </p>
                                                        </div>


                                                        <div class="mt-auto d-flex gap-2">
                                                            <button type="button" class="btn btn-primary flex-fill rounded-pill w-100 select-hotel-btn">
                                                                <i class="bi bi-check-circle"></i> Chọn
                                                            </button>
                                                            <button type="button" 
                                                                    class="btn btn-success flex-fill rounded-pill w-100" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#hotelDetailModal" 
                                                                    data-hotelname="${hotel.hotelName}"
                                                                    data-hotelimage="${pageContext.request.contextPath}/${hotel.hotelImageUrl}">


                                                                Xem chi tiết
                                                            </button>
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
                            <input type="hidden" id="selectedHotelId" name="selectedHotelId" value="">
                        </div>
                    </section>


                    <style>
                        .hotel-scroll-container {
                            display: flex;
                            gap: 20px;
                            overflow-x: auto;
                            scroll-snap-type: x mandatory;
                            padding-bottom: 1rem;
                        }
                        .hotel-item {
                            flex: 0 0 calc(33.333% - 20px);
                            scroll-snap-align: start;
                        }
                    </style>
                    <!-- Vehicles Section -->
                    <section class="mb-5">
                        <h2 class="h3 mb-4 text-center fw-bold text-primary">🚘 Chọn phương tiện di chuyển trong đảo</h2>
                        <div class="row g-4 justify-content-center">

                            <c:forEach var="v" items="${islandvehicles}">
                                <div class="col-lg-4">
                                    <div class="card vehicle-card shadow-lg h-100 border-2" data-vehicleid="${v.vehicleId}">
                                        <img src="${pageContext.request.contextPath}/views/home/images/vehicles/${v.vehicleType}.jpg"
                                             alt="${v.vehicleType}" class="card-img-top"
                                             style="height: 220px; object-fit: cover; border-top-left-radius: .75rem; border-top-right-radius: .75rem;">

                                        <div class="card-body">
                                            <h5 class="card-title fw-bold text-dark">${v.vehicleType}</h5>
                                            <p class="mb-1">Tên xe: ${v.modelName}</p>

                                            <div class="mb-2 fs-5">
                                                <span class="badge bg-info text-dark me-1">Sức chứa: ${v.capacity} người</span>
                                                <span class="badge bg-success text-light">Còn ${v.availability} xe</span>
                                            </div>
                                            <div class="d-flex justify-content-between mt-3">
                                                <p class="mb-2" style="margin-left: 2px;">

                                                    <i class="bi bi-heart heart" data-vehicle-id="${v.vehicleId}" style="font-size:1.4rem;"></i>
                                                </p>
                                                <h6 class="text-danger fw-bold fs-5 mb-2 text-end">
                                                    <fmt:formatNumber value="${v.pricePerDay}" type="number" /> VNĐ/ngày
                                                </h6>

                                            </div>


                                            <button type="button" 
                                                    class="mt-2 btn btn-primary flex-fill rounded-pill w-100 fw-semibold select-btn">
                                                <i class="bi bi-check2-circle"></i> Chọn
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                        </div>

                        <!-- Input ẩn để lưu ID của phương tiện được chọn -->
                        <input type="hidden" id="selectedVehicleId" name="selectedVehicleId" value="">
                    </section>
                    <!-- Places Section -->
                    <section class="mb-5">
                        <h2 class="h3 mb-4 text-center fw-bold text-primary">
                            📍 Các địa điểm nổi bật tại đảo
                        </h2>

                        <div class="row g-4">
                            <c:choose>
                                <c:when test="${empty places}">
                                    <div class="col-12">
                                        <div class="alert alert-warning text-center rounded-3 shadow-sm py-4">
                                            <i class="bi bi-exclamation-circle text-warning fs-4"></i>
                                            Hiện chưa có địa điểm nào được thêm cho đảo này.
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <c:forEach var="p" items="${places}">
                                        <div class="col-sm-6 col-lg-4">
                                            <div class="card place-card border-0 shadow-lg rounded-4 h-100 overflow-hidden position-relative card-hover" data-placeid="${p.placeId}">

                                                <!-- Ảnh địa điểm -->
                                                <div class="ratio ratio-16x9">
                                                    <img src="${pageContext.request.contextPath}/views/home/images/places/${p.placeName}.jpg"
                                                         class="card-img-top object-fit-cover"
                                                         alt="${p.placeName}">
                                                </div>

                                                <!-- Nội dung -->
                                                <div class="card-body d-flex flex-column p-4">
                                                    <h5 class="card-title fw-bold text-dark mb-2">
                                                        <i class="bi bi-map text-primary me-1"></i>${p.placeName}
                                                    </h5>
                                                    <p class="text-muted small mb-2">
                                                        <i class="bi bi-geo-alt-fill text-danger me-1"></i>${p.location}
                                                    </p>
                                                    <p class="card-text text-muted small flex-grow-1">
                                                        ${p.description}
                                                    </p>
                                                    <div class="d-flex justify-content-between mt-3">
                                                        <p class="mb-2" style="margin-left: 2px;">

                                                            <i class="bi bi-heart heart" data-place-id="${p.placeId}" style="font-size:1.4rem;"></i>
                                                        </p>
                                                        <div class="text-end">
                                                            <c:choose>
                                                                <c:when test="${p.hasTicket}">
                                                                    <span class="badge bg-success-subtle text-success fs-6 py-2 px-3">
                                                                        Có vé: 
                                                                        <fmt:formatNumber value="${p.ticketPrice}" type="number" groupingUsed="true"/> VNĐ
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary-subtle text-secondary fs-6 py-2 px-3">
                                                                        Miễn phí tham quan
                                                                    </span>
                                                                </c:otherwise>

                                                            </c:choose>
                                                        </div>
                                                    </div>


                                                    <!-- Vé -->



                                                    <!-- Nút chọn -->
                                                    <button type="button"
                                                            class="mt-3 btn btn-primary rounded-pill w-100 fw-semibold select-place-btn">
                                                        <i class="bi bi-check2-circle"></i> Chọn
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <!-- Input ẩn để lưu ID của địa điểm được chọn -->
                        <input type="hidden" id="selectedPlaceId" name="selectedPlaceId" value="">
                    </section>
                    <section class="mb-5 text-center d-flex justify-content-center flex-column">

                        <h2 class="h2 mb-4 text-primary fw-bold">📅 Vui lòng hãy chọn thời gian du lịch</h2>
                        <div class="d-flex justify-content-center gap-4">
                            <div>
                                <label for="startDate" class="form-label fw-semibold">Ngày bắt đầu</label>
                                <input type="date" class="form-control rounded-pill text-center" id="startDate" name="startDate" required>
                            </div>
                            <div>
                                <label for="endDate" class="form-label fw-semibold">Ngày kết thúc</label>
                                <input type="date" class="form-control rounded-pill text-center" id="endDate" name="endDate" required>
                            </div>

                        </div>
                        <small class="text-muted d-block mt-2">  <Strong> Ví dụ</Strong>: 12/03 - 16/03 tương ứng lịch trình 4 ngày 3 đêm.</small>
                    </section>
                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary btn-lg px-5 py-2 rounded-pill fw-semibold">
                            <i class="bi bi-cart-check"></i> Tạo tour ngay
                        </button>
                    </div>

                </form>


                <section class="mb-5">
                    <h2 class="h3 mt-4 mb-4 text-center fw-bold text-primary">Các dịch vụ trong tour</h2>
                    <div class="row g-4">

                        <!-- Service Card 1: Thuê khách sạn -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card shadow-sm p-3 h-100 d-flex align-items-start border-0 rounded-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="bi bi-house-fill text-primary fs-3 me-3"></i>
                                    <h5 class="card-title mb-0 fw-bold">Thuê khách sạn</h5>
                                </div>
                                <p class="card-text text-muted">Đặt phòng tại các khách sạn 5 sao hoặc homestay gần biển với giá ưu đãi.</p>
                            </div>
                        </div>

                        <!-- Service Card 2: Thuê xe du lịch -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card shadow-sm p-3 h-100 d-flex align-items-start border-0 rounded-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="bi bi-car-front-fill text-success fs-3 me-3"></i>
                                    <h5 class="card-title mb-0 fw-bold">Thuê xe du lịch</h5>
                                </div>
                                <p class="card-text text-muted">Cung cấp dịch vụ thuê xe máy, xe hơi hoặc xe buýt đưa đón tận nơi.</p>
                            </div>
                        </div>

                        <!-- Service Card 3: Hướng dẫn viên -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card shadow-sm p-3 h-100 d-flex align-items-start border-0 rounded-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="bi bi-compass-fill text-warning fs-3 me-3"></i>
                                    <h5 class="card-title mb-0 fw-bold">Khu du lịch nổi tiếng</h5>
                                </div>
                                <p class="card-text text-muted">
                                    Khám phá những địa điểm du lịch nổi tiếng, cảnh đẹp thiên nhiên hùng vĩ và văn hóa đặc sắc khắp mọi miền.
                                </p>
                            </div>
                        </div>

                        <!-- Service Card 4: Chuyến bay -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card shadow-sm p-3 h-100 d-flex align-items-start border-0 rounded-3">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="bi bi-airplane-fill text-danger fs-3 me-3"></i>
                                    <h5 class="card-title mb-0 fw-bold">Chuyến bay</h5>
                                </div>
                                <p class="card-text text-muted">Đặt vé máy bay đến đảo, khởi hành từ các thành phố lớn với giá hợp lý.</p>
                            </div>
                        </div>

                    </div>
                </section>


            </div>
        </main>
        <div class="modal fade" id="hotelDetailModal" tabindex="-1" aria-labelledby="hotelDetailLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content shadow-lg rounded-4 border-0">
                    <div class="modal-header p-3 text-white" style="background: linear-gradient(90deg, #4e73df, #224abe); border-bottom: 1px solid #dee2e6; border-top-left-radius: .75rem; border-top-right-radius: .75rem;">
                        <h5 class="modal-title fw-bold" id="hotelDetailLabel">Thông tin khách sạn</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-4">
                            <!-- Ảnh bên trái -->
                            <div class="col-md-6">
                                <img id="modalHotelImage" src="" class="d-block w-100 rounded-3 shadow-sm" style="height:350px; object-fit:cover; border:1px solid #dee2e6;">
                            </div>
                            <!-- Thông tin bên phải -->
                            <div class="col-md-6 text-start">
                                <div class="mt-3 d-flex flex-column justify-content-start gap-2">
                                    <p class="mb-2"><strong class="fs-5">Tên khách sạn: </strong> <span class="fs-5" id="modalHotelName"></span></p>
                                    <p><strong class="fs-5">Tiện nghi:</strong></p>
                                    <div class="row row-cols-2 g-2 mb-2">
                                        <div class="col">
                                            <i class="bi bi-wifi me-2"></i>WiFi miễn phí
                                        </div>
                                        <div class="col">
                                            <i class="bi bi-card-image me-2"></i>Tầm nhìn ra khung cảnh
                                        </div>
                                        <div class="col">
                                            <i class="bi bi-house-door me-2"></i>Phòng gia đình
                                        </div>
                                        <div class="col">
                                            <i class="bi bi-slash-circle me-2"></i>Phòng không hút thuốc
                                        </div>
                                        <div class="col">
                                            <i class="bi bi-snow me-2"></i>Điều hòa không khí
                                        </div>
                                        <div class="col">
                                            <i class="bi bi-car-front me-2"></i>Chỗ đỗ xe
                                        </div>
                                        <div class="col">
                                            <i class="bi bi-tv me-2"></i>TV màn hình phẳng
                                        </div>
                                    </div>

                                    <p class="mb-2 fs-5"><strong>Chính sách:</strong> Nhận phòng từ 14h, Trả phòng trước 12h, Hủy miễn phí trong 24h</p>
                                </div>

                                <div class="mt-3 d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">
                                        Đóng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Footer -->
        <%@ include file="/views/common/footer.jsp" %>



        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>


        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const vehicleButtons = document.querySelectorAll(".vehicle-card .select-btn");
                const hotelButtons = document.querySelectorAll(".hotel-card .select-hotel-btn");
                const placeButtons = document.querySelectorAll(".place-card .select-place-btn");

                const vehicleInput = document.getElementById("selectedVehicleId");
                const hotelInput = document.getElementById("selectedHotelId");
                const placeInput = document.getElementById("selectedPlaceId");
                const selectedPlaces = new Set();
                // --- CHỌN KHÁCH SẠN (BẮT BUỘC, CHỈ ĐƯỢC 1) ---
                const flightButtons = document.querySelectorAll(".flight-card .select-flight-btn");
                const flightInput = document.getElementById("selectedFlightId");

                // --- CHỌN KHÁCH SẠN (BẮT BUỘC) ---
                hotelButtons.forEach(button => {
                    button.addEventListener("click", function () {
                        // Reset các nút khách sạn
                        hotelButtons.forEach(btn => {
                            btn.innerHTML = '<i class="bi bi-check2-circle"></i> Chọn';
                            btn.disabled = false;
                        });

                        // Đặt trạng thái "đã chọn"
                        this.innerHTML = '<i class="bi bi-check-lg"></i> Đã chọn';
                        this.disabled = true;

                        // Lưu ID khách sạn
                        const hotelId = this.closest(".hotel-card").getAttribute("data-hotelid");
                        hotelInput.value = hotelId;
                    });
                });

                // --- CHỌN VÉ MÁY BAY (BẮT BUỘC) ---
                flightButtons.forEach(button => {
                    button.addEventListener("click", function () {
                        // Reset các nút vé máy bay
                        flightButtons.forEach(btn => {
                            btn.innerHTML = '<i class="bi bi-check2-circle"></i> Chọn';
                            btn.disabled = false;
                        });

                        // Đặt trạng thái "đã chọn"
                        this.innerHTML = '<i class="bi bi-check-lg"></i> Đã chọn';
                        this.disabled = true;

                        // Lưu ID vé may bay
                        const flightlId = this.closest(".flight-card").getAttribute("data-flightId");
                        flightInput.value = flightlId;
                    });
                });




                // --- CHỌN PHƯƠNG TIỆN (TÙY CHỌN, CÓ THỂ BỎ CHỌN) ---
                vehicleButtons.forEach(button => {
                    button.addEventListener("click", function () {
                        const card = this.closest(".vehicle-card");
                        const vehicleId = card.getAttribute("data-vehicleid");

                        // Nếu nút này đang ở trạng thái "đã chọn" → bỏ chọn
                        if (this.classList.contains("btn-success")) {
                            this.classList.remove("btn-success");
                            this.innerHTML = '<i class="bi bi-check2-circle"></i> Chọn';
                            this.disabled = false;
                            this.style.opacity = "1";
                            vehicleInput.value = ""; // xóa lựa chọn
                        } else {
                            // Reset trạng thái tất cả nút xe khác
                            vehicleButtons.forEach(btn => {
                                btn.classList.remove("btn-success");
                                btn.innerHTML = '<i class="bi bi-check2-circle"></i> Chọn';
                                btn.disabled = false;
                                btn.style.opacity = "1";
                            });

                            // Đặt trạng thái "đã chọn"
                            this.classList.add("btn-success");
                            this.innerHTML = '<i class="bi bi-check-lg"></i> Đã chọn';
                            this.disabled = false;
                            this.style.opacity = "0.6";
                            // Lưu ID xe đã chọn
                            vehicleInput.value = vehicleId;
                        }
                    });
                });

                // --- CHỌN NHIỀU ĐỊA ĐIỂM (TÙY CHỌN, NHIỀU CÁI) ---
                placeButtons.forEach(button => {
                    button.addEventListener("click", function () {
                        const card = this.closest(".place-card");
                        const placeId = card.getAttribute("data-placeId");

                        if (selectedPlaces.has(placeId)) {
                            // 👉 Bỏ chọn
                            selectedPlaces.delete(placeId);
                            this.classList.remove("btn-success");
                            this.innerHTML = '<i class="bi bi-check2-circle"></i> Chọn';
                            this.style.opacity = "1"; // 🌟 làm nút sáng lại
                        } else {
                            // 👉 Chọn thêm
                            selectedPlaces.add(placeId);
                            this.classList.add("btn-success");
                            this.innerHTML = '<i class="bi bi-check-lg"></i> Đã chọn';
                            this.style.opacity = "0.6"; // 🌟 làm nút mờ đi để báo đã chọn
                        }

                        // Cập nhật input ẩn
                        placeInput.value = Array.from(selectedPlaces).join(",");
                    });
                });
            });
        </script>
        <script>
            //2. Lấy modal hotel
            const hotelModal = document.getElementById('hotelDetailModal');

            hotelModal.addEventListener('show.bs.modal', event => {
                // Nút đã click
                const button = event.relatedTarget;

                // Lấy dữ liệu từ data-* attributes
                const hotelName = button.getAttribute('data-hotelname');
                const hotelImage = button.getAttribute('data-hotelimage');

                // Gán dữ liệu vào modal
                hotelModal.querySelector('#modalHotelName').textContent = hotelName;
                hotelModal.querySelector('#modalHotelImage').src = hotelImage;
            });


// ==================== HÀM HỖ TRỢ  ====================

            function setText(selector, text) {
                const el = document.querySelector(selector);
                if (el)
                    el.textContent = text || '-';
            }

            function set(selector, attr, value) {
                const el = document.querySelector(selector);
                if (el)
                    el.setAttribute(attr, value);
            }

            function show(selector) {
                const el = document.querySelector(selector);
                if (el)
                    el.style.display = 'block';
            }

            function hide(selector) {
                const el = document.querySelector(selector);
                if (el)
                    el.style.display = 'none';
            }

            function formatTime(time) {
                return time ? time.substring(0, 5) : '-';
            }

            function splitAirport(airport) {
                return airport ? airport.split('(')[0].trim() : '-';
            }

        </script>

        <!-- nhap thong tin ngay de tim chuyen bay va cam ket -->
<script>
document.addEventListener('DOMContentLoaded', function () {
    const startDate = document.getElementById('startDateFlight');
    const endDate = document.getElementById('endDateFlight');
    const oneWayLink = document.getElementById('oneWayLink');
    const roundTripLink = document.getElementById('roundTripLink');
    const commitCheckbox = document.getElementById('commitFlight');

    const today = new Date().toISOString().split("T")[0];
    startDate.setAttribute("min", today);
    endDate.setAttribute("min", today);

    // --- LOAD STATE ---
    const savedStart = sessionStorage.getItem("startDateFlight");
    const savedEnd = sessionStorage.getItem("endDateFlight");
    // ❌ Không load trạng thái checkbox nữa
    commitCheckbox.checked = false;

    if (savedStart) startDate.value = savedStart;
    if (savedEnd) endDate.value = savedEnd;

    // --- UPDATE BUTTONS ---
    function updateButtons() {
        const startVal = startDate.value;
        const endVal = endDate.value;
        const isCommitted = commitCheckbox.checked;

        if (startVal && endVal && endVal < startVal) {
            alert("❌ Ngày kết thúc không thể trước ngày bắt đầu!");
            endDate.value = "";
            sessionStorage.removeItem("endDateFlight");
        }

        const hasStart = startVal.trim() !== '';
        const hasEnd = endVal.trim() !== '';

        oneWayLink.classList.toggle('disabled', !(hasStart && isCommitted));
        oneWayLink.style.pointerEvents = hasStart && isCommitted ? 'auto' : 'none';
        oneWayLink.style.opacity = hasStart && isCommitted ? '1' : '0.5';

        roundTripLink.classList.toggle('disabled', !(hasStart && hasEnd && isCommitted));
        roundTripLink.style.pointerEvents = hasStart && hasEnd && isCommitted ? 'auto' : 'none';
        roundTripLink.style.opacity = hasStart && hasEnd && isCommitted ? '1' : '0.5';
    }

    // --- SAVE STATE ---
    function saveState() {
        if (commitCheckbox.checked) {
            sessionStorage.setItem("startDateFlight", startDate.value);
            sessionStorage.setItem("endDateFlight", endDate.value);
        }
    }

    // --- EVENT LISTENERS ---
    startDate.addEventListener('change', () => { saveState(); updateButtons(); });
    endDate.addEventListener('change', () => { saveState(); updateButtons(); });
    commitCheckbox.addEventListener('change', () => {
        if (!commitCheckbox.checked) {
            sessionStorage.clear();
            startDate.value = "";
            endDate.value = "";
        } else {
            saveState();
        }
        updateButtons();
    });

    // --- Xóa tick khi rời trang ---
    window.addEventListener('beforeunload', () => {
        commitCheckbox.checked = false;
        sessionStorage.removeItem("commitFlightChecked");
    });

    updateButtons();
});
</script>

   <!-- add favaroutie tours ,services   -->
        <script >


            document.addEventListener("DOMContentLoaded", () => {
                document.querySelectorAll(".heart").forEach(heart => {
                    heart.addEventListener("click", () => {
                        heart.classList.toggle("full");
                        heart.classList.toggle("bi-heart");       // bi-heart: trống
                        heart.classList.toggle("bi-heart-fill");  // bi-heart-fill: đầy

                        const flightId = heart.dataset.flightId;
                        const liked = heart.classList.contains("full");

                        // Gửi lên server  lưu trạng thái like
                        console.log("Flight ID:", flightId, "Liked:", liked);
                    });
                });
            });

        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


        <%@ include file="/views/common/script.jsp" %>
        <script>

        </script>   
    </body>
</html>