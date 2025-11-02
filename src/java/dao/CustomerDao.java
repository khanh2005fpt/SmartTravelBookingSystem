/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.sql.Date;
import java.util.List;
import java.util.Objects;
import model.CustomerProfile;
import model.EmailCustomer;
import model.Notification;
import model.PhoneCustomer;
import utils.DBContext;

/**
 *
 * @author nqagh
 */
public class CustomerDao extends DBContext {
    public static CustomerDao INSTANCE = new CustomerDao();
    
    // PROFILE OF CUSTOMER
    
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
    return false; // mặc định không phải email chính
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
        
         // check email deleted_exist
        
            public boolean checkEmailExistsByIdAndUser(int emailId, int userId) {
    String sql = "SELECT COUNT(*) FROM UserEmails WHERE  emailId = ? AND userId = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, emailId);
        ps.setInt(2, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
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

        
     // check phone deleted_exist
        
            public boolean checkPhoneExistsByIdAndUser(int phoneId, int userId) {
    String sql = "SELECT COUNT(*) FROM UserPhones WHERE phoneId = ? AND userId = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, phoneId);
        ps.setInt(2, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        }
    } catch (SQLException e) {
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
        
        
   // ======= Cập nhật avatar =======
    public boolean updateProfilePicture(int userId, String avatarUrl) {
        String sql = "UPDATE CustomerProfiles SET profilePicture = ? WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    
    // ======= Lấy profile theo userId =======
    public CustomerProfile getProfileByUserId(int userId) {
        String sql = "SELECT * FROM CustomerProfiles WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CustomerProfile profile = new CustomerProfile();
                profile.setProfileId(rs.getInt("profileId"));
                profile.setUserId(rs.getInt("userId"));
                profile.setFullName(rs.getString("fullName"));
                 Date dob = rs.getDate("dateOfBirth");
                profile.setDateOfBirth(dob != null ? dob.toLocalDate() : null);
                profile.setGender(profile.getGender());
                profile.setAddress(rs.getString("address"));
                profile.setProfilePicture(rs.getString("profilePicture"));
                profile.setLoyaltyPoints(rs.getInt("loyaltyPoints"));
               String levelStr = rs.getString("membershipLevel");
            if (levelStr != null && !levelStr.isEmpty()) {
                profile.setMembershipLevel(CustomerProfile.MembershipLevel.valueOf(levelStr.toUpperCase()));
            }
                return profile;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy profile
    }
    
     // lay list thong bao 
    
    public List<Notification> getNotificationByUser(int userId){
        
        List <Notification> list = new ArrayList<>();
                
        try{
            
                   String sql = "SELECT * FROM Notifications WHERE userId = ? AND isDeleted = 0 ORDER BY createdAt DESC";
                   try (PreparedStatement ps = connection.prepareStatement(sql)){
                       ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();
                        while(rs.next()){
                            Notification n = new Notification();
                              n.setNotificationId(rs.getInt("notificationId"));
                n.setUserId(rs.getInt("userId"));
                n.setTitle(rs.getString("title"));
                n.setMessage(rs.getString("message"));
                n.setType(rs.getString("type"));
                n.setIsRead(rs.getBoolean("isRead"));
                n.setCreatedAt(rs.getTimestamp("createdAt"));
                n.setIsDeleted(rs.getBoolean("isDeleted"));
                list.add(n);
                        }
                   }
        
        }catch (SQLException e) {
            e.printStackTrace();
    }
      return list;
}
    
     // danh dau la da doc 
       public boolean markAllRead (int userId){
           try{
                String sql ="UPDATE Notifications SET isRead =1 WHERE userId=?";
                try (PreparedStatement ps = connection.prepareStatement(sql)){
                       ps.setInt(1, userId);
                       return ps.executeUpdate() >0;
                }
               
               }catch (SQLException e) {
            e.printStackTrace();
           }
           return false;
       }
       
       // xoa mem tren UI user thoi
         public void softDeleteAllByUser(int userId) {
        String sql = "UPDATE Notifications SET isDeleted = 1 WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
         // Trả về danh sách notificationId chưa đọc
public List<Integer> getUnreadNotificationIds(int userId)  {
    List<Integer> unreadIds = new ArrayList<>();

    String sql = "SELECT notificationId FROM Notifications WHERE userId = ? AND isRead=0 AND isDeleted=0";
    
     try (PreparedStatement ps = connection.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            unreadIds.add(rs.getInt("notificationId"));
        }
    }catch (SQLException e) {
            e.printStackTrace();
        }

    return unreadIds;
}
   
    }

