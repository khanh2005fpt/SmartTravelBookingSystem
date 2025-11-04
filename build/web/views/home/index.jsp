<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="vi">
    <head>
        <title>Smart Ticket Booking</title>


        <%@ include file="/views/common/css.jsp" %>

    </head>
    <body>
        <%@ include file="/views/common/navbar.jsp" %>
        <!-- KẾT THÚC nav -->

        <!--hien thi modal login thanh cong -->
        <style>
            .welcome-box {
                width: 420px;
                max-width: 100%;
                border-radius: 16px;
                overflow: hidden;
                margin-left: 50px;
                box-shadow: 0 8px 28px rgba(0,0,0,0.2);
                background: #fff;
                border: none;
                text-align: center;
                height: 350px;
            }

            /* Banner */
            .welcome-banner img {
                width: 100%;
                height: 140px;
                object-fit: cover;
                display: block;
                margin: 0 auto;
            }


            /* Tiêu đề */
            .welcome-body h4 {
                font-size: 1.7rem;
                font-weight: 800;
                margin-bottom: 1rem;
                color: #1565c0;
                margin-right: 30px;
            }


            .welcome-body h4 span {
                color: #1976d2;
                margin-left: 30px;

            }

            /* Nội dung */
            .welcome-body p {
                font-size: 0.95rem;
                color: #444;
                margin-bottom: 1.5rem;
                line-height: 1.6;
            }

            /* Nút CTA */
            .btn-meland {
                background: #1976d2;
                color: #fff;
                font-weight: 600;
                padding: 10px 24px;
                border-radius: 8px;
                border: none;
                transition: 0.25s;
            }

            .btn-meland:hover {
                background: #0d47a1;
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(25,118,210,0.3);
            }


        </style>

        <!-- Welcome Modal -->
        <div class="modal fade" id="welcomeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content welcome-box">

                    <!-- Banner ảnh -->
                    <div class="welcome-banner">
                        <img src="${pageContext.request.contextPath}/views/home/images/wellcome_pic.jpg"  alt="Meland Banner">
                    </div>

                    <!-- Nội dung -->
                    <div class="welcome-body text-center p-4">
                        <h4>🌴 Chào mừng đến với <span>MelandBooking</span></h4>
                        <p>
                            Trải nghiệm hệ thống đặt tour - khách sạn thông minh và tận hưởng kỳ nghỉ trọn vẹn cùng chúng tôi! 🏖️ <br>
                        </p>
                    </div>

                </div>
            </div>
        </div>


        <!--xu ly modal login thanh cong -->
        <%
          String successFlag = (String) session.getAttribute("loginSuccess");
          if ("oke".equals(successFlag)) {
        %>
        <script>
            $(document).ready(function () {
                $('#welcomeModal').modal('show'); // Bootstrap 4

                setTimeout(function () {
                    $('#welcomeModal').modal('hide');
                }, 3000);

            });
        </script>
        <%
           session.removeAttribute("loginSuccess");
           }
        %>





        <div class="hero-wrap js-fullheight" style="background-image: url('${pageContext.request.contextPath}/views/home/images/island_Bg.jpg');">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-center" data-scrollax-parent="true">
                    <div class="col-md-7 ftco-animate">
                        <span class="subheading">Chào mừng đến với Meland</span>
                        <h1 class="mb-4">Khám phá điểm đến yêu thích của bạn cùng chúng tôi</h1>
                        <p class="caps">Du lịch đến bất kỳ nơi nào trên thế giới, mà không cần phải đi vòng quanh</p>
                    </div>
                    <a href="https://vimeo.com/1103281572" class="icon-video popup-vimeo d-flex align-items-center justify-content-center mb-4">
                        <span class="fa fa-play"></span>
                    </a>
                </div>
            </div>
        </div>

        <section class="ftco-section ftco-no-pb ftco-no-pt mt-5 pt-5">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <div class="ftco-search d-flex justify-content-center">
                            <div class="row">
                                <div class="col-md-12 nav-link-wrap">
                                    <div class="nav nav-pills text-center" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                                        <a class="nav-link active mr-md-1" id="v-pills-1-tab" data-toggle="pill" href="#v-pills-1"
                                           role="tab" aria-controls="v-pills-1" aria-selected="true">Tìm kiếm đảo</a>
                                    </div>
                                </div>
                                <div class="col-md-12 tab-wrap">
                                    <div class="" id="v-pills-tabContent">

                                        <!-- Tab tìm kiếm đảo -->
                                        <div class="tab-pane fade show active" id="v-pills-1" role="tabpanel">
                                            <form action="SearchIslandController" method="post" class="search-property-1">
                                                <div class="row no-gutters">

                                                    <!-- Quốc gia -->
                                                    <div class="col-md d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="country">Quốc gia</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-globe"></span></div>
                                                                <select name="country" id="country" class="form-control">
                                                                    <option value="" ${empty param.country ? 'selected' : ''}>-- Chọn quốc gia --</option>
                                                                    <c:forEach var="c" items="${countries}">
                                                                        <option value="${c.countryName}" ${param.country == c.countryName ? 'selected' : ''}>${c.countryName}</option>
                                                                    </c:forEach>
                                                                </select>

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Mùa đẹp nhất -->
                                                    <div class="col-md d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="bestSeason">Mùa đẹp nhất</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-sun"></span></div>
                                                                <select name="bestSeason" id="bestSeason" class="form-control">
                                                                    <option value="" ${empty param.bestSeason ? 'selected' : ''}>--Chọn mùa--</option>
                                                                    <option value="Xuân" ${param.bestSeason == 'Xuân' ? 'selected' : ''}>Xuân</option>
                                                                    <option value="Hạ" ${param.bestSeason == 'Hạ' ? 'selected' : ''}>Hạ</option>
                                                                    <option value="Thu" ${param.bestSeason == 'Thu' ? 'selected' : ''}>Thu</option>
                                                                    <option value="Đông" ${param.bestSeason == 'Đông' ? 'selected' : ''}>Đông</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Submit -->
                                                    <div class="col-md d-flex">
                                                        <div class="form-group d-flex w-100 border-0">
                                                            <div class="form-field w-100 align-items-center d-flex">
                                                                <input type="submit" value="Tìm kiếm"
                                                                       class="align-self-stretch form-control btn btn-primary">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>

                                        </div> <!-- end tab -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>






        <section class="ftco-section">
            <div class="container">
                <div class="row justify-content-center pb-4">
                    <div class="col-md-12 heading-section text-center ftco-animate">
                        <span class="subheading">Điểm đến</span>
                        <h2 class="mb-4">Điểm đến Du lịch</h2>
                    </div>
                </div>
                <div class="row">
                    <c:choose>
                        <c:when test="${empty islands}">
                            <div class="col-12">
                                <div class="text-center rounded-3 py-4">
                                    <h5 class="mb-1">Không có đảo nào ở quốc gia này</h5>
                                    <p class="mb-0">Vui lòng quay lại sau hoặc liên hệ để được tư vấn.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="island" items="${islands}">
                                <div class="col-md-4 mb-4">
                                    <div class="card h-100 shadow-lg border-0 rounded-3">
                                        <!-- Ảnh -->
                                        <img src="${pageContext.request.contextPath}/${island.imageUrl}" 
                                             class="card-img-top rounded-top-3" alt="${island.islandName}" 
                                             style="height: 220px; object-fit: cover;">

                                        <!-- Nội dung -->
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title fw-bold text-primary mb-2">${island.islandName}</h5>

                                            <p class="card-text text-muted small mb-2">
                                                <i class="fa fa-map-marker text-danger"></i> ${island.countryName}
                                            </p>

                                            <p class="card-text text-secondary small mb-2">
                                                ${island.shortDescription}
                                            </p>

                                            <!-- Đẩy footer xuống cuối card -->
                                            <div class="mt-auto pt-2">
                                                <form action="IslandDetailController" method="post" class="search-property-1">
                                                    <button type="submit" class="btn btn-primary btn-sm" name="detailId" value="${island.islandId}">Xem chi tiết</button>
                                                </form>

                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    <!-- Pagination -->


                </div>
                <form action="SearchIslandController" method="post" class="search-property-1">
                    <c:if test="${not empty islands}">
                        <c:choose>
                            <c:when test="${totalPages == 1}">
                                <nav aria-label="Page navigation example">
                                    <ul class="pagination justify-content-center mt-4">
                                        <li class="page-item active">
                                            <button type="submit" class="page-link btn btn-primary" name="page" value="1">1</button>
                                        </li>
                                    </ul>
                                </nav>
                            </c:when>
                            <c:otherwise>
                                <nav aria-label="Page navigation example">
                                    <ul class="pagination justify-content-center mt-4">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <button type="submit" class="page-link btn btn-primary" name="page" value="${currentPage - 1}">Trước</button>
                                            </li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <button type="submit" class="page-link btn btn-primary" name="page" value="${i}">${i}</button>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <button type="submit" class="page-link btn btn-primary" name="page" value="${currentPage + 1}">Sau</button>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:otherwise>
                        </c:choose>

                        <!-- Giữ các giá trị tìm kiếm khác -->
                        <input type="hidden" name="country" value="${param.country}">
                        <input type="hidden" name="bestSeason" value="${param.bestSeason}">
                    </c:if>
                </form>

            </div>
        </section>

        <section class="ftco-section ftco-about img" style="background-image: url(${pageContext.request.contextPath}/views/home/images/bg_4.jpg);">
            <div class="overlay"></div>
            <div class="container py-md-5">
                <div class="row py-md-5">
                    <div class="col-md d-flex align-items-center justify-content-center">
                        <a href="https://vimeo.com/45830194" class="icon-video popup-vimeo d-flex align-items-center justify-content-center mb-4">
                            <span class="fa fa-play"></span>
                        </a>
                    </div>
                </div>
            </div>
        </section>



        <section class="ftco-section">
            <div class="container">
                <div class="row justify-content-center pb-4">
                    <div class="col-md-12 heading-section text-center ftco-animate">
                        <span class="subheading">Blog của chúng tôi</span>
                        <h2 class="mb-4">Bài viết gần đây</h2>
                    </div>
                </div>
                <div class="row d-flex">
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry justify-content-end">
                            <a href="blog-single.html" class="block-20" style="background-image: url('${pageContext.request.contextPath}/views/home/images/image_1.jpg');">
                            </a>
                            <div class="text">
                                <div class="d-flex align-items-center mb-4 topp">
                                    <div class="one">
                                        <span class="day">11</span>
                                    </div>
                                    <div class="two">
                                        <span class="yr">2020</span>
                                        <span class="mos">Tháng Chín</span>
                                    </div>
                                </div>
                                <h3 class="heading"><a href="#">Nơi Phổ biến Nhất trên Thế giới</a></h3>
                                <!-- <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p> -->
                                <p><a href="#" class="btn btn-primary">Đọc thêm</a></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry justify-content-end">
                            <a href="blog-single.jsp" class="block-20" style="background-image: url('${pageContext.request.contextPath}/views/home/images/image_2.jpg');">
                            </a>
                            <div class="text">
                                <div class="d-flex align-items-center mb-4 topp">
                                    <div class="one">
                                        <span class="day">11</span>
                                    </div>
                                    <div class="two">
                                        <span class="yr">2020</span>
                                        <span class="mos">Tháng Chín</span>
                                    </div>
                                </div>
                                <h3 class="heading"><a href="#">Nơi Phổ biến Nhất trên Thế giới</a></h3>
                                <!-- <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p> -->
                                <p><a href="#" class="btn btn-primary">Đọc thêm</a></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry">
                            <a href="blog-single.jsp" class="block-20" style="background-image: url('${pageContext.request.contextPath}/views/home/images/image_3.jpg');">
                            </a>
                            <div class="text">
                                <div class="d-flex align-items-center mb-4 topp">
                                    <div class="one">
                                        <span class="day">11</span>
                                    </div>
                                    <div class="two">
                                        <span class="yr">2020</span>
                                        <span class="mos">Tháng Chín</span>
                                    </div>
                                </div>
                                <h3 class="heading"><a href="#">Nơi Phổ biến Nhất trên Thế giới</a></h3>
                                <!-- <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p> -->
                                <p><a href="#" class="btn btn-primary">Đọc thêm</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-intro ftco-section ftco-no-pt">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-12 text-center">
                        <div class="img" style="background-image: url(${pageContext.request.contextPath}/views/home/images/bg_2.jpg);">
                            <div class="overlay"></div>
                            <h2>Chúng tôi là Meland - Công ty Du lịch</h2>
                            <p>Chúng tôi biến ước mơ khám phá biển đảo của bạn thành hiện thực. Những hòn đảo nhiệt đới xinh đẹp đang chờ bạn ghé thăm cùng Meland.</p>
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