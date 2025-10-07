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
public class EmailDao extends DBContext{
    public static EmailDao INSTANCE = new EmailDao();
    
    //add email profile
       public boolean addEmail(int userId , String email ){
           try{
               String sqlEmail = "INSERT INTO UserEmails (userId , email) VALUES(?,?)";
               try(PreparedStatement ps = connection.prepareStatement(sqlEmail)){
                    ps.setInt(1, userId);
                    ps.setString(2, email);
                    return ps.executeUpdate()>0;
                   
               }
           }
               
           catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Lỗi khi cập nhật thông tin: " + e.getMessage());
        return false;
        
      }
          
       }
       
       
       // lay list userEmail (phu)
       
       public List<String> getEmailByUserId(int userId){
           List<String> emails = new ArrayList<>();
           try{
               String sqlList ="SELECT email FROM UserEmails WHERE userId =1";
                try (PreparedStatement ps = connection.prepareStatement(sqlList)){
                    ps.setInt(1, userId);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()){
                        emails.add(rs.getString("email"));
                    }
                }
           }catch (SQLException e) {
            e.printStackTrace();
        }
           return emails;
       }
       
       
       //delete email
    public boolean deleteEmail(int emailId) {
        String sql = "DELETE FROM UserEmails WHERE emailId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, emailId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    //check ton tai emai
    
        public  boolean checkEmailExists(int userId, String email) {
            try{
                String sql="SELECT COUNT(*) FROM UserEmails WHERE email = ? AND userId = ?";
                try(PreparedStatement ps = connection.prepareStatement(sql)){
                      ps.setString(1, email);
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
        
    
}
