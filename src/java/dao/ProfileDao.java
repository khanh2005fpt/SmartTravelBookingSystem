/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.SQLException;
import java.time.LocalDate;
import model.CustomerProfile;
import model.CustomerProfile.Gender ;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Objects;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author nqagh
 */
public class ProfileDao extends DBContext{
    
     public static ProfileDao INSTANCE = new ProfileDao();
 
    //update information of user
    
public CustomerProfile updateInformation(int userId, String fullName, LocalDate dob,
        CustomerProfile.Gender gender, String address, String profilePicture,
        int loyaltyPoints, CustomerProfile.MembershipLevel membershipLevel) {
    
    try {
        // Kiểm tra xem bản ghi đã tồn tại trong CustomerProfiles chưa
        String checkSql = "SELECT COUNT(*) FROM CustomerProfiles WHERE userId = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, userId);
            ResultSet rs = checkPs.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            // Update bang Users
            String sqlUser = "UPDATE Users SET fullName=? WHERE userId=?";
            try (PreparedStatement psUser = connection.prepareStatement(sqlUser)) {
                psUser.setString(1, fullName);
                psUser.setInt(2, userId);
                psUser.executeUpdate();
            }

            // Update hoặc Insert bang CustomerProfiles
            String sqlProfile;
            if (count > 0) {
                // Cập nhật nếu bản ghi đã tồn tại
                sqlProfile = "UPDATE CustomerProfiles " +
                        "SET fullName=?, dateOfBirth=?, gender=?, address=?, profilePicture=?, " +
                        "loyaltyPoints=?, membershipLevel=? WHERE userId=?";
            } else {
                // Thêm mới nếu bản ghi chưa tồn tại
                sqlProfile = "INSERT INTO CustomerProfiles (userId, fullName, dateOfBirth, gender, address, profilePicture, loyaltyPoints, membershipLevel) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            }

            try (PreparedStatement ps = connection.prepareStatement(sqlProfile)) {
           
                ps.setString(1, fullName);
                ps.setDate(2, dob != null ? java.sql.Date.valueOf(dob) : null);
                ps.setString(3, gender != null ? gender.name() : null);
                ps.setString(4, address);
                ps.setString(5, profilePicture);
                ps.setInt(6, loyaltyPoints);
                ps.setString(7, membershipLevel != null ? membershipLevel.name() : "BRONZE");

                if (count > 0) {
                    ps.setInt(8, userId); // Cho UPDATE
                }
                ps.executeUpdate();
            }

            // Trả về đối tượng CustomerProfile (giả định)
            return new CustomerProfile(userId, fullName, dob, gender, address, profilePicture, loyaltyPoints, membershipLevel);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Lỗi khi cập nhật thông tin: " + e.getMessage());
        return null; // Hoặc ném ngoại lệ tùy theo yêu cầu
    }
}

  
    // check changing of information
     public boolean isProfileChanged(int userId , String fullName , LocalDate dob , CustomerProfile.Gender gender , String address){
         try{
             String sqlChanged = "SELECT fullName , dateOfBirth , gender , address FROM CustomerProfiles WHERE userId =?";
              try(PreparedStatement ps = connection.prepareStatement(sqlChanged)){
                  ps.setInt(1, userId);
                  ResultSet rs = ps.executeQuery();
                  if(rs.next()){
                      //lay information from db 
                      String dbFullName = rs.getString("fullName");
                      LocalDate dbDob = rs.getDate("dateOfBirth")!=null ? rs.getDate("dateOfBirth").toLocalDate(): null;
                      String dbGender = rs.getString("gender");
                      String dbAddress = rs.getString("address");
                      
                      // check so sanh co ton tai k
                      Boolean changed = 
                              !Objects.equals(dbFullName, fullName)||
                              !Objects.equals(dbDob, dob)||
                              !Objects.equals(dbGender, gender != null ? gender.name() : null) ||
                              !Objects.equals(dbAddress, address);
                      return changed;
                    
                      
                  }
              }
         
             
         }catch (SQLException e) {
             e.printStackTrace();
        System.out.println("Lỗi khi lưu thông tin: " + e.getMessage());
        
    }
    return false;
     }


    
}
