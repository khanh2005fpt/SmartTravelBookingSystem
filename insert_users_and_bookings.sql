-- Script tạo Users, CustomerProfiles và Bookings mẫu
-- Chạy script này để tạo dữ liệu test hoàn chỉnh

USE SmartTravelBooking;
GO

-- Kiểm tra dữ liệu hiện có
PRINT 'Checking existing data...';
SELECT 'Current Users Count: ' + CAST(COUNT(*) AS VARCHAR) FROM Users;
SELECT 'Current CUSTOMER Users Count: ' + CAST(COUNT(*) AS VARCHAR) FROM Users WHERE roleId = 3;
SELECT 'Current CustomerProfiles Count: ' + CAST(COUNT(*) AS VARCHAR) FROM CustomerProfiles;
SELECT 'Current Tours Count: ' + CAST(COUNT(*) AS VARCHAR) FROM Tours;
SELECT 'Current CustomTours Count: ' + CAST(COUNT(*) AS VARCHAR) FROM CustomTours;
SELECT 'Current Bookings Count: ' + CAST(COUNT(*) AS VARCHAR) FROM Bookings;

-- Tạo Users mẫu với roleId = 3 (CUSTOMER)
PRINT 'Creating sample users...';

-- Kiểm tra và tạo user nếu chưa tồn tại
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'customer1')
BEGIN
    INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
    VALUES ('customer1', '$2a$10$example.hash.password1', 'customer1@example.com', N'Nguyễn Văn An', '0901234567', 3, 'ACTIVE');
    PRINT 'Created user: customer1';
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'customer2')
BEGIN
    INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
    VALUES ('customer2', '$2a$10$example.hash.password2', 'customer2@example.com', N'Trần Thị Bình', '0901234568', 3, 'ACTIVE');
    PRINT 'Created user: customer2';
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'customer3')
BEGIN
    INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
    VALUES ('customer3', '$2a$10$example.hash.password3', 'customer3@example.com', N'Lê Văn Cường', '0901234569', 3, 'ACTIVE');
    PRINT 'Created user: customer3';
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'customer4')
BEGIN
    INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
    VALUES ('customer4', '$2a$10$example.hash.password4', 'customer4@example.com', N'Phạm Thị Dung', '0901234570', 3, 'ACTIVE');
    PRINT 'Created user: customer4';
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'customer5')
BEGIN
    INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
    VALUES ('customer5', '$2a$10$example.hash.password5', 'customer5@example.com', N'Hoàng Văn Em', '0901234571', 3, 'ACTIVE');
    PRINT 'Created user: customer5';
END

-- Lấy userId của các customer vừa tạo
DECLARE @customer1Id INT = (SELECT userId FROM Users WHERE username = 'customer1');
DECLARE @customer2Id INT = (SELECT userId FROM Users WHERE username = 'customer2');
DECLARE @customer3Id INT = (SELECT userId FROM Users WHERE username = 'customer3');
DECLARE @customer4Id INT = (SELECT userId FROM Users WHERE username = 'customer4');
DECLARE @customer5Id INT = (SELECT userId FROM Users WHERE username = 'customer5');

PRINT 'Customer IDs: ' + CAST(@customer1Id AS VARCHAR) + ', ' + CAST(@customer2Id AS VARCHAR) + ', ' + CAST(@customer3Id AS VARCHAR) + ', ' + CAST(@customer4Id AS VARCHAR) + ', ' + CAST(@customer5Id AS VARCHAR);

-- Tạo CustomerProfiles cho các user
PRINT 'Creating customer profiles...';

-- Profile cho customer1
IF NOT EXISTS (SELECT 1 FROM CustomerProfiles WHERE userId = @customer1Id)
BEGIN
    INSERT INTO CustomerProfiles (userId, fullName, dateOfBirth, gender, address, loyaltyPoints, membershipLevel)
    VALUES (@customer1Id, N'Nguyễn Văn An', '1990-05-15', 'MALE', N'123 Nguyễn Huệ, Q1, TP.HCM', 500, 'BRONZE');
    PRINT 'Created profile for customer1';
END

-- Profile cho customer2
IF NOT EXISTS (SELECT 1 FROM CustomerProfiles WHERE userId = @customer2Id)
BEGIN
    INSERT INTO CustomerProfiles (userId, fullName, dateOfBirth, gender, address, loyaltyPoints, membershipLevel)
    VALUES (@customer2Id, N'Trần Thị Bình', '1985-08-22', 'FEMALE', N'456 Lê Lợi, Q1, TP.HCM', 1200, 'SILVER');
    PRINT 'Created profile for customer2';
END

-- Profile cho customer3
IF NOT EXISTS (SELECT 1 FROM CustomerProfiles WHERE userId = @customer3Id)
BEGIN
    INSERT INTO CustomerProfiles (userId, fullName, dateOfBirth, gender, address, loyaltyPoints, membershipLevel)
    VALUES (@customer3Id, N'Lê Văn Cường', '1992-12-10', 'MALE', N'789 Trần Hưng Đạo, Q5, TP.HCM', 2500, 'SILVER');
    PRINT 'Created profile for customer3';
