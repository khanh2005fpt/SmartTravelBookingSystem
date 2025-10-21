/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.CustomTour;
import model.CustomTourDetail;
import model.CustomTourItinerary;
import model.Tour;
import model.TourActivities;
import model.TourItinerary;

/**
 *
 * @author Admin
 */
public class TourDao extends DBContext {

    //Lay danh sach tour tron goi theo dao
    public List<Tour> getListToursById(int id) throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = "select * from tours a join islands b on a.islandId = b.islandId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều tour
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));

                list.add(t);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi thực thi getListToursById, islandId = " + id, e);
        }
        return list;
    }

    //Lay thong tin chi tiet cua tour tron goi
    public Tour getTourDetailById(int id) throws SQLException {
        String sql = "select * from tours where tourId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                return t;
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy chi tiết tour, tourId = " + id, e);
        }
        return null;
    }

    //Lay lich trinh cua tour theo tung tour tron goi rieng
    public List<TourItinerary> getListTourItineriesById(int id) throws SQLException {
        List<TourItinerary> list = new ArrayList<>();
        String sql = "select * from TourItinerary where tourId = ? order by dayNumber";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều island
                TourItinerary tourI = new TourItinerary();
                tourI.setItineraryId(rs.getInt("itineraryId"));
                tourI.setTourId(rs.getInt("tourId"));
                tourI.setDayNumber(rs.getInt("dayNumber"));
                tourI.setTitle(rs.getString("title"));
                tourI.setActivities(getListTourActivitiesByItineraryId(tourI.getItineraryId()));
                list.add(tourI);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy lịch trình tour, tourId = " + id, e);
        }
        return list;
    }

    //Lay hoat dong cua tour theo tung tour tron goi rieng
    public List<TourActivities> getListTourActivitiesByItineraryId(int id) throws SQLException {
        List<TourActivities> list = new ArrayList<>();
        String sql = "select * from TourActivities where itineraryId = ? order by activityOrder";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều island
                TourActivities tourA = new TourActivities();
                tourA.setActivityId(rs.getInt("activityId"));
                tourA.setItineraryId(rs.getInt("itineraryId"));
                tourA.setActivityOrder(rs.getInt("activityOrder"));
                tourA.setActivityTitle(rs.getString("activityTitle"));
                tourA.setDescription(rs.getString("description"));
                list.add(tourA);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy hoạt động lịch trình, itineraryId = " + id, e);
        }
        return list;
    }

    //Ham tao tour le theo cac dich vu
    public int createCustomTour(CustomTour tour) throws SQLException {
        //sql tra ve ID vua moi insert
        String sql = "INSERT INTO CustomTours (islandId, tourName, startDate, endDate, totalPrice) OUTPUT INSERTED.customTourId VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                throw new SQLException("Tạo tour riêng thất bại: không có ID trả về");
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi khi tạo custom tour: " + tour.getTourName(), e);
        }
        return 0;
    }

    //Lay lich trinh cua tour rieng le
    public List<CustomTourItinerary> getListCustomTourItineriesById(int id) throws SQLException {
        List<CustomTourItinerary> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomTourItinerary WHERE customTourId = ? ORDER BY dayNumber";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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

        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy lịch trình custom tour, customTourId = " + id, e);
        }
        return list;
    }

    //update gia theo tour rieng le
    public void updateTotalPrice(int customTourId, int totalPrice) throws SQLException {
        String sql = "UPDATE CustomTours SET totalPrice = ? WHERE customTourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, totalPrice);
            ps.setInt(2, customTourId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi cập nhật tổng giá custom tour, customTourId = " + customTourId, e);
        }
    }

    //Tao thong tin chi tiet cua tour le
    public void createCustomTourDetail(CustomTourDetail detail) throws SQLException {
        String sql = "INSERT INTO CustomTourDetails (customTourId, serviceType, serviceId, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, detail.getCustomTourId());
            ps.setString(2, detail.getServiceType());
            ps.setInt(3, detail.getServiceId());
            ps.setInt(4, detail.getPrice());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tạo chi tiết custom tour, customTourId = " + detail.getCustomTourId(), e);
        }
    }

    //Tao thong tin lich trinh cua tour le
    public void createSampleItinerary(int customTourId, LocalDate startDate, LocalDate endDate) throws SQLException {
        String sql = "INSERT INTO CustomTourItinerary "
                + "(customTourId, dayNumber, activity, location, startTime, endTime) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        // Tính số ngày tour, bao gồm cả ngày bắt đầu và kết thúc
        int numberOfDays = (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
        if (numberOfDays <= 0) {
            numberOfDays = 1;
        }

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
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tạo lịch trình mẫu cho custom tour, customTourId=" + customTourId, e);
        }
    }

    //Lay tour rieng le theo id
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

        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy custom tour theo customTourId = " + tourId, e);
        }
        return null;
    }

    //Lay thong tin chi tiet tour le theo id
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
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy chi tiết custom tour, customTourId = " + tourId, e);
        }
        return list;
    }

    //Lay lich trinh tour le theo id
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
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy lịch trình custom tour, customTourId=" + tourId, e);
        }
        return list;
    }

    //Lay gia cua dich vu theo loai dich vu
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
            case "Địa điểm nổi bật":
                sql = "SELECT ticketPrice AS price FROM Places WHERE placeId = ?";
                break;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("price");
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy giá dịch vụ (" + serviceType + "), id=" + serviceId, e);
        }
        return 0;
    }

    //Lay ten dich vu theo loai dich vu
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
            case "Địa điểm nổi bật":
                sql = "SELECT placeName AS name FROM Places WHERE placeId = ?";
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
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy tên dịch vụ, serviceType=" + detail.getServiceType(), e);
        }
    }
}
