/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Hotel {
    private int hotelId;
    private int islandId;
    private String hotelName;
    private String countryName;
    private String hotelImageUrl;
    private String roomType;
    private int pricePerNight;
    private int roomAvailable;
    private double rating;

    public Hotel() {
    }

    public Hotel(int hotelId, int islandId, String hotelName, String countryName, String hotelImageUrl, String roomType, int pricePerNight, int roomAvailable, double rating) {
        this.hotelId = hotelId;
        this.islandId = islandId;
        this.hotelName = hotelName;
        this.countryName = countryName;
        this.hotelImageUrl = hotelImageUrl;
        this.roomType = roomType;
        this.pricePerNight = pricePerNight;
        this.roomAvailable = roomAvailable;
        this.rating = rating;
    }
    
   
    
    
    public int getHotelId() {
        return hotelId;
    }

    public void setHotelId(int hotelId) {
        this.hotelId = hotelId;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }
    
    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getHotelImageUrl() {
        return hotelImageUrl;
    }

    public void setHotelImageUrl(String hotelImageUrl) {
        this.hotelImageUrl = hotelImageUrl;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(int pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public int getRoomAvailable() {
        return roomAvailable;
    }

    public void setRoomAvailable(int roomAvailable) {
        this.roomAvailable = roomAvailable;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    @Override
    public String toString() {
        return "Hotel{" + "hotelId=" + hotelId + ", islandId=" + islandId + ", hotelName=" + hotelName + ", countryName=" + countryName + ", hotelImageUrl=" + hotelImageUrl + ", roomType=" + roomType + ", pricePerNight=" + pricePerNight + ", roomAvailable=" + roomAvailable + ", rating=" + rating + '}' + "\n";
    }

    
    
    
}
