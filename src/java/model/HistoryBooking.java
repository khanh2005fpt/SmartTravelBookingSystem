/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Timestamp;
/**
 *
 * @author nqagh
 */
public class HistoryBooking {
    private int historyId;
    private int paymentId;
    private Integer accountUserId; // có thể null
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private Timestamp createdAt;
    private String tourStatus;
    //k có trong bang
    private String tourType;

    public HistoryBooking() {
    }
    
    

    public HistoryBooking(int historyId,  int paymentId, Integer accountUserId, String customerName, String customerEmail, String customerPhone, Timestamp createdAt, String tourStatus) {
        this.historyId = historyId;
        this.paymentId = paymentId;
        this.accountUserId = accountUserId;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.createdAt = createdAt;
        this.tourStatus = tourStatus;
    }


    public Integer getAccountUserId() {
        return accountUserId;
    }

    public void setAccountUserId(Integer accountUserId) {
        this.accountUserId = accountUserId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }


    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }


    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }


    public String getTourStatus() {
        return tourStatus;
    }

    public void setTourStatus(String tourStatus) {
        this.tourStatus = tourStatus;
    }

    public String getTourType() {
        return tourType;
    }

    public void setTourType(String tourType) {
        this.tourType = tourType;
    }
    
    

    @Override
    public String toString() {
        return "HistoryBooking{" + "historyId=" + historyId + ", paymentId=" + paymentId + ", accountUserId=" + accountUserId + ", customerName=" + customerName + ", customerEmail=" + customerEmail + ", customerPhone=" + customerPhone + ", createdAt=" + createdAt + ", tourStatus=" + tourStatus + '}';
    }

    
    
    
}
