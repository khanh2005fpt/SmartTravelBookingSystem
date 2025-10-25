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
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Payment;

/**
 *
 * @author Admin
 */
public class BookingDao extends DBContext {

    public static BookingDao INSTANCE = new BookingDao();

    public void createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (profileId, customerId, tourId, customTourId, price, departureDate, endDate, adultQuantity, childQuantity, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, booking.getProfileId());
            ps.setInt(2, booking.getCustomerId());
            ps.setInt(3, booking.getTourId());
            ps.setInt(4, booking.getCustomTourId());
            ps.setInt(5, booking.getPrice());
            ps.setDate(6, new java.sql.Date(booking.getDepartureDate().getTime()));
            ps.setDate(7, booking.getEndDate() != null ? new java.sql.Date(booking.getEndDate().getTime()) : null);
            ps.setInt(8, booking.getAdultQuantity());
            ps.setInt(9, booking.getChildQuantity());
            ps.setString(10, booking.getStatus());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int paymentId = rs.getInt(1);
                payment.setPaymentId(paymentId);
                return paymentId;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * Get all bookings with customer and tour information for staff view
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = """
            SELECT 
                b.bookingId, b.profileId, b.customerId, b.tourId, b.customTourId,
                b.price, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
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
                b.bookingId, b.profileId, b.customerId, b.tourId, b.customTourId,
                b.price, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
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
                b.bookingId, b.profileId, b.customerId, b.tourId, b.customTourId,
                b.price, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
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
        booking.setProfileId(rs.getInt("profileId"));
        booking.setCustomerId(rs.getInt("customerId"));
        booking.setTourId(rs.getInt("tourId"));
        booking.setCustomTourId(rs.getInt("customTourId"));
        booking.setPrice(rs.getInt("price"));
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
