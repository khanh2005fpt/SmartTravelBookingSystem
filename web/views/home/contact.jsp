<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="vi">
<head>
 <%@ include file="/views/common/css.jsp" %>
</head>
<body>
 <%@ include file="/views/common/navbar.jsp" %>
 <!-- KẾT THÚC nav -->
 
 <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('images/bg_1.jpg');">
  <div class="overlay"></div>
  <div class="container">
    <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
      <div class="col-md-9 ftco-animate pb-5 text-center">
       <p class="breadcrumbs"><span class="mr-2"><a href="index.jsp">Trang chủ <i class="fa fa-chevron-right"></i></a></span> <span>Liên hệ với chúng tôi <i class="fa fa-chevron-right"></i></span></p>
       <h1 class="mb-0 bread">Liên hệ với chúng tôi</h1>
     </div>
   </div>
 </div>
</section>

<section class="ftco-section ftco-no-pb contact-section mb-4">
  <div class="container">
    <div class="row d-flex contact-info">
      <div class="col-md-3 d-flex">
       <div class="align-self-stretch box p-4 text-center">
        <div class="icon d-flex align-items-center justify-content-center">
         <span class="fa fa-map-marker"></span>
       </div>
       <h3 class="mb-2">Địa chỉ</h3>
       <p>198 West 21th Street, Suite 721 New York NY 10016</p>
     </div>
   </div>
   <div class="col-md-3 d-flex">
     <div class="align-self-stretch box p-4 text-center">
      <div class="icon d-flex align-items-center justify-content-center">
       <span class="fa fa-phone"></span>
     </div>
     <h3 class="mb-2">Số liên hệ</h3>
     <p><a href="tel://1234567920">+ 1235 2355 98</a></p>
   </div>
 </div>
 <div class="col-md-3 d-flex">
   <div class="align-self-stretch box p-4 text-center">
    <div class="icon d-flex align-items-center justify-content-center">
     <span class="fa fa-paper-plane"></span>
   </div>
   <h3 class="mb-2">Địa chỉ Email</h3>
   <p><a href="mailto:info@yoursite.com">info@yoursite.com</a></p>
 </div>
</div>
<div class="col-md-3 d-flex">
 <div class="align-self-stretch box p-4 text-center">
  <div class="icon d-flex align-items-center justify-content-center">
   <span class="fa fa-globe"></span>
 </div>
 <h3 class="mb-2">Trang web</h3>
 <p><a href="#">yoursite.com</a></p>
</div>
</div>
</div>
</div>
</section>

<section class="ftco-section contact-section ftco-no-pt">
  <div class="container">
    <div class="row block-9">
      <div class="col-md-6 order-md-last d-flex">
        <form action="#" class="bg-light p-5 contact-form">
          <div class="form-group">
            <input type="text" class="form-control" placeholder="Tên của bạn">
          </div>
          <div class="form-group">
            <input type="text" class="form-control" placeholder="Email của bạn">
          </div>
          <div class="form-group">
            <input type="text" class="form-control" placeholder="Chủ đề">
          </div>
          <div class="form-group">
            <textarea name="" id="" cols="30" rows="7" class="form-control" placeholder="Tin nhắn"></textarea>
          </div>
          <div class="form-group">
            <input type="submit" value="Gửi Tin nhắn" class="btn btn-primary py-3 px-5">
          </div>
        </form>
        
      </div>

      <div class="col-md-6 d-flex">
       <div id="map" class="bg-white"></div>
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


    <%@ include file="/views/common/script.jsp" %>

</body>
</html>