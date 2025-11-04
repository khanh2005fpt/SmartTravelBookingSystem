package model;

import java.sql.Date;

public class BookingDetailItem {

        private int bookingDetailId;
        private int bookingId;
        private Integer tourId, hotelId, flightId, vehicleId;
        private int adultQuantity, childQuantity;
        private Date departureDate;
        private int unitPrice;
        private double totalPrice;
        private String serviceName;

        // getters/setters
        public int getBookingDetailId() {
            return bookingDetailId;
        }

        public void setBookingDetailId(int bookingDetailId) {
            this.bookingDetailId = bookingDetailId;
        }

        public int getBookingId() {
            return bookingId;
        }

        public void setBookingId(int bookingId) {
            this.bookingId = bookingId;
        }

        public Integer getTourId() {
            return tourId;
        }

        public void setTourId(Integer tourId) {
            this.tourId = tourId;
        }

        public Integer getHotelId() {
            return hotelId;
        }

        public void setHotelId(Integer hotelId) {
            this.hotelId = hotelId;
        }

        public Integer getFlightId() {
            return flightId;
        }

        public void setFlightId(Integer flightId) {
            this.flightId = flightId;
        }

        public Integer getVehicleId() {
            return vehicleId;
        }

        public void setVehicleId(Integer vehicleId) {
            this.vehicleId = vehicleId;
        }

        public int getAdultQuantity() {
            return adultQuantity;
        }

        public void setAdultQuantity(int adultQuantity) {
            this.adultQuantity = adultQuantity;
        }

        public int getChildQuantity() {
            return childQuantity;
        }

        public void setChildQuantity(int childQuantity) {
            this.childQuantity = childQuantity;
        }

        public Date getDepartureDate() {
            return departureDate;
        }

        public void setDepartureDate(Date departureDate) {
            this.departureDate = departureDate;
        }

        public int getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(int unitPrice) {
            this.unitPrice = unitPrice;
        }

        public double getTotalPrice() {
            return totalPrice;
        }

        public void setTotalPrice(double totalPrice) {
            this.totalPrice = totalPrice;
        }

        public String getServiceName() {
            return serviceName;
        }

        public void setServiceName(String serviceName) {
            this.serviceName = serviceName;
        }
    }