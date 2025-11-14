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
            SELECT TOP 10
                b.*,
                u.fullName as customerName,
                t.tourName,
                ct.tourName as customTourName
            FROM Bookings b
            LEFT JOIN Users u ON b.customerId = u.userId
            LEFT JOIN Tours t ON b.tourId = t.tourId
            LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
            ORDER BY b.bookingDate DESC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
    public  Booking getBookingById(int bookingId) {
        String sql = """
            SELECT 
                b.*,
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
            SELECT TOP 10
                b.*,
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
            ps.setString(6, "INCOMPLETE");
            ps.setTimestamp(7, hb.getCreatedAt());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new SQLException("Lỗi khi thêm lịch sử paymentId = " + hb.getPaymentId(), e);
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
        booking.setTotalPrice(rs.getInt("totalPrice"));
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

                    int p = rs.getInt("totalPrice");
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
    // lay 5 historyBookings
    
    public List<HistoryBooking> getTop5HistoryByUser(int accountUserId) throws SQLException {
    List<HistoryBooking> list = new ArrayList<>();
    String sql = "SELECT TOP 5 * FROM HistoryBooking WHERE accountUserId = ? ORDER BY createdAt DESC";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, accountUserId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                HistoryBooking hb = new HistoryBooking();
                hb.setHistoryId(rs.getInt("historyId"));
                hb.setPaymentId(rs.getInt("paymentId"));

                int userId = rs.getInt("accountUserId");
                if (rs.wasNull()) hb.setAccountUserId(null);
                else hb.setAccountUserId(userId);

                hb.setCustomerName(rs.getString("customerName"));
                hb.setCustomerEmail(rs.getString("customerEmail"));
                hb.setCustomerPhone(rs.getString("customerPhone"));
                hb.setCreatedAt(rs.getTimestamp("createdAt"));
                hb.setTourStatus(rs.getString("tourStatus"));

                list.add(hb);
            }
        }
    }
    return list;
}

     /**
     * Get flight ID from TourServices for a given booking
     * Flight is associated with tour through TourServices table
     */
    public Integer getFlightIdByBookingId(int bookingId) {
        // First get the tourId from booking
        String sqlBooking = "SELECT tourId, customTourId FROM Bookings WHERE bookingId = ?";
        Integer tourId = null;
        Integer customTourId = null;
        
        try (PreparedStatement ps = connection.prepareStatement(sqlBooking)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int tid = rs.getInt("tourId");
                    if (!rs.wasNull()) {
                        tourId = tid;
                    }
                    int ctid = rs.getInt("customTourId");
                    if (!rs.wasNull()) {
                        customTourId = ctid;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        
        // If booking has a tour, get flight from TourServices
        if (tourId != null && tourId > 0) {
            String sqlFlight = """
                SELECT TOP 1 ts.serviceId 
                FROM TourServices ts 
                WHERE ts.tourId = ? 
                AND (UPPER(ts.serviceType) = 'FLIGHT' OR UPPER(ts.serviceType) = 'AIRLINE')
                ORDER BY ts.createdAt
                """;
            
            try (PreparedStatement ps = connection.prepareStatement(sqlFlight)) {
                ps.setInt(1, tourId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int flightId = rs.getInt("serviceId");
                        if (!rs.wasNull()) {
                            return flightId;
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // If booking has a customTour, get flight from CustomTourDetails
        if (customTourId != null && customTourId > 0) {
            String sqlCustomFlight = """
                SELECT TOP 1 serviceId 
                FROM CustomTourDetails 
                WHERE customTourId = ? 
                AND serviceType = N'Chuyến bay'
                ORDER BY detailId
                """;
            
            try (PreparedStatement ps = connection.prepareStatement(sqlCustomFlight)) {
                ps.setInt(1, customTourId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int flightId = rs.getInt("serviceId");
                        if (!rs.wasNull()) {
                            return flightId;
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return null;
    }
 
public boolean decreaseInventory(int bookingId) throws SQLException {
    connection.setAutoCommit(false); // start transaction
    try {
        // 1️⃣ Lấy thông tin booking
        String sqlBooking = "SELECT tourId, adultQuantity, childQuantity FROM Bookings WHERE bookingId = ?";
        PreparedStatement psBooking = connection.prepareStatement(sqlBooking);
        psBooking.setInt(1, bookingId);
        ResultSet rsBooking = psBooking.executeQuery();
        if (!rsBooking.next()) return false;

        int tourId = rsBooking.getInt("tourId");
        int totalPeople = rsBooking.getInt("adultQuantity") + rsBooking.getInt("childQuantity");

        if (tourId == 0) return false; // customTour, bỏ qua

        // 2️⃣ Lấy island từ tour
        String sqlTour = "SELECT islandId, availableQuantity FROM Tours WHERE tourId = ?";
        PreparedStatement psTour = connection.prepareStatement(sqlTour);
        psTour.setInt(1, tourId);
        ResultSet rsTour = psTour.executeQuery();
        if (!rsTour.next()) return false;

        int islandId = rsTour.getInt("islandId");
        int availableTour = rsTour.getInt("availableQuantity");

        if (availableTour < 1) {
            throw new SQLException("Không đủ tồn kho để đặt tour. Vui lòng kiểm tra lại số lượng");
        }

        // 3️⃣ Giảm tour (luôn trừ 1)
        String updateTour = "UPDATE Tours SET availableQuantity = availableQuantity - 1 WHERE tourId = ?";
        PreparedStatement psUpdateTour = connection.prepareStatement(updateTour);
        psUpdateTour.setInt(1, tourId);
        psUpdateTour.executeUpdate();

        // 4️⃣ Giảm Flights (trừ theo totalPeople)
        int remaining = totalPeople;
        String sqlFlights = "SELECT flightId, ticketAvailable FROM Flights WHERE destinationIslandId = ?";
        PreparedStatement psF = connection.prepareStatement(sqlFlights);
        psF.setInt(1, islandId);
        ResultSet rsF = psF.executeQuery();
        while (rsF.next() && remaining > 0) {
            int flightId = rsF.getInt("flightId");
            int availableTickets = rsF.getInt("ticketAvailable");
            int toReduce = Math.min(availableTickets, remaining);
            if (toReduce > 0) {
                String upd = "UPDATE Flights SET ticketAvailable = ticketAvailable - ? WHERE flightId = ?";
                PreparedStatement psUpd = connection.prepareStatement(upd);
                psUpd.setInt(1, toReduce);
                psUpd.setInt(2, flightId);
                psUpd.executeUpdate();
                remaining -= toReduce;
            }
        }
        if (remaining > 0) throw new SQLException("Not enough flight tickets");

        // 5️⃣ Giảm Hotels (trừ theo totalPeople)
        remaining = totalPeople;
        String sqlHotels = "SELECT hotelId, roomsAvailable FROM Hotels WHERE islandId = ?";
        PreparedStatement psH = connection.prepareStatement(sqlHotels);
        psH.setInt(1, islandId);
        ResultSet rsH = psH.executeQuery();
        while (rsH.next() && remaining > 0) {
            int hotelId = rsH.getInt("hotelId");
            int availableRooms = rsH.getInt("roomsAvailable");
            int toReduce = Math.min(availableRooms, remaining);
            if (toReduce > 0) {
                String upd = "UPDATE Hotels SET roomsAvailable = roomsAvailable - ? WHERE hotelId = ?";
                PreparedStatement psUpd = connection.prepareStatement(upd);
                psUpd.setInt(1, toReduce);
                psUpd.setInt(2, hotelId);
                psUpd.executeUpdate();
                remaining -= toReduce;
            }
        }
        if (remaining > 0) throw new SQLException("Not enough hotel rooms");

        // 6️⃣ Giảm Vehicles (trừ theo totalPeople)
        remaining = totalPeople;
        String sqlVehicles = "SELECT vehicleId, availability FROM IslandVehicles WHERE islandId = ?";
        PreparedStatement psV = connection.prepareStatement(sqlVehicles);
        psV.setInt(1, islandId);
        ResultSet rsV = psV.executeQuery();
        while (rsV.next() && remaining > 0) {
            int vehicleId = rsV.getInt("vehicleId");
            int availableVehicles = rsV.getInt("availability");
            int toReduce = Math.min(availableVehicles, remaining);
            if (toReduce > 0) {
                String upd = "UPDATE IslandVehicles SET availability = availability - ? WHERE vehicleId = ?";
                PreparedStatement psUpd = connection.prepareStatement(upd);
                psUpd.setInt(1, toReduce);
                psUpd.setInt(2, vehicleId);
                psUpd.executeUpdate();
                remaining -= toReduce;
            }
        }
        if (remaining > 0) throw new SQLException("Not enough vehicles");

        connection.commit(); // commit nếu tất cả OK
        return true;
    } catch (SQLException ex) {
        connection.rollback(); // rollback nếu có lỗi
        throw ex;
    } finally {
        connection.setAutoCommit(true);
    }
}
}

