package dao;

import utils.DBContext;
import java.sql.*;
import java.util.*;
import model.Log;

public class LogDAO extends DBContext {

    public List<Log> getAllLogs() {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.roleName, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l "
                + "LEFT JOIN Users u ON l.UserId = u.UserId "
                + "LEFT JOIN Roles r ON u.RoleId = r.RoleId "
                + "ORDER BY l.Timestamp DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("roleName"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy chi tiết log theo ID
    public Log getLogById(int logId) {
        String sql = "SELECT l.LogId, l.UserId, u.username, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l LEFT JOIN Users u ON l.UserId = u.UserId WHERE l.LogId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, logId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                return log;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Log> searchLogsByUser(String keyword) {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.role_name, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l "
                + "LEFT JOIN Users u ON l.UserId = u.UserId "
                + "LEFT JOIN Roles r ON u.RoleId = r.RoleId "
                + "WHERE u.username LIKE ? OR u.email LIKE ? "
                + "ORDER BY l.Timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("role_name"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Log> searchLogsByAction(String action) {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.roleName, l.Action, l.Method, l.Timestamp \n"
                + "                FROM Logs l \n"
                + "                LEFT JOIN Users u ON l.UserId = u.UserId \n"
                + "                LEFT JOIN Roles r ON u.RoleId = r.RoleId \n"
                + "                WHERE l.Action = ? \n"
                + "                ORDER BY l.Timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, action);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("role_name"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Log> searchLogsByRole(String role) {
        List<Log> list = new ArrayList<>();
        String sql = "SELECT l.LogId, l.UserId, u.username, r.roleName, l.Action, l.Method, l.Timestamp "
                + "FROM Logs l "
                + "LEFT JOIN Users u ON l.UserId = u.UserId "
                + "LEFT JOIN Roles r ON u.RoleId = r.RoleId "
                + "WHERE r.roleName = ? "
                + "ORDER BY l.Timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Log log = new Log();
                log.setLogId(rs.getInt("LogId"));
                log.setUserId(rs.getInt("UserId"));
                log.setUsername(rs.getString("username"));
                log.setRoleName(rs.getString("roleName"));
                log.setAction(rs.getString("Action"));
                log.setMethod(rs.getString("Method"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllActions() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT Action FROM Logs ORDER BY Action";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("Action"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
