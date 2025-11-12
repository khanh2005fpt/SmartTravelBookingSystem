/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.SecureRandom;
import model.User;
import model.Log;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.CallableStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Role;
import model.Token;

import utils.DBContext;

/**
 *
 * @author nqagh
 */
public class UserDao extends DBContext {

    public static UserDao INSTANCE = new UserDao();

    public String status;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // dang ky  
    public String Signup(String username, String password, String email, String fullName, String phone) throws SQLException{
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
                    status = "Success";
                    return status;
                } else {
                    status = "Error";
                    return status;
                }
            }
        } catch (SQLException e) {
            String errorMessage = "Lỗi khi đăng ký: " + e.getMessage();
            System.out.println(errorMessage);
            return "Error: " + errorMessage;
        }
    }

    // dang nhappp
    public User loginSystem(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password")); // lấy hash từ DB
                user.setFullName(rs.getString("fullName")); 
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getString("status"));
                user.setRoleId(rs.getInt("roleId"));
                String storedPassword = user.getPassword();

                // So sánh password plain text 
                if (password != null && password.equals(storedPassword)) {
                    return user;
                }

                // So sánh password với hash BCrypt
                try {
                    if (BCrypt.checkpw(password, storedPassword)) {
                        return user;
                    }
                } catch (Exception e) {
                    System.out.println("BCrypt Verify error: " + e);
                }
            }
        } catch (SQLException sq) {
            sq.printStackTrace();
        }

        return null; // Sai username hoặc password
    }

    // check userName ton tai
    public boolean checkUsernameExist(String username) {
        String sqlExist = "SELECT COUNT (*)FROM Users WHERE username=? ";
        try (PreparedStatement stmt = connection.prepareStatement(sqlExist)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    //dem ban ghi > 0 la ton tai
                    return rs.getInt(1) > 0;

                }
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra Username: " + e.getMessage());
            e.printStackTrace();

        }
        return false;
    }
    // check email ton tai

    public boolean checkEmailExist(String email) {
        String sqlExist = "SELECT COUNT (*)FROM Users WHERE email=? ";
        try (PreparedStatement stmt = connection.prepareStatement(sqlExist)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    //dem ban ghi > 0 la ton tai
                    return rs.getInt(1) > 0;

                }
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra Email: " + e.getMessage());
            e.printStackTrace();

        }
        return false;
    }

    // check fullname ton tai
    public boolean checkFullnameExist(String fullName) {
        String sqlExist = "SELECT COUNT (*)FROM Users WHERE fullName=? ";
        try (PreparedStatement stmt = connection.prepareStatement(sqlExist)) {
            stmt.setString(1, fullName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    //dem ban ghi > 0 la ton tai
                    return rs.getInt(1) > 0;

                }
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra fullName: " + e.getMessage());
            e.printStackTrace();

        }
        return false;
    }

    // check phone ton tai
    public boolean checkPhoneExist(String phone) {
        String sqlExist = "SELECT COUNT (*)FROM Users WHERE phone=? ";
        try (PreparedStatement stmt = connection.prepareStatement(sqlExist)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    //dem ban ghi > 0 la ton tai
                    return rs.getInt(1) > 0;

                }
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra phone: " + e.getMessage());
            e.printStackTrace();

        }
        return false;
    }

    // token password , lay email
    public User getUserByEmail(String email) {
        try {
            String sql = "Select * from Users where email=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new User(
                        rs.getInt("userId"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getInt("roleId"),
                        rs.getTimestamp("createdAt"),
                        rs.getString("status")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return null;
    }

    //lay user by username
    public User getUserByUsername(String username) {
        try {
            String sql = "Select * from Users where username=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new User(
                        rs.getInt("userId"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getInt("roleId"),
                        rs.getTimestamp("createdAt"),
                        rs.getString("status")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return null;
    }

    // lay userById
    public User getUserById(int userId) {
        try {
            String sql = "SELECT * FROM Users WHERE userId = ? ";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return new User(
                            rs.getInt("userId"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("email"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getInt("roleId"),
                            rs.getTimestamp("createdAt"),
                            rs.getString("status")
                    );
                }
            }

        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    // update password
   public void updatePassword(String email, String password) {
    try {
        // Hash mật khẩu trước khi lưu
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

        String sqlPass = "UPDATE Users SET Password = ? WHERE Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlPass)) {
            ps.setString(1, passwordHash);  // Password đã hash
            ps.setString(2, email);         // Email để xác định user
            ps.executeUpdate();
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
}
    
    // update status

    public void updateStatus(Token tokenForget) {
        try {
            String sqlStatus = "UPDATE Tokens \n"
                    + "SET isUsed= ? \n"
                    + "WHERE  TokenValue = ?";
            try (PreparedStatement ps = connection.prepareStatement(sqlStatus)) {
                ps.setString(1, tokenForget.getTokenValue());
                ps.setBoolean(2, tokenForget.isIsUsed());

                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

    }

    // generate random password
    public String generateRandomPassword(int lenght) {
        final String CHARACTER = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < lenght; i++) {
            int idx = random.nextInt(CHARACTER.length());
            sb.append(CHARACTER.charAt(idx));
        }
        return sb.toString();
    }

    // Auto dky cho user
    public String AutoSignupByGoogle(String username, String password, String email, String fullName, String phone) {
        try {

            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

            String sql = "INSERT INTO Users (username, password, email, fullName, phone) VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, passwordHash);
                stmt.setString(3, email);
                stmt.setString(4, fullName);
                stmt.setString(5, null);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    status = "Success";
                    return status;
                } else {
                    status = "Error";
                    return status;
                }
            }
        } catch (SQLException e) {
            String errorMessage = "Lỗi khi đăng ký: " + e.getMessage();
            System.out.println(errorMessage);
            return "Error: " + errorMessage;
        }
    }

    public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = myDateObj.format(myFormatObj);
        return formattedDate;
    }

      // luu token moi
    public boolean insertToken(Token tokenForget) {

        try {
            String sqlToken = "INSERT INTO Tokens (UserId, TokenValue, ExpiryDate, IsUsed , OtpCode , AttemptCount) VALUES (?, ?, ?, ? , ? , ?)";
            try (PreparedStatement ps = connection.prepareStatement(sqlToken)) {
                ps.setInt(1, tokenForget.getUserId());
                ps.setString(2, tokenForget.getTokenValue());
                ps.setTimestamp(3, Timestamp.valueOf(tokenForget.getExpiryDate()));
                ps.setBoolean(4, tokenForget.isIsUsed());
                ps.setString(5,tokenForget.getOtpCode());
                ps.setInt(6, tokenForget.getAttemptCount());
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMessage = "Lỗi khi luu token: " + e.getMessage();
        }
        return false;
    }
    
     // check validToken
public Token checkValidToken(String tokenValue) {
    Token token = getTokenByValue(tokenValue);

    if (token == null) {
        return null; 
    }
    if (token.getExpiryDate().isBefore(LocalDateTime.now())) {
        return null;
    }
    if (token.isIsUsed()) {
        return null;
    }

    return token; // token hợp lệ
}


 // danh dau token da su dung
    public void markTokenAsUsed(String tokenValue) {

        try {
            String sqlMark = "UPDATE Tokens SET IsUsed = 1 WHERE TokenValue=?";
            try (PreparedStatement ps = connection.prepareStatement(sqlMark)) {
                ps.setString(1, tokenValue);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            String errorMessage = "Lỗi khi danh dau token: " + e.getMessage();
        }
    }

 // xoa token het han 
    public void deleteExpiredTokens() {

        try {
            String sql = "DELETE FROM Tokens WHERE ExpiryDate < GetDate() OR IsUsed=1";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            String errorMessage = "Lỗi khi xoa token: " + e.getMessage();
        }

    }
    
     // get token 

    public Token getTokenByValue(String tokenValue) {
        try {
            String sql = "SELECT * FROM Tokens WHERE TokenValue =? ";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, tokenValue);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return new Token(
                            rs.getInt("TokenId"),
                            rs.getInt("UserId"),
                            rs.getString("TokenValue"),
                            rs.getTimestamp("ExpiryDate").toLocalDateTime(),
                            rs.getBoolean("IsUsed"),
                            rs.getString("OtpCode"),
                            rs.getInt("AttemptCount")
                    );
                    

                    
                }
            }

        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }
    
     // update otpcode va attempt cout
    
      public void updateOtpAndAttempt(int tokenId , String OtpCode , int AttemptCount){
            try{
                String sqlOtp ="UPDATE Tokens SET OtpCode =? , AttemptCount = ? WHERE TokenId =?";
                try(PreparedStatement ps = connection.prepareStatement(sqlOtp)){
                     ps.setString(1, OtpCode); 
              
                     ps.setInt(2, AttemptCount);
                     ps.setInt(3, tokenId);
                     
                     ps.executeUpdate();
                }
                
            }catch(SQLException e){
                e.printStackTrace();
                System.out.println(e);
            }
      }  
      
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   /*
    // ===================  Phần ADMIN ===================
  */   
      
         // lay roleAllUser
    
      public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT roleId, roleName FROM Roles ORDER BY roleName";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("roleId"));
                r.setRoleName(rs.getString("roleName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
      
        // Thống kê người dùng theo trạng thái (ACTIVE, LOCKED, INACTIVE, v.v.)
    public Map<String, Integer> getUserCountByStatus() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS total FROM Users GROUP BY status";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int total = rs.getInt("total");
                map.put(status, total);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public int getTotalUsers2() {
        return getCount("SELECT COUNT(*) FROM Users");
    }

    public int getActiveUsers() {
        return getCount("SELECT COUNT(*) FROM Users WHERE status = 'ACTIVE'");
    }

    public int getLockedUsers() {
        return getCount("SELECT COUNT(*) FROM Users WHERE status = 'LOCKED'");
    }
    private int getCount(String sql) {
        int count = 0;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    
    public List<User> getAllUsers(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, email, fullName, phone, roleId, createdAt, status "
                + "FROM Users "
                + "ORDER BY userId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int offset = (page - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setPhone(rs.getString("phone"));
                u.setRoleId(rs.getInt("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // lay total user
   public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
   
   
   // search user of admin
   
   public List<User> searchUsers(String keyword, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, email, fullName, phone, roleId, createdAt, status "
                + "FROM Users "
                + "WHERE fullName LIKE ? OR email LIKE ? "
                + "ORDER BY userId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            int offset = (page - 1) * pageSize;
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setPhone(rs.getString("phone"));
                u.setRoleId(rs.getInt("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
   
   // lay user b trang thai
    public List<User> getUsersByStatus(String status, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, email, fullName, phone, roleId, createdAt, status "
                + "FROM Users ";
        if (!"ALL".equalsIgnoreCase(status)) {
            sql += "WHERE status = ? ";
        }
        sql += "ORDER BY userId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            if (!"ALL".equalsIgnoreCase(status)) {
                ps.setString(idx++, status);
            }
            int offset = (page - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setPhone(rs.getString("phone"));
                u.setRoleId(rs.getInt("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
   // update status
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE Users SET status = ? WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
       // =================== ADD USER ===================
    public boolean addUser(User user) {
        String sql = "INSERT INTO Users (username, password, email, fullName, phone, roleId, status, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            // Băm mật khẩu trước khi lưu
            String passwordHash = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

            ps.setString(1, user.getUsername());
            ps.setString(2, passwordHash);
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Lỗi khi thêm người dùng: " + e.getMessage());
        }
        return false;
    }

// =================== UPDATE USER ===================
// Không cho phép cập nhật username và email
    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET fullName = ?, phone = ?, roleId = ?, status = ? WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setInt(3, user.getRoleId());
            ps.setString(4, user.getStatus());
            ps.setInt(5, user.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Lỗi khi cập nhật người dùng: " + e.getMessage());
        }
        return false;
    }
   // =================== Log của admin===================
    public List<Log> getAllLogs() {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.roleName, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l "
                + "LEFT JOIN Users u ON l.UserId = u.UserId "
                + "LEFT JOIN Roles r ON u.RoleId = r.RoleId "
                + "ORDER BY l.Timestamp DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("roleName"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
     // Lấy chi tiết log theo ID
    public Log getLogById(int logId) {
        String sql = "SELECT l.LogId, l.UserId, u.username, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l LEFT JOIN Users u ON l.UserId = u.UserId WHERE l.LogId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, logId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                return log;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
      // search log
      public List<Log> searchLogsByUser(String keyword) {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.role_name, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l "
                + "LEFT JOIN Users u ON l.UserId = u.UserId "
                + "LEFT JOIN Roles r ON u.RoleId = r.RoleId "
                + "WHERE u.username LIKE ? OR u.email LIKE ? "
                + "ORDER BY l.Timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("role_name"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

        public List<Log> searchLogsByAction(String action) {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.roleName, l.Action, l.Method, l.Timestamp \n"
                + "                FROM Logs l \n"
                + "                LEFT JOIN Users u ON l.UserId = u.UserId \n"
                + "                LEFT JOIN Roles r ON u.RoleId = r.RoleId \n"
                + "                WHERE l.Action = ? \n"
                + "                ORDER BY l.Timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, action);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("role_name"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
         public List<Log> searchLogsByRole(String role) {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.roleName, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l "
                + "LEFT JOIN Users u ON l.UserId = u.UserId "
                + "LEFT JOIN Roles r ON u.RoleId = r.RoleId "
                + "WHERE r.roleName = ? "
                + "ORDER BY l.Timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("roleName"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllActions() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT Action FROM Logs ORDER BY Action";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("Action"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
     public List<String[]> getAllRolesOfManager() throws SQLException {
        List<String[]> roles = new ArrayList<>();
        String sql = "SELECT roleId, roleName FROM Roles ORDER BY roleId";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(new String[]{String.valueOf(rs.getInt("roleId")), rs.getString("roleName")});
            }
        }
        return roles;
    }

    public List<String> getAllStatuses() throws SQLException {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM Users WHERE status IS NOT NULL ORDER BY status";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statuses.add(rs.getString("status"));
            }
        }
        return statuses;
    }
   

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("userId"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setEmail(rs.getString("email"));
        u.setFullName(rs.getString("fullName"));
        u.setPhone(rs.getString("phone"));
        u.setRoleId(rs.getInt("roleId"));
        u.setCreatedAt(rs.getTimestamp("createdAt"));
        u.setStatus(rs.getString("status"));
        return u;
    }

    public List<User> searchByUsername(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE roleId = 3 AND username LIKE ? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<User> searchByFullName(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE roleId = 3 AND fullName LIKE ? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<User> searchByEmail(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE roleId = 3 AND email LIKE ? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<User> searchByRole(int roleId) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE roleId = 3 AND roleId = ? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<User> searchByStatus(String status) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE roleId = 3 AND status = ? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public int getTotalUsersOfManager() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE roleId = 3";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
}