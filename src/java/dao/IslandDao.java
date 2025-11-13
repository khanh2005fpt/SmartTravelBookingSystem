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

    public List<Country> getAllCountries() throws SQLException {
        List<Country> list = new ArrayList<>();
        String sql = "SELECT * FROM Countries";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Country c = new Country();
                c.setCountryId(rs.getInt("countryId"));
                c.setCountryName(rs.getString("countryName"));
                list.add(c);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy danh sách quốc gia từ cơ sở dữ liệu.", e);
        }
        return list;
    }

    public List<Island> getIslands() throws SQLException {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Island i = new Island();
                i.setIslandId(rs.getInt("islandId"));
                i.setIslandName(rs.getString("islandName"));
                i.setCountryName(rs.getString("countryName"));
                i.setShortDescription(rs.getString("shortDescription"));
                i.setLongDescription(rs.getString("longDescription"));
                i.setBestSeason(rs.getString("bestSeason"));
                i.setActivities(rs.getString("activities"));
                i.setImageUrl(rs.getString("imageUrl"));
                i.setLocation(rs.getString("location"));
                list.add(i);
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi khi lấy danh sách đảo từ cơ sở dữ liệu.", e);
        }
        return list;
    }

    public Island getIslandById(int id) throws SQLException {
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId WHERE islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { // chỉ cần lấy 1 island thôi
                Island i = new Island();
                i.setIslandId(rs.getInt("islandId"));
                i.setIslandName(rs.getString("islandName"));
                i.setCountryName(rs.getString("countryName"));
                i.setShortDescription(rs.getString("shortDescription"));
                i.setLongDescription(rs.getString("longDescription"));
                i.setBestSeason(rs.getString("bestSeason"));
                i.setActivities(rs.getString("activities"));
                i.setImageUrl(rs.getString("imageUrl"));
                i.setLocation(rs.getString("location"));
                return i; // trả về Island
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy thông tin đảo có islandId = " + id, e);
        }
        return null; // không tìm thấy thì trả về null
    }

    public String getIslandNameById(int islandId) throws SQLException {
        String islandName = "";
        String sql = "SELECT islandName FROM Islands WHERE islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, islandId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                islandName = rs.getString("islandName");
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy tên đảo có islandId = " + islandId, e);
        }
        return islandName;
    }

    public List<Island> searchIslands(String country, String season) throws SQLException {
        List<Island> list = new ArrayList<>();
        String sql = "SELECT * FROM Islands a join Countries b on a.countryId = b.countryId WHERE 1=1";

        if (country != null && !country.isEmpty()) {
            sql += " AND b.countryName LIKE ?";
        }
        if (season != null && !season.isEmpty()) {
            sql += " AND a.bestSeason = ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                        rs.getString("shortDescription"),
                        rs.getString("longDescription"),
                        rs.getString("bestSeason"),
                        rs.getString("activities"),
                        rs.getString("imageUrl"),
                        rs.getString("location")
                ));
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tìm kiếm đảo theo quốc gia hoặc mùa du lịch.", e);
        }
        return list;
    }

    public int getTotalIslands() throws SQLException {
        int total = 0;
        String sql = "select count(*) from Islands";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi đếm tổng số lượng đảo trong cơ sở dữ liệu.", e);
        }
        return total;
    }

    public static void main(String[] args) {
        try {
            IslandDao id = new IslandDao();
            List<Island> i = id.searchIslands("Thái Lan", "");
            System.out.println(i.toString());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
   

    // Lấy danh sách Đảo đang chờ duyệt
   public List<Island> getPendingIslands() throws SQLException {
    List<Island> list = new ArrayList<>();
    // ⭐ SỬA: Thay description bằng shortDescription hoặc longDescription
    String sql = "SELECT islandId, islandName, shortDescription, longDescription, islandImageUrl, approvalStatus FROM Islands WHERE approvalStatus = 'PENDING' ORDER BY islandId DESC";

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Island island = new Island();
            island.setIslandId(rs.getInt("islandId"));
            island.setIslandName(rs.getString("islandName"));

            // ⭐ SỬA: Dùng setter tương ứng với cột SQL mới
            island.setShortDescription(rs.getString("shortDescription"));
            // Hoặc island.setLongDescription(rs.getString("longDescription"));

            island.setIslandImageUrl(rs.getString("islandImageUrl")); // Tên này cũng cần được kiểm tra lại (bạn dùng imageUrl trong model)
            island.setApprovalStatus(rs.getString("approvalStatus"));
            list.add(island);
        }
    }
    return list;
}

    // Cập nhật trạng thái duyệt của Đảo
    public void updateIslandStatus(int islandId, String status) throws SQLException {
        // Cập nhật trạng thái duyệt (APPROVED/REJECTED) cho Đảo
        String sql = "UPDATE Islands SET approvalStatus = ? WHERE islandId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, islandId);
            ps.executeUpdate();
        }
    }
}
    

