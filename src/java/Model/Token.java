/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author nqagh
 */


import java.util.Date;

public class Token {
    private int tokenId;
    private int userId;
    private String tokenValue;
    private Date ExpiryDate;
    private boolean isUsed;
    private Date CreatedDate;

    public Token() {
    }

    public Token(int tokenId, int userId, String tokenValue, Date  ExpiryDate, boolean isUsed, Date CreatedDate) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.tokenValue = tokenValue;
        this. ExpiryDate =  ExpiryDate;
        this.isUsed = isUsed;
        this.CreatedDate = CreatedDate;
    }

    
    // Getters và Setters
    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTokenValue() {
        return tokenValue;
    }

    public void setTokenValue(String tokenValue) {
        this.tokenValue = tokenValue;
    }

    public Date getExpiryDate() {
        return  ExpiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this. ExpiryDate = expiryDate;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Date getCreatedDate() {
        return CreatedDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.CreatedDate = createdDate;
    }

    @Override
    public String toString() {
        return "Tokens{" + "tokenId=" + tokenId + ", userId=" + userId + ", tokenValue=" + tokenValue + ", expiryDate=" +  ExpiryDate + ", isUsed=" + isUsed + ", createdDate=" + CreatedDate + '}';
    }
    
    
}