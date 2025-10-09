
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
                        
         <!-- lay thong tin customerProfile --> 
         <%
                            CustomerProfile profile = (CustomerProfile)session.getAttribute("profile_customer");
%>
         
    </head>
    <body class="profile" >

        <div class="profile-container">
            <!-- SIDEBAR -->
            <div class="profile-sidebar">
                <div class="profile-header">
                    
         <!-- form avatar customer-------------->  
         
  <div class="profile-sidebar text-center p-4">
    <div class="avatar-wrapper mx-auto">
        <img 
            src="<%= (profile != null && profile.getProfilePicture() != null) ? profile.getProfilePicture() : "https://via.placeholder.com/150/eeeeee/aaaaaa?text=Avatar" %>" 
            class="profile-avatar" 
            alt="Avatar">
        <div class="overlay">
            <label for="avatarFile" class="change-photo">
                <i class="bi bi-camera-fill"></i> Thay ảnh
            </label>
        </div>
    </div>

     <form id="avatarForm" 
        action="<%=request.getContextPath()%>/UploadAvatarServlet" 
        method="post" 
        enctype="multipart/form-data" 
        style="display: inline;">
    <input type="file" id="avatarFile" name="avatar" accept="image/*" 
           style="display:none" 
           onchange="document.getElementById('avatarForm').submit();">
  </form>

    <div class="profile-info mt-3">
        <h5 class="fw-bold mb-1 text-primary font-weight-bold">${sessionScope.user.fullName}</h5>
        <p class="text-muted mb-0">Google</p>
    </div>
</div>
               
                </div>

                <div class="profile-rank">
                    <i class="bi bi-award-fill"></i>
                    <span>Bạn là thành viên <b>Bronze Priority</b></span>
                </div>

                <div class="profile-menu">
                    <a href="#" onclick="showMainSection(event, 'points')"><i class="bi bi-coin"></i> Thẻ của tôi</a>
                    <a href="#" onclick="showMainSection(event, 'bookings')"><i class="bi bi-calendar2-check"></i> Đặt chỗ của tôi</a>
                    <a href="#" onclick="showMainSection(event, 'transactions')"><i class="bi bi-list-ul"></i> Giao dịch</a>
                    <a href="#" onclick="showMainSection(event, 'notifications')"><i class="bi bi-bell"></i> Thông báo</a>
                    <a href="#" onclick="showMainSection(event, 'setting')"><i class="bi bi-gear"></i> Cài đặt</a>
                    <a href="#" onclick="showMainSection(event, 'account')" class="active"><i class="bi bi-person"></i> Tài khoản</a>
                    <a  href="#" data-toggle="modal" data-target="#logoutModal"class="logout text-danger"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>

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

            <div id="points" class="main-section" style="display:none;">Nội dung điểm...</div>

            <!-- booking content -->
            <div id="bookings" class="main-section" style="display:none;">Nội dung Đặt chỗ của tôi...</div>

            <!--  content -->
            <div id="transactions" class="main-section" style="display:none;">Nội dung giao dịch của tôi...</div>

            <!-- account and securit content --> 
            <div class="account-container">
                <div class="tab-header-account">
                    <button class="active w-auto font-weight-bold" onclick="showAccountTab(event, 'profile')">Thông tin tài khoản</button>

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
                                                📧 <span>${email.email}</span>
                                            </div>
                                            <div>
                                                <button type="submit" name="action" value="makePrimary-${email.emailId}" class="btn btn-sm btn-outline-success me-2">
                                                    ✅
                                                </button>
                                                <button type="submit" name="action" value="delete-${email.emailId}" class="btn btn-sm btn-outline-danger">
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
                                            📧 <span>${email.email}</span>
                                        </div>
                                        <div>
                                            <button type="submit" name="action_current" value="delete-${email.emailId}" class="btn btn-sm btn-outline-danger">
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
                                                📱 <span>${phone.phone}</span>
                                            </div>
                                            <div>
                                                <button type="submit" name="action" value="delete-${phone.phoneId}" class="btn btn-sm btn-outline-danger">
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
                                            📱 <span>${phone.phone}</span>
                                        </div>
                                        <div>
                                            <button type="submit" name="action_current" value="delete-${phone.phoneId}" class="btn btn-sm btn-outline-danger">
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

                    <%@ include file="/views/common/script.jsp" %>
                    </body>
                    </html>
