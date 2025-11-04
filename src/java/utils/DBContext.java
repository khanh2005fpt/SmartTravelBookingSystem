/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBContext {
    protected Connection connection;
    public DBContext()
    {
        try {
String url = "jdbc:sqlserver://localhost:1433;databaseName=SmartTravelBooking;encrypt=true;trustServerCertificate=true;loginTimeout=30;";
            String username = "sa";
            String password = "12345";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
            
               if (connection != null) {
                System.out.println("✅ Kết nối cơ sở dữ liệu thành công!");
            } else {
                System.out.println("❌ Kết nối cơ sở dữ liệu thất bại!");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        DBContext db = new DBContext();
        
    }
}
