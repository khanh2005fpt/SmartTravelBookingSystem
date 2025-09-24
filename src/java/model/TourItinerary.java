/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class TourItinerary {
    private int itineraryId;     
    private int tourId;          
    private int dayNumber;       
    private String title;       
    private String description;  

    public TourItinerary() {
    }

    public TourItinerary(int itineraryId, int tourId, int dayNumber, String title, String description) {
        this.itineraryId = itineraryId;
        this.tourId = tourId;
        this.dayNumber = dayNumber;
        this.title = title;
        this.description = description;
    }

    public int getItineraryId() {
        return itineraryId;
    }

    public void setItineraryId(int itineraryId) {
        this.itineraryId = itineraryId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "TourItinerary{" + "itineraryId=" + itineraryId + ", tourId=" + tourId + ", dayNumber=" + dayNumber + ", title=" + title + ", description=" + description + '}' + "\n";
    }
    
    
}
