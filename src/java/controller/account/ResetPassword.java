/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.account;

import dao.UserDao;
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
@WebServlet(name = "ResetPassword", urlPatterns = {"/ResetPassword"})
public class ResetPassword extends HttpServlet {

    public UserDao userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = UserDao.INSTANCE;

            System.out.println("userDao initialized successfully in requestPasswordServlet");
        } catch (Exception e) {
            System.out.println("Error initializing userDao in requestPassword: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize requestPassword", e);
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
            out.println("<title>Servlet resetPassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet resetPassword at " + request.getContextPath() + "</h1>");
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
        String token = request.getParameter("token");

        Token tokenForget = userDAO.checkValidToken(token);

        if (tokenForget == null) {
            request.getSession().setAttribute("errorMess", "Link đặt lại mật khẩu đã hết hạn. Hãy gửi yêu cầu lại!");
            response.sendRedirect("views/account/login.jsp");
            return;
        }

        // luu token va email vao session
        User user = userDAO.getUserById(tokenForget.getUserId());
        request.getSession().setAttribute("resetEmail", user.getEmail());
        request.getSession().setAttribute("token", tokenForget.getTokenValue());

        response.sendRedirect("views/account/reset_password.jsp");

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

        String otpInput = request.getParameter("otp");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("confirmPassword");

        // get token từ session
        String tokenValue = (String) session.getAttribute("token");
        Token tokenForget = userDAO.checkValidToken(tokenValue);

        if (tokenForget == null) {
            session.setAttribute("errorPass", "Mã OTP đã hết hạn. Hãy gửi yêu cầu lại!");
            response.sendRedirect(request.getContextPath() + "/views/account/reset_password.jsp");
            return;
        }

        // kiểm tra OTP
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String otpSession = (String) session.getAttribute("otpSession");

        if (otpVerified == null || !otpVerified) {
            Integer attempt = (Integer) session.getAttribute("otpAttempt");
            if (attempt == null) {
                attempt = 0;
            }

            if (otpInput == null || otpInput.trim().isEmpty()) {
                session.setAttribute("errorPass", "Vui lòng nhập OTP!");
                response.sendRedirect(request.getContextPath() + "/views/account/reset_password.jsp");
                return;
            }

            if (!otpInput.equals(otpSession)) {
                attempt++;
                session.setAttribute("otpAttempt", attempt);
                userDAO.updateOtpAndAttempt(tokenForget.getTokenId(), otpInput, attempt);

                if (attempt >= 3) {
                    session.invalidate();
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("errorMess", "Bạn đã nhập sai OTP quá 3 lần. Vui lòng gửi lại yêu cầu!");
                    response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
                    return;
                }

                session.setAttribute("errorPass", "OTP sai! Bạn còn " + (3 - attempt) + " lần thử.");
                response.sendRedirect(request.getContextPath() + "/views/account/reset_password.jsp");
                return;
            }

            // OTP đúng → set flag
            session.setAttribute("otpVerified", true);
            //  tiếp tục xử lý password
        }

        // Kiểm tra password và rePassword
        if (password == null || password.trim().isEmpty()
                || rePassword == null || rePassword.trim().isEmpty()) {
            session.setAttribute("errorPass", "Vui lòng nhập mật khẩu và xác nhận!");
        } else if (!password.equals(rePassword)) {
            session.setAttribute("errorPass", "Mật khẩu xác nhận không khớp!");
        } else if (!password.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,20}$")) {
            session.setAttribute("errorPass", "Mật khẩu phải 8-20 ký tự, ít nhất 1 chữ hoa, 1 chữ thường, 1 số, 1 ký tự đặc biệt!");
        }

// Nếu có lỗi thì redirect
        if (session.getAttribute("errorPass") != null) {
            response.sendRedirect(request.getContextPath() + "/views/account/reset_password.jsp");
            return;
        }

        // update password và mark token
        userDAO.updatePassword(email, password);
        userDAO.markTokenAsUsed(tokenValue);

        // clean OTP
        session.removeAttribute("otpSession");
        session.removeAttribute("otpVerified");
        session.removeAttribute("otpAttempt");

        // thông báo thành công
        session.setAttribute("successMessage", "Đổi mật khẩu thành công.");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
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
