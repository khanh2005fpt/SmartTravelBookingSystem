/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.Flight;
import model.Airlines;
import model.Island;
import model.User;
import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for managing flight operations for staff members
 * Handles flight CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "FlightStaffServlet", urlPatterns = {"/staff/flights"})
public class FlightStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in FlightStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in FlightStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for flight operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (!isStaffAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    handleFlightList(request, response);
                    break;
                case "view":
                    handleFlightDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleFlightSearch(request, response);
                    break;
                default:
                    handleFlightList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for flight operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!isStaffAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    handleCreateFlight(request, response);
                    break;
                case "update":
                    handleUpdateFlight(request, response);
                    break;
                case "delete":
                    handleDeleteFlight(request, response);
                    break;
                case "updateAvailability":
                    handleUpdateAvailability(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/flights");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all flights
     */
    private void handleFlightList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Flight> flights = serviceDao.getAllFlights();
            request.setAttribute("flights", flights);
            request.setAttribute("pageTitle", "Flight Management");
            request.getRequestDispatcher("/views/staff/flight-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight list: " + e.getMessage(), e);
        }
    }

    /**
     * Display flight details
     */
    private void handleFlightDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("id");
            if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Flight ID is required");
                handleFlightList(request, response);
                return;
            }
            
            int flightId = Integer.parseInt(flightIdStr);
            Flight flight = serviceDao.getFlightById(flightId);
            
            if (flight == null) {
                request.setAttribute("errorMessage", "Flight not found");
                handleFlightList(request, response);
                return;
            }
            
            request.setAttribute("flight", flight);
            request.setAttribute("pageTitle", "Flight Details - " + flight.getFlightNumber());
            request.getRequestDispatcher("/views/staff/flight-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid flight ID format");
            handleFlightList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create flight form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load airlines and islands for dropdowns
            List<Airlines> airlines = serviceDao.getAllAirlines();
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("airlines", airlines);
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Create New Flight");
            request.getRequestDispatcher("/views/staff/flight-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit flight form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("id");
            if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Flight ID is required");
                handleFlightList(request, response);
                return;
            }
            
            int flightId = Integer.parseInt(flightIdStr);
            Flight flight = serviceDao.getFlightById(flightId);
            
            if (flight == null) {
                request.setAttribute("errorMessage", "Flight not found");
                handleFlightList(request, response);
                return;
            }
            
            // Load airlines and islands for dropdowns
            List<Airlines> airlines = serviceDao.getAllAirlines();
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("flight", flight);
            request.setAttribute("airlines", airlines);
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Edit Flight - " + flight.getFlightNumber());
            request.getRequestDispatcher("/views/staff/flight-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid flight ID format");
            handleFlightList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle flight search
     */
    private void handleFlightSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String islandIdStr = request.getParameter("islandId");
            List<Flight> flights;
            
            if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
                int islandId = Integer.parseInt(islandIdStr);
                flights = serviceDao.getFlightsByIslandId(islandId);
                request.setAttribute("searchIslandId", islandId);
            } else {
                flights = serviceDao.getAllFlights();
            }
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                request.setAttribute("searchKeyword", keyword.trim());
            }
            
            request.setAttribute("flights", flights);
            request.setAttribute("pageTitle", "Flight Search Results");
            request.getRequestDispatcher("/views/staff/flight-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid island ID format");
            handleFlightList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error searching flights: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create flight
     */
    private void handleCreateFlight(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateFlightInput(request)) {
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Flight");
                request.getRequestDispatcher("/views/staff/flight-form.jsp").forward(request, response);
                return;
            }
            
            // Create flight object
            Flight flight = createFlightFromRequest(request);
            
            // Save flight
            boolean success = serviceDao.createFlight(flight);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create flight. Please try again.");
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Flight");
                request.getRequestDispatcher("/views/staff/flight-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating flight: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update flight
     */
    private void handleUpdateFlight(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateFlightInput(request)) {
                String flightIdStr = request.getParameter("flightId");
                if (flightIdStr != null) {
                    Flight flight = serviceDao.getFlightById(Integer.parseInt(flightIdStr));
                    request.setAttribute("flight", flight);
                }
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Flight");
                request.getRequestDispatcher("/views/staff/flight-form.jsp").forward(request, response);
                return;
            }
            
            // Create flight object
            Flight flight = createFlightFromRequest(request);
            flight.setFlightId(Integer.parseInt(request.getParameter("flightId")));
            
            // Update flight
            boolean success = serviceDao.updateFlight(flight);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update flight. Please try again.");
                request.setAttribute("flight", flight);
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Flight");
                request.getRequestDispatcher("/views/staff/flight-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating flight: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete flight
     */
    private void handleDeleteFlight(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("flightId");
            if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_id");
                return;
            }
            
            int flightId = Integer.parseInt(flightIdStr);
            boolean success = serviceDao.deleteFlight(flightId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting flight: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update flight availability
     */
    private void handleUpdateAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("flightId");
            String availabilityStr = request.getParameter("availability");
            
            if (flightIdStr == null || availabilityStr == null) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_params");
                return;
            }
            
            int flightId = Integer.parseInt(flightIdStr);
            int availability = Integer.parseInt(availabilityStr);
            
            boolean success = serviceDao.updateFlightAvailability(flightId, availability);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?success=availability_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_params");
        } catch (Exception e) {
            handleError(request, response, "Error updating flight availability: " + e.getMessage(), e);
        }
    }

    /**
     * Create flight object from request parameters
     */
    private Flight createFlightFromRequest(HttpServletRequest request) {
        Flight flight = new Flight();
        
        flight.setFlightNumber(request.getParameter("flightNumber"));
        flight.setDeparture(request.getParameter("departure"));
        flight.setDestination(request.getParameter("destination"));
        flight.setBasePrice(Integer.parseInt(request.getParameter("basePrice")));
        flight.setTicketAvailable(Integer.parseInt(request.getParameter("ticketAvailable")));
        flight.setFlightType(request.getParameter("flightType"));
        flight.setFlightClass(request.getParameter("flightClass"));
        flight.setDestinationImageUrl(request.getParameter("destinationImageUrl"));
        
        // Set airline
        Airlines airline = new Airlines();
        airline.setAirlineId(Integer.parseInt(request.getParameter("airlineId")));
        flight.setAirline(airline);
        
        // Set destination island if provided
        String destinationIslandIdStr = request.getParameter("destinationIslandId");
        if (destinationIslandIdStr != null && !destinationIslandIdStr.trim().isEmpty()) {
            Island island = new Island();
            island.setIslandId(Integer.parseInt(destinationIslandIdStr));
            flight.setDestinationIsland(island);
        }
        
        // Set times if provided
        String departureTime = request.getParameter("departureTime");
        if (departureTime != null && !departureTime.trim().isEmpty()) {
            flight.setDepartureTime(LocalTime.parse(departureTime));
        }
        
        String arrivalTime = request.getParameter("arrivalTime");
        if (arrivalTime != null && !arrivalTime.trim().isEmpty()) {
            flight.setArrivalTime(LocalTime.parse(arrivalTime));
        }
        
        String returnDepartureTime = request.getParameter("returnDepartureTime");
        if (returnDepartureTime != null && !returnDepartureTime.trim().isEmpty()) {
            flight.setReturnDepartureTime(LocalTime.parse(returnDepartureTime));
        }
        
        String returnArrivalTime = request.getParameter("returnArrivalTime");
        if (returnArrivalTime != null && !returnArrivalTime.trim().isEmpty()) {
            flight.setReturnArrivalTime(LocalTime.parse(returnArrivalTime));
        }
        
        return flight;
    }

    /**
     * Validate flight input
     */
    private boolean validateFlightInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String flightNumber = request.getParameter("flightNumber");
        if (flightNumber == null || flightNumber.trim().isEmpty()) {
            request.setAttribute("errorFlightNumber", "Flight number is required");
            isValid = false;
        }
        
        String airlineIdStr = request.getParameter("airlineId");
        if (airlineIdStr == null || airlineIdStr.trim().isEmpty()) {
            request.setAttribute("errorAirlineId", "Airline is required");
            isValid = false;
        } else {
            try {
                Integer.parseInt(airlineIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorAirlineId", "Invalid airline selection");
                isValid = false;
            }
        }
        
        String departure = request.getParameter("departure");
        if (departure == null || departure.trim().isEmpty()) {
            request.setAttribute("errorDeparture", "Departure location is required");
            isValid = false;
        }
        
        String destination = request.getParameter("destination");
        if (destination == null || destination.trim().isEmpty()) {
            request.setAttribute("errorDestination", "Destination is required");
            isValid = false;
        }
        
        String basePriceStr = request.getParameter("basePrice");
        if (basePriceStr == null || basePriceStr.trim().isEmpty()) {
            request.setAttribute("errorBasePrice", "Base price is required");
            isValid = false;
        } else {
            try {
                int basePrice = Integer.parseInt(basePriceStr);
                if (basePrice <= 0) {
                    request.setAttribute("errorBasePrice", "Base price must be greater than 0");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorBasePrice", "Invalid base price format");
                isValid = false;
            }
        }
        
        String ticketAvailableStr = request.getParameter("ticketAvailable");
        if (ticketAvailableStr == null || ticketAvailableStr.trim().isEmpty()) {
            request.setAttribute("errorTicketAvailable", "Ticket availability is required");
            isValid = false;
        } else {
            try {
                int ticketAvailable = Integer.parseInt(ticketAvailableStr);
                if (ticketAvailable < 0) {
                    request.setAttribute("errorTicketAvailable", "Ticket availability cannot be negative");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorTicketAvailable", "Invalid ticket availability format");
                isValid = false;
            }
        }
        
        String flightType = request.getParameter("flightType");
        if (flightType == null || flightType.trim().isEmpty()) {
            request.setAttribute("errorFlightType", "Flight type is required");
            isValid = false;
        }
        
        String flightClass = request.getParameter("flightClass");
        if (flightClass == null || flightClass.trim().isEmpty()) {
            request.setAttribute("errorFlightClass", "Flight class is required");
            isValid = false;
        }
        
        // Validate time formats if provided
        String departureTime = request.getParameter("departureTime");
        if (departureTime != null && !departureTime.trim().isEmpty()) {
            try {
                LocalTime.parse(departureTime);
            } catch (DateTimeParseException e) {
                request.setAttribute("errorDepartureTime", "Invalid departure time format (HH:MM)");
                isValid = false;
            }
        }
        
        String arrivalTime = request.getParameter("arrivalTime");
        if (arrivalTime != null && !arrivalTime.trim().isEmpty()) {
            try {
                LocalTime.parse(arrivalTime);
            } catch (DateTimeParseException e) {
                request.setAttribute("errorArrivalTime", "Invalid arrival time format (HH:MM)");
                isValid = false;
            }
        }
        
        return isValid;
    }

    /**
     * Check if user is authorized staff member
     */
    private boolean isStaffAuthorized(HttpSession session) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "staff".equals(role) || "admin".equals(role);
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                           String message, Exception e) throws ServletException, IOException {
        System.err.println("FlightStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "FlightStaffServlet - Handles flight management operations for staff";
    }
}