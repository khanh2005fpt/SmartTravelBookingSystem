package dao;

import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDetailDAO extends DBContext {

    public static class BookingDetailItem {

        private int bookingDetailId;
        private int bookingId;
        private Integer tourId, hotelId, flightId, vehicleId;
        private int adultQuantity, childQuantity;
        private Date departureDate;
        private int unitPrice;
        private double totalPrice;
        private String serviceName;

        // getters/setters
        public int getBookingDetailId() {
            return bookingDetailId;
        }

        public void setBookingDetailId(int bookingDetailId) {
            this.bookingDetailId = bookingDetailId;
        }

        public int getBookingId() {
            return bookingId;
        }

        public void setBookingId(int bookingId) {
            this.bookingId = bookingId;
        }

        public Integer getTourId() {
            return tourId;
        }

        public void setTourId(Integer tourId) {
            this.tourId = tourId;
        }

        public Integer getHotelId() {
            return hotelId;
        }

        public void setHotelId(Integer hotelId) {
            this.hotelId = hotelId;
        }

        public Integer getFlightId() {
            return flightId;
        }

        public void setFlightId(Integer flightId) {
            this.flightId = flightId;
        }

        public Integer getVehicleId() {
            return vehicleId;
        }

        public void setVehicleId(Integer vehicleId) {
            this.vehicleId = vehicleId;
        }

        public int getAdultQuantity() {
            return adultQuantity;
        }

        public void setAdultQuantity(int adultQuantity) {
            this.adultQuantity = adultQuantity;
        }

        public int getChildQuantity() {
            return childQuantity;
        }

        public void setChildQuantity(int childQuantity) {
            this.childQuantity = childQuantity;
        }

        public Date getDepartureDate() {
            return departureDate;
        }

        public void setDepartureDate(Date departureDate) {
            this.departureDate = departureDate;
        }

        public int getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(int unitPrice) {
            this.unitPrice = unitPrice;
        }

        public double getTotalPrice() {
            return totalPrice;
        }

        public void setTotalPrice(double totalPrice) {
            this.totalPrice = totalPrice;
        }

        public String getServiceName() {
            return serviceName;
        }

        public void setServiceName(String serviceName) {
            this.serviceName = serviceName;
        }
    }

    public List<BookingDetailItem> getDetailsByBookingId(int bookingId) throws SQLException {
        String sql
                = "SELECT d.*, "
                + "       COALESCE(h.hotelName, f.flightNumber, v.modelName, t.tourName) AS serviceName "
                + "FROM BookingDetails d "
                + "LEFT JOIN Hotels h ON d.hotelId = h.hotelId "
                + "LEFT JOIN Flights f ON d.flightId = f.flightId "
                + "LEFT JOIN IslandVehicles v ON d.vehicleId = v.vehicleId "
                + "LEFT JOIN Tours t ON d.tourId = t.tourId "
                + "WHERE d.bookingId = ?";

        List<BookingDetailItem> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingDetailItem it = new BookingDetailItem();
                it.setBookingDetailId(rs.getInt("bookingDetailId"));
                it.setBookingId(rs.getInt("bookingId"));
                it.setAdultQuantity(rs.getInt("adultQuantity"));
                it.setChildQuantity(rs.getInt("childQuantity"));
                it.setDepartureDate(rs.getDate("departureDate"));
                it.setUnitPrice(rs.getInt("unitPrice"));
                it.setTotalPrice(rs.getDouble("totalPrice"));
                it.setServiceName(rs.getString("serviceName"));
                list.add(it);
            }
        }
        return list;
    }
}
