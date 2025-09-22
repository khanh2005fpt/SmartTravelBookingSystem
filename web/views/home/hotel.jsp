<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<html lang="vi">
    <head>
        <%@ include file="/views/common/css.jsp" %>

    </head>
    <body>

        <!-- KẾT THÚC nav -->
        <%@ include file="/views/common/navbar.jsp" %>
        <!-- END nav -->

        <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('${pageContext.request.contextPath}/views/home/images/bg_5.jpg');">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
                    <div class="col-md-9 ftco-animate pb-5 text-center">
                        <p class="breadcrumbs"><span class="mr-2"><a href="SearchIslandController">Trang chủ <i class="fa fa-chevron-right"></i></a></span> <span>Khách sạn <i class="fa fa-chevron-right"></i></span></p>
                        <h1 class="mb-0 bread">Khách sạn</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-section ftco-no-pb">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <div class="search-wrap-1 ftco-animate">
                            <form action="HotelsController" method="get" class="search-property-1">
                                <div class="row no-gutters">

                                    <!-- Country -->
                                    <div class="col-md d-flex">
                                        <div class="form-group p-4">
                                            <label for="country">Quốc gia</label>
                                            <div class="form-field">
                                                <div class="icon"><span class="fa fa-globe"></span></div>
                                                <select name="country" id="country" class="form-control">
                                                    <option value="" ${empty param.country ? 'selected' : ''}>-- Chọn quốc gia --</option>
                                                    <option value="Vietnam" ${param.country == 'Vietnam' ? 'selected' : ''}>Việt Nam</option>
                                                    <option value="Thailand" ${param.country == 'Thailand' ? 'selected' : ''}>Thái Lan</option>
                                                    <option value="Malaysia" ${param.country == 'Malaysia' ? 'selected' : ''}>Malaysia</option>
                                                    <option value="Singapore" ${param.country == 'Singapore' ? 'selected' : ''}>Singapore</option>
                                                    <option value="Indonesia" ${param.country == 'Indonesia' ? 'selected' : ''}>Indonesia</option>
                                                    <option value="Philippines" ${param.country == 'Philippines' ? 'selected' : ''}>Philippines</option>
                                                    <option value="Cambodia" ${param.country == 'Cambodia' ? 'selected' : ''}>Campuchia</option>
                                                    <option value="Laos" ${param.country == 'Laos' ? 'selected' : ''}>Lào</option>
                                                    <option value="Myanmar" ${param.country == 'Myanmar' ? 'selected' : ''}>Myanmar</option>
                                                    <option value="Brunei" ${param.country == 'Brunei' ? 'selected' : ''}>Brunei</option>
                                                    <option value="Timor-Leste" ${param.country == 'Timor-Leste' ? 'selected' : ''}>Đông Timor (Timor-Leste)</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Room type -->
                                    <div class="col-lg d-flex">
                                        <div class="form-group p-4">
                                            <label>Loại phòng</label>
                                            <div class="form-field">
                                                <select name="roomType" class="form-control">
                                                    <option value="">Tất cả</option>
                                                    <option value="Standard" ${param.roomType=="Standard"?"selected":""}>Standard</option>
                                                    <option value="Deluxe" ${param.roomType=="Deluxe"?"selected":""}>Deluxe</option>
                                                    <option value="Suite" ${param.roomType=="Suite"?"selected":""}>Suite</option>
                                                    <option value="Family" ${param.roomType=="Family"?"selected":""}>Family</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Min price -->
                                    <div class="col-lg d-flex">
                                        <div class="form-group p-4">
                                            <label>Giá tối thiểu</label>
                                            <div class="form-field">
                                                <input type="number" name="minPrice" value="${param.minPrice}" 
                                                       class="form-control" placeholder="kVNĐ">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Max price -->
                                    <div class="col-lg d-flex">
                                        <div class="form-group p-4">
                                            <label>Giá tối đa</label>
                                            <div class="form-field">
                                                <input type="number" name="maxPrice" value="${param.maxPrice}" 
                                                       class="form-control" placeholder="kVNĐ">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Submit -->
                                    <div class="col-lg d-flex">
                                        <div class="form-group d-flex w-100 border-0">
                                            <div class="form-field w-100 align-items-center d-flex">
                                                <input type="submit" value="Tìm kiếm" 
                                                       class="align-self-stretch form-control btn btn-primary">
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <section class="ftco-section">
            <div class="container">
                <div class="row">
                    <c:forEach var="hotel" items="${hotels}">
                        <div class="col-md-4 ftco-animate">
                            <div class="project-wrap hotel">
                                <a href="#" class="img" 
                                   style="background-image: url('${pageContext.request.contextPath}/${hotel.imageUrl}');">
                                <span class="price">${hotel.pricePerNight}đ/đêm</span>
                                </a>
                                <div class="text p-4">
                                    <p class="star mb-2">
                                        <c:forEach begin="1" end="${hotel.rating}" var="i">
                                            <span class="fa fa-star"></span>
                                        </c:forEach>
                                    </p>
                                    <h3><a href="#">${hotel.hotelName}</a></h3>
                                    <p class="location"><span class="fa fa-map-marker"></span> ${hotel.country}</p>
                                    <ul>
                                        <li><span class="flaticon-shower"></span>${hotel.roomAvailable}</li>
                                        <li><span class="flaticon-king-size"></span>${hotel.roomType}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Phân trang -->
                <c:choose>
                    <c:when test="${totalPages == 1}">
                        <nav aria-label="Page navigation example">
                            <ul class="pagination justify-content-center mt-4">
                                <li class="page-item active">
                                    <a class="page-link bg-warning text-white border-warning" href="#">1</a>
                                </li>
                            </ul>
                        </nav>
                    </c:when>

                    <c:otherwise>
                        <nav aria-label="Page navigation example">
                            <ul class="pagination justify-content-center mt-4">

                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link bg-warning text-white border-warning" 
                                           href="?page=${currentPage - 1}&country=${param.country}&roomType=${param.roomType}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            Previous
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link bg-warning text-white border-warning" 
                                           href="?page=${i}&country=${param.country}&roomType=${param.roomType}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link bg-warning text-white border-warning" 
                                           href="?page=${currentPage + 1}&country=${param.country}&roomType=${param.roomType}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            Next
                                        </a>
                                    </li>
                                </c:if>


                            </ul>
                        </nav>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section class="ftco-intro ftco-section ftco-no-pt">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-12 text-center">
                        <div class="img"  style="background-image: url(images/bg_2.jpg);">
                            <div class="overlay"></div>
                            <h2>Chúng tôi là Pacific - Công ty Du lịch</h2>
                            <p>Chúng tôi có thể giúp bạn thực hiện ước mơ du lịch. Một con sông nhỏ tên là Duden chảy qua nơi họ ở.</p>
                            <p class="mb-0"><a href="#" class="btn btn-primary px-4 py-3">Nhận báo giá</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="/views/common/footer.jsp" %>

        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <%@ include file="/views/common/script.jsp" %>

    </body>
</html>