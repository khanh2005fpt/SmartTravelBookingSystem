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
    private int totalQuantity; // Tổng số lượng phương tiện
    
    // Additional properties for JSP compatibility
    private String vehicleImageUrl;
    private String vehicleName;
    private String brand;
    private String model;
    private String islandName;
    private String countryName;
    private String contactInfo;
    private String location;
    private String description;

    public IslandVehicle() {
    }

    public IslandVehicle(int vehicleId, int islandId, String vehicleType, String modelName, double pricePerDay, int capacity, int availability, String vehicleImageUrl, int totalQuantity) {
        this.vehicleId = vehicleId;
        this.islandId = islandId;
        this.vehicleType = vehicleType;
        this.modelName = modelName;
        this.pricePerDay = pricePerDay;
        this.capacity = capacity;
        this.availability = availability;
        this.vehicleImageUrl = vehicleImageUrl;
        this.totalQuantity = totalQuantity;
    }
    
    public IslandVehicle(int vehicleId, int islandId, String vehicleType, String modelName, double pricePerDay, int capacity, int availability,
                        String vehicleImageUrl, String vehicleName, String brand, String model, String islandName, String contactInfo, String location, String description) {
        this.vehicleId = vehicleId;
        this.islandId = islandId;
        this.vehicleType = vehicleType;
        this.modelName = modelName;
        this.pricePerDay = pricePerDay;
        this.capacity = capacity;
        this.availability = availability;
        this.vehicleImageUrl = vehicleImageUrl;
        this.vehicleName = vehicleName;
        this.brand = brand;
        this.model = model;
        this.islandName = islandName;
        this.contactInfo = contactInfo;
        this.location = location;
        this.description = description;
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

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public String getVehicleImageUrl() {
        return vehicleImageUrl;
    }

    public void setVehicleImageUrl(String vehicleImageUrl) {
        this.vehicleImageUrl = vehicleImageUrl;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getIslandName() {
        return islandName;
    }

    public void setIslandName(String islandName) {
        this.islandName = islandName;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "IslandVehicle{" +
                "vehicleId=" + vehicleId +
                ", islandId=" + islandId +
                ", vehicleType='" + vehicleType + '\'' +
                ", modelName='" + modelName + '\'' +
                ", pricePerDay=" + pricePerDay +
                ", capacity=" + capacity +
                ", availability=" + availability +
                ", totalQuantity=" + totalQuantity +
                ", vehicleImageUrl='" + vehicleImageUrl + '\'' +
                ", vehicleName='" + vehicleName + '\'' +
                ", brand='" + brand + '\'' +
                ", model='" + model + '\'' +
                ", islandName='" + islandName + '\'' +
                ", contactInfo='" + contactInfo + '\'' +
                ", location='" + location + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