END

-- Profile cho customer4
IF NOT EXISTS (SELECT 1 FROM CustomerProfiles WHERE userId = @customer4Id)
BEGIN
    INSERT INTO CustomerProfiles (userId, fullName, dateOfBirth, gender, address, loyaltyPoints, membershipLevel)
    VALUES (@customer4Id, N'Phạm Thị Dung', '1988-03-18', 'FEMALE', N'321 Võ Văn Tần, Q3, TP.HCM', 5500, 'GOLD');
    PRINT 'Created profile for customer4';
END

-- Profile cho customer5
IF NOT EXISTS (SELECT 1 FROM CustomerProfiles WHERE userId = @customer5Id)
BEGIN
    INSERT INTO CustomerProfiles (userId, fullName, dateOfBirth, gender, address, loyaltyPoints, membershipLevel)
    VALUES (@customer5Id, N'Hoàng Văn Em', '1995-07-25', 'MALE', N'654 Pasteur, Q1, TP.HCM', 800, 'BRONZE');
    PRINT 'Created profile for customer5';
END

-- Lấy profileId của các customer
DECLARE @profile1Id INT = (SELECT profileId FROM CustomerProfiles WHERE userId = @customer1Id);
DECLARE @profile2Id INT = (SELECT profileId FROM CustomerProfiles WHERE userId = @customer2Id);
DECLARE @profile3Id INT = (SELECT profileId FROM CustomerProfiles WHERE userId = @customer3Id);
DECLARE @profile4Id INT = (SELECT profileId FROM CustomerProfiles WHERE userId = @customer4Id);
DECLARE @profile5Id INT = (SELECT profileId FROM CustomerProfiles WHERE userId = @customer5Id);

PRINT 'Profile IDs: ' + CAST(@profile1Id AS VARCHAR) + ', ' + CAST(@profile2Id AS VARCHAR) + ', ' + CAST(@profile3Id AS VARCHAR) + ', ' + CAST(@profile4Id AS VARCHAR) + ', ' + CAST(@profile5Id AS VARCHAR);

-- Thêm booking records mẫu với userId và profileId chính xác
PRINT 'Creating sample bookings...';

-- LƯU Ý: Do thiết kế database yêu cầu cả tourId và customTourId phải NOT NULL với foreign key constraints,
-- chúng ta phải sử dụng giá trị hợp lệ cho cả hai trường. Trong thực tế, ứng dụng sẽ sử dụng logic nghiệp vụ
-- để xác định loại booking dựa trên context hoặc trường khác.
-- Để phân biệt: 
-- - Package Tours: sử dụng tourId thực và customTourId = 1 (dummy)
-- - Custom Tours: sử dụng customTourId thực và tourId = 1 (dummy)

INSERT INTO Bookings (
    profileId, customerId, tourId, customTourId, price,
    departureDate, endDate, adultQuantity, childQuantity, status, bookingDate
)
VALUES
-- Booking 1: Tour Phú Quốc Nghỉ dưỡng - CONFIRMED (Package Tour)
(@profile1Id, @customer1Id, 1, 1, 4500000, '2025-02-15', '2025-02-18', 2, 1, 'CONFIRMED', '2025-01-10 09:30:00'),

-- Booking 2: Custom Tour Phú Quốc Văn hóa - PENDING (Custom Tour)
(@profile2Id, @customer2Id, 1, 1, 3590000, '2025-03-01', '2025-03-02', 2, 0, 'PENDING', '2025-01-15 14:20:00'),

-- Booking 3: Tour Phú Quốc Lặn biển - COMPLETED (Package Tour)
(@profile1Id, @customer1Id, 2, 1, 6800000, '2025-01-05', '2025-01-08', 1, 2, 'COMPLETED', '2024-12-20 11:45:00'),

-- Booking 4: Custom Tour Phú Quốc Lặn biển - CANCELLED (Custom Tour)
(@profile3Id, @customer3Id, 1, 2, 7990000, '2025-02-20', '2025-02-24', 1, 1, 'CANCELLED', '2025-01-08 16:15:00'),

-- Booking 5: Tour Langkawi - CONFIRMED (Package Tour)
(@profile2Id, @customer2Id, 4, 1, 5200000, '2025-04-10', '2025-04-14', 2, 2, 'CONFIRMED', '2025-01-20 10:00:00'),

-- Booking 6: Custom Tour Phuket - PENDING (Custom Tour)
(@profile4Id, @customer4Id, 1, 3, 7990000, '2025-03-15', '2025-03-19', 1, 0, 'PENDING', '2025-01-22 13:30:00'),

-- Booking 7: Tour Phuket - CONFIRMED (Package Tour)
(@profile1Id, @customer1Id, 5, 1, 7200000, '2025-05-01', '2025-05-05', 2, 1, 'CONFIRMED', '2025-01-25 08:45:00'),

