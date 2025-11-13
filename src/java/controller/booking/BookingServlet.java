package controller.booking;

import dao.BookingDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.BookingListItem;
import model.User;

/**
 * Servlet quản lý danh sách booking cho Manager/Admin
 */
@WebServlet("/manager/booking")
public class BookingServlet extends HttpServlet {

    private BookingDao bookingDao;

    @Override
    public void init() throws ServletException {
        bookingDao = new BookingDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
           HttpSession session = request.getSession(false);
           if (!isStaffAuthorized(session, request, response)) {
        return;
    }
        

        // Lấy action từ URL (mặc định là list)
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "searchStatus":
                    searchByStatus(request, response);
                    break;
                case "searchName":
                    searchByCustomerName(request, response);
                    break;
                case "filterTour":
                    searchByTourAndSort(request, response);
                    break;
                case "detail":
                    viewBookingDetail(request, response);
                    break;

                default:
                    listBookings(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void viewBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        BookingListItem booking = bookingDao.getBookingById2(id);

        if (booking == null) {
            request.setAttribute("error", "Booking not found!");
        } else {
            request.setAttribute("booking", booking);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/booking_detail.jsp");
        dispatcher.forward(request, response);
    }

    private void searchByTourAndSort(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String tour = request.getParameter("tour");
        String sort = request.getParameter("sort");

        List<BookingListItem> list = bookingDao.searchByTourAndSort(tour, sort);
        List<String> tours = bookingDao.getAllTours();

        request.setAttribute("listBookings", list);
        request.setAttribute("tours", tours);
        request.setAttribute("selectedTour", tour);
        request.setAttribute("sortOrder", sort);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/booking_list.jsp");
        dispatcher.forward(request, response);
    }

    // ===================== HIỂN THỊ DANH SÁCH =====================
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // giữ mặc định là 1
        }

        List<BookingListItem> list = bookingDao.getAll(page);
        request.setAttribute("listBookings", list);
        request.setAttribute("currentPage", page);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/booking_list.jsp");
        dispatcher.forward(request, response);
    }

    // ===================== TÌM THEO TRẠNG THÁI =====================
    private void searchByStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String status = request.getParameter("status");
        List<BookingListItem> list = bookingDao.searchByStatus(status);

        request.setAttribute("listBookings", list);
        request.setAttribute("searchType", "status");
        request.setAttribute("searchValue", status);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/booking_list.jsp");
        dispatcher.forward(request, response);
    }

    // ===================== TÌM THEO TÊN KHÁCH HÀNG =====================
    private void searchByCustomerName(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<BookingListItem> list = bookingDao.searchByCustomerName(keyword);

        request.setAttribute("listBookings", list);
        request.setAttribute("searchType", "name");
        request.setAttribute("searchValue", keyword);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/booking_list.jsp");
        dispatcher.forward(request, response);
    }
private boolean isStaffAuthorized(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
    if (session == null) {
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return false;
    }

    User user = (User) session.getAttribute("user");
    if (user == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return false;
    }

    // Map roleId -> roleName
 String role;
        switch (user.getRoleId()) {
            case 1:
                role = "ADMIN";
                break;
            case 2:
                role = "BOOKING MANAGER";
                break;
            case 3:
                role = "CUSTOMER";
                break;
            default:
                role = "STAFF";
                break;
        }

        if (!"CUSTOMER".equals(role) && !"ADMIN".equals(role)) {
            session.setAttribute("errorMess", "Bạn không có quyền truy cập!");
            response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
            return false;
        }

        return true;
    }

    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
