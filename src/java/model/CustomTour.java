/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author Admin
 */
public class CustomTour {
    private int customTourId;
    private String tourName;
    private int islandId;
    private int totalPrice;
    private LocalDate startDate; 
    private LocalDate endDate;

    public CustomTour() {
    }

    public CustomTour(String tourName, int islandId, LocalDate startDate, LocalDate endDate, int totalPrice) {
        this.tourName = tourName;
        this.islandId = islandId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalPrice = totalPrice;
    }

    public CustomTour(int customTourId, String tourName, int islandId, int totalPrice, LocalDate startDate, LocalDate endDate) {
        this.customTourId = customTourId;
        this.tourName = tourName;
        this.islandId = islandId;
        this.totalPrice = totalPrice;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    

    

   

    public int getCustomTourId() {
        return customTourId;
    }

    public void setCustomTourId(int customTourId) {
        this.customTourId = customTourId;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    
    

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    
}
