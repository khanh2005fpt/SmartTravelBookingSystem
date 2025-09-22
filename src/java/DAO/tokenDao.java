/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author nqagh
 */
  import Model.Token;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Optional;
import utils.DBContext;
public class tokenDao extends DBContext {
    private static final tokenDao INSTANCE = new tokenDao();
      
     public static tokenDao getInstance(){
         return INSTANCE;
     }
     
     // luu token moi
     
     public void saveToken(int userId , String tokenValue ,LocalDateTime expiryDate){
         
         try{
             String sqlToken ="INSERT INTO Tokens (UserId, TokenValue, ExpiryDate, IsUsed, CreatedDate) VALUES (?, ?, ?, 0, GETDATE())";
             try(PreparedStatement ps = connection.prepareStatement(sqlToken)){
                   ps.setInt(1, userId);
                   ps.setString(2, tokenValue);
                   ps.setTimestamp(3, Timestamp.valueOf(expiryDate));
                   ps.executeUpdate();
             }
         }catch(SQLException e){
               String errorMessage = "Lỗi khi luu token: " + e.getMessage();
         }
     }
     
     //lay token theo value 
     
     public Optional <Token> getToken(String tokenValue){
                try{
                       String sqlGetToken = "SELECT * FROM Tokens WHERE TokenValue =?";
                    try(PreparedStatement ps = connection.prepareStatement(sqlGetToken)){
                       ps.setString(1, tokenValue);
                       ResultSet rs = ps.executeQuery();
                       if(rs.next()){
                           Token token = new Token(
                             rs.getInt("TokenId"),
                             rs.getInt("UserId"),
                             rs.getString("TokenValue"),
                             rs.getTimestamp("ExpiryDate"),
                             rs.getBoolean("IsUsed"),
                             rs.getTimestamp("CreateDate")
                           
                           
                           );
                           
                          // tra ve token
                          
                          return Optional.of(token);
                       }
                       
                    }
                }catch(SQLException e){
                     String errorMessage = "Lỗi khi lay token: " + e.getMessage();
                }
                return Optional.empty();
     }
     
     // danh dau token da su dung
       public void markTokenAsUsed(String tokenValue ){
         
           try{
                  String sqlMark = "UPDATE Tokens SET IsUsed = 1 WHERE TokenValue=?";
                  try(PreparedStatement ps = connection.prepareStatement(sqlMark)){
                      ps.setString(1, tokenValue);
                      ps.executeUpdate();             
                  }
               
           }catch(SQLException e){
                   String errorMessage = "Lỗi khi danh dau token: " + e.getMessage();
           }
       }
       
       // xoa token het han 
       
       public void deleteExpiredTokens(){
           
           try{
                String sql ="DELETE FROM Tokens WHERE ExpiryDate < GetDate() OR IsUsed=1";
                try(PreparedStatement ps = connection.prepareStatement(sql)){
                    ps.executeUpdate();
                }
           }catch(SQLException e){
                 String errorMessage = "Lỗi khi xoa token: " + e.getMessage();
           }
          
           
       }
    
}
