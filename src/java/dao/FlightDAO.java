package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Flight;
import utils.DBContext;  // Sử dụng DBContext mà bạn đã tạo

public class FlightDAO {

    // Phương thức lấy tất cả chuyến bay với phân trang (mỗi trang 5 chuyến bay)
    public List<Flight> getAllFlightsWithPagination(int pageNumber) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flights ORDER BY departureTime OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        
        try (Connection conn = new DBContext().connection;
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Tính toán OFFSET: (pageNumber - 1) * 5
            int offset = (pageNumber - 1) * 5;
            stmt.setInt(1, offset);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int flightId = rs.getInt("flightId");
                    String flightNumber = rs.getString("flightNumber");
                    int airlineId = rs.getInt("airlineId");
                    String departure = rs.getString("departure");
                    String destination = rs.getString("destination");
                    int destinationIslandId = rs.getInt("destinationIslandId");
                    Timestamp departureTime = rs.getTimestamp("departureTime");
                    Timestamp arrivalTime = rs.getTimestamp("arrivalTime");
                    double price = rs.getDouble("price");

                    Flight flight = new Flight(flightId, flightNumber, airlineId, departure, 
                                                destination, destinationIslandId, departureTime, 
                                                arrivalTime, price);
                    flights.add(flight);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }

    // Phương thức lấy tổng số chuyến bay (để tính tổng số trang)
    public int getTotalFlights() {
        int totalFlights = 0;
        String sql = "SELECT COUNT(*) FROM Flights";

        try (Connection conn = new DBContext().connection;
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                totalFlights = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalFlights;
    }
}