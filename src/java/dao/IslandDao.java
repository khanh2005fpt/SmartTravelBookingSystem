/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Island;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class IslandDao extends DBContext {

    public List<Island> getIslands() {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Island i = new Island();
                i.setIslandId(rs.getInt("islandId"));
                i.setIslandName(rs.getString("islandName"));
                i.setCountry(rs.getString("country"));
                i.setDescription(rs.getString("description"));
                i.setBestSeason(rs.getString("bestSeason"));
                i.setActivities(rs.getString("activities"));
                i.setImageUrl(rs.getString("imageUrl"));
                list.add(i);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Island getIslandById(int id) {
        String sql = "SELECT * FROM Islands WHERE islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id); 
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { // chỉ cần lấy 1 island thôi
                Island i = new Island();
                i.setIslandId(rs.getInt("islandId"));
                i.setIslandName(rs.getString("islandName"));
                i.setCountry(rs.getString("country"));
                i.setDescription(rs.getString("description"));
                i.setBestSeason(rs.getString("bestSeason"));
                i.setActivities(rs.getString("activities"));
                i.setImageUrl(rs.getString("imageUrl"));
                return i; // trả về Island
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // không tìm thấy thì trả về null
    }

    public List<Island> searchIslands(String name, String country, String season) {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands WHERE 1=1";

        if (name != null && !name.isEmpty()) {
            sql += " AND islandName LIKE ?";
        }
        if (country != null && !country.isEmpty()) {
            sql += " AND country LIKE ?";
        }
        if (season != null && !season.isEmpty()) {
            sql += " AND bestSeason = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            int idx = 1;
            if (name != null && !name.isEmpty()) {
                ps.setString(idx++, "%" + name + "%");
            }
            if (country != null && !country.isEmpty()) {
                ps.setString(idx++, "%" + country + "%");
            }
            if (season != null && !season.isEmpty()) {
                ps.setString(idx++, season);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Island(
                        rs.getInt("islandId"),
                        rs.getString("islandName"),
                        rs.getString("country"),
                        rs.getString("description"),
                        rs.getString("bestSeason"),
                        rs.getString("activities"),
                        rs.getString("imageUrl")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Island> getIslandsByPage(int page, int pageSize) {
        List<Island> list = new ArrayList<>();
        String sql = "Select * from Islands order by islandId offset ? rows fetch next ? rows only";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize); // OFFSET
            ps.setInt(2, pageSize);              // FETCH NEXT
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Island(
                        rs.getInt("islandId"),
                        rs.getString("islandName"),
                        rs.getString("country"),
                        rs.getString("description"),
                        rs.getString("bestSeason"),
                        rs.getString("activities"),
                        rs.getString("imageUrl")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getTotalIslands() {
        int total = 0;
        String sql = "select count(*) from Islands";
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

    public static void main(String[] args) {
        IslandDao id = new IslandDao();
        List<Island> i = id.searchIslands("", "", "Xuân");
        System.out.println(i.toString());
    }
}
