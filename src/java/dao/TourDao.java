/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.Timestamp;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Booking;
import model.CustomTour;
import model.CustomTourBookingInfo;
import model.CustomTourDetail;
import model.CustomTourItinerary;
import model.Flight;
import model.FlightSchedule;
import model.HistoryBooking;
import model.Tour;
import model.TourActivities;
import model.TourBookingInfo;
import model.TourItinerary;
import model.TourService;

/**
 *
 * @author Admin
 */
public class TourDao extends DBContext {

    public static TourDao INSTANCE = new TourDao();

    //Lay danh sach tour tron goi theo dao
    public List<Tour> getListToursById(int id) throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = "select * from tours a join islands b on a.islandId = b.islandId where b.islandId = ? and a.approvalStatus = 'APPROVED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                t.setApprovalStatus(rs.getString("approvalStatus"));
                t.setAvailableQuantity(rs.getInt("availableQuantity"));

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
                t.setApprovalStatus(rs.getString("approvalStatus"));
                t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
            while (rs.next()) { // get multiple islands
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
            while (rs.next()) { // get multiple activities
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
                tourI.setTimeOfDay(rs.getString("timeOfDay"));

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
                + "(customTourId, dayNumber, activity, location, timeOfDay) "
                + "VALUES (?, ?, ?, ?, ?)";

        // Lay danh sach dich vu trong tour
        List<CustomTourDetail> services = getCustomTourDetails(customTourId);

        // Tinh so ngay tour
        int numberOfDays = (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
        if (numberOfDays <= 0) {
            numberOfDays = 1;
        }

        // Tach rieng khach san va dia diem noi bat
        String hotelName = null;
        List<String> places = new ArrayList<>();

        for (CustomTourDetail detail : services) {
            if ("Khách sạn".equals(detail.getServiceType())) {
                hotelName = detail.getServiceName(); //Boi vi khach san chi co 1
            } else if ("Địa điểm nổi bật".equals(detail.getServiceType())) {
                places.add(detail.getServiceName()); //Dia diem noi bat la 1 danh sach hoac khong
            }
        }

        // Loai bo trung lap dia diem
        Set<String> uniquePlaces = new LinkedHashSet<>(places); //Neu trung lap thi se bo qua
        places = new ArrayList<>(uniquePlaces);

        String[] times = {"Buổi sáng", "Buổi chiều", "Buổi tối"};

        // Tao danh sach slot theo tung slot (bo sang ngay dau va chieu voi toi ngay cuoi)
        List<int[]> scheduleSlots = new ArrayList<>(); //Mang lay cac slot tinh tu chieu ngay dau den sang ngay cuoi(mang chua mang)
        for (int day = 1; day <= numberOfDays; day++) {
            for (int t = 0; t < times.length; t++) {
                String time = times[t];
                if (day == 1 && time.equals("Buổi sáng")) {
                    continue;
                }
                if (day == numberOfDays && time.equals("Buổi tối")) {
                    continue;
                }
                scheduleSlots.add(new int[]{day, t}); //scheduleSlots là một danh sách chứa các cặp giá trị {day, t} Vi du (1, 0)
            }
        }

        // Dem so slot (khong tinh check-in/out)
        int totalSlots = 0;
        for (int[] slot : scheduleSlots) {
            int day = slot[0];
            String time = times[slot[1]];
            if (!(day == 1 && time.equals("Buổi chiều")) && !(day == numberOfDays && time.equals("Buổi chiều"))) {
                totalSlots++;
            }
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int placeIndex = 0;

            for (int[] slot : scheduleSlots) {
                int day = slot[0];
                String timeOfDay = times[slot[1]];
                String activity;
                String location;

                if (timeOfDay.equals("Buổi tối")) {
                    activity = "Hoạt động tự do và nghỉ ngơi";
                    location = hotelName;
                } else if (day == 1 && timeOfDay.equals("Buổi chiều")) {
                    activity = "Xuống sân bay và đến check-in tại khách sạn " + hotelName + " và ổn định chỗ ở";
                    location = hotelName;
                } else if (day == numberOfDays && timeOfDay.equals("Buổi chiều")) {
                    activity = "Check-out tại khách sạn " + hotelName + " và ra sân bay";
                    location = hotelName;
                } else {
                    // Neu so dia diem nhieu hon so slot thi chia deu nhieu dia diem vao mot slot
                    int remainingPlaces = places.size() - placeIndex;
                    int remainingSlots = totalSlots - (placeIndex / Math.max(1, (places.size() / Math.max(1, totalSlots))));
                    int placesPerSlot = Math.max(1, remainingPlaces / Math.max(1, remainingSlots));

                    List<String> slotPlaces = new ArrayList<>();
                    for (int i = 0; i < placesPerSlot && placeIndex < places.size(); i++) {
                        slotPlaces.add(places.get(placeIndex++));
                    }

                    String joinedPlaces = String.join(", ", slotPlaces);
                    if (slotPlaces.isEmpty()) {
                        //  Neu khong co dia diem nao thi tu do
                        activity = "Tự do khám phá hoặc tham quan theo sở thích cá nhân";
                        location = "Tự do";
                    } else {
                        joinedPlaces = String.join(", ", slotPlaces);
                        activity = "Tham quan và trải nghiệm " + joinedPlaces;
                        location = joinedPlaces;
                    }
                }

                ps.setInt(1, customTourId);
                ps.setInt(2, day);

                ps.setString(3, activity);

                ps.setString(4, location);
                ps.setString(5, timeOfDay);
                ps.addBatch();
            }

            ps.executeBatch();
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tạo lịch trình mẫu cho custom tour, customTourId = " + customTourId, e);
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
    public List<CustomTourDetail> getCustomTourDetails(int tourId) throws SQLException {
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
                        rs.getString("timeOfDay")
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
                sql = "SELECT basePrice  AS price FROM Flights WHERE flightId = ?";
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

    //Lay ten dich vu theo loai dich vu cho tour lẻ
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
    
    
    
    
     //Lay ten dich vu theo loai dich vu cho tour trọn gói
    public void setServiceNameTour(TourService detail) throws SQLException {
        String sql = "";
         switch (detail.getServiceType()) {
    case "Hotel":
        sql = "SELECT hotelName AS name FROM Hotels WHERE hotelId = ?";
        break;
    case "Place":
        sql = "SELECT placeName AS name FROM Places WHERE placeId = ?";
        break;
    case "FLIGHT":
        sql = "SELECT flightNumber AS name FROM Flights WHERE flightId = ?";
        break;
    case "Vehicle":
        sql = "SELECT modelName AS name FROM IslandVehicles WHERE vehicleId = ?";
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

    // ==================== CRUD OPERATIONS FOR TOURS (STAFF FUNCTIONS) ====================
    //Tao tour tron goi moi (Create)
    public int createTour(Tour tour) throws SQLException {
        String sql = "INSERT INTO Tours (islandId, tourName, description, price, tourImageUrl, availableQuantity) OUTPUT INSERTED.tourId VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tour.getIslandId());
            ps.setString(2, tour.getTourName());
            ps.setString(3, tour.getDescription());
            ps.setInt(4, tour.getPrice());
            ps.setString(5, tour.getTourImageUrl());
            ps.setInt(6, tour.getAvailableQuantity());

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
        String sql = "UPDATE Tours SET islandId = ?, tourName = ?, description = ?, price = ?, tourImageUrl = ?, approvalStatus = ?, availableQuantity = ? WHERE tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tour.getIslandId());
            ps.setString(2, tour.getTourName());
            ps.setString(3, tour.getDescription());
            ps.setInt(4, tour.getPrice());
            ps.setString(5, tour.getTourImageUrl());
            ps.setString(6, tour.getApprovalStatus());
            ps.setInt(7, tour.getAvailableQuantity());
            ps.setInt(8, tour.getTourId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Updating tour failed: " + e.getMessage());
        }
    }

    //Cap nhat thong tin tour tron goi va cac dich vu (Update with Services)
    public boolean updateTourWithServices(Tour tour, String[] selectedHotels, String[] selectedRestaurants,
            String[] selectedPlaces, String[] selectedVehicles) throws SQLException {
        try {
            String sql = "UPDATE Tours SET islandId = ?, tourName = ?, description = ?, price = ?, tourImageUrl = ?, approvalStatus = ?, availableQuantity = ? WHERE tourId = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, tour.getIslandId());
                ps.setString(2, tour.getTourName());
                ps.setString(3, tour.getDescription());
                ps.setInt(4, tour.getPrice());
                ps.setString(5, tour.getTourImageUrl());
                ps.setString(6, tour.getApprovalStatus());
                ps.setInt(7, tour.getAvailableQuantity());
                ps.setInt(8, tour.getTourId());

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected == 0) {
                    return false;
                }
            }

            // Clear existing services for this tour
            ServiceDao serviceDao = new ServiceDao();
            serviceDao.clearTourServices(tour.getTourId());

            // Add selected hotels
            if (selectedHotels != null) {
                for (String hotelId : selectedHotels) {
                    if (hotelId != null && !hotelId.trim().isEmpty()) {
                        serviceDao.addServiceToTour(tour.getTourId(), "Hotel", Integer.parseInt(hotelId));
                    }
                }
            }

            // Add selected restaurants
            if (selectedRestaurants != null) {
                for (String restaurantId : selectedRestaurants) {
                    if (restaurantId != null && !restaurantId.trim().isEmpty()) {
                        serviceDao.addServiceToTour(tour.getTourId(), "Restaurant", Integer.parseInt(restaurantId));
                    }
                }
            }

            // Add selected places
            if (selectedPlaces != null) {
                for (String placeId : selectedPlaces) {
                    if (placeId != null && !placeId.trim().isEmpty()) {
                        serviceDao.addServiceToTour(tour.getTourId(), "Place", Integer.parseInt(placeId));
                    }
                }
            }

            // Add selected vehicles
            if (selectedVehicles != null) {
                for (String vehicleId : selectedVehicles) {
                    if (vehicleId != null && !vehicleId.trim().isEmpty()) {
                        serviceDao.addServiceToTour(tour.getTourId(), "Vehicle", Integer.parseInt(vehicleId));
                    }
                }
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Updating tour with services failed: " + e.getMessage());
        } finally {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
        String sql = "SELECT t.*, i.islandName FROM Tours t "
                + "LEFT JOIN Islands i ON t.islandId = i.islandId "
                + "ORDER BY t.tourId";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                t.setApprovalStatus(rs.getString("approvalStatus"));
                t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
                    t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
        String sql = "SELECT t.*, i.islandName FROM Tours t "
                + "LEFT JOIN Islands i ON t.islandId = i.islandId "
                + "ORDER BY t.tourId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
                    t.setApprovalStatus(rs.getString("approvalStatus"));
                    t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
                    t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
        String sql = "SELECT t.*, i.islandName FROM Tours t "
                + "LEFT JOIN Islands i ON t.islandId = i.islandId "
                + "WHERE t.tourName LIKE ? ORDER BY t.tourId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
                    t.setAvailableQuantity(rs.getInt("availableQuantity"));
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
                    t.setAvailableQuantity(rs.getInt("availableQuantity"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Searching tours failed: " + e.getMessage());
        }
        return list;
    }

    // ==================== ITINERARY MANAGEMENT METHODS ====================
    /**
     * Create a new tour itinerary day
     */
    public int createTourItinerary(TourItinerary itinerary) throws SQLException {
        String sql = "INSERT INTO TourItinerary (tourId, dayNumber, title) OUTPUT INSERTED.itineraryId VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itinerary.getTourId());
            ps.setInt(2, itinerary.getDayNumber());
            ps.setString(3, itinerary.getTitle());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tạo lịch trình tour, tourId = " + itinerary.getTourId(), e);
        }
        return 0;
    }

    /**
     * Create a new tour activity
     */
    public int createTourActivity(TourActivities activity) throws SQLException {
        String sql = "INSERT INTO TourActivities (itineraryId, activityOrder, activityTitle, description) OUTPUT INSERTED.activityId VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, activity.getItineraryId());
            ps.setInt(2, activity.getActivityOrder());
            ps.setString(3, activity.getActivityTitle());
            ps.setString(4, activity.getDescription());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tạo hoạt động lịch trình, itineraryId = " + activity.getItineraryId(), e);
        }
        return 0;
    }

    /**
     * Update a tour activity
     */
    public boolean updateTourActivity(TourActivities activity) throws SQLException {
        String sql = "UPDATE TourActivities SET activityTitle = ?, description = ?, activityOrder = ? WHERE activityId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, activity.getActivityTitle());
            ps.setString(2, activity.getDescription());
            ps.setInt(3, activity.getActivityOrder());
            ps.setInt(4, activity.getActivityId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi cập nhật hoạt động, activityId = " + activity.getActivityId(), e);
        }
    }

    /**
     * Get a tour activity by ID
     */
    public TourActivities getTourActivityById(int activityId) throws SQLException {
        String sql = "SELECT * FROM TourActivities WHERE activityId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, activityId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TourActivities activity = new TourActivities();
                    activity.setActivityId(rs.getInt("activityId"));
                    activity.setItineraryId(rs.getInt("itineraryId"));
                    activity.setActivityOrder(rs.getInt("activityOrder"));
                    activity.setActivityTitle(rs.getString("activityTitle"));
                    activity.setDescription(rs.getString("description"));
                    return activity;
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy hoạt động, activityId = " + activityId, e);
        }
        return null;
    }

    /**
     * Get tour itinerary by ID
     */
    public TourItinerary getTourItineraryById(int itineraryId) throws SQLException {
        String sql = "SELECT itineraryId, tourId, dayNumber, title FROM TourItinerary WHERE itineraryId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itineraryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TourItinerary itinerary = new TourItinerary();
                    itinerary.setItineraryId(rs.getInt("itineraryId"));
                    itinerary.setTourId(rs.getInt("tourId"));
                    itinerary.setDayNumber(rs.getInt("dayNumber"));
                    itinerary.setTitle(rs.getString("title"));
                    return itinerary;
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy thông tin lịch trình, itineraryId = " + itineraryId, e);
        }
        return null;
    }

    /**
     * Update tour itinerary
     */
    public boolean updateTourItinerary(TourItinerary itinerary) throws SQLException {
        String sql = "UPDATE TourItinerary SET dayNumber = ?, title = ? WHERE itineraryId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itinerary.getDayNumber());
            ps.setString(2, itinerary.getTitle());
            ps.setInt(3, itinerary.getItineraryId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi cập nhật lịch trình, itineraryId = " + itinerary.getItineraryId(), e);
        }
    }

    /**
     * Delete all itineraries for a tour
     */
    public void deleteTourItineraries(int tourId) throws SQLException {
        // First delete all activities
        String deleteActivitiesSql = "DELETE ta FROM TourActivities ta "
                + "INNER JOIN TourItinerary ti ON ta.itineraryId = ti.itineraryId "
                + "WHERE ti.tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(deleteActivitiesSql)) {
            ps.setInt(1, tourId);
            ps.executeUpdate();
        }

        // Then delete itineraries
        String deleteItinerariesSql = "DELETE FROM TourItinerary WHERE tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(deleteItinerariesSql)) {
            ps.setInt(1, tourId);
            ps.executeUpdate();
        }
    }

    /**
     * Delete a specific itinerary by ID
     */
    public boolean deleteItinerary(int itineraryId) throws SQLException {
        // First delete all activities for this itinerary
        String deleteActivitiesSql = "DELETE FROM TourActivities WHERE itineraryId = ?";
        try (PreparedStatement ps = connection.prepareStatement(deleteActivitiesSql)) {
            ps.setInt(1, itineraryId);
            ps.executeUpdate();
        }

        // Then delete the itinerary
        String deleteItinerarySql = "DELETE FROM TourItinerary WHERE itineraryId = ?";
        try (PreparedStatement ps = connection.prepareStatement(deleteItinerarySql)) {
            ps.setInt(1, itineraryId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // -------------------- LẤY DANH SÁCH TOUR PENDING --------------------
    public List<Tour> getPendingTours() throws SQLException {
        List<Tour> list = new ArrayList<>();

        String sql = """
            SELECT t.tourId, t.islandId, t.tourName, t.description, t.price, 
                   t.tourImageUrl, t.approvalStatus, i.islandName
            FROM Tours t
            JOIN Islands i ON t.islandId = i.islandId
            WHERE t.approvalStatus = 'PENDING'
            ORDER BY t.tourId DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                t.setApprovalStatus(rs.getString("approvalStatus"));
                t.setIslandName(rs.getString("islandName"));
                list.add(t);
            }
        }
        return list;
    }

    // -------------------- CẬP NHẬT TRẠNG THÁI DUYỆT TOUR --------------------
    public void updateTourStatus(int tourId, String status) throws SQLException {
        String sql = "UPDATE Tours SET approvalStatus = ? WHERE tourId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tourId);
            ps.executeUpdate();
        }
    }

    // -------------------- LẤY TOÀN BỘ TOUR (THEO TRẠNG THÁI TUỲ CHỌN) --------------------
    public List<Tour> getToursByStatus(String status) throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = """
            SELECT t.tourId, t.islandId, t.tourName, t.description, t.price, 
                   t.tourImageUrl, t.approvalStatus, i.islandName
            FROM Tours t
            JOIN Islands i ON t.islandId = i.islandId
            WHERE (? IS NULL OR t.approvalStatus = ?)
            ORDER BY t.tourId DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                t.setApprovalStatus(rs.getString("approvalStatus"));
                t.setIslandName(rs.getString("islandName"));
                list.add(t);
            }
        }
        return list;
    }

    // -------------------- Dashboard  tour --------------------
    public int getTotalTours() throws SQLException {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM tours";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi thực thi getTotalTours", e);
        }
        return total;
    }

    // lay recent tour
    public List<Tour> getRecentTours() throws SQLException {
        List<Tour> list = new ArrayList<>();
        String sql = "SELECT TOP 5 t.tourId, t.tourName, t.price, t.tourImageUrl, "
                + "i.islandName, MAX(ts.createdAt) AS createdAt "
                + "FROM Tours t "
                + "JOIN Islands i ON t.islandId = i.islandId "
                + "LEFT JOIN TourServices ts ON ts.tourId = t.tourId "
                + "GROUP BY t.tourId, t.tourName, t.price, t.tourImageUrl, i.islandName "
                + "ORDER BY MAX(ts.createdAt) DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setTourId(rs.getInt("tourId"));
                tour.setTourName(rs.getString("tourName"));
                tour.setPrice(rs.getInt("price"));
                tour.setTourImageUrl(rs.getString("tourImageUrl"));
                tour.setIslandName(rs.getString("islandName"));
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                tour.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);

                list.add(tour);
            }
        }
        return list;
    }
  //-------------------TOUR LẺ SAU BOOKING-----------------------------------------//
    // lấy thông tin chi tiết của customerTour sau khi booking
    public CustomTourBookingInfo getLatestCustomTourAfterBookingByUser(int userId) throws SQLException {
        CustomTourBookingInfo info = new CustomTourBookingInfo();
        String sql = """
    SELECT ct.*, ctd.*, cti.*, hb.*,b.bookingId , b.totalPrice
    FROM HistoryBooking hb
    JOIN Payments p ON hb.paymentId = p.paymentId
    JOIN Bookings b ON p.bookingId = b.bookingId
    JOIN CustomTours ct ON b.customTourId = ct.customTourId
    LEFT JOIN CustomTourDetails ctd ON ct.customTourId = ctd.customTourId
    LEFT JOIN CustomTourItinerary cti ON ct.customTourId = cti.customTourId
    WHERE hb.accountUserId = ?
      AND b.tourId IS NULL
      AND hb.historyId = (
          SELECT MAX(hb2.historyId)
          FROM HistoryBooking hb2
          JOIN Payments p2 ON hb2.paymentId = p2.paymentId
          JOIN Bookings b2 ON p2.bookingId = b2.bookingId
          WHERE hb2.accountUserId = ? AND b2.tourId IS NULL
      )
    ORDER BY ctd.detailId, cti.dayNumber
""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            CustomTour ct = null;
            Booking bk = null;
            HistoryBooking hb = null;
            Set<Integer> detailIds = new HashSet<>();
            Set<Integer> itineraryIds = new HashSet<>();

            while (rs.next()) {
                // Khởi tạo CustomTour 1 lần
                if (ct == null) {
                    ct = new CustomTour(
                            rs.getString("tourName"),
                            rs.getInt("islandId"),
                            rs.getDate("startDate").toLocalDate(),
                            rs.getDate("endDate").toLocalDate(),
                            rs.getInt("totalPrice")
                    );
                    ct.setCustomTourId(rs.getInt("customTourId"));
                    info.setCustomTour(ct);
                }
                
                

            // === BOOKING ===
            if (bk == null) {
                bk = new Booking();
                bk.setBookingId(rs.getInt("bookingId"));
                bk.setTotalPrice(rs.getDouble("totalPrice"));
                java.sql.Date departure = rs.getDate("departureDate");
                if (departure != null) {
                    bk.setDepartureDate(departure);
                }
                info.setBooking(bk);
            }
                // Khởi tạo HistoryBooking 1 lần
                if (hb == null) {
                    hb = new HistoryBooking();
                    hb.setHistoryId(rs.getInt("historyId"));
                    hb.setPaymentId(rs.getInt("paymentId"));
                    hb.setAccountUserId(rs.getInt("accountUserId"));
                    hb.setCustomerName(rs.getString("customerName"));
                    hb.setCustomerEmail(rs.getString("customerEmail"));
                    hb.setCustomerPhone(rs.getString("customerPhone"));
                    hb.setCreatedAt(rs.getTimestamp("createdAt"));
                    hb.setTourStatus(rs.getString("tourStatus"));
                    info.setHistoryBooking(hb);
                }

                // Lấy CustomTourDetails nếu có và chưa add
                int detailId = rs.getInt("detailId");
                if (!rs.wasNull() && !detailIds.contains(detailId)) {
                    CustomTourDetail detail = new CustomTourDetail();
                    detail.setDetailId(detailId);
                    detail.setCustomTourId(rs.getInt("customTourId"));
                    detail.setServiceType(rs.getString("serviceType"));

                    detail.setServiceId(rs.getInt("serviceId"));
                    setServiceName(detail);
                    detail.setPrice(rs.getInt("price"));
                    info.addCustomTourDetail(detail);
                    detailIds.add(detailId);
                }

                // Lấy CustomTourItinerary nếu có và chưa add
                int itineraryId = rs.getInt("itineraryId"); // lấy đúng cột ID
                if (!rs.wasNull() && !itineraryIds.contains(itineraryId)) {
                    CustomTourItinerary itinerary = new CustomTourItinerary(
                            rs.getInt("dayNumber"),
                            rs.getString("activity"),
                            rs.getString("location"),
                            rs.getString("timeOfDay")
                    );
                    info.addCustomTourItinerary(itinerary);
                    itineraryIds.add(itineraryId); // đánh dấu đã thêm
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy CustomTour mới nhất của userId=" + userId, e);
        }

        return info;
    }

    // Lay tat ca lich bay sau khi booking tour lẻ
    public FlightSchedule geFlightScheduleOfCustomerTourByUser(int userId) throws SQLException {
        String sql = """
        SELECT TOP 1 
            fs.scheduleId,
            fs.departureTime,
            fs.arrivalTime,
            fs.returnDepartureTime,
            fs.returnArrivalTime,
            fs.departureAirport,
            fs.arrivalAirport,
            fs.transitAirport,
            fs.transitDuration,
            fs.notes,
            
            f.flightId,
            f.flightNumber,
            f.flightClass,
            f.flightType,
            f.destinationImageUrl

        FROM HistoryBooking hb
        JOIN Payments p ON hb.paymentId = p.paymentId
        JOIN Bookings b ON p.bookingId = b.bookingId
        JOIN CustomTours ct ON b.customTourId = ct.customTourId
        JOIN Islands i ON ct.islandId = i.islandId
        JOIN Flights f ON f.destinationIslandId = i.islandId
        JOIN FlightSchedules fs ON fs.flightId = f.flightId
        WHERE hb.accountUserId = ?
        ORDER BY hb.historyId DESC, fs.scheduleId ASC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // === Tạo Flight ===
                    Flight flight = new Flight();
                    flight.setFlightId(rs.getInt("flightId"));
                    flight.setFlightNumber(rs.getString("flightNumber"));
                    flight.setFlightClass(rs.getString("flightClass"));
                    flight.setFlightType(rs.getString("flightType"));
                    flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));

                    // === Tạo FlightSchedule ===
                    FlightSchedule schedule = new FlightSchedule();
                    schedule.setScheduleId(rs.getInt("scheduleId"));
                    schedule.setFlight(flight);

                    // --- Thời gian ---
                    Time dep = rs.getTime("departureTime");
                    schedule.setDepartureTime(dep != null ? dep.toLocalTime() : null);
                    Time arr = rs.getTime("arrivalTime");
                    schedule.setArrivalTime(arr != null ? arr.toLocalTime() : null);
                    Time retDep = rs.getTime("returnDepartureTime");
                    schedule.setReturnDepartureTime(retDep != null ? retDep.toLocalTime() : null);
                    Time retArr = rs.getTime("returnArrivalTime");
                    schedule.setReturnArrivalTime(retArr != null ? retArr.toLocalTime() : null);

                    // --- Thông tin chuyến bay khác ---
                    schedule.setDepartureAirport(rs.getString("departureAirport"));
                    schedule.setArrivalAirport(rs.getString("arrivalAirport"));
                    schedule.setTransitAirport(rs.getString("transitAirport"));
                    schedule.setTransitDuration(rs.getString("transitDuration"));
                    schedule.setNotes(rs.getString("notes"));

                    // --- Cài đặt thông tin máy bay ---
                    setAircraftInfo(schedule, flight.getFlightClass());

                    return schedule;
                }
            }
        }
        return null; // nếu user chưa booking custom tour nào có flight
    }

    /**
     * Helper gán planeModel, seatCapacity, seatPitch, cabinBaggage dựa trên
     * flightClass
     */
    private void setAircraftInfo(FlightSchedule schedule, String flightClass) {
        if (flightClass == null) {
            flightClass = "";
        }
        switch (flightClass.trim()) {
            case "Phổ thông":
                schedule.setPlaneModel("Airbus A319");
                schedule.setSeatCapacity(100);
                schedule.setSeatPitch("29 inch (ngắn hơn tiêu chuẩn)");
                schedule.setCabinBaggage("7 kg");
                break;
            case "Thương gia":
                schedule.setPlaneModel("Boeing 737 MAX 9");
                schedule.setSeatCapacity(185);
                schedule.setSeatPitch("30 inch (tiêu chuẩn)");
                schedule.setCabinBaggage("10 kg");
                break;
            case "Hạng nhất":
                schedule.setPlaneModel("Airbus A321neo");
                schedule.setSeatCapacity(220);
                schedule.setSeatPitch("32 inch (rộng hơn trung bình)");
                schedule.setCabinBaggage("15 kg");
                break;
            default:
                schedule.setPlaneModel("Boeing 737-800");
                schedule.setSeatCapacity(189);
                schedule.setSeatPitch("30 inch (tiêu chuẩn)");
                schedule.setCabinBaggage("7 kg");
                break;
        }
    }
    
  //-------------------TOUR TRỌN GÓI SAU BOOKING-----------------------------------------//
    // lấy thông tin chi tiết của Tour sau khi booking
  public TourBookingInfo getLatestTourAfterBookingByUser(int userId) throws SQLException {
    TourBookingInfo info = new TourBookingInfo();
    String sql = """
        SELECT 
            t.*, 
            ts.*, 
            ti.*, 
              ta.activityId, 
                ta.itineraryId, 
                ta.activityOrder, 
                ta.activityTitle, 
                ta.description AS activityDescription, 
            hb.*,
            b.bookingId,
            b.totalPrice,
            b.departureDate              
        FROM HistoryBooking hb
        JOIN Payments p ON hb.paymentId = p.paymentId
        JOIN Bookings b ON p.bookingId = b.bookingId
        JOIN Tours t ON b.tourId = t.tourId
        LEFT JOIN TourServices ts ON t.tourId = ts.tourId
        LEFT JOIN TourItinerary ti ON t.tourId = ti.tourId
        LEFT JOIN TourActivities ta ON ti.itineraryId = ta.itineraryId
        WHERE hb.accountUserId = ?
          AND b.customTourId IS NULL
          AND hb.historyId = (
              SELECT MAX(hb2.historyId)
              FROM HistoryBooking hb2
              JOIN Payments p2 ON hb2.paymentId = p2.paymentId
              JOIN Bookings b2 ON p2.bookingId = b2.bookingId
              WHERE hb2.accountUserId = ? AND b2.customTourId IS NULL
          )
        ORDER BY ts.tourServiceId, ti.dayNumber, ta.activityOrder
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setInt(2, userId);
        ResultSet rs = ps.executeQuery();

        Tour tour = null;
        Booking bk = null;
        HistoryBooking hb = null;

        // Để tránh thêm trùng
        Map<Integer, TourService> serviceMap = new HashMap<>();
        Map<Integer, TourItinerary> itineraryMap = new LinkedHashMap<>();
        Map<Integer, Set<Integer>> activityMap = new HashMap<>();
        while (rs.next()) {
            // === TOUR ===
            if (tour == null) {
                tour = new Tour();
                tour.setTourId(rs.getInt("tourId"));
                tour.setIslandId(rs.getInt("islandId"));
                tour.setTourName(rs.getString("tourName"));
                tour.setDescription(rs.getString("description"));
                tour.setPrice(rs.getInt("price"));
                tour.setTourImageUrl(rs.getString("tourImageUrl"));
                tour.setApprovalStatus(rs.getString("approvalStatus"));
                tour.setAvailableQuantity(rs.getInt("availableQuantity"));

                java.sql.Timestamp createdTs = rs.getTimestamp("createdAt");
                if (createdTs != null) {
                    tour.setCreatedAt(createdTs.toLocalDateTime());
                }
                info.setTour(tour);
            }

            // === BOOKING ===
            if (bk == null) {
                bk = new Booking();
                bk.setBookingId(rs.getInt("bookingId"));
                bk.setTotalPrice(rs.getDouble("totalPrice"));
                java.sql.Date departure = rs.getDate("departureDate");
                if (departure != null) {
                    bk.setDepartureDate(departure);
                }
                info.setBooking(bk);
            }

            // === HISTORY BOOKING ===
            if (hb == null) {
                hb = new HistoryBooking();
                hb.setHistoryId(rs.getInt("historyId"));
                hb.setPaymentId(rs.getInt("paymentId"));
                hb.setAccountUserId(rs.getInt("accountUserId"));
                hb.setCustomerName(rs.getString("customerName"));
                hb.setCustomerEmail(rs.getString("customerEmail"));
                hb.setCustomerPhone(rs.getString("customerPhone"));
                hb.setCreatedAt(rs.getTimestamp("createdAt"));
                hb.setTourStatus(rs.getString("tourStatus"));
                info.setHistoryBooking(hb);
            }

            // === TOUR SERVICES ===
            int serviceId = rs.getInt("tourServiceId");
            if (!rs.wasNull() && !serviceMap.containsKey(serviceId)) {
                TourService ts = new TourService();
                ts.setTourServiceId(serviceId);
                ts.setTourId(rs.getInt("tourId"));
                ts.setServiceType(rs.getString("serviceType"));
                ts.setServiceId(rs.getInt("serviceId"));
                ts.setCreatedAt(rs.getTimestamp("createdAt"));
                setServiceNameTour(ts); // gọi hàm của bạn
                info.addTourService(ts);
                serviceMap.put(serviceId, ts);
            }

            // === TOUR ITINERARY ===
        
            int itineraryId = rs.getInt("itineraryId");
            TourItinerary ti = null;
            if (!rs.wasNull()) {
                ti = itineraryMap.get(itineraryId);
                if (ti == null) {
                    ti = new TourItinerary();
                    ti.setItineraryId(itineraryId);
                    ti.setTourId(rs.getInt("tourId"));
                    ti.setDayNumber(rs.getInt("dayNumber"));
                    ti.setTitle(rs.getString("title"));
                    ti.setActivities(new ArrayList<>());
                    info.addTourItinerary(ti);
                    itineraryMap.put(itineraryId, ti);
                }
            }

            // === TOUR ACTIVITIES ===
            
          int activityId = rs.getInt("activityId");
if (!rs.wasNull() && ti != null) {
    Set<Integer> activitySet = activityMap.computeIfAbsent(itineraryId, k -> new HashSet<>());
    if (!activitySet.contains(activityId)) {
        TourActivities ta = new TourActivities();
        ta.setActivityId(activityId);
        ta.setItineraryId(itineraryId);
        ta.setActivityOrder(rs.getInt("activityOrder"));
        ta.setActivityTitle(rs.getString("activityTitle"));
        ta.setDescription(rs.getString("activityDescription"));
        ti.getActivities().add(ta);
        activitySet.add(activityId);
    }
}
        }
    } catch (SQLException e) {
        throw new SQLException("Lỗi khi lấy tour mới nhất của userId=" + userId, e);
    }

    return info;
}

    
    // Lay tat ca lich bay sau khi booking tour trọn gói

    public FlightSchedule getFlightScheduleOfTourByUser(int userId) throws SQLException {
        String sql = """
        SELECT TOP 1 
            fs.scheduleId,
            fs.departureTime,
            fs.arrivalTime,
            fs.returnDepartureTime,
            fs.returnArrivalTime,
            fs.departureAirport,
            fs.arrivalAirport,
            fs.transitAirport,
            fs.transitDuration,
            fs.notes,
            
            f.flightId,
            f.flightNumber,
            f.flightClass,
            f.flightType,
            f.destinationImageUrl

        FROM HistoryBooking hb
        JOIN Payments p ON hb.paymentId = p.paymentId
        JOIN Bookings b ON p.bookingId = b.bookingId
        JOIN Tours t ON b.tourId = t.tourId
        JOIN Islands i ON t.islandId = i.islandId
        JOIN Flights f ON f.destinationIslandId = i.islandId
        JOIN FlightSchedules fs ON fs.flightId = f.flightId
        WHERE hb.accountUserId = ?
        ORDER BY hb.historyId DESC, fs.scheduleId ASC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // === Tạo Flight ===
                    Flight flight = new Flight();
                    flight.setFlightId(rs.getInt("flightId"));
                    flight.setFlightNumber(rs.getString("flightNumber"));
                    flight.setFlightClass(rs.getString("flightClass"));
                    flight.setFlightType(rs.getString("flightType"));
                    flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));

                    // === Tạo FlightSchedule ===
                    FlightSchedule schedule = new FlightSchedule();
                    schedule.setScheduleId(rs.getInt("scheduleId"));
                    schedule.setFlight(flight);

                    // --- Thời gian ---
                    Time dep = rs.getTime("departureTime");
                    schedule.setDepartureTime(dep != null ? dep.toLocalTime() : null);
                    Time arr = rs.getTime("arrivalTime");
                    schedule.setArrivalTime(arr != null ? arr.toLocalTime() : null);
                    Time retDep = rs.getTime("returnDepartureTime");
                    schedule.setReturnDepartureTime(retDep != null ? retDep.toLocalTime() : null);
                    Time retArr = rs.getTime("returnArrivalTime");
                    schedule.setReturnArrivalTime(retArr != null ? retArr.toLocalTime() : null);

                    // --- Thông tin chuyến bay khác ---
                    schedule.setDepartureAirport(rs.getString("departureAirport"));
                    schedule.setArrivalAirport(rs.getString("arrivalAirport"));
                    schedule.setTransitAirport(rs.getString("transitAirport"));
                    schedule.setTransitDuration(rs.getString("transitDuration"));
                    schedule.setNotes(rs.getString("notes"));

                    // --- Cài đặt thông tin máy bay ---
                    setAircraftInfo(schedule, flight.getFlightClass());

                    return schedule;
                }
            }
        }
        return null; // nếu user chưa booking custom tour nào có flight
    }
    // để check xem booking mới nhất là kiểu tour nào 

    public HistoryBooking getLatestHistoryBookingWithTourType(int userId) throws SQLException {
        HistoryBooking hb = null;
        String sql = """
        SELECT TOP 1 hb.historyId, hb.paymentId, hb.accountUserId, 
               hb.customerName, hb.customerEmail, hb.customerPhone,
               b.tourId, b.customTourId, hb.createdAt, hb.tourStatus
        FROM HistoryBooking hb
        JOIN Payments p ON hb.paymentId = p.paymentId
        JOIN Bookings b ON p.bookingId = b.bookingId
        WHERE hb.accountUserId = ?
        ORDER BY hb.historyId DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                hb = new HistoryBooking();
                hb.setHistoryId(rs.getInt("historyId"));
                hb.setPaymentId(rs.getInt("paymentId"));
                hb.setAccountUserId(rs.getInt("accountUserId"));
                hb.setCustomerName(rs.getString("customerName"));
                hb.setCustomerEmail(rs.getString("customerEmail"));
                hb.setCustomerPhone(rs.getString("customerPhone"));
                hb.setCreatedAt(rs.getTimestamp("createdAt"));
                hb.setTourStatus(rs.getString("tourStatus"));

                // Xác định tourType dựa vào tourId / customTourId
                int tourIdValue = rs.getInt("tourId");
                Integer tourId = rs.wasNull() ? null : tourIdValue;

                int customTourIdValue = rs.getInt("customTourId");
                Integer customTourId = rs.wasNull() ? null : customTourIdValue;
                if (customTourId != null) {
                    hb.setTourType("Tour lẻ");
                } else {
                    hb.setTourType("Tour trọn gói");
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy lịch sử booking mới nhất của userId=" + userId, e);
        }
        return hb;
    }

    public static void main(String[] args) {
        try {
            TourDao dao = new TourDao();
      
           int testUserId = 4; // <-- đổi userId để test theo dữ liệu thật trong DB
        
            TourBookingInfo info = dao.getLatestTourAfterBookingByUser(testUserId);

            System.out.println("\n===== THÔNG TIN TOUR MỚI NHẤT CỦA USER ID: " + testUserId + " =====");
            System.out.println("📌 Tour: " + info.getTour());
            System.out.println("📅 Booking: " + info.getBooking().getBookingId());
             System.out.println("📅 Booking: " + info.getBooking().getTotalPrice());
            System.out.println("🧾 History: " + info.getHistoryBooking());

            System.out.println("\n--- Các dịch vụ đi kèm ---");
            for (TourService s : info.getTourServices()) {
                System.out.println("  • " + s);
            }

            System.out.println("\n--- Lịch trình tour ---");
            for (TourItinerary ti : info.getTourItineraries()) {
                System.out.println("Ngày " + ti.getDayNumber() + ": " + ti.getTitle());
                if (ti.getActivities() != null) {
                    for (TourActivities act : ti.getActivities()) {
                        System.out.println("   ↳ " + act.getActivityOrder() + ". " + act.getActivityTitle() 
                                           + " — " + act.getDescription());
                    }
                } else {
                    System.out.println("   (Không có hoạt động nào)");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}