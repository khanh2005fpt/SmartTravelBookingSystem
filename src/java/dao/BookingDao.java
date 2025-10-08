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
import model.BookingDetail;

/**
 *
 * @author Admin
 */
public class BookingDao extends DBContext {

    public void createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (profileId, customerId, price, departureDate, adultQuantity, childQuantity, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
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

    public void createBookingDetail(BookingDetail detail) {
        String sql = "INSERT INTO BookingDetails (bookingId, tourId, hotelId, flightId, vehicleId, totalPrice) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, detail.getBookingId());
            if (detail.getTourId() != null) {
                ps.setInt(2, detail.getTourId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            if (detail.getHotelId() != null) {
                ps.setInt(3, detail.getHotelId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            if (detail.getFlightId() != null) {
                ps.setInt(4, detail.getFlightId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (detail.getVehicleId() != null) {
                ps.setInt(5, detail.getVehicleId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, detail.getTotalPrice());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
