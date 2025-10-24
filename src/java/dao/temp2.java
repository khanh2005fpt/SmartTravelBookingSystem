package dao;

import model.User;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DBContext {

    // Lấy danh sách khách hàng
    public List<User> getAllCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, username, password, email, fullName, phone, roleId, createdAt, status " +
                     "FROM Users WHERE roleId = '3'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy thông tin chi tiết của khách hàng theo ID
    public User getCustomerById(int id) {
        String sql = "SELECT userId, username, password, email, fullName, phone, roleId, createdAt, status " +
                     "FROM Users WHERE userId = ? AND roleId = '3'";
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

    // 🧪 Test main()
    public static void main(String[] args) {
        CustomerDAO dao = new CustomerDAO();

        System.out.println("===== Danh sách khách hàng =====");
        List<User> list = dao.getAllCustomers();
        for (User u : list) {
            System.out.println(u);
        }

        System.out.println("\n===== Kiểm tra lấy chi tiết khách hàng ID = 1 =====");
        User detail = dao.getCustomerById(1); // thay ID cho phù hợp với DB của bạn
        if (detail != null) {
            System.out.println(detail);
        } else {
            System.out.println("Không tìm thấy khách hàng với ID này!");
        }
    }
}
