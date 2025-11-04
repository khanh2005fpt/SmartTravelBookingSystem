/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.Hotel;
import model.Island;
import model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet for managing hotel operations for staff members
 * Handles hotel CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "HotelStaffServlet", urlPatterns = {"/staff/hotels"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
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
            if (action == null) {
                response.sendRedirect(request.getContextPath() + "/staff/hotels");
                return;
            }
            
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
            List<Hotel> hotels = serviceDao.getHotels();
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
                // Use searchHotels with proper parameters (country, roomType, minPrice, maxPrice)
                hotels = serviceDao.searchHotels(keyword.trim(), "", "", "");
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                hotels = serviceDao.getHotels();
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
                String hotelIdStr = request.getParameter("id");
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
            hotel.setHotelId(Integer.parseInt(request.getParameter("id")));
            
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
            String hotelIdStr = request.getParameter("id");
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
            String hotelIdStr = request.getParameter("id");
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
    private Hotel createHotelFromRequest(HttpServletRequest request) throws ServletException, IOException {
        Hotel hotel = new Hotel();
        
        hotel.setHotelName(request.getParameter("hotelName"));
        
        // Handle image URL - check for file upload first, then fallback to current URL
        String imageUrl = request.getParameter("currentImageUrl"); // Default to existing image
        
        try {
            Part filePart = request.getPart("hotelImageFile");
            if (filePart != null && filePart.getSize() > 0) {
                // Get original filename
                String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Generate unique filename
                String fileExtension = originalName.substring(originalName.lastIndexOf("."));
                String uniqueFileName = "hotel_" + System.currentTimeMillis() + "_" + 
                                      Math.random() * 1000 + fileExtension;
                
                // Create upload directory if it doesn't exist
                String uploadDir = getServletContext().getRealPath("/") + "UploadData" + File.separator + "Hotels";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Save the file
                String filePath = uploadDir + File.separator + uniqueFileName;
                filePart.write(filePath);
                
                // Set the relative path for database storage
                imageUrl = "UploadData/Hotels/" + uniqueFileName;
            }
        } catch (Exception e) {
            System.err.println("Error handling file upload: " + e.getMessage());
            e.printStackTrace();
            // Continue with existing image URL if file upload fails
        }
        
        hotel.setHotelImageUrl(imageUrl);
        
        // Set room type
        String roomType = request.getParameter("roomType");
        if (roomType != null && !roomType.trim().isEmpty()) {
            hotel.setRoomType(roomType);
        }
        
        // Set numeric fields
        String pricePerNightStr = request.getParameter("pricePerNight");
        if (pricePerNightStr != null && !pricePerNightStr.trim().isEmpty()) {
            hotel.setPricePerNight(Integer.parseInt(pricePerNightStr));
        }
        
        String ratingStr = request.getParameter("rating");
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            hotel.setRating(Double.parseDouble(ratingStr));
        }
        
        String roomAvailableStr = request.getParameter("roomAvailable");
        if (roomAvailableStr != null && !roomAvailableStr.trim().isEmpty()) {
            hotel.setRoomAvailable(Integer.parseInt(roomAvailableStr));
        }
        
        // Set island ID
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
            hotel.setIslandId(Integer.parseInt(islandIdStr));
        }
        
        // Set country name
        String countryName = request.getParameter("countryName");
        if (countryName != null && !countryName.trim().isEmpty()) {
            hotel.setCountryName(countryName);
        }
        
        return hotel;
    }

    /**
     * Validate hotel input
     */
    private boolean validateHotelInput(HttpServletRequest request) {
        boolean isValid = true;
        Map<String, String> errors = new HashMap<>();
        
        // Validate hotel name (required)
        String hotelName = request.getParameter("hotelName");
        if (hotelName == null || hotelName.trim().isEmpty()) {
            errors.put("hotelName", "Hotel name is required");
            isValid = false;
        } else if (hotelName.trim().length() > 255) {
            errors.put("hotelName", "Hotel name cannot exceed 255 characters");
            isValid = false;
        }
        
        // Validate island ID (required)
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
            errors.put("islandId", "Island selection is required");
            isValid = false;
        } else {
            try {
                int islandId = Integer.parseInt(islandIdStr);
                if (islandId <= 0) {
                    errors.put("islandId", "Invalid island selection");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                errors.put("islandId", "Invalid island selection");
                isValid = false;
            }
        }
        
        // Validate rating (optional, but if provided must be valid)
        String ratingStr = request.getParameter("rating");
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                double rating = Double.parseDouble(ratingStr);
                if (rating < 0 || rating > 5) {
                    errors.put("rating", "Rating must be between 0 and 5");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                errors.put("rating", "Invalid rating format");
                isValid = false;
            }
        }
        
        // Validate star rating (optional, but if provided must be valid)
        String starRatingStr = request.getParameter("starRating");
        if (starRatingStr != null && !starRatingStr.trim().isEmpty()) {
            try {
                int starRating = Integer.parseInt(starRatingStr);
                if (starRating < 1 || starRating > 5) {
                    errors.put("starRating", "Star rating must be between 1 and 5");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                errors.put("starRating", "Invalid star rating format");
                isValid = false;
            }
        }
        
        // Validate room type (required)
        String roomType = request.getParameter("roomType");
        if (roomType == null || roomType.trim().isEmpty()) {
            errors.put("roomType", "Room type selection is required");
            isValid = false;
        }

        // Validate country name (optional, but if provided check length)
        String countryName = request.getParameter("countryName");
        if (countryName != null && countryName.trim().length() > 100) {
            errors.put("countryName", "Country name cannot exceed 100 characters");
            isValid = false;
        }

        // Set the errors map as an attribute
        request.setAttribute("errors", errors);
        
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