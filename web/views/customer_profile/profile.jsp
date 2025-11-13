
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.CustomerProfile" %>


<html lang="vi">
    <head>
        <%@ include file="/views/common/css.jsp" %>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <style>
            /* tranh bi ghi de color boostrap
            
                .modal .btn-primary,
   #addEmailModal .btn-primary {
       background-color: #007bff !important;
       border-color: #007bff !important;
       color: #fff !important;
   }
   
   .modal .btn-primary:hover,
   #addEmailModal .btn-primary:hover {
       background-color: #0069d9 !important;
       border-color: #0062cc !important;
   }
                    
            */

            /* edit input add email*/
            #emailInput {
                height: 50px !important;
                font-size: 15px;
                padding: 6px 12px;
                line-height: 1.2;
            }

            #emailInput::placeholder {
                font-size: 13px;
                color: #999;
            }


            #phoneInput {
                height: 40px !important;
                font-size: 15px;
                padding: 6px 12px;
                line-height: 1.2;
            }

            .input-group-text {
                height: 40px !important;
                padding: 4px 10px !important;
                font-size: 14px;
                line-height: 1.2;
            }

            #phoneInput::placeholder {
                font-size: 13px;
                color: #999;
            }

        </style>
        <!-- lay thong tin user -->
        <%
                                    User user = (User)session.getAttribute("user");
        %>

        <!-- lay thong tin customerProfile-------------------------------------------------------- --> 
        <%
                           CustomerProfile profile_customer = (CustomerProfile)session.getAttribute("profile_customer");
                            
        %>
        
                   <!-- lay thong tin user và athorized -->
        
    <%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }
