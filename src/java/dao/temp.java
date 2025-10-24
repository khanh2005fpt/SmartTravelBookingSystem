package dao;

import utils.DBContext;
import model.BookingStatus;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBContext {

    public static final int PAGE_SIZE = 10;

    // DTO hiển thị danh sách Booking
    public static class BookingListItem {

        private int bookingId;
        private String profileName;
        private String customerName;
        private Integer price;
        private BookingStatus status;
        private LocalDateTime bookingDate;
        private java.math.BigDecimal totalAmount;
        private String services;

        public int getBookingId() {
            return bookingId;
        }

        public void setBookingId(int bookingId) {
            this.bookingId = bookingId;
        }

        public String getProfileName() {
            return profileName;
        }

        public void setProfileName(String profileName) {
            this.profileName = profileName;
        }

        public String getCustomerName() {
            return customerName;
        }

        public void setCustomerName(String customerName) {
            this.customerName = customerName;
        }

        public Integer getPrice() {
            return price;
        }

        public void setPrice(Integer price) {
            this.price = price;
        }

        public BookingStatus getStatus() {
            return status;
        }

        public void setStatus(BookingStatus status) {
            this.status = status;
        }

        public LocalDateTime getBookingDate() {
            return bookingDate;
        }

        public void setBookingDate(LocalDateTime bookingDate) {
            this.bookingDate = bookingDate;
        }

        public java.math.BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(java.math.BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }

        public String getServices() {
            return services;
        }

        public void setServices(String services) {
            this.services = services;
        }
    }

    /**
     * Lấy danh sách Booking có phân trang 10 item/trang. Hiển thị Profile Name
     * và Customer Name thay vì ID.
     */
    public List<BookingListItem> getAll(int page) throws SQLException {
        if (page < 1) {
            page = 1;
        }
        int offset = (page - 1) * PAGE_SIZE;

        String sql
                = "WITH agg AS ( \n"
                + "  SELECT b.bookingId, \n"
                + "         cp.profileId, \n"
                + "         cpUser.fullName AS profileName, \n"
                + "         u.fullName AS customerName, \n"
                + "         b.price, b.status, b.bookingDate, \n"
                + "         SUM(d.totalPrice) AS totalAmount, \n"
                + "         STRING_AGG(COALESCE(h.hotelName, f.flightNumber, v.modelName, t.tourName), ', ') AS services \n"
                + "  FROM Bookings b \n"
                + "  LEFT JOIN BookingDetails d ON d.bookingId = b.bookingId \n"
                + "  LEFT JOIN Hotels h ON d.hotelId = h.hotelId \n"
                + "  LEFT JOIN Flights f ON d.flightId = f.flightId \n"
                + "  LEFT JOIN IslandVehicles v ON d.vehicleId = v.vehicleId \n"
                + "  LEFT JOIN Tours t ON d.tourId = t.tourId \n"
                + "  LEFT JOIN CustomerProfiles cp ON b.profileId = cp.profileId \n"
                + "  LEFT JOIN Users cpUser ON cp.userId = cpUser.userId \n"
                + // Tên người thuộc profile
                "  LEFT JOIN Users u ON b.customerId = u.userId \n"
                + // Tên người đặt booking
                "  GROUP BY b.bookingId, cp.profileId, cpUser.fullName, u.fullName, b.price, b.status, b.bookingDate \n"
                + ") \n"
                + "SELECT bookingId, profileName, customerName, price, status, bookingDate, totalAmount, services \n"
                + "FROM agg \n"
                + "ORDER BY bookingDate DESC \n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";

        List<BookingListItem> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, PAGE_SIZE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();
                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(rs.getString("profileName"));
                    it.setCustomerName(rs.getString("customerName"));

                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);

                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services"));

                    list.add(it);
                }
            }
        }
        return list;
    }

    /**
     * Tổng số trang dựa theo PAGE_SIZE
     */
    public int getTotalPages() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            int total = 0;
            if (rs.next()) {
                total = rs.getInt(1);
            }
            return (total + PAGE_SIZE - 1) / PAGE_SIZE;
        }
    }

    public List<BookingListItem> searchByCustomerName(String keyword) throws SQLException {
        String sql
                = "WITH agg AS ( \n"
                + "  SELECT b.bookingId, cpUser.fullName AS profileName, u.fullName AS customerName, \n"
                + "         b.price, b.status, b.bookingDate, SUM(d.totalPrice) AS totalAmount, \n"
                + "         STRING_AGG(COALESCE(h.hotelName, f.flightNumber, v.modelName, t.tourName), ', ') AS services \n"
                + "  FROM Bookings b \n"
                + "  LEFT JOIN BookingDetails d ON d.bookingId = b.bookingId \n"
                + "  LEFT JOIN Hotels h ON d.hotelId = h.hotelId \n"
                + "  LEFT JOIN Flights f ON d.flightId = f.flightId \n"
                + "  LEFT JOIN IslandVehicles v ON d.vehicleId = v.vehicleId \n"
                + "  LEFT JOIN Tours t ON d.tourId = t.tourId \n"
                + "  LEFT JOIN CustomerProfiles cp ON b.profileId = cp.profileId \n"
                + "  LEFT JOIN Users cpUser ON cp.userId = cpUser.userId \n"
                + "  LEFT JOIN Users u ON b.customerId = u.userId \n"
                + "  GROUP BY b.bookingId, cpUser.fullName, u.fullName, b.price, b.status, b.bookingDate \n"
                + ") \n"
                + "SELECT * FROM agg WHERE customerName LIKE ? ORDER BY bookingDate DESC";

        List<BookingListItem> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();
                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(rs.getString("profileName"));
                    it.setCustomerName(rs.getString("customerName"));

                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);

                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services"));

                    list.add(it);
                }
            }
        }
        return list;
    }

    public List<BookingListItem> searchByStatus(String status) throws SQLException {
        String sql
                = "WITH agg AS ( \n"
                + "  SELECT b.bookingId, cpUser.fullName AS profileName, u.fullName AS customerName, \n"
                + "         b.price, b.status, b.bookingDate, SUM(d.totalPrice) AS totalAmount, \n"
                + "         STRING_AGG(COALESCE(h.hotelName, f.flightNumber, v.modelName, t.tourName), ', ') AS services \n"
                + "  FROM Bookings b \n"
                + "  LEFT JOIN BookingDetails d ON d.bookingId = b.bookingId \n"
                + "  LEFT JOIN Hotels h ON d.hotelId = h.hotelId \n"
                + "  LEFT JOIN Flights f ON d.flightId = f.flightId \n"
                + "  LEFT JOIN IslandVehicles v ON d.vehicleId = v.vehicleId \n"
                + "  LEFT JOIN Tours t ON d.tourId = t.tourId \n"
                + "  LEFT JOIN CustomerProfiles cp ON b.profileId = cp.profileId \n"
                + "  LEFT JOIN Users cpUser ON cp.userId = cpUser.userId \n"
                + "  LEFT JOIN Users u ON b.customerId = u.userId \n"
                + "  GROUP BY b.bookingId, cpUser.fullName, u.fullName, b.price, b.status, b.bookingDate \n"
                + ") \n"
                + "SELECT * FROM agg WHERE status = ? ORDER BY bookingDate DESC";

        List<BookingListItem> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();
                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(rs.getString("profileName"));
                    it.setCustomerName(rs.getString("customerName"));

                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);

                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services"));
                    list.add(it);
                }
            }
        }
        return list;
    }

}
