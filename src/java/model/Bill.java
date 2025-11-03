/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Timestamp;
/**
 *
 * @author Admin
 */
public class Bill {
    private int paymentId;
    private String fullname;
    private String phone;
    private Timestamp createdAt;
    private String tourName;
    private long amount;
    private String status;

    public Bill() {
    }

    public Bill(int paymentId, String fullname, String phone, Timestamp createdAt, String tourName, long amount, String status) {
        this.paymentId = paymentId;
        this.fullname = fullname;
        this.phone = phone;
        this.createdAt = createdAt;
        this.tourName = tourName;
        this.amount = amount;
        this.status = status;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

   

    

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Bill{" + "paymentId=" + paymentId + ", fullname=" + fullname + ", phone=" + phone + ", createdAt=" + createdAt + ", tourName=" + tourName + ", amount=" + amount + ", status=" + status + '}';
    }

   
    
    
}
