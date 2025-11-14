/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class CustomTourDetail {
     private int detailId;      // chỉ khi lấy từ DB
    private int customTourId;
    private String serviceType;
    private int serviceId;
    private int price;
    private String serviceName;

    public CustomTourDetail() {
    }
  // Constructor tạo mới khi add dịch vụ (chưa có detailId)
    public CustomTourDetail(int customTourId, String serviceType, int serviceId, int price) {
        this.customTourId = customTourId;
        this.serviceType = serviceType;
        this.serviceId = serviceId;
        this.price = price;

    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }
    

    

    public int getCustomTourId() {
        return customTourId;
    }

    public void setCustomTourId(int customTourId) {
        this.customTourId = customTourId;
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

    

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

 
    
    
}
