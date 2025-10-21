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
import model.Hotel;
import model.IslandVehicle;
import model.Place;
import utils.DBContext;

/**
 *
 * @author Admin
 */
public class ServiceDao extends DBContext{
    
    //Lay danh sach phuong tien theo dao
    public List<IslandVehicle> getListVehicleById(int id) throws SQLException{
        List<IslandVehicle> list = new ArrayList<>();
        String sql = "select * from IslandVehicles a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)){
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
      public List<Hotel> getHotels() throws SQLException{
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
     public List<Hotel> getListHotelsById(int id) throws SQLException{
        List<Hotel> list = new ArrayList<>();
        String sql = "select * from hotels a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)){
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
    public List<Hotel> searchHotels(String country, String roomType, String minPrice, String maxPrice) throws SQLException{
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

        try (PreparedStatement ps = connection.prepareStatement(sql)){
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
    public int getTotalIslands() throws SQLException{
        int total = 0;
        String sql = "select count(*) from Hotels";
        try (PreparedStatement ps = connection.prepareStatement(sql)){
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
     public List<Place> getListPlaceById(int id) throws SQLException{
        List<Place> list = new ArrayList<>();
        String sql = "select * from places a join islands b on a.islandId = b.islandId join Countries c on b.countryId = c.countryId where b.islandId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)){
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
}
