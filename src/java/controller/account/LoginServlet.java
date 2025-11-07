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
import model.CustomerContacts;
import model.CustomerProfile;
import model.GoogleAccount;
import model.Notification;
import java.sql.SQLException;

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
            customerDao = CustomerDao.INSTANCE;

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
        try {
            if (existing != null) {
                   if ("LOCKED".equalsIgnoreCase(existing.getStatus())) {
        // nếu tài khoản bị khóa, gửi thông báo và redirect về login
        session.setAttribute("errorMess", "Tài khoản của bạn đã bị khóa!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return; // quan trọng: dừng tiếp tục xử lý
    }

                
                
                // user ton tai -> login
                session.setAttribute("user", existing);
                session.setAttribute("loginSuccess", "oke");
           
              System.out.println("UserId: " + existing.getUserId());
                // gui thong bang session den trang profile
                CustomerProfile profile = customerDao.getProfileByUserId(existing.getUserId());
        

System.out.println("Profile after query: " + profile);
session.setAttribute("profile_customer", profile);
System.out.println("Session set done!");

                session.setAttribute("profile_customer", profile);

                List<Notification> listNotification = customerDao.getNotificationByUser(existing.getUserId());
                List<CustomerContacts> emailList = customerDao.getEmailContactByUserId(existing.getUserId());
                List<CustomerContacts> phoneList = customerDao.getPhoneContactByUserId(existing.getUserId());

                session.setAttribute("listNotification", listNotification);
                session.setAttribute("emailList_Current", emailList);
                session.setAttribute("phoneList_Current", phoneList);

               int roleId = existing != null ? existing.getRoleId() : existing.getRoleId();
                    if (roleId == 1) {
                      response.sendRedirect(request.getContextPath() + "/admin/dashboard-user");
                    }else if(roleId == 2 ){
                        response.sendRedirect(request.getContextPath() + "/manager/dashboard");
                    }else if( roleId == 4){
                        response.sendRedirect(request.getContextPath() + "/views/staff/index.jsp");
                    }
                     else if (roleId == 3) {
                        response.sendRedirect(request.getContextPath() + "/SearchIslandController");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
                    }
                return;
            } else {
                // user chua co acc --> dky luon cho user

                String randomPass = userDAO.generateRandomPassword(10);
                String fullName = acc.getFamily_name() + " " + acc.getGiven_name();

                String result = userDAO.AutoSignupByGoogle(acc.getEmail(), randomPass, acc.getEmail(), fullName, null);

                if (result.startsWith("Success")) {
                    // sau khi add thi check user de login
                    User newUser = userDAO.getUserByEmail(acc.getEmail());

                    //login
                    session.setAttribute("user", newUser);
                    session.setAttribute("loginSuccess", "oke");

                    // redirect theo roleId
                    int roleId = existing != null ? existing.getRoleId() : newUser.getRoleId();
                    if (roleId == 1 || roleId == 2 || roleId == 4) {
                        response.sendRedirect(request.getContextPath() + "/views/staff/index.jsp");
                    } else if (roleId == 3) {
                        response.sendRedirect(request.getContextPath() + "/SearchIslandController");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
                    }
                } else {
                    session.setAttribute("errorMess", "Không thể tạo tài khoản bằng google");
                    response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");

                }

            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorEmail_Deleted", "Có lỗi xảy ra khi login or register bằng google. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=account#");
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
        try {

            User user = userDAO.loginSystem(userN, passWord);
            //check acc active and ton tai
            String error = null;
            if (user == null) {
                error = "Tên đăng nhập hoặc mật khẩu không đúng!";
            } else if ("LOCKED".equals(user.getStatus())) {
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

            List<CustomerContacts> emailList = customerDao.getEmailContactByUserId(user.getUserId());
            List<CustomerContacts> phoneList = customerDao.getPhoneContactByUserId(user.getUserId());
            List<Notification> listNotification = customerDao.getNotificationByUser(user.getUserId());

            session.setAttribute("listNotification", listNotification);
            session.setAttribute("emailList_Current", emailList);
            session.setAttribute("phoneList_Current", phoneList);

            session.setAttribute("loginSuccess", "oke");

            // redirect theo roleId
            int roleId = user.getRoleId();
                    if (roleId == 1) {
                      response.sendRedirect(request.getContextPath() + "/admin/dashboard-user");
                    }else if(roleId == 2 ){
                        response.sendRedirect(request.getContextPath() + "/manager/dashboard");
                    }else if( roleId == 4){
                        response.sendRedirect(request.getContextPath() + "/views/staff/index.jsp");
                    }
                     else if (roleId == 3) {
                        response.sendRedirect(request.getContextPath() + "/SearchIslandController");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
                    }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorEmail_Deleted", "Có lỗi xảy ra khi xóa or đặt lại email. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?section=account#");
        }

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
