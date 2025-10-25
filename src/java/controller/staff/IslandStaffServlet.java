/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
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
 * Servlet for managing island operations for staff members
 * Handles island CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "IslandStaffServlet", urlPatterns = {"/staff/islands"})
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
        if (!isStaffAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    handleIslandList(request, response);
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
        if (!isStaffAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
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
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Island Management");
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
            String keyword = request.getParameter("keyword");
            String region = request.getParameter("region");
            String status = request.getParameter("status");
            
            List<Island> islands;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                islands = serviceDao.searchIslandsByName(keyword.trim());
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                islands = serviceDao.getAllIslands();
            }
            
            // Apply additional filters if provided
            if (region != null && !region.trim().isEmpty()) {
                request.setAttribute("searchRegion", region);
            }
            
            if (status != null && !status.trim().isEmpty()) {
                request.setAttribute("searchStatus", status);
            }
            
            request.setAttribute("islands", islands);
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
                request.setAttribute("pageTitle", "Create New Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
                return;
            }
            
            // Create island object
            Island island = createIslandFromRequest(request);
            
            // Get countryId from request
            String countryIdStr = request.getParameter("countryId");
            int countryId = (countryIdStr != null && !countryIdStr.isEmpty()) ? Integer.parseInt(countryIdStr) : 1; // Default to 1 if not provided
            
            // Save island
            boolean success = serviceDao.createIsland(island, countryId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create island. Please try again.");
                request.setAttribute("pageTitle", "Create New Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
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
                request.setAttribute("pageTitle", "Edit Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
                return;
            }
            
            // Create island object
            Island island = createIslandFromRequest(request);
            island.setIslandId(Integer.parseInt(request.getParameter("islandId")));
            
            // Get countryId from request
            String countryIdStr = request.getParameter("countryId");
            int countryId = (countryIdStr != null && !countryIdStr.isEmpty()) ? Integer.parseInt(countryIdStr) : 1; // Default to 1 if not provided
            
            // Update island
            boolean success = serviceDao.updateIsland(island, countryId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update island. Please try again.");
                request.setAttribute("island", island);
                request.setAttribute("pageTitle", "Edit Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
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
            boolean success = serviceDao.deleteIsland(islandId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=deleted");
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
        
        String location = request.getParameter("location");
        if (location == null || location.trim().isEmpty()) {
            request.setAttribute("errorLocation", "Location is required");
            isValid = false;
        }
        
        String description = request.getParameter("description");
        if (description == null || description.trim().isEmpty()) {
            request.setAttribute("errorDescription", "Description is required");
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