/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile.account;

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
import model.EmailCustomer;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="saved_Email", urlPatterns={"/saved_Email"})
public class SecondaryEmail extends HttpServlet {
   
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
    
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet saved_Email</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet saved_Email at " + request.getContextPath () + "</h1>");
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
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
    return;
}

Integer userId = user.getUserId();
String action = request.getParameter("action");

if (action == null) {
    response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
    return;
}

// Xử lý xóa email
        if (action.startsWith("delete-")) {
            int emailId = Integer.parseInt(action.split("-")[1]);

            // Kiểm tra email có tồn tại cho user không
            boolean existEmail = customerDao.checkEmailExistsByIdAndUser(emailId, userId);
            if (!existEmail) {
                session.setAttribute("errorEmail_Deleted", "Email này đã bị xóa!");
            } else {
                boolean deleted = customerDao.deleteEmail(emailId);
                if (deleted) {
                    session.setAttribute("successEmail", "Đã xóa email thành công!");
                } else {
                    session.setAttribute("errorEmail_Deleted", "Xóa email không thành công!");
                }
            }

            // Cập nhật danh sách email mới
            session.removeAttribute("emailList");
            List<EmailCustomer> updatedList = customerDao.getEmailsByUserId(userId);
            session.setAttribute("emailList", updatedList);

            response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
            return;
        } // Xử lý đặt email chính
        else if (action.startsWith("makePrimary-")) {
            int emailId = Integer.parseInt(action.split("-")[1]);

            // Đặt email mới làm chính, trigger tự đồng bộ sang Users
            customerDao.setPrimaryEmai(userId, emailId);

            // Cập nhật session user để hiển thị profile ngay
            String newPrimaryEmail = customerDao.getEmailById(emailId);
            user.setEmail(newPrimaryEmail);
            session.setAttribute("user", user);
            session.setAttribute("successEmail", "Đã đặt email chính mới!");

            // Cập nhật danh sách email mới
            List<EmailCustomer> updatedList = customerDao.getEmailsByUserId(userId);
            session.setAttribute("emailList", updatedList);

             response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=account#");
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

