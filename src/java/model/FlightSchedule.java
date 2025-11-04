/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalTime;

/**
 *
 * @author nqagh
 */
public class FlightSchedule {
    private int scheduleId;
    private Flight flight;               
    private String planeModel;          
    private String departureAirport;    
    private String arrivalAirport;      
    private LocalTime departureTime;    
    private LocalTime arrivalTime;     
    private LocalTime returnDepartureTime; 
    private LocalTime returnArrivalTime;   
    private String transitAirport;      
    private String transitDuration; 
    private String notes;  
    // k phai thuoc tinh db , ma la de hien thi ui thoi 
    private int seatCapacity;
    private String cabinBaggage;
    private String seatPitch;    
                


    public FlightSchedule() {
    }

    public FlightSchedule(int scheduleId, Flight flight, String planeModel, String departureAirport, String arrivalAirport, LocalTime departureTime, LocalTime arrivalTime, LocalTime returnDepartureTime, LocalTime returnArrivalTime, String transitAirport, String transitDuration, String notes, int seatCapacity, String cabinBaggage, String seatPitch) {
        this.scheduleId = scheduleId;
        this.flight = flight;
        this.planeModel = planeModel;
        this.departureAirport = departureAirport;
        this.arrivalAirport = arrivalAirport;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.returnDepartureTime = returnDepartureTime;
        this.returnArrivalTime = returnArrivalTime;
        this.transitAirport = transitAirport;
        this.transitDuration = transitDuration;
        this.notes = notes;
        this.seatCapacity = seatCapacity;
        this.cabinBaggage = cabinBaggage;
        this.seatPitch = seatPitch;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public Flight getFlight() {
        return flight;
    }

    public void setFlight(Flight flight) {
        this.flight = flight;
    }

    public String getPlaneModel() {
        return planeModel;
    }

    public void setPlaneModel(String planeModel) {
        this.planeModel = planeModel;
    }

    public String getDepartureAirport() {
        return departureAirport;
    }

    public void setDepartureAirport(String departureAirport) {
        this.departureAirport = departureAirport;
    }

    public String getArrivalAirport() {
        return arrivalAirport;
    }

    public void setArrivalAirport(String arrivalAirport) {
        this.arrivalAirport = arrivalAirport;
    }

    public LocalTime getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(LocalTime departureTime) {
        this.departureTime = departureTime;
    }

    public LocalTime getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(LocalTime arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public LocalTime getReturnDepartureTime() {
        return returnDepartureTime;
    }

    public void setReturnDepartureTime(LocalTime returnDepartureTime) {
        this.returnDepartureTime = returnDepartureTime;
    }

    public LocalTime getReturnArrivalTime() {
        return returnArrivalTime;
    }

    public void setReturnArrivalTime(LocalTime returnArrivalTime) {
        this.returnArrivalTime = returnArrivalTime;
    }

    public String getTransitAirport() {
        return transitAirport;
    }

    public void setTransitAirport(String transitAirport) {
        this.transitAirport = transitAirport;
    }

    public String getTransitDuration() {
        return transitDuration;
    }

    public void setTransitDuration(String transitDuration) {
        this.transitDuration = transitDuration;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public int getSeatCapacity() {
        return seatCapacity;
    }

    public void setSeatCapacity(int seatCapacity) {
        this.seatCapacity = seatCapacity;
    }

    public String getCabinBaggage() {
        return cabinBaggage;
    }

    public void setCabinBaggage(String cabinBaggage) {
        this.cabinBaggage = cabinBaggage;
    }

    public String getSeatPitch() {
        return seatPitch;
    }

    public void setSeatPitch(String seatPitch) {
        this.seatPitch = seatPitch;
    }

    @Override
    public String toString() {
        return "FlightSchedule{" + "scheduleId=" + scheduleId + ", flight=" + flight + ", planeModel=" + planeModel + ", departureAirport=" + departureAirport + ", arrivalAirport=" + arrivalAirport + ", departureTime=" + departureTime + ", arrivalTime=" + arrivalTime + ", returnDepartureTime=" + returnDepartureTime + ", returnArrivalTime=" + returnArrivalTime + ", transitAirport=" + transitAirport + ", transitDuration=" + transitDuration + ", notes=" + notes + ", seatCapacity=" + seatCapacity + ", cabinBaggage=" + cabinBaggage + ", seatPitch=" + seatPitch + '}';
    }

    
  
  
}
