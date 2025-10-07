/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile;

import dao.EmailDao;
import dao.userDao;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="email_Added", urlPatterns={"/email_Added"})
public class email_Added extends HttpServlet {
     public EmailDao emailDao;
    
   
       @Override
    public void init() throws ServletException {
        try {
          emailDao = EmailDao.INSTANCE;
        
            System.out.println("emailDao initialized successfully in loginServlet");
        } catch (Exception e) {
            System.out.println("Error initializing emailDao in loginServlet: " + e.getMessage());
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
        response.sendRedirect(request.getContextPath() + "/views/home/login.jsp");
        return;
    }

    Integer userId = user.getUserId();
    
     String email = request.getParameter("email");
     
     //validate
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("errorEmail", "Vui lòng nhập địa chỉ email hợp lệ!");
        request.getRequestDispatcher("/views/home/profile.jsp").forward(request, response);
            return;
        }
        // check mail ton tai
        
        Boolean exist = emailDao.checkEmailExists(userId, email);
        if(exist){
             session.setAttribute("errorEmail", "Email này đã tồn tại!");
              request.getRequestDispatcher("/views/home/profile.jsp").forward(request, response);
            return;
        }
        
        // them email
        emailDao.addEmail(userId, email);
          session.setAttribute("successEmail", "Thêm email thành công!");
       response.sendRedirect(request.getContextPath() + "/views/home/profile.jsp");

        
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
