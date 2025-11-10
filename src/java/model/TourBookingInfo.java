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
public class TourBookingInfo {
    private Tour tour;
    private Booking booking;
    private List<TourService> tourServices = new ArrayList<>();
    private List<TourItinerary> tourItineraries = new ArrayList<>();
    private List<TourActivities> tourActivities = new ArrayList<>();
    private HistoryBooking historyBooking;

    public Tour getTour() {
        return tour;
    }

    public void setTour(Tour tour) {
        this.tour = tour;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }
    

    public List<TourService> getTourServices() {
        return tourServices;
    }

    public void setTourServices(List<TourService> tourServices) {
        this.tourServices = tourServices;
    }

    public List<TourItinerary> getTourItineraries() {
        return tourItineraries;
    }

    public void setTourItineraries(List<TourItinerary> tourItineraries) {
        this.tourItineraries = tourItineraries;
    }

    public List<TourActivities> getTourActivities() {
        return tourActivities;
    }

    public void setTourActivities(List<TourActivities> tourActivities) {
        this.tourActivities = tourActivities;
    }

    public HistoryBooking getHistoryBooking() {
        return historyBooking;
    }

    public void setHistoryBooking(HistoryBooking historyBooking) {
        this.historyBooking = historyBooking;
    }

    // Helper methods
    public void addTourService(TourService ts) {
        if (this.tourServices == null) this.tourServices = new ArrayList<>();
        this.tourServices.add(ts);
    }

    public void addTourItinerary(TourItinerary ti) {
        if (this.tourItineraries == null) this.tourItineraries = new ArrayList<>();
        this.tourItineraries.add(ti);
    }

    public void addTourActivity(TourActivities ta) {
        if (this.tourActivities == null) this.tourActivities = new ArrayList<>();
        this.tourActivities.add(ta);
    }

    @Override
    public String toString() {
        return "TourBookingInfo{" +
                "tour=" + tour +
                ", tourServices=" + tourServices +
                ", tourItineraries=" + tourItineraries +
                ", tourActivities=" + tourActivities +
                ", historyBooking=" + historyBooking +
                '}';
    }
}
    
    

