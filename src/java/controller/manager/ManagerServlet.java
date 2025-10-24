package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet chính chịu trách nhiệm hiển thị trang Manager Dashboard.
 * Ánh xạ tới: /manager
 */
@WebServlet("/manager")
public class ManagerServlet extends HttpServlet {

    private static final String MANAGER_DASHBOARD_JSP = "/managerDashboard.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- 1. LOGIC XÁC THỰC (Authentication/Authorization) ---
        // BƯỚC QUAN TRỌNG: Kiểm tra xem người dùng đã đăng nhập và có vai trò (Role) là Manager chưa.
        // Bạn cần phải thay thế logic sau bằng code xác thực thực tế của bạn.
        /*
        User loggedInUser = (User) request.getSession().getAttribute("user");
        if (loggedInUser == null || !loggedInUser.getRole().equals("MANAGER_ROLE_ID")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        */

        // --- 2. XỬ LÝ DỮ LIỆU DASHBOARD ---
        // Tại đây, bạn có thể gọi các DAO để lấy dữ liệu tổng quan, ví dụ:
        // int totalBookings = BookingDAO.INSTANCE.getTotalBookings();
        // request.setAttribute("totalBookings", totalBookings);
        
        // Hiện tại, ta chỉ forward trực tiếp.
        
        // --- 3. FORWARD ĐẾN TRANG JAP ---
        // Trang managerDashboard.jsp nên nằm trong thư mục gốc của Web Pages (hoặc bạn điều chỉnh đường dẫn)
        request.getRequestDispatcher(MANAGER_DASHBOARD_JSP).forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý các yêu cầu POST tại đây nếu cần (ví dụ: gửi form tổng quan)
        doGet(request, response);
    }
}