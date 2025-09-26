package dao;

import model.Island;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IslandDAO {

    // Lấy tất cả islands
    public List<Island> getAllIslands() {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands";
        try (Connection conn = new DBContext().connection;
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Island island = new Island(
                        rs.getInt("islandId"),
                        rs.getString("islandName"),
                        rs.getString("country"),
                        rs.getString("description"),
                        rs.getString("bestSeason"),
                        rs.getString("activities"),
                        rs.getString("imageUrl")
                );
                list.add(island);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 island theo id
    public Island getIslandById(int id) {
        String sql = "SELECT * FROM Islands WHERE islandId=?";
        try (Connection conn = new DBContext().connection;
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Island(
                            rs.getInt("islandId"),
                            rs.getString("islandName"),
                            rs.getString("country"),
                            rs.getString("description"),
                            rs.getString("bestSeason"),
                            rs.getString("activities"),
                            rs.getString("imageUrl")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
