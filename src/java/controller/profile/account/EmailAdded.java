/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile.account;

import dao.CustomerDao;

import dao.UserDao;

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
@WebServlet(name="email_Added", urlPatterns={"/email_Added"})
public class EmailAdded extends HttpServlet {
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
            out.println("<title>Servlet email_Added</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet email_Added at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
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
        HttpSession session =request.getSession();
           User user = (User) session.getAttribute("user"); 
     
    if (user == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
    }

    Integer userId = user.getUserId();
    
     String email = request.getParameter("email");
     
     //validate
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("errorEmail", "Vui lòng nhập địa chỉ email hợp lệ!");
         response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
            return;
        }
        // check mail ton tai
        
        Boolean existAddedPhone = customerDao.checkEmailExists(userId, email);
        
        if(existAddedPhone || email.equals(user.getEmail())){
             session.setAttribute("errorEmail_Deleted", "Email này đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
            return;
        }
        
        // check k them qua 2 mail
        int totalEmails = customerDao.countSecondaryEmails(userId);
          if(totalEmails>=2){
              session.setAttribute("errorEmail_Deleted", "Bạn chỉ được dùng tối đa 3 email!");
              response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
            return;
          }
        // them email
        customerDao.addEmail(userId, email);
        List<EmailCustomer> emailList = customerDao.getEmailsByUserId(userId);
      session.setAttribute("emailList", emailList);
       session.setAttribute("successEmail", "Thêm email thành công!");
       response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
   

        
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
