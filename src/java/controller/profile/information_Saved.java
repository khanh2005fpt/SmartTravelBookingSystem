/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile;

import dao.ProfileDao;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import model.CustomerProfile;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="information_Saved", urlPatterns={"/information"})
public class information_Saved extends HttpServlet {
   
      public ProfileDao profileDAO;
   
       @Override
    public void init() throws ServletException {
        try {
           profileDAO = ProfileDao.INSTANCE;
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
            out.println("<title>Servlet information_Saved</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet information_Saved at " + request.getContextPath () + "</h1>");
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
      //lay session sau khi login thanh cong
    User user = (User) session.getAttribute("user"); 
    if (user == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/home/login.jsp");
        return;
    }

    Integer userId = user.getUserId(); 
    
    String fullName = request.getParameter("fullname"); 
    String dobDate = request.getParameter("dob");
    LocalDate dob = (dobDate != null && !dobDate.isEmpty()) ? LocalDate.parse(dobDate) : null;
    String genderStr = request.getParameter("gender");
    CustomerProfile.Gender gender = genderStr != null ? CustomerProfile.Gender.valueOf(genderStr) : null;
    String Address = request.getParameter("address");
    
   // validate 
         if(dobDate==null || dobDate.isEmpty() || fullName ==null || fullName.isEmpty() || Address ==null || Address.isEmpty()){
               session.setAttribute("errorMess", "vui lòng điền đầy đủ thông tin để lưu!");
                 response.sendRedirect(request.getContextPath() + "/views/home/profile.jsp");
                 return;
         }
         
  

    //  Kiểm tra dữ liệu có thay đổi không
    if (!profileDAO.isProfileChanged(userId, fullName, dob, gender, Address)) {
        session.setAttribute("errorMess", "Thông tin không có thay đổi nào để lưu.");
       response.sendRedirect(request.getContextPath() + "/views/home/profile.jsp");
        return;
    }

    //  Nếu có thay đổi → update
    profileDAO.updateInformation(userId, fullName, dob, gender, Address, null, 0, CustomerProfile.MembershipLevel.BRONZE);
     request.setAttribute("fullname", fullName);
     //format date
     if (dob != null) {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
    request.setAttribute("dobFormatted", dob.format(formatter));
}
    request.setAttribute("address", Address);
    session.setAttribute("successMess", "Cập nhật thông tin thành công!");

    request.getRequestDispatcher("/views/home/profile.jsp").forward(request, response);
    return;
       
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
