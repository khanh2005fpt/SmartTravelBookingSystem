/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author PC
 */
public class UserDAO {
    public List<User> findAll() throws Exception {
        String sql = "SELECT id, name, email, role, active FROM users ORDER BY id DESC";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<User> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new User(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getBoolean("active")
                ));
            }
            return list;
        }
    }

    public void insert(User u) throws Exception {
        String sql = "INSERT INTO users(name, email, role, active) VALUES(?,?,?,?)";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getRole());
            ps.setBoolean(4, u.isActive());
            ps.executeUpdate();
        }
    }
}
