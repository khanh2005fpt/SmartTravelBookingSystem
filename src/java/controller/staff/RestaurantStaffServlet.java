package controller.staff;

import dao.ServiceDao;
import dao.userDao;
import model.Restaurant;
import model.Island;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

@WebServlet(name = "RestaurantStaffServlet", urlPatterns = {"/staff/restaurants"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class RestaurantStaffServlet extends HttpServlet {

    private ServiceDao serviceDao;
    private userDao userDao;

    @Override
    public void init() throws ServletException {
        serviceDao = new ServiceDao();
        userDao = new userDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is authorized
        if (!isStaffAuthorized(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    handleListRestaurants(request, response);
                    break;
                case "view":
                    handleViewRestaurant(request, response);
                    break;
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                    handleShowEditForm(request, response);
                    break;
                case "search":
                    handleSearchRestaurants(request, response);
                    break;
                default:
                    handleListRestaurants(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is authorized
        if (!isStaffAuthorized(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if (action == null || action.trim().isEmpty()) {
                // If no action specified, redirect to list view
                response.sendRedirect(request.getContextPath() + "/staff/restaurants?action=list");
                return;
            }
            
            switch (action) {
                case "create":
                    handleCreateRestaurant(request, response);
                    break;
                case "update":
                    handleUpdateRestaurant(request, response);
                    break;
                case "delete":
                    handleDeleteRestaurant(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/restaurants?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }

    // ==================== GET REQUEST HANDLERS ====================

    private void handleListRestaurants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        
        int page = 1;
        int pageSize = 10;
        
        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
            if (pageSizeStr != null) {
                pageSize = Integer.parseInt(pageSizeStr);
            }
        } catch (NumberFormatException e) {
            // Use default values
        }

        List<Restaurant> restaurants = serviceDao.getRestaurants();
        List<Island> islands = serviceDao.getAllIslands();

        // Simple pagination
        int totalRestaurants = restaurants.size();
        int totalPages = (int) Math.ceil((double) totalRestaurants / pageSize);
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalRestaurants);

        List<Restaurant> paginatedRestaurants = restaurants.subList(startIndex, endIndex);

        request.setAttribute("restaurants", paginatedRestaurants);
        request.setAttribute("islands", islands);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalRestaurants", totalRestaurants);

        request.getRequestDispatcher("/views/staff/restaurant-list.jsp").forward(request, response);
    }

    private void handleViewRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String restaurantIdStr = request.getParameter("id");
        if (restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(restaurantIdStr);
            Restaurant restaurant = serviceDao.getRestaurantById(restaurantId);
            
            if (restaurant == null) {
                request.setAttribute("errorMessage", "Restaurant not found.");
                handleListRestaurants(request, response);
                return;
            }

            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/views/staff/restaurant-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
        }
    }

    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Island> islands = serviceDao.getAllIslands();
        request.setAttribute("islands", islands);
        request.getRequestDispatcher("/views/staff/restaurant-form.jsp").forward(request, response);
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String restaurantIdStr = request.getParameter("id");
        if (restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(restaurantIdStr);
            Restaurant restaurant = serviceDao.getRestaurantById(restaurantId);
            
            if (restaurant == null) {
                request.setAttribute("errorMessage", "Restaurant not found.");
                handleListRestaurants(request, response);
                return;
            }

            List<Island> islands = serviceDao.getAllIslands();
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("islands", islands);
            request.getRequestDispatcher("/views/staff/restaurant-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
        }
    }

    private void handleSearchRestaurants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("search");
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        
        int page = 1;
        int pageSize = 10;
        
        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
            if (pageSizeStr != null) {
                pageSize = Integer.parseInt(pageSizeStr);
            }
        } catch (NumberFormatException e) {
            // Use default values
        }

        List<Restaurant> restaurants;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            restaurants = serviceDao.searchRestaurants(searchTerm.trim());
        } else {
            restaurants = serviceDao.getRestaurants();
        }

        List<Island> islands = serviceDao.getAllIslands();

        // Simple pagination
        int totalRestaurants = restaurants.size();
        int totalPages = (int) Math.ceil((double) totalRestaurants / pageSize);
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalRestaurants);

        List<Restaurant> paginatedRestaurants = restaurants.subList(startIndex, endIndex);

        request.setAttribute("restaurants", paginatedRestaurants);
        request.setAttribute("islands", islands);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalRestaurants", totalRestaurants);
        request.setAttribute("searchTerm", searchTerm);

        request.getRequestDispatcher("/views/staff/restaurant-list.jsp").forward(request, response);
    }

    // ==================== POST REQUEST HANDLERS ====================

    private void handleCreateRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Restaurant restaurant = createRestaurantFromRequest(request);
            String validationError = validateRestaurantInput(restaurant);
            
            if (validationError != null) {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("/views/staff/restaurant-form.jsp").forward(request, response);
                return;
            }

            boolean success = serviceDao.createRestaurant(restaurant);
            
            if (success) {
                request.setAttribute("successMessage", "Restaurant created successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/restaurants");
            } else {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("errorMessage", "Failed to create restaurant. Please try again.");
                request.getRequestDispatcher("/views/staff/restaurant-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating restaurant: " + e.getMessage());
        }
    }

    private void handleUpdateRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Restaurant restaurant = createRestaurantFromRequest(request);
            String validationError = validateRestaurantInput(restaurant);
            
            if (validationError != null) {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("/views/staff/restaurant-form.jsp").forward(request, response);
                return;
            }

            boolean success = serviceDao.updateRestaurant(restaurant);
            
            if (success) {
                request.setAttribute("successMessage", "Restaurant updated successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/restaurants");
            } else {
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("islands", islands);
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("errorMessage", "Failed to update restaurant. Please try again.");
                request.getRequestDispatcher("/views/staff/restaurant-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating restaurant: " + e.getMessage());
        }
    }

    private void handleDeleteRestaurant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String restaurantIdStr = request.getParameter("id");
        if (restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(restaurantIdStr);
            boolean success = serviceDao.deleteRestaurant(restaurantId);
            
            if (success) {
                request.setAttribute("successMessage", "Restaurant deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete restaurant. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/restaurants");
        } catch (Exception e) {
            handleError(request, response, "Error deleting restaurant: " + e.getMessage());
        }
    }

    // ==================== HELPER METHODS ====================

    private Restaurant createRestaurantFromRequest(HttpServletRequest request) {
        Restaurant restaurant = new Restaurant();
        
        String restaurantIdStr = request.getParameter("id");
        if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
            try {
                restaurant.setRestaurantId(Integer.parseInt(restaurantIdStr));
            } catch (NumberFormatException e) {
                // Ignore, will be 0 for new restaurants
            }
        }

        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr != null && !islandIdStr.trim().isEmpty()) {
            try {
                restaurant.setIslandId(Integer.parseInt(islandIdStr));
            } catch (NumberFormatException e) {
                restaurant.setIslandId(0);
            }
        }

        restaurant.setRestaurantName(request.getParameter("restaurantName"));
        restaurant.setCuisineType(request.getParameter("cuisineType"));
        restaurant.setPriceRange(request.getParameter("priceRange"));
        
        String ratingStr = request.getParameter("rating");
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                restaurant.setRating(Double.parseDouble(ratingStr));
            } catch (NumberFormatException e) {
                restaurant.setRating(0.0);
            }
        }

        restaurant.setAddress(request.getParameter("address"));
        restaurant.setPhoneNumber(request.getParameter("phoneNumber"));
        restaurant.setOpeningHours(request.getParameter("openingHours"));
        
        String capacityStr = request.getParameter("capacity");
        if (capacityStr != null && !capacityStr.trim().isEmpty()) {
            try {
                restaurant.setCapacity(Integer.parseInt(capacityStr));
            } catch (NumberFormatException e) {
                restaurant.setCapacity(0);
            }
        }

        // Handle image URL - check for file upload first, then fallback to current URL
        String imageUrl = request.getParameter("currentImageUrl"); // Default to existing image
        
        try {
            Part filePart = request.getPart("restaurantImage");
            if (filePart != null && filePart.getSize() > 0) {
                // Get original filename
                String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Generate unique filename
                String fileExtension = originalName.substring(originalName.lastIndexOf("."));
                String uniqueFileName = "restaurant_" + System.currentTimeMillis() + "_" + 
                                      Math.random() * 1000 + fileExtension;
                
                // Create upload directory if it doesn't exist
                String uploadDir = getServletContext().getRealPath("/") + "UploadData" + File.separator + "Restaurants";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Save the file
                String filePath = uploadDir + File.separator + uniqueFileName;
                filePart.write(filePath);
                
                // Set the relative path for database storage
                imageUrl = "UploadData/Restaurants/" + uniqueFileName;
            }
        } catch (Exception e) {
            System.err.println("Error handling file upload: " + e.getMessage());
            e.printStackTrace();
            // Continue with existing image URL if file upload fails
        }
        
        restaurant.setRestaurantImageUrl(imageUrl);
        restaurant.setDescription(request.getParameter("description"));
        restaurant.setSpecialties(request.getParameter("specialties"));

        return restaurant;
    }

    private String validateRestaurantInput(Restaurant restaurant) {
        if (restaurant.getRestaurantName() == null || restaurant.getRestaurantName().trim().isEmpty()) {
            return "Restaurant name is required.";
        }
        
        if (restaurant.getCuisineType() == null || restaurant.getCuisineType().trim().isEmpty()) {
            return "Cuisine type is required.";
        }
        
        if (restaurant.getPriceRange() == null || restaurant.getPriceRange().trim().isEmpty()) {
            return "Price range is required.";
        }
        
        if (restaurant.getRating() < 0 || restaurant.getRating() > 5) {
            return "Rating must be between 0 and 5.";
        }
        
        if (restaurant.getAddress() == null || restaurant.getAddress().trim().isEmpty()) {
            return "Address is required.";
        }
        
        if (restaurant.getCapacity() <= 0) {
            return "Capacity must be greater than 0.";
        }
        
        if (restaurant.getIslandId() <= 0) {
            return "Please select a valid island.";
        }

        return null; // No validation errors
    }

    private boolean isStaffAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return false;
        }

        String role = user.getRole();
        return "staff".equals(role) || "admin".equals(role);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/views/staff/restaurant-list.jsp").forward(request, response);
    }
}