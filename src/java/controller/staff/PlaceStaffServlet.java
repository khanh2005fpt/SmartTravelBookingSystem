/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.Place;
import model.Island;
import model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet for managing place operations for staff members
 * Handles place CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "PlaceStaffServlet", urlPatterns = {"/staff/places"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class PlaceStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in PlaceStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in PlaceStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for place operations
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
                    handlePlaceList(request, response);
                    break;
                case "view":
                    handlePlaceDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handlePlaceSearch(request, response);
                    break;
                default:
                    handlePlaceList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing place request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for place operations
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
            if (action == null || action.trim().isEmpty()) {
                // If no action specified, redirect to list view
                response.sendRedirect(request.getContextPath() + "/staff/places?action=list");
                return;
            }
            
            switch (action) {
                case "create":
                    handleCreatePlace(request, response);
                    break;
                case "update":
                    handleUpdatePlace(request, response);
                    break;
                case "delete":
                    handleDeletePlace(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/places?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing place operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all places
     */
    private void handlePlaceList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            applyPlaceMessages(request);

            // Get pagination parameters
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            String search = request.getParameter("search");
            String hasTicket = request.getParameter("hasTicket");
            String islandId = request.getParameter("islandId");
            
            int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
            int pageSize = (pageSizeParam != null) ? Integer.parseInt(pageSizeParam) : 10;
            
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            request.setAttribute("islands", islands);
            
            // Get places with filters
            List<Place> places = serviceDao.getPlacesWithFilters(search, hasTicket, islandId, page, pageSize);
            int totalPlaces = serviceDao.getPlacesCountWithFilters(search, hasTicket, islandId);
            
            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalPlaces / pageSize);
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            
            // Set attributes
            request.setAttribute("places", places);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPlaces", totalPlaces);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("pageTitle", "Place Management");
            
            // Preserve filter parameters for form
            if (search != null) {
                request.setAttribute("search", search);
            }
            if (hasTicket != null) {
                request.setAttribute("hasTicket", hasTicket);
            }
            if (islandId != null) {
                request.setAttribute("islandId", islandId);
            }
            
            request.getRequestDispatcher("/views/staff/place-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading place list: " + e.getMessage(), e);
        }
    }

    /**
     * Display place details
     */
    private void handlePlaceDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String placeIdStr = request.getParameter("id");
            if (placeIdStr == null || placeIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Place ID is required");
                handlePlaceList(request, response);
                return;
            }
            
            int placeId = Integer.parseInt(placeIdStr);
            Place place = serviceDao.getPlaceById(placeId);
            
            if (place == null) {
                request.setAttribute("errorMessage", "Place not found");
                handlePlaceList(request, response);
                return;
            }
            
            request.setAttribute("place", place);
            request.setAttribute("pageTitle", "Place Details - " + place.getPlaceName());
            request.getRequestDispatcher("/views/staff/place-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid place ID format");
            handlePlaceList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading place details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create place form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Create New Place");
            request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit place form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String placeIdStr = request.getParameter("id");
            if (placeIdStr == null || placeIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Place ID is required");
                handlePlaceList(request, response);
                return;
            }
            
            int placeId = Integer.parseInt(placeIdStr);
            Place place = serviceDao.getPlaceById(placeId);
            
            if (place == null) {
                request.setAttribute("errorMessage", "Place not found");
                handlePlaceList(request, response);
                return;
            }
            
            // Load islands for dropdown
            List<Island> islands = serviceDao.getAllIslands();
            
            request.setAttribute("place", place);
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Edit Place - " + place.getPlaceName());
            request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid place ID format");
            handlePlaceList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading place for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle place search
     */
    private void handlePlaceSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String islandIdStr = request.getParameter("islandId");
            
            List<Place> places;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                places = serviceDao.searchPlaces(keyword.trim());
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                places = serviceDao.getPlaces();
            }
            
            // Apply additional filters if provided
            if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
                int islandId = Integer.parseInt(islandIdStr);
                places = serviceDao.getPlacesByIslandId(islandId);
                request.setAttribute("searchIslandId", islandId);
            }
            
            request.setAttribute("places", places);
            request.setAttribute("pageTitle", "Place Search Results");
            request.getRequestDispatcher("/views/staff/place-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid search parameters");
            handlePlaceList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error searching places: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create place
     */
    private void handleCreatePlace(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validatePlaceInput(request)) {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Place");
                request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
                return;
            }
            
            // Create place object
            Place place = createPlaceFromRequest(request);
            
            // Save place
            boolean success = serviceDao.addPlace(place);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/places?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create place. Please try again.");
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Place");
                request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating place: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update place
     */
    private void handleUpdatePlace(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validatePlaceInput(request)) {
                String placeIdStr = request.getParameter("id");
                if (placeIdStr != null && !placeIdStr.trim().isEmpty()) {
                    try {
                        Place place = serviceDao.getPlaceById(Integer.parseInt(placeIdStr));
                        request.setAttribute("place", place);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid place ID format: " + placeIdStr);
                    }
                }
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Place");
                request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
                return;
            }
            
            // Create place object
            Place place = createPlaceFromRequest(request);
            
            // Parse and set place ID with error handling
            String placeIdStr = request.getParameter("id");
            if (placeIdStr == null || placeIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Place ID is missing. Cannot update place.");
                request.setAttribute("place", place);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Place");
                request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
                return;
            }
            
            try {
                place.setPlaceId(Integer.parseInt(placeIdStr));
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid place ID format. Cannot update place.");
                request.setAttribute("place", place);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Place");
                request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
                return;
            }
            
            // Update place
            boolean success = serviceDao.updatePlace(place);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/places?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update place. Please try again.");
                request.setAttribute("place", place);
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Place");
                request.getRequestDispatcher("/views/staff/place-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating place: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete place
     */
    private void handleDeletePlace(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String placeIdStr = request.getParameter("id");
            if (placeIdStr == null || placeIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/places?error=invalid_id");
                return;
            }
            
            int placeId = Integer.parseInt(placeIdStr);

            if (serviceDao.isPlaceInUse(placeId)) {
                response.sendRedirect(request.getContextPath() + "/staff/places?error=in_use");
                return;
            }

            boolean success = serviceDao.deletePlace(placeId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/places?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/places?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/places?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting place: " + e.getMessage(), e);
        }
    }

    /**
     * Create place object from request parameters
     */
    private Place createPlaceFromRequest(HttpServletRequest request) throws ServletException, IOException {
        Place place = new Place();
        
        // Set basic fields
        place.setPlaceName(request.getParameter("placeName"));
        place.setLocation(request.getParameter("location"));
        place.setDescription(request.getParameter("description"));
        
        // Handle image URL - check for file upload first, then fallback to current URL
        String imageUrl = request.getParameter("currentImageUrl"); // Default to existing image
        
        try {
            Part filePart = request.getPart("placeImageFile");
            if (filePart != null && filePart.getSize() > 0) {
                // Get original filename
                String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Generate unique filename
                String fileExtension = originalName.substring(originalName.lastIndexOf("."));
                String uniqueFileName = "place_" + System.currentTimeMillis() + "_" + 
                                      (int)(Math.random() * 1000) + fileExtension;
                
                // Create upload directory if it doesn't exist
                String uploadDir = getServletContext().getRealPath("/") + "UploadData" + File.separator + "Places";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Save the file
                String filePath = uploadDir + File.separator + uniqueFileName;
                filePart.write(filePath);
                
                // Set the relative path for database storage
                imageUrl = "UploadData/Places/" + uniqueFileName;
            }
        } catch (Exception e) {
            System.err.println("Error handling file upload: " + e.getMessage());
            e.printStackTrace();
            // Continue with existing image URL if file upload fails
        }
        
        place.setPlaceImageUrl(imageUrl);
        
        // Set boolean field
        String hasTicketStr = request.getParameter("hasTicket");
        place.setHasTicket("true".equals(hasTicketStr) || "on".equals(hasTicketStr));
        
        // Set numeric fields
        String ticketPriceStr = request.getParameter("ticketPrice");
        if (ticketPriceStr != null && !ticketPriceStr.trim().isEmpty()) {
            place.setTicketPrice(Integer.parseInt(ticketPriceStr));
        } else {
            place.setTicketPrice(0);
        }
        
        // Set island ID
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
            place.setIslandId(Integer.parseInt(islandIdStr));
        }
        
        return place;
    }

    /**
     * Validate place input
     */
    private boolean validatePlaceInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String placeName = request.getParameter("placeName");
        if (placeName == null || placeName.trim().isEmpty()) {
            request.setAttribute("errorPlaceName", "Place name is required");
            isValid = false;
        }
        
        String location = request.getParameter("location");
        if (location == null || location.trim().isEmpty()) {
            request.setAttribute("errorLocation", "Location is required");
            isValid = false;
        }
        
        String ticketPriceStr = request.getParameter("ticketPrice");
        if (ticketPriceStr != null && !ticketPriceStr.trim().isEmpty()) {
            try {
                int ticketPrice = Integer.parseInt(ticketPriceStr);
                if (ticketPrice < 0) {
                    request.setAttribute("errorTicketPrice", "Ticket price cannot be negative");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorTicketPrice", "Invalid ticket price format");
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
    private boolean isStaffAuthorized(HttpSession session) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "staff".equals(role) || "admin".equals(role);
    }

    private void applyPlaceMessages(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object success = session.getAttribute("successMessage");
            if (success != null) {
                request.setAttribute("successMessage", success);
                session.removeAttribute("successMessage");
            }
            Object error = session.getAttribute("errorMessage");
            if (error != null) {
                request.setAttribute("errorMessage", error);
                session.removeAttribute("errorMessage");
            }
        }

        if (request.getAttribute("successMessage") == null) {
            String success = request.getParameter("success");
            if (success != null) {
                switch (success) {
                    case "created" -> request.setAttribute("successMessage", "Thêm địa điểm thành công.");
                    case "updated" -> request.setAttribute("successMessage", "Cập nhật địa điểm thành công.");
                    case "deleted" -> request.setAttribute("successMessage", "Xóa địa điểm thành công.");
                }
            }
        }

        if (request.getAttribute("errorMessage") == null) {
            String error = request.getParameter("error");
            if (error != null) {
                switch (error) {
                    case "invalid_id" -> request.setAttribute("errorMessage", "ID địa điểm không hợp lệ.");
                    case "delete_failed" -> request.setAttribute("errorMessage", "Không thể xóa địa điểm. Vui lòng thử lại.");
                    case "update_failed" -> request.setAttribute("errorMessage", "Cập nhật địa điểm thất bại.");
                    case "in_use" -> request.setAttribute("errorMessage", "Không thể xóa địa điểm vì đang được sử dụng trong tour hoặc custom tour.");
                }
            }
        }
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                           String message, Exception e) throws ServletException, IOException {
        System.err.println("PlaceStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "PlaceStaffServlet - Handles place management operations for staff";
    }
}