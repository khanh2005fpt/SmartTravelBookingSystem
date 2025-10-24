/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.Hotel;
import model.Island;
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
 * Servlet for managing hotel operations for staff members
 * Handles hotel CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "HotelStaffServlet", urlPatterns = {"/staff/hotels"})
public class HotelStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in HotelStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in HotelStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for hotel operations
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
                    handleHotelList(request, response);
                    break;
                case "view":
                    handleHotelDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleHotelSearch(request, response);
                    break;
                default:
                    handleHotelList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing hotel request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for hotel operations
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
                    handleCreateHotel(request, response);
                    break;
                case "update":
                    handleUpdateHotel(request, response);
                    break;
                case "delete":
                    handleDeleteHotel(request, response);
                    break;
                case "updateAvailability":
                    handleUpdateAvailability(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/hotels");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing hotel operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all hotels
     */
    private void handleHotelList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Hotel> hotels = serviceDao.getAllHotels();
            request.setAttribute("hotels", hotels);
            request.setAttribute("pageTitle", "Hotel Management");
            request.getRequestDispatcher("/views/staff/hotel-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading hotel list: " + e.getMessage(), e);
        }
    }

    /**
     * Display hotel details
     */
    private void handleHotelDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String hotelIdStr = request.getParameter("id");
            if (hotelIdStr == null || hotelIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Hotel ID is required");
                handleHotelList(request, response);
                return;
            }
            
            int hotelId = Integer.parseInt(hotelIdStr);
            Hotel hotel = serviceDao.getHotelById(hotelId);
            
            if (hotel == null) {
                request.setAttribute("errorMessage", "Hotel not found");
                handleHotelList(request, response);
                return;
            }
            
            request.setAttribute("hotel", hotel);
            request.setAttribute("pageTitle", "Hotel Details - " + hotel.getHotelName());
            request.getRequestDispatcher("/views/staff/hotel-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid hotel ID format");
            handleHotelList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading hotel details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create hotel form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Create New Hotel");
            request.getRequestDispatcher("/views/staff/hotel-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit hotel form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String hotelIdStr = request.getParameter("id");
            if (hotelIdStr == null || hotelIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Hotel ID is required");
                handleHotelList(request, response);
                return;
            }
            
            int hotelId = Integer.parseInt(hotelIdStr);
            Hotel hotel = serviceDao.getHotelById(hotelId);
            
            if (hotel == null) {
                request.setAttribute("errorMessage", "Hotel not found");
                handleHotelList(request, response);
                return;
            }
            
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("hotel", hotel);
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Edit Hotel - " + hotel.getHotelName());
            request.getRequestDispatcher("/views/staff/hotel-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid hotel ID format");
            handleHotelList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading hotel for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle hotel search
     */
    private void handleHotelSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String islandIdStr = request.getParameter("islandId");
            String priceRangeStr = request.getParameter("priceRange");
            String starRatingStr = request.getParameter("starRating");
            
            List<Hotel> hotels;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                hotels = serviceDao.searchHotels(keyword.trim());
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                hotels = serviceDao.getAllHotels();
            }
            
            // Apply additional filters if provided
            if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
                int islandId = Integer.parseInt(islandIdStr);
                request.setAttribute("searchIslandId", islandId);
            }
            
            if (priceRangeStr != null && !priceRangeStr.trim().isEmpty()) {
                request.setAttribute("searchPriceRange", priceRangeStr);
            }
            
            if (starRatingStr != null && !starRatingStr.trim().isEmpty()) {
                request.setAttribute("searchStarRating", starRatingStr);
            }
            
            request.setAttribute("hotels", hotels);
            request.setAttribute("pageTitle", "Hotel Search Results");
            request.getRequestDispatcher("/views/staff/hotel-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid search parameters");
            handleHotelList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error searching hotels: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create hotel
     */
    private void handleCreateHotel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateHotelInput(request)) {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Hotel");
                request.getRequestDispatcher("/views/staff/hotel-form.jsp").forward(request, response);
                return;
            }
            
            // Create hotel object
            Hotel hotel = createHotelFromRequest(request);
            
            // Save hotel
            boolean success = serviceDao.createHotel(hotel);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create hotel. Please try again.");
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Hotel");
                request.getRequestDispatcher("/views/staff/hotel-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating hotel: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update hotel
     */
    private void handleUpdateHotel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateHotelInput(request)) {
                String hotelIdStr = request.getParameter("hotelId");
                if (hotelIdStr != null) {
                    Hotel hotel = serviceDao.getHotelById(Integer.parseInt(hotelIdStr));
                    request.setAttribute("hotel", hotel);
                }
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Hotel");
                request.getRequestDispatcher("/views/staff/hotel-form.jsp").forward(request, response);
                return;
            }
            
            // Create hotel object
            Hotel hotel = createHotelFromRequest(request);
            hotel.setHotelId(Integer.parseInt(request.getParameter("hotelId")));
            
            // Update hotel
            boolean success = serviceDao.updateHotel(hotel);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update hotel. Please try again.");
                request.setAttribute("hotel", hotel);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Hotel");
                request.getRequestDispatcher("/views/staff/hotel-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating hotel: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete hotel
     */
    private void handleDeleteHotel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String hotelIdStr = request.getParameter("hotelId");
            if (hotelIdStr == null || hotelIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?error=invalid_id");
                return;
            }
            
            int hotelId = Integer.parseInt(hotelIdStr);
            boolean success = serviceDao.deleteHotel(hotelId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/hotels?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting hotel: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update hotel availability
     */
    private void handleUpdateAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String hotelIdStr = request.getParameter("hotelId");
            String availabilityStr = request.getParameter("availability");
            
            if (hotelIdStr == null || availabilityStr == null) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?error=invalid_params");
                return;
            }
            
            int hotelId = Integer.parseInt(hotelIdStr);
            int availability = Integer.parseInt(availabilityStr);
            
            boolean success = serviceDao.updateHotelAvailability(hotelId, availability);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?success=availability_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/hotels?error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/hotels?error=invalid_params");
        } catch (Exception e) {
            handleError(request, response, "Error updating hotel availability: " + e.getMessage(), e);
        }
    }

    /**
     * Create hotel object from request parameters
     */
    private Hotel createHotelFromRequest(HttpServletRequest request) {
        Hotel hotel = new Hotel();
        
        hotel.setHotelName(request.getParameter("hotelName"));
        hotel.setAddress(request.getParameter("address"));
        hotel.setDescription(request.getParameter("description"));
        hotel.setImageUrl(request.getParameter("imageUrl"));
        hotel.setContactPhone(request.getParameter("contactPhone"));
        hotel.setContactEmail(request.getParameter("contactEmail"));
        hotel.setWebsite(request.getParameter("website"));
        
        // Set numeric fields
        String pricePerNightStr = request.getParameter("pricePerNight");
        if (pricePerNightStr != null && !pricePerNightStr.trim().isEmpty()) {
            hotel.setPricePerNight(Integer.parseInt(pricePerNightStr));
        }
        
        String starRatingStr = request.getParameter("starRating");
        if (starRatingStr != null && !starRatingStr.trim().isEmpty()) {
            hotel.setStarRating(Integer.parseInt(starRatingStr));
        }
        
        String roomAvailableStr = request.getParameter("roomAvailable");
        if (roomAvailableStr != null && !roomAvailableStr.trim().isEmpty()) {
            hotel.setRoomAvailable(Integer.parseInt(roomAvailableStr));
        }
        
        // Set island if provided
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
            Island island = new Island();
            island.setIslandId(Integer.parseInt(islandIdStr));
            hotel.setIsland(island);
        }
        
        return hotel;
    }

    /**
     * Validate hotel input
     */
    private boolean validateHotelInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String hotelName = request.getParameter("hotelName");
        if (hotelName == null || hotelName.trim().isEmpty()) {
            request.setAttribute("errorHotelName", "Hotel name is required");
            isValid = false;
        }
        
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("errorAddress", "Address is required");
            isValid = false;
        }
        
        String pricePerNightStr = request.getParameter("pricePerNight");
        if (pricePerNightStr == null || pricePerNightStr.trim().isEmpty()) {
            request.setAttribute("errorPricePerNight", "Price per night is required");
            isValid = false;
        } else {
            try {
                int pricePerNight = Integer.parseInt(pricePerNightStr);
                if (pricePerNight <= 0) {
                    request.setAttribute("errorPricePerNight", "Price per night must be greater than 0");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorPricePerNight", "Invalid price format");
                isValid = false;
            }
        }
        
        String starRatingStr = request.getParameter("starRating");
        if (starRatingStr != null && !starRatingStr.trim().isEmpty()) {
            try {
                int starRating = Integer.parseInt(starRatingStr);
                if (starRating < 1 || starRating > 5) {
                    request.setAttribute("errorStarRating", "Star rating must be between 1 and 5");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorStarRating", "Invalid star rating format");
                isValid = false;
            }
        }
        
        String roomAvailableStr = request.getParameter("roomAvailable");
        if (roomAvailableStr != null && !roomAvailableStr.trim().isEmpty()) {
            try {
                int roomAvailable = Integer.parseInt(roomAvailableStr);
                if (roomAvailable < 0) {
                    request.setAttribute("errorRoomAvailable", "Room availability cannot be negative");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorRoomAvailable", "Invalid room availability format");
                isValid = false;
            }
        }
        
        String contactEmail = request.getParameter("contactEmail");
        if (contactEmail != null && !contactEmail.trim().isEmpty()) {
            if (!contactEmail.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                request.setAttribute("errorContactEmail", "Invalid email format");
                isValid = false;
            }
        }
        
        String website = request.getParameter("website");
        if (website != null && !website.trim().isEmpty()) {
            if (!website.matches("^(https?://).*")) {
                request.setAttribute("errorWebsite", "Website must start with http:// or https://");
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
        System.err.println("HotelStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "HotelStaffServlet - Handles hotel management operations for staff";
    }
}