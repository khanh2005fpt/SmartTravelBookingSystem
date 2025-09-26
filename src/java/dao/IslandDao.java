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
import model.Country;

/**
 *
 * @author Admin
 */
public class IslandDao extends DBContext {

    public List<Country> getAllCountries() {
        List<Country> list = new ArrayList<>();
        String sql = "SELECT * FROM Countries";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Country c = new Country();
                c.setCountryId(rs.getInt("countryId"));
                c.setCountryName(rs.getString("countryName"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Island> getIslands() {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Island i = new Island();
                i.setIslandId(rs.getInt("islandId"));
                i.setIslandName(rs.getString("islandName"));
                i.setCountryName(rs.getString("countryName"));
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
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId WHERE islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { // chỉ cần lấy 1 island thôi
                Island i = new Island();
                i.setIslandId(rs.getInt("islandId"));
                i.setIslandName(rs.getString("islandName"));
                i.setCountryName(rs.getString("countryName"));
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

    public List<Island> searchIslands(String country, String season) {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId WHERE 1=1";

        if (country != null && !country.isEmpty()) {
            sql += " AND b.countryName LIKE ?";
        }
        if (season != null && !season.isEmpty()) {
            sql += " AND a.bestSeason = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            int idx = 1;
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
                        rs.getString("countryName"),
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
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId order by islandId offset ? rows fetch next ? rows only";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize); // OFFSET
            ps.setInt(2, pageSize);              // FETCH NEXT
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Island(
                        rs.getInt("islandId"),
                        rs.getString("islandName"),
                        rs.getString("countryName"),
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
        List<Island> i = id.searchIslands("Thái Lan", "");

        System.out.println(i.toString());
    }
}
