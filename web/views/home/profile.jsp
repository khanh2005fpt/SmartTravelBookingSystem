
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<html lang="vi">
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

                </div>

                <!-- Thông báo lỗi  -->
                <% String error = (String)session.getAttribute("errorMess") ; %>
                <% if(error !=null){%>

                <div id="errorAlert" class="alert alert-danger alert_style" role="alert">
                    <%=error%>
                </div>
                <!-- set time display loi  ------------------------------------------------------>
                <script>
                    setTimeout(function () {
                        var alertBox = document.getElementById("errorAlert");
                        if (alertBox) {
                            alertBox.style.display = "none";
                        }
                    }, 2000);
                </script>
                <!-- remove session  -->
                <% session.removeAttribute("errorMess");%>
                <%}%>


                <!-- Thông báo lưu thành công  -------------------------------------------------->
                <% String success = (String)session.getAttribute("successMess") ; %>
                <% if(success !=null){%>

                <div id="successAlert" class="alert alert-success alert_style" role="alert">
                    <%=success%>
                </div>
                <!-- set time display loi  -->
                <script>
                    setTimeout(function () {
                        var alertBox = document.getElementById("successAlert");
                        if (alertBox) {
                            alertBox.style.display = "none";
                        }
                    }, 2000);
                </script>
                <!-- remove session  -->
                <% session.removeAttribute("successMess");%>
                <%}%>



                <div id="profile" class="tab-content active">


                    <section class="card">
                        <form  action="${pageContext.request.contextPath}/information" method="POST">

                            <h3>Dữ liệu cá nhân</h3>
                            <div class="form-grid">
                                <div>
                                    <label>Tên đầy đủ</label>
                                    <input type="text" name="fullname" value="${requestScope.fullname != null ? requestScope.fullname : ''}"placeholder="vui lòng nhập tên đầy đủ">
                                </div>
                                <div>
                                    <label for="gender">Giới tính</label>
                                    <select id="gender" name="gender">
                                        <option value="MALE" ${requestScope.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${requestScope.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${requestScope.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                <div>
                                    <label for="dob">Ngày sinh</label>
                                    <div class="date-group">
                                        <input type="date" id="dob" name="dob" lang="vi" value="${requestScope.dobFormatted != null ? requestScope.dobFormatted : ''}"
                                               placeholder="yyyy-MM-dd">
                                    </div>
                                </div>
                                <div>
                                    <label>Thành phố cư trú</label>
                                    <input type="text" name="address" value="${requestScope.address != null ? requestScope.address : ''}" placeholder="Thành phố cư trú">
                                </div>
                            </div>
                            <div class="actions">
                                <button class="btn-secondary">Để sau</button>
                                <button class="btn-primary" >Lưu</button>
                            </div>

                        </form>

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

            </div>
        </div>
        <!-- =================== MODAL THÊM EMAIL =================== -->

        <div id="addEmailModal" class="modal-overlay">
            <div class="modal-content">
                <h3>THÊM EMAIL</h3>
                <p>Thêm email đang sử dụng của bạn để đăng nhập và nhận thông báo </p>

                <form action="${pageContext.request.contextPath}/addEmail" method="POST">
                    <label for="emailInput">Email </label>
                    <input type="email" id="emailInput" name="email" placeholder="Ví dụ: yourname@email.com">
                    <div class="modal-actions">
                        <button type="submit" class="btn-save">Lưu</button>
                        <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                    </div>

                </form>




            </div>
        </div>  
        <!-- Js thêm email -------------------------------------------------->
        <script>
            // Mở modal khi bấm “+ Thêm email”
            document.querySelector('.btn-outline.w-25.mt-2').addEventListener('click', function () {
                document.getElementById('addEmailModal').style.display = 'flex';
            });

            // Đóng modal
            function closeModal() {
                document.getElementById('addEmailModal').style.display = 'none';
            }

            // Đóng khi click ra ngoài modal
            window.onclick = function (event) {
                const modal = document.getElementById('addEmailModal');
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            }
        </script>                  

        <!-- =================== MODAL THÊM Phones =================== -->

        <div id="addPhoneModal" class="modal-overlay">
            <div class="modal-content">
                <h3>THÊM SỐ ĐIỆN THOẠI</h3>
                <p>Thêm số điện thoại đang sử dụng của bạn để đăng nhập và nhận thông báo</p>
                <form action="${pageContext.request.contextPath}/addPhone" method="post">
                    <label for="phoneInput">Điện thoại</label>
                    <div class="phone-group">
                        <span class="country-code">+84</span>
                        <input type="text" id="phoneInput" name="phone" placeholder="Ví dụ: 012345678" pattern="[0-9]{9,11}" required>
                    </div>
                    <div class="modal-actions">
                        <button type="submit" class="btn-save">Lưu</button>
                        <button type="button" class="btn-cancel" onclick="closePhoneModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Js them so dien thoai  -------------------------------------------------->  

        <script>
            // Mở modal Thêm số điện thoại
            document.querySelectorAll('.btn-outline.w-25.mt-2').forEach(btn => {
                if (btn.textContent.includes('số di động')) {
                    btn.addEventListener('click', function () {
                        document.getElementById('addPhoneModal').style.display = 'flex';
                    });
                }
            });

            // Đóng modal
            function closePhoneModal() {
                document.getElementById('addPhoneModal').style.display = 'none';
            }

            // Đóng khi click ra ngoài modal
            window.addEventListener('click', function (event) {
                const modal = document.getElementById('addPhoneModal');
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        </script>


        <!-- =================== Js for sidebar menu =================== -->               
        <script>
            function showMainSection(evt, sectionId) {
                // Ẩn toàn bộ các main-section
                document.querySelectorAll(".main-section , .account-container").forEach(s => s.style.display = "none");

                // Hiển thị phần được chọn
                const selected = document.getElementById(sectionId);
                if (selected)
                    selected.style.display = "block";

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
