/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.services;

import dao.CustomTourDao;
import dao.IslandDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import model.CustomTour;
import model.CustomTourDetail;

/**
 *
 * @author Admin
 */
public class CreateCustomTourController extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateCustomTourController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateCustomTourController at " + request.getContextPath() + "</h1>");
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
        try {
            CustomTourDao dao = new CustomTourDao();

            String islandIdStr = request.getParameter("islandId");
            String hotelIdStr = request.getParameter("selectedHotelId");
            String vehicleIdStr = request.getParameter("selectedVehicleId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");

            if (islandIdStr == null || hotelIdStr == null || vehicleIdStr == null || startDateStr == null || endDateStr == null) {
                throw new ServletException("Thiếu tham số yêu cầu để tạo tour");
            }

            int islandId = Integer.parseInt(islandIdStr);
            int hotelId = Integer.parseInt(hotelIdStr);
            int vehicleId = Integer.parseInt(vehicleIdStr);

            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);
            if (endDate.isBefore(startDate)) {
                throw new ServletException("Ngày kết thúc không thể trước ngày bắt đầu");
            }
            // Lấy giá của các dịch vụ
            int hotelPrice = dao.getServicePrice("Khách sạn", hotelId);
            int vehiclePrice = dao.getServicePrice("Phương tiện", vehicleId);

            
            long days = ChronoUnit.DAYS.between(startDate, endDate) + 1; // ví dụ 4 ngày
            long nights = days - 1; // 3 đêm
            int totalPrice = (int) ((hotelPrice + vehiclePrice) * days);
            IslandDao id = new IslandDao();
            String islandName = id.getIslandNameById(islandId);
            String tourName = "Du lịch " + islandName + " - " + days + "N" + nights + "Đ";

            CustomTour tour = new CustomTour(tourName, islandId, startDate, endDate, totalPrice);
            int customTourId = dao.createCustomTour(tour);
            if (customTourId <= 0) {
                throw new ServletException("Tạo tour thất bại: không có ID tour trả về");
            }

            // Lưu chi tiết dịch vụ
            dao.createCustomTourDetail(new CustomTourDetail(customTourId, "Khách sạn", hotelId, hotelPrice));
            dao.createCustomTourDetail(new CustomTourDetail(customTourId, "Phương tiện", vehicleId, vehiclePrice));

            // Tạo lịch trình mẫu
            dao.createSampleItinerary(customTourId, startDate, endDate);

            // Gửi tour sang trang chi tiết
            CustomTour createdTour = dao.getTourById(customTourId);
            request.setAttribute("tour", createdTour);
            request.setAttribute("details", dao.getTourDetails(customTourId));
            request.setAttribute("itinerary", dao.getTourItinerary(customTourId));

            request.getRequestDispatcher("/views/trip/custom_tour_detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage() != null ? e.getMessage() : "Có lỗi khi tạo tour.";
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
