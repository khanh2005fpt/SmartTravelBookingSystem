package model;

public class ReportRevenue {

    private String month;
    private double confirmedRevenue;
    private double pendingRevenue;
    private double totalRevenue;
    private int confirmedCount;
    private int pendingCount;

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public double getConfirmedRevenue() {
        return confirmedRevenue;
    }

    public void setConfirmedRevenue(double confirmedRevenue) {
        this.confirmedRevenue = confirmedRevenue;
    }

    public double getPendingRevenue() {
        return pendingRevenue;
    }

    public void setPendingRevenue(double pendingRevenue) {
        this.pendingRevenue = pendingRevenue;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getConfirmedCount() {
        return confirmedCount;
    }

    public void setConfirmedCount(int confirmedCount) {
        this.confirmedCount = confirmedCount;
    }

    public int getPendingCount() {
        return pendingCount;
    }

    public void setPendingCount(int pendingCount) {
        this.pendingCount = pendingCount;
    }
}
