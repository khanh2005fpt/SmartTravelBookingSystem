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
import java.sql.SQLException;
import java.util.List;
import model.CustomerContacts;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="Secondary_CurrentPhone", urlPatterns={"/Secondary_CurrentPhone"})
public class SecondaryCurrentPhone extends HttpServlet {
   
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
            out.println("<title>Servlet Secondary_CurrentPhone</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Secondary_CurrentPhone at " + request.getContextPath () + "</h1>");
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
       HttpSession session = request.getSession();
       User user = (User) session.getAttribute("user");
       if(user==null){
            session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return;
       }
       
       try{
           
           
        Integer userId = user.getUserId();
       String action = request.getParameter("action");
       if(action==null){
             response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=account#");
          return;
       }
       
       if(action.startsWith("delete-")){
           
             int contactId = Integer.parseInt(action.split("-")[1]);
             //check phone co thuoc ve user hien tai k
           
              customerDao.deleteContact(contactId);
            session.setAttribute("successPhone", "Đã xóa số điện thoại thành công!");
         
            //sau khi xoa update moi nhat
               List<CustomerContacts> updatePhoneList =customerDao.getPhoneContactByUserId(userId);
           session.setAttribute("phoneList_Current", updatePhoneList);
          response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=account#");
           
           
       }
           
               
    }catch(SQLException e){
       e.printStackTrace();
       session.setAttribute("errorPhone_Deleted", "Có lỗi xảy ra khi thêm số điện thoại. Vui lòng thử lại!");
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
