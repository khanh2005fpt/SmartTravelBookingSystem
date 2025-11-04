/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */
 import java.util.Date;
public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String fullName;
    private String phone;
    private int roleId;
    private Date createdAt;
    private String status;


    public User() {}

  
  
    public User(int userId, String username, String password, String email, 
                String fullName, String phone, int roleId, Date createdAt, String status) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.roleId = roleId;
        this.createdAt = createdAt;
        this.status = status;
    }

     public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Get role name based on roleId
     * @return role name as string
     */
    public String getRole() {
        switch (this.roleId) {
            case 1:
                return "admin";
            case 2:
                return "booking_manager";
            case 3:
                return "customer";
            case 4:
                return "staff";
            default:
                return "unknown";
        }
    }

    // toString
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", role='" + roleId + '\'' +
                ", createdAt=" + createdAt +'\'' +
                 ", status=" + status+
                '}';
    }
}