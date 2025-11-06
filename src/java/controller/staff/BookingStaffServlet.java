/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.BookingDao;
import model.Booking;
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
 * Servlet for managing booking operations for staff members
 * Handles booking list display, detail view, search, and status updates
 * 
 * @author Admin
 */
@WebServlet(name = "BookingStaffServlet", urlPatterns = {"/staff/bookings"})
public class BookingStaffServlet extends HttpServlet {
    
    private BookingDao bookingDao;
    
    @Override
    public void init() throws ServletException {
        try {
            bookingDao = BookingDao.INSTANCE;
            System.out.println("BookingDao initialized successfully in BookingStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing BookingDao in BookingStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize BookingDao", e);
        }
    }

    /**
     * Handles GET requests for booking list and detail views
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            
            if (action == null || action.equals("list")) {
                handleBookingList(request, response);
            } else if (action.equals("detail")) {
                handleBookingDetail(request, response);
            } else if (action.equals("search")) {
                handleBookingSearch(request, response);
            } else {
                response.sendError(400, "Invalid action parameter");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        }
    }

    /**
     * Handles POST requests for booking status updates
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            
            if (action != null && action.equals("updateStatus")) {
                handleStatusUpdate(request, response);
            } else {
                response.sendError(400, "Invalid action parameter");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi cập nhật trạng thái: " + e.getMessage());
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle booking list display
     */
    private void handleBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Booking> bookings = bookingDao.getAllBookings();

            // Filter: only tour bookings (package or custom) and statuses PENDING/CONFIRMED/COMPLETED
            List<Booking> tourBookings = new java.util.ArrayList<>();
            for (Booking b : bookings) {
                boolean hasTour = (b.getTourName() != null && !b.getTourName().trim().isEmpty())
                        || (b.getCustomTourName() != null && !b.getCustomTourName().trim().isEmpty());
                if (!hasTour) continue;
                String st = b.getStatus();
                if ("PENDING".equals(st) || "CONFIRMED".equals(st) || "COMPLETED".equals(st)) {
                    tourBookings.add(b);
                }
            }

            // Compute stats only for filtered tour bookings
            // Chưa hoàn thành = PENDING + CONFIRMED
            // Đã hoàn thành = COMPLETED
            int incompleteCount = 0;
            int completedCount = 0;
            for (Booking b : tourBookings) {
                String st = b.getStatus();
                if ("PENDING".equals(st) || "CONFIRMED".equals(st)) {
                    incompleteCount++;
                } else if ("COMPLETED".equals(st)) {
                    completedCount++;
                }
            }

            request.setAttribute("bookings", tourBookings);
            request.setAttribute("incompleteCount", incompleteCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("totalCount", tourBookings.size());
            
            request.getRequestDispatcher("/views/staff/booking-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải danh sách booking: " + e.getMessage());
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle booking detail display
     */
    private void handleBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String bookingIdStr = request.getParameter("id");
            
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendError(400, "Booking ID is required");
            return;
        }
            
            int bookingId;
            try {
                bookingId = Integer.parseInt(bookingIdStr);
            } catch (NumberFormatException e) {
                response.sendError(400, "Invalid booking ID format");
                return;
            }
            
            Booking booking = bookingDao.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendError(404, "Booking not found");
                return;
            }
            
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/views/staff/booking-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải chi tiết booking: " + e.getMessage());
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle booking search
     */
    private void handleBookingSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String customerName = request.getParameter("customerName");
            String status = request.getParameter("status");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            
            // Convert INCOMPLETE to PENDING,CONFIRMED for search
            String searchStatus = status;
            if ("INCOMPLETE".equals(status)) {
                // Search for both PENDING and CONFIRMED
                searchStatus = "PENDING,CONFIRMED";
            }
            
            List<Booking> bookings = bookingDao.searchBookings(customerName, searchStatus, dateFrom, dateTo);

            // Filter: only tour bookings (package or custom) and allowed statuses
            List<Booking> tourBookings = new java.util.ArrayList<>();
            for (Booking b : bookings) {
                boolean hasTour = (b.getTourName() != null && !b.getTourName().trim().isEmpty())
                        || (b.getCustomTourName() != null && !b.getCustomTourName().trim().isEmpty());
                if (!hasTour) continue;
                String st = b.getStatus();
                if ("PENDING".equals(st) || "CONFIRMED".equals(st) || "COMPLETED".equals(st)) {
                    // If filtering by INCOMPLETE, only include PENDING and CONFIRMED
                    if ("INCOMPLETE".equals(status) && "COMPLETED".equals(st)) {
                        continue;
                    }
                    // If filtering by COMPLETED, only include COMPLETED
                    if ("COMPLETED".equals(status) && !"COMPLETED".equals(st)) {
                        continue;
                    }
                    tourBookings.add(b);
                }
            }

            // Stats based on filtered result
            // Chưa hoàn thành = PENDING + CONFIRMED
            // Đã hoàn thành = COMPLETED
            int incompleteCount = 0;
            int completedCount = 0;
            for (Booking b : tourBookings) {
                String st = b.getStatus();
                if ("PENDING".equals(st) || "CONFIRMED".equals(st)) {
                    incompleteCount++;
                } else if ("COMPLETED".equals(st)) {
                    completedCount++;
                }
            }

            request.setAttribute("bookings", tourBookings);
            request.setAttribute("incompleteCount", incompleteCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("totalCount", tourBookings.size());
            
            // Preserve search parameters
            request.setAttribute("searchCustomerName", customerName);
            request.setAttribute("searchStatus", status);
            request.setAttribute("searchDateFrom", dateFrom);
            request.setAttribute("searchDateTo", dateTo);
            
            request.getRequestDispatcher("/views/staff/booking-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tìm kiếm booking: " + e.getMessage());
            request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle booking status update
     */
    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String bookingIdStr = request.getParameter("bookingId");
            String newStatus = request.getParameter("status");
            
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendError(400, "Booking ID is required");
            return;
        }
        
        if (newStatus == null || newStatus.trim().isEmpty()) {
            response.sendError(400, "Status is required");
            return;
        }
            
            // Validate status values
            if (!isValidStatus(newStatus)) {
                response.sendError(400, "Invalid status value");
                return;
            }
            
            int bookingId;
            try {
                bookingId = Integer.parseInt(bookingIdStr);
            } catch (NumberFormatException e) {
                response.sendError(400, "Invalid booking ID format");
                return;
            }
            
            boolean success = bookingDao.updateBookingStatus(bookingId, newStatus);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật trạng thái booking thành công!");
                response.sendRedirect(request.getContextPath() + "/staff/bookings?action=detail&id=" + bookingId);
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật trạng thái booking");
                request.getRequestDispatcher("/views/staff/error.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi cập nhật trạng thái: " + e.getMessage());
            request.getRequestDispatcher("/staff/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Validate booking status values
     */
    private boolean isValidStatus(String status) {
        return status.equals("PENDING") || status.equals("CONFIRMED") || 
               status.equals("CANCELLED") || status.equals("COMPLETED");
    }
    
    public String getServletInfo() {
        return "BookingStaffServlet handles booking management for staff";
    }
}