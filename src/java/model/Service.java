package model;

public class Service {

    private int serviceId;
    private String name;
    private String type;
    private double price;
    private String status;

    public Service() {
    }

    public Service(int serviceId, String name, String type, double price, String status) {
        this.serviceId = serviceId;
        this.name = name;
        this.type = type;
        this.price = price;
        this.status = status;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
