/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.Date;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import model.Booking;
import model.Payment;

/**
 *
 * @author Admin
 */
public class BookingDao extends DBContext {

    public int createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (customerId, departureDate, adultQuantity, childQuantity, status) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setDate(2, new java.sql.Date(booking.getDepartureDate().getTime()));
            ps.setInt(3, booking.getAdultQuantity());
            ps.setInt(4, booking.getChildQuantity());
            ps.setString(5, booking.getStatus());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Tạo booking thất bại");
            }

            // Lấy bookingId vừa tạo
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int bookingId = rs.getInt(1);
                    booking.setBookingId(bookingId); // lưu vào object
                    return bookingId; // trả về bookingId
                } else {
                    throw new SQLException("Tạo booking thất bại, không lấy được ID.");
                }
            }
        }
    }

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

    public static void main(String[] args) {
        BookingDao bookingDao = new BookingDao();

        // Tạo đối tượng Booking mẫu
        Booking booking = new Booking();

        // **Quan trọng:** customerId phải tồn tại trong bảng Users
        booking.setCustomerId(5); // Giả sử userId 1 có trong Users
        try {
            // Chuyển đổi string thành java.util.Date
            Date departureDate = new SimpleDateFormat("yyyy-MM-dd").parse("2025-10-25");
            booking.setDepartureDate(departureDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        booking.setAdultQuantity(2);
        booking.setChildQuantity(1);
        booking.setStatus("PENDING");

        try {
            bookingDao.createBooking(booking);
            System.out.println("Tạo booking thành công. Booking ID: " + booking.getBookingId());
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Tạo booking thất bại: " + e.getMessage());
        }
    }
}
