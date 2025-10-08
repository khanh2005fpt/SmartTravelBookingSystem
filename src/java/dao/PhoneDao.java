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
import model.PhoneCustomer;

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
    
    // lay list phone of customer
      public List<PhoneCustomer> getPhoneCustomersByUserId(int userId) {
    List<PhoneCustomer> list = new ArrayList<>();
    String sql = "SELECT phoneId, userId, phoneNumber FROM UserPhones WHERE userId = ?";
    
    try ( PreparedStatement stmt = connection.prepareStatement(sql))
         {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
           PhoneCustomer phone = new PhoneCustomer();
          phone.setPhoneId(rs.getInt("phoneId"));
          phone.setUserId(rs.getInt("userId"));
          phone.setPhone(rs.getString("phoneNumber"));
          list.add(phone);
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return list;
}
    
 //check ton tai phone
    
        public  boolean checkPhonelExists(int userId, String phone) {
            try{
                String sql="SELECT COUNT(*) FROM UserPhones WHERE phoneNumber = ? AND userId = ?";
                try(PreparedStatement ps = connection.prepareStatement(sql)){
                      ps.setString(1, phone);
            ps.setInt(2, userId);
               ResultSet rs = ps.executeQuery();
               while (rs.next()){
                  int count = rs.getInt(1);
                  return count>0;// da ton tai
               }
                }
            }catch (SQLException e) {
            e.printStackTrace();
        }
            return false;//chua ton tai
        }   
        
        
        // check default phone
        
        
    // check phone ton tai
  public boolean checkDefaultPhoneExist(int userId, String phone) {
    String sql = "SELECT COUNT(*) FROM Users WHERE phone = ? AND userId <> ?";//<>  tuong duong voi !=
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, phone);
        stmt.setInt(2, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0; // da ton tai
            }
        }
    } catch (SQLException e) {
        System.out.println("Lỗi khi kiểm tra phone: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
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
    
    
          //limit them sdt va so sdt dc dung
        
        public int countPhonesByUserId(int userId) {
    int count = 0;
    String sql = "SELECT COUNT(*) FROM UserPhones WHERE userId = ?";
    
    try ( PreparedStatement stmt = connection.prepareStatement(sql) ) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return count;
}
       public static void main(String[] args) {
          List<PhoneCustomer> listPhone = PhoneDao.INSTANCE.getPhoneCustomersByUserId(2);
    
  
    List<PhoneCustomer> list = new ArrayList<>();
    
  
    for (PhoneCustomer phone :listPhone) {
         System.out.println(phone.getPhoneId()  +" "+phone.getUserId()+" "+phone.getPhone());
    }
    
    }
}
