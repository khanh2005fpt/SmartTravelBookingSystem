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
import model.CustomerContacts;
import model.CustomerProfile;
import model.HistoryBooking;
import model.Notification;
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

      // Lấy danh sách lịch sử theo customerId
    public List<HistoryBooking> getHistoryByCustomerId(int customerId) throws SQLException {
    List<HistoryBooking> list = new ArrayList<>();
    String sql = "SELECT * FROM HistoryBooking WHERE customerId = ?";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                HistoryBooking h = new HistoryBooking(
                    rs.getInt("historyId"),
                    rs.getInt("customerId"),
                    rs.getInt("paymentId"),
                    rs.getString("note"),
                    rs.getString("tourStatus")
                );
                list.add(h);
            }
        }

    } catch (SQLException e) {
         throw new SQLException("Lỗi khi lấy lịch sử booking theo customerId: " + customerId, e);
    
  
    }

    return list;
}
     // them contact cho profile
    public boolean addContact(int userId, String contactValue) throws SQLException {
        // Xác định contactType dựa vào value
       String contactType;
    if (contactValue.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
        contactType = "EMAIL";
    } else if (contactValue.matches("^0\\d{9,10}$")) {
        contactType = "PHONE";
    } else {
        throw new IllegalArgumentException("Contact không hợp lệ: " + contactValue);
    }


        String sql = "INSERT INTO CustomerContacts (userId, contactValue, contactType, isPrimary) " +
                     "VALUES (?, ?, ?, 0)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, contactValue);
            ps.setString(3, contactType);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0; // true nếu insert thành công
        }
    }

     // count so luong email dc them 
    public int countEmailContactSecondary(int userId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM CustomerContacts WHERE userId = ? AND contactType = 'EMAIL'";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    
     // lay ra list email theo user
    public List<CustomerContacts> getEmailContactByUserId(int userId)throws SQLException {
    List<CustomerContacts> list = new ArrayList<>();
    String sql = "SELECT * FROM CustomerContacts WHERE userId = ? AND contactType = 'EMAIL' AND isPrimary=0 ";

    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
               CustomerContacts email = new CustomerContacts();
                email.setContactId(rs.getInt("contactId"));
                email.setUserId(rs.getInt("userId"));
                email.setContactValue(rs.getString("contactValue")); 
                email.setIsPrimary(rs.getBoolean("isPrimary"));
                list.add(email);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}
      // check ton tai contact
   public boolean isContactExist(int userId, String contactValue) throws SQLException{
    String sql = "SELECT COUNT(*) FROM CustomerContacts WHERE userId = ? AND contactValue = ?";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        stmt.setString(2, contactValue);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0; // true nếu tồn tại
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false; 
}

    
    
     public boolean deleteContact(int contactId) throws SQLException{
        String sql = "DELETE FROM CustomerContacts WHERE contactId = ? AND isPrimary = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contactId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
     
        // Đặt email chính cho contactId , và đồng bộ sang bảng Users.
     
      public void setPrimaryEmailContact(int contactId) throws SQLException {
        String sql = "UPDATE CustomerContacts SET isPrimary = 1 WHERE contactId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            connection.setAutoCommit(false); // Bắt đầu transaction

            ps.setInt(1, contactId);
      
            int rowsAffected = ps.executeUpdate();
            connection.commit(); // Commit transaction
        } catch (SQLException ex) {
            connection.rollback(); // Rollback nếu có lỗi
            throw ex;
        } finally {
            connection.setAutoCommit(true);
        }
    }
      
      
      //   // Lấy email theo contactId 
     public String getEmailContactById(int contactId)
     {
         String sql = "SELECT contactValue FROM CustomerContacts WHERE contactId = ?"; 
     try ( PreparedStatement stmt = connection.prepareStatement(sql)) 
     { 
         stmt.setInt(1, contactId); 
         ResultSet rs = stmt.executeQuery();
         if (rs.next()) return rs.getString("contactValue"); 
     } catch (SQLException e) {
         e.printStackTrace();
     } return null; 
     
     }
     
     
        // count so luong phone dc them 
    public int countPhoneContactSecondary(int userId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM CustomerContacts WHERE userId = ? AND contactType = 'PHONE'";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    
      // lay ra list email theo user
    public List<CustomerContacts> getPhoneContactByUserId(int userId)throws SQLException {
    List<CustomerContacts> list = new ArrayList<>();
    String sql = "SELECT * FROM CustomerContacts WHERE userId = ? AND contactType = 'PHONE' AND isPrimary=0 ";

    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
               CustomerContacts email = new CustomerContacts();
                email.setContactId(rs.getInt("contactId"));
                email.setUserId(rs.getInt("userId"));
                email.setContactValue(rs.getString("contactValue")); 
                email.setIsPrimary(rs.getBoolean("isPrimary"));
                list.add(email);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

     
    
     public static void main(String[] args) {
       // Tạo đối tượng DAO
        try {
     CustomerDao dao = new CustomerDao();

        // Nhập customerId muốn test
          int contactId = 1; // giả sử userId đã tồn tại
         

        // Gọi phương thức


       dao.setPrimaryEmailContact(contactId);

            System.out.println("🎯 Đã gọi setPrimaryEmail(" + contactId + ").");
            System.out.println("➡️ Hãy kiểm tra bảng CustomerContacts và Users để xem kết quả trigger đồng bộ.");

            // Thêm phone
         

    } catch (Exception e) {
        e.printStackTrace();
    }
        }
    
    }

