/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class Booking {

    private int bookingId;
    private int customerId;
    private Integer tourId;
    private Integer customTourId;
    private Date departureDate;
    private Date endDate;
    private int adultQuantity;
    private int childQuantity;
    private double totalPrice;
    private String status;

    public Booking() {
    }

    public Booking(int bookingId, int customerId, Integer tourId, Integer customTourId, Date departureDate, Date endDate, int adultQuantity, int childQuantity, double totalPrice, String status) {
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.tourId = tourId;
        this.customTourId = customTourId;
        this.departureDate = departureDate;
        this.endDate = endDate;
        this.adultQuantity = adultQuantity;
        this.childQuantity = childQuantity;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }
    

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getTourId() {
        return tourId;
    }

    public void setTourId(Integer tourId) {
        this.tourId = tourId;
    }

    public Integer getCustomTourId() {
        return customTourId;
    }

    public void setCustomTourId(Integer customTourId) {
        this.customTourId = customTourId;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    
    public Date getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(Date departureDate) {
        this.departureDate = departureDate;
    }

    public int getAdultQuantity() {
        return adultQuantity;
    }

    public void setAdultQuantity(int adultQuantity) {
        this.adultQuantity = adultQuantity;
    }

    public int getChildQuantity() {
        return childQuantity;
    }

    public void setChildQuantity(int childQuantity) {
        this.childQuantity = childQuantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}
