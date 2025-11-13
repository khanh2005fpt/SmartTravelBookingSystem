/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.history_bookings;

import dao.CustomerDao;
import dao.TourDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.CustomTourBookingInfo;
import model.CustomTourDetail;
import model.CustomTourItinerary;
import model.FlightSchedule;
import model.User;
import model.HistoryBooking;
import model.TourBookingInfo;


/**
 *
 * @author nqagh
 */
@WebServlet(name="HistoryBookingServlet", urlPatterns={"/HistoryBookingServlet"})
public class HistoryBookingServlet extends HttpServlet {
   
      public TourDao tourDao;
       @Override
    public void init() throws ServletException {
        try {
          tourDao = TourDao.INSTANCE;
            System.out.println("tourDao initialized successfully in HistoryBookingServlet");
        } catch (Exception e) {
            System.out.println("Error initializing tourDaoO in HistoryBookingServletoginServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize information", e);
        }
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HistoryBooking</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HistoryBooking at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
            response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
            return;
        }

        int roleId = currentUser.getRoleId();
        if (roleId != 1 && roleId != 3) {
            session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
            response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
            return;
        }
  try {
        int userId = currentUser.getUserId();

        // Lấy lịch sử booking mới nhất + tourType
        HistoryBooking hb = tourDao.getLatestHistoryBookingWithTourType(userId);

        FlightSchedule flightSchedules = null;

        if (hb == null) {
            request.setAttribute("errorMessage", "Không tìm thấy lịch sử đặt tour nào gần đây cho tài khoản của bạn!");
       
        } else {
            request.setAttribute("historyBooking", hb);
            System.out.println("type:"+hb.getTourType());

            if ("Tour lẻ".equals(hb.getTourType())) {
               // Tour lẻ
                CustomTourBookingInfo customTourInfo = tourDao.getLatestCustomTourAfterBookingByUser(userId);
                request.setAttribute("tour", customTourInfo.getCustomTour());
                request.setAttribute("booking", customTourInfo.getBooking());
                request.setAttribute("details", customTourInfo.getCustomTourDetails());
                request.setAttribute("itinerary", customTourInfo.getCustomTourItineraries());
                   // Lấy flight của tour lẻ
             
                flightSchedules = tourDao.geFlightScheduleOfCustomerTourByUser(userId);
                 request.setAttribute("flightSchedulesCT", flightSchedules);

            } else if ("Tour trọn gói".equals(hb.getTourType())) {
                // Lấy flight của tour trọn gói
                TourBookingInfo tourInfo = tourDao.getLatestTourAfterBookingByUser(userId);
                 request.setAttribute("booking", tourInfo.getBooking());
                request.setAttribute("tour", tourInfo.getTour());
                request.setAttribute("services", tourInfo.getTourServices());
                request.setAttribute("itineraries", tourInfo.getTourItineraries());
                

              // Lấy flight của tour trọn gói
                flightSchedules = tourDao.getFlightScheduleOfTourByUser(userId);
                 request.setAttribute("flightSchedulesT", flightSchedules);
            }
        }


        request.getRequestDispatcher("/views/customer/my_tour.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Đã xảy ra lỗi xem thông tin tour sau khi đặt.");
        request.getRequestDispatcher("/views/customer/my_tour.jsp").forward(request, response);
    }
  
    }
    

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