if (currentUser != null) {
    int roleId = currentUser.getRoleId();

    if (roleId != 1 && roleId != 3) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>

    </head>
    <body class="profile" >
        <div class="profile-container">
            <!-- SIDEBAR -->
            <div class="profile-sidebar">
                <div class="profile-header">

                    <!-- form avatar customer-------------->  

                    <div class="profile-sidebar-avatar text-center p-4 mr-auto">
                        <div class="avatar-wrapper mx-auto">
                        
                            <img 
                                id="avatarPreview"
                                src="${profile_customer != null && profile_customer.profilePicture != null
      ? pageContext.request.contextPath.concat('/Avatar_DisplayServlet?file=').concat(profile_customer.profilePicture)
      : 'https://via.placeholder.com/150/eeeeee/aaaaaa?text=Avatar'}"
                                class="profile-avatar"
                                alt="Avatar">
                            <div class="overlay">
                                <label for="avatarFile" class="change-photo">
                                    <i class="bi bi-camera-fill"></i> Thay ảnh
                                </label>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/Upload_AvatarServlet" 
                              method="POST" enctype="multipart/form-data" class="upload-form">
                            <input type="file" id="avatarFile" name="avatarFile" accept="image/*" 
                                   class="d-none"  onchange="previewAvatar(event)">
                          
                        
                        </form>

                        <div class="profile-info mt-3">
                               <div class="w-100 mt-3 mb-1 text-primary"> <i class="bi bi-person-badge-fill"></i> ${sessionScope.user.fullName}  </div>
                            
                            <p class="text-muted mb-0">
                                  ${sessionScope.profile_customer.loyaltyPoints}
                                <i class="bi bi-coin text-warning me-1"></i>
                              
                            </p>
                        </div>
                    </div>

                    <!-- xử lý ảnh trước khi upload  -->
                    <script>    
                        // Preview ảnh và auto upload
                        function previewAvatar(event) {
                            const file = event.target.files[0];
                            if (file) {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    document.getElementById('avatarPreview').src = e.target.result;
                                };
                                reader.readAsDataURL(file);

                                // Tự động gửi form sau khi chọn file
                                setTimeout(() => {
                                    event.target.form.submit();
                                }, 2000);
                            }
                        }

                    </script>


                </div>


                <div class="profile-menu">
                    <a href="#" onclick="showMainSection(event, 'member-priority')"><i class="bi bi-award"></i> Membership Level</a>
                    <a href="#" onclick="showMainSection(event, 'historyBookings')"><i class="bi bi-calendar2-check"></i> Lịch sử đặt chỗ</a>
                    <a href="#" onclick="showMainSection(event, 'favorites')"><i class="bi bi-heart-fill"></i>Tours and Services</a>
                    <a href="#" onclick="showMainSection(event, 'account')"><i class="bi bi-gear"></i> Tài khoản</a>
                    <a href="#" data-toggle="modal" data-target="#logoutModal"class="logout text-danger"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                     <a href="${pageContext.request.contextPath}/SearchIslandController" class="back-link" style="color:#007BFF">
    <i class="fa fa-arrow-left"></i> Quay lại trang chủ
  </a>
                </div>
                                
            </div>

            <!-- ===================== logout modal profile ===================== -->        
            <div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content logout-box">

                        <!-- Body -->
                        <div class="logout-body text-center p-4">
                            <h2 class="logout-header text-primary mb-3 ">Xác nhận đăng xuất</h2>
                            <h5>
                                Nếu bạn đăng xuất, bạn sẽ không thể quản lý trang thông tin hiện tại.<br>
                                Bạn có chắc chắn muốn thoát khỏi không?
                            </h5>
                            <div class="mt-4">
                                <button class="btn mr-2 font-weight-bold" data-dismiss="modal">Không</button>
                                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout btn-primary">Có</a>
                            </div>
                        </div>

                    </div>
                </div>
            </div>




            <!-- ===================== CONTENT ===================== -->
            <!-- point content -->

            <div id="member-priority" class="membership-container main-section">
                <div class="tab-header-membership text-center mb-4 "style="width: 100%;">
                    <img 
                        src="${pageContext.request.contextPath}/views/home/images/island_Bg.jpg"
                        alt="Membership Banner"
                        class="img-fluid rounded-3 shadow-sm w-100"
                        "
                        >
                </div>

                <div class="text-center mb-4 w-auto" >
                    <span class="badge bg-gradient" 
                          style="background: linear-gradient(to right, #d97706, #b45309); font-size: 1.1rem; padding: 10px 20px; border-radius: 20px; color: #FFF">
                        🏅 Bạn là thành viên <strong>  ${sessionScope.profile_customer.membershipLevel}</strong>
                    </span>
                </div>
                <section class="membership-info container my-5">
                    <h3>Hệ thống hạng thành viên & Ưu đãi</h3>
                    <div class="row justify-content-center g-4">

                        <div class="col-md-6 col-lg-3">
                            <div class="membership-card bronze">
                                <div class="level-icon">🥉</div>
                                <h5>Bronze</h5>
                                <p>Dưới 800.000 điểm</p>
                                <ul>
                                    <li>• Nhận quà sinh nhật hoặc sự kiện đặc biệt</li>
                                    <li>• Nhận thông báo ưu đãi sớm</li>
                                    <li>• Cộng điểm tích lũy khi thanh toán</li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-3">
                            <div class="membership-card silver">
                                <div class="level-icon">🥈</div>
                                <h5>Silver</h5>
                                <p>Từ 800.000 đến 5.000.000 điểm</p>
                                <ul>
                                    <li>• Giảm 10% cho mọi dịch vụ và gói tour</li>
                                    <li>• Miễn phí 1 lần đổi dịch vụ mỗi tháng</li>
                                    <li>• Ưu tiên hỗ trợ khách hàng</li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-3">
                            <div class="membership-card gold">
                                <div class="level-icon">🥇</div>
                                <h5>Gold</h5>
                                <p>Từ  5.000.000 đến 10.000.000 điểm</p>
                                <ul>
                                    <li>• Giảm 15% cho mọi dịch vụ và gói tour</li>
                                    <li>• Tặng voucher sinh nhật trị giá 100.000đ</li>
                                    <li>• Ưu tiên đặt dịch vụ trước</li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-3">
                            <div class="membership-card platinum">
                                <div class="level-icon">💎</div>
                                <h5>Platinum</h5>
                                <p>Từ 10.000.000 điểm trở lên</p>
                                <ul>
                                    <li>• Giảm 20% cho mọi DỊCH VỤ KÈM GÓI TOUR</li>
                                    <li>• Có nhân viên chăm sóc riêng</li>
                                    <li>• Quyền truy cập sớm các chương trình VIP</li>
                                </ul>
                            </div>
                        </div>

                    </div>
                </section>
            </div>
                  <!-- historyBooking content ----------------------------------------->       
            
                  <div id="historyBookings" class="historyBookings-container main-section">

    <!-- Banner -->
    <div class="tab-header-historyBookings text-center mb-4 w-100">
        <img 
            src="${pageContext.request.contextPath}/views/home/images/island_Bg.jpg"
            alt="historyBookings Banner"
            class="img-fluid rounded-3 shadow-sm w-100">
    </div>

    <!-- Tiêu đề -->
    <div class="text-center mb-4 w-auto">
        <span class="badge bg-gradient" 
              style="background: linear-gradient(to right, #d97706, #b45309);
                     font-size: 1.1rem; padding: 10px 20px; border-radius: 20px; color: #FFF">
            🔔 Lịch sử đặt tour của bạn
        </span>
    </div>

   <!-- Tiêu đề phụ / thông báo -->
