/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.TourDao;
import dao.IslandDao;
import dao.ServiceDao;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Tour;
import model.User;
import model.Island;
import model.TourItinerary;
import model.TourActivities;
import model.TourService;
import model.Airlines;
import model.Flight;

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
    private ServiceDao serviceDao;

    @Override
    public void init() throws ServletException {
        super.init();
        tourDao = new TourDao();
        islandDao = new IslandDao();
        serviceDao = new ServiceDao();
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
                case "manage-services":
                    manageServices(request, response);
                    break;
                case "add-service":
                    addServiceToTour(request, response);
                    break;
                case "remove-service":
                    removeServiceFromTour(request, response);
                    break;
                case "itinerary":
                    manageTourItinerary(request, response);
                    break;
                case "edit-activity":
                    editActivity(request, response);
                    break;
                case "update-activity":
                    updateActivity(request, response);
                    break;
                case "edit-itinerary":
                    editItinerary(request, response);
                    break;
                case "update-itinerary":
                    updateItinerary(request, response);
                    break;
                case "add-activity-to-itinerary":
                    addActivityToItinerary(request, response);
                    break;
                case "create-activity":
                    createActivity(request, response);
                    break;
                case "create-itinerary":
                    createTourItinerary(request, response);
                    break;
                case "deleteItinerary":
                    deleteItinerary(request, response);
                    break;
                case "getServices":
                    getServicesForIsland(request, response);
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
    private void transferSessionMessages(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

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

    private void applyListFeedbackMessages(HttpServletRequest request) {
        if (request.getAttribute("successMessage") == null) {
            String successParam = request.getParameter("success");
            if (successParam != null) {
                switch (successParam) {
                    case "created" -> request.setAttribute("successMessage", "Thêm tour thành công.");
                    case "updated" -> request.setAttribute("successMessage", "Cập nhật tour thành công.");
                    case "deleted" -> request.setAttribute("successMessage", "Xóa tour thành công.");
                }
            }
        }

        if (request.getAttribute("errorMessage") == null) {
            String errorParam = request.getParameter("error");
            if (errorParam != null) {
                switch (errorParam) {
                    case "invalid_id" -> request.setAttribute("errorMessage", "ID tour không hợp lệ.");
                    case "delete_failed" -> request.setAttribute("errorMessage", "Xóa tour thất bại. Vui lòng thử lại.");
                    case "in_use" -> request.setAttribute("errorMessage", "Không thể xóa tour vì đang được sử dụng.");
                }
            }
        }
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

        // Check if user has staff role (roleId = 1 for admin, roleId = 2 for staff)
        return user.getRoleId() == 1 || user.getRoleId() == 4;
    }

    /**
     * List all tours
     */
    private void listTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        transferSessionMessages(request);
        applyListFeedbackMessages(request);

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
        
        transferSessionMessages(request);

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
            
            // Load current services for the tour (to display on the view page)
            List<TourService> currentServices = serviceDao.getServicesByTourId(tourId);
            
            // Load tour itinerary data
            List<TourItinerary> tourItineraries = tourDao.getListTourItineriesById(tourId);
            
            request.setAttribute("tour", tour);
            request.setAttribute("island", island);
            request.setAttribute("currentServices", currentServices);
            request.setAttribute("tourItineraries", tourItineraries);
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
            throws ServletException, IOException, SQLException {
        
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
            
            // Load current services for the tour
            List<TourService> currentServices = serviceDao.getServicesByTourId(tourId);
            request.setAttribute("currentServices", currentServices);
            
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
            tour.setApprovalStatus("PENDING"); // Set status to PENDING when staff edit tours
            
            // Set available quantity
            String availableQuantityStr = request.getParameter("availableQuantity");
            if (availableQuantityStr != null && !availableQuantityStr.trim().isEmpty()) {
                tour.setAvailableQuantity(Integer.parseInt(availableQuantityStr));
            }
            
            // Get selected services from the request and parse them by type
            String[] selectedServices = request.getParameterValues("selectedServices");
            
            // Parse services by type (format: "type_id")
            List<String> hotelIds = new ArrayList<>();
            List<String> placeIds = new ArrayList<>();
            List<String> vehicleIds = new ArrayList<>();
            List<String> flightIds = new ArrayList<>();
            
            if (selectedServices != null) {
                System.out.println("Total selectedServices count: " + selectedServices.length);
                for (String service : selectedServices) {
                    System.out.println("Processing service: " + service);
                    if (service.startsWith("hotel_")) {
                        hotelIds.add(service.substring(6)); // Remove "hotel_" prefix
                    } else if (service.startsWith("place_")) {
                        placeIds.add(service.substring(6)); // Remove "place_" prefix
                    } else if (service.startsWith("vehicle_")) {
                        vehicleIds.add(service.substring(8)); // Remove "vehicle_" prefix
                    } else if (service.startsWith("flight_")) {
                        flightIds.add(service.substring(7)); // Remove "flight_" prefix
                        System.out.println("Found flight: " + service.substring(7));
                    } else if (service.startsWith("airline_")) {
                        // Backward compatibility: convert airline_ to flight_
                        flightIds.add(service.substring(8)); // Remove "airline_" prefix
                        System.out.println("Found airline (converted to flight): " + service.substring(8));
                    }
                }
            } else {
                System.out.println("selectedServices is null!");
            }
            
            System.out.println("Parsed services - Hotels: " + hotelIds.size() + ", Places: " + placeIds.size() + 
                             ", Vehicles: " + vehicleIds.size() + ", Flights: " + flightIds.size());
            
            // Convert lists to arrays
            String[] selectedHotels = hotelIds.toArray(new String[0]);
            String[] selectedPlaces = placeIds.toArray(new String[0]);
            String[] selectedVehicles = vehicleIds.toArray(new String[0]);
            
            // Update tour with services using the new method
            boolean success = tourDao.updateTourWithServices(tour, selectedHotels, null, selectedPlaces, selectedVehicles);
            // After clearing and re-adding services, add flights
            if (flightIds != null && !flightIds.isEmpty()) {
                System.out.println("Calling addSelectedServicesToTour with " + flightIds.size() + " flights for tour " + tour.getTourId());
                addSelectedServicesToTour(tour.getTourId(), flightIds.toArray(new String[0]), "FLIGHT");
            } else {
                System.out.println("No flights to add for tour " + tour.getTourId() + " (flightIds is " + 
                                 (flightIds == null ? "null" : "empty") + ")");
            }

            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật tour thành công");
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
        
        // Load current services for the tour
        List<TourService> currentServices = serviceDao.getServicesByTourId(tourId);
        request.setAttribute("currentServices", currentServices);
        
        request.setAttribute("tour", tour);
        request.setAttribute("islands", islands);
        request.setAttribute("action", "edit");
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

            if (tourDao.isTourInUse(tourId)) {
                request.setAttribute("errorMessage", "Không thể xóa tour vì đang được sử dụng trong các booking hiện có.");
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
                tour.setApprovalStatus("PENDING"); // Set default status to PENDING for staff-created tours
                
                // Set available quantity
                String availableQuantityStr = request.getParameter("availableQuantity");
                if (availableQuantityStr != null && !availableQuantityStr.trim().isEmpty()) {
                    tour.setAvailableQuantity(Integer.parseInt(availableQuantityStr));
                } else {
                    tour.setAvailableQuantity(0); // Default to 0 if not provided
                }
                
                int newTourId = tourDao.createTour(tour);

                if (newTourId > 0) {
                    // Process selected services in unified format: type_id
                    String[] selectedServices = request.getParameterValues("selectedServices");

                    List<String> hotelIds = new ArrayList<>();
                    List<String> placeIds = new ArrayList<>();
                    List<String> vehicleIds = new ArrayList<>();
                    List<String> flightIds = new ArrayList<>();

                    if (selectedServices != null) {
                        for (String service : selectedServices) {
                            if (service.startsWith("hotel_")) {
                                hotelIds.add(service.substring(6));
                            } else if (service.startsWith("place_")) {
                                placeIds.add(service.substring(6));
                            } else if (service.startsWith("vehicle_")) {
                                vehicleIds.add(service.substring(8));
                            } else if (service.startsWith("flight_")) {
                                flightIds.add(service.substring(7));
                            } else if (service.startsWith("airline_")) {
                                // Backward compatibility: convert airline_ to flight_
                                flightIds.add(service.substring(8));
                            }
                        }
                    }

                    // Add selected services to tour
                    addSelectedServicesToTour(newTourId, hotelIds.toArray(new String[0]), "Hotel");
                    addSelectedServicesToTour(newTourId, placeIds.toArray(new String[0]), "Place");
                    addSelectedServicesToTour(newTourId, vehicleIds.toArray(new String[0]), "Vehicle");
                    addSelectedServicesToTour(newTourId, flightIds.toArray(new String[0]), "FLIGHT");
                    
                    request.setAttribute("success", "Tạo tour thành công");
                    // Redirect to itinerary page after successful tour creation
                    response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + newTourId + "&fromCreate=true");
                } else {
                    request.setAttribute("error", "Tạo tour thất bại");
                    request.setAttribute("action", "create");
                    List<Island> islands = islandDao.getIslands();
                    request.setAttribute("islands", islands);
                    request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
                }

            } else if ("edit".equals(action)) {
                // Handle tour editing with service management
                String tourIdStr = request.getParameter("id");
                String tourName = request.getParameter("tourName");
                String description = request.getParameter("description");
                String priceStr = request.getParameter("price");
                String islandIdStr = request.getParameter("islandId");
                
                if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
                    request.setAttribute("error", "ID tour là bắt buộc");
                    response.sendRedirect(request.getContextPath() + "/staff/tours");
                    return;
                }
                
                try {
                    int tourId = Integer.parseInt(tourIdStr);
                    
                    // Get existing tour
                    Tour existingTour = tourDao.getTourDetailById(tourId);
                    if (existingTour == null) {
                        request.setAttribute("error", "Không tìm thấy tour");
                        response.sendRedirect(request.getContextPath() + "/staff/tours");
                        return;
                    }
                    
                    String tourImageUrl = existingTour.getTourImageUrl();
                    
                    // Handle file upload if new image is provided
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
                            // Load edit form with current data to preserve user input
                            loadEditTourData(request, response, tourId);
                            return;
                        }
                    }
                    
                    // Validation
                    if (!validateTourInput(tourIdStr, tourName, description, priceStr, islandIdStr, request)) {
                        // Load edit form with current data to preserve user input
                        loadEditTourData(request, response, tourId);
                        return;
                    }
                    
                    int price = Integer.parseInt(priceStr);
                    int islandId = Integer.parseInt(islandIdStr);
                    
                    // Check if tour name already exists (excluding current tour)
                    if (tourDao.tourNameExists(tourName, tourId)) {
                        request.setAttribute("error", "Tên tour đã tồn tại");
                        // Load edit form with current data to preserve user input
                        loadEditTourData(request, response, tourId);
                        return;
                    }
                    
                    // Update tour with services
                    Tour tour = new Tour(tourId, islandId, tourName, description, price, tourImageUrl);
                    tour.setApprovalStatus("PENDING"); // Set status to PENDING when staff edit tours
                    
                    // Get selected services from the request and parse them by type
                    String[] selectedServices = request.getParameterValues("selectedServices");
                    
                    // Parse services by type (format: "type_id")
                    List<String> hotelIds = new ArrayList<>();
                    List<String> placeIds = new ArrayList<>();
                    List<String> vehicleIds = new ArrayList<>();
                    List<String> flightIds = new ArrayList<>();
                    
                    if (selectedServices != null) {
                        for (String service : selectedServices) {
                            if (service.startsWith("hotel_")) {
                                hotelIds.add(service.substring(6)); // Remove "hotel_" prefix
                            } else if (service.startsWith("place_")) {
                                placeIds.add(service.substring(6)); // Remove "place_" prefix
                            } else if (service.startsWith("vehicle_")) {
                                vehicleIds.add(service.substring(8)); // Remove "vehicle_" prefix
                            } else if (service.startsWith("flight_")) {
                                flightIds.add(service.substring(7)); // Remove "flight_" prefix
                            } else if (service.startsWith("airline_")) {
                                // Backward compatibility: convert airline_ to flight_
                                flightIds.add(service.substring(8)); // Remove "airline_" prefix
                            }
                        }
                    }
                    
                    // Convert lists to arrays
                    String[] selectedHotels = hotelIds.toArray(new String[0]);
                    String[] selectedPlaces = placeIds.toArray(new String[0]);
                    String[] selectedVehicles = vehicleIds.toArray(new String[0]);
                    
                    // Update tour with services using the new method in TourDao
                    boolean updated = tourDao.updateTourWithServices(tour, selectedHotels, null, selectedPlaces, selectedVehicles);
                    // After clearing and re-adding services, add flights
                    if (flightIds != null && !flightIds.isEmpty()) {
                        addSelectedServicesToTour(tour.getTourId(), flightIds.toArray(new String[0]), "FLIGHT");
                        System.out.println("Added " + flightIds.size() + " flights to tour " + tour.getTourId());
                    } else {
                        System.out.println("No flights to add for tour " + tour.getTourId());
                    }
                    
                    if (updated) {
                        request.setAttribute("success", "Cập nhật tour thành công");
                        response.sendRedirect(request.getContextPath() + "/staff/tours?action=view&id=" + tourId);
                    } else {
                        request.setAttribute("error", "Cập nhật tour thất bại");
                        // Load edit form with current data to preserve user input
                        loadEditTourData(request, response, tourId);
                    }
                    
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Dữ liệu không hợp lệ");
                    try {
                        int tourId = Integer.parseInt(tourIdStr);
                        loadEditTourData(request, response, tourId);
                    } catch (Exception ex) {
                        listTours(request, response);
                    }
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

    // ==================== SERVICE MANAGEMENT METHODS ====================
    
    /**
     * Manage services for a tour
     */
    private void manageServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("tourId");
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

            // Get current services for the tour
            List<TourService> currentServices = serviceDao.getServicesByTourId(tourId);
            
            // Get available services for the island
            List<TourService> availableServices = serviceDao.getServicesByIslandId(tour.getIslandId());
            
            request.setAttribute("tour", tour);
            request.setAttribute("currentServices", currentServices);
            request.setAttribute("availableServices", availableServices);
            request.getRequestDispatcher("/views/staff/tour-services.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid tour ID format");
            listTours(request, response);
        }
    }
    
    /**
     * Add service to tour
     */
    private void addServiceToTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("tourId");
        String serviceType = request.getParameter("serviceType");
        String serviceIdStr = request.getParameter("serviceId");
        
        if (tourIdStr == null || serviceType == null || serviceIdStr == null) {
            request.getSession().setAttribute("error", "Thiếu thông tin bắt buộc");
            listTours(request, response);
            return;
        }

        try {
            int tourId = Integer.parseInt(tourIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            
            // Check if service is already in tour
            if (serviceDao.isServiceInTour(tourId, serviceType, serviceId)) {
                request.getSession().setAttribute("error", "Dịch vụ đã được thêm vào tour");
            } else {
                boolean success = serviceDao.addServiceToTour(tourId, serviceType, serviceId);
                if (success) {
                    request.getSession().setAttribute("success", "Thêm dịch vụ thành công");
                } else {
                    request.getSession().setAttribute("error", "Thêm dịch vụ thất bại");
                }
            }
            
            // Redirect back to manage services page
            response.sendRedirect(request.getContextPath() + "/staff/tours?action=manage-services&tourId=" + tourId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid ID format");
            listTours(request, response);
        }
    }
    
    /**
     * Remove service from tour
     */
    private void removeServiceFromTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourServiceIdStr = request.getParameter("tourServiceId");
        String tourIdStr = request.getParameter("tourId");
        
        if (tourServiceIdStr == null || tourIdStr == null) {
            request.getSession().setAttribute("error", "Thiếu thông tin bắt buộc");
            listTours(request, response);
            return;
        }

        try {
            int tourServiceId = Integer.parseInt(tourServiceIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            
            boolean success = serviceDao.removeServiceFromTour(tourServiceId);
            if (success) {
                request.getSession().setAttribute("success", "Xóa dịch vụ thành công");
            } else {
                request.getSession().setAttribute("error", "Xóa dịch vụ thất bại");
            }
            
            // Redirect back to manage services page
            response.sendRedirect(request.getContextPath() + "/staff/tours?action=manage-services&tourId=" + tourId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid ID format");
            listTours(request, response);
        }
    }
    
    /**
     * Helper method to add selected services to tour
     */
    private void addSelectedServicesToTour(int tourId, String[] selectedServices, String serviceType) {
        if (selectedServices != null && selectedServices.length > 0) {
            try {
                for (String serviceIdStr : selectedServices) {
                    if (serviceIdStr != null && !serviceIdStr.trim().isEmpty()) {
                        int serviceId = Integer.parseInt(serviceIdStr);
                        // Check if service is not already in tour before adding
                        if (!serviceDao.isServiceInTour(tourId, serviceType, serviceId)) {
                            boolean added = serviceDao.addServiceToTour(tourId, serviceType, serviceId);
                            if (added) {
                                System.out.println("Successfully added " + serviceType + " (ID: " + serviceId + ") to tour " + tourId);
                            } else {
                                System.err.println("Failed to add " + serviceType + " (ID: " + serviceId + ") to tour " + tourId);
                            }
                        } else {
                            System.out.println(serviceType + " (ID: " + serviceId + ") already exists in tour " + tourId);
                        }
                    }
                }
            } catch ( Exception e) {
                // Log error but don't fail the tour creation
                System.err.println("Error adding services to tour " + tourId + ": " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("No " + serviceType + " services to add for tour " + tourId);
        }
    }
    


    // ==================== AJAX METHODS ====================
    
    /**
     * Get services for an island (AJAX endpoint)
     */
    private void getServicesForIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        String islandIdStr = request.getParameter("islandId");
        if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Island ID is required\"}");
            return;
        }

        try {
            int islandId = Integer.parseInt(islandIdStr);
            List<TourService> services = serviceDao.getServicesByIslandId(islandId);
            
            // Build JSON response manually with success wrapper
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\": true,");
            json.append("\"data\": {");
            json.append("\"hotels\": [");
            
            boolean firstHotel = true;
            for (TourService service : services) {
                if ("Hotel".equals(service.getServiceType())) {
                    if (!firstHotel) json.append(",");
                    json.append("{");
                    json.append("\"id\": ").append(service.getServiceId()).append(",");
                    json.append("\"name\": \"").append(escapeJson(service.getServiceName())).append("\",");
                    json.append("\"address\": \"").append(escapeJson(service.getAddress() != null ? service.getAddress() : "")).append("\",");
                    json.append("\"price\": ").append(service.getServicePrice());
                    json.append("}");
                    firstHotel = false;
                }
            }
            
            json.append("], \"places\": [");
            
            boolean firstPlace = true;
            for (TourService service : services) {
                if ("Place".equals(service.getServiceType())) {
                    if (!firstPlace) json.append(",");
                    json.append("{");
                    json.append("\"id\": ").append(service.getServiceId()).append(",");
                    json.append("\"name\": \"").append(escapeJson(service.getServiceName())).append("\",");
                    json.append("\"address\": \"").append(escapeJson(service.getAddress() != null ? service.getAddress() : "")).append("\",");
                    json.append("\"price\": ").append(service.getServicePrice());
                    json.append("}");
                    firstPlace = false;
                }
            }
            
            json.append("], \"vehicles\": [");
            
            boolean firstVehicle = true;
            for (TourService service : services) {
                if ("Vehicle".equals(service.getServiceType())) {
                    if (!firstVehicle) json.append(",");
                    json.append("{");
                    json.append("\"id\": ").append(service.getServiceId()).append(",");
                    json.append("\"name\": \"").append(escapeJson(service.getServiceName())).append("\",");
                    json.append("\"type\": \"").append(escapeJson(service.getVehicleType() != null ? service.getVehicleType() : "")).append("\",");
                    json.append("\"price\": ").append(service.getServicePrice());
                    json.append("}");
                    firstVehicle = false;
                }
            }
            
            json.append("], \"flights\": [");

            boolean firstFlight = true;
            for (TourService service : services) {
                if ("FLIGHT".equals(service.getServiceType())) {
                    if (!firstFlight) json.append(",");
                    json.append("{");
                    json.append("\"id\": ").append(service.getServiceId()).append(",");
                    json.append("\"name\": \"").append(escapeJson(service.getServiceName() != null ? service.getServiceName() : "")).append("\",");
                    json.append("\"description\": \"").append(escapeJson(service.getServiceDescription() != null ? service.getServiceDescription() : "")).append("\",");
                    json.append("\"price\": ").append(service.getServicePrice());
                    json.append("}");
                    firstFlight = false;
                }
            }

            json.append("]");
            json.append("}"); // Close data object
            json.append("}"); // Close main response object
            
            response.getWriter().write(json.toString());
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid island ID format\"}");
        }
    }
    
    /**
     * Escape JSON special characters
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    /**
     * Manage tour itinerary page
     */
    private void manageTourItinerary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("id");
        if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID tour là bắt buộc");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }
        
        try {
            int tourId = Integer.parseInt(tourIdStr);
            
            // Get tour details
            Tour tour = tourDao.getTourDetailById(tourId);
            if (tour == null) {
                request.setAttribute("error", "Không tìm thấy tour");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            // Get existing itineraries for this tour
            List<TourItinerary> tourItineraries = tourDao.getListTourItineriesById(tourId);
            
            // Set attributes
            request.setAttribute("tour", tour);
            request.setAttribute("tourItineraries", tourItineraries);
            
            // Check if redirected from tour creation
            String fromCreate = request.getParameter("fromCreate");
            if ("true".equals(fromCreate)) {
                request.setAttribute("successMessage", "Tour đã được tạo thành công! Bây giờ hãy tạo lịch trình cho tour.");
            }
            
            request.getRequestDispatcher("/views/staff/tour-itinerary.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID tour không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }

    /**
     * Create tour itinerary
     */
    private void createTourItinerary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String tourIdStr = request.getParameter("tourId");
        if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID tour là bắt buộc");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }
        
        try {
            int tourId = Integer.parseInt(tourIdStr);
            
            // Get tour details to verify it exists
            Tour tour = tourDao.getTourDetailById(tourId);
            if (tour == null) {
                request.setAttribute("error", "Không tìm thấy tour");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            // Process itinerary data from form
            Map<String, String[]> parameterMap = request.getParameterMap();
            Map<Integer, TourItinerary> itinerariesMap = new HashMap<>();
            
            // Parse form data to create itinerary objects
            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                String paramName = entry.getKey();
                String[] paramValues = entry.getValue();
                
                if (paramName.startsWith("dayTitle_")) {
                    // Extract day number from parameter name
                    String dayNumberStr = paramName.substring("dayTitle_".length());
                    try {
                        int dayNumber = Integer.parseInt(dayNumberStr);
                        String dayTitle = paramValues[0];
                        
                        // Create or get existing itinerary for this day
                        TourItinerary itinerary = itinerariesMap.get(dayNumber);
                        if (itinerary == null) {
                            itinerary = new TourItinerary();
                            itinerary.setTourId(tourId);
                            itinerary.setDayNumber(dayNumber);
                            itinerary.setActivities(new ArrayList<>());
                            itinerariesMap.put(dayNumber, itinerary);
                        }
                        itinerary.setTitle(dayTitle);
                        
                    } catch (NumberFormatException e) {
                        // Skip invalid day numbers
                        continue;
                    }
                }
                
                // Process activities
                if (paramName.startsWith("activityTitle_")) {
                    // Extract day number and activity number
                    String[] parts = paramName.substring("activityTitle_".length()).split("_");
                    if (parts.length == 2) {
                        try {
                            int dayNumber = Integer.parseInt(parts[0]);
                            int activityOrder = Integer.parseInt(parts[1]);
                            String activityTitle = paramValues[0];
                            
                            // Get corresponding description
                            String descriptionParam = "activityDescription_" + parts[0] + "_" + parts[1];
                            String description = "";
                            if (parameterMap.containsKey(descriptionParam)) {
                                description = parameterMap.get(descriptionParam)[0];
                            }
                            
                            // Create activity
                            TourActivities activity = new TourActivities();
                            activity.setActivityTitle(activityTitle);
                            activity.setDescription(description);
                            activity.setActivityOrder(activityOrder);
                            
                            // Add to itinerary
                            TourItinerary itinerary = itinerariesMap.get(dayNumber);
                            if (itinerary != null) {
                                itinerary.getActivities().add(activity);
                            }
                            
                        } catch (NumberFormatException e) {
                            // Skip invalid numbers
                            continue;
                        }
                    }
                }
            }
            
            // Save itineraries to database
            boolean success = true;
            for (TourItinerary itinerary : itinerariesMap.values()) {
                try {
                    // Save itinerary and get its ID
                    int itineraryId = tourDao.createTourItinerary(itinerary);
                    if (itineraryId > 0) {
                        // Save activities for this itinerary
                        for (TourActivities activity : itinerary.getActivities()) {
                            activity.setItineraryId(itineraryId);
                            tourDao.createTourActivity(activity);
                        }
                    } else {
                        success = false;
                        break;
                    }
                } catch (Exception e) {
                    success = false;
                    break;
                }
            }
            
            if (success) {
                request.setAttribute("successMessage", "Lịch trình tour đã được tạo thành công!");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId + "&success=true");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo lịch trình");
                manageTourItinerary(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID tour không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }

    // ==================== ACTIVITY MANAGEMENT METHODS ====================
    
    /**
     * Edit activity - show edit form
     */
    private void editActivity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String activityIdStr = request.getParameter("id");
        String tourIdStr = request.getParameter("tourId");
        
        if (activityIdStr == null || tourIdStr == null) {
            request.setAttribute("error", "Thiếu thông tin bắt buộc");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }
        
        try {
            int activityId = Integer.parseInt(activityIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            
            // Get activity details
            TourActivities activity = tourDao.getTourActivityById(activityId);
            if (activity == null) {
                request.setAttribute("error", "Không tìm thấy hoạt động");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
                return;
            }
            
            // Get tour details for context
            Tour tour = tourDao.getTourDetailById(tourId);
            if (tour == null) {
                request.setAttribute("error", "Không tìm thấy tour");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            request.setAttribute("activity", activity);
            request.setAttribute("tour", tour);
            request.getRequestDispatcher("/views/staff/edit-activity.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }
    
    /**
     * Update activity
     */
    private void updateActivity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String activityIdStr = request.getParameter("activityId");
        String tourIdStr = request.getParameter("tourId");
        String activityTitle = request.getParameter("activityTitle");
        String description = request.getParameter("description");
        String activityOrderStr = request.getParameter("activityOrder");
        
        if (activityIdStr == null || tourIdStr == null || activityTitle == null || description == null || activityOrderStr == null) {
            request.setAttribute("error", "Thiếu thông tin bắt buộc");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }
        
        try {
            int activityId = Integer.parseInt(activityIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            int activityOrder = Integer.parseInt(activityOrderStr);
            
            // Validate input
            if (activityTitle.trim().isEmpty() || description.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề và mô tả không được để trống");
                editActivity(request, response);
                return;
            }
            
            // Get existing activity to preserve itineraryId
            TourActivities existingActivity = tourDao.getTourActivityById(activityId);
            if (existingActivity == null) {
                request.setAttribute("error", "Không tìm thấy hoạt động");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
                return;
            }
            
            // Create updated activity object
            TourActivities activity = new TourActivities();
            activity.setActivityId(activityId);
            activity.setItineraryId(existingActivity.getItineraryId());
            activity.setActivityTitle(activityTitle.trim());
            activity.setDescription(description.trim());
            activity.setActivityOrder(activityOrder);
            
            // Update activity
            boolean success = tourDao.updateTourActivity(activity);
            
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật hoạt động thành công");
            } else {
                request.getSession().setAttribute("error", "Cập nhật hoạt động thất bại");
            }
            
            // Redirect back to itinerary page
            response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }

    /**
     * Handle edit itinerary request - display edit form
     */
    private void editItinerary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            String itineraryIdStr = request.getParameter("id");
            String tourIdStr = request.getParameter("tourId");
            
            if (itineraryIdStr == null || tourIdStr == null) {
                request.setAttribute("error", "Thiếu thông tin lịch trình");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            int itineraryId = Integer.parseInt(itineraryIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            
            // Get itinerary details
            TourItinerary itinerary = tourDao.getTourItineraryById(itineraryId);
            if (itinerary == null) {
                request.setAttribute("error", "Không tìm thấy lịch trình");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
                return;
            }
            
            // Get tour details for context
            Tour tour = tourDao.getTourDetailById(tourId);
            
            request.setAttribute("itinerary", itinerary);
            request.setAttribute("tour", tour);
            request.getRequestDispatcher("/views/staff/edit-itinerary.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }
    
    /**
     * Handle update itinerary request - process form submission
     */
    private void updateItinerary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            String itineraryIdStr = request.getParameter("itineraryId");
            String tourIdStr = request.getParameter("tourId");
            String dayNumberStr = request.getParameter("dayNumber");
            String title = request.getParameter("title");
            
            if (itineraryIdStr == null || tourIdStr == null || dayNumberStr == null || title == null) {
                request.getSession().setAttribute("error", "Thiếu thông tin cần thiết");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            int itineraryId = Integer.parseInt(itineraryIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            int dayNumber = Integer.parseInt(dayNumberStr);
            
            // Validate input
            if (title.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Tiêu đề ngày không được để trống");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=edit-itinerary&id=" + itineraryId + "&tourId=" + tourId);
                return;
            }
            
            if (dayNumber <= 0) {
                request.getSession().setAttribute("error", "Số ngày phải lớn hơn 0");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=edit-itinerary&id=" + itineraryId + "&tourId=" + tourId);
                return;
            }
            
            // Get existing itinerary to verify it exists
            TourItinerary existingItinerary = tourDao.getTourItineraryById(itineraryId);
            if (existingItinerary == null) {
                request.getSession().setAttribute("error", "Không tìm thấy lịch trình");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
                return;
            }
            
            // Create updated itinerary object
            TourItinerary itinerary = new TourItinerary();
            itinerary.setItineraryId(itineraryId);
            itinerary.setTourId(tourId);
            itinerary.setDayNumber(dayNumber);
            itinerary.setTitle(title.trim());
            
            // Update itinerary
            boolean success = tourDao.updateTourItinerary(itinerary);
            
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật lịch trình thành công");
            } else {
                request.getSession().setAttribute("error", "Cập nhật lịch trình thất bại");
            }
            
            // Redirect back to itinerary page
            response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }

    /**
     * Handle add activity to itinerary request - display add form
     */
    private void addActivityToItinerary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            String itineraryIdStr = request.getParameter("id");
            String tourIdStr = request.getParameter("tourId");
            
            if (itineraryIdStr == null || tourIdStr == null) {
                request.setAttribute("error", "Thiếu thông tin lịch trình");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            int itineraryId = Integer.parseInt(itineraryIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            
            // Get itinerary details
            TourItinerary itinerary = tourDao.getTourItineraryById(itineraryId);
            if (itinerary == null) {
                request.setAttribute("error", "Không tìm thấy lịch trình");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
                return;
            }
            
            // Get tour details for context
            Tour tour = tourDao.getTourDetailById(tourId);
            
            // Get existing activities to determine next order
            List<TourActivities> activities = tourDao.getListTourActivitiesByItineraryId(itineraryId);
            int nextOrder = activities.size() + 1;
            
            request.setAttribute("itinerary", itinerary);
            request.setAttribute("tour", tour);
            request.setAttribute("nextOrder", nextOrder);
            request.getRequestDispatcher("/views/staff/add-activity-to-itinerary.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }
    
    /**
     * Handle create activity request - process form submission
     */
    private void createActivity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            String itineraryIdStr = request.getParameter("itineraryId");
            String tourIdStr = request.getParameter("tourId");
            String activityOrderStr = request.getParameter("activityOrder");
            String activityTitle = request.getParameter("activityTitle");
            String description = request.getParameter("description");
            
            if (itineraryIdStr == null || tourIdStr == null || activityOrderStr == null || 
                activityTitle == null || description == null) {
                request.getSession().setAttribute("error", "Thiếu thông tin cần thiết");
                response.sendRedirect(request.getContextPath() + "/staff/tours");
                return;
            }
            
            int itineraryId = Integer.parseInt(itineraryIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            int activityOrder = Integer.parseInt(activityOrderStr);
            
            // Validate input
            if (activityTitle.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Tên hoạt động không được để trống");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=add-activity-to-itinerary&id=" + itineraryId + "&tourId=" + tourId);
                return;
            }
            
            if (description.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Mô tả hoạt động không được để trống");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=add-activity-to-itinerary&id=" + itineraryId + "&tourId=" + tourId);
                return;
            }
            
            if (activityOrder <= 0) {
                request.getSession().setAttribute("error", "Thứ tự hoạt động phải lớn hơn 0");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=add-activity-to-itinerary&id=" + itineraryId + "&tourId=" + tourId);
                return;
            }
            
            // Verify itinerary exists
            TourItinerary existingItinerary = tourDao.getTourItineraryById(itineraryId);
            if (existingItinerary == null) {
                request.getSession().setAttribute("error", "Không tìm thấy lịch trình");
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
                return;
            }
            
            // Create new activity object
            TourActivities activity = new TourActivities();
            activity.setItineraryId(itineraryId);
            activity.setActivityOrder(activityOrder);
            activity.setActivityTitle(activityTitle.trim());
            activity.setDescription(description.trim());
            
            // Create activity
            int activityId = tourDao.createTourActivity(activity);
            
            if (activityId > 0) {
                request.getSession().setAttribute("success", "Thêm hoạt động thành công");
            } else {
                request.getSession().setAttribute("error", "Thêm hoạt động thất bại");
            }
            
            // Redirect back to itinerary page
            response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tours");
        }
    }

    /**
     * Delete a specific itinerary
     */
    private void deleteItinerary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String itineraryIdStr = request.getParameter("id");
        String tourIdStr = request.getParameter("tourId");
        
        if (itineraryIdStr == null || tourIdStr == null) {
            handleError(request, response, "Missing itinerary ID or tour ID", null);
            return;
        }
        
        try {
            int itineraryId = Integer.parseInt(itineraryIdStr);
            int tourId = Integer.parseInt(tourIdStr);
            
            boolean deleted = tourDao.deleteItinerary(itineraryId);
            
            if (deleted) {
                // Redirect back to the itinerary management page
                response.sendRedirect(request.getContextPath() + "/staff/tours?action=itinerary&id=" + tourId);
            } else {
                handleError(request, response, "Failed to delete itinerary. Itinerary may not exist.", null);
            }
        } catch (NumberFormatException e) {
            handleError(request, response, "Invalid itinerary ID or tour ID format", e);
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