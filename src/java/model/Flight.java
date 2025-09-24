/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author user
 */
import java.util.Date;

public class Flight {
    private int flightId;            
    private String flightNumber;      
    private int airlineId;            
    private String departure;         
    private String destination;       
    private Integer destinationIslandId; 
    private Date departureTime;      
    private Date arrivalTime;        
    private double price;            

    public Flight(int flightId, String flightNumber, int airlineId, String departure, 
                  String destination, Integer destinationIslandId, Date departureTime, 
                  Date arrivalTime, double price) {
        this.flightId = flightId;
        this.flightNumber = flightNumber;
        this.airlineId = airlineId;
        this.departure = departure;
        this.destination = destination;
        this.destinationIslandId = destinationIslandId;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.price = price;
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

    public int getAirlineId() {
        return airlineId;
    }

    public void setAirlineId(int airlineId) {
        this.airlineId = airlineId;
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

    public Integer getDestinationIslandId() {
        return destinationIslandId;
    }

    public void setDestinationIslandId(Integer destinationIslandId) {
        this.destinationIslandId = destinationIslandId;
    }

    public Date getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Date departureTime) {
        this.departureTime = departureTime;
    }

    public Date getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(Date arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Flight{" +
               "flightId=" + flightId +
               ", flightNumber='" + flightNumber + '\'' +
               ", airlineId=" + airlineId +
               ", departure='" + departure + '\'' +
               ", destination='" + destination + '\'' +
               ", destinationIslandId=" + destinationIslandId +
               ", departureTime=" + departureTime +
               ", arrivalTime=" + arrivalTime +
               ", price=" + price +
               '}';
    }
}

