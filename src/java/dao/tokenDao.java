/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author nqagh
 */
import model.Token;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.text.DateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;
import utils.DBContext;

public class tokenDao extends DBContext {

    private static final tokenDao INSTANCE = new tokenDao();

    public static tokenDao getInstance() {
        return INSTANCE;
    }

    public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = myDateObj.format(myFormatObj);
        return formattedDate;
    }

    // luu token moi
    public boolean insertToken(Token tokenForget) {

        try {
            String sqlToken = "INSERT INTO Tokens (UserId, TokenValue, ExpiryDate, IsUsed) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(sqlToken)) {
                ps.setInt(1, tokenForget.getUserId());
                ps.setString(2, tokenForget.getTokenValue());
                ps.setTimestamp(3, Timestamp.valueOf(tokenForget.getExpiryDate()));
                ps.setBoolean(4, tokenForget.isIsUsed());

                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
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
                            rs.getBoolean("IsUsed")
                    );
                    

                    
                }
            }

        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

}
