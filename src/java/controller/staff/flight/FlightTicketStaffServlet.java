/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff.flight;

import dao.ServiceDao;
import jakarta.mail.Session;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
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
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import model.Airlines;
import model.Flight;
import model.Island;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name = "FlightTicketStaffServlet", urlPatterns = {"/staff/flight/tickets"})

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB: temporary storage in memory before writing to file
        maxFileSize = 1024 * 1024 * 10, // 10MB: maximum file size
        maxRequestSize = 1024 * 1024 * 50 // 50MB: total request size
)
public class FlightTicketStaffServlet extends HttpServlet {

    private ServiceDao serviceDao;

    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in FlightStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in FlightStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FlightTicketStaffServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlightTicketStaffServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // khai bao class flightService
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);

        // Kiểm tra quyền staff/admin; hàm sẽ tự redirect nếu chưa login hoặc role không hợp lệ
        if (!isStaffAuthorized(session, request, response)) {
            return;
        }
     
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    handleFlightList(request, response);
                    break;

                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleFlightSearch(request, response);
                    break;
                default:
                    handleFlightList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight request: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (!isStaffAuthorized(session, request, response)) {

            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/staff/flight/tickets");
            return;
        }
        try {
            switch (action) {
                case "create":
                    handleCreateFlight(request, response);
                    break;

                case "update":
                    handleUpdateFlight(request, response);
                    break;
                case "delete":
                    handleDeleteFlight(request, response);
                    break;
                case "updateAvailability":
                    handleUpdateAvailability(request, response);
                    break;
                default:
                    handleFlightList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight request: " + e.getMessage(), e);
        }
    }

    /**
     * Layer flights service
     */
    /**
     * Display list of all flights
     */
    private void handleFlightList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {

            // Get pagination paramaters
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            String searchParam = request.getParameter("search");

            // handle current page (dafault page =1)
            int page = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // handle pageSize (the number each pages display) 
            int pageSize = 12;// default=12
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 1) {
                        pageSize = 12;
                    }
                    if (pageSize > 100) {
                        pageSize = 100;//Max page size limit
                    }
                } catch (NumberFormatException e) {
                    pageSize = 12;
                }
            }

            // check search or not
            List<Flight> flights;
            int totalFlights;

            // check if search is performed
            if (searchParam != null && !searchParam.trim().isEmpty()) {
                flights = serviceDao.searchFlightsWithPagination(searchParam, page, pageSize);
                totalFlights = serviceDao.getSearchFlightsCount(searchParam.trim());
                request.setAttribute("search", searchParam.trim());

            } else {
                flights = serviceDao.getFlightsByPageWithAirlineNames(page, pageSize);
                totalFlights = serviceDao.getTotalFlightsCount();
            }

            // calculate pagination info
            int totalPages = (int) Math.ceil((double) totalFlights / pageSize);

            //set Attribute
            request.setAttribute("flights", flights);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalFlights", totalFlights);

            List<Airlines> airlines = serviceDao.getAllAirlineNames();
            session.setAttribute("airlineNames", airlines);
            // calculate pagination display page
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);

            request.setAttribute("action", "list");
            request.setAttribute("pageTitle", "Flight Management");
            request.getRequestDispatcher("/views/staff/flight_ticket-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight list: " + e.getMessage(), e);
        }
    }

    /**
     * Display flight details
     */
    /**
     * Display create flight form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load airlines and islands for dropdowns
            List<Airlines> airlines = serviceDao.getAllAirlines();
            List<Island> islands = serviceDao.getAllIslands();
            request.setAttribute("islands", islands);
            request.setAttribute("airlines", airlines);
            request.setAttribute("pageTitle", "Create New Flight");
            request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit flight form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("flightId");
            if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Flight ID is required");
                handleFlightList(request, response);
                return;
            }

            int flightId = Integer.parseInt(flightIdStr);
            Flight flight = serviceDao.getFlightById(flightId);

            if (flight == null) {
                request.setAttribute("errorMessage", "Flight not found");
                handleFlightList(request, response);
                return;
            }

            // Load airlines and islands for dropdowns
            List<Airlines> airlines = serviceDao.getAllAirlines();
            List<Island> islands = serviceDao.getAllIslands();

            request.setAttribute("flight", flight);
            request.setAttribute("airlines", airlines);
            request.setAttribute("islands", islands);
            request.setAttribute("action", "edit");
            request.setAttribute("pageTitle", "Edit Flight - " + flight.getFlightNumber());
            request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
            return;
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid flight ID format");
            handleFlightList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle flight search
     */
    public void handleFlightSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy tham số từ form
            String keyword = request.getParameter("search");
            String airlineIdStr = request.getParameter("airlineId");
            String priceRange = request.getParameter("priceRange");

            // Chuyển airlineId sang Integer nếu hợp lệ, null nếu rỗng
            Integer airlineId = null;
            if (airlineIdStr != null && !airlineIdStr.isEmpty()) {
                try {
                    airlineId = Integer.parseInt(airlineIdStr);
                } catch (NumberFormatException e) {

                    request.setAttribute("errorMessage", "Hãng bay không hợp lệ, bỏ qua filter.");
                    request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
                }
            }

            // Kiểm tra priceRange hợp lệ, null hoặc rỗng cũng được
            if (priceRange != null && !priceRange.isEmpty() && !priceRange.matches("\\d+-\\d+|\\d+\\+")) {
                request.setAttribute("errorMessage", "Khoảng giá không hợp lệ, bỏ qua filter.");
                priceRange = null;
            }

            // Gọi DAO / service để tìm chuyến bay theo filter
            List<Flight> flights = serviceDao.searchFlightTickets(keyword, airlineId, priceRange);

            // Truyền dữ liệu sang JSP
            request.setAttribute("flights", flights);
            request.setAttribute("keyword", keyword);
            request.setAttribute("airlineId", airlineIdStr);
            request.setAttribute("priceRange", priceRange);

            // Forward sang JSP danh sách chuyến bay
            request.getRequestDispatcher("/views/staff/flight_ticket-list.jsp").forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            // Forward sang trang error
            request.setAttribute("message", "Lỗi khi tìm chuyến bay: " + e.getMessage());
            request.setAttribute("exception", e);
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle create flight
     */
    private void handleCreateFlight(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input (nếu !false thì xử lý bên trong)
            if (!validateFlightInput(request)) {
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Flight");
                request.setAttribute("errorMessage", "Failed to create flight. Please try again.");
                request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
                return;
            }

            // Create flight object
            Flight flight = createFlightFromRequest(request);// catch exeptions

            // check ton tai chuyen bay
            if (serviceDao.isFlightExist(flight)) {
                request.setAttribute("error", "vé máy bay này đã tồn tại trong hệ thống!");
                request.setAttribute("action", "create");
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
                return;
            }
            // Save flight
            int newFlightId = serviceDao.createFlight(flight);

            if (newFlightId > 0) {

                response.sendRedirect(request.getContextPath() + "/staff/flight/tickets?action=list&success=created&flightId=" + newFlightId);
            } else {
                request.setAttribute("errorMessage", "Failed to create flight. Please try again.");
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Create New Flight");
                request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            handleError(request, response, "Error creating flight: " + e.getMessage(), e);
        }
    }

    /**
     * Create flight object from request parameters
     */
    private Flight createFlightFromRequest(HttpServletRequest request) throws IOException, ServletException, SQLException {
        Flight flight = new Flight();

        flight.setFlightNumber(request.getParameter("flightNumber"));
        flight.setDeparture(request.getParameter("departure"));

        // Set destination island
        String destinationIslandIdStr = request.getParameter("destinationIslandId");
        if (destinationIslandIdStr != null && !destinationIslandIdStr.trim().isEmpty()) {
            int islandId = Integer.parseInt(destinationIslandIdStr);
            Island island = serviceDao.getIslandById(islandId);
            flight.setDestinationIsland(island);
            flight.setDestination(island.getIslandName());
        }

        flight.setBasePrice(Integer.parseInt(request.getParameter("basePrice")));
        flight.setTicketAvailable(Integer.parseInt(request.getParameter("ticketAvailable")));
        flight.setFlightType(request.getParameter("flightType"));
        flight.setFlightClass(request.getParameter("flightClass"));

        // Set airline
        Airlines airline = new Airlines();
        airline.setAirlineId(Integer.parseInt(request.getParameter("airlineId")));
        flight.setAirline(airline);

        // Handle file upload
        Part filePart = request.getPart("flightImageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            String ext = originalName.substring(originalName.lastIndexOf("."));
            String uniqueName = "flight_" + System.currentTimeMillis() + ext;

            String uploadDir = getServletContext().getRealPath("") + File.separator + "UploadData" + File.separator + "Flights";
            File uploadPath = new File(uploadDir);
            if (!uploadPath.exists()) {
                uploadPath.mkdirs();
            }

            Path filePath = Paths.get(uploadDir, uniqueName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            flight.setDestinationImageUrl("UploadData/Flights/" + uniqueName);
        }

        return flight;
    }

    /**
     * Validate flight input
     *
     *
     */
    private boolean validateFlightInput(HttpServletRequest request) {
        boolean isValid = true;

        String flightNumber = request.getParameter("flightNumber");
        System.out.println("FlightNumber nhận được: " + request.getParameter("flightNumber"));

        if (flightNumber == null || flightNumber.trim().isEmpty()) {
            request.setAttribute("errorFlightNumber", "Flight number is required");
            isValid = false;
        }

        String airlineIdStr = request.getParameter("airlineId");
        if (airlineIdStr == null || airlineIdStr.trim().isEmpty()) {
            request.setAttribute("errorAirlineId", "Airline is required");
            isValid = false;
        } else {
            try {
                Integer.parseInt(airlineIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorAirlineId", "Invalid airline selection");
                isValid = false;
            }
        }

        String departure = request.getParameter("departure");
        if (departure == null || departure.trim().isEmpty()) {
            request.setAttribute("errorDeparture", "Departure location is required");
            isValid = false;
        }

        String destinationIslandIdStr = request.getParameter("destinationIslandId");
        if (destinationIslandIdStr == null || destinationIslandIdStr.trim().isEmpty()) {
            request.setAttribute("errorDestinationIslandId", "Destination island is required");
            isValid = false;
        } else {
            try {
                Integer.parseInt(destinationIslandIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorDestinationIslandId", "Invalid destination island selection");
                isValid = false;
            }
        }

        String basePriceStr = request.getParameter("basePrice");
        if (basePriceStr == null || basePriceStr.trim().isEmpty()) {
            request.setAttribute("errorBasePrice", "Base price is required");
            isValid = false;
        } else {
            try {
                int basePrice = Integer.parseInt(basePriceStr);
                if (basePrice <= 0) {
                    request.setAttribute("errorBasePrice", "Base price must be greater than 0");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorBasePrice", "Invalid base price format");
                isValid = false;
            }
        }

        String ticketAvailableStr = request.getParameter("ticketAvailable");
        if (ticketAvailableStr == null || ticketAvailableStr.trim().isEmpty()) {
            request.setAttribute("errorTicketAvailable", "Ticket availability is required");
            isValid = false;
        } else {
            try {
                int ticketAvailable = Integer.parseInt(ticketAvailableStr);
                if (ticketAvailable < 0) {
                    request.setAttribute("errorTicketAvailable", "Ticket availability cannot be negative");
                    isValid = false;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorTicketAvailable", "Invalid ticket availability format");
                isValid = false;
            }
        }

        String flightType = request.getParameter("flightType");
        if (flightType == null || flightType.trim().isEmpty()) {
            request.setAttribute("errorFlightType", "Flight type is required");
            isValid = false;
        }

        String flightClass = request.getParameter("flightClass");
        if (flightClass == null || flightClass.trim().isEmpty()) {
            request.setAttribute("errorFlightClass", "Flight class is required");
            isValid = false;
        }

        return isValid;
    }

    /**
     * Handle update flight
     */
    private void handleUpdateFlight(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            // Validate input
            if (!validateFlightInput(request)) {
                String flightIdStr = request.getParameter("flightId");
                if (flightIdStr != null) {
                    Flight flight = serviceDao.getFlightById(Integer.parseInt(flightIdStr));
                    request.setAttribute("flight", flight);
                }
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Flight");
                request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
                return;
            }

            // Create flight object
            Flight flight = createFlightFromRequest(request);
            flight.setFlightId(Integer.parseInt(request.getParameter("flightId")));

            // Update flight
            int updateFlightId = serviceDao.updateFlight(flight);

            if (updateFlightId > 0) {

                response.sendRedirect(request.getContextPath() + "/staff/flight/tickets?action=list&success=updated&flightId=" + updateFlightId);
            } else {
                request.setAttribute("errorMessage", "Failed to update flight. Please try again.");
                request.setAttribute("flight", flight);
                List<Airlines> airlines = serviceDao.getAllAirlines();
                List<Island> islands = serviceDao.getAllIslands();
                request.setAttribute("airlines", airlines);
                request.setAttribute("islands", islands);
                request.setAttribute("pageTitle", "Edit Flight");
                request.getRequestDispatcher("/views/staff/flight_ticket-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            handleError(request, response, "Error updating flight: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete flight
     */
    private void handleDeleteFlight(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("flightId");
            if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_id");
                return;
            }

            int flightId = Integer.parseInt(flightIdStr);

            // Delete flight
            int deleteFlightId = serviceDao.deleteFlight(flightId);

            if (deleteFlightId > 0) {

                response.sendRedirect(request.getContextPath() + "/staff/flight/tickets?action=list&success=deleted&flightId=" + deleteFlightId);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting flight: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update flight availability
     */
    private void handleUpdateAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String flightIdStr = request.getParameter("flightId");
            String availabilityStr = request.getParameter("availability");

            if (flightIdStr == null || availabilityStr == null) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_params");
                return;
            }

            int flightId = Integer.parseInt(flightIdStr);
            int availability = Integer.parseInt(availabilityStr);

            boolean success = serviceDao.updateFlightAvailability(flightId, availability);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/flights?success=availability_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=update_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_params");
        } catch (Exception e) {
            handleError(request, response, "Error updating flight availability: " + e.getMessage(), e);
        }
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
        System.err.println("FlightStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }

        int statusCode = 500;
        if (message.toLowerCase().contains("not found")) {
            statusCode = 404;
        } else if (message.toLowerCase().contains("unauthorized")) {
            statusCode = 401;
        }

        response.setStatus(statusCode);
        request.setAttribute("statusCode", statusCode);
        request.setAttribute("errorMessage", message);
        request.setAttribute("exception", e);
        request.setAttribute("pageTitle", "Error");

        request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "FlightStaffServlet - Handles flight management operations for staff";
    }

}
