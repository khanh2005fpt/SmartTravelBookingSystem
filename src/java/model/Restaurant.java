package model;

/**
 * Restaurant model class representing a restaurant entity
 */
public class Restaurant {
    private int restaurantId;
    private int islandId;
    private String restaurantName;
    private String cuisineType;
    private String priceRange;
    private double rating;
    private String address;
    private String phoneNumber;
    private String openingHours;
    private int capacity;
    private String restaurantImageUrl;
    private String description;
    private String specialties;
    
    // Additional fields for joins
    private String islandName;
    private String countryName;

    // Default constructor
    public Restaurant() {}

    // Constructor with all fields
    public Restaurant(int restaurantId, int islandId, String restaurantName, String cuisineType, 
                     String priceRange, double rating, String address, String phoneNumber, 
                     String openingHours, int capacity, String restaurantImageUrl, 
                     String description, String specialties) {
        this.restaurantId = restaurantId;
        this.islandId = islandId;
        this.restaurantName = restaurantName;
        this.cuisineType = cuisineType;
        this.priceRange = priceRange;
        this.rating = rating;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.openingHours = openingHours;
        this.capacity = capacity;
        this.restaurantImageUrl = restaurantImageUrl;
        this.description = description;
        this.specialties = specialties;
    }

    // Getters and Setters
    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getIslandId() {
        return islandId;
    }

    public void setIslandId(int islandId) {
        this.islandId = islandId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public String getPriceRange() {
        return priceRange;
    }

    public void setPriceRange(String priceRange) {
        this.priceRange = priceRange;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getOpeningHours() {
        return openingHours;
    }

    public void setOpeningHours(String openingHours) {
        this.openingHours = openingHours;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getRestaurantImageUrl() {
        return restaurantImageUrl;
    }

    public void setRestaurantImageUrl(String restaurantImageUrl) {
        this.restaurantImageUrl = restaurantImageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSpecialties() {
        return specialties;
    }

    public void setSpecialties(String specialties) {
        this.specialties = specialties;
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

    @Override
    public String toString() {
        return "Restaurant{" +
                "restaurantId=" + restaurantId +
                ", islandId=" + islandId +
                ", restaurantName='" + restaurantName + '\'' +
                ", cuisineType='" + cuisineType + '\'' +
                ", priceRange='" + priceRange + '\'' +
                ", rating=" + rating +
                ", address='" + address + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", openingHours='" + openingHours + '\'' +
                ", capacity=" + capacity +
                ", restaurantImageUrl='" + restaurantImageUrl + '\'' +
                ", description='" + description + '\'' +
                ", specialties='" + specialties + '\'' +
                '}';
    }
}