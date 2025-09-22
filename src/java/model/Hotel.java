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
    private String hotelName;
    private String country;
    private String imageUrl;
    private String roomType;
    private int pricePerNight;
    private int roomAvailable;
    private double rating;

    public Hotel() {
    }
    
    public Hotel(int hotelId, String hotelName, String country, String imageUrl, String roomType, int pricePerNight, int roomAvailable, double rating) {
        this.hotelId = hotelId;
        this.hotelName = hotelName;
        this.country = country;
        this.imageUrl = imageUrl;
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

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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
        return "Hotel{" + "hotelId=" + hotelId + ", hotelName=" + hotelName + ", country=" + country + ", imageUrl=" + imageUrl + ", roomType=" + roomType + ", pricePerNight=" + pricePerNight + ", roomAvailable=" + roomAvailable + ", rating=" + rating + '}' + "\n";
    }
    
    
}
