package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Flight;
import utils.DBContext;

public class FlightDAO {

    // Phương thức lấy tất cả chuyến bay với phân trang (mỗi trang 5 chuyến bay)
    public List<Flight> getAllFlightsWithPagination(int pageNumber) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flights ORDER BY departureTime OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                totalFlights = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalFlights;
    }

// Thêm chuyến bay
    public boolean addFlight(Flight flight) {
        String sql = "INSERT INTO Flights (flightNumber, airlineId, departure, destination, "
                + "destinationIslandId, departureTime, arrivalTime, price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, flight.getFlightNumber());
            stmt.setInt(2, flight.getAirlineId());
            stmt.setString(3, flight.getDeparture());
            stmt.setString(4, flight.getDestination());

            if (flight.getDestinationIslandId() != null) {
                stmt.setInt(5, flight.getDestinationIslandId());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }

            stmt.setTimestamp(6, new java.sql.Timestamp(flight.getDepartureTime().getTime()));
            stmt.setTimestamp(7, new java.sql.Timestamp(flight.getArrivalTime().getTime()));
            stmt.setDouble(8, flight.getPrice());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Lấy 1 chuyến bay theo id (cho update)
    public Flight getFlightById(int id) {
        String sql = "SELECT * FROM Flights WHERE flightId=?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Flight(
                            rs.getInt("flightId"),
                            rs.getString("flightNumber"),
                            rs.getInt("airlineId"),
                            rs.getString("departure"),
                            rs.getString("destination"),
                            (rs.getObject("destinationIslandId") != null ? rs.getInt("destinationIslandId") : null),
                            rs.getTimestamp("departureTime"),
                            rs.getTimestamp("arrivalTime"),
                            rs.getDouble("price")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// Cập nhật
    public boolean updateFlight(Flight flight) {
        String sql = "UPDATE Flights SET flightNumber=?, airlineId=?, departure=?, destination=?, "
                + "destinationIslandId=?, departureTime=?, arrivalTime=?, price=? WHERE flightId=?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, flight.getFlightNumber());
            stmt.setInt(2, flight.getAirlineId());
            stmt.setString(3, flight.getDeparture());
            stmt.setString(4, flight.getDestination());

            if (flight.getDestinationIslandId() != null) {
                stmt.setInt(5, flight.getDestinationIslandId());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }

            stmt.setTimestamp(6, new java.sql.Timestamp(flight.getDepartureTime().getTime()));
            stmt.setTimestamp(7, new java.sql.Timestamp(flight.getArrivalTime().getTime()));
            stmt.setDouble(8, flight.getPrice());
            stmt.setInt(9, flight.getFlightId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Xóa
    public boolean deleteFlight(int id) {
        String sql = "DELETE FROM Flights WHERE flightId=?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra flightNumber đã tồn tại chưa (ngoại trừ 1 flightId nhất định khi update)
    public boolean existsFlightNumber(String flightNumber, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Flights WHERE flightNumber = ? AND flightId <> ?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, flightNumber);
            stmt.setInt(2, excludeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách tất cả số hiệu chuyến bay (distinct)
    public List<String> getAllFlightNumbers() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT flightNumber FROM Flights ORDER BY flightNumber";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("flightNumber"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// Tìm chuyến bay theo số hiệu
    public List<Flight> searchByFlightNumber(String flightNumber) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flights WHERE flightNumber = ?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, flightNumber);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    flights.add(new Flight(
                            rs.getInt("flightId"),
                            rs.getString("flightNumber"),
                            rs.getInt("airlineId"),
                            rs.getString("departure"),
                            rs.getString("destination"),
                            rs.getObject("destinationIslandId") != null ? rs.getInt("destinationIslandId") : null,
                            rs.getTimestamp("departureTime"),
                            rs.getTimestamp("arrivalTime"),
                            rs.getDouble("price")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }

    // Tìm chuyến bay theo hãng bay
    public List<Flight> searchByAirline(int airlineId) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flights WHERE airlineId = ?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, airlineId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    flights.add(new Flight(
                            rs.getInt("flightId"),
                            rs.getString("flightNumber"),
                            rs.getInt("airlineId"),
                            rs.getString("departure"),
                            rs.getString("destination"),
                            rs.getObject("destinationIslandId") != null ? rs.getInt("destinationIslandId") : null,
                            rs.getTimestamp("departureTime"),
                            rs.getTimestamp("arrivalTime"),
                            rs.getDouble("price")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }

    public List<Flight> searchByRoute(String departure, String destination) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flights WHERE 1=1";
        if (departure != null && !departure.isEmpty()) {
            sql += " AND departure LIKE ?";
        }
        if (destination != null && !destination.isEmpty()) {
            sql += " AND destination LIKE ?";
        }
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {

            int index = 1;
            if (departure != null && !departure.isEmpty()) {
                stmt.setString(index++, "%" + departure + "%"); // tìm gần đúng
            }
            if (destination != null && !destination.isEmpty()) {
                stmt.setString(index++, "%" + destination + "%");
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    flights.add(new Flight(
                            rs.getInt("flightId"),
                            rs.getString("flightNumber"),
                            rs.getInt("airlineId"),
                            rs.getString("departure"),
                            rs.getString("destination"),
                            rs.getObject("destinationIslandId") != null ? rs.getInt("destinationIslandId") : null,
                            rs.getTimestamp("departureTime"),
                            rs.getTimestamp("arrivalTime"),
                            rs.getDouble("price")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }

}
