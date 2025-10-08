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
import model.Token;
import utils.DBContext;

/**
 *
 * @author nqagh
 */
public class userDao extends DBContext {

    public static userDao INSTANCE = new userDao();

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

    public static void main(String[] args) {
        userDao dao = new userDao();
        String email = "nqaghuyyy6969@gmail.com";
        User existing = dao.getUserByEmail(email);
        if (existing != null) {
            System.out.println("ton tai email login thanh cong");
        } else {
            System.out.println(" email chưa ton tai co the dky");
        }
    }

}
