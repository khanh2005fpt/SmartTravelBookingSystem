package controller.customer;

import dao.CustomerDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import model.User;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {

    private final CustomerDao dao = CustomerDao.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        // Check if user is logged in
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.print("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }

        String action = req.getParameter("action");
        String serviceType = req.getParameter("serviceType");
        String refIdStr = req.getParameter("refId");

        if ("check".equals(action) && serviceType != null && refIdStr != null) {
            try {
                int refId = Integer.parseInt(refIdStr);
                boolean isFavorite = dao.isFavorite(user.getUserId(), serviceType, refId);
                out.print("{\"success\": true, \"isFavorite\": " + isFavorite + "}");
            } catch (Exception e) {
                out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
            }
        } else {
            out.print("{\"success\": false, \"message\": \"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        // Check if user is logged in
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.print("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }

        String action = req.getParameter("action");
        String serviceType = req.getParameter("serviceType");
        String refIdStr = req.getParameter("refId");

        if (action == null || serviceType == null || refIdStr == null) {
            out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            int refId = Integer.parseInt(refIdStr);
            boolean success = false;

            if ("add".equals(action)) {
                success = dao.addFavorite(user.getUserId(), serviceType, refId);
            } else if ("remove".equals(action)) {
                success = dao.removeFavorite(user.getUserId(), serviceType, refId);
            } else if ("toggle".equals(action)) {
                // Toggle: if exists, remove; else add
                if (dao.isFavorite(user.getUserId(), serviceType, refId)) {
                    success = dao.removeFavorite(user.getUserId(), serviceType, refId);
                } else {
                    success = dao.addFavorite(user.getUserId(), serviceType, refId);
                }
            }

            if (success) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"Operation failed\"}");
            }

        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}