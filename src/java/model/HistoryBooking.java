/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */
public class HistoryBooking {
      private int historyId;
    private int customerId;
    private int paymentId;
    private String note;
    private String tourStatus;

    public HistoryBooking() {
    }

    public HistoryBooking(int historyId, int customerId, int paymentId, String note, String tourStatus) {
        this.historyId = historyId;
        this.customerId = customerId;
        this.paymentId = paymentId;
        this.note = note;
        this.tourStatus = tourStatus;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getTourStatus() {
        return tourStatus;
    }

    public void setTourStatus(String tourStatus) {
        this.tourStatus = tourStatus;
    }

    @Override
    public String toString() {
        return "HistoryBooking{" + "historyId=" + historyId + ", customerId=" + customerId + ", paymentId=" + paymentId + ", note=" + note + ", tourStatus=" + tourStatus + '}';
    }
    
    
}
