<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Service_TermsPage</title>
          <%@ include file="/views/common/css.jsp" %>
    </head>
    
            
    <%
User currentUser = (User) session.getAttribute("user");

if (currentUser != null) {
    int roleId = currentUser.getRoleId();

    if (roleId != 1 && roleId != 3) {
        session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
        return;
    }
}
%>
    <body  class="service-page"  >
       <%@ include file="/views/common/navbar.jsp" %>
        <!-- KẾT THÚC nav -->
          <header>
        <img id="headerImage" src="${pageContext.request.contextPath}/views/home/images/Servie_Term_Pic.jpg"
             alt="Smart Island Travel Banner">
        <div class="header-overlay">
            🏝️ Smart Island Travel
        </div>
    </header>

    <main >
        <h1>Điều khoản Dịch vụ</h1>
        
        <h2>1. Giới thiệu</h2>
        <p>Chào mừng bạn đến với <strong>Smart Island Travel Booking System</strong> ("Hệ thống"). Bằng việc sử dụng dịch vụ của chúng tôi, bạn đồng ý tuân thủ các điều khoản dưới đây.</p>

        <h2>2. Phạm vi dịch vụ</h2>
        <p>Hệ thống cung cấp nền tảng để đặt vé tàu, khách sạn, tour du lịch và các dịch vụ liên quan trên đảo thông minh.</p>
        <p>Chúng tôi chỉ đóng vai trò <strong>trung gian</strong> giữa khách hàng và nhà cung cấp dịch vụ (khách sạn, hãng tàu, công ty tour…).</p>

        <h2>3. Đăng ký tài khoản</h2>
        <ul>
            <li>Người dùng phải cung cấp thông tin chính xác, đầy đủ khi đăng ký.</li>
            <li>Bạn chịu trách nhiệm bảo mật thông tin đăng nhập của mình.</li>
            <li>Hệ thống có quyền tạm khóa hoặc hủy tài khoản nếu phát hiện hành vi gian lận, vi phạm pháp luật hoặc điều khoản.</li>
        </ul>

        <h2>4. Đặt chỗ & Thanh toán</h2>
        <ul>
            <li>Việc đặt chỗ chỉ được xác nhận sau khi hệ thống nhận đủ thông tin và thanh toán hợp lệ.</li>
            <li>Giá dịch vụ có thể thay đổi tùy thời điểm và sẽ được hiển thị rõ ràng trước khi thanh toán.</li>
            <li>Thanh toán được thực hiện thông qua các cổng thanh toán được tích hợp, đảm bảo an toàn.</li>
        </ul>

        <h2>5. Hủy & Hoàn tiền</h2>
        <ul>
            <li>Chính sách hủy/hoàn tiền phụ thuộc vào từng nhà cung cấp dịch vụ.</li>
            <li>Người dùng cần đọc kỹ thông tin trước khi xác nhận đặt chỗ.</li>
            <li>Một số dịch vụ có thể <strong>không hoàn tiền</strong> nếu hủy trong thời gian quá ngắn.</li>
        </ul>

        <h2>6. Quyền & Trách nhiệm của người dùng</h2>
        <ul>
            <li>Sử dụng hệ thống đúng mục đích: đặt dịch vụ du lịch hợp pháp.</li>
            <li>Không được phép sử dụng để gian lận, spam, hoặc gây rối hệ thống.</li>
            <li>Chịu trách nhiệm về thông tin cá nhân, phương thức thanh toán và các giao dịch của mình.</li>
        </ul>

        <h2>7. Quyền & Trách nhiệm của hệ thống</h2>
        <ul>
            <li>Đảm bảo hệ thống hoạt động ổn định, bảo mật và minh bạch.</li>
            <li>Hỗ trợ khách hàng trong quá trình đặt chỗ và xử lý sự cố phát sinh.</li>
            <li>Không chịu trách nhiệm cho mọi thiệt hại trực tiếp hoặc gián tiếp do nhà cung cấp dịch vụ gây ra.</li>
        </ul>

        <h2>8. Chính sách bảo mật</h2>
        <p>Hệ thống cam kết bảo mật dữ liệu cá nhân của người dùng. Thông tin chỉ được chia sẻ với nhà cung cấp dịch vụ liên quan để hoàn tất giao dịch.</p>

        <h2>9. Sửa đổi điều khoản</h2>
        <p>Chúng tôi có quyền điều chỉnh Điều khoản dịch vụ bất kỳ lúc nào. Các thay đổi sẽ được công bố trên website, và việc tiếp tục sử dụng dịch vụ đồng nghĩa bạn chấp nhận các điều chỉnh đó.</p>

        <h2>10. Liên hệ</h2>
        <div class="contact-info">
            <p>📧 <strong>Email:</strong> support@smartislandbooking.com</p>
            <p>📞 <strong>Hotline:</strong> 1800-123-456</p>
        </div>
    </main>

        <%@ include file="/views/common/footer.jsp" %>

<div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>
   <%@ include file="/views/common/script.jsp" %>
    </body>
</html>
