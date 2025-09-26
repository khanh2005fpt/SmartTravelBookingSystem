package model;

public class Airline {
    private int airlineId;
    private String airlineName;
    private String iataCode;
    private String country;
    private String hotline;
    private String logoUrl;

    public Airline() {
    }

    public Airline(int airlineId, String airlineName, String iataCode, String country, String hotline, String logoUrl) {
        this.airlineId = airlineId;
        this.airlineName = airlineName;
        this.iataCode = iataCode;
        this.country = country;
        this.hotline = hotline;
        this.logoUrl = logoUrl;
    }

    public int getAirlineId() {
        return airlineId;
    }

    public void setAirlineId(int airlineId) {
        this.airlineId = airlineId;
    }

    public String getAirlineName() {
        return airlineName;
    }

    public void setAirlineName(String airlineName) {
        this.airlineName = airlineName;
    }

    public String getIataCode() {
        return iataCode;
    }

    public void setIataCode(String iataCode) {
        this.iataCode = iataCode;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getHotline() {
        return hotline;
    }

    public void setHotline(String hotline) {
        this.hotline = hotline;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    @Override
    public String toString() {
        return "Airline{" +
                "airlineId=" + airlineId +
                ", airlineName='" + airlineName + '\'' +
                ", iataCode='" + iataCode + '\'' +
                ", country='" + country + '\'' +
                ", hotline='" + hotline + '\'' +
                ", logoUrl='" + logoUrl + '\'' +
                '}';
    }
} 