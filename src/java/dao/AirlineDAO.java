package dao;

import model.Airline;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AirlineDAO {

    // Lấy tất cả airlines
    public List<Airline> getAllAirlines() {
        List<Airline> list = new ArrayList<>();
        String sql = "SELECT * FROM Airlines";
        try (Connection conn = new DBContext().connection;
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Airline airline = new Airline(
                        rs.getInt("airlineId"),
                        rs.getString("airlineName"),
                        rs.getString("iataCode"),
                        rs.getString("country"),
                        rs.getString("hotline"),
                        rs.getString("logoUrl")
                );
                list.add(airline);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 airline theo id
    public Airline getAirlineById(int id) {
        String sql = "SELECT * FROM Airlines WHERE airlineId=?";
        try (Connection conn = new DBContext().connection;
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Airline(
                            rs.getInt("airlineId"),
                            rs.getString("airlineName"),
                            rs.getString("iataCode"),
                            rs.getString("country"),
                            rs.getString("hotline"),
                            rs.getString("logoUrl")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
