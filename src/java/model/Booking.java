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
    private int profileId;
    private int customerId;
    private int tourId;
    private int customTourId;
    private int price;
    private Date departureDate;
    private Date endDate;
    private int adultQuantity;
    private int childQuantity;
    private String status;
    private Date bookingDate;
    
    // Additional fields for display purposes
    private String customerName;
    private String tourName;
    private String customTourName;

    public Booking() {
    }

    public Booking(int profileId, int customerId, int tourId, int customTourId, int price, 
                   Date departureDate, Date endDate, int adultQuantity, int childQuantity, String status) {
        this.profileId = profileId;
        this.customerId = customerId;
        this.tourId = tourId;
        this.customTourId = customTourId;
        this.price = price;
        this.departureDate = departureDate;
        this.endDate = endDate;
        this.adultQuantity = adultQuantity;
        this.childQuantity = childQuantity;
        this.status = status;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
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

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public int getCustomTourId() {
        return customTourId;
    }

    public void setCustomTourId(int customTourId) {
        this.customTourId = customTourId;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getCustomTourName() {
        return customTourName;
    }

    public void setCustomTourName(String customTourName) {
        this.customTourName = customTourName;
    }
}
