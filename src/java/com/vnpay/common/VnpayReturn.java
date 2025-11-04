/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.vnpay.common;

import dao.BookingDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import model.Payment;

/**
 *
 * @author HP
 */
public class VnpayReturn extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        Map<String, String> fields = new HashMap<>();
        for (String key : request.getParameterMap().keySet()) {
            String value = request.getParameter(key);
            if (value != null && !value.isEmpty()) {
                fields.put(key, value);
            }
        }
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
        String signValue = Config.hashAllFields(fields);
        System.out.println("✅ signValue (local) = " + signValue);
        System.out.println("✅ vnp_SecureHash (from VNPAY) = " + vnp_SecureHash);
        if (signValue.equals(vnp_SecureHash)) {
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            int bookingId;
            try {
                String[] txnRefParts = vnp_TxnRef.split("_");
                bookingId = Integer.parseInt(txnRefParts[0]); // Lấy phần số
            } catch (NumberFormatException e) {
                response.getWriter().println("Định dạng vnp_TxnRef không hợp lệ: " + vnp_TxnRef);
                return;
            }
            String vnp_Amount = request.getParameter("vnp_Amount");
            String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
            boolean isSuccess = "00".equals(vnp_TransactionStatus);
            try {
                BookingDao bookingDao = new BookingDao();
                Payment payment = new Payment();
                payment.setBookingId(bookingId);
                long amount = Long.parseLong(vnp_Amount) / 100;

                payment.setAmount(amount);

                payment.setStatus(isSuccess ? "Success" : "Failed");
               // bookingDao.createPayment(payment);
                if (isSuccess) {
                    bookingDao.updateStatus(bookingId, "COMPLETED");
                }
                request.setAttribute("payment", payment);
                request.setAttribute("result", isSuccess ? "Success" : "Failed");
                request.getRequestDispatcher("views/booking/payment_result.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Lỗi khi lưu dữ liệu thanh toán: " + e.getMessage());
            }
        } else {
            response.getWriter().println("❌ Giao dịch không hợp lệ (Invalid signature)");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Xử lý trả về VNPAY";
    }
}