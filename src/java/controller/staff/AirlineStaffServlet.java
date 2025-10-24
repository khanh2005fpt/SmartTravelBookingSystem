/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.Airlines;
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
 * Servlet for managing airline operations for staff members
 * Handles airline CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "AirlineStaffServlet", urlPatterns = {"/staff/airlines"})
public class AirlineStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in AirlineStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in AirlineStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for airline operations
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
                    handleAirlineList(request, response);
                    break;
                case "view":
                    handleAirlineDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleAirlineSearch(request, response);
                    break;
                default:
                    handleAirlineList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing airline request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for airline operations
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
                    handleCreateAirline(request, response);
                    break;
                case "update":
                    handleUpdateAirline(request, response);
                    break;
                case "delete":
                    handleDeleteAirline(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/airlines");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing airline operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all airlines
     */
    private void handleAirlineList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Airlines> airlines = serviceDao.getAllAirlines();
            request.setAttribute("airlines", airlines);
            request.setAttribute("pageTitle", "Airline Management");
            request.getRequestDispatcher("/views/staff/airline-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading airline list: " + e.getMessage(), e);
        }
    }

    /**
     * Display airline details
     */
    private void handleAirlineDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String airlineIdStr = request.getParameter("id");
            if (airlineIdStr == null || airlineIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Airline ID is required");
                handleAirlineList(request, response);
                return;
            }
            
            int airlineId = Integer.parseInt(airlineIdStr);
            Airlines airline = serviceDao.getAirlineById(airlineId);
            
            if (airline == null) {
                request.setAttribute("errorMessage", "Airline not found");
                handleAirlineList(request, response);
                return;
            }
            
            request.setAttribute("airline", airline);
            request.setAttribute("pageTitle", "Airline Details - " + airline.getAirlineName());
            request.getRequestDispatcher("/views/staff/airline-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid airline ID format");
            handleAirlineList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading airline details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create airline form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Create New Airline");
        request.getRequestDispatcher("/views/staff/airline-form.jsp").forward(request, response);
    }

    /**
     * Display edit airline form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String airlineIdStr = request.getParameter("id");
            if (airlineIdStr == null || airlineIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Airline ID is required");
                handleAirlineList(request, response);
                return;
            }
            
            int airlineId = Integer.parseInt(airlineIdStr);
            Airlines airline = serviceDao.getAirlineById(airlineId);
            
            if (airline == null) {
                request.setAttribute("errorMessage", "Airline not found");
                handleAirlineList(request, response);
                return;
            }
            
            request.setAttribute("airline", airline);
            request.setAttribute("pageTitle", "Edit Airline - " + airline.getAirlineName());
            request.getRequestDispatcher("/views/staff/airline-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid airline ID format");
            handleAirlineList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading airline for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle airline search
     */
    private void handleAirlineSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            List<Airlines> airlines;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                airlines = serviceDao.searchAirlines(keyword.trim());
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                airlines = serviceDao.getAllAirlines();
            }
            
            request.setAttribute("airlines", airlines);
            request.setAttribute("pageTitle", "Airline Search Results");
            request.getRequestDispatcher("/views/staff/airline-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Error searching airlines: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create airline
     */
    private void handleCreateAirline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateAirlineInput(request)) {
                request.setAttribute("pageTitle", "Create New Airline");
                request.getRequestDispatcher("/views/staff/airline-form.jsp").forward(request, response);
                return;
            }
            
            // Create airline object
            Airlines airline = new Airlines();
            airline.setAirlineName(request.getParameter("airlineName"));
            airline.setIataCode(request.getParameter("iataCode"));
            airline.setCountryId(Integer.parseInt(request.getParameter("countryId")));
            airline.setHotline(request.getParameter("hotline"));
            airline.setLogoUrl(request.getParameter("logoUrl"));
            
            // Save airline
            boolean success = serviceDao.createAirline(airline);
            
            if (success) {
                request.setAttribute("successMessage", "Airline created successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/airlines?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create airline. Please try again.");
                request.setAttribute("pageTitle", "Create New Airline");
                request.getRequestDispatcher("/views/staff/airline-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating airline: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update airline
     */
    private void handleUpdateAirline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateAirlineInput(request)) {
                String airlineIdStr = request.getParameter("airlineId");
                if (airlineIdStr != null) {
                    Airlines airline = serviceDao.getAirlineById(Integer.parseInt(airlineIdStr));
                    request.setAttribute("airline", airline);
                }
                request.setAttribute("pageTitle", "Edit Airline");
                request.getRequestDispatcher("/views/staff/airline-form.jsp").forward(request, response);
                return;
            }
            
            // Create airline object
            Airlines airline = new Airlines();
            airline.setAirlineId(Integer.parseInt(request.getParameter("airlineId")));
            airline.setAirlineName(request.getParameter("airlineName"));
            airline.setIataCode(request.getParameter("iataCode"));
            airline.setCountryId(Integer.parseInt(request.getParameter("countryId")));
            airline.setHotline(request.getParameter("hotline"));
            airline.setLogoUrl(request.getParameter("logoUrl"));
            
            // Update airline
            boolean success = serviceDao.updateAirline(airline);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/airlines?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update airline. Please try again.");
                request.setAttribute("airline", airline);
                request.setAttribute("pageTitle", "Edit Airline");
                request.getRequestDispatcher("/views/staff/airline-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating airline: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete airline
     */
    private void handleDeleteAirline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String airlineIdStr = request.getParameter("airlineId");
            if (airlineIdStr == null || airlineIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/airlines?error=invalid_id");
                return;
            }
            
            int airlineId = Integer.parseInt(airlineIdStr);
            boolean success = serviceDao.deleteAirline(airlineId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/airlines?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/airlines?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/airlines?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting airline: " + e.getMessage(), e);
        }
    }

    /**
     * Validate airline input
     */
    private boolean validateAirlineInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String airlineName = request.getParameter("airlineName");
        if (airlineName == null || airlineName.trim().isEmpty()) {
            request.setAttribute("errorAirlineName", "Airline name is required");
            isValid = false;
        }
        
        String iataCode = request.getParameter("iataCode");
        if (iataCode == null || iataCode.trim().isEmpty()) {
            request.setAttribute("errorIataCode", "IATA code is required");
            isValid = false;
        } else if (iataCode.trim().length() != 2) {
            request.setAttribute("errorIataCode", "IATA code must be exactly 2 characters");
            isValid = false;
        }
        
        String countryIdStr = request.getParameter("countryId");
        if (countryIdStr == null || countryIdStr.trim().isEmpty()) {
            request.setAttribute("errorCountryId", "Country is required");
            isValid = false;
        } else {
            try {
                Integer.parseInt(countryIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorCountryId", "Invalid country selection");
                isValid = false;
            }
        }
        
        String hotline = request.getParameter("hotline");
        if (hotline == null || hotline.trim().isEmpty()) {
            request.setAttribute("errorHotline", "Hotline is required");
            isValid = false;
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
        System.err.println("AirlineStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "AirlineStaffServlet - Handles airline management operations for staff";
    }
}