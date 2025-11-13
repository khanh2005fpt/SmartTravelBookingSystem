/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.booking;

import dao.BookingDao;
import dao.TourDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Booking;
import model.Tour;
import model.TourItinerary;
import model.User;

/**
 *
 * @author Admin
 */
public class BookingController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          HttpSession session = request.getSession(false);
           if (!isStaffAuthorized(session, request, response)) {
        return;
    }
           
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            double price = Double.parseDouble(request.getParameter("discountedPrice"));
            Date departureDate = Date.valueOf(request.getParameter("departureDate"));
            int adultQty = Integer.parseInt(request.getParameter("adultQty"));
            int childQty = Integer.parseInt(request.getParameter("childQty"));
            TourDao td = new TourDao();
            Tour tour = td.getTourDetailById(tourId);
            List<TourItinerary> itineraries = td.getListTourItineriesById(tourId);
            // Kiểm tra ngày khởi hành phải >= hôm nay
            Date today = new Date(System.currentTimeMillis());
            if (departureDate.before(today)) {
                request.setAttribute("errorMessage", "❌ Ngày khởi hành không được nhỏ hơn ngày hiện tại!");
                request.setAttribute("tour", tour);
                request.setAttribute("itineraries", itineraries);
                request.getRequestDispatcher("/views/trip/tour_detail.jsp").forward(request, response);
                return;
            }

            //Kiem tra ngay khoi hanh phai sau 3 ngay
            long diffInMillis = departureDate.getTime() - today.getTime();
            long diffInDays = diffInMillis / (1000 * 60 * 60 * 24);

            if (diffInDays < 3) {
                request.setAttribute("errorMessage", "❌ Ngày khởi hành phải sau ít nhất 3 ngày kể từ hôm nay!");
                request.setAttribute("tour", tour);
                request.setAttribute("itineraries", itineraries);
                request.getRequestDispatcher("/views/trip/tour_detail.jsp").forward(request, response);
                return;
            }

            int totalPeople = adultQty + childQty;
            if (totalPeople > 40) {
                request.setAttribute("errorMessage", "❌ Tổng số người không được vượt quá 40 người!");
                request.setAttribute("tour", tour);
                request.setAttribute("itineraries", itineraries);
                request.getRequestDispatcher("/views/trip/tour_detail.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin người dùng đăng nhập
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                request.setAttribute("errorMessage", "❌ Bạn cần đăng nhập trước khi đặt tour!");
                request.getRequestDispatcher("/views/account/login.jsp").forward(request, response);
                return;
            }

            int customerId = user.getUserId();
            
          //  System.out.println("Customer ID from session: " + customerId);


            // Tính tổng tiền
            double totalPrice = (adultQty * price) + (childQty * price * 0.3);

            // Tạo booking
            Booking booking = new Booking();
            booking.setCustomerId(customerId);
            booking.setTourId(tourId);
            booking.setDepartureDate(departureDate);
            booking.setAdultQuantity(adultQty);
            booking.setChildQuantity(childQty);
            booking.setStatus("PENDING");
            booking.setTotalPrice(totalPrice);

            BookingDao bd = new BookingDao();
            int bookingId = bd.createBooking(booking); // bookingId được tạo ở DB
            booking.setBookingId(bookingId);           // đã set trong DAO
         //   System.out.println(bookingId);
            // Lấy thông tin tour
            // Gửi dữ liệu sang trang thanh toán
            request.setAttribute("booking", booking);
            request.setAttribute("tour", tour);

            request.getRequestDispatcher("/views/booking/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            TourDao td = new TourDao();
            Tour tour = null;
            try {
                tour = td.getTourDetailById(tourId);
            } catch (SQLException ex) {
                Logger.getLogger(BookingController.class.getName()).log(Level.SEVERE, null, ex);
            }
            List<TourItinerary> itineraries = null;
            try {
                itineraries = td.getListTourItineriesById(tourId);
            } catch (SQLException ex) {
                Logger.getLogger(BookingController.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình xử lý: " + e.getMessage());
            request.setAttribute("tour", tour);
            request.setAttribute("itineraries", itineraries);
            request.getRequestDispatcher("/views/trip/tour_detail.jsp").forward(request, response);
        }

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
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
