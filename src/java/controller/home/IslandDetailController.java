/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.home;

import dao.IslandDao;
import dao.ServiceDao;
import dao.TourDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Flight;
import model.FlightSchedule;
import model.Hotel;
import model.Island;
import model.IslandVehicle;
import model.Place;
import model.Tour;

/**
 *
 * @author Admin
 */
public class IslandDetailController extends HttpServlet {



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
            out.println("<title>Servlet IslandDetailController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet IslandDetailController at " + request.getContextPath() + "</h1>");
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
     

        try {
            String idRaw = request.getParameter("detailId");

            int id = Integer.parseInt(idRaw);
            String flightTypeRaw = request.getParameter("flightType");
            IslandDao dao = new IslandDao();
            Island island = dao.getIslandById(id);
            ServiceDao serviceDao = new ServiceDao();
            List<Hotel> listH = serviceDao.getListHotelsById(id);
            List<IslandVehicle> listV = serviceDao.getListVehicleById(id);
            List<Place> listP = serviceDao.getListPlaceById(id);
            TourDao td = new TourDao();
            List<Tour> listT = td.getListToursById(id);

            // Lấy danh sách flights dựa trên flightType 
            
             List<FlightSchedule> flights= new ArrayList<>();
            if (flightTypeRaw != null) {
                String flightType;
                switch (flightTypeRaw.toLowerCase()) {
                    case "motchieu":
                        flightType = "Một chiều";
                        break;
                    case "khuhoi":
                        flightType = "Khứ hồi";
                        break;
                    default:
                        flightType = null;
                }
                if (flightType != null) {
                   
                    flights= serviceDao.getFlightSchedules(id, flightType);
                 
                }
            }
                request.setAttribute("islandvehicles", listV);
                request.setAttribute("island", island);
                request.setAttribute("hotels", listH);
                request.setAttribute("tours", listT);
                request.setAttribute("places", listP);
                request.setAttribute("flights", flights);
           
                
                request.setAttribute("flightType", flightTypeRaw != null ? flightTypeRaw : ""); // Truyền flightType để hiển thị
                request.getRequestDispatcher("/views/trip/island_detail.jsp").forward(request, response);
           } catch (NumberFormatException e) {
            response.sendError(400, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi hệ thống");
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
        processRequest(request, response);
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
