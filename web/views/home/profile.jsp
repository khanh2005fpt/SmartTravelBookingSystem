
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<html>
    <head
         <%@ include file="/views/common/css.jsp" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
       
    </head>
    <body class="profile" >
  <div class="profile-container">
    <!-- SIDEBAR -->
    <div class="profile-sidebar">
      <div class="profile-header">
        <img src="https://via.placeholder.com/60" class="profile-avatar" alt="avatar">
        <div class="profile-info">
            <!-- lay thong tin user tu session  -->
<%
    User user = (User)session.getAttribute("user");
%>
          <h4><%= user != null ? user.getFullName() : "Khách" %> </h4>
          <p class="provider">Google</p>
        </div>
      </div>

      <div class="profile-rank">
        <i class="bi bi-award-fill"></i>
        <span>Bạn là thành viên <b>Bronze Priority</b></span>
      </div>

 <div class="profile-menu">
  <a href="#" onclick="showMainSection(event, 'points')"><i class="bi bi-coin"></i> 0 Điểm</a>
  <a href="#" onclick="showMainSection(event, 'bookings')"><i class="bi bi-calendar2-check"></i> Đặt chỗ của tôi</a>
  <a href="#" onclick="showMainSection(event, 'transactions')"><i class="bi bi-list-ul"></i> Giao dịch</a>
  <a href="#" onclick="showMainSection(event, 'notifications')"><i class="bi bi-bell"></i> Thông báo</a>
  <a href="#" onclick="showMainSection(event, 'setting')"><i class="bi bi-gear"></i> Cài đặt</a>
  <a href="#" onclick="showMainSection(event, 'account')" class="active"><i class="bi bi-person"></i> Tài khoản</a>
  <a href="<%= request.getContextPath() %>/logout" class="logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
  
</div>
  </div>

    <!-- ===================== CONTENT ===================== -->
  <!-- point content -->
    
  <div id="points" class="main-section" style="display:none;">Nội dung điểm...</div>
  
   <!-- booking content -->
      <div id="bookings" class="main-section" style="display:none;">Nội dung Đặt chỗ của tôi...</div>
  
        <!--  content -->
      <div id="transactions" class="main-section" style="display:none;">Nội dung giao dịch của tôi...</div>
  
    <!-- account and securit content --> 
    <div class="account-container">
      <div class="tab-header-account">
        <button class="active" onclick="showAccountTab(event, 'profile')">Thông tin tài khoản</button>
        <button onclick="showAccountTab(event, 'security')">Mật khẩu & Bảo mật</button>
      </div>

      <div id="profile" class="tab-content active">
        <section class="card">
          <h3>Dữ liệu cá nhân</h3>
          <div class="form-grid">
            <div>
              <label>Tên đầy đủ</label>
              <input type="text" value="Huy Nguyễn Quang">
            </div>
            <div>
              <label>Giới tính</label>
              <select>
                <option>Nam</option>
                <option>Nữ</option>
              </select>
            </div>
            <div>
              <label>Ngày sinh</label>
              <div class="date-group">
                <select><option>26</option></select>
                <select><option>Tháng 10</option></select>
                <select><option>2004</option></select>
              </div>
            </div>
            <div>
              <label>Thành phố cư trú</label>
              <input type="text" placeholder="Thành phố cư trú" disabled>
            </div>
          </div>
          <div class="actions">
            <button class="btn-secondary">Để sau</button>
            <button class="btn-primary" disabled>Lưu</button>
          </div>
        </section>

        <section class="card">
          <h3>Email</h3>
          <div class="email-list">
            <div class="email-item">
              <span>1. nqaghuyyy6969@gmail.com</span>
              <span class="tag">Nơi nhận thông báo</span>
            </div>
          </div>
          <button class="btn-outline w-25 mt-2">+ Thêm email</button>
        </section>

        <section class="card">
          <h3>Số di động</h3>
          <button class="btn-outline w-25 mt-2">+ Thêm số di động</button>
        </section>
      </div>

      <div id="security" class="tab-content">
        <section class="card">
          <h3>Đổi mật khẩu</h3>
          <div class="form-grid">
            <div>
              <label>Mật khẩu hiện tại</label>
              <input type="password" placeholder="Nhập mật khẩu cũ">
            </div>
            <div>
              <label>Mật khẩu mới</label>
              <input type="password" placeholder="Nhập mật khẩu mới">
            </div>
            <div>
              <label>Xác nhận mật khẩu mới</label>
              <input type="password" placeholder="Nhập lại mật khẩu mới">
            </div>
          </div>
          <div class="actions">
            <button class="btn-primary">Lưu thay đổi</button>
          </div>
        </section>
      </div>
    </div>
  </div>

<script>
function showMainSection(evt, sectionId) {
  // Ẩn toàn bộ các main-section
  document.querySelectorAll(".main-section , .account-container").forEach(s => s.style.display = "none");

  // Hiển thị phần được chọn
  const selected = document.getElementById(sectionId);
  if (selected) selected.style.display = "block";

 if (sectionId === 'account') {
    document.querySelector('.account-container').style.display = "block";
  }

  // Cập nhật active trong menu
  document.querySelectorAll(".profile-menu a").forEach(a => a.classList.remove("active"));
  evt.currentTarget.classList.add("active");
}

// Điều khiển tab con trong phần Tài khoản
function showAccountTab(evt, tabId) {
  document.querySelectorAll(".account-container .tab-content").forEach(c => c.classList.remove("active"));
  document.querySelectorAll(".tab-header-account button").forEach(b => b.classList.remove("active"));

  document.getElementById(tabId).classList.add("active");
  evt.currentTarget.classList.add("active");
}
</script>
</body>
</html>
