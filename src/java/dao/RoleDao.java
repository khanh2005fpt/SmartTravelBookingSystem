package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Role;
import utils.DBContext;

public class RoleDao extends DBContext {

    public static RoleDao INSTANCE = new RoleDao();

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT roleId, roleName FROM Roles";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Role(rs.getInt("roleId"), rs.getString("roleName")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getRoleNameById(int id) {
        try (PreparedStatement ps = connection.prepareStatement("SELECT roleName FROM Roles WHERE roleId=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("roleName");
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
