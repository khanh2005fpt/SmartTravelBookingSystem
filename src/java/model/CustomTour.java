/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author Admin
 */
public class CustomTour {
    private int customTourId;
    private String customerName;
    private String tourName;
    private String islandName;
    private double totalPrice;
    private String startDate; 
    private String endDate;
    private List<CustomTourDetail> details;

    public CustomTour() {
    }

    public CustomTour(int customTourId, String customerName, String tourName, String islandName, double totalPrice, String startDate, String endDate, List<CustomTourDetail> details) {
        this.customTourId = customTourId;
        this.customerName = customerName;
        this.tourName = tourName;
        this.islandName = islandName;
        this.totalPrice = totalPrice;
        this.startDate = startDate;
        this.endDate = endDate;
        this.details = details;
    }

    public int getCustomTourId() {
        return customTourId;
    }

    public void setCustomTourId(int customTourId) {
        this.customTourId = customTourId;
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

    public String getIslandName() {
        return islandName;
    }

    public void setIslandName(String islandName) {
        this.islandName = islandName;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public List<CustomTourDetail> getDetails() {
        return details;
    }

    public void setDetails(List<CustomTourDetail> details) {
        this.details = details;
    }
    
    
}
