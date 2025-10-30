/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.services;

import dao.IslandDao;
import dao.TourDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import model.CustomTour;
import model.CustomTourDetail;
import model.Hotel;
import model.Island;
import model.IslandVehicle;
import model.Tour;

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
            TourDao dao = new TourDao();
            IslandDao islandDao = new IslandDao();

            // Lấy dữ liệu từ form
            String islandIdStr = request.getParameter("islandId");
            String hotelIdStr = request.getParameter("selectedHotelId");
            String flightIdStr = request.getParameter("selectedFlightId");
            String vehicleIdStr = request.getParameter("selectedVehicleId"); // tùy chọn
            String selectedPlaces = request.getParameter("selectedPlaceId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            int id = Integer.parseInt(islandIdStr);

            // Kiểm tra các tham số bắt buộc
            if (islandIdStr == null || hotelIdStr == null || startDateStr == null || endDateStr == null) {
                throw new ServletException("Thiếu tham số yêu cầu để tạo tour.");
            }

            // Bat buoc muon tao tour phai chon khach san va chuyen bay
            if (hotelIdStr == null || hotelIdStr.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Bắt buộc phải chọn những dịch vụ.");
                response.sendRedirect("IslandDetailController?detailId=" + id);
                return;
            }
            if (flightIdStr == null || flightIdStr.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Bắt buộc phải chọn những dịch vụ.");
                response.sendRedirect("IslandDetailController?detailId=" + id);
                return;
            }

            int islandId = Integer.parseInt(islandIdStr);
            int hotelId = Integer.parseInt(hotelIdStr);
            int flightId = Integer.parseInt(flightIdStr);

            // Vehicle tùy chọn
            Integer vehicleId = null;
            if (vehicleIdStr != null && !vehicleIdStr.isEmpty()) {
                vehicleId = Integer.parseInt(vehicleIdStr);
            }

            List<Integer> pids = new ArrayList<>();
            int placePrice = 0;
            Integer placeId = null;
            if (selectedPlaces != null && !selectedPlaces.isEmpty()) {
                String[] placeIds = selectedPlaces.split(",");
                for (String pid : placeIds) {
                    placeId = Integer.parseInt(pid.trim());
                    pids.add(placeId);
                    int pPrice = dao.getServicePrice("Địa điểm nổi bật", placeId);
                    placePrice += pPrice;
                }
            }

            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);

            LocalDate today = LocalDate.now();
            if (startDate.isBefore(today)) {
                request.getSession().setAttribute("errorMessage", "Ngày bắt đầu không thể trước ngày hiện tại.");
                response.sendRedirect("IslandDetailController?detailId=" + id);
                return;
            }

            if (startDate.isBefore(today.plusDays(3))) {
                request.getSession().setAttribute("errorMessage", "Ngày bắt đầu phải sau ít nhất 3 ngày kể từ hôm nay.");
                response.sendRedirect("IslandDetailController?detailId=" + id);
                return;
            }

            if (endDate.isBefore(startDate)) {
                request.getSession().setAttribute("errorMessage", "Ngày kết thúc không thể trước ngày bắt đầu.");
                response.sendRedirect("IslandDetailController?detailId=" + id);
                return;
            }

            int numberOfDays = (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;

            if (numberOfDays > 7) {
                request.getSession().setAttribute("errorMessage", "Người dùng không được đặt thời gian quá 7 ngày.");
                response.sendRedirect("IslandDetailController?detailId=" + id);
                return;
            }
            // Lấy giá dịch vụ
            int hotelPrice = dao.getServicePrice("Khách sạn", hotelId);
            int ticketFlightPrice = dao.getServicePrice("Chuyến bay", flightId);
            int vehiclePrice = 0;
            if (vehicleId != null) {
                vehiclePrice = dao.getServicePrice("Phương tiện", vehicleId);
            }

            long days = ChronoUnit.DAYS.between(startDate, endDate) + 1;
            long nights = days - 1;
            int totalPrice = (int) ((hotelPrice) * (days)) + vehiclePrice + placePrice;

            // Tạo tên tour
            String islandName = islandDao.getIslandNameById(islandId);
            String tourName = "Du lịch " + islandName + " - " + days + "N" + nights + "Đ";

            // Tạo tour
            CustomTour tour = new CustomTour(tourName, islandId, startDate, endDate, totalPrice);
            int customTourId = dao.createCustomTour(tour);
//            if (customTourId <= 0) {
//                throw new ServletException("Tạo tour thất bại: không có ID tour trả về.");
//            }

            // Lưu chi tiết dịch vụ
            dao.createCustomTourDetail(new CustomTourDetail(customTourId, "Khách sạn", hotelId, hotelPrice));
            dao.createCustomTourDetail(new CustomTourDetail(customTourId, "Chuyến bay", flightId, ticketFlightPrice));
            if (vehicleId != null) {
                dao.createCustomTourDetail(new CustomTourDetail(customTourId, "Phương tiện", vehicleId, vehiclePrice));
            }

            for (int pId : pids) {
                int pPrice = dao.getServicePrice("Địa điểm nổi bật", pId);
                dao.createCustomTourDetail(new CustomTourDetail(customTourId, "Địa điểm nổi bật", pId, pPrice));
            }

            // Tạo lịch trình mẫu
            dao.createSampleItinerary(customTourId, startDate, endDate);

            // Lấy dữ liệu tour để hiển thị chi tiết
            CustomTour createdTour = dao.getTourById(customTourId);
            request.getSession().removeAttribute("errorMessage");
            request.setAttribute("tour", createdTour);
            request.setAttribute("details", dao.getTourDetails(customTourId));
            request.setAttribute("itinerary", dao.getTourItinerary(customTourId));

            // Forward sang JSP chi tiết tour
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
