/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Notification;
import utils.DBContext;
import java.sql.ResultSet;

/**
 *
 * @author nqagh
 */
public class NotificationDao extends DBContext{
  public static NotificationDao INSTANCE = new NotificationDao();
    // lay list thong bao 
    
    public List<Notification> getNotificationByUser(int userId){
        
        List <Notification> list = new ArrayList<>();
        
        try{
            
                   String sql = "SELECT * FROM Notifications WHERE userId = ? ORDER BY createdAt DESC";
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
       public static void main(String[] args) {
    NotificationDao dao = new NotificationDao();
    List<Notification> listNotification = dao.getNotificationByUser(2);

    for(Notification notification : listNotification){
        System.out.println(notification.getType()); // in chi tiết từng notification
    }
}
   
}
