/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.home;

import dao.ServiceDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Flight;
import model.FlightSchedule;

/**
 *
 * @author nqagh
 */
public class FlightSearchController extends HttpServlet {
   
  public ServiceDao serviceDAO;
   
       @Override
    public void init() throws ServletException {
        try {
           serviceDAO =  ServiceDao.INSTANCE;
            System.out.println("serviceDAO initialized successfully in loginServlet");
        } catch (Exception e) {
            System.out.println("Error initializin serviceDAO in loginServlet: " + e.getMessage());
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
            out.println("<title>Servlet FlightSearchController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlightSearchController at " + request.getContextPath () + "</h1>");
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
        try {
            
    String idRaw = request.getParameter("islandId");
    String flightTypeRaw = request.getParameter("flightType"); // Nhận "MotChieu" hoặc "KhuHoi"
    
    System.out.println("DEBUG: Raw islandId = " + idRaw);
    System.out.println("DEBUG: Raw flightType = " + flightTypeRaw);
    
    if (idRaw == null || flightTypeRaw == null) {
        response.sendRedirect(request.getContextPath() + "/IslandDetailController");
        return;
    }
    
    int islandId;
    try {
        islandId = Integer.parseInt(idRaw);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/IslandDetailController");
        return;
    }
  
    // Ánh xạ flightTypeRaw sang giá trị DB
    String flightType;
    switch (flightTypeRaw.toLowerCase()) { 
        case "motchieu":
            flightType = "Một chiều";
            break;
        case "khuhoi":
            flightType = "Khứ hồi";
            break;
        default:
            response.sendRedirect(request.getContextPath() + "/IslandDetailController");
            return;
    }
    
   
    // lay list de hien thi thong tin chuyen bay
  
      List<FlightSchedule> flights = serviceDAO.getFlightSchedules(islandId, flightType);
  
    request.setAttribute("flights", flights);
    request.setAttribute("flightType", flightType);
   
  
    
    response.sendRedirect(request.getContextPath() + "/IslandDetailController?detailId=" + islandId + "&flightType=" + flightTypeRaw);
            
            
        } catch (Exception e) {
            e.printStackTrace();    
            System.out.println(e);
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
        processRequest(request, response);
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
