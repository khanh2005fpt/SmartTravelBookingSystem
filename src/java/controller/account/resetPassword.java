/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.account;

import dao.tokenDao;
import dao.userDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Token;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="resetPassword", urlPatterns={"/resetPassword"})
public class resetPassword extends HttpServlet {
    
   private tokenDao TokenDao;
   private userDao UserDao;
    
    @Override
      public void init(){
             try {
            TokenDao = tokenDao.getInstance();
               UserDao = userDao.INSTANCE;
            System.out.println("tokenDao or UserDao initialized successfully in requestPasswordServlet");
        } catch (Exception e) {
            System.out.println("Error initializing tokenDao or UserDao in requestPassword: " + e.getMessage());
            e.printStackTrace();
           
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
            out.println("<title>Servlet resetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet resetPassword at " + request.getContextPath () + "</h1>");
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
      String token = request.getParameter("token");
         
Token tokenForget = tokenDao.getInstance().checkValidToken(token);

if (tokenForget == null) {
    request.getSession().setAttribute("errorMess", "Link đặt lại mật khẩu đã hết hạn. Hãy gửi yêu cầu lại!");
    response.sendRedirect("views/home/login.jsp");
    return;
}

  // luu token va email vao session
User user = UserDao.getUserById(tokenForget.getUserId());
request.getSession().setAttribute("resetEmail", user.getEmail());
request.getSession().setAttribute("token", tokenForget.getTokenValue());

response.sendRedirect("views/home/resetPassword.jsp");

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
        String email = request.getParameter("email");
        String passoword = request.getParameter("password");
        String rePassword = request.getParameter("confirmPassword");
        
        HttpSession session = request.getSession();
        //check null
        if(passoword==null || passoword.isEmpty() || rePassword==null || rePassword.isEmpty() ){
           session.setAttribute("errorPass", "Vui lòng hãy nhập mật khẩu!");
           response.sendRedirect(request.getContextPath() + "/views/home/resetPassword.jsp");
           return;
        }
        // validate password
        if(!rePassword.equals(passoword)){
              session.setAttribute("errorPass", "Mật khẩu không khớp nhau!");
       response.sendRedirect(request.getContextPath() + "/views/home/resetPassword.jsp");
       return;
        }
        
          // update is used of token 
        String tokenValue = (String) session.getAttribute("token");
                 //update password , status
          UserDao.updatePassword(email, passoword);
TokenDao.markTokenAsUsed(tokenValue);

          //  save user and redirect to home
          
          session.setAttribute("successMessage", "Đổi mật khẩu thành công.");
          response.sendRedirect("views/home/login.jsp");

        
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
