/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.history_bookings;

import dao.BookingDao;
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
import model.HistoryBooking;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="FullHistoryBookingServlet", urlPatterns={"/FullHistoryBooking"})
public class FullHistoryBookingServlet extends HttpServlet {
   
       public BookingDao bookingDao;
       public void init() throws ServletException {
          try {
          bookingDao = BookingDao.INSTANCE;
            System.out.println("bookingDao initialized successfully in History BookingServlet");
        } catch (Exception e) {
            System.out.println("Error initializing tourDaoO in History BookingServlet loginServlet: " + e.getMessage());
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
            out.println("<title>Servlet FullHistoryBookingServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FullHistoryBookingServlet at " + request.getContextPath () + "</h1>");
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
           // Lấy section từ navbar
    String section = request.getParameter("section");
    if (section == null || section.isEmpty()) {
        section = "account"; // mặc định
    }
    
    
           if (!isStaffAuthorized(session, request, response)) {
        return;
    }

    try {
        int userId = currentUser.getUserId();
        List<HistoryBooking> historyList = bookingDao.getTop5HistoryByUser(userId);
        request.setAttribute("historyList", historyList);
        request.setAttribute("section", section);

        // Forward JSP (không redirect nữa)
        request.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(request, response);
        
         } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi xem thông tin tour sau khi đặt.");
         request.getRequestDispatcher("/views/customer_profile/profile.jsp?section=historyBookings#").forward(request, response);
        }
        
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
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
