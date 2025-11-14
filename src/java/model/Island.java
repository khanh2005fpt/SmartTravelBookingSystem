/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Island {

     private int islandId;
    private String islandName;
    private int countryId;
    private String countryName;
    private String shortDescription;
    private String longDescription;
    private String bestSeason;
    private String activities;
    private String imageUrl;
    private String location;
    private String approvalStatus;

    public Island() {
    }

    public Island(int islandId, String islandName, String countryName, String shortDescription, String longDescription, String bestSeason, String activities, String imageUrl, String location) {
        this.islandId = islandId;
        this.islandName = islandName;
        this.countryName = countryName;
        this.shortDescription = shortDescription;
        this.longDescription = longDescription;
        this.bestSeason = bestSeason;
        this.activities = activities;
        this.imageUrl = imageUrl;
        this.location = location;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public String getIslandName() {
        return islandName;
    }

    public void setIslandName(String islandName) {
        this.islandName = islandName;
    }

    public int getCountryId() {
        return countryId;
    }

    public void setCountryId(int countryId) {
        this.countryId = countryId;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getLongDescription() {
        return longDescription;
    }

    public void setLongDescription(String longDescription) {
        this.longDescription = longDescription;
    }

    public String getBestSeason() {
        return bestSeason;
    }

    public void setBestSeason(String bestSeason) {
        this.bestSeason = bestSeason;
    }

    public String getActivities() {
        return activities;
    }

    public void setActivities(String activities) {
        this.activities = activities;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    @Override
    public String toString() {
        return "Island{" + "islandId=" + islandId + ", islandName=" + islandName + ", countryName=" + countryName + ", shortDescription=" + shortDescription + ", longDescription=" + longDescription + ", bestSeason=" + bestSeason + ", activities=" + activities + ", imageUrl=" + imageUrl + ", location=" + location + ", approvalStatus=" + approvalStatus + '}' + "\n";
    }
    
    
   
    
}