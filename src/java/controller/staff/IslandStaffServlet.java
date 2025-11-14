/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import dao.IslandDao;
import model.Island;
import model.Country;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet for managing island operations for staff members
 * Handles island CRUD operations, list display, search functionality
 *
 * @author Admin
 */
@WebServlet(name = "IslandStaffServlet", urlPatterns = {"/staff/islands"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 50 * 1024 * 1024
)
public class IslandStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in IslandStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in IslandStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for island operations
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
                    handleIslandList(request, response);
                    break;
                case "detail":
                    handleIslandDetail(request, response);
                    break;
                case "view":
                    handleIslandDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleIslandSearch(request, response);
                    break;
                default:
                    handleIslandList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing island request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for island operations
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
            switch (action) {
                case "create":
                    handleCreateIsland(request, response);
                    break;
                case "update":
                    handleUpdateIsland(request, response);
                    break;
                case "delete":
                    handleDeleteIsland(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/islands");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing island operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all islands
     */
    private void handleIslandList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Island> islands = serviceDao.getAllIslands();
            List<Country> countries = getCountries();
            request.setAttribute("islands", islands);
            request.setAttribute("countries", countries);
            request.setAttribute("pageTitle", "Island Management");

            // Handle success/error messages from query parameters
            String success = request.getParameter("success");
            String error = request.getParameter("error");

            if ("deleted".equals(success)) {
                request.setAttribute("successMessage", "Đảo đã được xóa thành công!");
            } else if ("created".equals(success)) {
                request.setAttribute("successMessage", "Đảo đã được tạo thành công!");
            } else if ("updated".equals(success)) {
                request.setAttribute("successMessage", "Đảo đã được cập nhật thành công!");
            }

            if ("foreign_key_constraint".equals(error)) {
                request.setAttribute("errorMessage", "Không thể xóa đảo này vì nó đang được sử dụng trong các tour hoặc hoạt động khác. Vui lòng xóa các liên kết trước.");
            } else if ("delete_failed".equals(error)) {
                request.setAttribute("errorMessage", "Xóa đảo thất bại. Vui lòng thử lại.");
            } else if ("invalid_id".equals(error)) {
                request.setAttribute("errorMessage", "ID đảo không hợp lệ.");
            } else if ("not_found".equals(error)) {
                request.setAttribute("errorMessage", "Không tìm thấy đảo cần xóa.");
            }

            request.getRequestDispatcher("/views/staff/island-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading island list: " + e.getMessage(), e);
        }
    }

    /**
     * Display island details
     */
    private void handleIslandDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("id");
            if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Island ID is required");
                handleIslandList(request, response);
                return;
            }
            
            int islandId = Integer.parseInt(islandIdStr);
            Island island = serviceDao.getIslandById(islandId);
            
            if (island == null) {
                request.setAttribute("errorMessage", "Island not found");
                handleIslandList(request, response);
                return;
            }
            
            request.setAttribute("island", island);
            request.setAttribute("pageTitle", "Island Details - " + island.getIslandName());
            request.getRequestDispatcher("/views/staff/island-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid island ID format");
            handleIslandList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading island details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create island form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Country> countries = getCountries();
            System.out.println(countries.toString());
            request.setAttribute("countries", countries);
            request.setAttribute("pageTitle", "Create New Island");
            request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit island form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("id");
            if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Island ID is required");
                handleIslandList(request, response);
                return;
            }

            int islandId = Integer.parseInt(islandIdStr);
            Island island = serviceDao.getIslandById(islandId);

            if (island == null) {
                request.setAttribute("errorMessage", "Island not found");
                handleIslandList(request, response);
                return;
            }

            List<Country> countries = getCountries();
            request.setAttribute("countries", countries);
            System.out.println("countries");
            request.setAttribute("island", island);
            request.setAttribute("pageTitle", "Edit Island - " + island.getIslandName());
            request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid island ID format");
            handleIslandList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading island for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle island search
     */
    private void handleIslandSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandName = request.getParameter("islandName");
            String country = request.getParameter("country");
            String season = request.getParameter("season");

            List<Island> islands;

            // Search by island name if provided
            if (islandName != null && !islandName.trim().isEmpty()) {
                islands = serviceDao.searchIslandsByName(islandName.trim());
                request.setAttribute("searchIslandName", islandName.trim());
            } else if ((country != null && !country.trim().isEmpty()) ||
                       (season != null && !season.trim().isEmpty())) {
                // Search by country and/or season
                islands = IslandDao.INSTANCE.searchIslands(
                    country != null ? country.trim() : "",
                    season != null ? season.trim() : ""
                );
                if (country != null && !country.isEmpty()) {
                    request.setAttribute("searchCountry", country);
                }
                if (season != null && !season.isEmpty()) {
                    request.setAttribute("searchSeason", season);
                }
            } else {
                islands = serviceDao.getAllIslands();
            }

            List<Country> countries = getCountries();
            request.setAttribute("islands", islands);
            request.setAttribute("countries", countries);
            request.setAttribute("pageTitle", "Island Search Results");
            request.getRequestDispatcher("/views/staff/island-list.jsp").forward(request, response);

        } catch (Exception e) {
            handleError(request, response, "Error searching islands: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create island
     */
    private void handleCreateIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateIslandInput(request)) {
                List<Country> countries = getCountries();
                request.setAttribute("countries", countries);
                request.setAttribute("pageTitle", "Create New Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
                return;
            }

            // Create island object
            Island island = createIslandFromRequest(request);

            // Handle file upload
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/views/home/images/islands");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + java.io.File.separator + fileName);
                island.setImageUrl(fileName);
            }

            // Get countryId from request
            String countryIdStr = request.getParameter("countryId");
            int countryId = (countryIdStr != null && !countryIdStr.isEmpty()) ? Integer.parseInt(countryIdStr) : 1;

            // Debug log
            System.out.println("DEBUG: Creating island with name=" + island.getIslandName() +
                             ", countryId=" + countryId +
                             ", bestSeason=" + island.getBestSeason() +
                             ", imageUrl=" + island.getImageUrl());

            // Save island
            boolean success = serviceDao.createIsland(island, countryId);

            System.out.println("DEBUG: Island creation result: " + success);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create island. Please try again.");
                List<Country> countries = getCountries();
                request.setAttribute("countries", countries);
                request.setAttribute("pageTitle", "Create New Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("DEBUG: Exception in handleCreateIsland: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Error creating island: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update island
     */
    private void handleUpdateIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateIslandInput(request)) {
                String islandIdStr = request.getParameter("islandId");
                if (islandIdStr != null) {
                    Island island = serviceDao.getIslandById(Integer.parseInt(islandIdStr));
                    request.setAttribute("island", island);
                }
                List<Country> countries = getCountries();
                request.setAttribute("countries", countries);
                request.setAttribute("pageTitle", "Edit Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
                return;
            }

            // Get existing island data
            String islandIdStr = request.getParameter("islandId");
            int islandId = Integer.parseInt(islandIdStr);
            Island existingIsland = serviceDao.getIslandById(islandId);

            // Create island object
            Island island = createIslandFromRequest(request);
            island.setIslandId(islandId);

            // Handle file upload - if no new file, keep existing image
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/views/home/images/islands");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + java.io.File.separator + fileName);
                island.setImageUrl(fileName);
            } else if (existingIsland != null) {
                // Keep existing image if no new file uploaded
                island.setImageUrl(existingIsland.getImageUrl());
            }

            // Get countryId from request
            String countryIdStr = request.getParameter("countryId");
            int countryId = (countryIdStr != null && !countryIdStr.isEmpty()) ? Integer.parseInt(countryIdStr) : 1;

            // Debug log
            System.out.println("DEBUG: Updating island with id=" + islandId +
                             ", name=" + island.getIslandName() +
                             ", countryId=" + countryId +
                             ", bestSeason=" + island.getBestSeason() +
                             ", imageUrl=" + island.getImageUrl());

            // Update island
            boolean success = serviceDao.updateIsland(island, countryId);

            System.out.println("DEBUG: Island update result: " + success);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update island. Please try again.");
                request.setAttribute("island", island);
                List<Country> countries = getCountries();
                request.setAttribute("countries", countries);
                request.setAttribute("pageTitle", "Edit Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("DEBUG: Exception in handleUpdateIsland: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Error updating island: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete island
     */
    private void handleDeleteIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("islandId");
            if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=invalid_id");
                return;
            }

            int islandId = Integer.parseInt(islandIdStr);
            String result = serviceDao.deleteIslandWithErrorHandling(islandId);

            if ("success".equals(result)) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=deleted");
            } else if ("foreign_key_constraint".equals(result)) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=foreign_key_constraint");
            } else if ("not_found".equals(result)) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=not_found");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/islands?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting island: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update island status
     */
    /**
     * Create island object from request parameters
     */
    private Island createIslandFromRequest(HttpServletRequest request) {
        Island island = new Island();
        
        // Only set properties that exist in the Island model
        island.setIslandName(request.getParameter("islandName"));
        island.setCountryName(request.getParameter("countryName"));
        island.setShortDescription(request.getParameter("shortDescription"));
        island.setLongDescription(request.getParameter("longDescription"));
        island.setBestSeason(request.getParameter("bestSeason"));
        island.setActivities(request.getParameter("activities"));
        island.setImageUrl(request.getParameter("imageUrl"));
        island.setLocation(request.getParameter("location"));
        
        return island;
    }

    /**
     * Validate island input
     */
    private boolean validateIslandInput(HttpServletRequest request) {
        boolean isValid = true;

        String islandName = request.getParameter("islandName");
        if (islandName == null || islandName.trim().isEmpty()) {
            request.setAttribute("errorIslandName", "Island name is required");
            isValid = false;
        }

        String countryId = request.getParameter("countryId");
        if (countryId == null || countryId.trim().isEmpty()) {
            request.setAttribute("errorCountryId", "Country is required");
            isValid = false;
        }

        String bestSeason = request.getParameter("bestSeason");
        if (bestSeason == null || bestSeason.trim().isEmpty()) {
            request.setAttribute("errorBestSeason", "Best season is required");
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
     * Get all countries from database
     */
    private List<Country> getCountries() {
        try {
            return IslandDao.INSTANCE.getAllCountries();
        } catch (Exception e) {
            System.err.println("Error loading countries: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                           String message, Exception e) throws ServletException, IOException {
        System.err.println("IslandStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }

        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "IslandStaffServlet - Handles island management operations for staff";
    }
}