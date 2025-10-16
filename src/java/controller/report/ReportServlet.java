package controller.report;

import dao.ReportDao;
import model.ReportRevenue;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/report")
public class ReportServlet extends HttpServlet {

    private final ReportDao dao = ReportDao.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<ReportRevenue> reportData = dao.getMonthlyRevenueWithCounts();
        req.setAttribute("reportData", reportData);
        req.getRequestDispatcher("../views/report/reportDashboard.jsp").forward(req, resp);
    }
}
