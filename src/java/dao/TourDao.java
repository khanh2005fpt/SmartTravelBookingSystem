/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Tour;
import model.TourActivities;
import model.TourItinerary;

/**
 *
 * @author Admin
 */
public class TourDao extends DBContext {

    public List<Tour> getListToursById(int id) {
        List<Tour> list = new ArrayList<>();
        String sql = "select * from tours a join islands b on a.islandId = b.islandId where b.islandId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều tour
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));

                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Tour getTourDetailById(int id) {
        String sql = "select * from tours where tourId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Tour t = new Tour();
                t.setTourId(rs.getInt("tourId"));
                t.setIslandId(rs.getInt("islandId"));
                t.setTourName(rs.getString("tourName"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getInt("price"));
                t.setTourImageUrl(rs.getString("tourImageUrl"));
                return t;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TourItinerary> getListTourItineriesById(int id) {
        List<TourItinerary> list = new ArrayList<>();
        String sql = "select * from TourItinerary where tourId = ? order by dayNumber";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều island
                TourItinerary tourI = new TourItinerary();
                tourI.setItineraryId(rs.getInt("itineraryId"));
                tourI.setTourId(rs.getInt("tourId"));
                tourI.setDayNumber(rs.getInt("dayNumber"));
                tourI.setTitle(rs.getString("title"));
                tourI.setActivities(getListTourActivitiesByItineraryId(tourI.getItineraryId()));
                list.add(tourI);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TourActivities> getListTourActivitiesByItineraryId(int id) {
        List<TourActivities> list = new ArrayList<>();
        String sql = "select * from TourActivities where itineraryId = ? order by activityOrder";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { // lấy nhiều island
                TourActivities tourA = new TourActivities();
                tourA.setActivityId(rs.getInt("activityId"));
                tourA.setItineraryId(rs.getInt("itineraryId"));
                tourA.setActivityOrder(rs.getInt("activityOrder"));
                tourA.setActivityTitle(rs.getString("activityTitle"));
                tourA.setDescription(rs.getString("description"));
                list.add(tourA);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        TourDao td = new TourDao();

        List<Tour> list = td.getListToursById(1);

        System.out.println(list.toString());

    }
}
