/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Airlines;
import model.Flight;
import model.Hotel;
import model.Island;
import model.IslandVehicle;
import model.Place;
import model.TourService;
import utils.DBContext;
import java.sql.Time;
import model.FlightSchedule;

/**
 *
 * @author Admin
 */
public class ServiceDao extends DBContext {

    public static final ServiceDao INSTANCE = new ServiceDao();

    //Lay danh sach phuong tien theo dao
    public List<IslandVehicle> getListVehicleById(int id) throws SQLException {
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "select * from IslandVehicles a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều phương tiện
                IslandVehicle v = new IslandVehicle(
                        rs.getInt("vehicleId"),
                        rs.getInt("islandId"),
                        rs.getString("vehicleType"),
                        rs.getString("modelName"),
                        rs.getDouble("pricePerDay"),
                        rs.getInt("capacity"),
                        rs.getInt("availability")
                );
                list.add(v);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy danh sách phương tiện cho đảo có islandId = " + id, e);
        }
        return list;
    }

    //Lay tat ca khach san
    public List<Hotel> getHotels() throws SQLException {
        List<Hotel> list = new ArrayList<>();
        String sql = "select * from hotels a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Hotel h = new Hotel();
                h.setHotelId(rs.getInt("hotelId"));
                h.setIslandId(rs.getInt("islandId"));
                h.setHotelName(rs.getString("hotelName"));
                h.setCountryName(rs.getString("countryName"));
                h.setHotelImageUrl(rs.getString("hotelImageUrl"));
                h.setRoomType(rs.getString("roomType"));
                h.setPricePerNight(rs.getInt("pricePerNight"));
                h.setRoomAvailable(rs.getInt("roomsAvailable"));
                h.setRating(rs.getDouble("rating"));
                list.add(h);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy danh sách khách sạn từ cơ sở dữ liệu.", e);
        }
        return list;
    }

    //lay danh sach khach san theo dao
    public List<Hotel> getListHotelsById(int id) throws SQLException {
        List<Hotel> list = new ArrayList<>();
        String sql = "select * from hotels a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều khách sạn
                Hotel h = new Hotel();
                h.setHotelId(rs.getInt("hotelId"));
                h.setIslandId(rs.getInt("islandId"));
                h.setHotelName(rs.getString("hotelName"));
                h.setCountryName(rs.getString("countryName"));
                h.setHotelImageUrl(rs.getString("hotelImageUrl"));
                h.setRoomType(rs.getString("roomType"));
                h.setPricePerNight(rs.getInt("pricePerNight"));
                h.setRoomAvailable(rs.getInt("roomsAvailable"));
                h.setRating(rs.getDouble("rating"));
                list.add(h);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy danh sách khách sạn cho đảo có islandId = " + id, e);
        }
        return list;
    }

    //Tim kiem danh sach khach san theo quoc gia va loai phong
    public List<Hotel> searchHotels(String country, String roomType, String minPrice, String maxPrice) throws SQLException {
        List<Hotel> list = new ArrayList<>();
        String sql = "select * from hotels a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where 1=1";

        if (country != null && !country.isEmpty()) {
            sql += " and c.countryName like ?";
        }

        if (roomType != null && !roomType.isEmpty()) {
            sql += " and roomType like ?";
        }

        if (minPrice != null && !minPrice.isEmpty() && maxPrice != null && !maxPrice.isEmpty()) {
            sql += " and a.pricePerNight between ? and ?";
        } else if (minPrice != null && !minPrice.isEmpty()) {
            sql += " and a.pricePerNight >= ?";
        } else if (maxPrice != null && !maxPrice.isEmpty()) {
            sql += " and a.pricePerNight <= ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;

            if (country != null && !country.isEmpty()) {
                ps.setString(idx++, "%" + country + "%");
            }
            if (roomType != null && !roomType.isEmpty()) {
                ps.setString(idx++, "%" + roomType + "%");
            }
            if (minPrice != null && !minPrice.isEmpty() && maxPrice != null && !maxPrice.isEmpty()) {
                ps.setInt(idx++, Integer.parseInt(minPrice));
                ps.setInt(idx++, Integer.parseInt(maxPrice));
            } else if (minPrice != null && !minPrice.isEmpty()) {
                ps.setInt(idx++, Integer.parseInt(minPrice));
            } else if (maxPrice != null && !maxPrice.isEmpty()) {
                ps.setInt(idx++, Integer.parseInt(maxPrice));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Hotel h = new Hotel();
                h.setHotelId(rs.getInt("hotelId"));
                h.setHotelName(rs.getString("hotelName"));
                h.setCountryName(rs.getString("countryName"));
                h.setHotelImageUrl(rs.getString("hotelImageUrl"));
                h.setRoomType(rs.getString("roomType"));
                h.setPricePerNight(rs.getInt("pricePerNight"));
                h.setRoomAvailable(rs.getInt("roomsAvailable"));
                h.setRating(rs.getDouble("rating"));
                list.add(h);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tìm kiếm khách sạn theo quốc gia hoặc loại phòng.", e);
        }
        return list;
    }

    //Tinh tong so khach san
    public int getTotalIslands() throws SQLException {
        int total = 0;
        String sql = "select count(*) from Hotels";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tính tổng số lượng khách sạn trong cơ sở dữ liệu.", e);
        }
        return total;
    }

    //Lay danh sach dia diem noi tieng theo dao
    public List<Place> getListPlaceById(int id) throws SQLException {
        List<Place> list = new ArrayList<>();
        String sql = "select * from places a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều địa điểm
                Place place = new Place(
                        rs.getInt("placeId"),
                        rs.getInt("islandId"),
                        rs.getString("placeName"),
                        rs.getString("location"),
                        rs.getString("description"),
                        rs.getBoolean("hasTicket"),
                        rs.getInt("ticketPrice")
                );
                list.add(place);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy danh sách địa điểm nổi tiếng cho đảo có islandId = " + id, e);
        }
        return list;
    }

