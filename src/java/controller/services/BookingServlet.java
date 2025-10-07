/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.services;

import dao.BookingDAO;
import dao.BookingDAO.BookingListItem;
import dao.BookingDetailDAO;
import dao.BookingDetailDAO.BookingDetailItem;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private BookingDetailDAO detailDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        detailDAO = new BookingDetailDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    handleList(req, resp);
                    break;

                case "detail":
                    handleDetail(req, resp);
                    break;

                case "search":
                    handleSearch(req, resp);
                    break;

                case "filterStatus":
                    handleFilterByStatus(req, resp);
                    break;

                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown action: " + action);
            }
        } catch (SQLException e) {

            e.printStackTrace();
            throw new ServletException("DB error: " + e.getMessage(), e);
        }
    }
    
    private void handleFilterByStatus(HttpServletRequest req, HttpServletResponse resp)
        throws SQLException, ServletException, IOException {

    String status = req.getParameter("status");
    if (status == null || status.trim().isEmpty()) {
        resp.sendRedirect(req.getContextPath() + "/booking?action=list");
        return;
    }

    List<BookingListItem> results = bookingDAO.searchByStatus(status.trim());
    req.setAttribute("items", results);
    req.setAttribute("selectedStatus", status);
    req.getRequestDispatcher("views/booking/list.jsp").forward(req, resp);
}


    private void handleSearch(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        String keyword = req.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/booking?action=list");
            return;
        }

        List<BookingListItem> results = bookingDAO.searchByCustomerName(keyword.trim());
        req.setAttribute("items", results);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("views/booking/list.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/bookings?action=list");
            return;
        }

        int bookingId = parseIntOrDefault(idStr, -1);
        if (bookingId == -1) {
            resp.sendRedirect(req.getContextPath() + "/bookings?action=list");
            return;
        }

        List<BookingDetailItem> details = detailDAO.getDetailsByBookingId(bookingId);

        req.setAttribute("details", details);
        req.setAttribute("bookingId", bookingId);
        req.getRequestDispatcher("views/booking/detail.jsp").forward(req, resp);
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        int page = parseIntOrDefault(req.getParameter("page"), 1);
        if (page < 1) {
            page = 1;
        }

        List<BookingListItem> items = bookingDAO.getAll(page);
        int totalPages = bookingDAO.getTotalPages();

        req.setAttribute("items", items);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", BookingDAO.PAGE_SIZE);

        // forward tới JSP hiển thị
        req.getRequestDispatcher("views/booking/list.jsp").forward(req, resp);
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
