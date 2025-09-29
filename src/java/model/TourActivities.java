/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class TourActivities {
     private int activityId;
    private int itineraryId;
    private int activityOrder;
    private String activityTitle;
    private String description;

    public TourActivities() {
    }

    public TourActivities(int activityId, int itineraryId, int activityOrder, String activityTitle, String description) {
        this.activityId = activityId;
        this.itineraryId = itineraryId;
        this.activityOrder = activityOrder;
        this.activityTitle = activityTitle;
        this.description = description;
    }

    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public int getItineraryId() {
        return itineraryId;
    }

    public void setItineraryId(int itineraryId) {
        this.itineraryId = itineraryId;
    }

    public int getActivityOrder() {
        return activityOrder;
    }

    public void setActivityOrder(int activityOrder) {
        this.activityOrder = activityOrder;
    }

    public String getActivityTitle() {
        return activityTitle;
    }

    public void setActivityTitle(String activityTitle) {
        this.activityTitle = activityTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "TourActivities{" + "activityId=" + activityId + ", itineraryId=" + itineraryId + ", activityOrder=" + activityOrder + ", activityTitle=" + activityTitle + ", description=" + description + '}' + "\n";
    }
    
    
}
