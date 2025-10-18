/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile.notifications;

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
import model.Notification;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="notificatios_servlet", urlPatterns={"/notificatios_servlet"})
public class NotificatiosServlet extends HttpServlet {
   
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
            out.println("<title>Servlet notificatios_servlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet notificatios_servlet at " + request.getContextPath () + "</h1>");
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
           HttpSession session = request.getSession();
      //lay session sau khi login thanh cong
    User user = (User) session.getAttribute("user"); 
    if (user == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }

    Integer userId = user.getUserId(); 
    
      String action = request.getParameter("action");
      

    
    
    try {
        switch (action) {
            case "markAll":
                customerDao.markAllRead(userId);
                break;

            case "deleteAll":
                List<Integer> unreadIds = customerDao.getUnreadNotificationIds(userId);
              if (!unreadIds.isEmpty()) {
    session.setAttribute("errorNoti_Deleted", "Bạn còn thông báo chưa đọc, không thể xóa được!");
       response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=notifications#");
       return ;
             } else {
    customerDao.softDeleteAllByUser(userId);
             }
              break;
        }

       
        List<Notification> listNotification = customerDao.getNotificationByUser(userId);
        session.setAttribute("listNotification", listNotification);

   
         response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=notifications#");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMess", "Đã xảy ra lỗi khi xử lý thông báo!");
        response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=notifications#");
    }
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
