/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;

/**
 *
 * @author nqagh
 */
public class CustomerProfile {
        
    private int profileId;
    private int userId;
    private String fullName;
    private LocalDate dateOfBirth;
    private Gender gender;
    private String address;
    private String profilePicture;
    private int loyaltyPoints = 0;
    private MembershipLevel membershipLevel = MembershipLevel.BRONZE;
    

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }

    public MembershipLevel getMembershipLevel() {
        return membershipLevel;
    }

    public void setMembershipLevel(MembershipLevel membershipLevel) {
        this.membershipLevel = membershipLevel;
    }

    public CustomerProfile(int profileId, int userId, String fullName, LocalDate dateOfBirth, Gender gender, String address, String profilePicture) {
        this.profileId = profileId;
        this.userId = userId;
        this.fullName = fullName;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
        this.profilePicture = profilePicture;
    }

  public CustomerProfile(int userId, String fullName, LocalDate dateOfBirth, Gender gender, String address, String profilePicture, int loyaltyPoints, MembershipLevel membershipLevel) {
    this.userId = userId;
    this.fullName = fullName;
    this.dateOfBirth = dateOfBirth;
    this.gender = gender;
    this.address = address;
    this.profilePicture = profilePicture;
    this.loyaltyPoints = loyaltyPoints;
    this.membershipLevel = membershipLevel;
}
    

    public CustomerProfile() {
    }

    @Override
    public String toString() {
        return "CustomerProfile{" + "profileId=" + profileId + ", userId=" + userId + ", fullName=" + fullName + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", address=" + address + ", profilePicture=" + profilePicture + ", loyaltyPoints=" + loyaltyPoints + ", membershipLevel=" + membershipLevel + '}';
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

   //enum gender
    public enum Gender {
    MALE("Nam"),
    FEMALE("Nữ"),
    OTHER("Khác");

    private final String displayName;

    Gender(String displayName) {
        this.displayName = displayName;
    }

    @Override
    public String toString() {
        return displayName; 
    }
}
//enum membership 
public enum MembershipLevel {
    BRONZE,
    SILVER,
    GOLD,
    PLATINUM
}
   
}