//     public static void main(String[] args) {
//        ServiceDao sd = new ServiceDao();
//        List<Place> place;
//        try {
//            place = sd.getListPlaceById(1);
//              System.out.println(place.toString());
//        } catch (SQLException ex) {
//            Logger.getLogger(ServiceDao.class.getName()).log(Level.SEVERE, null, ex);
//        }
//
//    }
    // ==================== HOTEL CRUD OPERATIONS ====================
    // CREATE - Them khach san moi
    public boolean createHotel(Hotel hotel) {
        String sql = "INSERT INTO Hotels (islandId, hotelName, roomType, pricePerNight, roomsAvailable, rating, hotelImageUrl, area) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, hotel.getIslandId());
            ps.setString(2, hotel.getHotelName());
            ps.setString(3, hotel.getRoomType());
            ps.setInt(4, hotel.getPricePerNight());
            ps.setInt(5, hotel.getRoomAvailable());
            ps.setDouble(6, hotel.getRating());
            ps.setString(7, hotel.getHotelImageUrl());
            ps.setInt(8, 50); // Default area value

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Lay khach san theo ID
    public Hotel getHotelById(int hotelId) {
        String sql = "SELECT h.*, i.islandName, c.countryName FROM Hotels h "
                + "JOIN Islands i ON h.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE h.hotelId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, hotelId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Hotel hotel = new Hotel();
                hotel.setHotelId(rs.getInt("hotelId"));
                hotel.setIslandId(rs.getInt("islandId"));
                hotel.setHotelName(rs.getString("hotelName"));
                hotel.setCountryName(rs.getString("countryName"));
                hotel.setHotelImageUrl(rs.getString("hotelImageUrl"));
                hotel.setRoomType(rs.getString("roomType"));
                hotel.setPricePerNight(rs.getInt("pricePerNight"));
                hotel.setRoomAvailable(rs.getInt("roomsAvailable"));
                hotel.setRating(rs.getDouble("rating"));
                return hotel;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Cap nhat thong tin khach san
    public boolean updateHotel(Hotel hotel) {
        String sql = "UPDATE Hotels SET islandId = ?, hotelName = ?, roomType = ?, pricePerNight = ?, roomsAvailable = ?, rating = ?, hotelImageUrl = ? WHERE hotelId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, hotel.getIslandId());
            ps.setString(2, hotel.getHotelName());
            ps.setString(3, hotel.getRoomType());
            ps.setInt(4, hotel.getPricePerNight());
            ps.setInt(5, hotel.getRoomAvailable());
            ps.setDouble(6, hotel.getRating());
            ps.setString(7, hotel.getHotelImageUrl());
            ps.setInt(8, hotel.getHotelId());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Xoa khach san
    public boolean deleteHotel(int hotelId) {
        String sql = "DELETE FROM Hotels WHERE hotelId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, hotelId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cap nhat so phong con trong
    public boolean updateHotelAvailability(int hotelId, int newAvailability) {
        String sql = "UPDATE Hotels SET roomsAvailable = ? WHERE hotelId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, newAvailability);
            ps.setInt(2, hotelId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== HOTEL PAGINATION METHODS ====================

    // Lay danh sach khach san theo trang voi thong tin dao
    public List<Hotel> getHotelsByPageWithIslandNames(int page, int pageSize) throws SQLException {
        List<Hotel> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT h.*, i.islandName, c.countryName FROM Hotels h " +
                     "LEFT JOIN Islands i ON h.islandId = i.islandId " +
                     "LEFT JOIN Countries c ON i.countryId = c.countryId " +
                     "ORDER BY h.hotelId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hotel h = new Hotel();
                    h.setHotelId(rs.getInt("hotelId"));
                    h.setIslandId(rs.getInt("islandId"));
                    h.setHotelName(rs.getString("hotelName"));
                    h.setCountryName(rs.getString("countryName"));
                    h.setHotelImageUrl(rs.getString("hotelImageUrl"));
                    h.setRoomType(rs.getString("roomType"));
                    h.setPricePerNight(rs.getInt("pricePerNight"));
                    h.setRoomAvailable(rs.getInt("roomsAvailable"));
                    h.setRating(rs.getDouble("rating"));
                    h.setIslandName(rs.getString("islandName"));
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting hotels by page with island names failed: " + e.getMessage());
        }
        return list;
    }

    // Dem tong so khach san
    public int getTotalHotelsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Hotels";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting total hotels count failed: " + e.getMessage());
        }
        return 0;
    }

    // Tim kiem khach san theo ten voi phan trang va ten dao
    public List<Hotel> searchHotelsByNameWithPaginationAndIslandNames(String searchTerm, int page, int pageSize) throws SQLException {
        List<Hotel> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT h.*, i.islandName, c.countryName FROM Hotels h " +
                     "LEFT JOIN Islands i ON h.islandId = i.islandId " +
                     "LEFT JOIN Countries c ON i.countryId = c.countryId " +
                     "WHERE h.hotelName LIKE ? ORDER BY h.hotelId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hotel h = new Hotel();
                    h.setHotelId(rs.getInt("hotelId"));
                    h.setIslandId(rs.getInt("islandId"));
                    h.setHotelName(rs.getString("hotelName"));
                    h.setCountryName(rs.getString("countryName"));
                    h.setHotelImageUrl(rs.getString("hotelImageUrl"));
                    h.setRoomType(rs.getString("roomType"));
                    h.setPricePerNight(rs.getInt("pricePerNight"));
                    h.setRoomAvailable(rs.getInt("roomsAvailable"));
                    h.setRating(rs.getDouble("rating"));
                    h.setIslandName(rs.getString("islandName"));
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Searching hotels by name with pagination and island names failed: " + e.getMessage());
        }
        return list;
    }

    // Dem so khach san tim duoc theo ten
    public int getSearchHotelsCount(String searchTerm) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Hotels WHERE hotelName LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Getting search hotels count failed: " + e.getMessage());
        }
        return 0;
    }

    // la danh sach ve may bay dua theo diem den
    public List<Flight> getFlightsByIslandId(int islandId) {
        List<Flight> list = new ArrayList<>();
        String sql = "SELECT * FROM Flights WHERE destinationIslandId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, islandId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Flight flight = new Flight();

                    flight.setFlightId(rs.getInt("flightId"));
                    flight.setFlightNumber(rs.getString("flightNumber"));
                    flight.setDeparture(rs.getString("departure"));
                    flight.setDestination(rs.getString("destination"));
                    flight.setBasePrice(rs.getInt("basePrice"));
                    flight.setTicketAvailable(rs.getInt("ticketAvailable"));
                    flight.setFlightType(rs.getString("flightType"));
                    flight.setFlightClass(rs.getString("flightClass"));
                    flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));

                    // Gán Airline
                    Airlines airline = new Airlines();
                    airline.setAirlineId(rs.getInt("airlineId"));
                    flight.setAirline(airline);

                    // Gán Island
                    Island island = new Island();
                    island.setIslandId(rs.getInt("destinationIslandId"));
                    flight.setDestinationIsland(island);

                    list.add(flight);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== FLIGHT CRUD OPERATIONS ====================
    // la danh sach ve may bay dua theo diem dien va flight type
    public List<Flight> getFlightTickets(int islandId, String flightType) throws SQLException {
        List<Flight> list = new ArrayList<>();

        String sql = """
    SELECT 
        f.flightId,
        f.flightNumber,
        f.departure,
        f.destinationIslandId,   
        f.destination,
        f.basePrice,
        f.ticketAvailable,
        f.flightClass,
        f.destinationImageUrl,
        
        -- Airline
        a.airlineId,
        a.airlineName,
        a.iataCode,
        a.logoUrl
    FROM Flights f
    JOIN Airlines a ON f.airlineId = a.airlineId
    WHERE f.destinationIslandId = ? AND f.flightType = ?
    ORDER BY f.basePrice ASC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, islandId);
            ps.setString(2, flightType);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // === Tạo Airline ===
                    Airlines airline = new Airlines();
                    airline.setAirlineId(rs.getInt("airlineId"));
                    airline.setAirlineName(rs.getString("airlineName"));
                    airline.setIataCode(rs.getString("iataCode"));
                    airline.setLogoUrl(rs.getString("logoUrl"));

                    // === Tạo Flight ===
                    Flight flight = new Flight();
                    flight.setFlightId(rs.getInt("flightId"));
                    flight.setFlightNumber(rs.getString("flightNumber"));
                    flight.setDeparture(rs.getString("departure"));
                    flight.setDestination(rs.getString("destination"));
                    flight.setBasePrice(rs.getInt("basePrice"));
                    flight.setTicketAvailable(rs.getInt("ticketAvailable"));
                    flight.setFlightClass(rs.getString("flightClass"));
                    flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));
                    flight.setAirline(airline);

                    // === Tạo Island ===
                    Island island = new Island();
                    island.setIslandId(rs.getInt("destinationIslandId"));
                    flight.setDestinationIsland(island);

                    list.add(flight);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        return list;
    }

    // lay list flight ticket
    public List<Flight> getAllFlightTickets() throws SQLException {
        List<Flight> list = new ArrayList<>();

        String sql = """
        SELECT 
            f.flightId,
            f.flightNumber,
            f.departure,
            f.destinationIslandId,   
            f.destination,
            f.basePrice,
            f.ticketAvailable,
            f.flightClass,
            f.destinationImageUrl,
            
            -- Airline
            a.airlineId,
            a.airlineName,
            a.iataCode,
            a.logoUrl
        FROM Flights f
        JOIN Airlines a ON f.airlineId = a.airlineId
        ORDER BY f.basePrice ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // === Tạo Airline ===
                    Airlines airline = new Airlines();
                    airline.setAirlineId(rs.getInt("airlineId"));
                    airline.setAirlineName(rs.getString("airlineName"));
                    airline.setIataCode(rs.getString("iataCode"));
                    airline.setLogoUrl(rs.getString("logoUrl"));

                    // === Tạo Flight ===
                    Flight flight = new Flight();
                    flight.setFlightId(rs.getInt("flightId"));
                    flight.setFlightNumber(rs.getString("flightNumber"));
                    flight.setDeparture(rs.getString("departure"));
                    flight.setDestination(rs.getString("destination"));
                    flight.setBasePrice(rs.getInt("basePrice"));
                    flight.setTicketAvailable(rs.getInt("ticketAvailable"));
                    flight.setFlightClass(rs.getString("flightClass"));
                    flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));
                    flight.setAirline(airline);

                    // === Tạo Island ===
                    Island island = new Island();
                    island.setIslandId(rs.getInt("destinationIslandId"));
                    flight.setDestinationIsland(island);

                    list.add(flight);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return list;
    }

    // CREATE - Them chuyen bay moi
    public int createFlight(Flight flight) throws SQLException {
        String sql = "INSERT INTO Flights (flightNumber, airlineId, departure, destination, destinationIslandId, "
                + "basePrice, ticketAvailable, flightType, flightClass, destinationImageUrl) "
                + "OUTPUT INSERTED.flightId VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, flight.getFlightNumber());
            ps.setInt(2, flight.getAirline().getAirlineId());
            ps.setString(3, flight.getDeparture());
            ps.setString(4, flight.getDestination());

            // Nếu island null thì setNull
            if (flight.getDestinationIsland() != null) {
                ps.setInt(5, flight.getDestinationIsland().getIslandId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            ps.setInt(6, flight.getBasePrice());
            ps.setInt(7, flight.getTicketAvailable());
            ps.setString(8, flight.getFlightType());
            ps.setString(9, flight.getFlightClass());
            ps.setString(10, flight.getDestinationImageUrl());

            // Thực thi và lấy ID chuyến bay mới tạo
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Creating flight failed: " + e.getMessage());
        }
        return 0; // Nếu thất bại
    }

    // check ton tai ve may bay
    public boolean isFlightExist(Flight flight) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Flights WHERE "
                + "airlineId = ? AND departure = ? AND destination = ? AND "
                + "destinationIslandId = ? AND basePrice = ? AND flightType = ? AND flightClass = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, flight.getAirline().getAirlineId());
            ps.setString(2, flight.getDeparture());
            ps.setString(3, flight.getDestination());
            ps.setInt(4, flight.getDestinationIsland().getIslandId());
            ps.setInt(5, flight.getBasePrice());
            ps.setString(6, flight.getFlightType());
            ps.setString(7, flight.getFlightClass());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // true nếu có bản ghi trùng
            }
        }
        return false;
    }

    // READ - Lay chuyen bay theo ID
    public Flight getFlightById(int flightId) {
        String sql = "SELECT f.*, a.airlineName, a.iataCode, a.logoUrl, i.islandName "
                + "FROM Flights f "
                + "JOIN Airlines a ON f.airlineId = a.airlineId "
                + "LEFT JOIN Islands i ON f.destinationIslandId = i.islandId "
                + "WHERE f.flightId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, flightId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Flight flight = new Flight();
                flight.setFlightId(rs.getInt("flightId"));
                flight.setFlightNumber(rs.getString("flightNumber"));
                flight.setDeparture(rs.getString("departure"));
                flight.setDestination(rs.getString("destination"));
                flight.setBasePrice(rs.getInt("basePrice"));
                flight.setTicketAvailable(rs.getInt("ticketAvailable"));
                flight.setFlightType(rs.getString("flightType"));
                flight.setFlightClass(rs.getString("flightClass"));
                flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));

                // Set airline
                Airlines airline = new Airlines();
                airline.setAirlineId(rs.getInt("airlineId"));
                airline.setAirlineName(rs.getString("airlineName"));
                airline.setIataCode(rs.getString("iataCode"));
                airline.setLogoUrl(rs.getString("logoUrl"));
                flight.setAirline(airline);

                // Set destination island if exists
                if (rs.getInt("destinationIslandId") != 0) {
                    Island island = new Island();
                    island.setIslandId(rs.getInt("destinationIslandId"));
                    island.setIslandName(rs.getString("islandName"));
                    flight.setDestinationIsland(island);
                }

                return flight;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Cap nhat thong tin chuyen bay
    public int updateFlight(Flight flight) throws SQLException {
        String sql = "UPDATE Flights "
                + "SET flightNumber = ?, airlineId = ?, departure = ?, destination = ?, "
                + "destinationIslandId = ?, basePrice = ?, ticketAvailable = ?, "
                + "flightType = ?, flightClass = ?, destinationImageUrl = ? "
                + "OUTPUT INSERTED.flightId "
                + "WHERE flightId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, flight.getFlightNumber());
            ps.setInt(2, flight.getAirline().getAirlineId());
            ps.setString(3, flight.getDeparture());
            ps.setString(4, flight.getDestination());

            if (flight.getDestinationIsland() != null) {
                ps.setInt(5, flight.getDestinationIsland().getIslandId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            ps.setInt(6, flight.getBasePrice());
            ps.setInt(7, flight.getTicketAvailable());
            ps.setString(8, flight.getFlightType());
            ps.setString(9, flight.getFlightClass());
            ps.setString(10, flight.getDestinationImageUrl());
            ps.setInt(11, flight.getFlightId());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // trả về flightId vừa update
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Updating flight failed: " + e.getMessage());
        }

        return 0; // nếu không có dòng nào được update
    }

    // DELETE - Xoa chuyen bay
    public int deleteFlight(int flightId) throws SQLException {
        String sql = "DELETE FROM Flights WHERE flightId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, flightId);
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return flightId; //  Trả về ID chuyến bay vừa xóa
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Deleting flight failed: " + e.getMessage());
        }
        return 0; // ❌ Không có dòng nào bị xóa
    }

    // Cap nhat so ve con lai
    public boolean updateFlightAvailability(int flightId, int newAvailability) {
        String sql = "UPDATE Flights SET ticketAvailable = ? WHERE flightId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, newAvailability);
            ps.setInt(2, flightId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lay tat ca chuyen bay
    public List<Flight> getAllFlights() {
        List<Flight> list = new ArrayList<>();
        String sql = "SELECT f.*, a.airlineName, a.iataCode, a.logoUrl, i.islandName "
                + "FROM Flights f "
                + "JOIN Airlines a ON f.airlineId = a.airlineId "
                + "LEFT JOIN Islands i ON f.destinationIslandId = i.islandId "
                + "ORDER BY f.flightId";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Flight flight = new Flight();
                flight.setFlightId(rs.getInt("flightId"));
                flight.setFlightNumber(rs.getString("flightNumber"));
                flight.setDeparture(rs.getString("departure"));
                flight.setDestination(rs.getString("destination"));
                flight.setBasePrice(rs.getInt("basePrice"));
                flight.setTicketAvailable(rs.getInt("ticketAvailable"));
                flight.setFlightType(rs.getString("flightType"));
                flight.setFlightClass(rs.getString("flightClass"));
                flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));

                // Set airline
                Airlines airline = new Airlines();
                airline.setAirlineId(rs.getInt("airlineId"));
                airline.setAirlineName(rs.getString("airlineName"));
                airline.setIataCode(rs.getString("iataCode"));
                airline.setLogoUrl(rs.getString("logoUrl"));
                flight.setAirline(airline);

                // Set destination island if exists
                if (rs.getInt("destinationIslandId") != 0) {
                    Island island = new Island();
                    island.setIslandId(rs.getInt("destinationIslandId"));
                    island.setIslandName(rs.getString("islandName"));
                    flight.setDestinationIsland(island);
                }

                list.add(flight);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== AIRLINES CRUD OPERATIONS ====================
    // CREATE - Them hang hang khong moi
    public boolean createAirline(Airlines airline) {
        String sql = "INSERT INTO Airlines (airlineName, iataCode, countryId, hotline, logoUrl) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, airline.getAirlineName());
            ps.setString(2, airline.getIataCode());
            ps.setString(4, airline.getHotline());
            ps.setString(5, airline.getLogoUrl());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Lay hang hang khong theo ID
    public Airlines getAirlineById(int airlineId) {
        String sql = "SELECT * FROM Airlines WHERE airlineId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, airlineId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Airlines airline = new Airlines();
                airline.setAirlineId(rs.getInt("airlineId"));
                airline.setAirlineName(rs.getString("airlineName"));
                airline.setIataCode(rs.getString("iataCode"));
                airline.setHotline(rs.getString("hotline"));
                airline.setLogoUrl(rs.getString("logoUrl"));

                return airline;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Cap nhat thong tin hang hang khong
    public boolean updateAirline(Airlines airline) {
        String sql = "UPDATE Airlines SET airlineName = ?, iataCode = ?, countryId = ?, hotline = ?, logoUrl = ? "
                + "WHERE airlineId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, airline.getAirlineName());
            ps.setString(2, airline.getIataCode());
            ps.setString(4, airline.getHotline());
            ps.setString(5, airline.getLogoUrl());
            ps.setInt(6, airline.getAirlineId());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Xoa hang hang khong
    public boolean deleteAirline(int airlineId) {
        String sql = "DELETE FROM Airlines WHERE airlineId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, airlineId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lay tat ca hang hang khong
    public List<Airlines> getAllAirlines() throws SQLException {
        List<Airlines> list = new ArrayList<>();
        String sql = "SELECT * FROM Airlines ORDER BY airlineName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Airlines airline = new Airlines();
                airline.setAirlineId(rs.getInt("airlineId"));
                airline.setAirlineName(rs.getString("airlineName"));
                airline.setIataCode(rs.getString("iataCode"));
                airline.setHotline(rs.getString("hotline"));
                airline.setLogoUrl(rs.getString("logoUrl"));

                list.add(airline);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // lây thong tin hang bay 
    public List<Airlines> getAllAirlineNames() throws SQLException {
        List<Airlines> list = new ArrayList<>();
        String sql = """
        SELECT MIN(airlineId) AS airlineId, airlineName
        FROM Airlines
        GROUP BY airlineName
        ORDER BY airlineName
    """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Airlines airline = new Airlines();
                airline.setAirlineId(rs.getInt("airlineId"));
                airline.setAirlineName(rs.getString("airlineName"));
                list.add(airline);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    


    // search and filter flightTicket in list

     public List<Flight> searchFlightTickets(String keyword, Integer airlineId, String priceRange) throws SQLException {
        List<Flight> flights = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT f.*, a.airlineId, a.airlineName, a.logoUrl "
                + "FROM Flights f "
                + "JOIN Airlines a ON f.airlineId = a.airlineId "
                + "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        //  1. Tìm kiếm theo keyword (departure / destination / flightNumber)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND ("
                    + "f.departure COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR "
                    + "f.destination COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR "
                    + "f.flightNumber COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR "
                    + "f.flightType COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR "
                    + "f.flightClass COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?"
                    + ")");

            String kw = "%" + keyword.trim() + "%";
            // Thêm 5 lần vì có 5 cột cần tìm
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        //  2. Lọc theo hãng bay
        if (airlineId != null) {
            sql.append(" AND f.airlineId = ?");
            params.add(airlineId);
        }

        //  3. Lọc theo khoảng giá
        if (priceRange != null && !priceRange.isEmpty()) {
            if (priceRange.equals("5000000+") || priceRange.equals("over5000000")) {
                sql.append(" AND f.basePrice > 5000000");
            } else {
                String[] range = priceRange.split("-");
                sql.append(" AND f.basePrice BETWEEN ? AND ?");
                //Gom giá trị thật vào params
                params.add(Integer.parseInt(range[0]));
                params.add(Integer.parseInt(range[1]));
            }
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                // gán giá trị thật vào ?
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    //  Gắn hãng bay
                    Airlines airline = new Airlines();
                    airline.setAirlineId(rs.getInt("airlineId"));
                    airline.setAirlineName(rs.getString("airlineName"));
                    airline.setLogoUrl(rs.getString("logoUrl"));

                    //  Gắn chuyến bay
                    Flight flight = new Flight();
                    flight.setFlightId(rs.getInt("flightId"));
                    flight.setFlightNumber(rs.getString("flightNumber"));
                    flight.setAirline(airline);
                    flight.setDeparture(rs.getString("departure"));
                    flight.setDestination(rs.getString("destination"));
                    flight.setBasePrice(rs.getInt("basePrice"));
                    flight.setFlightType(rs.getString("flightType"));
                    flight.setFlightClass(rs.getString("flightClass"));
                    flight.setTicketAvailable(rs.getInt("ticketAvailable"));
                    flight.setDestinationImageUrl(rs.getString("destinationImageUrl"));

                    flights.add(flight);
                }
            }
        }

        return flights;
    }

    // search and filter flightSchedules in list

    public List<FlightSchedule> searchFlightSchedules(String keyword, String flightType , String departureTimeRange) throws SQLException {
    List<FlightSchedule> flights = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
        "SELECT fs.*, f.flightNumber, f.flightType, f.flightClass " +
        "FROM FlightSchedules fs " +
        "JOIN Flights f ON fs.flightId = f.flightId " +
        "WHERE 1=1 "
    );

    List<Object> params = new ArrayList<>();

    // Tìm kiếm theo keyword (departureAirport / arrivalAirport / flightNumber / transitAirport / flightClass)
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append("AND (")
           .append("fs.departureAirport COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR ")
           .append("fs.arrivalAirport COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR ")
           .append("f.flightNumber COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR ")
           .append("fs.transitAirport COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? OR ")
           .append("f.flightClass COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? ")
           .append(")");
        String kw = "%" + keyword.trim() + "%";
        for (int i = 0; i < 5; i++) params.add(kw);
    }


   //Lọc theo loại chuyến bay (Một chiều / Khứ hồi)
    if (flightType != null && !flightType.trim().isEmpty()) {
        sql.append("AND f.flightType = ? ");
        params.add(flightType.trim());
    }

// lọc theo giờ khởi hành (cả lượt đi và lượt về)
if (departureTimeRange != null && !departureTimeRange.isEmpty()) {
    String[] timeRangeParts = departureTimeRange.split("-");
    if (timeRangeParts.length == 2) {
        String startTime = timeRangeParts[0].trim();
        String endTime = timeRangeParts[1].trim();
        sql.append("AND (fs.departureTime BETWEEN ? AND ? OR fs.returnDepartureTime BETWEEN ? AND ?) ");
        params.add(startTime);
        params.add(endTime);
        params.add(startTime);
        params.add(endTime);
    }
}


    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {

                // === Gắn Flight ===
                Flight flight = new Flight();
                flight.setFlightId(rs.getInt("flightId"));
                flight.setFlightNumber(rs.getString("flightNumber"));
                flight.setFlightClass(rs.getString("flightClass"));
                flight.setFlightType(rs.getString("flightType"));

                // === Gắn FlightSchedule ===
                FlightSchedule schedule = new FlightSchedule();
                schedule.setScheduleId(rs.getInt("scheduleId"));
                schedule.setFlight(flight);
                schedule.setDepartureAirport(rs.getString("departureAirport"));
                schedule.setArrivalAirport(rs.getString("arrivalAirport"));
                schedule.setTransitAirport(rs.getString("transitAirport"));
                schedule.setTransitDuration(rs.getString("transitDuration"));
                schedule.setNotes(rs.getString("notes"));

                // Giờ bay (chuyển sang LocalTime
                Time dep = rs.getTime("departureTime");
                schedule.setDepartureTime(dep != null ? dep.toLocalTime() : null);
                Time arr = rs.getTime("arrivalTime");
                schedule.setArrivalTime(arr != null ? arr.toLocalTime() : null);
                Time retDep = rs.getTime("returnDepartureTime");
                schedule.setReturnDepartureTime(retDep != null ? retDep.toLocalTime() : null);
                Time retArr = rs.getTime("returnArrivalTime");
                schedule.setReturnArrivalTime(retArr != null ? retArr.toLocalTime() : null);
                
                       // --- Xác định loại máy bay và các thông số liên quan ---
                String flightClass = rs.getString("flightClass");
                setAircraftInfo(schedule, flightClass);
               
                flights.add(schedule);
            }
        }
    }

    return flights;
}
    
    public static void main(String[] args) {
        ServiceDao dao = new ServiceDao();
        try {


                // === 1️⃣ Trường hợp test không lọc gì (hiển thị tất cả) ===
            List<Flight> f = dao.getFlightsWithoutSchedule();
            for(Flight flight :f ){
                System.out.println(flight);
            }
           

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==================== ISLAND VEHICLE CRUD OPERATIONS ====================
    // CREATE - Them phuong tien moi
    public boolean createIslandVehicle(IslandVehicle vehicle) {
        String sql = "INSERT INTO IslandVehicles (islandId, vehicleType, modelName, pricePerDay, capacity, availability) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, vehicle.getIslandId());
            ps.setString(2, vehicle.getVehicleType());
            ps.setString(3, vehicle.getModelName());
            ps.setDouble(4, vehicle.getPricePerDay());
            ps.setInt(5, vehicle.getCapacity());
            ps.setInt(6, vehicle.getAvailability());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Lay phuong tien theo ID
    public IslandVehicle getIslandVehicleById(int vehicleId) {
        String sql = "SELECT iv.*, i.islandName FROM IslandVehicles iv "
                + "JOIN Islands i ON iv.islandId = i.islandId "
                + "WHERE iv.vehicleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, vehicleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                IslandVehicle vehicle = new IslandVehicle();
                vehicle.setVehicleId(rs.getInt("vehicleId"));
                vehicle.setIslandId(rs.getInt("islandId"));
                vehicle.setVehicleType(rs.getString("vehicleType"));
                vehicle.setModelName(rs.getString("modelName"));
                vehicle.setPricePerDay(rs.getDouble("pricePerDay"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setAvailability(rs.getInt("availability"));

                // Set island name from JOIN
                vehicle.setIslandName(rs.getString("islandName"));

                // Set default values for properties not in database
                vehicle.setVehicleName(rs.getString("modelName")); // Use modelName as vehicleName
                vehicle.setBrand(""); // Default empty brand
                vehicle.setModel(rs.getString("modelName")); // Use modelName as model
                vehicle.setContactInfo(""); // Default empty contact info
                vehicle.setLocation(""); // Default empty location
                vehicle.setDescription(""); // Default empty description
                vehicle.setVehicleImageUrl(""); // Default empty image URL

                return vehicle;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Cap nhat thong tin phuong tien
    public boolean updateIslandVehicle(IslandVehicle vehicle) {
        String sql = "UPDATE IslandVehicles SET islandId = ?, vehicleType = ?, modelName = ?, "
                + "pricePerDay = ?, capacity = ?, availability = ? WHERE vehicleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, vehicle.getIslandId());
            ps.setString(2, vehicle.getVehicleType());
            ps.setString(3, vehicle.getModelName());
            ps.setDouble(4, vehicle.getPricePerDay());
            ps.setInt(5, vehicle.getCapacity());
            ps.setInt(6, vehicle.getAvailability());
            ps.setInt(7, vehicle.getVehicleId());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Xoa phuong tien
    public boolean deleteIslandVehicle(int vehicleId) {
        String sql = "DELETE FROM IslandVehicles WHERE vehicleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, vehicleId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cap nhat tinh trang phuong tien
    public boolean updateVehicleAvailability(int vehicleId, int newAvailability) {
        String sql = "UPDATE IslandVehicles SET availability = ? WHERE vehicleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, newAvailability);
            ps.setInt(2, vehicleId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lay tat ca phuong tien
    public List<IslandVehicle> getAllIslandVehicles() {
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "SELECT iv.*, i.islandName FROM IslandVehicles iv "
                + "JOIN Islands i ON iv.islandId = i.islandId "
                + "ORDER BY iv.vehicleId";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                IslandVehicle vehicle = new IslandVehicle();
                vehicle.setVehicleId(rs.getInt("vehicleId"));
                vehicle.setIslandId(rs.getInt("islandId"));
                vehicle.setVehicleType(rs.getString("vehicleType"));
                vehicle.setModelName(rs.getString("modelName"));
                vehicle.setPricePerDay(rs.getDouble("pricePerDay"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setAvailability(rs.getInt("availability"));

                // Set island name from JOIN
                vehicle.setIslandName(rs.getString("islandName"));

                // Set default values for properties not in database
                vehicle.setVehicleName(rs.getString("modelName")); // Use modelName as vehicleName
                vehicle.setBrand(""); // Default empty brand
                vehicle.setModel(rs.getString("modelName")); // Use modelName as model
                vehicle.setContactInfo(""); // Default empty contact info
                vehicle.setLocation(""); // Default empty location
                vehicle.setDescription(""); // Default empty description
                vehicle.setVehicleImageUrl(""); // Default empty image URL

                list.add(vehicle);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tim kiem phuong tien theo loai hoac model
    public List<IslandVehicle> searchIslandVehicles(String keyword) {
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "SELECT iv.*, i.islandName FROM IslandVehicles iv "
                + "JOIN Islands i ON iv.islandId = i.islandId "
                + "WHERE iv.vehicleType LIKE ? OR iv.modelName LIKE ? "
                + "ORDER BY iv.vehicleId";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                IslandVehicle vehicle = new IslandVehicle();
                vehicle.setVehicleId(rs.getInt("vehicleId"));
                vehicle.setIslandId(rs.getInt("islandId"));
                vehicle.setVehicleType(rs.getString("vehicleType"));
                vehicle.setModelName(rs.getString("modelName"));
                vehicle.setPricePerDay(rs.getDouble("pricePerDay"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setAvailability(rs.getInt("availability"));

                // Set island name from JOIN
                vehicle.setIslandName(rs.getString("islandName"));

                // Set default values for properties not in database
                vehicle.setVehicleName(rs.getString("modelName")); // Use modelName as vehicleName
                vehicle.setBrand(""); // Default empty brand
                vehicle.setModel(rs.getString("modelName")); // Use modelName as model
                vehicle.setContactInfo(""); // Default empty contact info
                vehicle.setLocation(""); // Default empty location
                vehicle.setDescription(""); // Default empty description
                vehicle.setVehicleImageUrl(""); // Default empty image URL

                list.add(vehicle);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== FLIGHT SCHEDULE CRUD OPERATIONS ====================
    // CREATE - Them lich bay moi
    public boolean createFlightSchedule(FlightSchedule schedule) {
        String sql = "INSERT INTO FlightSchedules (flightId, planeModel, departureAirport, arrivalAirport, "
                + "transitAirport, transitDuration, seatCapacity, cabinBaggage, seatPitch, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, schedule.getFlight().getFlightId());
            ps.setString(2, schedule.getPlaneModel());
            ps.setString(3, schedule.getDepartureAirport());
            ps.setString(4, schedule.getArrivalAirport());
            ps.setString(5, schedule.getTransitAirport());
            ps.setString(6, schedule.getTransitDuration());
            ps.setInt(7, schedule.getSeatCapacity());
            ps.setString(8, schedule.getCabinBaggage());
            ps.setString(9, schedule.getSeatPitch());
            ps.setString(10, schedule.getNotes());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Lay lich bay theo ID
    public FlightSchedule getFlightScheduleById(int scheduleId) {
        String sql = "SELECT fs.*, f.flightNumber, f.departure, f.destination, a.airlineName, a.iataCode, a.logoUrl " +
                    "FROM FlightSchedules fs " +
                    "JOIN Flights f ON fs.flightId = f.flightId " +
                    "JOIN Airlines a ON f.airlineId = a.airlineId " +
                    "WHERE fs.scheduleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                FlightSchedule schedule = new FlightSchedule();
                schedule.setScheduleId(rs.getInt("scheduleId"));
                schedule.setPlaneModel(rs.getString("planeModel"));
                schedule.setDepartureAirport(rs.getString("departureAirport"));
                schedule.setArrivalAirport(rs.getString("arrivalAirport"));
                schedule.setTransitAirport(rs.getString("transitAirport"));
                schedule.setTransitDuration(rs.getString("transitDuration"));
                schedule.setSeatCapacity(rs.getInt("seatCapacity"));
                schedule.setCabinBaggage(rs.getString("cabinBaggage"));
                schedule.setSeatPitch(rs.getString("seatPitch"));
                schedule.setNotes(rs.getString("notes"));

                // Set flight information
                Flight flight = new Flight();
                flight.setFlightId(rs.getInt("flightId"));
                flight.setFlightNumber(rs.getString("flightNumber"));
                flight.setDeparture(rs.getString("departure"));
                flight.setDestination(rs.getString("destination"));

                Airlines airline = new Airlines();
                airline.setAirlineName(rs.getString("airlineName"));
                airline.setIataCode(rs.getString("iataCode"));
                airline.setLogoUrl(rs.getString("logoUrl"));
                flight.setAirline(airline);

                schedule.setFlight(flight);

                return schedule;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Cap nhat thong tin lich bay
    public boolean updateFlightSchedule(FlightSchedule schedule) {
        String sql = "UPDATE FlightSchedules SET flightId = ?, planeModel = ?, departureAirport = ?, "
                + "arrivalAirport = ?, transitAirport = ?, transitDuration = ?, seatCapacity = ?, "
                + "cabinBaggage = ?, seatPitch = ?, notes = ? WHERE scheduleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, schedule.getFlight().getFlightId());
            ps.setString(2, schedule.getPlaneModel());
            ps.setString(3, schedule.getDepartureAirport());
            ps.setString(4, schedule.getArrivalAirport());
            ps.setString(5, schedule.getTransitAirport());
            ps.setString(6, schedule.getTransitDuration());
            ps.setInt(7, schedule.getSeatCapacity());
            ps.setString(8, schedule.getCabinBaggage());
            ps.setString(9, schedule.getSeatPitch());
            ps.setString(10, schedule.getNotes());
            ps.setInt(11, schedule.getScheduleId());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Xoa lich bay
    public boolean deleteFlightSchedule(int scheduleId) throws SQLException {
        String sql = "DELETE FROM FlightSchedules WHERE scheduleId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, scheduleId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lay tat ca lich bay
public List<FlightSchedule> getFlightSchedules() throws Exception {
    List<FlightSchedule> list = new ArrayList<>();
    String sql = """
        SELECT 
            fs.scheduleId,
            fs.departureAirport,
            fs.arrivalAirport,
            fs.departureTime,
            fs.arrivalTime,
            fs.returnDepartureTime,
            fs.returnArrivalTime,
            fs.transitAirport,
            fs.transitDuration,
            fs.notes,
            
            -- Flight
            f.flightId,
            f.flightNumber,
            f.flightType,       
            f.flightClass,
            f.destinationImageUrl
        FROM FlightSchedules fs
        JOIN Flights f ON fs.flightId = f.flightId
        ORDER BY fs.scheduleId
        """;

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
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

            // --- Xác định loại máy bay và các thông số liên quan ---
            String flightClass = rs.getString("flightClass");
            setAircraftInfo(schedule, flightClass);

            // --- Thông tin chuyến bay khác ---
            schedule.setDepartureAirport(rs.getString("departureAirport"));
            schedule.setArrivalAirport(rs.getString("arrivalAirport"));
            schedule.setTransitAirport(rs.getString("transitAirport"));
            schedule.setTransitDuration(rs.getString("transitDuration"));
            schedule.setNotes(rs.getString("notes"));

            list.add(schedule);
        }

    } catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    return list;
}

    
/**
 * Helper gán planeModel, seatCapacity, seatPitch, cabinBaggage dựa trên flightClass
 */
private void setAircraftInfo(FlightSchedule schedule, String flightClass) {
    if (flightClass == null) flightClass = "";
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

  //Lấy danh sách Flight chưa có lịch trình
public List<Flight> getFlightsWithoutSchedule() throws SQLException {
    List<Flight> list = new ArrayList<>();
    String sql = """
        SELECT flightId, departure , destination 
        FROM Flights
        WHERE hasSchedule = 0
        ORDER BY flightId
        """;
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Flight f = new Flight();
            f.setFlightId(rs.getInt("flightId"));
            f.setDeparture(rs.getString("departure"));
            f.setDestination(rs.getString("destination"));
            list.add(f);
        }
    }
    return list;
}




    // ==================== ISLAND CRUD OPERATIONS ====================
    // CREATE - Them dao moi
    public boolean createIsland(Island island, int countryId) {
        String sql = "INSERT INTO Islands (islandName, countryId, shortDescription, longDescription, "
                + "bestSeason, activities, imageUrl, location) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, island.getIslandName());
            ps.setInt(2, countryId);
            ps.setString(3, island.getShortDescription());
            ps.setString(4, island.getLongDescription());
            ps.setString(5, island.getBestSeason());
            ps.setString(6, island.getActivities());
            ps.setString(7, island.getImageUrl());
            ps.setString(8, island.getLocation());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Lay dao theo ID
    public Island getIslandById(int islandId) throws SQLException {
        String sql = "SELECT i.*, c.countryName "
                + "FROM Islands i "
                + "LEFT JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE i.islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, islandId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Island island = new Island();
                island.setIslandId(rs.getInt("islandId"));
                island.setIslandName(rs.getString("islandName"));
                island.setCountryName(rs.getString("countryName"));
                island.setShortDescription(rs.getString("shortDescription"));
                island.setLongDescription(rs.getString("longDescription"));
                island.setBestSeason(rs.getString("bestSeason"));
                island.setActivities(rs.getString("activities"));
                island.setImageUrl(rs.getString("imageUrl"));
                island.setLocation(rs.getString("location"));

                return island;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Cap nhat thong tin dao
    public boolean updateIsland(Island island, int countryId) {
        String sql = "UPDATE Islands SET islandName = ?, countryId = ?, shortDescription = ?, "
                + "longDescription = ?, bestSeason = ?, activities = ?, imageUrl = ?, location = ? "
                + "WHERE islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, island.getIslandName());
            ps.setInt(2, countryId);
            ps.setString(3, island.getShortDescription());
            ps.setString(4, island.getLongDescription());
            ps.setString(5, island.getBestSeason());
            ps.setString(6, island.getActivities());
            ps.setString(7, island.getImageUrl());
            ps.setString(8, island.getLocation());
            ps.setInt(9, island.getIslandId());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Xoa dao
    public boolean deleteIsland(int islandId) {
        String sql = "DELETE FROM Islands WHERE islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, islandId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lay tat ca dao
    public List<Island> getAllIslands() {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT i.*, c.countryName "
                + "FROM Islands i "
                + "LEFT JOIN Countries c ON i.countryId = c.countryId "
                + "ORDER BY i.islandName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Island island = new Island();
                island.setIslandId(rs.getInt("islandId"));
                island.setIslandName(rs.getString("islandName"));
                island.setCountryName(rs.getString("countryName"));
                island.setShortDescription(rs.getString("shortDescription"));
                island.setLongDescription(rs.getString("longDescription"));
                island.setBestSeason(rs.getString("bestSeason"));
                island.setActivities(rs.getString("activities"));
                island.setImageUrl(rs.getString("imageUrl"));
                island.setLocation(rs.getString("location"));

                list.add(island);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tim kiem dao theo ten
    public List<Island> searchIslandsByName(String searchTerm) {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT i.*, c.countryName "
                + "FROM Islands i "
                + "LEFT JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE i.islandName LIKE ? OR c.countryName LIKE ? "
                + "ORDER BY i.islandName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Island island = new Island();
                island.setIslandId(rs.getInt("islandId"));
                island.setIslandName(rs.getString("islandName"));
                island.setCountryName(rs.getString("countryName"));
                island.setShortDescription(rs.getString("shortDescription"));
                island.setLongDescription(rs.getString("longDescription"));
                island.setBestSeason(rs.getString("bestSeason"));
                island.setActivities(rs.getString("activities"));
                island.setImageUrl(rs.getString("imageUrl"));
                island.setLocation(rs.getString("location"));

                list.add(island);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== RESTAURANT CRUD OPERATIONS ====================
    // Lay tat ca nha hang
    public List<model.Restaurant> getRestaurants() {
        List<model.Restaurant> list = new ArrayList<>();
        String sql = "SELECT r.*, i.islandName, c.countryName "
                + "FROM Restaurants r "
                + "JOIN Islands i ON r.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "ORDER BY r.restaurantName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.Restaurant restaurant = new model.Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setIslandId(rs.getInt("islandId"));
                restaurant.setRestaurantName(rs.getString("restaurantName"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setPriceRange(rs.getString("priceRange"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setPhoneNumber(rs.getString("phoneNumber"));
                restaurant.setOpeningHours(rs.getString("openingHours"));
                restaurant.setCapacity(rs.getInt("capacity"));
                restaurant.setRestaurantImageUrl(rs.getString("restaurantImageUrl"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setSpecialties(rs.getString("specialties"));
                restaurant.setIslandName(rs.getString("islandName"));
                restaurant.setCountryName(rs.getString("countryName"));
                list.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay nha hang theo ID
    public model.Restaurant getRestaurantById(int restaurantId) {
        String sql = "SELECT r.*, i.islandName, c.countryName "
                + "FROM Restaurants r "
                + "JOIN Islands i ON r.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE r.restaurantId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                model.Restaurant restaurant = new model.Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setIslandId(rs.getInt("islandId"));
                restaurant.setRestaurantName(rs.getString("restaurantName"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setPriceRange(rs.getString("priceRange"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setPhoneNumber(rs.getString("phoneNumber"));
                restaurant.setOpeningHours(rs.getString("openingHours"));
                restaurant.setCapacity(rs.getInt("capacity"));
                restaurant.setRestaurantImageUrl(rs.getString("restaurantImageUrl"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setSpecialties(rs.getString("specialties"));
                restaurant.setIslandName(rs.getString("islandName"));
                restaurant.setCountryName(rs.getString("countryName"));
                return restaurant;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // CREATE - Them nha hang moi
    public boolean createRestaurant(model.Restaurant restaurant) {
        String sql = "INSERT INTO Restaurants (islandId, restaurantName, cuisineType, priceRange, rating, address, phoneNumber, openingHours, capacity, restaurantImageUrl, description, specialties) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, restaurant.getIslandId());
            ps.setString(2, restaurant.getRestaurantName());
            ps.setString(3, restaurant.getCuisineType());
            ps.setString(4, restaurant.getPriceRange());
            ps.setDouble(5, restaurant.getRating());
            ps.setString(6, restaurant.getAddress());
            ps.setString(7, restaurant.getPhoneNumber());
            ps.setString(8, restaurant.getOpeningHours());
            ps.setInt(9, restaurant.getCapacity());
            ps.setString(10, restaurant.getRestaurantImageUrl());
            ps.setString(11, restaurant.getDescription());
            ps.setString(12, restaurant.getSpecialties());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE - Cap nhat thong tin nha hang
    public boolean updateRestaurant(model.Restaurant restaurant) {
        String sql = "UPDATE Restaurants SET islandId = ?, restaurantName = ?, cuisineType = ?, priceRange = ?, rating = ?, address = ?, phoneNumber = ?, openingHours = ?, capacity = ?, restaurantImageUrl = ?, description = ?, specialties = ? WHERE restaurantId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, restaurant.getIslandId());
            ps.setString(2, restaurant.getRestaurantName());
            ps.setString(3, restaurant.getCuisineType());
            ps.setString(4, restaurant.getPriceRange());
            ps.setDouble(5, restaurant.getRating());
            ps.setString(6, restaurant.getAddress());
            ps.setString(7, restaurant.getPhoneNumber());
            ps.setString(8, restaurant.getOpeningHours());
            ps.setInt(9, restaurant.getCapacity());
            ps.setString(10, restaurant.getRestaurantImageUrl());
            ps.setString(11, restaurant.getDescription());
            ps.setString(12, restaurant.getSpecialties());
            ps.setInt(13, restaurant.getRestaurantId());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Xoa nha hang
    public boolean deleteRestaurant(int restaurantId) {
        String sql = "DELETE FROM Restaurants WHERE restaurantId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, restaurantId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Tim kiem nha hang theo ten
    public List<model.Restaurant> searchRestaurants(String searchTerm) {
        List<model.Restaurant> list = new ArrayList<>();
        String sql = "SELECT r.*, i.islandName, c.countryName "
                + "FROM Restaurants r "
                + "JOIN Islands i ON r.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE r.restaurantName LIKE ? OR r.cuisineType LIKE ? OR r.address LIKE ? "
                + "ORDER BY r.restaurantName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                model.Restaurant restaurant = new model.Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setIslandId(rs.getInt("islandId"));
                restaurant.setRestaurantName(rs.getString("restaurantName"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setPriceRange(rs.getString("priceRange"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setPhoneNumber(rs.getString("phoneNumber"));
                restaurant.setOpeningHours(rs.getString("openingHours"));
                restaurant.setCapacity(rs.getInt("capacity"));
                restaurant.setRestaurantImageUrl(rs.getString("restaurantImageUrl"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setSpecialties(rs.getString("specialties"));
                restaurant.setIslandName(rs.getString("islandName"));
                restaurant.setCountryName(rs.getString("countryName"));
                list.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay danh sach nha hang theo dao
    public List<model.Restaurant> getRestaurantsByIslandId(int islandId) {
        List<model.Restaurant> list = new ArrayList<>();
        String sql = "SELECT r.*, i.islandName, c.countryName "
                + "FROM Restaurants r "
                + "JOIN Islands i ON r.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE r.islandId = ? "
                + "ORDER BY r.restaurantName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, islandId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                model.Restaurant restaurant = new model.Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setIslandId(rs.getInt("islandId"));
                restaurant.setRestaurantName(rs.getString("restaurantName"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setPriceRange(rs.getString("priceRange"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setPhoneNumber(rs.getString("phoneNumber"));
                restaurant.setOpeningHours(rs.getString("openingHours"));
                restaurant.setCapacity(rs.getInt("capacity"));
                restaurant.setRestaurantImageUrl(rs.getString("restaurantImageUrl"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setSpecialties(rs.getString("specialties"));
                restaurant.setIslandName(rs.getString("islandName"));
                restaurant.setCountryName(rs.getString("countryName"));
                list.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    // ==================== VEHICLE PAGINATION METHODS ====================

    /**
     * Get vehicles with pagination and island names
     */
    public List<IslandVehicle> getVehiclesByPageWithIslandNames(int page, int pageSize) {
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "SELECT iv.*, i.islandName, c.countryName " +
                    "FROM IslandVehicles iv " +
                    "JOIN Islands i ON iv.islandId = i.islandId " +
                    "JOIN Countries c ON i.countryId = c.countryId " +
                    "ORDER BY iv.vehicleId " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IslandVehicle vehicle = new IslandVehicle();
                    vehicle.setVehicleId(rs.getInt("vehicleId"));
                    vehicle.setIslandId(rs.getInt("islandId"));
                    vehicle.setVehicleType(rs.getString("vehicleType"));
                    vehicle.setModelName(rs.getString("modelName"));
                    vehicle.setPricePerDay(rs.getDouble("pricePerDay"));
                    vehicle.setCapacity(rs.getInt("capacity"));
                    vehicle.setAvailability(rs.getInt("availability"));

                    // Set island and country names
                    vehicle.setIslandName(rs.getString("islandName"));
                    vehicle.setCountryName(rs.getString("countryName"));

                    // Set additional fields
                    vehicle.setVehicleName(rs.getString("modelName"));
                    vehicle.setBrand("");
                    vehicle.setModel(rs.getString("modelName"));
                    vehicle.setContactInfo("");
                    vehicle.setLocation("");
                    vehicle.setDescription("");
                    vehicle.setVehicleImageUrl("");

                    list.add(vehicle);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get total count of vehicles
     */
    public int getTotalVehiclesCount() {
        String sql = "SELECT COUNT(*) FROM IslandVehicles";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Search vehicles with pagination and island names
     */
    public List<IslandVehicle> searchVehiclesByNameWithPaginationAndIslandNames(String searchTerm, int page, int pageSize) {
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "SELECT iv.*, i.islandName, c.countryName " +
                    "FROM IslandVehicles iv " +
                    "JOIN Islands i ON iv.islandId = i.islandId " +
                    "JOIN Countries c ON i.countryId = c.countryId " +
                    "WHERE iv.vehicleType LIKE ? OR iv.modelName LIKE ? " +
                    "ORDER BY iv.vehicleId " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setInt(3, (page - 1) * pageSize);
            ps.setInt(4, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IslandVehicle vehicle = new IslandVehicle();
                    vehicle.setVehicleId(rs.getInt("vehicleId"));
                    vehicle.setIslandId(rs.getInt("islandId"));
                    vehicle.setVehicleType(rs.getString("vehicleType"));
                    vehicle.setModelName(rs.getString("modelName"));
                    vehicle.setPricePerDay(rs.getDouble("pricePerDay"));
                    vehicle.setCapacity(rs.getInt("capacity"));
                    vehicle.setAvailability(rs.getInt("availability"));

                    // Set island and country names
                    vehicle.setIslandName(rs.getString("islandName"));
                    vehicle.setCountryName(rs.getString("countryName"));

                    // Set additional fields
                    vehicle.setVehicleName(rs.getString("modelName"));
                    vehicle.setBrand("");
                    vehicle.setModel(rs.getString("modelName"));
                    vehicle.setContactInfo("");
                    vehicle.setLocation("");
                    vehicle.setDescription("");
                    vehicle.setVehicleImageUrl("");

                    list.add(vehicle);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get count of vehicles matching search term
     */
    public int getSearchVehiclesCount(String searchTerm) {
        String sql = "SELECT COUNT(*) FROM IslandVehicles " +
                    "WHERE vehicleType LIKE ? OR modelName LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

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

    // ==================== PLACE CRUD OPERATIONS ====================
    // Lay tat ca dia diem
    public List<Place> getPlaces() {
        List<Place> list = new ArrayList<>();
        String sql = "SELECT p.*, i.islandName, c.countryName "
                + "FROM Places p "
                + "JOIN Islands i ON p.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "ORDER BY p.placeName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Place place = new Place();
                place.setPlaceId(rs.getInt("placeId"));
                place.setIslandId(rs.getInt("islandId"));
                place.setPlaceName(rs.getString("placeName"));
                place.setLocation(rs.getString("location"));
                place.setDescription(rs.getString("description"));
                place.setHasTicket(rs.getBoolean("hasTicket"));
                place.setTicketPrice(rs.getInt("ticketPrice"));
                place.setIslandName(rs.getString("islandName"));
                list.add(place);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay dia diem theo ID
    public Place getPlaceById(int placeId) {
        String sql = "SELECT p.*, i.islandName, c.countryName "
                + "FROM Places p "
                + "JOIN Islands i ON p.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE p.placeId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, placeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Place place = new Place();
                place.setPlaceId(rs.getInt("placeId"));
                place.setIslandId(rs.getInt("islandId"));
                place.setPlaceName(rs.getString("placeName"));
                place.setLocation(rs.getString("location"));
                place.setDescription(rs.getString("description"));
                place.setHasTicket(rs.getBoolean("hasTicket"));
                place.setTicketPrice(rs.getInt("ticketPrice"));
                place.setIslandName(rs.getString("islandName"));
                return place;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Them dia diem moi
    public boolean addPlace(Place place) {
        String sql = "INSERT INTO Places (islandId, placeName, location, description, hasTicket, ticketPrice) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, place.getIslandId());
            ps.setString(2, place.getPlaceName());
            ps.setString(3, place.getLocation());
            ps.setString(4, place.getDescription());
            ps.setBoolean(5, place.isHasTicket());
            ps.setInt(6, place.getTicketPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cap nhat dia diem
    public boolean updatePlace(Place place) {
        String sql = "UPDATE Places SET islandId = ?, placeName = ?, location = ?, "
                + "description = ?, hasTicket = ?, ticketPrice = ? WHERE placeId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, place.getIslandId());
            ps.setString(2, place.getPlaceName());
            ps.setString(3, place.getLocation());
            ps.setString(4, place.getDescription());
            ps.setBoolean(5, place.isHasTicket());
            ps.setInt(6, place.getTicketPrice());
            ps.setInt(7, place.getPlaceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoa dia diem
    public boolean deletePlace(int placeId) {
        String sql = "DELETE FROM Places WHERE placeId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, placeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tim kiem dia diem theo ten
    public List<Place> searchPlaces(String searchTerm) {
        List<Place> list = new ArrayList<>();
        String sql = "SELECT p.*, i.islandName, c.countryName "
                + "FROM Places p "
                + "JOIN Islands i ON p.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE p.placeName LIKE ? OR p.location LIKE ? OR p.description LIKE ? "
                + "ORDER BY p.placeName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Place place = new Place();
                place.setPlaceId(rs.getInt("placeId"));
                place.setIslandId(rs.getInt("islandId"));
                place.setPlaceName(rs.getString("placeName"));
                place.setLocation(rs.getString("location"));
                place.setDescription(rs.getString("description"));
                place.setHasTicket(rs.getBoolean("hasTicket"));
                place.setTicketPrice(rs.getInt("ticketPrice"));
                place.setIslandName(rs.getString("islandName"));
                list.add(place);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay danh sach dia diem theo dao
    public List<Place> getPlacesByIslandId(int islandId) {
        List<Place> list = new ArrayList<>();
        String sql = "SELECT p.*, i.islandName, c.countryName "
                + "FROM Places p "
                + "JOIN Islands i ON p.islandId = i.islandId "
                + "JOIN Countries c ON i.countryId = c.countryId "
                + "WHERE p.islandId = ? "
                + "ORDER BY p.placeName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, islandId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Place place = new Place();
                place.setPlaceId(rs.getInt("placeId"));
                place.setIslandId(rs.getInt("islandId"));
                place.setPlaceName(rs.getString("placeName"));
                place.setLocation(rs.getString("location"));
                place.setDescription(rs.getString("description"));
                place.setHasTicket(rs.getBoolean("hasTicket"));
                place.setTicketPrice(rs.getInt("ticketPrice"));
                list.add(place);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    // ==================== PLACE PAGINATION METHODS ====================

    /**
     * Get places with pagination and island names
     */
    public List<Place> getPlacesByPageWithIslandNames(int page, int pageSize) {
        List<Place> list = new ArrayList<>();
        String sql = "SELECT p.*, i.islandName, c.countryName " +
                    "FROM Places p " +
                    "JOIN Islands i ON p.islandId = i.islandId " +
                    "JOIN Countries c ON i.countryId = c.countryId " +
                    "ORDER BY p.placeName " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Place place = new Place();
                    place.setPlaceId(rs.getInt("placeId"));
                    place.setIslandId(rs.getInt("islandId"));
                    place.setPlaceName(rs.getString("placeName"));
                    place.setLocation(rs.getString("location"));
                    place.setDescription(rs.getString("description"));
                    place.setHasTicket(rs.getBoolean("hasTicket"));
                    place.setTicketPrice(rs.getInt("ticketPrice"));

                    // Set island and country names
                    place.setIslandName(rs.getString("islandName"));
                    place.setCountryName(rs.getString("countryName"));

                    list.add(place);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get total count of places
     */
    public int getTotalPlacesCount() {
        String sql = "SELECT COUNT(*) FROM Places";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Search places with pagination and island names
     */
    public List<Place> searchPlacesByNameWithPaginationAndIslandNames(String searchTerm, int page, int pageSize) {
        List<Place> list = new ArrayList<>();
        String sql = "SELECT p.*, i.islandName, c.countryName " +
                    "FROM Places p " +
                    "JOIN Islands i ON p.islandId = i.islandId " +
                    "JOIN Countries c ON i.countryId = c.countryId " +
                    "WHERE p.placeName LIKE ? OR p.location LIKE ? OR p.description LIKE ? " +
                    "ORDER BY p.placeName " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, (page - 1) * pageSize);
            ps.setInt(5, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Place place = new Place();
                    place.setPlaceId(rs.getInt("placeId"));
                    place.setIslandId(rs.getInt("islandId"));
                    place.setPlaceName(rs.getString("placeName"));
                    place.setLocation(rs.getString("location"));
                    place.setDescription(rs.getString("description"));
                    place.setHasTicket(rs.getBoolean("hasTicket"));
                    place.setTicketPrice(rs.getInt("ticketPrice"));

                    // Set island and country names
                    place.setIslandName(rs.getString("islandName"));
                    place.setCountryName(rs.getString("countryName"));

                    list.add(place);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get count of places matching search term
     */
    public int getSearchPlacesCount(String searchTerm) {
        String sql = "SELECT COUNT(*) FROM Places " +
                    "WHERE placeName LIKE ? OR location LIKE ? OR description LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

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

    // ==================== TOUR SERVICE OPERATIONS ====================

    // Lay tat ca services theo islandId (Hotels, Restaurants, Places, Vehicles)
    public List<TourService> getServicesByIslandId(int islandId) {
        List<TourService> services = new ArrayList<>();

        // Get Hotels
        try {
            List<Hotel> hotels = getListHotelsById(islandId);
            for (Hotel hotel : hotels) {
                TourService service = new TourService();
                service.setServiceType("Hotel");
                service.setServiceId(hotel.getHotelId());
                service.setServiceName(hotel.getHotelName());
                service.setServiceDescription("Room Type: " + hotel.getRoomType());
                service.setServicePrice(hotel.getPricePerNight());
                service.setServiceImageUrl(hotel.getHotelImageUrl());
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Get Restaurants
        List<model.Restaurant> restaurants = getRestaurantsByIslandId(islandId);
        for (model.Restaurant restaurant : restaurants) {
            TourService service = new TourService();
            service.setServiceType("Restaurant");
            service.setServiceId(restaurant.getRestaurantId());
            service.setServiceName(restaurant.getRestaurantName());
            service.setServiceDescription(restaurant.getCuisineType() + " - " + restaurant.getPriceRange());
            service.setServicePrice(0); // Restaurants don't have fixed price
            service.setServiceImageUrl(restaurant.getRestaurantImageUrl());
            services.add(service);
        }

        // Get Places
        List<Place> places = getPlacesByIslandId(islandId);
        for (Place place : places) {
            TourService service = new TourService();
            service.setServiceType("Place");
            service.setServiceId(place.getPlaceId());
            service.setServiceName(place.getPlaceName());
            service.setServiceDescription(place.getDescription());
            service.setServicePrice(place.getTicketPrice());
            service.setServiceImageUrl(""); // Places don't have image URL in current model
            services.add(service);
        }

        // Get Vehicles
        try {
            List<IslandVehicle> vehicles = getListVehicleById(islandId);
            for (IslandVehicle vehicle : vehicles) {
                TourService service = new TourService();
                service.setServiceType("Vehicle");
                service.setServiceId(vehicle.getVehicleId());
                service.setServiceName(vehicle.getVehicleType() + " - " + vehicle.getModelName());
                service.setServiceDescription("Capacity: " + vehicle.getCapacity() + " people");
                service.setServicePrice((int) vehicle.getPricePerDay());
                service.setServiceImageUrl(""); // Vehicles don't have image URL in current model
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    // Them service vao tour
    public boolean addServiceToTour(int tourId, String serviceType, int serviceId) {
        String sql = "INSERT INTO TourServices (tourId, serviceType, serviceId, createdAt) VALUES (?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tourId);
            ps.setString(2, serviceType);
            ps.setInt(3, serviceId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xoa service khoi tour
    public boolean removeServiceFromTour(int tourServiceId) {
        String sql = "DELETE FROM TourServices WHERE tourServiceId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tourServiceId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lay tat ca services cua mot tour
    public List<TourService> getServicesByTourId(int tourId) {
        List<TourService> services = new ArrayList<>();
        String sql = "SELECT ts.*, " +
                    "CASE " +
                    "WHEN UPPER(ts.serviceType) = 'HOTEL' THEN h.hotelName " +
                    "WHEN UPPER(ts.serviceType) = 'RESTAURANT' THEN r.restaurantName " +
                    "WHEN UPPER(ts.serviceType) = 'PLACE' THEN p.placeName " +
                    "WHEN UPPER(ts.serviceType) = 'VEHICLE' THEN CONCAT(v.vehicleType, ' - ', v.modelName) " +
                    "END as serviceName, " +
                    "CASE " +
                    "WHEN UPPER(ts.serviceType) = 'HOTEL' THEN h.hotelImageUrl " +
                    "WHEN UPPER(ts.serviceType) = 'RESTAURANT' THEN r.restaurantImageUrl " +
                    "ELSE '' " +
                    "END as serviceImageUrl, " +
                    "CASE " +
                    "WHEN UPPER(ts.serviceType) = 'HOTEL' THEN h.pricePerNight " +
                    "WHEN UPPER(ts.serviceType) = 'PLACE' THEN p.ticketPrice " +
                    "WHEN UPPER(ts.serviceType) = 'VEHICLE' THEN v.pricePerDay " +
                    "ELSE 0 " +
                    "END as servicePrice " +
                    "FROM TourServices ts " +
                    "LEFT JOIN Hotels h ON UPPER(ts.serviceType) = 'HOTEL' AND ts.serviceId = h.hotelId " +
                    "LEFT JOIN Restaurants r ON UPPER(ts.serviceType) = 'RESTAURANT' AND ts.serviceId = r.restaurantId " +
                    "LEFT JOIN Places p ON UPPER(ts.serviceType) = 'PLACE' AND ts.serviceId = p.placeId " +
                    "LEFT JOIN IslandVehicles v ON UPPER(ts.serviceType) = 'VEHICLE' AND ts.serviceId = v.vehicleId " +
                    "WHERE ts.tourId = ? " +
                    "ORDER BY ts.createdAt";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TourService service = new TourService();
                service.setTourServiceId(rs.getInt("tourServiceId"));
                service.setTourId(rs.getInt("tourId"));
                service.setServiceType(rs.getString("serviceType"));
                service.setServiceId(rs.getInt("serviceId"));
                service.setCreatedAt(rs.getTimestamp("createdAt"));
                service.setServiceName(rs.getString("serviceName"));
                service.setServiceImageUrl(rs.getString("serviceImageUrl"));
                service.setServicePrice(rs.getInt("servicePrice"));
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    // Kiem tra xem service da duoc them vao tour chua
    public boolean isServiceInTour(int tourId, String serviceType, int serviceId) {
        String sql = "SELECT COUNT(*) FROM TourServices WHERE tourId = ? AND serviceType = ? AND serviceId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tourId);
            ps.setString(2, serviceType);
            ps.setInt(3, serviceId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoa tat ca services cua mot tour
    public boolean clearTourServices(int tourId) {
        String sql = "DELETE FROM TourServices WHERE tourId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tourId);

            int result = ps.executeUpdate();
            return result >= 0; // Return true even if no services were deleted (0 rows affected)
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


}
