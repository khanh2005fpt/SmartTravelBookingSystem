package controller.report;

import dao.SystemDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import jakarta.servlet.annotation.WebServlet;



@WebServlet("/manager/report")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SystemDao dao = new SystemDao();    

        try {
            // 1️⃣ Lấy dữ liệu thống kê từ DAO
            Map<String, Double> monthlyRevenue = dao.getMonthlyRevenue();
            Map<String, Integer> monthlyBookings = dao.getMonthlyBookings();
            List<Map<String, Object>> servicePerformance = dao.getServicePerformance();

            // 2️⃣ Truyền sang JSP
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("monthlyBookings", monthlyBookings);
            request.setAttribute("servicePerformance", servicePerformance);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠️ Database error: " + e.getMessage());
        }

        // 3️⃣ Forward tới JSP hiển thị dashboard
        RequestDispatcher rd = request.getRequestDispatcher("/views/manager/report_dashboard.jsp");
        rd.forward(request, response);
    }
}
