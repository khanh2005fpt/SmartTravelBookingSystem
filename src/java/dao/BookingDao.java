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
import model.Payment;
import utils.DBContext;

public class BookingDao extends DBContext {

    /**
     * Tạo mới một booking (cho phép tourId hoặc customTourId)
     */
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
                payment.setPaymentId(paymentId);
                return paymentId;
            }
        }
        return 0;
    }

    //Cap nhap trang thai booking
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
                + "[t].[tourName], [p].[amount], [p].[status] AS paymentStatus "
                + "FROM [HistoryBooking] hb "
                + "JOIN [Payments] p ON [hb].[paymentId] = [p].[paymentId] "
                + "JOIN [Bookings] b ON [p].[bookingId] = [b].[bookingId] "
                + "LEFT JOIN [Tours] t ON [b].[tourId] = [t].[tourId] "
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
                    bill.setTourName(rs.getString("tourName"));
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
