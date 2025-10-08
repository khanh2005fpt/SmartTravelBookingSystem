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
    String sql = "SELECT * FROM UserEmails WHERE userId = ?";
    
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
     
     // check isPrimaryEmail
     
     
 public boolean isPrimaryEmail(int emailId) {
    String sql = "SELECT isPrimary FROM UserEmails WHERE emailId = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, emailId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getBoolean("isPrimary");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false; // không phải email chính
}

       
       //delete email
    public boolean deleteEmail(int emailId) {
        String sql = "DELETE FROM UserEmails WHERE emailId = ? AND isPrimary = 0";
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
public void setPrimaryEmai(int userId, int emailId) {
    try {
      

        String newEmail = getEmailById(emailId);
        if (newEmail == null) return;

        String sqlReset = "UPDATE UserEmails SET isPrimary=0 WHERE userId=? AND isPrimary=1";
        String sqlSetNew = "UPDATE UserEmails SET isPrimary=1 WHERE emailId=?";
        String sqlUpdateUser = "UPDATE Users SET email=? WHERE userId=?";

        connection.setAutoCommit(false);

        try (PreparedStatement ps1 = connection.prepareStatement(sqlReset)) {
            ps1.setInt(1, userId);
            ps1.executeUpdate();
        }

        try (PreparedStatement ps2 = connection.prepareStatement(sqlSetNew)) {
            ps2.setInt(1, emailId);
            ps2.executeUpdate();
        }

        try (PreparedStatement ps3 = connection.prepareStatement(sqlUpdateUser)) {
            ps3.setString(1, newEmail);
            ps3.setInt(2, userId);
            ps3.executeUpdate();
        }

        connection.commit();

    } catch (SQLException e) {
        try { connection.rollback(); } catch (SQLException ignored) {}
        e.printStackTrace();
    } finally {
        try { connection.setAutoCommit(true); } catch (SQLException ignored) {}
    }
}


        
        //limit them emai va so email dc dung
        
   public int countSecondaryEmails(int userId) {
    String sql = "SELECT COUNT(*) FROM UserEmails WHERE userId = ? AND isPrimary = 0";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
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
    EmailDao dao = new EmailDao();

    int userId = 2;
    String email = "nqaghuyyy6969@gmail.com";

    try {
        // 1️⃣ Thêm email mới
        dao.addEmail(userId, email);
        System.out.println("✅ Đã thêm email mới: " + email);

        // 2️⃣ Lấy danh sách email hiện tại
      
        List<EmailCustomer> emailList = dao.getEmailsByUserId(userId);
        System.out.println("📋 Danh sách email trước khi set primary:");
        for (EmailCustomer e : emailList) {
            System.out.println(" - emailId: " + e.getEmailId() + ", email: " + e.getEmail() + ", isPrimary: " + e.isIsPrimary());
        }

        // 3️⃣ Lấy emailId vừa thêm cuối cùng
        int emailId = emailList.get(emailList.size() - 1).getEmailId();

        // 4️⃣ Gọi hàm setPrimaryEmai
        dao.setPrimaryEmai(userId, emailId);
        System.out.println("\n🔥 Đã set emailId " + emailId + " làm email chính!");

        // 5️⃣ Check lại UserEmails
     
        List<EmailCustomer> listAfter = dao.getEmailsByUserId(userId);
        System.out.println("\n📋 Danh sách email sau khi set primary:");
        for (EmailCustomer e : listAfter) {
            System.out.println(" - emailId: " + e.getEmailId() + ", email: " + e.getEmail() + ", isPrimary: " + e.isIsPrimary());
        }

        // 6️⃣ Check trong bảng Users
        String sqlUser = "SELECT email FROM Users WHERE userId = ?";
        try (PreparedStatement ps = dao.connection.prepareStatement(sqlUser)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("\n👤 Email trong bảng Users hiện tại: " + rs.getString("email"));
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
}


}
    

