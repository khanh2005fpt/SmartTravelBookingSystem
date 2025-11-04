<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="vi">
<head>
 <%@ include file="/views/common/css.jsp" %>
</head>
<body>
 <%@ include file="/views/common/navbar.jsp" %>
 <!-- END nav -->
 
 <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('images/bg_1.jpg');">
  <div class="overlay"></div>
  <div class="container">
    <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-center">
      <div class="col-md-9 ftco-animate pb-5 text-center">
       <p class="breadcrumbs"><span class="mr-2"><a href="index.jsp">Trang chủ <i class="fa fa-chevron-right"></i></a></span> <span class="mr-2"><a href="index.jsp">Blog <i class="fa fa-chevron-right"></i></a></span> <span>Chi tiết Blog <i class="fa fa-chevron-right"></i></span></p>
       <h1 class="mb-0 bread">Chi tiết Blog</h1>
     </div>
   </div>
 </div>
</section>

<section class="ftco-section ftco-no-pt ftco-no-pb">
  <div class="container">
    <div class="row">
      <div class="col-lg-8 ftco-animate py-md-5 mt-md-5">
        <h2 class="mb-3">Một sự thật lâu đời là người đọc dễ bị phân tâm</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Reiciendis, eius mollitia suscipit, quisquam doloremque distinctio perferendis et doloribus unde architecto optio laboriosam porro adipisci sapiente officiis nemo accusamus ad praesentium? Esse minima nisi et. Dolore perferendis, enim praesentium omnis, iste doloremque quia officia optio deserunt molestiae voluptates soluta architecto tempora.</p>
        <p>
          <img src="images/bg_5.jpg" alt="" class="img-fluid">
        </p>
        <p>Molestiae cupiditate inventore animi, maxime sapiente optio, illo est nemo veritatis repellat sunt doloribus nesciunt! Minima laborum magni reiciendis qui voluptate quisquam voluptatem soluta illo eum ullam incidunt rem assumenda eveniet eaque sequi deleniti tenetur dolore amet fugit perspiciatis ipsa, odit. Nesciunt dolor minima esse vero ut ea, repudiandae suscipit!</p>
        <h2 class="mb-3 mt-5">#2. Chủ đề WordPress sáng tạo</h2>
        <p>Temporibus ad error suscipit exercitationem hic molestiae totam obcaecati rerum, eius aut, in. Exercitationem atque quidem tempora maiores ex architecto voluptatum aut officia doloremque. Error dolore voluptas, omnis molestias odio dignissimos culpa ex earum nisi consequatur quos odit quasi repellat qui officiis reiciendis incidunt hic non? Debitis commodi aut, adipisci.</p>
        <p>
          <img src="images/bg_1.jpg" alt="" class="img-fluid">
        </p>
        <p>Quisquam esse aliquam fuga distinctio, quidem delectus veritatis reiciendis. Nihil explicabo quod, est eos ipsum. Unde aut non tenetur tempore, nisi culpa voluptate maiores officiis quis vel ab consectetur suscipit veritatis nulla quos quia aspernatur perferendis, libero sint. Error, velit, porro. Deserunt minus, quibusdam iste enim veniam, modi rem maiores.</p>
        <div class="tag-widget post-tag-container mb-5 mt-5">
          <div class="tagcloud">
            <a href="#" class="tag-cloud-link">Cuộc sống</a>
            <a href="#" class="tag-cloud-link">Thể thao</a>
            <a href="#" class="tag-cloud-link">Công nghệ</a>
            <a href="#" class="tag-cloud-link">Du lịch</a>
          </div>
        </div>
        
        <div class="about-author d-flex p-4 bg-light">
          <div class="bio mr-5">
            <img src="images/person_1.jpg" alt="Ảnh đại diện" class="img-fluid mb-4">
          </div>
          <div class="desc">
            <h3>George Washington</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ducimus itaque, autem necessitatibus voluptate quod mollitia delectus aut, sunt placeat nam vero culpa sapiente consectetur similique, inventore eos fugit cupiditate numquam!</p>
          </div>
        </div>


        <div class="pt-5 mt-5">
          <h3 class="mb-5" style="font-size: 20px; font-weight: bold;">6 Bình luận</h3>
          <ul class="comment-list">
            <li class="comment">
              <div class="vcard bio">
                <img src="images/person_1.jpg" alt="Ảnh đại diện">
              </div>
              <div class="comment-body">
                <h3>Nguyễn Văn A</h3>
                <div class="meta">11 Tháng 9, 2020 lúc 2:21 chiều</div>
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Pariatur quidem laborum necessitatibus, ipsam impedit vitae autem, eum officia, fugiat saepe enim sapiente iste iure! Quam voluptas earum impedit necessitatibus, nihil?</p>
                <p><a href="#" class="reply">Trả lời</a></p>
              </div>
            </li>

            <li class="comment">
              <div class="vcard bio">
                <img src="images/person_1.jpg" alt="Ảnh đại diện">
              </div>
              <div class="comment-body">
                <h3>Nguyễn Văn B</h3>
                <div class="meta">11 Tháng 9, 2020 lúc 2:21 chiều</div>
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Pariatur quidem laborum necessitatibus, ipsam impedit vitae autem, eum officia, fugiat saepe enim sapiente iste iure! Quam voluptas earum impedit necessitatibus, nihil?</p>
                <p><a href="#" class="reply">Trả lời</a></p>
              </div>

              <ul class="children">
                <li class="comment">
                  <div class="vcard bio">
                    <img src="images/person_1.jpg" alt="Ảnh đại diện">
                  </div>
                  <div class="comment-body">
                    <h3>Nguyễn Văn C</h3>
                    <div class="meta">11 Tháng 9, 2020 lúc 2:21 chiều</div>
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Pariatur quidem laborum necessitatibus, ipsam impedit vitae autem, eum officia, fugiat saepe enim sapiente iste iure! Quam voluptas earum impedit necessitatibus, nihil?</p>
                    <p><a href="#" class="reply">Trả lời</a></p>
                  </div>


                  <ul class="children">
                    <li class="comment">
                      <div class="vcard bio">
                        <img src="images/person_1.jpg" alt="Ảnh đại diện">
                      </div>
                      <div class="comment-body">
                        <h3>Nguyễn Văn D</h3>
                        <div class="meta">11 Tháng 9, 2020 lúc 2:21 chiều</div>
                        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Pariatur quidem laborum necessitatibus, ipsam impedit vitae autem, eum officia, fugiat saepe enim sapiente iste iure! Quam voluptas earum impedit necessitatibus, nihil?</p>
                        <p><a href="#" class="reply">Trả lời</a></p>
                      </div>
                    </li>
                  </ul>
                </li>
              </ul>
            </li>

            <li class="comment">
              <div class="vcard bio">
                <img src="images/person_1.jpg" alt="Ảnh đại diện">
              </div>
              <div class="comment-body">
                <h3>Nguyễn Văn E</h3>
                <div class="meta">11 Tháng 9, 2020 lúc 2:21 chiều</div>
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Pariatur quidem laborum necessitatibus, ipsam impedit vitae autem, eum officia, fugiat saepe enim sapiente iste iure! Quam voluptas earum impedit necessitatibus, nihil?</p>
                <p><a href="#" class="reply">Trả lời</a></p>
              </div>
            </li>
          </ul>
          <!-- END comment-list -->
          
          <div class="comment-form-wrap pt-5">
            <h3 class="mb-5" style="font-size: 20px; font-weight: bold;">Để lại bình luận</h3>
            <form action="#" class="p-5 bg-light">
              <div class="form-group">
                <label for="name">Tên *</label>
                <input type="text" class="form-control" id="name">
              </div>
              <div class="form-group">
                <label for="email">Email *</label>
                <input type="email" class="form-control" id="email">
              </div>
              <div class="form-group">
                <label for="website">Website</label>
                <input type="url" class="form-control" id="website">
              </div>

              <div class="form-group">
                <label for="message">Nội dung</label>
                <textarea name="" id="message" cols="30" rows="10" class="form-control"></textarea>
              </div>
              <div class="form-group">
                <input type="submit" value="Gửi bình luận" class="btn py-3 px-4 btn-primary">
              </div>

            </form>
          </div>
        </div>

      </div> <!-- .col-md-8 -->
      <div class="col-lg-4 sidebar ftco-animate bg-light py-md-5">
        <div class="sidebar-box pt-md-5">
          <form action="#" class="search-form">
            <div class="form-group">
              <span class="icon fa fa-search"></span>
              <input type="text" class="form-control" placeholder="Tìm kiếm...">
            </div>
          </form>
        </div>
        <div class="sidebar-box ftco-animate">
          <div class="categories">
            <h3>Danh mục</h3>
            <li><a href="#">Du lịch <span>(12)</span></a></li>
            <li><a href="#">Tour <span>(22)</span></a></li>
            <li><a href="#">Điểm đến <span>(37)</span></a></li>
            <li><a href="#">Đồ uống <span>(42)</span></a></li>
            <li><a href="#">Ẩm thực <span>(14)</span></a></li>
            <li><a href="#">Du lịch <span>(140)</span></a></li>
          </div>
        </div>

        <div class="sidebar-box ftco-animate">
          <h3>Bài viết mới</h3>
          <div class="block-21 mb-4 d-flex">
            <a class="blog-img mr-4" style="background-image: url(images/image_1.jpg);"></a>
            <div class="text">
              <h3 class="heading"><a href="#">Ngay cả Pointing quyền lực cũng không kiểm soát được các văn bản mù</a></h3>
              <div class="meta">
                <div><a href="#"><span class="fa fa-calendar"></span> 11 Tháng 9, 2020</a></div>
                <div><a href="#"><span class="fa fa-user"></span> Quản trị viên</a></div>
                <div><a href="#"><span class="fa fa-comment"></span> 19</a></div>
              </div>
            </div>
          </div>
          <div class="block-21 mb-4 d-flex">
            <a class="blog-img mr-4" style="background-image: url(images/image_2.jpg);"></a>
            <div class="text">
              <h3 class="heading"><a href="#">Ngay cả Pointing quyền lực cũng không kiểm soát được các văn bản mù</a></h3>
              <div class="meta">
                <div><a href="#"><span class="fa fa-calendar"></span> 11 Tháng 9, 2020</a></div>
                <div><a href="#"><span class="fa fa-user"></span> Quản trị viên</a></div>
                <div><a href="#"><span class="fa fa-comment"></span> 19</a></div>
              </div>
            </div>
          </div>
          <div class="block-21 mb-4 d-flex">
            <a class="blog-img mr-4" style="background-image: url(images/image_3.jpg);"></a>
            <div class="text">
              <h3 class="heading"><a href="#">Ngay cả Pointing quyền lực cũng không kiểm soát được các văn bản mù</a></h3>
              <div class="meta">
                <div><a href="#"><span class="fa fa-calendar"></span> 11 Tháng 9, 2020</a></div>
                <div><a href="#"><span class="fa fa-user"></span> Quản trị viên</a></div>
                <div><a href="#"><span class="fa fa-comment"></span> 19</a></div>
              </div>
            </div>
          </div>
        </div>

        <div class="sidebar-box ftco-animate">
          <h3>Thẻ nổi bật</h3>
          <div class="tagcloud">
            <a href="#" class="tag-cloud-link">món ăn</a>
            <a href="#" class="tag-cloud-link">thực đơn</a>
            <a href="#" class="tag-cloud-link">ẩm thực</a>
            <a href="#" class="tag-cloud-link">ngọt</a>
            <a href="#" class="tag-cloud-link">ngon</a>
            <a href="#" class="tag-cloud-link">đặc sắc</a>
            <a href="#" class="tag-cloud-link">tráng miệng</a>
            <a href="#" class="tag-cloud-link">đồ uống</a>
          </div>
        </div>

        <div class="sidebar-box ftco-animate">
          <h3>Đoạn văn</h3>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ducimus itaque, autem necessitatibus voluptate quod mollitia delectus aut, sunt placeat nam vero culpa sapiente consectetur similique, inventore eos fugit cupiditate numquam!</p>
        </div>
      </div>

    </div>
  </div>
</section> <!-- .section -->	

<section class="ftco-intro ftco-section ftco-no-pt">
 <div class="container">
  <div class="row justify-content-center">
   <div class="col-md-12 text-center">
    <div class="img"  style="background-image: url(images/bg_2.jpg);">
     <div class="overlay"></div>
     <h2>Chúng tôi là Pacific - Công ty Du lịch</h2>
     <p>Chúng tôi có thể giúp bạn xây dựng ước mơ. Một con sông nhỏ tên là Duden chảy qua nơi của họ</p>
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