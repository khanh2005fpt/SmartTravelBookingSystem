/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.FlightSchedule;
import model.Flight;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for managing flight schedule operations for staff members
 * Handles flight schedule CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "FlightScheduleStaffServlet", urlPatterns = {"/staff/flight-schedules"})
public class FlightScheduleStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in FlightScheduleStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in FlightScheduleStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for flight schedule operations
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
                    handleScheduleList(request, response);
                    break;
                case "view":
                    handleScheduleDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleScheduleSearch(request, response);
                    break;
                default:
                    handleScheduleList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight schedule request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for flight schedule operations
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
                    handleCreateSchedule(request, response);
                    break;
                case "update":
                    handleUpdateSchedule(request, response);
                    break;
                case "delete":
                    handleDeleteSchedule(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/flight-schedules");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight schedule operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all flight schedules
     */
    private void handleScheduleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<FlightSchedule> schedules = serviceDao.getAllFlightSchedules();
            request.setAttribute("schedules", schedules);
            request.setAttribute("pageTitle", "Flight Schedule Management");
            request.getRequestDispatcher("/views/staff/flight-schedule-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight schedule list: " + e.getMessage(), e);
        }
    }

    /**
     * Display flight schedule details
     */
    private void handleScheduleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String scheduleIdStr = request.getParameter("id");
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Schedule ID is required");
                handleScheduleList(request, response);
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            FlightSchedule schedule = serviceDao.getFlightScheduleById(scheduleId);
            
            if (schedule == null) {
                request.setAttribute("errorMessage", "Flight schedule not found");
                handleScheduleList(request, response);
                return;
            }
            
            request.setAttribute("schedule", schedule);
            request.setAttribute("pageTitle", "Flight Schedule Details - " + schedule.getFlight().getFlightNumber());
            request.getRequestDispatcher("/views/staff/flight-schedule-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid schedule ID format");
            handleScheduleList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight schedule details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create flight schedule form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load available flights for dropdown
            List<Flight> flights = serviceDao.getAllFlights();
            request.setAttribute("flights", flights);
            request.setAttribute("pageTitle", "Create New Flight Schedule");
            request.getRequestDispatcher("/views/staff/flight-schedule-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit flight schedule form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String scheduleIdStr = request.getParameter("id");
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Schedule ID is required");
                handleScheduleList(request, response);
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            FlightSchedule schedule = serviceDao.getFlightScheduleById(scheduleId);
            
            if (schedule == null) {
                request.setAttribute("errorMessage", "Flight schedule not found");
                handleScheduleList(request, response);
                return;
            }
            
            // Load available flights for dropdown
            List<Flight> flights = serviceDao.getAllFlights();
            request.setAttribute("flights", flights);
            request.setAttribute("schedule", schedule);
            request.setAttribute("pageTitle", "Edit Flight Schedule - " + schedule.getFlight().getFlightNumber());
            request.getRequestDispatcher("/views/staff/flight-schedule-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid schedule ID format");
            handleScheduleList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight schedule for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle flight schedule search
     */
    private void handleScheduleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String flightNumber = request.getParameter("flightNumber");
            String planeModel = request.getParameter("planeModel");
            String departureAirport = request.getParameter("departureAirport");
            String arrivalAirport = request.getParameter("arrivalAirport");
            
            List<FlightSchedule> schedules = serviceDao.getAllFlightSchedules();
            
            // Apply filters if provided
            if (keyword != null && !keyword.trim().isEmpty()) {
                request.setAttribute("searchKeyword", keyword.trim());
            }
            
            if (flightNumber != null && !flightNumber.trim().isEmpty()) {
                request.setAttribute("searchFlightNumber", flightNumber);
            }
            
            if (planeModel != null && !planeModel.trim().isEmpty()) {
                request.setAttribute("searchPlaneModel", planeModel);
            }
            
            if (departureAirport != null && !departureAirport.trim().isEmpty()) {
                request.setAttribute("searchDepartureAirport", departureAirport);
            }
            
            if (arrivalAirport != null && !arrivalAirport.trim().isEmpty()) {
                request.setAttribute("searchArrivalAirport", arrivalAirport);
            }
            
            request.setAttribute("schedules", schedules);
            request.setAttribute("pageTitle", "Flight Schedule Search Results");
            request.getRequestDispatcher("/views/staff/flight-schedule-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Error searching flight schedules: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create flight schedule
     */
    private void handleCreateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateScheduleInput(request)) {
                List<Flight> flights = serviceDao.getAllFlights();
                request.setAttribute("flights", flights);
                request.setAttribute("pageTitle", "Create New Flight Schedule");
                request.getRequestDispatcher("/views/staff/flight-schedule-form.jsp").forward(request, response);
                return;
            }
            
            // Create flight schedule object
            FlightSchedule schedule = createScheduleFromRequest(request);
            
            // Save flight schedule
            boolean success = serviceDao.createFlightSchedule(schedule);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flight-schedules?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create flight schedule. Please try again.");
                List<Flight> flights = serviceDao.getAllFlights();
                request.setAttribute("flights", flights);
                request.setAttribute("pageTitle", "Create New Flight Schedule");
                request.getRequestDispatcher("/views/staff/flight-schedule-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating flight schedule: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update flight schedule
     */
    private void handleUpdateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateScheduleInput(request)) {
                String scheduleIdStr = request.getParameter("scheduleId");
                if (scheduleIdStr != null) {
                    FlightSchedule schedule = serviceDao.getFlightScheduleById(Integer.parseInt(scheduleIdStr));
                    request.setAttribute("schedule", schedule);
                }
                List<Flight> flights = serviceDao.getAllFlights();
                request.setAttribute("flights", flights);
                request.setAttribute("pageTitle", "Edit Flight Schedule");
                request.getRequestDispatcher("/views/staff/flight-schedule-form.jsp").forward(request, response);
                return;
            }
            
            // Create flight schedule object
            FlightSchedule schedule = createScheduleFromRequest(request);
            schedule.setScheduleId(Integer.parseInt(request.getParameter("scheduleId")));
            
            // Update flight schedule
            boolean success = serviceDao.updateFlightSchedule(schedule);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flight-schedules?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update flight schedule. Please try again.");
                List<Flight> flights = serviceDao.getAllFlights();
                request.setAttribute("flights", flights);
                request.setAttribute("schedule", schedule);
                request.setAttribute("pageTitle", "Edit Flight Schedule");
                request.getRequestDispatcher("/views/staff/flight-schedule-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating flight schedule: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete flight schedule
     */
    private void handleDeleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String scheduleIdStr = request.getParameter("scheduleId");
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/flight-schedules?error=invalid_id");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            boolean success = serviceDao.deleteFlightSchedule(scheduleId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flight-schedules?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/flight-schedules?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/flight-schedules?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting flight schedule: " + e.getMessage(), e);
        }
    }

    /**
     * Create flight schedule object from request parameters
     */
    private FlightSchedule createScheduleFromRequest(HttpServletRequest request) throws Exception {
        FlightSchedule schedule = new FlightSchedule();
        
        // Set flight
        String flightIdStr = request.getParameter("flightId");
        if (flightIdStr != null && !flightIdStr.trim().isEmpty()) {
            int flightId = Integer.parseInt(flightIdStr);
            Flight flight = serviceDao.getFlightById(flightId);
            if (flight != null) {
                schedule.setFlight(flight);
            }
        }
        
        schedule.setPlaneModel(request.getParameter("planeModel"));
        schedule.setDepartureAirport(request.getParameter("departureAirport"));
        schedule.setArrivalAirport(request.getParameter("arrivalAirport"));
        schedule.setTransitAirport(request.getParameter("transitAirport"));
        schedule.setTransitDuration(request.getParameter("transitDuration"));
        
        // Set seat capacity
        String seatCapacityStr = request.getParameter("seatCapacity");
        if (seatCapacityStr != null && !seatCapacityStr.trim().isEmpty()) {
            schedule.setSeatCapacity(Integer.parseInt(seatCapacityStr));
        }
        
        schedule.setCabinBaggage(request.getParameter("cabinBaggage"));
        schedule.setSeatPitch(request.getParameter("seatPitch"));
        schedule.setNotes(request.getParameter("notes"));
        
        return schedule;
    }

    /**
     * Validate flight schedule input
     */
    private boolean validateScheduleInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String flightId = request.getParameter("flightId");
        if (flightId == null || flightId.trim().isEmpty()) {
            request.setAttribute("errorFlightId", "Flight is required");
            isValid = false;
        }
        
        String planeModel = request.getParameter("planeModel");
        if (planeModel == null || planeModel.trim().isEmpty()) {
            request.setAttribute("errorPlaneModel", "Plane model is required");
            isValid = false;
        }
        
        String departureAirport = request.getParameter("departureAirport");
        if (departureAirport == null || departureAirport.trim().isEmpty()) {
            request.setAttribute("errorDepartureAirport", "Departure airport is required");
            isValid = false;
        }
        
        String arrivalAirport = request.getParameter("arrivalAirport");
        if (arrivalAirport == null || arrivalAirport.trim().isEmpty()) {
            request.setAttribute("errorArrivalAirport", "Arrival airport is required");
            isValid = false;
        }
        
        String seatCapacityStr = request.getParameter("seatCapacity");
        if (seatCapacityStr != null && !seatCapacityStr.trim().isEmpty()) {
            try {
                int seatCapacity = Integer.parseInt(seatCapacityStr);
                if (seatCapacity <= 0) {
                    request.setAttribute("errorSeatCapacity", "Seat capacity must be greater than 0");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorSeatCapacity", "Invalid seat capacity format");
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
        System.err.println("FlightScheduleStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "FlightScheduleStaffServlet - Handles flight schedule management operations for staff";
    }
}