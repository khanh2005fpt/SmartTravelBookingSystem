/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author nqagh
 */


import java.time.LocalDateTime;


public class Token {
    private int tokenId;
    private int userId;
    private String tokenValue;
    private LocalDateTime ExpiryDate;
    private boolean isUsed;


    public Token() {
    }

    public Token(int tokenId, int userId, String tokenValue, LocalDateTime ExpiryDate, boolean isUsed) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.tokenValue = tokenValue;
        this. ExpiryDate =  ExpiryDate;
        this.isUsed = isUsed;
       
    }
    
       public Token( int userId, String tokenValue, LocalDateTime  ExpiryDate, boolean isUsed) {
       
        this.userId = userId;
        this.tokenValue = tokenValue;
        this. ExpiryDate =  ExpiryDate;
        this.isUsed = isUsed;
     
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

    public LocalDateTime getExpiryDate() {
        return  ExpiryDate;
    }

    public void setExpiryDate(LocalDateTime  expiryDate) {
        this. ExpiryDate = expiryDate;
    }

    public boolean isIsUsed() {
        return isUsed;
    }

   

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

   
    @Override
    public String toString() {
        return "Tokens{" + "tokenId=" + tokenId + ", userId=" + userId + ", tokenValue=" + tokenValue + ", expiryDate=" +  ExpiryDate + ", isUsed=" + isUsed + '}';
    }
    
    
}