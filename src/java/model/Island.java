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
    private String countryName;
    private String description;
    private String bestSeason;
    private String activities;
    private String imageUrl;

    public Island() {
    }
    
    
    public Island(int islandId, String islandName, String countryName, String description, String bestSeason, String activities, String imageUrl) {
        this.islandId = islandId;
        this.islandName = islandName;
        this.countryName = countryName;
        this.description = description;
        this.bestSeason = bestSeason;
        this.activities = activities;
        this.imageUrl = imageUrl;
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

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String country) {
        this.countryName = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    @Override
    public String toString() {
        return "Island{" + "islandId=" + islandId + ", islandName=" + islandName + ", countryName=" + countryName + ", description=" + description + ", bestSeason=" + bestSeason + ", activities=" + activities + ", imageUrl=" + imageUrl + '}' + "\n";
    }
    
    
}
