/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */
public class Airlines {
     private int airlineId;
    private String airlineName; 
    private String iataCode;        
    private String hotline;     
    private String logoUrl; 

    public Airlines() {
    }

    public Airlines(int airlineId, String airlineName, String iataCode, String hotline, String logoUrl) {
        this.airlineId = airlineId;
        this.airlineName = airlineName;
        this.iataCode = iataCode;
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
        return "Airlines{" + "airlineId=" + airlineId + ", airlineName=" + airlineName + ", iataCode=" + iataCode + ", hotline=" + hotline + ", logoUrl=" + logoUrl + '}';
    }

    

  
    
}
