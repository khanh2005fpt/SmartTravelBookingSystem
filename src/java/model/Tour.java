/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.text.DecimalFormat;

/**
 *
 * @author Admin
 */
public class Tour {
    private int tourId;
    private int islandId;
    private String tourName;
    private String description;
    private int price;
    private String tourImageUrl;
    private String islandName; // Added for displaying island name
    private String approvalStatus; // PENDING, APPROVED, REJECTED
    private int availableQuantity; // Số lượng tour còn lại
    private String rejectionReason; // Lý do từ chối khi approvalStatus = REJECTED

    public Tour() {
    }

    public Tour(int tourId, int islandId, String tourName, String description, int price, String tourImageUrl) {
        this.tourId = tourId;
        this.islandId = islandId;
        this.tourName = tourName;
        this.description = description;
        this.price = price;
        this.tourImageUrl = tourImageUrl;
    }

   

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getTourImageUrl() {
        return tourImageUrl;
    }

    public void setTourImageUrl(String tourImageUrl) {
        this.tourImageUrl = tourImageUrl;
    }

    public String getIslandName() {
        return islandName;
    }

    public void setIslandName(String islandName) {
        this.islandName = islandName;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public int getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    @Override
    public String toString() {
        return "Tour{" + "tourId=" + tourId + ", islandId=" + islandId + ", tourName=" + tourName + ", description=" + description + ", price=" + price + ", tourImageUrl=" + tourImageUrl + ", islandName=" + islandName + ", availableQuantity=" + availableQuantity + '}' + "\n";
    }
    
    
}
