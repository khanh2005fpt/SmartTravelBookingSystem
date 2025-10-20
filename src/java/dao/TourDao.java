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
    public List<Tour> getListToursById(int id) {
        List<Tour> list = new ArrayList<>();
        String sql = "select * from tours a join islands b on a.islandId = b.islandId where b.islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // get multiple tours
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));

                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //Lay thong tin chi tiet cua tour tron goi
    public Tour getTourDetailById(int id) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    //Lay lich trinh cua tour theo tung tour tron goi rieng
    public List<TourItinerary> getListTourItineriesById(int id) {
        List<TourItinerary> list = new ArrayList<>();
        String sql = "select * from TourItinerary where tourId = ? order by dayNumber";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // get multiple islands
                TourItinerary tourI = new TourItinerary();
                tourI.setItineraryId(rs.getInt("itineraryId"));
                tourI.setTourId(rs.getInt("tourId"));
                tourI.setDayNumber(rs.getInt("dayNumber"));
                tourI.setTitle(rs.getString("title"));
                tourI.setActivities(getListTourActivitiesByItineraryId(tourI.getItineraryId()));
                list.add(tourI);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //Lay hoat dong cua tour theo tung tour tron goi rieng
    public List<TourActivities> getListTourActivitiesByItineraryId(int id) {
        List<TourActivities> list = new ArrayList<>();
        String sql = "select * from TourActivities where itineraryId = ? order by activityOrder";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // get multiple activities
                TourActivities tourA = new TourActivities();
                tourA.setActivityId(rs.getInt("activityId"));
                tourA.setItineraryId(rs.getInt("itineraryId"));
                tourA.setActivityOrder(rs.getInt("activityOrder"));
                tourA.setActivityTitle(rs.getString("activityTitle"));
                tourA.setDescription(rs.getString("description"));
                list.add(tourA);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //Ham tao tour le theo cac dich vu
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
    
    //Lay lich trinh cua tour rieng le
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
    
    //update gia theo tour rieng le
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
    
    //Tao thong tin chi tiet cua tour le
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
    
    //Tao thong tin lich trinh cua tour le
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

                // Logic to create activities by day
                String activity;
                if (day == 1) {
                    activity = "Hotel check-in and accommodation setup";
                } else if (day == numberOfDays) {
                    activity = "Hotel check-out and tour completion";
                } else {
                    activity = "Island sightseeing and experiences";
                }

                ps.setString(3, activity);
                ps.setString(4, "Featured location day " + day);

                // Sample activity hours: 08:00 - 17:00
                ps.setTime(5, Time.valueOf("08:00:00"));
                ps.setTime(6, Time.valueOf("17:00:00"));

                ps.addBatch();
            }
            ps.executeBatch();
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
    
    // ==================== CRUD OPERATIONS FOR TOURS (STAFF FUNCTIONS) ====================
    
    //Tao tour tron goi moi (Create)
    public int createTour(Tour tour) throws SQLException {
        String sql = "INSERT INTO Tours (islandId, tourName, description, price, tourImageUrl) OUTPUT INSERTED.tourId VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tour.getIslandId());
            ps.setString(2, tour.getTourName());
            ps.setString(3, tour.getDescription());
            ps.setInt(4, tour.getPrice());
            ps.setString(5, tour.getTourImageUrl());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Creating tour failed: " + e.getMessage());
        }
        return 0;
    }
    
    //Cap nhat thong tin tour tron goi (Update)
    public boolean updateTour(Tour tour) throws SQLException {
        String sql = "UPDATE Tours SET islandId = ?, tourName = ?, description = ?, price = ?, tourImageUrl = ? WHERE tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tour.getIslandId());
            ps.setString(2, tour.getTourName());
            ps.setString(3, tour.getDescription());
            ps.setInt(4, tour.getPrice());
            ps.setString(5, tour.getTourImageUrl());
            ps.setInt(6, tour.getTourId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Updating tour failed: " + e.getMessage());
        }
    }
    
    //Xoa tour tron goi (Delete)
    public boolean deleteTour(int tourId) throws SQLException {
        String sql = "DELETE FROM Tours WHERE tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Deleting tour failed: " + e.getMessage());
        }
    }
    
    //Lay tat ca tour tron goi (Read All)
    public List<Tour> getAllTours() throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = "SELECT * FROM Tours ORDER BY tourId";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting all tours failed: " + e.getMessage());
        }
        return list;
    }
    
    //Lay tat ca tour voi ten dao
    public List<Tour> getAllToursWithIslandNames() throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = "SELECT t.*, i.islandName FROM Tours t " +
                     "LEFT JOIN Islands i ON t.islandId = i.islandId " +
                     "ORDER BY t.tourId";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                t.setIslandName(rs.getString("islandName"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting all tours with island names failed: " + e.getMessage());
        }
        return list;
    }
    
    //Lay tour theo trang (Pagination)
    public List<Tour> getToursByPage(int page, int pageSize) throws SQLException {
        List<Tour> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Tours ORDER BY tourId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour t = new Tour();
                    t.setTourId(rs.getInt("tourId"));
                    t.setIslandId(rs.getInt("islandId"));
                    t.setTourName(rs.getString("tourName"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getInt("price"));
                    t.setTourImageUrl(rs.getString("tourImageUrl"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting tours by page failed: " + e.getMessage());
        }
        return list;
    }
    
    //Lay tour theo trang voi ten dao (Pagination with Island Names)
    public List<Tour> getToursByPageWithIslandNames(int page, int pageSize) throws SQLException {
        List<Tour> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT t.*, i.islandName FROM Tours t " +
                     "LEFT JOIN Islands i ON t.islandId = i.islandId " +
                     "ORDER BY t.tourId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour t = new Tour();
                    t.setTourId(rs.getInt("tourId"));
                    t.setIslandId(rs.getInt("islandId"));
                    t.setTourName(rs.getString("tourName"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getInt("price"));
                    t.setTourImageUrl(rs.getString("tourImageUrl"));
                    t.setIslandName(rs.getString("islandName"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting tours by page with island names failed: " + e.getMessage());
        }
        return list;
    }
    
    //Dem tong so tour
    public int getTotalToursCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tours";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting total tours count failed: " + e.getMessage());
        }
        return 0;
    }
    
    //Tim kiem tour theo ten voi phan trang
    public List<Tour> searchToursByNameWithPagination(String searchTerm, int page, int pageSize) throws SQLException {
        List<Tour> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Tours WHERE tourName LIKE ? ORDER BY tourId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour t = new Tour();
                    t.setTourId(rs.getInt("tourId"));
                    t.setIslandId(rs.getInt("islandId"));
                    t.setTourName(rs.getString("tourName"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getInt("price"));
                    t.setTourImageUrl(rs.getString("tourImageUrl"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Searching tours by name with pagination failed: " + e.getMessage());
        }
        return list;
    }
    
    //Tim kiem tour theo ten voi phan trang va ten dao
    public List<Tour> searchToursByNameWithPaginationAndIslandNames(String searchTerm, int page, int pageSize) throws SQLException {
        List<Tour> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT t.*, i.islandName FROM Tours t " +
                     "LEFT JOIN Islands i ON t.islandId = i.islandId " +
                     "WHERE t.tourName LIKE ? ORDER BY t.tourId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour t = new Tour();
                    t.setTourId(rs.getInt("tourId"));
                    t.setIslandId(rs.getInt("islandId"));
                    t.setTourName(rs.getString("tourName"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getInt("price"));
                    t.setTourImageUrl(rs.getString("tourImageUrl"));
                    t.setIslandName(rs.getString("islandName"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Searching tours by name with pagination and island names failed: " + e.getMessage());
        }
        return list;
    }
    
    //Dem so tour tim duoc theo ten
    public int getSearchToursCount(String searchTerm) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tours WHERE tourName LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting search tours count failed: " + e.getMessage());
        }
        return 0;
    }
    
    //Kiem tra tour co ton tai khong
    public boolean tourExists(int tourId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tours WHERE tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Checking tour existence failed: " + e.getMessage());
        }
        return false;
    }
    
    //Kiem tra ten tour co trung khong (cho validation)
    public boolean tourNameExists(String tourName, int excludeTourId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tours WHERE tourName = ? AND tourId != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, tourName);
            ps.setInt(2, excludeTourId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Checking tour name existence failed: " + e.getMessage());
        }
        return false;
    }
    
    //Tim kiem tour theo ten
    public List<Tour> searchToursByName(String searchTerm) throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = "SELECT * FROM Tours WHERE tourName LIKE ? ORDER BY tourName";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour t = new Tour();
                    t.setTourId(rs.getInt("tourId"));
                    t.setIslandId(rs.getInt("islandId"));
                    t.setTourName(rs.getString("tourName"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getInt("price"));
                    t.setTourImageUrl(rs.getString("tourImageUrl"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Searching tours failed: " + e.getMessage());
        }
        return list;
    }
}
