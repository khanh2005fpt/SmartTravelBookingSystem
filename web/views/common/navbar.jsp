<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.CustomerProfile" %>

<!-- lay thong tin user tu session  -->
<%
    User user = (User)session.getAttribute("user");
%>

<!-- lay thong tin customer_profile tu session  -->
<%
                         CustomerProfile profile_customer = (CustomerProfile)session.getAttribute("profile_customer");
                  
%>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/SearchIslandController">Meland<span>Công ty Du lịch</span></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" 
                aria-controls="ftco-nav" aria-expanded="false" aria-label="Chuyển đổi điều hướng">
            <span class="oi oi-menu"></span> Menu
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
            <link rel="stylesheet" href="views/home/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/views/home/css/style1.css">
        </button>
        <div class="collapse navbar-collapse" id="ftco-nav">
            <ul class="navbar-nav ml-auto align-items-center">


                <!-- neu chua login -->


                <li class="nav-item"><a href="${pageContext.request.contextPath}/SearchIslandController" class="nav-link">Trang chủ</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/about.jsp" class="nav-link">Giới thiệu</a></li>

                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/blog.jsp" class="nav-link">Blog</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/home/contact.jsp" class="nav-link">Liên hệ</a></li>

                <%
                    if (user == null) {
                        // Chưa đăng nhập → Hiện nút login/register
                %>
                <li class="nav-item dropdown position-relative">
                    <a class="nav-link dropdown-toggle" href="#" id="dropdown04" data-toggle="dropdown"
                       aria-haspopup="true" aria-expanded="false">
                        <i class="fa-solid fa-bell"></i>
                        <span class="badge badge-danger position-absolute" 
                              style="top: 5px; right: 5px; font-size: 0.7rem;">1</span>
                    </a>

                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdown04" style="maxwidth: 350px;">
                        <h6 class="dropdown-header">Thông báo</h6>
                        <a class="dropdown-item" href="#">Hệ thống đang bảo trì, Vui lòng quay lại sau</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item text-center" href="#">Xem tất cả</a>
                    </div>
                </li>

                <li class="nav-item ml-lg-5 ml-5 " ">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-login1"> 

                        Đăng nhập</a>


                </li>




                <li class="nav-item ml-lg-3">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-register1 ">Đăng ký</a>
                </li> 


                <%
                    } else {
                        // Đã đăng nhập → Hiện profile dropdown
                %>
                 <!-- đăt chỗ của tôi -->
                 <li class="nav-item"><a href="${pageContext.request.contextPath}/HistoryBookingServlet" class="nav-link">Đặt chỗ của tôi</a></li>
                
                      <!-- Chuông thông báo -->
              <li class="nav-item dropdown position-relative">
    <a class="nav-link dropdown-toggle" href="#" id="dropdown04" data-toggle="dropdown"
       aria-haspopup="true" aria-expanded="false">
        <i class="fa-solid fa-bell"></i>
        <c:if test="${not empty notifications}">
            <span class="badge badge-danger position-absolute" 
                  style="top: 5px; right: 5px; font-size: 0.7rem;">
                ${notifications.size()}
            </span>
        </c:if>
    </a>

    <div class="dropdown-menu dropdown-menu-right notification-dropdown" aria-labelledby="dropdown04">
    <h6 class="dropdown-header text-info d-flex align-items-center mb-2">
        <i class="fa-solid fa-bell me-2"></i> Thông báo
    </h6>

    <div class="notification-list">
        <c:forEach var="n" items="${notifications}" varStatus="status">
            <c:if test="${status.index < 10}">
                <div class="notification-item">
                    <div class="notification-icon">
                        <c:choose>
                            <c:when test="${n.type == 'BOOKING'}">
                                <i class="fa-solid fa-ticket-alt text-primary"></i>
                            </c:when>
                            <c:when test="${n.type == 'PAYMENT'}">
                                <i class="fa-solid fa-credit-card text-success"></i>
                            </c:when>
                            <c:when test="${n.type == 'SYSTEM'}">
                                <i class="fa-solid fa-gear text-warning"></i>
                            </c:when>
                            <c:when test="${n.type == 'TOUR'}">
                                <i class="fa-solid fa-map-marked-alt text-info"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-info-circle text-muted"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="notification-content">
                        <strong>${n.title}</strong>
                        <p class="text-muted mb-0">${n.message}</p>
                    </div>
                </div>
            </c:if>
        </c:forEach>

        <c:if test="${empty notifications}">
            <div class="text-center text-muted py-3">Không có thông báo mới nào</div>
        </c:if>
    </div>

    <div class="dropdown-divider my-2"></div>

    <div class="text-center pb-2">
    <button type="button" class="btn btn-sm btn-outline-danger" data-toggle="modal" data-target="#deleteNotificationModal">
        🗑 Xóa tất cả
    </button>
</div>

</div>
</li>



                <li class="nav-item dropdown ml-lg-5 w-auto">
                    <a href="#" 
                       class="nav-link dropdown-toggle d-flex align-items-center  " 
                       id="userDropdown" 
                       role="button" 
                       data-toggle="dropdown" 
                       aria-haspopup="true" 
                       aria-expanded="false"
                       style="background: #fff; padding: 8px 12px; border-radius: 8px; font-weight: 600; color: #0077b6;">

                        <i class="bi bi-person-circle mr-2" style="font-size: 20px;"></i>
                        <span lang="vi"><%= user != null ? user.getFullName() : "Khách" %> | ${sessionScope.profile_customer.loyaltyPoints} Điểm</span>
                    </a>

                    <!-- Menu xổ xuống -->
                    <div class="dropdown-menu dropdown-menu-right shadow w-auto" aria-labelledby="userDropdown">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/information?section=account#"><i class="bi bi-person-lines-fill mr-2"></i> Trang cá nhân</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/customer_profile/profile.jsp?section=member-priority#"><i class="bi bi-award"></i> Membership Level</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/FullHistoryBooking?section=historyBookings#"><i class="bi bi-calendar2-check"></i>Lịch sử đặt chỗ của tôi</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/customer_profile/profile.jsp?section=transactions#"><i class="bi bi-list-ul"></i>Giao dịch </a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/customer_profile/profile.jsp?section=notifications#"><i class="bi bi-bell mr-2"></i> Thông báo</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/views/customer_profile/profile.jsp?section=favorites#"><i class="bi bi-heart-fill"></i>Tours and Services</a>

                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item text-danger" href="#" data-toggle="modal" data-target="#logoutModal">
                            <i class="bi bi-box-arrow-right mr-2"></i> Đăng xuất
                        </a>   
                    </div>
                </li>

                <%
                    }
                %>


            </ul>
        </div>
    </div>
