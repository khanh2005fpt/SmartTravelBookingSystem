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
import model.Booking;
import model.BookingDetail;
import model.Tour;
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
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int price = Integer.parseInt(request.getParameter("price"));
            Date departureDate = Date.valueOf(request.getParameter("departureDate"));
            int adultQty = Integer.parseInt(request.getParameter("adultQty"));
            int childQty = Integer.parseInt(request.getParameter("childQty"));

            // Giả sử user đang đăng nhập
            int customerId = ((User) request.getSession().getAttribute("user")).getUserId();
//            int profileId = ((User) request.getSession().getAttribute("user")).getRoleId();

            // Tính tổng tiền
            double totalPrice = (adultQty * price) + (childQty * price * 0.3);

            // Tạo booking
            Booking booking = new Booking();
//            booking.setProfileId(profileId);
            booking.setCustomerId(customerId);
            booking.setPrice((int) totalPrice);
            booking.setDepartureDate(departureDate);
            booking.setAdultQuantity(adultQty);
            booking.setChildQuantity(childQty);
            booking.setStatus("PENDING");
            BookingDao bd = new BookingDao();
            bd.createBooking(booking);

            // Lưu BookingDetails
            BookingDetail detail = new BookingDetail(booking.getBookingId(), tourId, null, null, null, (int) totalPrice);
            bd.createBookingDetail(detail);
            
            TourDao td = new TourDao();
            Tour tour = td.getTourDetailById(tourId);
            // Đưa dữ liệu sang trang payment
            request.setAttribute("booking", booking);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("tour", tour);

            request.getRequestDispatcher("/views/booking/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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
