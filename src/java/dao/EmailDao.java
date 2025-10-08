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
import model.CustomerProfile;
import model.EmailCustomer;
import org.apache.jasper.tagplugins.jstl.core.ForEach;

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
       
       
       // lay  userEmail (phu)
       
     public List<EmailCustomer> getEmailsByUserId(int userId) {
    List<EmailCustomer> list = new ArrayList<>();
    String sql = "SELECT emailId, userId, email, isPrimary FROM UserEmails WHERE userId = ?";
    
    try ( PreparedStatement stmt = connection.prepareStatement(sql))
         {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            EmailCustomer email = new EmailCustomer();
            email.setEmailId(rs.getInt("emailId"));
            email.setUserId(rs.getInt("userId"));
            email.setEmail(rs.getString("email"));
            email.setIsPrimary(rs.getBoolean("isPrimary"));
            list.add(email);
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return list;
}
     
     // Lấy email theo emailId 
     public String getEmailById(int emailId)
     { String sql = "SELECT email FROM UserEmails WHERE emailId = ?"; 
     try ( PreparedStatement stmt = connection.prepareStatement(sql)) 
     { 
         stmt.setInt(1, emailId); 
         ResultSet rs = stmt.executeQuery();
         if (rs.next()) return rs.getString("email"); 
     } catch (SQLException e) {
         e.printStackTrace();
     } return null; 
     
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
  
       // update email thanh primary email va dong bo voi user
        
        public void setPrimaryEmai(int userId ,int emailId){
            String newEmail = getEmailById(emailId);
            if(newEmail==null) return;
            
            
            
            try{
                String sqlReset="UPDATE UserEmails SET isPrimary=0 WHERE userId=? AND isPrimary=1";
                String sqlSetNew = "UPDATE UserEmails SET isPrimary=1 WHERE emailId=?";
                // dong bo email o user
                String sqlUpdateUser = "UPDATE Users SET EMAIL=? WHERE userId=?";
                
                //Tắt auto-commit → dùng transaction.(nếu có lỗi thì rollback tránh k đồng bộ )
                connection.setAutoCommit(false);
                
                try(PreparedStatement ps = connection.prepareStatement(sqlReset)){
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                 try(PreparedStatement ps = connection.prepareStatement(sqlSetNew)){
                    ps.setInt(1, emailId);
                    ps.executeUpdate();
                }
                  try(PreparedStatement ps = connection.prepareStatement(sqlUpdateUser)){
                    ps.setString(1, newEmail);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
                  //mọi thay đổi được lưu đồng bộ
                    connection.commit();
                
            }catch (SQLException e) {
            e.printStackTrace();
            
        }
            
        }
        
        //limit them emai va so email dc dung
        
        public int countEmailsByUserId(int userId) {
    int count = 0;
    String sql = "SELECT COUNT(*) FROM UserEmails WHERE userId = ?";
    
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
        
        // check default phone
public boolean checkDefaultEmailExist(int userId, String email) {
    String sql = "SELECT COUNT(*) FROM Users WHERE email = ? AND userId <> ?";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, email);
        stmt.setInt(2, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;//đã tồn tại
            }
        }
    } catch (SQLException e) {
        System.out.println("Lỗi khi kiểm tra email: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}


        
        /*
        
        public List<Integer> getEmailIdsByUserId(int userId) {
    List<Integer> emailIds = new ArrayList<>();
    String sql = "SELECT emailId FROM UserEmails WHERE userId = ?";
    
    try ( PreparedStatement stmt = connection.prepareStatement(sql))
         {
        
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            emailIds.add(rs.getInt("emailId"));
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return emailIds;
}
*/
        public static void main(String[] args) {
            
           
          
    List<EmailCustomer> listEmail = EmailDao.INSTANCE.getEmailsByUserId(2);
    
  
    List<EmailCustomer> list = new ArrayList<>();
    
  
    for (EmailCustomer email : listEmail) {
         System.out.println(email.getEmailId()+" "+email.getEmail()+" "+email.getUserId());
    }
    }
}
    

