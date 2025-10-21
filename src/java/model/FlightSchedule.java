/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

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
    private String transitAirport;
    private String transitDuration;
    private String notes;

    public FlightSchedule() {
    }

    public FlightSchedule(int scheduleId, Flight flight, String planeModel, String departureAirport, String arrivalAirport, String transitAirport, String transitDuration, String notes) {
        this.scheduleId = scheduleId;
        this.flight = flight;
        this.planeModel = planeModel;
        this.departureAirport = departureAirport;
        this.arrivalAirport = arrivalAirport;
        this.transitAirport = transitAirport;
        this.transitDuration = transitDuration;
        this.notes = notes;
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

    @Override
    public String toString() {
        return "FlightSchedule{" + "scheduleId=" + scheduleId + ", flight=" + flight + ", planeModel=" + planeModel + ", departureAirport=" + departureAirport + ", arrivalAirport=" + arrivalAirport + ", transitAirport=" + transitAirport + ", transitDuration=" + transitDuration + ", notes=" + notes + '}';
    }

  
    
}