<div class="text-center mb-3">
    <p class="fw-bold text-success mb-0" style="font-size: 20px;">
        Những lần <strong>Booking Tour</strong>  gần nhất của bạn
    </p>
</div>
   <hr>
 <div class="text-center mb-3">
                          <a class="btn btn-primary btn-reload" href="${pageContext.request.contextPath}/FullHistoryBooking?section=historyBookings#" >Hiển thị lịch sử</a>
                      </div>

    <!-- Nếu không có lịch sử -->
    <c:if test="${empty historyList}">
        <p class="text-center text-muted mt-3">Không có lịch sử đặt tour nào.</p>
    </c:if>

    <!-- List nội dung -->
    <div class="container mt-4">
        <ul class="list-group list-group-flush">
            <c:forEach var="history" items="${historyList}">
                <li class="list-group-item d-flex justify-content-between align-items-center py-3">

                    <!-- Thông tin khách -->
                    <div class="d-flex flex-column flex-md-row w-100 justify-content-between align-items-md-center">

                        <div class="me-md-3">
                            <p class="mb-1 fw-semibold">👤 ${history.customerName}</p>
                            <p class="mb-1 text-muted">📧 ${history.customerEmail}</p>
                            <p class="mb-1 text-muted">☎️ ${history.customerPhone}</p>
                        </div>

                        <div class="me-md-3 text-md-center">
                            <p class="mb-1 text-muted">
                                🕓 <fmt:formatDate value="${history.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </p>
                        </div>

                        <div class="text-md-end mt-2 mt-md-0">
                            <span class="badge px-3 py-2 
                                ${history.tourStatus == 'COMPLETED' ? 'bg-success text-white' : 
                                  (history.tourStatus == 'INCOMPLETE' ? 'bg-danger' : 'bg-warning text-dark')} fw-semibold">
                                ${history.tourStatus}
                            </span>
                        </div>

                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>

