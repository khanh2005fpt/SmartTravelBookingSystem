/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */
public class PhoneCustomer {
    private int phoneId;
    private int userId;
    private String phone;

    public PhoneCustomer() {
    }

    public PhoneCustomer(int phoneId, int userId, String phone) {
        this.phoneId = phoneId;
        this.userId = userId;
        this.phone = phone;
    }

    public int getPhoneId() {
        return phoneId;
    }

    public void setPhoneId(int phoneId) {
        this.phoneId = phoneId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "PhoneCustomer{" + "phoneId=" + phoneId + ", userId=" + userId + ", phone=" + phone + '}';
    }
    
}
