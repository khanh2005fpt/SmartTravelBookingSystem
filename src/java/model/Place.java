/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Place {
    private int placeId;
    private int islandId;
    private String placeName;
    private String location;
    private String description;
    private boolean hasTicket;
    private int ticketPrice;
    
    // Additional field for joins
    private String placeImageUrl;
    private String islandName;
    private String countryName;

    public Place() {
    }

    public Place(int placeId, int islandId, String placeName, String location, String description, boolean hasTicket, int ticketPrice, String placeImageUrl) {
        this.placeId = placeId;
        this.islandId = islandId;
        this.placeName = placeName;
        this.location = location;
        this.description = description;
        this.hasTicket = hasTicket;
        this.ticketPrice = ticketPrice;
        this.placeImageUrl = placeImageUrl;
    }

    public int getPlaceId() {
        return placeId;
    }

    public void setPlaceId(int placeId) {
        this.placeId = placeId;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public String getPlaceName() {
        return placeName;
    }

    public void setPlaceName(String placeName) {
        this.placeName = placeName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isHasTicket() {
        return hasTicket;
    }

    public void setHasTicket(boolean hasTicket) {
        this.hasTicket = hasTicket;
    }

    public int getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(int ticketPrice) {
        this.ticketPrice = ticketPrice;
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

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getPlaceImageUrl() {
        return placeImageUrl;
    }

    public void setPlaceImageUrl(String placeImageUrl) {
        this.placeImageUrl = placeImageUrl;
    }
    
    @Override
    public String toString() {
        return "Place{" + "placeId=" + placeId + ", islandId=" + islandId + ", placeName=" + placeName + ", location=" + location + ", description=" + description + ", hasTicket=" + hasTicket + ", ticketPrice=" + ticketPrice + ", islandName=" + islandName + '}';
    }
    
    
}