</div>

     
          <!-- favorites content ----------------------------------------->
  
                <div id="favorites" class="favorites-container main-section" style="display:none;">

                    <!-- Banner -->
                    <div class="tab-header-favorites text-center mb-4 w-100">
                        <img 
                            src="${pageContext.request.contextPath}/views/home/images/island_Bg.jpg"
                            alt="favorites Banner"
                            class="img-fluid rounded-3 shadow-sm w-100">
                    </div>

                    <!-- Tiêu đề -->
                    <div class="text-center mb-4 w-auto">
                        <span class="badge bg-gradient" 
                              style="background: linear-gradient(to right, #d97706, #b45309);
                              font-size: 1.1rem; padding: 10px 20px; border-radius: 20px; color: #FFF">
                            ❤️ Danh sách yêu thích của tôi
                        </span>
                    </div>

                    <!-- Nút reload -->
                    <div class="text-center mb-3">
                        <a class="btn btn-primary btn-reload" 
                           href="${pageContext.request.contextPath}/customer/favorites">
                            🔄 Hiển thị danh sách yêu thích
                        </a>
                    </div>

                    <!-- Nếu danh sách trống -->
                    <c:if test="${empty favoriteList}">
                        <p class="text-center text-muted mt-3">Bạn chưa có dịch vụ nào được thêm vào yêu thích.</p>
                    </c:if>

                    <!-- Hiển thị danh sách yêu thích -->
                    <div class="container mt-4">
                        <c:forEach var="fav" items="${favoriteList}">
                            <div class="card mb-3 shadow-sm border-1 rounded-3 favorites-card" 
                                 data-fav-id="${fav.refId}" data-service="${fav.serviceType}">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="fw-bold mb-1">${fav.serviceType}</p>
                                        <small class="text-muted">
                                            Ngày thêm: 
                                            <fmt:formatDate value="${fav.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </small>
                                    </div>
                                    <button type="button" class="btn btn-outline-danger btn-sm btn-remove-fav">
                                        💔 Bỏ thích
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Script xử lý bỏ thích -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        document.querySelectorAll('.btn-remove-fav').forEach(btn => {
                            btn.addEventListener('click', function () {
                                const card = this.closest('.favorites-card');
                                const refId = card.dataset.favId;
                                const serviceType = card.dataset.service;
                                const contextPath = '<%= request.getContextPath() %>';

                                fetch(`${contextPath}/favorite?action=remove&refId=${refId}&serviceType=${serviceType}`, {
                                                    method: 'POST'
                                                }).then(response => {
                                                    if (response.ok) {
                                                        // ✅ Xóa khỏi giao diện
                                                        card.remove();
                                                    } else {
                                                        alert("Không thể bỏ thích. Vui lòng thử lại!");
                                                    }
                                                }).catch(err => console.error("Lỗi:", err));
                                            });
                                        });
                                    });
                </script>
                
            
            <!-- account and securit content --------------------------------------------------------> 
            <div id="account" class="account-container main-section " >
                <div class="tab-header-account">
                    <span class="active w-auto text-primary font-weight-bold mb-2" >Thông tin tài khoản</span>

                </div>

                <!-- Thông báo lỗi  -->
                <% String error = (String)session.getAttribute("errorMess") ; %>
                <% if(error !=null){%>

                <div id="errorAlertProfile" class="alert alert-danger alert_style" role="alert">
                    <%=error%>
                </div>
                <!-- set time display loi  ------------------------------------------------------>
                <script>
                    setTimeout(function () {
                        var alertBox = document.getElementById("errorAlertProfile");
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

                <div id="successAlertProfile" class="alert alert-success alert_style" role="alert">
                    <%=success%>
                </div>
                <!-- set time display loi  -->
                <script>
                    setTimeout(function () {
                        var alertBox = document.getElementById("successAlertProfile");
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
                                    <input type="text" name="fullname"  value="${not empty requestScope.fullname ? requestScope.fullname : sessionScope.user.fullName}"placeholder="vui lòng nhập tên đầy đủ">
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
                                        <input type="date" id="dob" name="dob" lang="vi" value="${not empty requestScope.dobFormatted  ? requestScope.dobFormatted :sessionScope.profile_customer.dateOfBirth}"
                                               placeholder="yyyy-MM-dd">
                                    </div>
                                </div>
                                <div>
                                    <label>Thành phố cư trú</label>
                                    <input type="text" name="address" value="${not empty requestScope.address  ? requestScope.address :  sessionScope.profile_customer.address}" placeholder="Thành phố cư trú">
                                </div>
                            </div>
                            <div class="actions">
                                <button class="btn-secondary" >Để sau</button>
                                <button class="btn-primary" >Lưu</button>
                            </div>

                        </form>

                    </section>
                    <!-- ====================================== EMAIL SECTION =================== -->
                    <section class="card p-3 shadow-sm">
                        <!-- ============================== Thông báo thành công về email ============================== --> 
                        <% String successEmail = (String) session.getAttribute("successEmail"); %>
                        <% if (successEmail != null) { %>
                        <div id="successAlertEmail" class="alert alert-success alert_style" role="alert">
                            <%= successEmail %>
                        </div>
                        <!-- set time display loi  ------------------------------------------------------>
                        <script>
                            setTimeout(function () {
                                var alertBox = document.getElementById("successAlertEmail");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 2000);
                        </script>
                        <% session.removeAttribute("successEmail"); %>
                        <% } %>

                        <!-- ============================== Thông báo lỗi khi xóa email ============================== --> 
                        <% String errorEmail_Deleted = (String) session.getAttribute("errorEmail_Deleted"); %>
                        <% if (errorEmail_Deleted != null) { %>
                        <div id="errorDeleted_AlertEmail" class="alert alert-danger alert_style" role="alert">
                            <%= errorEmail_Deleted %>
                        </div>
                        <!-- set time thong bao loi -->
                        <script>
                            setTimeout(function () {
                                var alertBox = document.getElementById("errorDeleted_AlertEmail");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 2000);
                        </script>
                        <% session.removeAttribute("errorEmail_Deleted"); %>
                        <% } %>

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h3 class="mb-0">Email</h3>
                            <h4 class="text-muted" style="font-size: 13px;">Chỉ có thể sử dụng tối đa 3 email</h4>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="openEmailModal()">+ Thêm</button>
                        </div>

                        <!-- ==================== Danh sách email chính (saved_Email) ==================== -->
                        <div class="border rounded p-3 bg-light mb-3">
                            <strong>Email chính:</strong>
                            <span class="text-primary">${user.email}</span>

                            <form id="emailForm" action="${pageContext.request.contextPath}/saved_Email" method="post">
                                <div class="email-list">
                                    <c:forEach var="email" items="${sessionScope.emailList}">
                                        <div class="email-item d-flex justify-content-between align-items-center border p-2 rounded mb-2">
                                            <div>
                                                📧 <span>${email.contactValue}</span>
                                            </div>
                                            <div>
                                                <button type="submit" name="action" value="makePrimary-${email.contactId}" class="btn btn-sm btn-outline-success me-2">
                                                    ✅
                                                </button>
                                                <button type="submit" name="action" value="delete-${email.contactId}" class="btn btn-sm btn-outline-danger">
                                                    🗑️
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </form>
                        </div>

                        <!-- ==================== Danh sách email phụ (Secondary_CurrentEmail) ==================== -->
                        <h4 class="font-weight-bold mt-3" style="font-size: 15px;">Danh sách email phụ:</h4>

                        <c:if test="${empty sessionScope.emailList_Current}">
                            <p>Chưa có email phụ nào.</p>
                        </c:if>

                        <form id="Current_emailForm" action="${pageContext.request.contextPath}/Secondary_CurrentEmail" method="post">
                            <div class="Current_email-list">
                                <c:forEach var="email" items="${sessionScope.emailList_Current}">
                                    <div class="email-item d-flex justify-content-between align-items-center border p-2 rounded mb-2">
                                        <div>
                                            📧 <span>${email.contactValue}</span>
                                        </div>
                                        <div>
                                            <button type="submit" name="action_current" value="delete-${email.contactId}" class="btn btn-sm btn-outline-danger">
                                                🗑️
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </form>
                    </section>




                    <!-- ============================== PHONE SECTION ============================== -->

                    <!-- ============================== Thông báo thành công và lỗi về phone ============================== -->
                    <section class="card p-3 shadow-sm">

                        <% String successPhone = (String) session.getAttribute("successPhone"); %>
                        <% if (successPhone != null) { %>
                        <div id="successPhoneAlert" class="alert alert-success alert_style" role="alert">
                            <%= successPhone %>
                        </div>
                        <!-- set time thong bao loi -->
                        <script>
                            setTimeout(function () {
                                var alertBox = document.getElementById("successPhoneAlert");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 2000);
                        </script>
                        <% session.removeAttribute("successPhone"); %>
                        <% } %>

                        <!-- set time thong bao loi -->
                        <% String errorPhone_Deleted = (String) session.getAttribute("errorPhone_Deleted"); %>
                        <% if (errorPhone_Deleted != null) { %>
                        <div id="errorDeleted_PhoneAlert" class="alert alert-danger alert_style" role="alert">
                            <%= errorPhone_Deleted %>
                        </div>
                        <script>
                            setTimeout(function () {
                                var alertBox = document.getElementById("errorDeleted_PhoneAlert");
                                if (alertBox) {
                                    alertBox.style.display = "none";
                                }
                            }, 2000);
                        </script>
                        <% session.removeAttribute("errorPhone_Deleted"); %>
                        <% } %>

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h3 class="mb-0">Số di động</h3>
                            <h4 class="text-muted" style="font-size: 13px;">Chỉ có thể sử dụng tối đa 3 số điện thoại</h4>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="openPhoneModal()">+ Thêm</button>
                        </div>

                        <div class="border rounded p-3 bg-light mb-3">
                            <strong>Số chính:</strong>
                            <span class="text-primary">${user.phone}</span>

                            <!-- =================== Danh sách số điện thoại phụ (Secondary_Phone) =================== -->
                            <form id="phoneForm" action="${pageContext.request.contextPath}/Secondary_Phone" method="post">
                                <div class="phone-list">
                                    <c:forEach var="phone" items="${sessionScope.phoneList}">
                                        <div class="phone-item d-flex justify-content-between align-items-center border p-2 rounded mb-2">
                                            <div>
                                                📱 <span>${phone.contactValue}</span>
                                            </div>
                                            <div>
                                                <button type="submit" name="action" value="delete-${phone.contactId}" class="btn btn-sm btn-outline-danger">
                                                    🗑️
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </form>
                        </div>

                        <h4 class="font-weight-bold mt-3" style="font-size: 15px;">Danh sách số điện thoại phụ:</h4>

                        <c:if test="${empty sessionScope.phoneList_Current}">
                            <p>Chưa có số điện thoại phụ nào.</p>
                        </c:if>

                        <!-- =================== Danh sách current Phone (Secondary_CurrentPhone) =================== -->
                        <form id="Current_phoneForm" action="${pageContext.request.contextPath}/Secondary_CurrentPhone" method="post">
                            <div class="Current_phone-list">
                                <c:forEach var="phone" items="${sessionScope.phoneList_Current}">
                                    <div class="phone-item d-flex justify-content-between align-items-center border p-2 rounded mb-2">
                                        <div>
                                            📱 <span>${phone.contactValue}</span>
                                        </div>
                                        <div>
                                            <button type="submit" name="action_current" value="delete-${phone.contactId}" class="btn btn-sm btn-outline-danger">
                                                🗑️
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </form>

                    </section>


                    <!-- =================== MODAL THÊM EMAIL =================== -->

                    <div class="modal fade" id="addEmailModal" tabindex="-1" role="dialog" aria-labelledby="addEmailModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content custom-modal">

                                <!-- Header -->
                                <div class="modal-header border-0">
                                    <h5 class="modal-title text-primary font-weight-bold" id="addEmailModalLabel">
                                        ✉️ Thêm Email
                                    </h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Đóng">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>

                                <!-- Body -->
                                <div class="modal-body">
                                    <!-- Thông báo lỗi -->
                                    <% String errorEmail = (String) session.getAttribute("errorEmail"); %>
                                    <% if (errorEmail != null) { %>
                                    <div id="errorAlertEmailModal" class="alert alert-danger alert_style"><%= errorEmail %></div>
                                    <% } %>

                                    <script>

                                        setTimeout(function () {
                                            var alertBox = document.getElementById("errorAlertEmailModal");
                                            if (alertBox) {
                                                alertBox.style.display = "none";
                                            }
                                        }, 2000);
                                    </script>

                                    <p class="text-muted mb-3">
                                        Nhập địa chỉ email bạn đang sử dụng để đăng nhập và nhận thông báo.
                                    </p>

                                    <!-- Form -->
                                    <form action="${pageContext.request.contextPath}/email_Added"  method="POST">
                                        <div class="form-group">
                                            <label for="emailInput" class="form-label text-primary font-weight-bold" style="font-size:18px;" >Email</label>
                                            <input type="email" class="form-control form-control-sm " id="emailInput"
                                                   name="email" placeholder="📧 Ví dụ: yourname@email.com" >
                                        </div>

                                        <div class="modal-footer border-0 mt-3 d-flex flex-column">
                                            <button type="submit" class="btn btn-primary w-100 mb-2">Lưu</button>
                                            <button type="button" class="btn btn-secondary w-100" data-dismiss="modal">Hủy</button>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- =================== AUTO MỞ MODAL KHI CÓ LỖI =================== -->
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                        <% boolean hasError = (session.getAttribute("errorEmail") != null);
                           if (hasError) { %>
                            $('#addEmailModal').modal('show');
                        <% 
        
                            session.removeAttribute("errorEmail");
                           } 
                        %>
                        });
                    </script>

                    <!--------- JS MỞ/ĐÓNG MODAL-------------------------------------------------->
                    <script>
                        function openEmailModal() {
                            $('#addEmailModal').modal('show');
                        }

                        function closeEmailModal() {
                            $('#addEmailModal').modal('hide');
                        }
                    </script>


                    <!-- =================== MODAL THÊM SỐ ĐIỆN THOẠI =================== -->
                    <div class="modal fade" id="addPhoneModal" tabindex="-1" role="dialog" aria-labelledby="addPhoneModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content custom-modal">

                                <!-- Header -->
                                <div class="modal-header border-0">
                                    <h5 class="modal-title text-primary font-weight-bold" id="addPhoneModalLabel">
                                        📞 Thêm Số Điện Thoại
                                    </h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Đóng">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>

                                <!-- Body -->
                                <div class="modal-body">
                                    <% String errorPhone = (String) session.getAttribute("errorPhone"); %>
                                    <% if (errorPhone != null) { %>
                                    <div id="errorPhoneAlert" class="alert alert-danger alert_style"><%= errorPhone %></div>
                                    <% } %>

                                    <script>
                                        setTimeout(function () {
                                            var alertBox = document.getElementById("errorPhoneAlert");
                                            if (alertBox) {
                                                alertBox.style.display = "none";
                                            }
                                        }, 2000);
                                    </script>

                                    <p class="text-muted mb-3">
                                        Thêm số điện thoại bạn đang sử dụng để đăng nhập và nhận thông báo.
                                    </p>

                                    <!-- Form -->
                                    <form action="${pageContext.request.contextPath}/phone_Added" method="POST">
                                        <div class="form-group">
                                            <label for="phoneInput" class="form-label text-primary font-weight-bold ">Số điện thoại</label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">+84</span>
                                                </div>
                                                <input type="text" class="form-control" id="phoneInput" 
                                                       name="phone" placeholder="Ví dụ: 912345678" 
                                                       pattern="[0-9]{9,11}" >
                                            </div>
                                        </div>

                                        <div class="modal-footer border-0 mt-3 d-flex flex-column">
                                            <button type="submit" class="btn btn-primary w-100 mb-2">Lưu</button>
                                            <button type="button" class="btn btn-secondary w-100" data-dismiss="modal">Hủy</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                                        </div>
                                        </div>

                    <!-- =================== AUTO MỞ MODAL KHI CÓ LỖI =================== -->
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                        <% boolean hasPhoneError = (session.getAttribute("errorPhone") != null);
                           if (hasPhoneError) { %>
                            $('#addPhoneModal').modal('show');
                        <% 
                            session.removeAttribute("errorPhone");
                           } 
                        %>
                        });
                    </script>

                    <!-- =================== JS MỞ/ĐÓNG MODAL =================== -->
                    <script>
                        function openPhoneModal() {
                            $('#addPhoneModal').modal('show');
                        }

                        function closePhoneModal() {
                            $('#addPhoneModal').modal('hide');
                        }
                    </script>


                    <!-- =================== Js for sidebar menu =================== -->               
               <script>
                   
// =================== Hiển thị section chính ===================
function showMainSection(evt, sectionId) {
    evt.preventDefault(); // Ngăn reload page
    console.log("Showing section: " + sectionId);

    // Ẩn tất cả section
    document.querySelectorAll(".main-section, .account-container").forEach(s => s.style.display = "none");

    // Hiển thị section được chọn
    const selected = document.getElementById(sectionId);
    if (selected) selected.style.display = "block";

    // Nếu là account, hiển thị container account
    if (sectionId === 'account') {
        const accountContainer = document.querySelector(".account-container");
        if (accountContainer) accountContainer.style.display = "block";
    }

    // Cập nhật class active cho menu
    document.querySelectorAll(".profile-menu a").forEach(a => a.classList.remove("active"));
    evt.currentTarget.classList.add("active");
}

// =================== Điều khiển tab con trong Account ===================
function showAccountTab(evt, tabId) {
    // Ẩn tất cả tab-content
    document.querySelectorAll(".account-container .tab-content").forEach(c => c.classList.remove("active"));
    document.querySelectorAll(".tab-header-account button").forEach(b => b.classList.remove("active"));

    // Hiển thị tab được chọn
    const selectedTab = document.getElementById(tabId);
    if (selectedTab) selectedTab.classList.add("active");

    evt.currentTarget.classList.add("active");
}

// =================== Khởi tạo section khi trang được tải ===================
document.addEventListener("DOMContentLoaded", function () {
    // Ẩn tất cả section
    document.querySelectorAll(".main-section, .account-container").forEach(s => s.style.display = "none");

  

    // Cập nhật class active cho menu mặc định
    const defaultMenuLink = Array.from(document.querySelectorAll(".profile-menu a"))
        .find(a => {
            const onclick = a.getAttribute("onclick");
            return onclick && onclick.includes(defaultSectionId);
        });
    if (defaultMenuLink) defaultMenuLink.classList.add("active");
});


document.addEventListener("DOMContentLoaded", function () {
    // Ẩn tất cả
    document.querySelectorAll(".main-section, .account-container").forEach(s => s.style.display = "none");

    // Lấy section từ URL query param
    const params = new URLSearchParams(window.location.search);
    const section = params.get('section') || 'account'; // default nếu không có

    const selectedSection = document.getElementById(section);
    if (selectedSection) selectedSection.style.display = "block";

    // Cập nhật active menu
    const menuLink = Array.from(document.querySelectorAll(".profile-menu a"))
        .find(a => a.getAttribute("onclick")?.includes(section));
    if (menuLink) menuLink.classList.add("active");
});


// Hàm helper kiểm tra danh sách rỗng
function checkEmptyList(cardSelector, emptyMessage, containerSelector) {
    const list = document.querySelectorAll(cardSelector);
    const container = document.querySelector(containerSelector);

    // Xóa thông báo rỗng cũ nếu tồn tại
    const existingEmptyMsg = container.querySelector(".text-center.text-muted.mt-3");
    if (existingEmptyMsg) {
        existingEmptyMsg.remove();
    }

    // Kiểm tra và thêm thông báo rỗng nếu danh sách trống
    if (list.length === 0 && container) {
        const emptyMsg = document.createElement("p");
        emptyMsg.textContent = emptyMessage;
        emptyMsg.classList.add("text-center", "text-muted", "mt-3");
        container.appendChild(emptyMsg);
    }
}
</script>

                    <%@ include file="/views/common/script.jsp" %>
 </body>
</html>