-- Booking 8: Custom Tour Phú Quốc Văn hóa - PENDING (Custom Tour)
(@profile3Id, @customer3Id, 1, 1, 3590000, '2025-04-20', '2025-04-21', 2, 0, 'PENDING', '2025-01-28 15:20:00'),

-- Booking 9: Tour Boracay - COMPLETED (Package Tour)
(@profile2Id, @customer2Id, 6, 1, 6500000, '2024-12-15', '2024-12-19', 1, 1, 'COMPLETED', '2024-11-20 12:00:00'),

-- Booking 10: Custom Tour Phú Quốc Lặn biển - CONFIRMED (Custom Tour)
(@profile4Id, @customer4Id, 1, 2, 7990000, '2025-03-25', '2025-03-29', 1, 0, 'CONFIRMED', '2025-01-30 09:15:00'),

-- Booking 11: Tour Koh Samui Nghỉ dưỡng - PENDING (Package Tour)
(@profile1Id, @customer1Id, 7, 1, 3800000, '2025-06-01', '2025-06-04', 2, 2, 'PENDING', '2025-02-01 11:30:00'),

-- Booking 12: Custom Tour Phuket - CANCELLED (Custom Tour)
(@profile2Id, @customer2Id, 1, 3, 7990000, '2025-02-28', '2025-03-04', 1, 1, 'CANCELLED', '2025-01-18 14:45:00'),

-- Booking 13: Tour Koh Samui Văn hóa - CONFIRMED (Package Tour)
(@profile3Id, @customer3Id, 8, 1, 12000000, '2025-07-15', '2025-07-20', 2, 0, 'CONFIRMED', '2025-02-05 16:00:00'),

-- Booking 14: Custom Tour Phú Quốc Văn hóa - PENDING (Custom Tour)
(@profile4Id, @customer4Id, 1, 1, 3590000, '2025-05-10', '2025-05-11', 1, 2, 'PENDING', '2025-02-08 10:20:00'),

-- Booking 15: Tour Bali Văn hóa & Biển - COMPLETED (Package Tour)
(@profile5Id, @customer5Id, 4, 1, 9500000, '2024-11-10', '2024-11-15', 2, 1, 'COMPLETED', '2024-10-15 13:45:00');

-- Kiểm tra dữ liệu sau khi insert
PRINT 'Checking data after insert...';
SELECT 'Total Users: ' + CAST(COUNT(*) AS VARCHAR) FROM Users;
SELECT 'Total CUSTOMER Users: ' + CAST(COUNT(*) AS VARCHAR) FROM Users WHERE roleId = 3;
SELECT 'Total CustomerProfiles: ' + CAST(COUNT(*) AS VARCHAR) FROM CustomerProfiles;
SELECT 'Total Bookings: ' + CAST(COUNT(*) AS VARCHAR) FROM Bookings;

-- Hiển thị thống kê booking theo status
PRINT 'Booking statistics by status:';
SELECT 
    status,
    COUNT(*) as count,
    SUM(price) as total_revenue
FROM Bookings 
GROUP BY status
ORDER BY status;

-- Hiển thị booking gần đây nhất
PRINT 'Recent bookings:';
SELECT TOP 5
    b.bookingId,
    u.fullName as customerName,
    t.tourName as packageTourName,
    ct.tourName as customTourName,
    CASE 
        WHEN b.tourId = 1 AND b.customTourId > 1 THEN 'Custom Tour: ' + ct.tourName
        ELSE 'Package Tour: ' + t.tourName
    END as actualTourName,
    b.price,
    b.departureDate,
    b.status,
    b.bookingDate
FROM Bookings b
LEFT JOIN Users u ON b.customerId = u.userId
LEFT JOIN Tours t ON b.tourId = t.tourId
LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
ORDER BY b.bookingDate DESC;

-- Hiển thị tất cả bookings với thông tin chi tiết
PRINT 'All bookings with details:';
SELECT 
    b.bookingId,
    u.fullName as customerName,
    u.email,
    CASE 
        WHEN b.tourId = 1 AND b.customTourId > 1 THEN ct.tourName
        ELSE t.tourName
    END as tourName,
    CASE 
        WHEN b.tourId = 1 AND b.customTourId > 1 THEN 'Custom Tour'
        ELSE 'Package Tour'
    END as tourType,
    b.tourId,
    b.customTourId,
    b.price,
    b.departureDate,
    b.endDate,
    b.adultQuantity,
    b.childQuantity,
    b.status,
    b.bookingDate
FROM Bookings b
LEFT JOIN Users u ON b.customerId = u.userId
LEFT JOIN Tours t ON b.tourId = t.tourId
LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
ORDER BY b.bookingDate DESC;

PRINT 'Sample data created successfully!';
PRINT 'You can now test the booking management functionality at: http://localhost:8080/SmartTravelBookingSystem/staff/bookings';