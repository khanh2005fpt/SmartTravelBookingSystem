/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.DashboardOverview;
import utils.DBContext;

public class SystemDao extends DBContext {

    public DashboardOverview getDashboardOverview() {
        DashboardOverview overview = new DashboardOverview();
        Connection con = connection;

        try {
            //  Tổng người dùng
            String sqlUsers = "SELECT COUNT(*) FROM Users";
            try (PreparedStatement ps = con.prepareStatement(sqlUsers); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    overview.setTotalUsers(rs.getInt(1));
                }
            }

            //  Tổng booking
            String sqlBookings = "SELECT COUNT(*) FROM Bookings";
            try (PreparedStatement ps = con.prepareStatement(sqlBookings); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    overview.setTotalBookings(rs.getInt(1));
                }
            }

            //  Tổng dịch vụ (4 bảng)
            String sqlServices = """
                SELECT (
                    (SELECT COUNT(*) FROM Hotels) +
                    (SELECT COUNT(*) FROM Flights) +
                    (SELECT COUNT(*) FROM IslandVehicles) +
                    (SELECT COUNT(*) FROM Places)
                ) AS total
            """;
            try (PreparedStatement ps = con.prepareStatement(sqlServices); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    overview.setTotalServices(rs.getInt("total"));
                }
            }

            // Tổng payment
            String sqlPayments = "SELECT COUNT(*) FROM Payments";
            try (PreparedStatement ps = con.prepareStatement(sqlPayments); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    overview.setTotalPayments(rs.getInt(1));
                }
            }

            //  Tổng doanh thu (Payments thành công)
            String sqlRevenue = "SELECT SUM(amount) FROM Payments WHERE status='SUCCESS'";
            try (PreparedStatement ps = con.prepareStatement(sqlRevenue); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    overview.setTotalRevenue(rs.getDouble(1));
                }
            }

            //  Doanh thu theo tháng (Monthly revenue)
            String sqlMonthly = """
    SELECT FORMAT(b.bookingDate, 'yyyy-MM') AS month, SUM(p.amount) AS total
    FROM Payments p
    JOIN Bookings b ON p.bookingId = b.bookingId
    WHERE p.status = 'SUCCESS'
    GROUP BY FORMAT(b.bookingDate, 'yyyy-MM')
    ORDER BY month ASC
""";

            Map<String, Double> monthlyRevenue = new LinkedHashMap<>();
            try (PreparedStatement ps = con.prepareStatement(sqlMonthly); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    monthlyRevenue.put(rs.getString("month"), rs.getDouble("total"));
                }
            }
            overview.setMonthlyRevenue(monthlyRevenue);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return overview;
    }

    // ===================== 1️⃣ DOANH THU THEO THÁNG =====================
    public Map<String, Double> getMonthlyRevenue() throws SQLException {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql
                = "SELECT FORMAT(b.bookingDate, 'yyyy-MM') AS month, "
                + "       SUM(p.amount) AS totalRevenue "
                + "FROM Payments p "
                + "JOIN Bookings b ON p.bookingId = b.bookingId "
                + "WHERE p.status = 'Success' "
                + "GROUP BY FORMAT(b.bookingDate, 'yyyy-MM') "
                + "ORDER BY month;";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.put(rs.getString("month"), rs.getDouble("totalRevenue"));
            }
        }
        return data;
    }

    // ===================== 2️⃣ SỐ LƯỢNG ĐẶT CHỖ THEO THÁNG =====================
    public Map<String, Integer> getMonthlyBookings() throws SQLException {
        Map<String, Integer> data = new LinkedHashMap<>();
        String sql
                = "SELECT FORMAT(b.bookingDate, 'yyyy-MM') AS month, "
                + "       COUNT(b.bookingId) AS totalBookings "
                + "FROM Bookings b "
                + "GROUP BY FORMAT(b.bookingDate, 'yyyy-MM') "
                + "ORDER BY month;";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.put(rs.getString("month"), rs.getInt("totalBookings"));
            }
        }
        return data;
    }

    // ===================== 3️⃣ HIỆU SUẤT DỊCH VỤ =====================
    public List<Map<String, Object>> getServicePerformance() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql
                = "SELECT t.tourName AS serviceName, "
                + "       COUNT(b.bookingId) AS totalBookings, "
                + "       SUM(b.totalPrice) AS totalRevenue "
                + "FROM Bookings b "
                + "LEFT JOIN Tours t ON b.tourId = t.tourId "
                + "GROUP BY t.tourName "
                + "ORDER BY totalRevenue DESC;";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("serviceName", rs.getString("serviceName"));
                map.put("totalBookings", rs.getInt("totalBookings"));
                map.put("totalRevenue", rs.getDouble("totalRevenue"));
                list.add(map);
            }
        }
        return list;
    }
}
