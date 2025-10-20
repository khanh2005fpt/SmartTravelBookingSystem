/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.TourDao;
import dao.IslandDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.List;
import model.Tour;
import model.User;
import model.Island;

/**
 * Servlet for CRUD operations on tour data, specifically designed for staff users
 * @author Admin
 */
@WebServlet(name = "TourStaffServlet", urlPatterns = {"/staff/tours"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB: temporary storage in memory before writing to file
    maxFileSize = 1024 * 1024 * 10,       // 10MB: maximum file size
    maxRequestSize = 1024 * 1024 * 50     // 50MB: total request size
)
public class TourStaffServlet extends HttpServlet {

    private TourDao tourDao;
    private IslandDao islandDao;

    @Override
    public void init() throws ServletException {
        super.init();
        tourDao = new TourDao();
        islandDao = new IslandDao();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Check staff authorization
        if (!isStaffAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Staff authorization required.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listTours(request, response);
                    break;
                case "view":
                    viewTour(request, response);
                    break;
                case "create":
                    createTour(request, response);
                    break;
                case "edit":
                    editTour(request, response);
                    break;
                case "update":
                    updateTour(request, response);
                    break;
                case "delete":
                    deleteTour(request, response);
                    break;
                case "search":
                    searchTours(request, response);
                    break;
                default:
                    listTours(request, response);
                    break;
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage(), e);
        } catch (Exception e) {
            handleError(request, response, "Unexpected error: " + e.getMessage(), e);
        }
    }

    /**
     * Check if user is authorized as staff
     */
    private boolean isStaffAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return false;
        }

        // Check if user has staff role (roleId = 1 for admin, roleId = 2 for staff)
        return user.getRoleId() == 1 || user.getRoleId() == 4;
    }

    /**
     * List all tours
     */
    private void listTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        // Get pagination parameters
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String searchParam = request.getParameter("search");
        
        int page = 1;
        int pageSize = 12; // Default page size
        
        // Parse page parameter
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Parse page size parameter
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 1) pageSize = 12;
                if (pageSize > 100) pageSize = 100; // Max page size limit
            } catch (NumberFormatException e) {
                pageSize = 12;
            }
        }
        
        List<Tour> tours;
        int totalTours;
        
        // Check if search is performed
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            tours = tourDao.searchToursByNameWithPaginationAndIslandNames(searchParam.trim(), page, pageSize);
            totalTours = tourDao.getSearchToursCount(searchParam.trim());
            request.setAttribute("search", searchParam.trim());
        } else {
            tours = tourDao.getToursByPageWithIslandNames(page, pageSize);
            totalTours = tourDao.getTotalToursCount();
        }
        
        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalTours / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("tours", tours);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTours", totalTours);
        
        // Calculate pagination display range
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        
        request.setAttribute("action", "list");
        request.getRequestDispatcher("/views/staff/tour-list.jsp").forward(request, response);
    }

    /**
     * View single tour details
     */
    private void viewTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("id");
        if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID tour là bắt buộc");
            listTours(request, response);
            return;
        }

        try {
            int tourId = Integer.parseInt(tourIdStr);
            Tour tour = tourDao.getTourDetailById(tourId);
            
            if (tour == null) {
                request.setAttribute("error", "Không tìm thấy tour");
                listTours(request, response);
                return;
            }

            // Load island data for the tour
            Island island = islandDao.getIslandById(tour.getIslandId());
            
            request.setAttribute("tour", tour);
            request.setAttribute("island", island);
            request.setAttribute("action", "view");
            request.getRequestDispatcher("/views/staff/tour-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid tour ID format");
            listTours(request, response);
        }
    }

    /**
     * Show create tour form
     */
    private void createTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Load islands data for dropdown
        List<Island> islands = islandDao.getIslands();
        request.setAttribute("islands", islands);
        request.setAttribute("action", "create");
        request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
    }

    /**
     * Show edit tour form
     */
    private void editTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("id");
        if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID tour là bắt buộc");
            listTours(request, response);
            return;
        }

        try {
            int tourId = Integer.parseInt(tourIdStr);
            Tour tour = tourDao.getTourDetailById(tourId);
            
            if (tour == null) {
                request.setAttribute("error", "Không tìm thấy tour");
                listTours(request, response);
                return;
            }

            // Load islands data for dropdown
            List<Island> islands = islandDao.getIslands();
            request.setAttribute("islands", islands);
            request.setAttribute("tour", tour);
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid tour ID format");
            listTours(request, response);
        }
    }

    /**
     * Update existing tour
     */
    private void updateTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("id");
        String tourName = request.getParameter("tourName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String islandIdStr = request.getParameter("islandId");
        String tourImageUrl = request.getParameter("currentImageUrl"); // Keep existing image by default
        
        // Handle file upload
        try {
            Part filePart = request.getPart("tourImageFile");
            if (filePart != null && filePart.getSize() > 0) {
                // Get original filename
                String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Generate unique filename
                String fileExtension = originalName.substring(originalName.lastIndexOf("."));
                String uniqueFileName = "tour_" + System.currentTimeMillis() + "_" + 
                                      Math.random() * 1000 + fileExtension;
                
                // Create upload directory if it doesn't exist
                String uploadDir = getServletContext().getRealPath("/") + "UploadData" + File.separator + "Tours";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Save file
                String filePath = uploadDir + File.separator + uniqueFileName;
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    tourImageUrl = "UploadData/Tours/" + uniqueFileName;
                } catch (IOException e) {
                    request.setAttribute("error", "Lỗi khi tải lên hình ảnh: " + e.getMessage());
                    request.setAttribute("action", "edit");
                    loadEditTourData(request, response, Integer.parseInt(tourIdStr));
                    return;
                }
            }
        } catch (Exception e) {
            // If there's an error with file upload, continue with existing image
            System.err.println("File upload error in updateTour: " + e.getMessage());
        }

        // Validation
        if (!validateTourInput(tourIdStr, tourName, description, priceStr, islandIdStr, request)) {
            request.setAttribute("action", "edit");
            loadEditTourData(request, response, Integer.parseInt(tourIdStr));
            return;
        }

        try {
            int tourId = Integer.parseInt(tourIdStr);
            int price = Integer.parseInt(priceStr);
            int islandId = Integer.parseInt(islandIdStr);

            // Check if tour name already exists (excluding current tour)
            if (tourDao.tourNameExists(tourName, tourId)) {
                request.setAttribute("error", "Tên tour đã tồn tại");
                request.setAttribute("action", "edit");
                loadEditTourData(request, response, tourId);
                return;
            }

            Tour tour = new Tour(tourId, islandId, tourName, description, price, tourImageUrl);
            boolean success = tourDao.updateTour(tour);

            if (success) {
                request.setAttribute("success", "Cập nhật tour thành công");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=view&id=" + tourId);
            } else {
                request.setAttribute("error", "Cập nhật tour thất bại");
                request.setAttribute("action", "edit");
                loadEditTourData(request, response, tourId);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
            request.setAttribute("action", "edit");
            try {
                loadEditTourData(request, response, Integer.parseInt(tourIdStr));
            } catch (Exception ex) {
                listTours(request, response);
            }
        }
    }

    /**
     * Helper method to load edit tour data
     */
    private void loadEditTourData(HttpServletRequest request, HttpServletResponse response, int tourId)
            throws ServletException, IOException, SQLException {
        
        Tour tour = tourDao.getTourDetailById(tourId);
        List<Island> islands = islandDao.getIslands();
        
        request.setAttribute("tour", tour);
        request.setAttribute("islands", islands);
        request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
    }

    /**
     * Delete tour
     */
    private void deleteTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("id");
        if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID tour là bắt buộc");
            listTours(request, response);
            return;
        }

        try {
            int tourId = Integer.parseInt(tourIdStr);
            
            // Check if tour exists
            if (!tourDao.tourExists(tourId)) {
                request.setAttribute("error", "Không tìm thấy tour");
                listTours(request, response);
                return;
            }

            boolean success = tourDao.deleteTour(tourId);

            if (success) {
                request.setAttribute("successMessage", "Xóa tour thành công");
            } else {
                request.setAttribute("errorMessage", "Xóa tour thất bại");
            }

            listTours(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid tour ID format");
            listTours(request, response);
        }
    }

    /**
     * Search tours
     */
    private void searchTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String searchTerm = request.getParameter("searchTerm");
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            listTours(request, response);
            return;
        }

        // Set search parameter and redirect to list method for unified pagination handling
        request.setAttribute("search", searchTerm.trim());
        listTours(request, response);
    }

    /**
     * Validate tour input
     */
    private boolean validateTourInput(String tourIdStr, String tourName, String description, 
                                    String priceStr, String islandIdStr, HttpServletRequest request) {
        
        boolean isValid = true;

        if (tourName == null || tourName.trim().isEmpty()) {
            request.setAttribute("errorTourName", "Tên tour là bắt buộc");
            isValid = false;
        } else if (tourName.trim().length() > 255) {
            request.setAttribute("errorTourName", "Tên tour không được vượt quá 255 ký tự");
            isValid = false;
        }

        if (description == null || description.trim().isEmpty()) {
            request.setAttribute("errorDescription", "Mô tả là bắt buộc");
            isValid = false;
        }

        if (priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("errorPrice", "Giá là bắt buộc");
            isValid = false;
        } else {
            try {
                int price = Integer.parseInt(priceStr);
                if (price < 0) {
                    request.setAttribute("errorPrice", "Giá phải là số không âm");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorPrice", "Giá phải là một số hợp lệ");
                isValid = false;
            }
        }

        if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
            request.setAttribute("errorIslandId", "ID đảo là bắt buộc");
            isValid = false;
        } else {
            try {
                int islandId = Integer.parseInt(islandIdStr);
                if (islandId <= 0) {
                    request.setAttribute("errorIslandId", "ID đảo phải là số dương");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorIslandId", "ID đảo phải là một số hợp lệ");
                isValid = false;
            }
        }

        return isValid;
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                           String message, Exception e) throws ServletException, IOException {
        
        // Log the error
        System.err.println("TourStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }

        // Check if response is already committed before forwarding
        if (!response.isCommitted()) {
            request.setAttribute("error", message);
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        } else {
            // If response is committed, just log the error
            System.err.println("Cannot forward to error page - response already committed");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check staff authorization for POST requests
        if (!isStaffAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Staff authorization required.");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                // Handle tour creation
                String tourName = request.getParameter("tourName");
                String description = request.getParameter("description");
                String priceStr = request.getParameter("price");
                String islandIdStr = request.getParameter("islandId");
                String tourImageUrl = "";

                // Handle file upload
                Part filePart = request.getPart("tourImageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    // Get original filename
                    String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int dotIndex = originalName.lastIndexOf(".");
                    if (dotIndex > 0) {
                        ext = originalName.substring(dotIndex);
                    }

                    // Create unique filename
                    String uniqueName = "tour_" + System.currentTimeMillis() + ext;

                    // Upload directory
                    String uploadDir = getServletContext().getRealPath("") + File.separator + "UploadData" + File.separator + "Tours";
                    File uploadPath = new File(uploadDir);
                    if (!uploadPath.exists()) {
                        uploadPath.mkdirs();
                    }

                    // Save file
                    Path filePath = Paths.get(uploadDir, uniqueName);
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                        tourImageUrl = "UploadData/Tours/" + uniqueName;
                    } catch (IOException e) {
                        request.setAttribute("error", "Lỗi khi tải lên hình ảnh: " + e.getMessage());
                        request.setAttribute("action", "create");
                        List<Island> islands = islandDao.getIslands();
                        request.setAttribute("islands", islands);
                        request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
                        return;
                    }
                }

                // Validation
                if (!validateTourInput(null, tourName, description, priceStr, islandIdStr, request)) {
                    request.setAttribute("action", "create");
                    List<Island> islands = islandDao.getIslands();
                    request.setAttribute("islands", islands);
                    request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
                    return;
                }

                int price = Integer.parseInt(priceStr);
                int islandId = Integer.parseInt(islandIdStr);

                // Check if tour name already exists
                if (tourDao.tourNameExists(tourName, 0)) {
                    request.setAttribute("error", "Tên tour đã tồn tại");
                    request.setAttribute("action", "create");
                    List<Island> islands = islandDao.getIslands();
                    request.setAttribute("islands", islands);
                    request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
                    return;
                }

                Tour tour = new Tour(0, islandId, tourName, description, price, tourImageUrl);
                int newTourId = tourDao.createTour(tour);

                if (newTourId > 0) {
                    request.setAttribute("success", "Tạo tour thành công");
                    response.sendRedirect(request.getContextPath() + "/staff/tours?action=view&id=" + newTourId);
                } else {
                    request.setAttribute("error", "Tạo tour thất bại");
                    request.setAttribute("action", "create");
                    List<Island> islands = islandDao.getIslands();
                    request.setAttribute("islands", islands);
                    request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
                }

            } else {
                // For other POST actions, delegate to processRequest
                processRequest(request, response);
            }
            
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage(), e);
        } catch (Exception e) {
            handleError(request, response, "Unexpected error: " + e.getMessage(), e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Tour Staff Servlet for CRUD operations on tour data";
    }
}