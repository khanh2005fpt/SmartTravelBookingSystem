/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.SecureRandom;
import model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.CallableStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
            String sqlPass = "UPDATE Users\n"
                    + "SET Password = ?\n"
                    + "WHERE Email = ?";
            try (PreparedStatement ps = connection.prepareStatement(sqlPass)) {
                ps.setString(1, email);
                ps.setString(2, password);

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

}
