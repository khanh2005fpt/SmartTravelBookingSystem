/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nqagh
 */
public class CustomTourBookingInfo {
    //Tour lẻ customer tạo 
    private CustomTour customTour; // 1 tour
     private Booking booking;
    private List<CustomTourDetail> customTourDetails = new ArrayList<>();      // nhiều dịch vụ
    private List<CustomTourItinerary> customTourItineraries = new ArrayList<>(); // nhiều lịch trình
    private HistoryBooking historyBooking; // 1 booking

    public CustomTourBookingInfo() {
    }

    public CustomTourBookingInfo(CustomTour customTour, HistoryBooking historyBooking) {
        this.customTour = customTour;
        this.historyBooking = historyBooking;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }
    

  
    public CustomTour getCustomTour() {
        return customTour;
    }

    public void setCustomTour(CustomTour customTour) {
        this.customTour = customTour;
    }

    public List<CustomTourDetail> getCustomTourDetails() {
        return customTourDetails;
    }

    public void setCustomTourDetails(List<CustomTourDetail> customTourDetails) {
        this.customTourDetails = customTourDetails;
    }

    public List<CustomTourItinerary> getCustomTourItineraries() {
        return customTourItineraries;
    }

    public void setCustomTourItineraries(List<CustomTourItinerary> customTourItineraries) {
        this.customTourItineraries = customTourItineraries;
    }

    public HistoryBooking getHistoryBooking() {
        return historyBooking;
    }

    public void setHistoryBooking(HistoryBooking historyBooking) {
        this.historyBooking = historyBooking;
    }
    
    

    @Override
    public String toString() {
        return "CustomTourBookingInfo{" + "customTour=" + customTour + ", customTourDetails=" + customTourDetails + ", customTourItineraries=" + customTourItineraries + ", historyBooking=" + historyBooking + '}';
    }
    
    public void addCustomTourDetail(CustomTourDetail detail) {
    if (this.customTourDetails == null) this.customTourDetails = new ArrayList<>();
    this.customTourDetails.add(detail);
}

public void addCustomTourItinerary(CustomTourItinerary itinerary) {
    if (this.customTourItineraries == null) this.customTourItineraries = new ArrayList<>();
    this.customTourItineraries.add(itinerary);
}
}

    
    
    


