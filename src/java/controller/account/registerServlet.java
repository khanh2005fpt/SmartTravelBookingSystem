/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.account;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAO.userDao;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author nqagh
 */
@WebServlet(name = "registerServlet", urlPatterns = {"/register"})
public class registerServlet extends HttpServlet {

    private userDao userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = userDao.INSTANCE;
            System.out.println("userDao initialized successfully in RegisterServlet");
        } catch (Exception e) {
            System.out.println("Error initializing userDao in RegisterServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize RegisterServlet", e);
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
            out.println("<title>Servlet registerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet registerServlet at " + request.getContextPath() + "</h1>");
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
        String UserName = request.getParameter("username");
        String PassWord = request.getParameter("password");
        String RePassword = request.getParameter("rePassword");
        String Email = request.getParameter("email");
        String FullName = request.getParameter("fullName");
        String Phone = request.getParameter("phoneNumber");
    HttpSession session = request.getSession();
      

        // check null and rong input
        if (UserName == null || UserName.isEmpty()
                || PassWord == null || PassWord.isEmpty()
                || RePassword == null || RePassword.isEmpty()
                || Email == null || Email.isEmpty()
                || FullName == null || FullName.isEmpty()
                || Phone == null || Phone.isEmpty()) {

         
    session.setAttribute("errorMess", "Thiếu các thông tin bắt buộc, vui lòng nhập đầy đủ!");
    response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
    return;

        }

        // Validate theo field
        String[] fields = {"username", "password", "repassword", "email", "fullname", "phone"};

        for (String field : fields) {
            String error = null;
            switch (field) {
                case "username":
                    if (!UserName.matches("^[a-zA-Z][a-zA-Z0-9_]*$")) {
                        error = "Tên đăng nhập chỉ chứa chữ, số, dấu _ và bắt đầu bằng chữ cái!";
                    } else if (UserName.length() < 3 || UserName.length() > 20) {
                        error = "Tên đăng nhập phải từ 3-20 ký tự!";
                    }
                    break;

                case "password":
                    if (!PassWord.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,20}$")) {
                        error = "Mật khẩu phải 8-20 ký tự, ít nhất 1 chữ hoa, 1 chữ thường, 1 số, 1 ký tự đặc biệt!";
                    }
                    break;

                case "repassword":
                    if (!PassWord.equals(RePassword)) {
                        error = "Mật khẩu nhập không khớp!";
                    }
                    break;

                case "email":
                    if (!Email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                        error = "Email không hợp lệ!";
                    }
                    break;

                case "fullname":
                    if (!FullName.matches("^[\\p{L} ]+$")) {
                        error = "Họ và tên chỉ chứa chữ và khoảng trắng!";
                    } else if (FullName.length() < 5 || FullName.length() > 20) {
                        error = "Họ và tên phải từ 5-20 ký tự!";
                    }
                    break;

                case "phone":
                    if (!Phone.matches("^0[0-9]{9}$")) {
                        error = "Số điện thoại phải bắt đầu từ 0 và có 10 chữ số!";
                    }
                    break;
            }

            if (error != null) {
               
    session.setAttribute("errorMess", error);
    response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
    return;
            }
        }

        // check ton tai 
        boolean userNameExist = userDAO.checkUsernameExist(UserName);
        boolean emailExist = userDAO.checkEmailExist(Email);
        boolean fullNamelExist = userDAO.checkFullnameExist(FullName);
        boolean phoneExist = userDAO.checkPhoneExist(Phone);
            
        try {
           
            if (userNameExist && emailExist && fullNamelExist && phoneExist) {
                session.setAttribute("errorMess", "Tài khoản này đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
                return;
            }
            if (userNameExist) {
                session.setAttribute("errorMess", "Tên đăng nhập đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
                return;
            }
            if (emailExist) {
                session.setAttribute("errorMess", "Email đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
                return;
            }
            if (phoneExist) {
                session.setAttribute("errorMess", "Số điện thoại đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
                return;
            }

            if (fullNamelExist) {
                session.setAttribute("errorMess", "Họ và tên đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
                return;
            }

        } catch (Exception e) {
            session.setAttribute("errorMess", "Lỗi khi kiểm tra thông tin: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
        }

        // dang ky 
        try {

            String signUpResult = userDAO.Signup(UserName, PassWord, Email, FullName, Phone);
            if ("Success".equals(userDAO.getStatus())) {
                session.setAttribute("mess", "Đăng kí thành công! Xin vui lòng đăng nhậppp .");
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
            } else {
                session.setAttribute("errorMess", signUpResult);
                response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
            }

        } catch (Exception e) {
          session.setAttribute("errorMess", "Đăng kí thất bại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/home/register.jsp");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
