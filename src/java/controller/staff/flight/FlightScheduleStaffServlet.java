/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.staff.flight;

import dao.ServiceDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
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
import model.FlightSchedule;
import model.Island;
import model.User;

/**
 *
 * @author nqagh
 */
@WebServlet(name="FlightScheduleStaffServlet", urlPatterns={"/staff/flight/schedules"})
public class FlightScheduleStaffServlet extends HttpServlet {
   
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
            out.println("<title>Servlet FlightScheduleStaffServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FlightScheduleStaffServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        
  // Kiểm tra quyền staff/admin; hàm sẽ tự redirect nếu chưa login hoặc role không hợp lệ
    if (!isStaffAuthorized(session, request, response)) {
        return;
    }
if(session != null){
    System.out.println("Session ID: " + session.getId());
    System.out.println("Creation time: " + new java.util.Date(session.getCreationTime()));
    System.out.println("Last accessed: " + new java.util.Date(session.getLastAccessedTime()));
    System.out.println("Max inactive interval: " + session.getMaxInactiveInterval() + " seconds");
} else {
    System.out.println("No session found");
}
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    handleFlightScheduleList(request, response);
                    break;
                case "create":
                    handleCreateSheduleForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                   handleFlightScheduleSearch(request, response);
                    break;
                default:
                    handleFlightScheduleList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight request: " + e.getMessage(), e);
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
                response.sendRedirect(request.getContextPath() + "/staff/flight/schedules");
                return;
            }
        try {
            switch (action) {
                case "create":
                    handleCreateFlightSchedule(request, response);
                    break;
                case "update":
                    handleUpdateFlightSchedule(request, response);
                    break;
                case "delete":
                  handleDeleteFlightSchedule(request, response);
                    break;
                default:
                   handleFlightScheduleList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing flight request: " + e.getMessage(), e);
        }
    }

   
     /**
     * Display list of all flights
     */
    private void handleFlightScheduleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            List<FlightSchedule> flightSchedules;
            int totalFlightSchedules;

            // check if search is performed
            if (searchParam != null && !searchParam.trim().isEmpty()) {
              flightSchedules = serviceDao.searchFlightSchedulesWithPagination(searchParam, page, pageSize);
               totalFlightSchedules = serviceDao.getSearchFlighScheduletsCount(searchParam.trim());
                request.setAttribute("search", searchParam.trim());

            } else {
               flightSchedules = serviceDao.getFlightsByPage(page, pageSize);
               totalFlightSchedules = serviceDao.getTotalFlightsCount();
            }

            // calculate pagination info
            int totalPages = (int) Math.ceil((double) totalFlightSchedules / pageSize);

            //set Attribute
            request.setAttribute("flightSchedules", flightSchedules);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute(" totalFlightSchedules",  totalFlightSchedules);

           
            // calculate pagination display page
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("pageTitle", "FlightSchedules Management");
            request.getRequestDispatcher("/views/staff/flight_schedule-list.jsp").forward(request, response);
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
    private void handleCreateSheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            //Danh sách chuyến bay chưa có lịch trình
            List<Flight> flights = serviceDao.getFlightsWithoutSchedule();
            request.setAttribute("flights", flights);
            