</nav>

<!-- Logout Modal -->

<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content logout-box">

            <!-- Body -->
            <div class="logout-body text-center p-4">
                <h2 class="logout-header mb-3">Xác nhận đăng xuất</h2>
                <h5>
                    Nếu bạn đăng xuất, bạn sẽ không thể quản lý các chuyến đi, đặt phòng và ưu đãi du lịch hiện tại.<br>
                    Bạn có chắc chắn muốn thoát khỏi Meland Booking không?
                </h5>
                <div class="mt-4">
                    <button class="btn btn-cancel mr-2" data-dismiss="modal">Không</button>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Có</a>
                </div>
            </div>

        </div>
    </div>
</div>
                               
    <!-- Delete Confirmation Modal ----------------------------------------->
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">⚠️ Xác nhận xóa thông báo</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <strong>Bạn có chắc chắn muốn xóa những thông báo này không? </strong>
                        <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <form id="deleteForm" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="flightId" id="flightlIdToDelete">
                            <button type="submit" class="btn btn-danger">Xóa</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    
        <script>
            function confirmDelete(flightlId, flightNumber) {
                document.getElementById('flightlIdToDelete').value = flightlId;
                document.getElementById('flightNumberToDelete').textContent = flightNumber;
                document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/staff/flight/tickets';
                $('#deleteModal').modal('show');
            }

            // Auto-hide alerts after 5 seconds
            setTimeout(function () {
                $('.alert').fadeOut('slow');
            }, 5000);
        </script>

<style>

    /* -------- Modal Logout -------- */

    .logout-box {
        width: 380px;
        max-width: 100%;
        border-radius: 12px;
        margin: auto;
        background: #fff;
        border: none;
        box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        text-align: center;
    }

    .logout-header {
        font-size: 1.5rem;
        font-weight: 800;
        color: #1976d2; /* xanh dương */
    }

    .logout-body h5 {
        font-size: 1rem;
        font-weight: normal;
        color: #000;
    }


    .btn-cancel {
        background: #fff;
        color: #1976d2;
        font-weight: 600;
        padding: 8px 20px;
        border: 2px solid #1976d2;
        border-radius: 6px;
        transition: 0.25s;
    }

    .btn-cancel:hover {
        background: #1976d2;
        color: #fff !important;
    }

    .btn-logout {
        background: #1976d2;
        color: #fff;
        font-weight: 600;
        padding: 8px 20px;
        border-radius: 6px;
        border: none;
        transition: 0.25s;
    }

    .btn-logout:hover {
        background: #0d47a1;
        color: #fff !important;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(25,118,210,0.3);

    }

    /* Nền ngoài modal sáng hơn */
    .modal-backdrop.show {
        opacity: 0.3 !important;
    }




    /* Dropdown tổng thể */
    .dropdown-menu {
        min-width: 300px;
        border-radius: 10px;
        padding: 6px 0;
        border: none;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        overflow: hidden; /*  tránh lòi màu hover ra ngoài */
    }

    /* Các item trong menu */
    .dropdown-item {
        padding: 10px 16px;
        font-size: 15px;
        font-weight: 500;
        color: #333;
        display: flex;
        align-items: center;
        gap: 8px;
        background-color: transparent; /* reset mặc định */
        transition: background-color 0.2s ease, color 0.2s ease;
        margin-left: 15px;
    }

    /* Khi hover */
    .dropdown-item:hover {
        background-color: #eaf6ff !important; /* nền xanh nhẹ */
        color: #0077b6 !important;
    }


    .dropdown-item i {
        font-size: 18px;
        color: #0077b6;
    }


    .dropdown-item:hover i {
        color: #0077b6;
    }


</style> 
