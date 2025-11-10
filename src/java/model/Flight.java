/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 *
 * @author nqagh
 */
public class Flight {
    private int flightId;
    private String flightNumber;       
    private Airlines airline;           
    private String departure;          
    private String destination;        
    private Island destinationIsland;  
    private int basePrice;
    private int ticketAvailable;
    private String flightType;           
    private String flightClass;        
    private String destinationImageUrl;
    private boolean hasSchedule = false; 
    
    public Flight() {
    }

    public Flight(int flightId, String flightNumber, Airlines airline, String departure, String destination, Island destinationIsland, int basePrice, int ticketAvailable, String flightType, String flightClass, String destinationImageUrl) {
        this.flightId = flightId;
        this.flightNumber = flightNumber;
        this.airline = airline;
        this.departure = departure;
        this.destination = destination;
        this.destinationIsland = destinationIsland;
        this.basePrice = basePrice;
        this.ticketAvailable = ticketAvailable;
        this.flightType = flightType;
        this.flightClass = flightClass;
        this.destinationImageUrl = destinationImageUrl;
    }

    public int getFlightId() {
        return flightId;
    }

    public void setFlightId(int flightId) {
        this.flightId = flightId;
    }

    public String getFlightNumber() {
        return flightNumber;
    }

    public void setFlightNumber(String flightNumber) {
        this.flightNumber = flightNumber;
    }

    public Airlines getAirline() {
        return airline;
    }

    public void setAirline(Airlines airline) {
        this.airline = airline;
    }

    public String getDeparture() {
        return departure;
    }

    public void setDeparture(String departure) {
        this.departure = departure;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public Island getDestinationIsland() {
        return destinationIsland;
    }

    public void setDestinationIsland(Island destinationIsland) {
        this.destinationIsland = destinationIsland;
    }

    public int getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(int basePrice) {
        this.basePrice = basePrice;
    }

    public int getTicketAvailable() {
        return ticketAvailable;
    }

    public void setTicketAvailable(int ticketAvailable) {
        this.ticketAvailable = ticketAvailable;
    }

    public String getFlightType() {
        return flightType;
    }

    public void setFlightType(String flightType) {
        this.flightType = flightType;
    }

    public String getFlightClass() {
        return flightClass;
    }

    public void setFlightClass(String flightClass) {
        this.flightClass = flightClass;
    }

    public String getDestinationImageUrl() {
        return destinationImageUrl;
    }

    public void setDestinationImageUrl(String destinationImageUrl) {
        this.destinationImageUrl = destinationImageUrl;
    }

    public boolean isHasSchedule() {
        return hasSchedule;
    }

    public void setHasSchedule(boolean hasSchedule) {
        this.hasSchedule = hasSchedule;
    }

    @Override
    public String toString() {
        return "Flight{" + "flightId=" + flightId + ", flightNumber=" + flightNumber + ", airline=" + airline + ", departure=" + departure + ", destination=" + destination + ", destinationIsland=" + destinationIsland + ", basePrice=" + basePrice + ", ticketAvailable=" + ticketAvailable + ", flightType=" + flightType + ", flightClass=" + flightClass + ", destinationImageUrl=" + destinationImageUrl + ", hasSchedule=" + hasSchedule + '}';
    }

    
   
}
