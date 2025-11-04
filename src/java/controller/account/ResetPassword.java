/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.account;


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
@WebServlet(name="ResetPassword", urlPatterns={"/ResetPassword"})
public class ResetPassword extends HttpServlet {
    
  public userDao userDAO ;
    
    
    @Override
     public void init() throws ServletException {
        try {
           userDAO = userDao.INSTANCE;
               
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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
     String otpInput = request.getParameter("otp");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("confirmPassword");

        HttpSession session = request.getSession();

        // get token 
        String tokenValue = (String) session.getAttribute("token");
        
        Token tokenForget =  userDAO.checkValidToken(tokenValue);

        if (tokenForget == null) {
            request.getSession().setAttribute("errorPass", "Mã OTP đã hết hạn. Hãy gửi yêu cầu lại!");
            response.sendRedirect("views/account/reset_password.jsp");
            return;
        }

        // flag check otp da xac thua chua
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String otpSession = (String) session.getAttribute("otpSession");
    
        // chi check OTP nếu chưa verify
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
                    session.invalidate(); // clear het session
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("errorMess", "Bạn đã nhập sai OTP quá 3 lần. Vui lòng gửi lại yêu cầu!");
                    response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
                    return;
                }

                session.setAttribute("errorPass", "OTP sai! Bạn còn " + (3 - attempt) + " lần thử.");
                response.sendRedirect(request.getContextPath() + "/views/account/reset_password.jsp");
                return;
            }

            // OTP dung → set flag 
            session.setAttribute("otpVerified", true); 
              response.sendRedirect(request.getContextPath() + "/views/account/reset_password.jsp");
                return; 
         }   
         // neu user chua nhap mat khau → quay lai form de nhap mat khau(flow 1&2)

        if (password == null || password.trim().isEmpty()
                || rePassword == null || rePassword.trim().isEmpty()) {
            session.setAttribute("errorPass", "Vui lòng nhập mật khẩu và xác nhận!");
            response.sendRedirect("views/account/reset_password.jsp");
            return;
        }
    // 4. Check confirm password
        if (!password.equals(rePassword)) {
            session.setAttribute("errorPass", "Mật khẩu xác nhận không khớp!");
            response.sendRedirect("views/account/reset_password.jsp");
            return;
        }

        // update is used of token 
        //update password , status
        userDAO.updatePassword(email, password);
        userDAO.markTokenAsUsed(tokenValue);
      
         // luu otp sau khi doi mat khau thanh cong
          String otpUsed = request.getParameter("otp");
          if (otpUsed != null && !otpUsed.trim().isEmpty()) {
         userDAO.updateOtpAndAttempt(tokenForget.getTokenId(), otpUsed,0 ); 
         
     

}     // clean otp khi doi mk thanh cong 
          session.removeAttribute("otpSession");
       
        //  save user and redirect to home
        session.setAttribute("successMessage", "Đổi mật khẩu thành công.");
        response.sendRedirect("views/account/login.jsp");

        
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
