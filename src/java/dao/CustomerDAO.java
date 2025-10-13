package dao;

import model.User;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DBContext {

    // ✅ Lấy tất cả khách hàng có phân trang
    public List<User> getAllCustomers(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, email, fullName, phone, roleId, createdAt, status " +
                     "FROM Users WHERE roleId = '29' " +
                     "ORDER BY userId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
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
                u.setRole(rs.getString("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Đếm tổng khách hàng
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE roleId = '29'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Lấy chi tiết khách hàng theo ID
    public User getCustomerById(int id) {
        String sql = "SELECT * FROM Users WHERE userId = ? AND roleId = '29'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Tìm kiếm khách hàng theo tên hoặc email
    public List<User> searchCustomers(String keyword, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, email, fullName, phone, roleId, createdAt, status " +
                     "FROM Users WHERE roleId = '29' AND (fullName LIKE ? OR email LIKE ?) " +
                     "ORDER BY userId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
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
                u.setRole(rs.getString("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lọc khách hàng theo trạng thái (ACTIVE / INACTIVE / ALL)
    public List<User> filterCustomersByStatus(String status, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, email, fullName, phone, roleId, createdAt, status " +
                     "FROM Users WHERE roleId = '29' ";
        if (!status.equalsIgnoreCase("ALL")) {
            sql += "AND status = ? ";
        }
        sql += "ORDER BY userId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int paramIndex = 1;
            if (!status.equalsIgnoreCase("ALL")) {
                ps.setString(paramIndex++, status);
            }
            int offset = (page - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("roleId"));
                u.setCreatedAt(rs.getDate("createdAt"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🧪 MAIN TEST
    public static void main(String[] args) {
        CustomerDAO dao = new CustomerDAO();

        System.out.println("===== 1️⃣ Danh sách khách hàng (trang 1) =====");
        List<User> list = dao.getAllCustomers(1, 10);
        for (User u : list) {
            System.out.println(u);
        }

        System.out.println("\n===== 2️⃣ Tổng số khách hàng =====");
        int total = dao.getTotalCustomers();
        System.out.println("Tổng số khách hàng: " + total);

        System.out.println("\n===== 3️⃣ Tìm kiếm theo từ khóa 'David' =====");
        List<User> search = dao.searchCustomers("David", 1, 10);
        for (User u : search) {
            System.out.println(u);
        }

        System.out.println("\n===== 4️⃣ Lọc theo trạng thái ACTIVE =====");
        List<User> active = dao.filterCustomersByStatus("ACTIVE", 1, 10);
        for (User u : active) {
            System.out.println(u);
        }

        System.out.println("\n===== 5️⃣ Lấy chi tiết khách hàng có ID = 1 =====");
        User detail = dao.getCustomerById(1);
        if (detail != null) {
            System.out.println(detail);
        } else {
            System.out.println("❌ Không tìm thấy khách hàng có ID = 1");
        }

        System.out.println("\n===== ✅ HOÀN TẤT TEST CustomerDAO =====");
    }
}
