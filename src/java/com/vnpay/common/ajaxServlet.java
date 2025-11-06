/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vnpay.common;

import dao.BookingDao;
import dao.TourDao;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Booking;
import model.User;

/**
 *
 * @author CTT VNPAY
 */
public class ajaxServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderType = "other";
        String returnUrl = Config.vnp_ReturnUrl;
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Date departureDate = Date.valueOf(request.getParameter("departureDate"));
        int adultQty = Integer.parseInt(request.getParameter("adultQuantity"));
        int childQty = Integer.parseInt(request.getParameter("childQuantity"));
        HttpSession session = request.getSession();
        session.setAttribute("fullname", request.getParameter("fullname"));
        session.setAttribute("email", request.getParameter("email"));
        session.setAttribute("phone", request.getParameter("phone"));
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().println("❌ Bạn cần đăng nhập trước khi thanh toán.");
            return;
        }

        int customerId = user.getUserId();
        System.out.println("customerId" + customerId);
        String tourIdParam = request.getParameter("tourId");
        String customTourIdParam = request.getParameter("customTourId");

        Integer tourId = null;
        Integer customTourId = null;

        if (tourIdParam != null && !tourIdParam.trim().isEmpty()) {
            tourId = Integer.parseInt(tourIdParam);
        }

        if (customTourIdParam != null && !customTourIdParam.trim().isEmpty()) {
            customTourId = Integer.parseInt(customTourIdParam);
        }
        System.out.println(tourId);
        String totalBill = request.getParameter("totalBill"); // số tiền tổng tour
        long amountLong = (long) (Double.parseDouble(totalBill) * 100); //số tiền hiển thị trong lúc thanh toán

        Booking booking = new Booking();
        booking.setDepartureDate(departureDate);
        booking.setAdultQuantity(adultQty);
        booking.setChildQuantity(childQty);
        booking.setStatus("PENDING");
        booking.setCustomerId(customerId);
        booking.setCustomTourId(customTourId);
        booking.setTourId(tourId);
        booking.setTotalPrice(Double.parseDouble(totalBill));

        BookingDao bd = new BookingDao();
        int bookingId = 0;
        try {
            bookingId = bd.createBooking(booking);
        } catch (SQLException ex) {
            Logger.getLogger(ajaxServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        response.getWriter().println("DEBUG bookingId param = " + bookingId);

        String vnp_TxnRef = bookingId + "_" + System.currentTimeMillis();

        String vnp_IpAddr = request.getRemoteAddr();

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amountLong));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan tour du lich cho " + fullName);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", returnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15); // Hết hạn 15 phút
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        response.sendRedirect(paymentUrl);
    }
}