/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import Model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.CallableStatement;
import utils.DBContext;
/**
 *
 * @author nqagh
 */
public class userDao extends DBContext {
    public static userDao INSTANCE = new userDao();
    
    
    public String status ;

        public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
 public String Signup(String username, String password, String email, String fullName, String phone) {
    try {
        
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
        
    
        String sql = "INSERT INTO Users (username, password, email, fullName, phone) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, passwordHash);
            stmt.setString(3, email);
            stmt.setString(4, fullName);
            stmt.setString(5, phone);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                status="Success"; 
                return status;
            } else {
                status="Error";
                return status;
            }
        }
    } catch (SQLException e) {
        String errorMessage = "Lỗi khi đăng ký: " + e.getMessage();
        System.out.println(errorMessage);
        return "Error: " + errorMessage;
    }
}
 // check userName ton tai
 
   public boolean checkUsernameExist (String username){
       String sqlExist = "SELECT COUNT (*)FROM Users WHERE username=? ";
          try(PreparedStatement stmt = connection.prepareStatement(sqlExist)){
            stmt.setString(1, username);
              try(ResultSet rs = stmt.executeQuery()) {
                  if(rs.next()){
                      //dem ban ghi > 0 la ton tai
                      return rs.getInt(1)>0;
              
              }
          } 

        }catch (SQLException e) {
               System.out.println("Lỗi khi kiểm tra Username: " + e.getMessage());
                e.printStackTrace();
           
          } 
          return false;
   }
  // check email ton tai
  
    public boolean checkEmailExist (String email){
       String sqlExist = "SELECT COUNT (*)FROM Users WHERE email=? ";
          try(PreparedStatement stmt = connection.prepareStatement(sqlExist)){
            stmt.setString(1, email);
              try(ResultSet rs = stmt.executeQuery()) {
                  if(rs.next()){
                      //dem ban ghi > 0 la ton tai
                      return rs.getInt(1)>0;
              
              }
          } 

        }catch (SQLException e) {
               System.out.println("Lỗi khi kiểm tra Email: " + e.getMessage());
                e.printStackTrace();
          
          }
              return false;
    }
          
   // check fullname ton tai
   
     public boolean checkFullnameExist (String fullName){
       String sqlExist = "SELECT COUNT (*)FROM Users WHERE fullName=? ";
          try(PreparedStatement stmt = connection.prepareStatement(sqlExist)){
            stmt.setString(1,fullName );
              try(ResultSet rs = stmt.executeQuery()) {
                  if(rs.next()){
                      //dem ban ghi > 0 la ton tai
                      return rs.getInt(1)>0;
              
              }
          } 

        }catch (SQLException e) {
               System.out.println("Lỗi khi kiểm tra fullName: " + e.getMessage());
                e.printStackTrace();
              
          }
          return false;
     }
     
  // check phone ton tai
     
        
     public boolean checkPhoneExist (String phone){
       String sqlExist = "SELECT COUNT (*)FROM Users WHERE phone=? ";
          try(PreparedStatement stmt = connection.prepareStatement(sqlExist)){
            stmt.setString(1,phone );
              try(ResultSet rs = stmt.executeQuery()) {
                  if(rs.next()){
                      //dem ban ghi > 0 la ton tai
                      return rs.getInt(1)>0;
              
              }
          } 

        }catch (SQLException e) {
               System.out.println("Lỗi khi kiểm tra phone: " + e.getMessage());
                e.printStackTrace();
              
          }
          return false;
     }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
    
    
}
