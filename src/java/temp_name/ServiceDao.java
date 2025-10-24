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
import model.Airlines;
import model.Flight;
import model.Hotel;
import model.Island;
import model.IslandVehicle;
import utils.DBContext;
import java.sql.Time;
import model.FlightSchedule;


/**
 *
 * @author Admin
 */
public class ServiceDao extends DBContext{
  public static final ServiceDao INSTANCE = new ServiceDao();
    
    //Lay danh sach phuong tien theo dao
    public List<IslandVehicle> getListVehicleById(int id) {
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "select * from IslandVehicles a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id); 
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều island
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; 
    }
    
    //Lay tat ca khach san
      public List<Hotel> getHotels() {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
      //lay danh sach dao theo dao
     public List<Hotel> getListHotelsById(int id) {
        List<Hotel> list = new ArrayList<>();
        String sql = "select * from hotels a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id); 
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều island
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; 
    }
     
     
     //Tim kiem danh sach khach san theo quoc gia va loai phong
    public List<Hotel> searchHotels(String country, String roomType, String minPrice, String maxPrice) {
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

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //Lay danh sach khach san theo tung trang
    public List<Hotel> getIslandsByPage(int page, int pageSize) {
        List<Hotel> list = new ArrayList<>();
        String sql = "Select * from Hotels order by hotelId offset ? rows fetch next ? rows only";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize); 
            ps.setInt(2, pageSize);              
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Hotel(
                        rs.getInt("hotelId"),
                        rs.getInt("islandId"),
                        rs.getString("hotelName"),
                        rs.getString("country"),
                        rs.getString("hotelImageUrl"),
                        rs.getString("roomType"),
                        rs.getInt("pricePerNight"),
                        rs.getInt("roomAvailable"),
                        rs.getDouble("rating")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    //Tinh tong so khach san
    public int getTotalIslands() {
        int total = 0;
        String sql = "select count(*) from Hotels";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
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


                // Chuyển từ  Time sang LocalTime
                flight.setDepartureTime(rs.getTime("departureTime").toLocalTime());
                flight.setArrivalTime(rs.getTime("arrivalTime").toLocalTime());

                // Xử lý giá trị null cho chiều về
                Time returnDep = rs.getTime("returnDepartureTime");
                flight.setReturnDepartureTime(returnDep != null ? returnDep.toLocalTime() : null);

                Time returnArr = rs.getTime("returnArrivalTime");
                flight.setReturnArrivalTime(returnArr != null ? returnArr.toLocalTime() : null);

                list.add(flight);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
   

   
 // la danh sach ve may bay dua theo diem den  logo , maCode

   public List<FlightSchedule> getFlightSchedules(int islandId, String flightType) throws Exception {
    List<FlightSchedule> list = new ArrayList<>();
    
    String sql = """
        SELECT 
            fs.scheduleId,
            fs.planeModel,
            fs.departureAirport,
            fs.arrivalAirport,
            fs.transitAirport,
            fs.transitDuration,
            fs.notes,
            
            -- Flight
            f.flightId,
            f.flightNumber,
            f.departure,
            f.destinationIslandId,   
            f.destination,
            f.basePrice,
            f.ticketAvailable,
            f.flightClass,
            f.destinationImageUrl,
            f.departureTime,
            f.arrivalTime,
            f.returnDepartureTime,
            f.returnArrivalTime,
            
            -- Airline
            a.airlineId,
            a.airlineName,
            a.iataCode,
            a.logoUrl
        FROM FlightSchedules fs
        JOIN Flights f ON fs.flightId = f.flightId
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
                
                
                
                // Thời gian
                Time dep = rs.getTime("departureTime");
                flight.setDepartureTime(dep != null ? dep.toLocalTime() : null);
                Time arr = rs.getTime("arrivalTime");
                flight.setArrivalTime(arr != null ? arr.toLocalTime() : null);
                // Xử lý giá trị null cho chiều về
                Time retDep = rs.getTime("returnDepartureTime");
                flight.setReturnDepartureTime(retDep != null ? retDep.toLocalTime() : null);
                Time retArr = rs.getTime("returnArrivalTime");
                flight.setReturnArrivalTime(retArr != null ? retArr.toLocalTime() : null);

                // === Tạo FlightSchedule ===
                FlightSchedule schedule = new FlightSchedule();
                schedule.setScheduleId(rs.getInt("scheduleId"));
                schedule.setFlight(flight);
                schedule.setPlaneModel(rs.getString("planeModel"));
                
                // --- Xác định sức chứa theo loại máy bay ---
                String model = rs.getString("planeModel");
                int capacity = 0;

                if (model != null) {
                    switch (model.trim()) {
                        case "Airbus A320":
                            capacity = 180;
                            break;
                        case "Airbus A321":
                            capacity = 200;
                            break;
                        case "Airbus A321neo":
                            capacity = 206;
                            break;
                        case "Airbus A319":
                            capacity = 144;
                            break;
                        case "Boeing 737 MAX 8":
                            capacity = 178;
                            break;
                        case "Boeing 737 MAX 9":
                            capacity = 193;
                            break;
                        case "Boeing 737-800":
                            capacity = 189;
                            break;
                        case "ATR 72-600":
                            capacity = 70;
                            break;
                        default:
                            capacity = 150; // fallback 
                            break;
                    }
                }
                schedule.setSeatCapacity(capacity);
                
                
                // === Hành lý và khoảng cách ghế ===
                String baggage = "7 kg";
                String pitch = "Không rõ";
                String flightClass = rs.getString("flightClass");
                String airlineName = rs.getString("airlineName");

                if (airlineName != null && !airlineName.isBlank()) {
                    String flightClassName = (flightClass != null) ? flightClass.trim() : "";

                    if (airlineName.contains("Vietnam Airlines")) {
                        switch (flightClassName) {
                            case "Thương gia":
                                baggage = "12 kg";
                                break;
                            case "Phổ thông":
                                baggage = "7 kg";
                                break;
                            default:
                                baggage = "7 kg";
                        }
                    } else if (airlineName.contains("Bamboo Airways")) {
                        switch (flightClassName) {
                            case "Thương gia":
                                baggage = "14 kg";
                                break;
                            case "Phổ thông":
                                baggage = "7 kg";
                                break;
                            default:
                                baggage = "7 kg";
                        }
                    } else if (airlineName.contains("VietJet Air") || airlineName.contains("Vietjet")) {
                        switch (flightClassName) {
                            case "Thương gia":
                                baggage = "10 kg"; // SkyBoss+
                                break;
                            case "Phổ thông":
                                baggage = "7 kg";
                                break;
                            default:
                                baggage = "7 kg";
                        }
                    }
                }

                if (model != null) {
                    switch (model.trim()) {
                        case "Airbus A320":
                        case "Airbus A319":
                            pitch = "30 inch (tiêu chuẩn)";
                            break;
                        case "Airbus A321":
                        case "Airbus A321neo":
                            pitch = "32 inch (rộng hơn trung bình)";
                            break;
                        case "Boeing 737 MAX 8":
                        case "Boeing 737-800":
                            pitch = "30 inch (tiêu chuẩn)";
                            break;
                        case "Boeing 737 MAX 9":
                            pitch = "31 inch (hơi rộng)";
                            break;
                        case "ATR 72-600":
                            pitch = "29 inch (ngắn hơn tiêu chuẩn)";
                            break;
                    }
                }

                schedule.setCabinBaggage(baggage);
                schedule.setSeatPitch(pitch);

                schedule.setDepartureAirport(rs.getString("departureAirport"));
                schedule.setArrivalAirport(rs.getString("arrivalAirport"));
                schedule.setTransitAirport(rs.getString("transitAirport"));
                schedule.setTransitDuration(rs.getString("transitDuration"));
                schedule.setNotes(rs.getString("notes"));

                list.add(schedule);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    return list;
}
   
   

    public static void main(String[] args) {
          ServiceDao dao = new   ServiceDao();

        
        int islandId = 1;
      try{
           List<FlightSchedule> flights = dao.getFlightSchedules(islandId, "Một chiều");
           
            System.out.println("=== DANH SÁCH CHUYẾN BAY ĐẾN ISLAND ID " + islandId + " ===");
        for (FlightSchedule f : flights) {
            System.out.println(f);
        }

        if (flights.isEmpty()) {
            System.out.println("⚠️ Không có chuyến bay nào đến đảo này!");
        }
           
           
      }catch(Exception e){
          System.out.println(e);
      }
       
       
    }
    }
    

