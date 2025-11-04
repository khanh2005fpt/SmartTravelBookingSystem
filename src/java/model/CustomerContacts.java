/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */
public class CustomerContacts {
      private int contactId;
    private int userId;
    private String contactType; // "EMAIL" hoặc "PHONE"
    private String contactValue; 
    private boolean isPrimary;

    public CustomerContacts() {
    }

    public CustomerContacts(int contactId, int userId, String contactType, String contactValue, boolean isPrimary) {
        this.contactId = contactId;
        this.userId = userId;
        this.contactType = contactType;
        this.contactValue = contactValue;
        this.isPrimary = isPrimary;
    }

    public int getContactId() {
        return contactId;
    }

    public void setContactId(int contactId) {
        this.contactId = contactId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getContactType() {
        return contactType;
    }

    public void setContactType(String contactType) {
        this.contactType = contactType;
    }

    public String getContactValue() {
        return contactValue;
    }

    public void setContactValue(String contactValue) {
        this.contactValue = contactValue;
    }

    public boolean isIsPrimary() {
        return isPrimary;
    }

    public void setIsPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    @Override
    public String toString() {
        return "CustomerContacts{" + "contactId=" + contactId + ", userId=" + userId + ", contactType=" + contactType + ", contactValue=" + contactValue + ", isPrimary=" + isPrimary + '}';
    }
    
    
}
