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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import model.CustomerProfile;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name = "information_Saved", urlPatterns = {"/information"})
public class InformationSaved extends HttpServlet {

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
            out.println("<title>Servlet information_Saved</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet information_Saved at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
       try{
            Integer userId = currentUser.getUserId();
           if("account".equals(section)){
               CustomerProfile profile = customerDao.getProfileByUserId(userId);
               request.setAttribute("dobFormatted", profile.getDateOfBirth());
               request.setAttribute("address", profile.getAddress());     
               request.setAttribute("fullname", profile.getFullName());
                request.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(request, response);
           }         
                   
           
       }catch(Exception e){
           handleError(request, response,   "Error updating Profile: " + e.getMessage(), e);
       }
      
    
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
        try {

            Integer userId = user.getUserId();

            String fullName = request.getParameter("fullname");
            String dobDate = request.getParameter("dob");
            LocalDate dob = (dobDate != null && !dobDate.isEmpty()) ? LocalDate.parse(dobDate) : null;
            String genderStr = request.getParameter("gender");
            CustomerProfile.Gender gender = genderStr != null ? CustomerProfile.Gender.valueOf(genderStr) : null;
            String Address = request.getParameter("address");

            // validate 
            if (dobDate == null || dobDate.isEmpty() || fullName == null || fullName.isEmpty() || Address == null || Address.isEmpty()) {
                session.setAttribute("errorMess", "vui lòng điền đầy đủ thông tin để lưu!");
                response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
                return;
            }

            // Kiểm tra ngày sinh không được là tương lai
            if (dob != null && dob.isAfter(LocalDate.now())) {
                session.setAttribute("errorMess", "Lỗi nhập ngày sinh!");
                response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
                return;
            }

            //  Kiểm tra dữ liệu có thay đổi không
            if (!customerDao.isProfileChanged(userId, fullName, dob, gender, Address)) {
                session.setAttribute("errorMess", "Thông tin bạn nhập trùng với dữ liệu hiện tại — không cần lưu lại.");
                response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
                return;
            }

            //  Nếu có thay đổi → update
            customerDao.updateProfileInfo(userId, fullName, dob, gender, Address);
            request.setAttribute("fullname", fullName);
            //format date
            if (dob != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                request.setAttribute("dobFormatted", dob.format(formatter));
            }
            request.setAttribute("address", Address);
            session.setAttribute("successMess", "Cập nhật thông tin thành công!");

            request.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(request, response);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi hệ thống");
        }

    }

      /**
     * Handle errors
     */


   private void handleError(HttpServletRequest request, HttpServletResponse response,
                         String message, Exception e) throws ServletException, IOException {
    System.err.println("FlightStaffServlet Error: " + message);
    if (e != null) e.printStackTrace();

    int statusCode = 500;
    if (message.toLowerCase().contains("not found")) {
        statusCode = 404;
    } else if (message.toLowerCase().contains("unauthorized")) {
        statusCode = 401;
    }

    response.setStatus(statusCode);
    request.setAttribute("statusCode", statusCode);
    request.setAttribute("errorMessage", message);
    request.setAttribute("exception", e);
    request.setAttribute("pageTitle", "Error");

    request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
    }
   
    
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
