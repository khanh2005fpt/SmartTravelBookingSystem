package model;

import java.sql.Timestamp;

/**
 * TourService model class representing the relationship between tours and services
 */
public class TourService {
    private int tourServiceId;
    private int tourId;
    private String serviceType; // HOTEL, RESTAURANT, VEHICLE, PLACE
    private int serviceId;
    private Timestamp createdAt;
    
    // Additional fields for joins
    private String serviceName;
    private String serviceDescription;
    private String serviceImageUrl;
    private double servicePrice;
    private String tourName;
    private String address;
    private String vehicleType;
    
    // Default constructor
    public TourService() {}
    
    // Constructor with basic fields
    public TourService(int tourId, String serviceType, int serviceId) {
        this.tourId = tourId;
        this.serviceType = serviceType;
        this.serviceId = serviceId;
    }
    
    // Constructor with all fields
    public TourService(int tourServiceId, int tourId, String serviceType, int serviceId, Timestamp createdAt) {
        this.tourServiceId = tourServiceId;
        this.tourId = tourId;
        this.serviceType = serviceType;
        this.serviceId = serviceId;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getTourServiceId() {
        return tourServiceId;
    }
    
    public void setTourServiceId(int tourServiceId) {
        this.tourServiceId = tourServiceId;
    }
    
    public int getTourId() {
        return tourId;
    }
    
    public void setTourId(int tourId) {
        this.tourId = tourId;
    }
    
    public String getServiceType() {
        return serviceType;
    }
    
    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }
    
    public int getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public String getServiceDescription() {
        return serviceDescription;
    }
    
    public void setServiceDescription(String serviceDescription) {
        this.serviceDescription = serviceDescription;
    }
    
    public String getServiceImageUrl() {
        return serviceImageUrl;
    }
    
    public void setServiceImageUrl(String serviceImageUrl) {
        this.serviceImageUrl = serviceImageUrl;
    }
    
    public double getServicePrice() {
        return servicePrice;
    }
    
    public void setServicePrice(double servicePrice) {
        this.servicePrice = servicePrice;
    }
    
    public String getTourName() {
        return tourName;
    }
    
    public void setTourName(String tourName) {
        this.tourName = tourName;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getVehicleType() {
        return vehicleType;
    }
    
    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }
    
    @Override
    public String toString() {
        return "TourService{" +
                "tourServiceId=" + tourServiceId +
                ", tourId=" + tourId +
                ", serviceType='" + serviceType + '\'' +
                ", serviceId=" + serviceId +
                ", createdAt=" + createdAt +
                ", serviceName='" + serviceName + '\'' +
                '}';
    }
}