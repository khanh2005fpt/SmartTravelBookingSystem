/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.SQLException;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nqagh
 */
public class PhoneDao extends DBContext{
    
    public static PhoneDao INSTANCE = new PhoneDao();
    
    // them so dien thoai 
    
    public boolean addPhone(int userId , String phoneNumber){
        try{
            String sqlPhone ="INSERT INTO UserPhones (userId , phoneNumber) VALUES (?,?)";
            try(PreparedStatement ps = connection.prepareStatement(sqlPhone)){
                ps.setInt(1, userId);
                ps.setString(2, phoneNumber);
                
                return ps.executeUpdate()>0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
     // lay list phone
    public List<String> getPhonesByUserId(int userId) {
        List<String> phones = new ArrayList<>();
        String sql = "SELECT phoneNumber FROM UserPhones WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                phones.add(rs.getString("phoneNumber"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return phones;
    }
  // xoa so dt
    public boolean deletePhone(int phoneId) {
        String sql = "DELETE FROM UserPhones WHERE phoneId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, phoneId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
