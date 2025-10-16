package dao;

import java.sql.*;
import java.util.*;
import model.ReportRevenue;
import utils.DBContext;

public class ReportDao extends DBContext {

    public static ReportDao INSTANCE = new ReportDao();

    public List<ReportRevenue> getMonthlyRevenueWithCounts() {
        List<ReportRevenue> list = new ArrayList<>();

        String sql = """
            SELECT 
                FORMAT(bookingDate, 'MM-yyyy') AS Month,
                SUM(CASE WHEN status = 'CONFIRMED' THEN price ELSE 0 END) AS ConfirmedRevenue,
                SUM(CASE WHEN status = 'PENDING' THEN price ELSE 0 END) AS PendingRevenue,
                SUM(price) AS TotalRevenue,
                COUNT(CASE WHEN status = 'CONFIRMED' THEN 1 END) AS ConfirmedCount,
                COUNT(CASE WHEN status = 'PENDING' THEN 1 END) AS PendingCount
            FROM Bookings
            GROUP BY FORMAT(bookingDate, 'MM-yyyy')
            ORDER BY MIN(bookingDate)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ReportRevenue r = new ReportRevenue();
                r.setMonth(rs.getString("Month"));
                r.setConfirmedRevenue(rs.getDouble("ConfirmedRevenue"));
                r.setPendingRevenue(rs.getDouble("PendingRevenue"));
                r.setTotalRevenue(rs.getDouble("TotalRevenue"));
                r.setConfirmedCount(rs.getInt("ConfirmedCount"));
                r.setPendingCount(rs.getInt("PendingCount"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
