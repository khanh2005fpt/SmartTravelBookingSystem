package dao;

import java.sql.*;
import java.util.*;
import model.Role;
import utils.DBContext;

public class RoleDAO extends DBContext {

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT roleId, roleName FROM Roles ORDER BY roleName";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("roleId"));
                r.setRoleName(rs.getString("roleName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
