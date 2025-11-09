package model;

import java.util.Date;

public class Favorite {

    private int favoriteId;
    private int userId;
    private String serviceType; // HOTEL, FLIGHT, VEHICLE, TOUR, PLACE
    private int refId;          // id của dịch vụ tương ứng
    private Date createdAt;

    // ----- Constructors -----
    public Favorite() {
    }

    public Favorite(int favoriteId, int userId, String serviceType, int refId, Date createdAt) {
        this.favoriteId = favoriteId;
        this.userId = userId;
        this.serviceType = serviceType;
        this.refId = refId;
        this.createdAt = createdAt;
    }

    public Favorite(int userId, String serviceType, int refId) {
        this.userId = userId;
        this.serviceType = serviceType;
        this.refId = refId;
    }

    // ----- Getters & Setters -----
    public int getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(int favoriteId) {
        this.favoriteId = favoriteId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public int getRefId() {
        return refId;
    }

    public void setRefId(int refId) {
        this.refId = refId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // ----- toString -----
    @Override
    public String toString() {
        return "Favorite{" +
                "favoriteId=" + favoriteId +
                ", userId=" + userId +
                ", serviceType='" + serviceType + '\'' +
                ", refId=" + refId +
                ", createdAt=" + createdAt +
                '}';
    }
}
