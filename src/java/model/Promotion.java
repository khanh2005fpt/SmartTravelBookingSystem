/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.util.Date;

/**
 *
 * @author nqagh
 */
public class Promotion {
    private int promoId;
    private String code;
    private String description;
    private String discountType; // "PERCENT" hoặc "AMOUNT"
    private int discountValue;    
    private LocalDate startDate;
    private LocalDate endDate;
    private int usageLimit;       
    private Date createdAt;

    // Chỉ 2 loại tour
    private String targetType;    // "FIXED_TOUR" hoặc "CUSTOM_TOUR"
    private int targetId;

    public Promotion() {
    }

    public Promotion(int promoId, String code, String description, String discountType, int discountValue, LocalDate startDate, LocalDate endDate, int usageLimit, Date createdAt, String targetType, int targetId) {
        this.promoId = promoId;
        this.code = code;
        this.description = description;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.createdAt = createdAt;
        this.targetType = targetType;
        this.targetId = targetId;
    }

    public int getPromoId() {
        return promoId;
    }

    public void setPromoId(int promoId) {
        this.promoId = promoId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public int getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(int discountValue) {
        this.discountValue = discountValue;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public int getTargetId() {
        return targetId;
    }

    public void setTargetId(int targetId) {
        this.targetId = targetId;
    }

    @Override
    public String toString() {
        return "Promotion{" + "promoId=" + promoId + ", code=" + code + ", description=" + description + ", discountType=" + discountType + ", discountValue=" + discountValue + ", startDate=" + startDate + ", endDate=" + endDate + ", usageLimit=" + usageLimit + ", createdAt=" + createdAt + ", targetType=" + targetType + ", targetId=" + targetId + '}';
    }
    
    
}
