<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Booking #${bookingId}</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        :root {
            --primary-color: #007bff;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --body-bg: #f4f7f6;
            --border-color: #dee2e6;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--body-bg);
            margin: 0;
            color: var(--dark-color);
        }

        .main-content {
            padding: 30px;
            max-width: 900px;
            margin: 20px auto;
        }

        .content-card {
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin: 0 0 30px 0;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .booking-table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .booking-table th, .booking-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .booking-table th {
            background-color: var(--light-color);
            font-weight: 600;
        }

        .booking-table td {
            vertical-align: middle;
        }
        
        .align-right {
            text-align: right !important;
        }
        
        /* Phần tổng kết */
        .summary-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid var(--border-color);
            text-align: right;
            font-size: 1.2rem;
        }
        
        .summary-section strong {
            font-size: 1.5rem;
            color: var(--primary-color);
            margin-left: 20px;
        }

        /* Nút Back */
        .back-link-wrapper {
            text-align: center;
            margin-top: 30px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background-color: var(--primary-color);
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 1rem;
            transition: background-color 0.2s;
        }
        .back-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>

        
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
<body>
    <%@ include file="../common/navbar.jsp" %>

    <main class="main-content">
        <div class="content-card">
            <h1 class="page-title">
                <i class="fa-solid fa-file-invoice-dollar"></i>
                Chi tiết Booking - ID #${bookingId}
            </h1>

            <c:choose>
                <c:when test="${not empty details}">
                    <%-- Khởi tạo biến tổng tiền --%>
                    <c:set var="totalSum" value="0" />

                    <table class="booking-table">
                        <thead>
                            <tr>
                                <th>Mã chi tiết</th>
                                <th>Dịch vụ</th>
                                <th>Người lớn</th>
                                <th>Trẻ em</th>
                                <th>Ngày khởi hành</th>
                                <th class="align-right">Đơn giá</th>
                                <th class="align-right">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${details}">
                                <%-- Cộng dồn tổng tiền --%>
                                <c:set var="totalSum" value="${totalSum + d.totalPrice}" />
                                
                                <tr>
                                    <td>${d.bookingDetailId}</td>
                                    <td>${d.serviceName != null ? d.serviceName : "-"}</td>
                                    <td>${d.adultQuantity}</td>
                                    <td>${d.childQuantity}</td>
                                    <td>${d.departureDate != null ? d.departureDate : "-"}</td>
                                    <td class="align-right">
                                        <fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                    </td>
                                    <td class="align-right">
                                        <fmt:formatNumber value="${d.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="summary-section">
                        Tổng cộng: 
                        <strong>
                            <fmt:formatNumber value="${totalSum}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                        </strong>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="text-align:center; padding: 20px;">Không có dữ liệu chi tiết cho booking này.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="back-link-wrapper">
            <a class="back-link" href="${pageContext.request.contextPath}/booking?action=list">
                <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>
</body>
</html>