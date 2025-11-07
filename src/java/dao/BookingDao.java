/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.time.LocalDate;
import java.util.Date;
import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import model.Booking;
import utils.DBContext;
import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import model.BookingDetailItem;
import model.BookingListItem;
import model.BookingStatus;

import model.Payment;
import model.Bill;
import model.HistoryBooking;

/**
 *
 * @author Admin
 */
public class BookingDao extends DBContext {

    public static final int PAGE_SIZE = 10;

    public static BookingDao INSTANCE = new BookingDao();

     public int createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Bookings (customerId, tourId, customTourId, departureDate, endDate, adultQuantity, childQuantity, status, totalPrice) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerId());

            // Cho phép tourId hoặc customTourId (tùy loại tour)
            if (booking.getTourId() != null) {
                ps.setInt(2, booking.getTourId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            if (booking.getCustomTourId() != null) {
                ps.setInt(3, booking.getCustomTourId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }

            ps.setDate(4, new java.sql.Date(booking.getDepartureDate().getTime()));

            if (booking.getEndDate() != null) {
                ps.setDate(5, new java.sql.Date(booking.getEndDate().getTime()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            ps.setInt(6, booking.getAdultQuantity());
            ps.setInt(7, booking.getChildQuantity());
            ps.setString(8, booking.getStatus());
            ps.setDouble(9, booking.getTotalPrice());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("❌ Tạo booking thất bại.");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int bookingId = rs.getInt(1);
                    booking.setBookingId(bookingId);
                    return bookingId;
                } else {
                    throw new SQLException("❌ Tạo booking thất bại — không lấy được ID vừa tạo.");
                }
            }
        }
    }

    /**
     * Get all bookings with customer and tour information for staff view
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = """
            SELECT 
                b.bookingId, b.profileId, b.customerId, b.tourId, b.customTourId,
                b.price, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
                b.status, b.bookingDate,
                u.fullName as customerName,
                t.tourName,
                ct.tourName as customTourName
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            ORDER BY b.bookingDate DESC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get booking by ID with detailed information
     */
    public Booking getBookingById(int bookingId) {
        String sql = """
            SELECT 
                b.bookingId, b.profileId, b.customerId, b.tourId, b.customTourId,
                b.price, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
                b.status, b.bookingDate,
                u.fullName as customerName, u.email, u.phone,
                t.tourName, t.description as tourDescription,
                ct.tourName as customTourName, NULL as customTourDescription
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            WHERE b.bookingId = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Search bookings by various criteria
     */
    public List<Booking> searchBookings(String customerName, String status, String dateFrom, String dateTo) {
        List<Booking> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT 
                b.bookingId, b.profileId, b.customerId, b.tourId, b.customTourId,
                b.price, b.departureDate, b.endDate, b.adultQuantity, b.childQuantity,
                b.status, b.bookingDate,
                u.fullName as customerName,
                t.tourName,
                ct.tourName as customTourName
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            WHERE 1=1
            """);

        List<Object> parameters = new ArrayList<>();

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND u.fullName LIKE ?");
            parameters.add("%" + customerName.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            // Handle multiple statuses separated by comma (e.g., "PENDING,CONFIRMED")
            if (status.contains(",")) {
                String[] statuses = status.split(",");
                sql.append(" AND b.status IN (");
                for (int i = 0; i < statuses.length; i++) {
                    if (i > 0) {
                        sql.append(",");
                    }
                    sql.append("?");
                    parameters.add(statuses[i].trim());
                }
                sql.append(")");
            } else {
                sql.append(" AND b.status = ?");
                parameters.add(status);
            }
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND b.bookingDate >= ?");
            parameters.add(dateFrom);
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND b.bookingDate <= ?");
            parameters.add(dateTo + " 23:59:59");
        }

        sql.append(" ORDER BY b.bookingDate DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Update booking status
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET status = ? WHERE bookingId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public void createHistoryBooking(HistoryBooking hb) throws SQLException {
        String sql = "INSERT INTO HistoryBooking (paymentId, accountUserId, customerName, "
                + "customerEmail, customerPhone, tourStatus, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, hb.getPaymentId());

            if (hb.getAccountUserId() != null) {
                ps.setInt(2, hb.getAccountUserId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            ps.setString(3, hb.getCustomerName());
            ps.setString(4, hb.getCustomerEmail());
            ps.setString(5, hb.getCustomerPhone());
            ps.setString(6, hb.getTourStatus());
            ps.setTimestamp(7, hb.getCreatedAt());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new SQLException("Lỗi khi thêm lịch sử paymentId = " + hb.getPaymentId(), e);
        }
    }

    public static void main(String[] args) {
        try {
            // 1. Tạo DAO (đảm bảo trong class này có connection hợp lệ)
            BookingDao bookingDao = new BookingDao();
            Booking booking= new Booking();
  booking.setCustomerId(3); // ID khách hàng có sẵn trong DB
            booking.setTourId(2);     // Tour có thật trong bảng Tours
            booking.setCustomTourId(null); // nếu không dùng customTour, để 0

            // Chuyển từ LocalDate sang java.util.Date
            LocalDate depLocal = LocalDate.of(2025, 11, 10);
            LocalDate endLocal = LocalDate.of(2025, 11, 15);
            Date depDate = Date.from(depLocal.atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date endDate = Date.from(endLocal.atStartOfDay(ZoneId.systemDefault()).toInstant());

            booking.setDepartureDate(depDate);
            booking.setEndDate(endDate);

            booking.setAdultQuantity(2);
            booking.setChildQuantity(1);
            booking.setStatus("PENDING");

            // 3. Gọi hàm createBooking()
            int bookingId = bookingDao.createBooking(booking);

            // 4. In kết quả ra console
            if (bookingId > 0) {
                System.out.println("✅ Booking created successfully with ID: " + bookingId);
            } else {
                System.out.println("❌ Failed to create booking!");
            }
           
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Bill getBillByHistoryBooking(int paymentId) throws SQLException {
        String sql = "SELECT [hb].[paymentId], [hb].[customerName], [hb].[customerPhone], [hb].[createdAt], "
                + "COALESCE([t].[tourName], [ct].[tourName]) AS tourNamePayment, [p].[amount], [p].[status] AS paymentStatus "
                + "FROM [HistoryBooking] hb "
                + "JOIN [Payments] p ON [hb].[paymentId] = [p].[paymentId] "
                + "JOIN [Bookings] b ON [p].[bookingId] = [b].[bookingId] "
                + "LEFT JOIN [Tours] t ON [b].[tourId] = [t].[tourId] "
                + "LEFT JOIN [CustomTours] ct ON [b].[customTourId] = [ct].[customTourId] "
                + "WHERE [hb].[paymentId] = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bill bill = new Bill();
                    bill.setPaymentId(rs.getInt("paymentId"));
                    bill.setFullname(rs.getString("customerName"));
                    bill.setPhone(rs.getString("customerPhone"));
                    bill.setCreatedAt(rs.getTimestamp("createdAt"));
                    bill.setTourName(rs.getString("tourNamePayment"));
                    bill.setAmount(rs.getLong("amount"));
                    bill.setStatus(rs.getString("paymentStatus"));
                    return bill;
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi lấy thông tin bill paymentId = " + paymentId, e);
        }
        return null;
    }

    //Tao thanh toan cho booking
    public int createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payments (bookingId, amount, status) OUTPUT INSERTED.paymentId VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getStatus());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int paymentId = rs.getInt(1);
                payment.setPaymentId(paymentId);
                return paymentId;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }

    /**
     * Get booking statistics for dashboard
     */
    public int getBookingCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE status = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Helper method to map ResultSet to Booking object
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("bookingId"));
        //booking.setProfileId(rs.getInt("profileId"));
        booking.setCustomerId(rs.getInt("customerId"));
        booking.setTourId(rs.getInt("tourId"));
        booking.setCustomTourId(rs.getInt("customTourId"));
        //booking.setPrice(rs.getInt("price"));
        booking.setDepartureDate(rs.getDate("departureDate"));
        booking.setEndDate(rs.getDate("endDate"));
        booking.setAdultQuantity(rs.getInt("adultQuantity"));
        booking.setChildQuantity(rs.getInt("childQuantity"));
        booking.setStatus(rs.getString("status"));
        booking.setBookingDate(rs.getTimestamp("bookingDate"));
        booking.setCustomerName(rs.getString("customerName"));
        booking.setTourName(rs.getString("tourName"));
        booking.setCustomTourName(rs.getString("customTourName"));

        return booking;
    }

    public void updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE Bookings SET status=? WHERE bookingId=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi cập nhật trạng thái bookingId = " + bookingId, e);
        }
    }

    public List<BookingListItem> searchByStatus(String status) throws SQLException {
        String sql = """
        SELECT 
            b.bookingId,
            u.fullName AS customerName,
            t.tourName AS services,
            b.totalPrice AS price,
            b.status,
            b.bookingDate,
            b.totalPrice AS totalAmount
        FROM Bookings b
        LEFT JOIN Users u ON b.customerId = u.userId
        LEFT JOIN Tours t ON b.tourId = t.tourId
        WHERE b.status = ?
        ORDER BY b.bookingDate DESC;
    """;

        List<BookingListItem> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();

                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(null); // Không có profileName trong DB
                    it.setCustomerName(rs.getString("customerName"));

                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);

                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services")); // tourName

                    list.add(it);
                }
            }
        }
        return list;
    }

    public List<BookingListItem> searchByCustomerName(String keyword) throws SQLException {
        String sql = """
        SELECT 
            b.bookingId,
            u.fullName AS customerName,
            t.tourName AS services,
            b.totalPrice AS price,
            b.status,
            b.bookingDate,
            b.totalPrice AS totalAmount
        FROM Bookings b
        LEFT JOIN Users u ON b.customerId = u.userId
        LEFT JOIN Tours t ON b.tourId = t.tourId
        WHERE u.fullName LIKE ?
        ORDER BY b.bookingDate DESC;
    """;

        List<BookingListItem> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();

                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(null);
                    it.setCustomerName(rs.getString("customerName"));

                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);

                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services"));

                    list.add(it);
                }
            }
        }
        return list;
    }

    public List<BookingListItem> getAll(int page) throws SQLException {
        if (page < 1) {
            page = 1;
        }
        int offset = (page - 1) * PAGE_SIZE;

        String sql = """
        WITH agg AS (
            SELECT 
                b.bookingId,
                u.fullName AS customerName,
                t.tourName AS services,
                b.status,
                b.totalPrice AS price,
                b.bookingDate,
                b.totalPrice AS totalAmount
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
        )
        SELECT 
            bookingId,
            customerName,
            services,
            price,
            status,
            bookingDate,
            totalAmount
        FROM agg
        ORDER BY bookingDate DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;
    """;

        List<BookingListItem> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, PAGE_SIZE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();

                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(null); // DB không có cột profileName, giữ null
                    it.setCustomerName(rs.getString("customerName"));

                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);

                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services")); // tourName hiển thị ở đây

                    list.add(it);
                }
            }
        }

        return list;
    }

    public int getTotalPages() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            int total = 0;
            if (rs.next()) {
                total = rs.getInt(1);
            }
            return (total + PAGE_SIZE - 1) / PAGE_SIZE;
        }
    }

    public List<String> getAllTours() throws SQLException {
        List<String> tours = new ArrayList<>();
        String sql = "SELECT tourName FROM Tours ORDER BY tourName ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tours.add(rs.getString("tourName"));
            }
        }
        return tours;
    }

    public List<BookingListItem> searchByTourAndSort(String tour, String sortOrder) throws SQLException {
        String orderBy = "ASC".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        String sql = """
        SELECT 
            b.bookingId,
            u.fullName AS customerName,
            t.tourName AS services,
            b.totalPrice AS price,
            b.status,
            b.bookingDate,
            b.totalPrice AS totalAmount
        FROM Bookings b
        LEFT JOIN Users u ON b.customerId = u.userId
        LEFT JOIN Tours t ON b.tourId = t.tourId
        WHERE (? IS NULL OR t.tourName = ?)
        ORDER BY b.totalPrice """ + orderBy;

        List<BookingListItem> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, tour == null || tour.isEmpty() ? null : tour);
            ps.setString(2, tour == null || tour.isEmpty() ? null : tour);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingListItem it = new BookingListItem();
                    it.setBookingId(rs.getInt("bookingId"));
                    it.setProfileName(null);
                    it.setCustomerName(rs.getString("customerName"));
                    int p = rs.getInt("price");
                    it.setPrice(rs.wasNull() ? null : p);
                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));
                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());
                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    it.setServices(rs.getString("services"));
                    list.add(it);
                }
            }
        }
        return list;
    }

    public BookingListItem getBookingById2(int id) throws SQLException {
        String sql = """
        SELECT 
            b.bookingId,
            u.fullName AS customerName,
            u.email,
            u.phone,
            t.tourName AS services,
            t.price AS tourPrice,
            b.totalPrice AS price,
            b.status,
            b.bookingDate,
            b.totalPrice AS totalAmount
        FROM Bookings b
        LEFT JOIN Users u ON b.customerId = u.userId
        LEFT JOIN Tours t ON b.tourId = t.tourId
        WHERE b.bookingId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookingListItem it = new BookingListItem();
                    it.setBookingId(rs.getInt("bookingId"));
                    it.setCustomerName(rs.getString("customerName"));
                    it.setServices(rs.getString("services"));
                    it.setPrice(rs.getInt("price"));
                    String st = rs.getString("status");
                    it.setStatus(st == null ? null : BookingStatus.valueOf(st.toUpperCase()));

                    Timestamp ts = rs.getTimestamp("bookingDate");
                    it.setBookingDate(ts == null ? null : ts.toLocalDateTime());

                    it.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    return it;
                }
            }
        }
        return null;
    }

    public List<BookingDetailItem> getDetailsByBookingId(int bookingId) throws SQLException {
        String sql
                = "SELECT d.*, "
                + "       COALESCE(h.hotelName, f.flightNumber, v.modelName, t.tourName) AS serviceName "
                + "FROM BookingDetails d "
                + "LEFT JOIN Hotels h ON d.hotelId = h.hotelId "
                + "LEFT JOIN Flights f ON d.flightId = f.flightId "
                + "LEFT JOIN IslandVehicles v ON d.vehicleId = v.vehicleId "
                + "LEFT JOIN Tours t ON d.tourId = t.tourId "
                + "WHERE d.bookingId = ?";

        List<BookingDetailItem> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingDetailItem it = new BookingDetailItem();
                it.setBookingDetailId(rs.getInt("bookingDetailId"));
                it.setBookingId(rs.getInt("bookingId"));
                it.setAdultQuantity(rs.getInt("adultQuantity"));
                it.setChildQuantity(rs.getInt("childQuantity"));
                it.setDepartureDate(rs.getDate("departureDate"));
                it.setUnitPrice(rs.getInt("unitPrice"));
                it.setTotalPrice(rs.getDouble("totalPrice"));
                it.setServiceName(rs.getString("serviceName"));
                list.add(it);
            }
        }
        return list;
        
        // get total booking
        
        
    }
    public int getTotalBooking() throws  SQLException{
    String sql = "SELECT COUNT(*) AS total FROM Bookings";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("total");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    
    // get revenue 
    public long getTotalRevenue() throws SQLException{
    String sql = "SELECT SUM(amount) AS totalRevenue FROM Payments WHERE status = 'SUCCESS'";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getLong("totalRevenue");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

    
}

