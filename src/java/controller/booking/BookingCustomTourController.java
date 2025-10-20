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
import java.sql.Date;
import java.util.List;
import model.Booking;
import model.CustomTour;
import model.CustomTourDetail;
import model.CustomTourItinerary;
import model.User;

/**
 *
 * @author Admin
 */
public class BookingCustomTourController extends HttpServlet {

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
            out.println("<title>Servlet BookingCustomTourController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingCustomTourController at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
            int customTourId = Integer.parseInt(request.getParameter("customTourId"));
            int price = Integer.parseInt(request.getParameter("price"));
            String startDateStr = request.getParameter("startDate");
            Date departureDate = null;

            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                try {
                    departureDate = Date.valueOf(startDateStr);
                } catch (IllegalArgumentException e) {
                    System.out.println("⚠️ startDateStr không hợp lệ: " + startDateStr);
                }
            }

            int adultQty = Integer.parseInt(request.getParameter("adultQty"));
            int childQty = Integer.parseInt(request.getParameter("childQty"));

            TourDao dao = new TourDao();
            CustomTour tour = dao.getTourById(customTourId);
            List<CustomTourDetail> details = dao.getTourDetails(customTourId);

            List<CustomTourItinerary> itineraries = dao.getTourItinerary(customTourId);
            // Kiểm tra ngày khởi hành phải >= hôm nay

            int totalPeople = adultQty + childQty;
            if (totalPeople > 50) {
                request.setAttribute("errorMessage", "❌ Tổng số người không được vượt quá 50 người!");
                request.setAttribute("tour", tour);
                request.setAttribute("details", details);
                request.setAttribute("itineraries", itineraries);
                request.getRequestDispatcher("/views/trip/custom_tour_detail.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin người dùng đăng nhập
            User user = (User) request.getSession().getAttribute("user");

            int customerId = user.getUserId();

            // Tính tổng tiền
            double totalPrice = (adultQty * price) + (childQty * price * 0.3);

            // Tạo booking
            Booking booking = new Booking();
            booking.setCustomerId(customerId);
            booking.setPrice((int) totalPrice);
            booking.setDepartureDate(departureDate);

            booking.setAdultQuantity(adultQty);
            booking.setChildQuantity(childQty);
            booking.setStatus("PENDING");

            BookingDao bd = new BookingDao();
            bd.createBooking(booking);

            // Lưu BookingDetails
            // Lấy thông tin tour
            // Gửi dữ liệu sang trang thanh toán
            request.setAttribute("booking", booking);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("tour", tour);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/views/booking/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage() != null ? e.getMessage() : "Có lỗi khi tạo tour.";
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
