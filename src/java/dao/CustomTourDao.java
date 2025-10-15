/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.CustomTour;
import model.CustomTourDetail;
import model.CustomTourItinerary;

/**
 *
 * @author Admin
 */
public class CustomTourDao extends DBContext {

    public int createCustomTour(CustomTour tour) throws SQLException {
        //sql tra ve ID vua moi insert
        String sql = "INSERT INTO CustomTours (islandId, tourName, startDate, endDate, totalPrice) OUTPUT INSERTED.customTourId VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tour.getIslandId());
            ps.setString(2, tour.getTourName());
            ps.setDate(3, java.sql.Date.valueOf(tour.getStartDate()));
            ps.setDate(4, java.sql.Date.valueOf(tour.getEndDate()));
            ps.setInt(5, tour.getTotalPrice());

            try {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            } catch (Exception e) {
                throw new SQLException("Creating custom tour failed: no tour ID returned");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<CustomTourItinerary> getListCustomTourItineriesById(int id) {
        List<CustomTourItinerary> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomTourItinerary WHERE customTourId = ? ORDER BY dayNumber";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CustomTourItinerary tourI = new CustomTourItinerary();
                tourI.setDayNumber(rs.getInt("dayNumber"));
                tourI.setActivity(rs.getString("activity"));
                tourI.setLocation(rs.getString("location"));
                tourI.setStartTime(rs.getTime("startTime"));
                tourI.setEndTime(rs.getTime("endTime"));

                list.add(tourI);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateTotalPrice(int customTourId, int totalPrice) {
        String sql = "UPDATE CustomTours SET totalPrice = ? WHERE customTourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, totalPrice);
            ps.setInt(2, customTourId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void createCustomTourDetail(CustomTourDetail detail) {
        String sql = "INSERT INTO CustomTourDetails (customTourId, serviceType, serviceId, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, detail.getCustomTourId());
            ps.setString(2, detail.getServiceType());
            ps.setInt(3, detail.getServiceId());
            ps.setInt(4, detail.getPrice());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void createSampleItinerary(int customTourId, LocalDate startDate, LocalDate endDate) throws SQLException {
        String sql = "INSERT INTO CustomTourItinerary " +
                     "(customTourId, dayNumber, activity, location, startTime, endTime) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        // Tính số ngày tour, bao gồm cả ngày bắt đầu và kết thúc
        int numberOfDays = (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
        if (numberOfDays <= 0) numberOfDays = 1;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int day = 1; day <= numberOfDays; day++) {
                ps.setInt(1, customTourId);
                ps.setInt(2, day);

                // Logic tạo hoạt động theo ngày
                String activity;
                if (day == 1) {
                    activity = "Check-in khách sạn và ổn định chỗ ở";
                } else if (day == numberOfDays) {
                    activity = "Check-out khách sạn và kết thúc tour";
                } else {
                    activity = "Tham quan và trải nghiệm đảo";
                }

                ps.setString(3, activity);
                ps.setString(4, "Địa điểm nổi bật ngày " + day);

                // Giờ hoạt động mẫu: 08:00 - 17:00
                ps.setTime(5, Time.valueOf("08:00:00"));
                ps.setTime(6, Time.valueOf("17:00:00"));

                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public CustomTour getTourById(int tourId) throws SQLException {
        String sql = "SELECT * FROM CustomTours WHERE customTourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CustomTour tour = new CustomTour(
                        rs.getString("tourName"),
                        rs.getInt("islandId"),
                        rs.getDate("startDate").toLocalDate(),
                        rs.getDate("endDate").toLocalDate(),
                        rs.getInt("totalPrice")
                );
                tour.setCustomTourId(rs.getInt("customTourId"));
                return tour;
            }
            
        }
        return null;
    }

    public List<CustomTourDetail> getTourDetails(int tourId) throws SQLException {
        List<CustomTourDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomTourDetails WHERE customTourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomTourDetail detail = new CustomTourDetail();
                detail.setCustomTourId(rs.getInt("customTourId"));
                detail.setServiceType(rs.getString("serviceType"));
                detail.setServiceId(rs.getInt("serviceId"));
                detail.setPrice(rs.getInt("price"));

                setServiceName(detail);

                list.add(detail);
            }
        }
        return list;
    }

    public List<CustomTourItinerary> getTourItinerary(int tourId) throws SQLException {
        List<CustomTourItinerary> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomTourItinerary WHERE customTourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CustomTourItinerary(
                        rs.getInt("dayNumber"),
                        rs.getString("activity"),
                        rs.getString("location"),
                        rs.getTime("startTime"),
                        rs.getTime("endTime")
                ));
            }
        }
        return list;
    }

    public int getServicePrice(String serviceType, int serviceId) throws SQLException {
        String sql = "";
        switch (serviceType) {
            case "Khách sạn":
                sql = "SELECT pricePerNight AS price FROM Hotels WHERE hotelId = ?";
                break;
            case "Phương tiện":
                sql = "SELECT pricePerDay AS price FROM IslandVehicles WHERE vehicleId = ?";
                break;
            case "Chuyến bay":
                sql = "SELECT price FROM Flights WHERE flightId = ?";
                break;
        }
        if (sql == null || sql.isEmpty()) {
            throw new SQLException("Unknown service type: " + serviceType);
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("price");
                }
            }
        }
        return 0;
    }

    public void setServiceName(CustomTourDetail detail) throws SQLException {
        String sql = "";
        switch (detail.getServiceType()) {
            case "Khách sạn":
                sql = "SELECT hotelName AS name FROM Hotels WHERE hotelId = ?";
                break;
            case "Phương tiện":
                sql = "SELECT modelName AS name FROM IslandVehicles WHERE vehicleId = ?";
                break;
            case "Chuyến bay":
                sql = "SELECT flightNumber AS name FROM Flights WHERE flightId = ?";
                break;
            default:
                throw new SQLException("Unknown service type: " + detail.getServiceType());
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, detail.getServiceId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    detail.setServiceName(rs.getString("name")); // set trực tiếp vào object
                } else {
                    detail.setServiceName(""); // nếu không tìm thấy, set rỗng
                }
            }
        }
    }
}
