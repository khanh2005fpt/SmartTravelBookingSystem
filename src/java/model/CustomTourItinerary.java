/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Time;
/**
 *
 * @author Admin
 */
public class CustomTourItinerary {
    private int dayNumber;
    private String activity;
    private String location;
    private Time startTime;
    private Time endTime;

    public CustomTourItinerary() {
    }

    public CustomTourItinerary(int dayNumber, String activity, String location, Time startTime, Time endTime) {
        this.dayNumber = dayNumber;
        this.activity = activity;
        this.location = location;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }
    
    
}
