package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Bill;

import model.Booking;
import model.HistoryBooking;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Payment;
import utils.DBContext;

public class BookingDao extends DBContext {

    /**
     * Tạo mới một booking (cho phép tourId hoặc customTourId)
     */
     public static BookingDao INSTANCE = new BookingDao();
    public int createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (customerId, tourId, customTourId, departureDate, endDate, adultQuantity, childQuantity, status, totalPrice) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerId());

            // Cho phép tourId hoặc customTourId (tùy loại tour)
            if (booking.getTourId() != null) {
                ps.setInt(2, booking.getTourId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            if (booking.getCustomTourId() != null) {
                ps.setInt(3, booking.getCustomTourId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }

            ps.setDate(4, new java.sql.Date(booking.getDepartureDate().getTime()));

            if (booking.getEndDate() != null) {
                ps.setDate(5, new java.sql.Date(booking.getEndDate().getTime()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            ps.setInt(6, booking.getAdultQuantity());
            ps.setInt(7, booking.getChildQuantity());
            ps.setString(8, booking.getStatus());
            ps.setDouble(9, booking.getTotalPrice());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("❌ Tạo booking thất bại.");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int bookingId = rs.getInt(1);
                    booking.setBookingId(bookingId);
                    return bookingId;
                } else {
                    throw new SQLException("❌ Tạo booking thất bại — không lấy được ID vừa tạo.");
                }
            }
        }
    }

    //Tao thanh toan cho booking
    public int createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payments (bookingId, amount, status) OUTPUT INSERTED.paymentId VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getStatus());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int paymentId = rs.getInt(1);
                //payment.setPaymentId(paymentId);
                return paymentId;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }

    /**
     * Get all bookings with customer and tour information for staff view
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = """
            SELECT 
                b.bookingId, b.customerId, b.tourId, b.customTourId,
                b.totalPrice, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
                b.status, b.bookingDate,
                u.fullName as customerName,
                t.tourName,
                ct.tourName as customTourName
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            ORDER BY b.bookingDate DESC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get booking by ID with detailed information
     */
    public Booking getBookingById(int bookingId) {
        String sql = """
            SELECT 
                b.bookingId, b.customerId, b.tourId, b.customTourId,
                b.totalPrice, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
                b.status, b.bookingDate,
                u.fullName as customerName, u.email, u.phone,
                t.tourName, t.description as tourDescription,
                ct.tourName as customTourName, NULL as customTourDescription
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            WHERE b.bookingId = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Search bookings by various criteria
     */
    public List<Booking> searchBookings(String customerName, String status, String dateFrom, String dateTo) {
        List<Booking> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT 
                b.bookingId, b.customerId, b.tourId, b.customTourId,
                b.totalPrice, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
                b.status, b.bookingDate,
                u.fullName as customerName,
                t.tourName,
                ct.tourName as customTourName
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            WHERE 1=1
            """);

        List<Object> parameters = new ArrayList<>();

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND u.fullName LIKE ?");
            parameters.add("%" + customerName.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND b.status = ?");
            parameters.add(status);
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND b.bookingDate >= ?");
            parameters.add(dateFrom);
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND b.bookingDate <= ?");
            parameters.add(dateTo + " 23:59:59");
        }

        sql.append(" ORDER BY b.bookingDate DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Update booking status
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET status = ? WHERE bookingId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get booking statistics for dashboard
     */
    public int getBookingCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE status = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Helper method to map ResultSet to Booking object
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("bookingId"));
        //booking.setProfileId(rs.getInt("profileId"));
        booking.setCustomerId(rs.getInt("customerId"));
        booking.setTourId(rs.getInt("tourId"));
        booking.setCustomTourId(rs.getInt("customTourId"));
        //booking.setPrice(rs.getInt("price"));
        booking.setDepartureDate(rs.getDate("departureDate"));
        booking.setEndDate(rs.getDate("endDate"));
        booking.setAdultQuantity(rs.getInt("adultQuantity"));
        booking.setChildQuantity(rs.getInt("childQuantity"));
        booking.setStatus(rs.getString("status"));
        booking.setBookingDate(rs.getTimestamp("bookingDate"));
        booking.setCustomerName(rs.getString("customerName"));
        booking.setTourName(rs.getString("tourName"));
        booking.setCustomTourName(rs.getString("customTourName"));

        return booking;
    }

    public void updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE Bookings SET status=? WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi cập nhật trạng thái bookingId = " + bookingId, e);
        }
    }

    public void createHistoryBooking(HistoryBooking hb) throws SQLException {
        String sql = "INSERT INTO HistoryBooking (paymentId, accountUserId, customerName, "
                + "customerEmail, customerPhone, tourStatus, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, hb.getPaymentId());

            if (hb.getAccountUserId() != null) {
                ps.setInt(2, hb.getAccountUserId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            ps.setString(3, hb.getCustomerName());
            ps.setString(4, hb.getCustomerEmail());
            ps.setString(5, hb.getCustomerPhone());
            ps.setString(6, hb.getTourStatus());
            ps.setTimestamp(7, hb.getCreatedAt());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new SQLException("Lỗi khi thêm lịch sử paymentId = " + hb.getPaymentId(), e);
        }
    }

    public Bill getBillByHistoryBooking(int paymentId) throws SQLException {
        String sql = "SELECT [hb].[paymentId], [hb].[customerName], [hb].[customerPhone], [hb].[createdAt], "
                + "COALESCE([t].[tourName], [ct].[tourName]) AS tourNamePayment, [p].[amount], [p].[status] AS paymentStatus "
                + "FROM [HistoryBooking] hb "
                + "JOIN [Payments] p ON [hb].[paymentId] = [p].[paymentId] "
                + "JOIN [Bookings] b ON [p].[bookingId] = [b].[bookingId] "
                + "LEFT JOIN [Tours] t ON [b].[tourId] = [t].[tourId] "
                + "LEFT JOIN [CustomTours] ct ON [b].[customTourId] = [ct].[customTourId] "
                + "WHERE [hb].[paymentId] = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bill bill = new Bill();
                    bill.setPaymentId(rs.getInt("paymentId"));
                    bill.setFullname(rs.getString("customerName"));
                    bill.setPhone(rs.getString("customerPhone"));
                    bill.setCreatedAt(rs.getTimestamp("createdAt"));
                    bill.setTourName(rs.getString("tourNamePayment"));
                    bill.setAmount(rs.getLong("amount"));
                    bill.setStatus(rs.getString("paymentStatus"));
                    return bill;
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy thông tin bill paymentId = " + paymentId, e);
        }
        return null;
    }

    //  Test thử
    public static void main(String[] args) {
//        BookingDao bookingDao = new BookingDao();
//
//        Booking booking = new Booking();
//        booking.setCustomerId(5);   // userId tồn tại
//        booking.setTourId(2);       // ví dụ: tour có sẵn
//        // booking.setCustomTourId(1); // nếu là tour tùy chỉnh thì gán cái này thay vì tourId
//
//        try {
//            Date departureDate = new SimpleDateFormat("yyyy-MM-dd").parse("2025-11-05");
//            booking.setDepartureDate(departureDate);
//        } catch (ParseException e) {
//            e.printStackTrace();
//        }
//
//        booking.setAdultQuantity(2);
//        booking.setChildQuantity(1);
//        booking.setTotalPrice(2500000);
//        booking.setStatus("PENDING");
//
//        try {
//            int id = bookingDao.createBooking(booking);
//            System.out.println("✅ Tạo booking thành công. Booking ID: " + id);
//        } catch (SQLException e) {
//            e.printStackTrace();
//            System.out.println("❌ Tạo booking thất bại: " + e.getMessage());
//        }
        try {
            BookingDao bd = new BookingDao();
            Bill b = bd.getBillByHistoryBooking(29);

            if (b != null) {
                System.out.println("=== HÓA ĐƠN ===");
                System.out.println(b.toString());
            } else {
                System.out.println("Không tìm thấy bill với paymentId = 29");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}