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
    private String timeOfDay;

    public CustomTourItinerary() {
    }

    public CustomTourItinerary(int dayNumber, String activity, String location, String timeOfDay) {
        this.dayNumber = dayNumber;
        this.activity = activity;
        this.location = location;
        this.timeOfDay = timeOfDay;
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

    public String getTimeOfDay() {
        return timeOfDay;
    }

    public void setTimeOfDay(String timeOfDay) {
        this.timeOfDay = timeOfDay;
    }

    
    
    
}
