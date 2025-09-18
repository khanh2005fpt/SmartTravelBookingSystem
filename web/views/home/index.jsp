<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="vi">
    <head>
        <title>Smart Ticket Booking</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700,800,900" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Arizonia&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

        <link rel="stylesheet" href="css/animate.css">

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/owl.theme.default.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">

        <link rel="stylesheet" href="css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="css/jquery.timepicker.css">


        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <%@ include file="/views/common/navbar.jsp" %>
        <!-- KẾT THÚC nav -->

        <div class="hero-wrap js-fullheight" style="background-image: url('images/island_Bg.jpg');">
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

        <section class="ftco-section ftco-no-pb ftco-no-pt">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <div class="ftco-search d-flex justify-content-center">
                            <div class="row">
                                <div class="col-md-12 nav-link-wrap">
                                    <div class="nav nav-pills text-center" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                                        <a class="nav-link active mr-md-1" id="v-pills-1-tab" data-toggle="pill" href="#v-pills-1" role="tab" aria-controls="v-pills-1" aria-selected="true">Tìm kiếm Tour</a>

                                        <a class="nav-link" id="v-pills-2-tab" data-toggle="pill" href="#v-pills-2" role="tab" aria-controls="v-pills-2" aria-selected="false">Khách sạn</a>

                                    </div>
                                </div>
                                <div class="col-md-12 tab-wrap">

                                    <div class="tab-content" id="v-pills-tabContent">

                                        <div class="tab-pane fade show active" id="v-pills-1" role="tabpanel" aria-labelledby="v-pills-nextgen-tab">
                                            <form action="#" class="search-property-1">
                                                <div class="row no-gutters">
                                                    <div class="col-md d-flex">
                                                        <div class="form-group p-4 border-0">
                                                            <label for="#">Điểm đến</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-search"></span></div>
                                                                <input type="text" class="form-control" placeholder="Tìm kiếm địa điểm">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="#">Ngày nhận phòng</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-calendar"></span></div>
                                                                <input type="text" class="form-control checkin_date" placeholder="Ngày nhận phòng">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="#">Ngày trả phòng</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-calendar"></span></div>
                                                                <input type="text" class="form-control checkout_date" placeholder="Ngày trả phòng">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="#">Giới hạn giá</label>
                                                            <div class="form-field">
                                                                <div class="select-wrap">
                                                                    <div class="icon"><span class="fa fa-chevron-down"></span></div>
                                                                    <select name="" id="" class="form-control">
                                                                        <option value="">$100</option>
                                                                        <option value="">$10,000</option>
                                                                        <option value="">$50,000</option>
                                                                        <option value="">$100,000</option>
                                                                        <option value="">$200,000</option>
                                                                        <option value="">$300,000</option>
                                                                        <option value="">$400,000</option>
                                                                        <option value="">$500,000</option>
                                                                        <option value="">$600,000</option>
                                                                        <option value="">$700,000</option>
                                                                        <option value="">$800,000</option>
                                                                        <option value="">$900,000</option>
                                                                        <option value="">$1,000,000</option>
                                                                        <option value="">$2,000,000</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md d-flex">
                                                        <div class="form-group d-flex w-100 border-0">
                                                            <div class="form-field w-100 align-items-center d-flex">
                                                                <input type="submit" value="Tìm kiếm" class="align-self-stretch form-control btn btn-primary">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>

                                        <div class="tab-pane fade" id="v-pills-2" role="tabpanel" aria-labelledby="v-pills-performance-tab">
                                            <form action="#" class="search-property-1">
                                                <div class="row no-gutters">
                                                    <div class="col-lg d-flex">
                                                        <div class="form-group p-4 border-0">
                                                            <label for="#">Điểm đến</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-search"></span></div>
                                                                <input type="text" class="form-control" placeholder="Tìm kiếm địa điểm">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="#">Ngày nhận phòng</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-calendar"></span></div>
                                                                <input type="text" class="form-control checkin_date" placeholder="Ngày nhận phòng">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="#">Ngày trả phòng</label>
                                                            <div class="form-field">
                                                                <div class="icon"><span class="fa fa-calendar"></span></div>
                                                                <input type="text" class="form-control checkout_date" placeholder="Ngày trả phòng">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg d-flex">
                                                        <div class="form-group p-4">
                                                            <label for="#">Giới hạn giá</label>
                                                            <div class="form-field">
                                                                <div class="select-wrap">
                                                                    <div class=" Sedan"><span class="fa fa-chevron-down"></span></div>
                                                                    <select name="" id="" class="form-control">
                                                                        <option value="">$100</option>
                                                                        <option value="">$10,000</option>
                                                                        <option value="">$50,000</option>
                                                                        <option value="">$100,000</option>
                                                                        <option value="">$200,000</option>
                                                                        <option value="">$300,000</option>
                                                                        <option value="">$400,000</option>
                                                                        <option value="">$500,000</option>
                                                                        <option value="">$600,000</option>
                                                                        <option value="">$700,000</option>
                                                                        <option value="">$800,000</option>
                                                                        <option value="">$900,000</option>
                                                                        <option value="">$1,000,000</option>
                                                                        <option value="">$2,000,000</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg d-flex">
                                                        <div class="form-group d-flex w-100 border-0">
                                                            <div class="form-field w-100 align-items-center d-flex">
                                                                <input type="submit" value="Tìm kiếm" class="align-self-stretch form-control btn btn-primary p-0">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        </section>

        <section class="ftco-section services-section">
            <div class="container">
                <div class="row d-flex">
                    <div class="col-md-6 order-md-last heading-section pl-md-5 ftco-animate d-flex align-items-center">
                        <div class="w-100">
                            <span class="subheading">Chào mừng đến với Pacific</span>
                            <h2 class="mb-4">Đã đến lúc bắt đầu cuộc phiêu lưu của bạn</h2>
                            <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp cho nó những điều cần thiết. Đó là một đất nước tuyệt vời, nơi những câu văn được nướng chín bay vào miệng bạn.</p>
                            <p>Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù. Họ sống tách biệt ở Bookmarksgrove ngay tại bờ biển của Semantics, một đại dương ngôn ngữ rộng lớn.
                                Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p>
                            <p><a href="#" class="btn btn-primary py-3 px-4">Tìm kiếm điểm đến</a></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-md-12 col-lg-6 d-flex align-self-stretch ftco-animate">
                                <div class="services services-1 color-1 d-block img" style="background-image: url(images/services-1.jpg);">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-paragliding"></span></div>
                                    <div class="media-body">
                                        <h3 class="heading mb-3">Hoạt động</h3>
                                        <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p>
                                    </div>
                                </div>      
                            </div>
                            <div class="col-md-12 col-lg-6 d-flex align-self-stretch ftco-animate">
                                <div class="services services-1 color-2 d-block img" style="background-image: url(images/services-2.jpg);">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-route"></span></div>
                                    <div class="media-body">
                                        <h3 class="heading mb-3">Sắp xếp chuyến đi</h3>
                                        <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p>
                                    </div>
                                </div>    
                            </div>
                            <div class="col-md-12 col-lg-6 d-flex align-self-stretch ftco-animate">
                                <div class="services services-1 color-3 d-block img" style="background-image: url(images/services-3.jpg);">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-tour-guide"></span></div>
                                    <div class="media-body">
                                        <h3 class="heading mb-3">Hướng dẫn viên riêng</h3>
                                        <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p>
                                    </div>
                                </div>      
                            </div>
                            <div class="col-md-12 col-lg-6 d-flex align-self-stretch ftco-animate">
                                <div class="services services-1 color-4 d-block img" style="background-image: url(images/services-4.jpg);">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-map"></span></div>
                                    <div class="media-body">
                                        <h3 class="heading mb-3">Quản lý địa điểm</h3>
                                        <p>Một con sông nhỏ tên là Duden chảy qua nơi họ ở và cung cấp những điều cần thiết.</p>
                                    </div>
                                </div>      
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-section img ftco-select-destination" style="background-image: url(images/bg_3.jpg);">
            <div class="container">
                <div class="row justify-content-center pb-4">
                    <div class="col-md-12 heading-section text-center ftco-animate">
                        <span class="subheading">Pacific Cung cấp Địa điểm</span>
                        <h2 class="mb-4">Chọn Điểm đến của Bạn</h2>
                    </div>
                </div>
            </div>
            <div class="container container-2">
                <div class="row">
                    <div class="col-md-12">
                        <div class="carousel-destination owl-carousel ftco-animate">
                            <div class="item">
                                <div class="project-destination">
                                    <a href="#" class="img" style="background-image: url(images/place-1.jpg);">
                                        <div class="text">
                                            <h3>Philippines</h3>
                                            <span>8 Tour</span>
                                        </div>
                                    </a>
                                </div>
                            </div>
                            <div class="item">
                                <div class="project-destination">
                                    <a href="#" class="img" style="background-image: url(images/place-2.jpg);">
                                        <div class="text">
                                            <h3>Canada</h3>
                                            <span>2 Tour</span>
                                        </div>
                                    </a>
                                </div>
                            </div>
                            <div class="item">
                                <div class="project-destination">
                                    <a href="#" class="img" style="background-image: url(images/place-3.jpg);">
                                        <div class="text">
                                            <h3>Thái Lan</h3>
                                            <span>5 Tour</span>
                                        </div>
                                    </a>
                                </div>
                            </div>
                            <div class="item">
                                <div class="project-destination">
                                    <a href="#" class="img" style="background-image: url(images/place-4.jpg);">
                                        <div class="text">
                                            <h3>Úc</h3>
                                            <span>5 Tour</span>
                                        </div>
                                    </a>
                                </div>
                            </div>
                            <div class="item">
                                <div class="project-destination">
                                    <a href="#" class="img" style="background-image: url(images/place-5.jpg);">
                                        <div class="text">
                                            <h3>Hy Lạp</h3>
                                            <span>7 Tour</span>
                                        </div>
                                    </a>
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
                    <div class="col-md-4 ftco-animate">
                        <div class="project-wrap">
                            <a href="#" class="img" style="background-image: url(images/destination-1.jpg);">
                                <span class="price">$550/người</span>
                            </a>
                            <div class="text p-4">
                                <span class="days">Tour 8 Ngày</span>
                                <h3><a href="#">Ruộng bậc thang Banaue</a></h3>
                                <p class="location"><span class="fa fa-map-marker"></span> Banaue, Ifugao, Philippines</p>
                                <ul>
                                    <li><span class="flaticon-shower"></span>2</li>
                                    <li><span class="flaticon-king-size"></span>3</li>
                                    <li><span class="flaticon-mountains"></span>Gần Núi</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 ftco-animate">
                        <div class="project-wrap">
                            <a href="#" class="img" style="background-image: url(images/destination-2.jpg);">
                                <span class="price">$550/người</span>
                            </a>
                            <div class="text p-4">
                                <span class="days">Tour 10 Ngày</span>
                                <h3><a href="#">Ruộng bậc thang Banaue</a></h3>
                                <p class="location"><span class="fa fa-map-marker"></span> Banaue, Ifugao, Philippines</p>
                                <ul>
                                    <li><span class="flaticon-shower"></span>2</li>
                                    <li><span class="flaticon-king-size"></span>3</li>
                                    <li><span class="flaticon-sun-umbrella"></span>Gần Bãi Biển</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 ftco-animate">
                        <div class="project-wrap">
                            <a href="#" class="img" style="background-image: url(images/destination-3.jpg);">
                                <span class="price">$550/người</span>
                            </a>
                            <div class="text p-4">
                                <span class="days">Tour 7 Ngày</span>
                                <h3><a href="#">Ruộng bậc thang Banaue</a></h3>
                                <p class="location"><span class="fa fa-map-marker"></span> Banaue, Ifugao, Philippines</p>
                                <ul>
                                    <li><span class="flaticon-shower"></span>2</li>
                                    <li><span class="flaticon-king-size"></span>3</li>
                                    <li><span class="flaticon-sun-umbrella"></span>Gần Bãi Biển</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 ftco-animate">
                        <div class="project-wrap">
                            <a href="#" class="img" style="background-image: url(images/destination-4.jpg);">
                                <span class="price">$550/người</span>
                            </a>
                            <div class="text p-4">
                                <span class="days">Tour 8 Ngày</span>
                                <h3><a href="#">Ruộng bậc thang Banaue</a></h3>
                                <p class="location"><span class="fa fa-map-marker"></span> Banaue, Ifugao, Philippines</p>
                                <ul>
                                    <li><span class="flaticon-shower"></span>2</li>
                                    <li><span class="flaticon-king-size"></span>3</li>
                                    <li><span class="flaticon-sun-umbrella"></span>Gần Bãi Biển</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 ftco-animate">
                        <div class="project-wrap">
                            <a href="#" class="img" style="background-image: url(images/destination-5.jpg);">
                                <span class="price">$550/người</span>
                            </a>
                            <div class="text p-4">
                                <span class="days">Tour 10 Ngày</span>
                                <h3><a href="#">Ruộng bậc thang Banaue</a></h3>
                                <p class="location"><span class="fa fa-map-marker"></span> Banaue, Ifugao, Philippines</p>
                                <ul>
                                    <li><span class="flaticon-shower"></span>2</li>
                                    <li><span class="flaticon-king-size"></span>3</li>
                                    <li><span class="flaticon-sun-umbrella"></span>Gần Bãi Biển</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 ftco-animate">
                        <div class="project-wrap">
                            <a href="#" class="img" style="background-image: url(images/destination-6.jpg);">
                                <span class="price">$550/người</span>
                            </a>
                            <div class="text p-4">
                                <span class="days">Tour 7 Ngày</span>
                                <h3><a href="#">Ruộng bậc thang Banaue</a></h3>
                                <p class="location"><span class="fa fa-map-marker"></span> Banaue, Ifugao, Philippines</p>
                                <ul>
                                    <li><span class="flaticon-shower"></span>2</li>
                                    <li><span class="flaticon-king-size"></span>3</li>
                                    <li><span class="flaticon-sun-umbrella"></span>Gần Bãi Biển</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-section ftco-about img" style="background-image: url(images/bg_4.jpg);">
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

        <section class="ftco-section ftco-about ftco-no-pt img">
            <div class="container">
                <div class="row d-flex">
                    <div class="col-md-12 about-intro">
                        <div class="row">
                            <div class="col-md-6 d-flex align-items-stretch">
                                <div class="img d-flex w-100 align-items-center justify-content-center" style="background-image:url(images/about-1.jpg);">
                                </div>
                            </div>
                            <div class="col-md-6 pl-md-5 py-5">
                                <div class="row justify-content-start pb-3">
                                    <div class="col-md-12 heading-section ftco-animate">
                                        <span class="subheading">Về Chúng Tôi</span>
                                        <h2 class="mb-4">Làm cho chuyến du lịch của bạn trở nên đáng nhớ và an toàn cùng chúng tôi</h2>
                                        <p>Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù. Họ sống tách biệt ở Bookmarksgrove ngay tại bờ biển của Semantics, một đại dương ngôn ngữ rộng lớn.</p>
                                        <p><a href="#" class="btn btn-primary">Đặt điểm đến của bạn</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-section testimony-section bg-bottom" style="background-image: url(images/bg_1.jpg);">
            <div class="overlay"></div>
            <div class="container">
                <div class="row justify-content-center pb-4">
                    <div class="col-md-7 text-center heading-section heading-section-white ftco-animate">
                        <span class="subheading">Phản hồi</span>
                        <h2 class="mb-4">Phản hồi của Du khách</h2>
                    </div>
                </div>
                <div class="row ftco-animate">
                    <div class="col-md-12">
                        <div class="carousel-testimony owl-carousel">
                            <div class="item">
                                <div class="testimony-wrap py-4">
                                    <div class="text">
                                        <p class="star">
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                        </p>
                                        <p class="mb-4">Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù.</p>
                                        <div class="d-flex align-items-center">
                                            <div class="user-img" style="background-image: url(images/person_1.jpg)"></div>
                                            <div class="pl-3">
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Quản lý Tiếp thị</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap py-4">
                                    <div class="text">
                                        <p class="star">
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                        </p>
                                        <p class="mb-4">Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù.</p>
                                        <div class="d-flex align-items-center">
                                            <div class="user-img" style="background-image: url(images/person_2.jpg)"></div>
                                            <div class="pl-3">
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Quản lý Tiếp thị</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap py-4">
                                    <div class="text">
                                        <p class="star">
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                        </p>
                                        <p class="mb-4">Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù.</p>
                                        <div class="d-flex align-items-center">
                                            <div class="user-img" style="background-image: url(images/person_3.jpg)"></div>
                                            <div class="pl-3">
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Quản lý Tiếp thị</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap py-4">
                                    <div class="text">
                                        <p class="star">
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                        </p>
                                        <p class="mb-4">Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù.</p>
                                        <div class="d-flex align-items-center">
                                            <div class="user-img" style="background-image: url(images/person_1.jpg)"></div>
                                            <div class="pl-3">
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Quản lý Tiếp thị</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap py-4">
                                    <div class="text">
                                        <p class="star">
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                            <span class="fa fa-star"></span>
                                        </p>
                                        <p class="mb-4">Xa xa, phía sau những ngọn núi chữ, xa các quốc gia Vokalia và Consonantia, có những văn bản mù.</p>
                                        <div class="d-flex align-items-center">
                                            <div class="user-img" style="background-image: url(images/person_2.jpg)"></div>
                                            <div class="pl-3">
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Quản lý Tiếp thị</span>
                                            </div>
                                        </div>
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
                        <span class="subheading">Blog của chúng tôi</span>
                        <h2 class="mb-4">Bài viết gần đây</h2>
                    </div>
                </div>
                <div class="row d-flex">
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry justify-content-end">
                            <a href="blog-single.html" class="block-20" style="background-image: url('images/image_1.jpg');">
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
                            <a href="blog-single.jsp" class="block-20" style="background-image: url('images/image_2.jpg');">
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
                            <a href="blog-single.jsp" class="block-20" style="background-image: url('images/image_3.jpg');">
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
                        <div class="img" style="background-image: url(images/bg_2.jpg);">
                            <div class="overlay"></div>
                            <h2>Chúng tôi là Pacific - Công ty Du lịch</h2>
                            <p>Chúng tôi có thể quản lý giấc mơ xây dựng của bạn. Một con sông nhỏ tên là Duden chảy qua nơi họ ở.</p>
                            <p class="mb-0"><a href="#" class="btn btn-primary px-4 py-3">Yêu cầu Báo giá</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="/views/common/footer.jsp" %>



        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>


        <script src="js/jquery.min.js"></script>
        <script src="js/jquery-migrate-3.0.1.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.easing.1.3.js"></script>
        <script src="js/jquery.waypoints.min.js"></script>
        <script src="js/jquery.stellar.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/jquery.animateNumber.min.js"></script>
        <script src="js/bootstrap-datepicker.js"></script>
        <script src="js/scrollax.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
        <script src="js/google-map.js"></script>
        <script src="js/main.js"></script>

    </body>
</html>