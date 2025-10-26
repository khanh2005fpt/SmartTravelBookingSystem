/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */
public class EmailCustomer {
      private int emailId;
    private int userId;
    private String email;
    private boolean isPrimary;

    public EmailCustomer() {
    }

    public EmailCustomer(int emailId, int userId, String email , boolean isPrimary) {
        this.emailId = emailId;
        this.userId = userId;
        this.email = email;
        this.isPrimary=isPrimary;
    }

    public int getEmailId() {
        return emailId;
    }

    public boolean isIsPrimary() {
        return isPrimary;
    }

    public void setIsPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    public void setEmailId(int emailId) {
        this.emailId = emailId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "EmailCustomer{" + "emailId=" + emailId + ", userId=" + userId + ", email=" + email + ", isPrimary=" + isPrimary + '}';
    }

   
    
}
