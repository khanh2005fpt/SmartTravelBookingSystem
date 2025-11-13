/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.dashboard;

import dao.BookingDao;
import dao.IslandDao;
import dao.TourDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Tour;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="StaffDashboardServlet", urlPatterns={"/staff/dashboard"})
public class StaffDashboardServlet extends HttpServlet {
      public TourDao tourDao;
    public IslandDao islandDao;
    public BookingDao bookingDao;
    @Override
    public void init() throws ServletException {
        try {
            tourDao = TourDao.INSTANCE;
           islandDao =IslandDao.INSTANCE;
           bookingDao = BookingDao.INSTANCE;
            System.out.println("tourDao initialized successfully in StaffDashboardServlet");
        } catch (Exception e) {
            System.out.println("Error initializing   tourDao in StaffDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize StaffDashboardServlet", e);
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
            out.println("<title>Servlet StaffDashboardServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffDashboardServlet at " + request.getContextPath () + "</h1>");
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
              HttpSession session = request.getSession(false);
           if (!isStaffAuthorized(session, request, response)) {
        return;
    }
        try{ 
            // total tour
         int totalTours = tourDao.getTotalTours();
          request.setAttribute("totalTours", totalTours);
          // total island
          int totalIslands =islandDao.getTotalIslands();
          request.setAttribute("totalIslands", totalIslands);
          // Total booking 
          
          int totalBookings = bookingDao.getTotalBooking();
           request.setAttribute("totalBookings", totalBookings);
           
           // total revenue
           long totalRevenues = bookingDao.getTotalRevenue();
           request.setAttribute("totalRevenues", totalRevenues);
           
           // recent tour
           List<Tour> recentTours = tourDao.getRecentTours();
           request.setAttribute("recentTours", recentTours);
           

         request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);
        }catch(Exception e){
           e.printStackTrace();
           request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);
        }

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

    }

    private boolean isStaffAuthorized(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
    if (session == null) {
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return false;
    }

    User user = (User) session.getAttribute("user");
    if (user == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return false;
    }

    // Map roleId -> roleName
 String role;
        switch (user.getRoleId()) {
            case 1:
                role = "ADMIN";
                break;
            case 2:
                role = "BOOKING MANAGER";
                break;
            case 3:
                role = "CUSTOMER";
                break;
            default:
                role = "STAFF";
                break;
        }

        if (!"STAFF".equals(role) && !"ADMIN".equals(role)) {
            session.setAttribute("errorMess", "Bạn không có quyền truy cập!");
            response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
            return false;
        }

        return true;
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
