package controller;

import dao.FlightDAO;
import dao.AirlineDAO;
import dao.IslandDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Flight;
import model.Airline;
import model.Island;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/flights")
public class FlightServlet extends HttpServlet {

    private FlightDAO flightDAO = new FlightDAO();
    private AirlineDAO airlineDAO = new AirlineDAO();
    private IslandDAO islandDAO = new IslandDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                handleDelete(request, response);
                break;
            case "list":
            default:
                handleList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "add": {
                    Flight fAdd = buildFlightFromRequest(request, 0);
                    flightDAO.addFlight(fAdd);
                    response.sendRedirect("flights");
                    break;
                }
                case "update": {
                    int flightId = Integer.parseInt(request.getParameter("flightId"));
                    Flight fUpdate = buildFlightFromRequest(request, flightId);
                    flightDAO.updateFlight(fUpdate);
                    response.sendRedirect("flights");
                    break;
                }
                default:
                    response.sendRedirect("flights");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            
            handleList(request, response);
        }
    }

    // ================== HANDLER ==================
private void handleList(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String searchFlightNumber = request.getParameter("searchFlightNumber");
    String searchAirlineIdStr = request.getParameter("searchAirlineId");

    List<Flight> flights;
    int totalFlights = 0;
    int totalPages = 1;
    int pageNumber = 1;

    if (searchFlightNumber != null && !searchFlightNumber.isEmpty()) {
        // Search theo số hiệu
        flights = flightDAO.searchByFlightNumber(searchFlightNumber);
        totalFlights = flights.size();
    } else if (searchAirlineIdStr != null && !searchAirlineIdStr.isEmpty()) {
        // Search theo hãng bay
        int searchAirlineId = Integer.parseInt(searchAirlineIdStr);
        flights = flightDAO.searchByAirline(searchAirlineId);
        totalFlights = flights.size();
        request.setAttribute("searchAirlineId", searchAirlineId);
    } else {
        // Phân trang mặc định
        String pageParam = request.getParameter("page");
        try {
            if (pageParam != null) pageNumber = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            pageNumber = 1;
        }
        flights = flightDAO.getAllFlightsWithPagination(pageNumber);
        totalFlights = flightDAO.getTotalFlights();
        int pageSize = 5;
        totalPages = (int) Math.ceil((double) totalFlights / pageSize);
    }

    // load airlines + islands + flightNumbers cho dropdown
    List<Airline> airlines = airlineDAO.getAllAirlines();
    List<Island> islands = islandDAO.getAllIslands();
    List<String> flightNumbers = flightDAO.getAllFlightNumbers();

    request.setAttribute("flights", flights);
    request.setAttribute("currentPage", pageNumber);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("airlines", airlines);
    request.setAttribute("islands", islands);
    request.setAttribute("flightNumbers", flightNumbers);
    request.setAttribute("searchFlightNumber", searchFlightNumber);

    request.getRequestDispatcher("/flights.jsp").forward(request, response);
}



    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int idDelete = Integer.parseInt(request.getParameter("id"));
        flightDAO.deleteFlight(idDelete);
        response.sendRedirect("flights");
    }

    // ================== HELPER ==================
    private Flight buildFlightFromRequest(HttpServletRequest request, int flightId) throws Exception {
        String flightNumber = request.getParameter("flightNumber");
        String airlineIdStr = request.getParameter("airlineId");
        String departure = request.getParameter("departure");
        String destination = request.getParameter("destination");
        String destinationIslandIdStr = request.getParameter("destinationIslandId");
        String departureTimeStr = request.getParameter("departureTime");
        String arrivalTimeStr = request.getParameter("arrivalTime");
        String priceStr = request.getParameter("price");

        // ===== VALIDATE không bỏ trống =====
        if (flightNumber == null || flightNumber.trim().isEmpty()
                || airlineIdStr == null || airlineIdStr.trim().isEmpty()
                || departure == null || departure.trim().isEmpty()
                || destination == null || destination.trim().isEmpty()
                || departureTimeStr == null || departureTimeStr.trim().isEmpty()
                || arrivalTimeStr == null || arrivalTimeStr.trim().isEmpty()
                || priceStr == null || priceStr.trim().isEmpty()) {
            throw new Exception("Vui lòng điền đầy đủ thông tin.");
        }

        // ===== VALIDATE số hiệu trùng =====
        if (flightDAO.existsFlightNumber(flightNumber, flightId)) {
            throw new Exception("Số hiệu chuyến bay đã tồn tại, vui lòng nhập số khác.");
        }

        int airlineId = Integer.parseInt(airlineIdStr);
        Integer destinationIslandId = (destinationIslandIdStr != null && !destinationIslandIdStr.isEmpty())
                ? Integer.parseInt(destinationIslandIdStr) : null;

        double price = Double.parseDouble(priceStr);
        if (price < 0) {
            throw new Exception("Giá vé không được âm.");
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Date departureTime = sdf.parse(departureTimeStr);
        Date arrivalTime = sdf.parse(arrivalTimeStr);

        if (!arrivalTime.after(departureTime)) {
            throw new Exception("Thời gian đến phải sau thời gian khởi hành.");
        }

        // ===== RETURN MODEL =====
        return new Flight(flightId, flightNumber, airlineId, departure, destination,
                destinationIslandId, departureTime, arrivalTime, price);
    }
}
