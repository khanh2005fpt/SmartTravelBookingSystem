/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.account;

import dao.CustomerDao;
import model.User;
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
import model.CustomerProfile;
import model.EmailCustomer;
import model.GoogleAccount;
import model.Notification;
import model.PhoneCustomer;

/**
 *
 * @author nqagh
 */
@WebServlet(name = "loginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserDao userDAO;
    public CustomerDao customerDao;
   

    @Override
    public void init() throws ServletException {
        try {
          userDAO = UserDao.INSTANCE;
            customerDao = CustomerDao .INSTANCE;
          
            
            System.out.println("userDao initialized successfully in loginServlet");
        } catch (Exception e) {
            System.out.println("Error initializing userDao in loginServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize loginServlet", e);
        }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet loginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet loginServlet at " + request.getContextPath() + "</h1>");
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
        // get error khi user click huy trong login gg
        String error = request.getParameter("error");
        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
            return;
        }

        String code = request.getParameter("code");
        GoogleLogin gg = new GoogleLogin();
        String accessToken = gg.getToken(code);
        System.out.println(accessToken);
        GoogleAccount acc = gg.getUserInfo(accessToken);
        System.out.println(acc);

        //check tk nay da dky chua
        User existing = userDAO.getUserByEmail(acc.getEmail());
        if (existing != null) {
            // user ton tai -> login
            session.setAttribute("user", existing);
            session.setAttribute("loginSuccess", "oke");
            
        // gui thong bang session den trang profile
            CustomerProfile profile = customerDao.getProfileByUserId(existing.getUserId());
            session.setAttribute("profile_customer", profile);

 
    
            List<Notification> listNotification = customerDao.getNotificationByUser(existing.getUserId());
            List<EmailCustomer> emailList =customerDao.getEmailsByUserId(existing.getUserId());
            List<PhoneCustomer> phoneList = customerDao.getPhoneCustomersByUserId(existing.getUserId());
            
          
            session.setAttribute("listNotification", listNotification);
            session.setAttribute("emailList_Current", emailList);
            session.setAttribute("phoneList_Current", phoneList);
 

            response.sendRedirect(request.getContextPath() + "/SearchIslandController");
            return;
        } else {
            // user chua co acc --> dky luon cho user

            String randomPass = userDAO.generateRandomPassword(10);
            String fullName = acc.getFamily_name() + " " + acc.getGiven_name();

            String result = userDAO.AutoSignupByGoogle(acc.getEmail(), randomPass, acc.getEmail(), fullName, null);

            if (result.startsWith("Success")) {
                // sau khi add thi check user de login
                User newUser = userDAO.getUserByEmail(acc.getEmail());
                // List<PhoneCustomer> listPhone = phoneDAO.getPhoneCustomersByUserId(0);
                //login
                session.setAttribute("user", newUser);
                session.setAttribute("userId", newUser.getUserId());

                session.setAttribute("loginSuccess", "oke");
                response.sendRedirect(request.getContextPath() + "/SearchIslandController");
            } else {
                session.setAttribute("errorMess", "Không thể tạo tài khoản bằng google");
                response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");

            }

        }

        //insertAccout , tao password ham random tu dong
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
        String userN = request.getParameter("username");
        String passWord = request.getParameter("pass");

        HttpSession session = request.getSession();
       

        // check null input
        if (userN.isEmpty() || userN == null || passWord.isEmpty() || passWord == null) {
            session.setAttribute("errorMess", "Các trường không được để trống!");
            response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
            return;
        }
        
          User user =userDAO.loginSystem(userN, passWord);
        //check acc active and ton tai
        String error = null;
        if (user == null) {
            error = "Tên đăng nhập hoặc mật khẩu không đúng!";
        } else if ("Locked".equals(user.getStatus())) {
            error = "Tài khoản của bạn đã bị khóa!";
        }
        // thong bao loi
        if (error != null) {
            session.setAttribute("errorMess", error);
            response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
            return;
        }

        
        //login thanh cong
     
        session.setAttribute("user", user);
      
        // gui thong bang session den trang profile
        
        CustomerProfile profile = customerDao.getProfileByUserId(user.getUserId());
            session.setAttribute("profile_customer", profile);
         
        
        List<EmailCustomer> emailList = customerDao.getEmailsByUserId(user.getUserId());
        List<PhoneCustomer> phoneList = customerDao.getPhoneCustomersByUserId(user.getUserId());
        List<Notification> listNotification = customerDao.getNotificationByUser(user.getUserId());

        session.setAttribute("listNotification", listNotification);
        session.setAttribute("emailList_Current", emailList);
        session.setAttribute("phoneList_Current", phoneList);
  

        session.setAttribute("userId", user.getUserId());
        session.setAttribute("loginSuccess", "oke");
        response.sendRedirect(request.getContextPath() + "/SearchIslandController");

    }

    /**
     * Returns a short description of the servlet .
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
