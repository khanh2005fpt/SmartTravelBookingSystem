/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.IslandVehicle;
import model.Island;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for managing island vehicle operations for staff members
 * Handles vehicle CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "VehicleStaffServlet", urlPatterns = {"/staff/vehicles"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class VehicleStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in VehicleStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in VehicleStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for vehicle operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (!isStaffAuthorized(session, request, response)) {
        return;
    }
            
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    handleVehicleList(request, response);
                    break;
                case "view":
                    handleVehicleDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleVehicleSearch(request, response);
                    break;
                default:
                    handleVehicleList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing vehicle request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for vehicle operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
         if (!isStaffAuthorized(session, request, response)) {
        return;
    }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.trim().isEmpty()) {
                // If no action specified, redirect to list view
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?action=list");
                return;
            }
            
            switch (action) {
                case "create":
                    handleCreateVehicle(request, response);
                    break;
                case "update":
                    handleUpdateVehicle(request, response);
                    break;
                case "delete":
                    handleDeleteVehicle(request, response);
                    break;
                case "updateAvailability":
                    handleUpdateAvailability(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/vehicles?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing vehicle operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all vehicles
     */
    private void handleVehicleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            String search = request.getParameter("search");
            
            int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
            int pageSize = (pageSizeParam != null) ? Integer.parseInt(pageSizeParam) : 10;
            
            List<IslandVehicle> vehicles;
            int totalVehicles;
            
            // Handle search or normal listing
            if (search != null && !search.trim().isEmpty()) {
                vehicles = serviceDao.searchVehiclesByNameWithPaginationAndIslandNames(search.trim(), page, pageSize);
                totalVehicles = serviceDao.getSearchVehiclesCount(search.trim());
                request.setAttribute("search", search);
            } else {
                vehicles = serviceDao.getVehiclesByPageWithIslandNames(page, pageSize);
                totalVehicles = serviceDao.getTotalVehiclesCount();
            }
            
            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalVehicles / pageSize);
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            
            // Set attributes
            request.setAttribute("vehicles", vehicles);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("pageTitle", "Vehicle Management");
            
            request.getRequestDispatcher("/views/staff/vehicle-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading vehicle list: " + e.getMessage(), e);
        }
    }

    /**
     * Display vehicle details
     */
    private void handleVehicleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String vehicleIdStr = request.getParameter("id");
            if (vehicleIdStr == null || vehicleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vehicle ID is required");
                handleVehicleList(request, response);
                return;
            }
            
            int vehicleId = Integer.parseInt(vehicleIdStr);
            IslandVehicle vehicle = serviceDao.getIslandVehicleById(vehicleId);
            
            if (vehicle == null) {
                request.setAttribute("errorMessage", "Vehicle not found");
                handleVehicleList(request, response);
                return;
            }
            
            request.setAttribute("vehicle", vehicle);
            request.setAttribute("pageTitle", "Vehicle Details - " + vehicle.getModelName());
            request.getRequestDispatcher("/views/staff/vehicle-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid vehicle ID format");
            handleVehicleList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading vehicle details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create vehicle form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Create New Vehicle");
            request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit vehicle form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String vehicleIdStr = request.getParameter("id");
            if (vehicleIdStr == null || vehicleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vehicle ID is required");
                handleVehicleList(request, response);
                return;
            }
            
            int vehicleId = Integer.parseInt(vehicleIdStr);
            IslandVehicle vehicle = serviceDao.getIslandVehicleById(vehicleId);
            
            if (vehicle == null) {
                request.setAttribute("errorMessage", "Vehicle not found");
                handleVehicleList(request, response);
                return;
            }
            
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("vehicle", vehicle);
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Edit Vehicle - " + vehicle.getModelName());
            request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid vehicle ID format");
            handleVehicleList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading vehicle for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle vehicle search
     */
    private void handleVehicleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String islandIdStr = request.getParameter("islandId");
            String vehicleType = request.getParameter("vehicleType");
            String priceRangeStr = request.getParameter("priceRange");
            
            List<IslandVehicle> vehicles;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                vehicles = serviceDao.searchIslandVehicles(keyword.trim());
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                vehicles = serviceDao.getAllIslandVehicles();
            }
            
            // Apply additional filters if provided
            if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
                int islandId = Integer.parseInt(islandIdStr);
                request.setAttribute("searchIslandId", islandId);
            }
            
            if (vehicleType != null && !vehicleType.trim().isEmpty()) {
                request.setAttribute("searchVehicleType", vehicleType);
            }
            
            if (priceRangeStr != null && !priceRangeStr.trim().isEmpty()) {
                request.setAttribute("searchPriceRange", priceRangeStr);
            }
            
            request.setAttribute("vehicles", vehicles);
            request.setAttribute("pageTitle", "Vehicle Search Results");
            request.getRequestDispatcher("/views/staff/vehicle-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid search parameters");
            handleVehicleList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error searching vehicles: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create vehicle
     */
    private void handleCreateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateVehicleInput(request)) {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Vehicle");
                request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
                return;
            }
            
            // Create vehicle object
            IslandVehicle vehicle = createVehicleFromRequest(request);
            
            // Save vehicle
            boolean success = serviceDao.createIslandVehicle(vehicle);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create vehicle. Please try again.");
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Vehicle");
                request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating vehicle: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update vehicle
     */
    private void handleUpdateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateVehicleInput(request)) {
                String vehicleIdStr = request.getParameter("id");
                if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
                    try {
                        IslandVehicle vehicle = serviceDao.getIslandVehicleById(Integer.parseInt(vehicleIdStr));
                        request.setAttribute("vehicle", vehicle);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid vehicle ID format: " + vehicleIdStr);
                    }
                }
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Vehicle");
                request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
                return;
            }
            
            // Create vehicle object
            IslandVehicle vehicle = createVehicleFromRequest(request);
            
            // Parse and set vehicle ID with error handling
            String vehicleIdStr = request.getParameter("id");
            if (vehicleIdStr == null || vehicleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vehicle ID is missing. Cannot update vehicle.");
                request.setAttribute("vehicle", vehicle);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Vehicle");
                request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
                return;
            }
            
            try {
                vehicle.setVehicleId(Integer.parseInt(vehicleIdStr));
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid vehicle ID format. Cannot update vehicle.");
                request.setAttribute("vehicle", vehicle);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Vehicle");
                request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
                return;
            }
            
            // Update vehicle
            boolean success = serviceDao.updateIslandVehicle(vehicle);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update vehicle. Please try again.");
                request.setAttribute("vehicle", vehicle);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Vehicle");
                request.getRequestDispatcher("/views/staff/vehicle-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating vehicle: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete vehicle
     */
    private void handleDeleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String vehicleIdStr = request.getParameter("vehicleId");
            if (vehicleIdStr == null || vehicleIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?error=invalid_id");
                return;
            }
            
            int vehicleId = Integer.parseInt(vehicleIdStr);
            boolean success = serviceDao.deleteIslandVehicle(vehicleId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/vehicles?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting vehicle: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update vehicle availability
     */
    private void handleUpdateAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String vehicleIdStr = request.getParameter("vehicleId");
            String availabilityStr = request.getParameter("availability");
            
            if (vehicleIdStr == null || availabilityStr == null) {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?error=invalid_params");
                return;
            }
            
            int vehicleId = Integer.parseInt(vehicleIdStr);
            int availability = Integer.parseInt(availabilityStr);
            
            boolean success = serviceDao.updateVehicleAvailability(vehicleId, availability);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?success=availability_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/vehicles?error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/vehicles?error=invalid_params");
        } catch (Exception e) {
            handleError(request, response, "Error updating vehicle availability: " + e.getMessage(), e);
        }
    }

    /**
     * Create vehicle object from request parameters
     */
    private IslandVehicle createVehicleFromRequest(HttpServletRequest request) {
        IslandVehicle vehicle = new IslandVehicle();
        
        // Set basic fields that exist in database
        vehicle.setVehicleType(request.getParameter("vehicleType"));
        vehicle.setModelName(request.getParameter("modelName"));
        
        // Set numeric fields
        String pricePerDayStr = request.getParameter("pricePerDay");
        if (pricePerDayStr != null && !pricePerDayStr.trim().isEmpty()) {
            vehicle.setPricePerDay(Double.parseDouble(pricePerDayStr));
        }
        
        String capacityStr = request.getParameter("capacity");
        if (capacityStr != null && !capacityStr.trim().isEmpty()) {
            vehicle.setCapacity(Integer.parseInt(capacityStr));
        }
        
        String availabilityStr = request.getParameter("availability");
        if (availabilityStr != null && !availabilityStr.trim().isEmpty()) {
            vehicle.setAvailability(Integer.parseInt(availabilityStr));
        }
        
        // Set island ID
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
            vehicle.setIslandId(Integer.parseInt(islandIdStr));
        }
        
        // Set JSP compatibility fields to modelName for display purposes
        vehicle.setVehicleName(vehicle.getModelName());
        vehicle.setModel(vehicle.getModelName());
        vehicle.setBrand("");
        
        return vehicle;
    }

    /**
     * Validate vehicle input
     */
    private boolean validateVehicleInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String modelName = request.getParameter("modelName");
        if (modelName == null || modelName.trim().isEmpty()) {
            request.setAttribute("errorModelName", "Model name is required");
            isValid = false;
        }
        
        String vehicleType = request.getParameter("vehicleType");
        if (vehicleType == null || vehicleType.trim().isEmpty()) {
            request.setAttribute("errorVehicleType", "Vehicle type is required");
            isValid = false;
        }
        
        String pricePerDayStr = request.getParameter("pricePerDay");
        if (pricePerDayStr == null || pricePerDayStr.trim().isEmpty()) {
            request.setAttribute("errorPricePerDay", "Price per day is required");
            isValid = false;
        } else {
            try {
                double pricePerDay = Double.parseDouble(pricePerDayStr);
                if (pricePerDay <= 0) {
                    request.setAttribute("errorPricePerDay", "Price per day must be greater than 0");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorPricePerDay", "Invalid price format");
                isValid = false;
            }
        }
        
        String capacityStr = request.getParameter("capacity");
        if (capacityStr == null || capacityStr.trim().isEmpty()) {
            request.setAttribute("errorCapacity", "Capacity is required");
            isValid = false;
        } else {
            try {
                int capacity = Integer.parseInt(capacityStr);
                if (capacity <= 0) {
                    request.setAttribute("errorCapacity", "Capacity must be greater than 0");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorCapacity", "Invalid capacity format");
                isValid = false;
            }
        }
        
        String availabilityStr = request.getParameter("availability");
        if (availabilityStr == null || availabilityStr.trim().isEmpty()) {
            request.setAttribute("errorAvailability", "Availability is required");
            isValid = false;
        } else {
            try {
                int availability = Integer.parseInt(availabilityStr);
                if (availability < 0) {
                    request.setAttribute("errorAvailability", "Availability cannot be negative");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorAvailability", "Invalid availability format");
                isValid = false;
            }
        }
        
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
            request.setAttribute("errorIslandId", "Island selection is required");
            isValid = false;
        }
        
        return isValid;
    }

    /**
     * Check if user is authorized staff member
     */
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

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                           String message, Exception e) throws ServletException, IOException {
        System.err.println("VehicleStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "VehicleStaffServlet - Handles vehicle management operations for staff";
    }
}