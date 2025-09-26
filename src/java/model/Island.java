package model;

public class Island {
    private int islandId;
    private String islandName;
    private String country;
    private String description;
    private String bestSeason;
    private String activities;
    private String imageUrl;

    public Island() {
    }

    public Island(int islandId, String islandName, String country, String description,
                  String bestSeason, String activities, String imageUrl) {
        this.islandId = islandId;
        this.islandName = islandName;
        this.country = country;
        this.description = description;
        this.bestSeason = bestSeason;
        this.activities = activities;
        this.imageUrl = imageUrl;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public String getIslandName() {
        return islandName;
    }

    public void setIslandName(String islandName) {
        this.islandName = islandName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBestSeason() {
        return bestSeason;
    }

    public void setBestSeason(String bestSeason) {
        this.bestSeason = bestSeason;
    }

    public String getActivities() {
        return activities;
    }

    public void setActivities(String activities) {
        this.activities = activities;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Island{" +
                "islandId=" + islandId +
                ", islandName='" + islandName + '\'' +
                ", country='" + country + '\'' +
                ", description='" + description + '\'' +
                ", bestSeason='" + bestSeason + '\'' +
                ", activities='" + activities + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}