            request.setAttribute("pageTitle", "Create New FlightSchdeule");
            request.getRequestDispatcher("/views/staff/flight_schedule-form.jsp").forward(request, response);
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
            String scheduleIdStr = request.getParameter("scheduleId");
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Schedule ID is required");
                handleFlightScheduleList(request, response);
                return;
            }
            
            int scheduleId= Integer.parseInt(scheduleIdStr);
            System.out.println("id:"+scheduleId);
            FlightSchedule  schedule = serviceDao.getFlightScheduleById(scheduleId);
            
            if (schedule == null) {
                request.setAttribute("errorMessage", "FlightSchedule not found");
                  handleFlightScheduleList(request, response);
                return;
            }
            
            // Load airlines and islands for dropdowns
            List<Flight> flights = serviceDao.getFlightsWithoutSchedule();
      
          
            request.setAttribute("schedule", schedule);
            request.setAttribute("flights", flights);
            request.setAttribute("action", "edit");
            request.setAttribute("pageTitle", "Edit FlightiD - " + schedule.getFlight().getFlightId());
            request.getRequestDispatcher("/views/staff/flight_schedule-form.jsp").forward(request, response);
            return;
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid flight ID format");
            handleFlightScheduleList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading flight for edit: " + e.getMessage(), e);
        }
    }
     
    
    /**
     * Handle flight search
     */
 public void handleFlightScheduleSearch(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        
        String keyword = request.getParameter("search"); 
        String flightTypeRaw = request.getParameter("flightType"); // dropdown loại chuyến bay
        String departureTimeRange = request.getParameter("departureTimeRange"); // dropdown khung giờ khởi hành
        System.out.println("Time"+departureTimeRange);

        // Xử lý loại chuyến bay
        String flightType = null;
        if ("Một chiều".equals(flightTypeRaw)) {
            flightType = "Một chiều";
        } else if ("Khứ hồi".equals(flightTypeRaw)) {
            flightType = "Khứ hồi";
        }

   if (departureTimeRange != null && !departureTimeRange.isEmpty()) {
    // Giải mã nếu còn dạng URL encoded
    departureTimeRange = java.net.URLDecoder.decode(departureTimeRange, java.nio.charset.StandardCharsets.UTF_8);
    departureTimeRange = departureTimeRange.trim();

    // Cho phép khoảng trắng linh hoạt
    if (!departureTimeRange.matches("\\s*\\d{1,2}:\\d{2}\\s*-\\s*\\d{1,2}:\\d{2}\\s*")) {
        request.setAttribute("errorMessage", "Định dạng khung giờ không hợp lệ, bỏ qua filter.");
        departureTimeRange = null;
    }
}
    
   
        List<FlightSchedule> flightSchedules = serviceDao.searchFlightSchedules(keyword,  flightType, departureTimeRange);

       
        request.setAttribute("flightSchedules", flightSchedules);
        request.setAttribute("keyword", keyword);
       request.setAttribute("flightType", flightTypeRaw != null ? flightTypeRaw : "");
        request.setAttribute("departureTimeRange", departureTimeRange);

    
        request.getRequestDispatcher("/views/staff/flight_schedule-list.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "Lỗi khi tìm lịch bay: " + e.getMessage());
        request.setAttribute("exception", e);
        request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
    }
}
   

    /**
     * Handle create flight
     */
    private void  handleCreateFlightSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input (nếu !false thì xử lý bên trong)
            if (!validateFlightScheduleInput(request)) {
                  List<Flight> flights = serviceDao.getFlightsWithoutSchedule();
                  request.setAttribute("flights", flights);
                request.setAttribute("pageTitle", "Create New FlightSchedule");
                request.setAttribute(   "errorMessage", "Failed to create flightSchedule. Please try again.");
                request.getRequestDispatcher("/views/staff/flight_schedule-form.jsp").forward(request, response);
                return;
            }

            // Create flight object
            FlightSchedule schedule = createFlightScheduleFromRequest(request);// catch exeptions

            // Save flight
            int newFlightScheduleId = serviceDao.createFlightSchedule(schedule);

            if (newFlightScheduleId> 0) {

                response.sendRedirect(request.getContextPath() + "/staff/flight/schedules?action=list&success=created&scheduleId=" + newFlightScheduleId);
            } else {
                request.setAttribute("errorMessage", "Failed to create flight. Please try again.");
                List<Flight> flights = serviceDao.getFlightsWithoutSchedule();
                request.setAttribute("flights", flights);
                request.setAttribute("pageTitle", "Create New Flight");
                request.getRequestDispatcher("/views/staff/flight_schedule-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            handleError(request, response, "Error creating flight: " + e.getMessage(), e);
        }
    }
    
    
    
    /**
     * Create flight object from request parameters
     */

    private FlightSchedule createFlightScheduleFromRequest(HttpServletRequest request) throws IOException, ServletException, SQLException {
        FlightSchedule schedule = new FlightSchedule();
 //   Nếu có scheduleId (tức là đang UPDATE) 
    String scheduleIdStr = request.getParameter("scheduleId");
    if (scheduleIdStr != null && !scheduleIdStr.trim().isEmpty()) {
        schedule.setScheduleId(Integer.parseInt(scheduleIdStr));
    }

    //  Chỉ khi CREATE mới cần flightId 
    String flightIdStr = request.getParameter("flightId");
    if ((scheduleIdStr == null || scheduleIdStr.isEmpty()) && flightIdStr != null && !flightIdStr.trim().isEmpty()) {
        int flightId = Integer.parseInt(flightIdStr);
        Flight flight = serviceDao.getFlightById(flightId);
        schedule.setFlight(flight);
    }
        
        // Notes
        String notes = request.getParameter("notes");
        schedule.setNotes(notes != null ? notes.trim() : "");

        // Airports
        schedule.setDepartureAirport(request.getParameter("departureAirport"));
        schedule.setArrivalAirport(request.getParameter("arrivalAirport"));

        // Times - convert sang LocalTime
        String depTimeStr = request.getParameter("departureTime");
        if (depTimeStr != null && !depTimeStr.isEmpty()) {
            schedule.setDepartureTime(LocalTime.parse(depTimeStr));
        }

        String arrTimeStr = request.getParameter("arrivalTime");
        if (arrTimeStr != null && !arrTimeStr.isEmpty()) {
            schedule.setArrivalTime(LocalTime.parse(arrTimeStr));
        }

        // nếu flightType là khứ hồi
        String flightType = request.getParameter("flightType");
        if ("Khứ hồi".equalsIgnoreCase(flightType)) {
            String retDepTimeStr = request.getParameter("returnDepartureTime");
            if (retDepTimeStr != null && !retDepTimeStr.isEmpty()) {
                schedule.setReturnDepartureTime(LocalTime.parse(retDepTimeStr));
            }

            String retArrTimeStr = request.getParameter("returnArrivalTime");
            if (retArrTimeStr != null && !retArrTimeStr.isEmpty()) {
                schedule.setReturnArrivalTime(LocalTime.parse(retArrTimeStr));
            }
        }

        // Transit info (không bắt buộc)
        String transitAirport = request.getParameter("transitAirport");
        String transitDuration = request.getParameter("transitDuration");
        if (transitAirport != null && !transitAirport.trim().isEmpty()) {
            schedule.setTransitAirport(transitAirport);
            if (transitDuration != null && !transitDuration.trim().isEmpty()) {
                schedule.setTransitDuration(transitDuration.trim());
            }
        }

        return schedule;
    }

    /**
     * Validate flightSchedule input
     *
     *
     */
    private boolean validateFlightScheduleInput(HttpServletRequest request) {
        boolean isValid = true;

        // Lấy các giá trị từ form
        String flightIdStr = request.getParameter("flightId");
        String action = request.getParameter("action");
        String notes = request.getParameter("notes");
        String departureAirport = request.getParameter("departureAirport");
        String arrivalAirport = request.getParameter("arrivalAirport");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        String returnDepartureTime = request.getParameter("returnDepartureTime");
        String returnArrivalTime = request.getParameter("returnArrivalTime");
        String transitAirport = request.getParameter("transitAirport");
        String transitDuration = request.getParameter("transitDuration");

        // --- Validate flightId ---
       if ("create".equalsIgnoreCase(action)) {
        if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
            request.setAttribute("errorFlightId", "Vui lòng chọn mã định danh chuyến bay");
            isValid = false;
        } else {
            try {
                Integer.parseInt(flightIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorFlightId", "Mã định danh chuyến bay không hợp lệ");
                isValid = false;
            }
        }
    }

        // --- Validate notes ---
        if (notes == null || notes.trim().isEmpty()) {
            request.setAttribute("errorNotes", "Vui lòng nhập ghi chú");
            isValid = false;
        } else if (notes.trim().length() < 5) {
            request.setAttribute("errorNotes", "Ghi chú phải dài ít nhất 5 ký tự");
            isValid = false;
        } else if (!notes.matches("^[a-zA-ZÀ-ỹ0-9\\s,\\.\\-()!?]+$")) {
            request.setAttribute("errorNotes", "Ghi chú chỉ được chứa chữ, số và dấu câu thông thường");
            isValid = false;
        }

        // --- Validate departureAirport & arrivalAirport ---
        if (departureAirport == null || departureAirport.trim().isEmpty()) {
            request.setAttribute("errorDepartureAirport", "Vui lòng chọn sân bay khởi hành");
            isValid = false;
        }

        if (arrivalAirport == null || arrivalAirport.trim().isEmpty()) {
            request.setAttribute("errorArrivalAirport", "Vui lòng chọn sân bay hạ cánh");
            isValid = false;
        }

        // --- Validate departureTime & arrivalTime ---
        if (departureTime == null || departureTime.trim().isEmpty()) {
            request.setAttribute("errorDepartureTime", "Vui lòng chọn giờ khởi hành");
            isValid = false;
        }

        if (arrivalTime == null || arrivalTime.trim().isEmpty()) {
            request.setAttribute("errorArrivalTime", "Vui lòng chọn giờ hạ cánh");
            isValid = false;
        }
        

        // --- Kiểm tra chuyến khứ hồi ---
        String flightType = request.getParameter("flightType");
        if ("Khứ hồi".equalsIgnoreCase(flightType)) {
            if (returnDepartureTime == null || returnDepartureTime.trim().isEmpty()) {
                request.setAttribute("errorReturnDepartureTime", "Vui lòng nhập giờ khởi hành chuyến về");
                isValid = false;
            }
            if (returnArrivalTime == null || returnArrivalTime.trim().isEmpty()) {
                request.setAttribute("errorReturnArrivalTime", "Vui lòng nhập giờ hạ cánh chuyến về");
                isValid = false;
            }   
        }

        // --- Validate transit airport & duration ---

        if (transitAirport != null && !transitAirport.trim().isEmpty()) {
    if (transitDuration == null || transitDuration.trim().isEmpty()) {
        request.setAttribute("errorTransitDuration", "Vui lòng nhập thời gian quá cảnh");
        isValid = false;
    } else if (!transitDuration.trim().matches(
           "^(\\d+[hH](\\d{1,2})?\\s*(phút|m)?|\\d+\\s*(phút|m))$" )) {
        request.setAttribute("errorTransitDuration",
                "Thời gian quá cảnh phải theo định dạng 1h, 1h20, 1h45 phút, 45 phút, 30m, ...");
        isValid = false;
    }
}
        
        // Nếu transitDuration nhập mà transitAirport trống
        if ((transitDuration != null && !transitDuration.trim().isEmpty())
                && (transitAirport == null || transitAirport.trim().isEmpty())) {
            request.setAttribute("errorTransitAirport", "Vui lòng chọn sân bay quá cảnh");
            isValid = false;
        }

        return isValid;
    }


    /**
     * Handle update flightSchedule
    
     */
    private void handleUpdateFlightSchedule(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Nếu validate fail
         if (!validateFlightScheduleInput(request)) {
                String scheduleIdStr = request.getParameter("scheduleId");
                if (scheduleIdStr!= null) {
                    FlightSchedule schedule = serviceDao.getFlightScheduleById(Integer.parseInt(scheduleIdStr));
                    request.setAttribute("schedule", schedule);
                }
                request.setAttribute("pageTitle", "Edit Flight");
                request.getRequestDispatcher("/views/staff/flight_schedule-form.jsp").forward(request, response);
                return;
            }

        // Tạo đối tượng từ form
        FlightSchedule schedule = createFlightScheduleFromRequest(request);

        // Gọi DAO cập nhật
        int updatedId = serviceDao.updateFlightSchedule(schedule);
       
        
        if (updatedId > 0) {
            // Redirect về danh sách
            response.sendRedirect(request.getContextPath()
                + "/staff/flight/schedules?action=list&success=updated&scheduleId=" + updatedId);
        } else {
            //  Update thất bại
            request.setAttribute("errorMessage", "Không thể cập nhật lịch trình. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/staff/flight_schedule-form.jsp").forward(request, response);
        }

    } catch (Exception e) {
        handleError(request, response, "Error updating flight: " + e.getMessage(), e);
    }
    
    }
  
    /**
     * Handle delete flight
     */
    private void handleDeleteFlightSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String scheduleIdStr = request.getParameter("scheduleId");
            String flightIdStr = request.getParameter("flightId");
            
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty() || flightIdStr == null || flightIdStr.trim().isEmpty())  {
                response.sendRedirect(request.getContextPath() + "/staff/flights?error=invalid_id");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            int flightId = Integer.parseInt(flightIdStr);
   
             // Delete flight
           int deleteScheduleId = serviceDao.deleteFlightSchedule(scheduleId , flightId);

            if (deleteScheduleId > 0) {

                response.sendRedirect(request.getContextPath() + "/staff/flight/schedules?action=list&success=deleted&scheduleId=" + deleteScheduleId);
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
    if (e != null) e.printStackTrace();

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
        return "Short description";
    }// </editor-fold>

}
