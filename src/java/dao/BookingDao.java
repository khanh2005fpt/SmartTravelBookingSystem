/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Date;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import model.Booking;
import model.Payment;


/**
 *
 * @author Admin
 */
public class BookingDao extends DBContext {

    public void createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (profileId, customerId, price, departureDate, adultQuantity, childQuantity, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1, booking.getProfileId());
            ps.setInt(2, booking.getCustomerId());
            ps.setInt(3, booking.getPrice());
            ps.setDate(4, new java.sql.Date(booking.getDepartureDate().getTime()));
            ps.setInt(5, booking.getAdultQuantity());
            ps.setInt(6, booking.getChildQuantity());
            ps.setString(7, booking.getStatus());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                booking.setBookingId(rs.getInt(1)); // Gán lại ID vừa được sinh
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    
    public void createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payments (bookingId, amount, status) "
                   + "VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi thêm Payment cho bookingId = " + payment.getBookingId(), e);
        }
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


}
