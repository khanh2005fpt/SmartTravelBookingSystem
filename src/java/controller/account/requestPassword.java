/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.account;

import DAO.tokenDao;
import DAO.userDao;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;

/**
 *
 * @author nqagh
 */
@WebServlet(name="requestPassword", urlPatterns={"/requestPassword"})
public class requestPassword extends HttpServlet {
    private userDao UserDao ;
    
    @Override
     public void init() throws ServletException {
        try {
            UserDao = userDao.INSTANCE;
            System.out.println("userDao initialized successfully in requestPasswordServlet");
        } catch (Exception e) {
            System.out.println("Error initializing userDao in requestPassword: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize requestPassword", e);
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
            out.println("<title>Servlet forgetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet forgetPassword at " + request.getContextPath () + "</h1>");
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
      request.getRequestDispatcher("requestPassword.jsp").forward(request, response);
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
            HttpSession session = request.getSession();
       //email ton tai
       try{
               if(email.isEmpty() || email ==null){
             session.setAttribute("errorEmail", "Vui lòng nhập Email!");
           response.sendRedirect(request.getContextPath()+ "/views/home/login.jsp"); 
           return;
          }
       User user = UserDao.getUserByEmail(email);
   
       if(user==null){
           session.setAttribute("errorEmail", "Email không tồn tại!");
           response.sendRedirect(request.getContextPath()+ "/views/home/login.jsp");
           return;
       }
       
       // Tao otp +token
       
       resetService service = new resetService();
       String otp = service.generateOtp();
       String token = service.generateToken();
       
       // luu token vao db
         tokenDao TokensDao = new tokenDao();
         TokensDao.saveToken(user.getUserId(), token, service.expireDateTime());
         
       // link reset co token
          String linkReset = "http://localhost:9090/SWP391_Group3_SE1957-KS/views/home/resetPassword?token="+token;
       
       // gui email otp + link
       service.sendEmail(email, linkReset, user.getFullName(), otp);
        
       // luu OTP tam vao session (de xac thuc sau khi user nhap)
       session.setAttribute("otp", otp);
       session.setAttribute("userId", user.getUserId());
       
       // gui thong bao thanh cong
       session.setAttribute("successMessage", "Mã OTP đã gửi đến Email của bạn!");
       response.sendRedirect(request.getContextPath()+"/views/home/login.jsp");
        
           
           
       }catch(Exception e){
            e.printStackTrace();
        session.setAttribute("errorEmail", "Có lỗi xảy ra, vui lòng thử lại sau!");
        response.sendRedirect(request.getContextPath() + "/views/home/login.jsp");
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
