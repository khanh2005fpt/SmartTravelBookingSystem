/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile.history_bookings;

import dao.CustomerDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;
import model.HistoryBooking;


/**
 *
 * @author nqagh
 */
@WebServlet(name="HistoryBookingServlet", urlPatterns={"/HistoryBookingServlet"})
public class HistoryBookingServlet extends HttpServlet {
   
        public CustomerDao customerDao;
   
       @Override
    public void init() throws ServletException {
        try {
            customerDao = CustomerDao.INSTANCE;
            System.out.println("profileDAO initialized successfully in loginServlet");
        } catch (Exception e) {
            System.out.println("Error initializingprofileDAO in loginServlet: " + e.getMessage());
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
        try {
            HttpSession session = request.getSession();
            //lay session sau khi login thanh cong
            User user = (User) session.getAttribute("user");
            if (user == null) {
                session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
                response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
                return;
            }

            Integer userId = user.getUserId();

            // Lấy danh sách lịch sử booking từ DB
          List<HistoryBooking> historyList = customerDao.getHistoryByCustomerId(userId);
          
          session.setAttribute("historyList", historyList);
          response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=historyBookings#");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải lịch sử đặt chỗ.");
           response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=historyBookings#");
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
