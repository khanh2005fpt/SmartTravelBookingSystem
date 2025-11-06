package controller.manager;

import dao.TourDao;
import model.Tour;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "TourApprovalManagerServlet", urlPatterns = {"/manager/tour-approval"})
public class TourApprovalManagerServlet extends HttpServlet {

    private TourDao tourDao;

    @Override
    public void init() throws ServletException {
        try {
            tourDao = new TourDao();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo TourDao", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession();
//        String role = (String) session.getAttribute("role");
//
//        // ✅ Chỉ cho phép role = MANAGER
//        if (role == null || !"MANAGER".equalsIgnoreCase(role)) {
//            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
//            return;
//        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "approve":
                    updateTourStatus(request, response, "APPROVED");
                    break;
                case "reject":
                    updateTourStatus(request, response, "REJECTED");
                    break;
                default:
                    listPendingTours(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/manager/tour-approval.jsp").forward(request, response);
        }
    }

    private void listPendingTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Tour> pendingTours = tourDao.getPendingTours();
        request.setAttribute("tours", pendingTours);
        request.getRequestDispatcher("/views/manager/tour-approval.jsp").forward(request, response);
    }

    private void updateTourStatus(HttpServletRequest request, HttpServletResponse response, String status)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        tourDao.updateTourStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/manager/tour-approval");
    }
}
