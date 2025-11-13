/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customer;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 *
 * @author nqagh
 */
@WebServlet(name="SendContact", urlPatterns={"/SendContact"})
public class SendContact extends HttpServlet {
   
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
            out.println("<title>Servlet SendContact</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendContact at " + request.getContextPath () + "</h1>");
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
          request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Mail người nhận (admin)
        String to = "nqaghuyyy6969@gmail.com";
String link = request.getContextPath() + "/views/home/contact.jsp";
        // Nội dung mail
      
String content = "<html><body>"
        + "<div style='max-width:600px;margin:0 auto;border:1px solid #ddd;border-radius:10px;overflow:hidden;font-family:Arial,sans-serif;'>"
        + "   <div style='background:#0077b6;color:#fff;text-align:center;padding:15px;font-size:20px;font-weight:bold;'>"
        + "       Smart Island Travel Booking"
        + "       <div style='font-size:13px;font-weight:normal;'>Thông báo phản hồi mới từ khách hàng</div>"
        + "   </div>"
        + "   <div style='padding:20px;font-size:15px;color:#333;line-height:1.6;'>"
        + "       <p>Xin chào <b>HuyDavid - Quản trị hệ thống</b>,</p>"
        + "       <p>Bạn vừa nhận được một phản hồi mới từ khách hàng. Chi tiết phản hồi như sau:</p>"
        + "       <div style='background:#f1f9ff;padding:15px;border-radius:8px;margin:20px 0;'>"
        + "           <p style='font-size:16px;color:#023e8a;'><b>Tên khách hàng:</b> " + name + "</p>"
        + "           <p style='font-size:16px;color:#023e8a;'><b>Email khách hàng:</b> " + email + "</p>"
        + "           <p style='font-size:16px;color:#023e8a;'><b>Chủ đề:</b> " + subject + "</p>"
        + "           <p style='font-size:15px;color:#555;'><b>💬 Nội dung phản hồi:</b><br>" + message + "</p>"
        + "       </div>"
        + "       <p style='text-align:center;font-style:italic;color:#555;'>Hãy xem phản hồi này và cân nhắc cải thiện trải nghiệm khách hàng trong các tour/dịch vụ sắp tới.</p>"
        + "   </div>"
        + "   <div style='font-size:12px;color:#777;text-align:center;padding:15px;border-top:1px solid #eee;'>"
        + "       &copy; 2025 Smart Island Travel Booking — Hệ thống quản lý chuyến đi"
        + "   </div>"
        + "</div>"
        + "</body></html>";
      
        ContactMailService cms = new ContactMailService();
        boolean sent = cms.sendFeedback(to, subject, content);

        if (sent) {
            request.getSession().setAttribute("successMess", "Gửi phản hồi thành công! Cảm ơn bạn đã liên hệ 💬");
        } else {
            request.getSession().setAttribute("errorMess", "Không thể gửi phản hồi, vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/views/home/contact.jsp");
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
