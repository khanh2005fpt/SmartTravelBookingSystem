package model;

import java.util.Map;

public class DashboardOverview {
    private int totalUsers;
    private int totalBookings;
    private int totalServices;
    private int totalPayments;
    private double totalRevenue;
    private Map<String, Double> monthlyRevenue;

    public DashboardOverview() {}

    public DashboardOverview(int totalUsers, int totalBookings, int totalServices,
                             int totalPayments, double totalRevenue,
                             Map<String, Double> monthlyRevenue) {
        this.totalUsers = totalUsers;
        this.totalBookings = totalBookings;
        this.totalServices = totalServices;
        this.totalPayments = totalPayments;
        this.totalRevenue = totalRevenue;
        this.monthlyRevenue = monthlyRevenue;
    }


    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }

    public int getTotalServices() {
        return totalServices;
    }

    public void setTotalServices(int totalServices) {
        this.totalServices = totalServices;
    }

    public int getTotalPayments() {
        return totalPayments;
    }

    public void setTotalPayments(int totalPayments) {
        this.totalPayments = totalPayments;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public Map<String, Double> getMonthlyRevenue() {
        return monthlyRevenue;
    }

    public void setMonthlyRevenue(Map<String, Double> monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }


    @Override
    public String toString() {
        return "DashboardOverview{" +
                "totalUsers=" + totalUsers +
                ", totalBookings=" + totalBookings +
                ", totalServices=" + totalServices +
                ", totalPayments=" + totalPayments +
                ", totalRevenue=" + totalRevenue +
                ", monthlyRevenue=" + monthlyRevenue +
                '}';
    }
}
