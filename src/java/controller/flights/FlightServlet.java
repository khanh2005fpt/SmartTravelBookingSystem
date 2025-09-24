/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import dao.FlightDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Flight;

/**
 *
 * @author Admin
 */
@WebServlet(urlPatterns = {"/flights"})
public class FlightServlet extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
    }


    @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy số trang từ request (mặc định = 1)
        String pageParam = request.getParameter("page");
        int pageNumber = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

        FlightDAO dao = new FlightDAO();
        List<Flight> flights = dao.getAllFlightsWithPagination(pageNumber);

        // Tổng số chuyến bay để tính số trang
        int totalFlights = dao.getTotalFlights();
        int pageSize = 5;
        int totalPages = (int) Math.ceil((double) totalFlights / pageSize);

        // Gửi dữ liệu sang JSP
        request.setAttribute("flights", flights);
        request.setAttribute("currentPage", pageNumber);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/flights.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
