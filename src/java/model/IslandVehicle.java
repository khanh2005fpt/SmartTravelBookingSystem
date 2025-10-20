/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class IslandVehicle {
    private int vehicleId;
    private int islandId;
    private String vehicleType;
    private String modelName;
    private double pricePerDay;
    private int capacity;
    private int availability;

    public IslandVehicle() {
    }

    public IslandVehicle(int vehicleId, int islandId, String vehicleType, String modelName, double pricePerDay, int capacity, int availability) {
        this.vehicleId = vehicleId;
        this.islandId = islandId;
        this.vehicleType = vehicleType;
        this.modelName = modelName;
        this.pricePerDay = pricePerDay;
        this.capacity = capacity;
        this.availability = availability;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getAvailability() {
        return availability;
    }

    public void setAvailability(int availability) {
        this.availability = availability;
    }
    
    
}
