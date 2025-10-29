Create database SmartTravelBooking
go
use SmartTravelBooking
go
-- Bảng Users
CREATE TABLE Users (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fullName NVARCHAR(100),
    phone NVARCHAR(20),
    roleId INT NOT NULL DEFAULT 3, 
    createdAt DATETIME DEFAULT GETDATE(),
	status VARCHAR(10) Check (status IN ('ACTIVE', 'LOCKED')) DEFAULT 'ACTIVE',
	FOREIGN KEY (roleId) REFERENCES Roles(roleId)
);
go
select * from Users

CREATE TABLE Roles (
    roleId INT IDENTITY(1,1) PRIMARY KEY,
    roleName NVARCHAR(50) UNIQUE NOT NULL
);
GO

INSERT INTO Roles (roleName)
VALUES ('ADMIN'), ('BOOKING MANAGER'), ('CUSTOMER'), ('STAFF');

-- khi đăng kí thì có luôn profile đấy của user
GO
CREATE TRIGGER trg_AfterInsertUser
ON Users
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ CustomerProfiles roleId = 3 (Customer)
    INSERT INTO CustomerProfiles (userId, fullName)
    SELECT 
        i.userId,
        i.fullName
    FROM inserted i
    WHERE i.roleId = 3;
END
GO



-- Bảng CustomerProfiles
CREATE TABLE CustomerProfiles (
    profileId INT IDENTITY(1,1) PRIMARY KEY,      
    userId INT NOT NULL UNIQUE,  
	fullName NVARCHAR(255) NULL,
    dateOfBirth DATE NULL,
    gender NVARCHAR(10) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')) NULL,
    address NVARCHAR(255) NULL,
    profilePicture NVARCHAR(255) NULL,
    loyaltyPoints INT DEFAULT 0 CHECK (loyaltyPoints >= 0),
    membershipLevel NVARCHAR(20) 
        CHECK (membershipLevel IN ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM')) 
        DEFAULT 'BRONZE',

    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO
-- Cộng điểm khi trạng thái chuyển sang COMPLETED và  cập nhật cấp độ thành viên tự động
CREATE OR ALTER TRIGGER trg_AddLoyaltyPoints_AfterBookingCompleted
ON Bookings
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cộng điểm khi trạng thái chuyển sang COMPLETED
    UPDATE cp
    SET cp.loyaltyPoints = cp.loyaltyPoints + CAST((x.totalAmount * 0.05) AS INT)
    FROM CustomerProfiles cp
    INNER JOIN (
        SELECT 
            i.customerId,
            SUM(
                CASE 
                    WHEN i.tourId IS NOT NULL THEN 
                        (t.price * i.adultQuantity) + (t.price * 0.5 * i.childQuantity)
                    WHEN i.customTourId IS NOT NULL THEN 
                        (ct.totalPrice * i.adultQuantity) + (ct.totalPrice * 0.5 * i.childQuantity)
                    ELSE 0
                END
            ) AS totalAmount
        FROM inserted i
        INNER JOIN Bookings b ON i.bookingId = b.bookingId
        LEFT JOIN Tours t ON i.tourId = t.tourId
        LEFT JOIN CustomTours ct ON i.customTourId = ct.customTourId
        WHERE i.status = 'COMPLETED'
        GROUP BY i.customerId
    ) x ON cp.userId = x.customerId;

    --  Cập nhật cấp độ thành viên sau khi cộng điểm
    UPDATE cp
    SET cp.membershipLevel = 
        CASE
            WHEN cp.loyaltyPoints >= 10000 THEN 'PLATINUM'
            WHEN cp.loyaltyPoints >= 5000 THEN 'GOLD'
            WHEN cp.loyaltyPoints >= 1000 THEN 'SILVER'
            ELSE 'BRONZE'
        END
    FROM CustomerProfiles cp
    INNER JOIN inserted i ON cp.userId = i.customerId
    WHERE i.status = 'COMPLETED';
END;
GO


select * from CustomerContacts
/*
delete from CustomerContacts
DBCC CHECKIDENT ('CustomerContacts' , RESEED , 0)
*/

CREATE TABLE CustomerContacts (
    contactId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    contactValue NVARCHAR(100) NOT NULL,
    contactType NVARCHAR(10) CHECK (contactType IN ('EMAIL', 'PHONE')) NOT NULL,
    isPrimary BIT DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
go

-- trigger set emaail chinh




CREATE TABLE Countries (
    countryId INT IDENTITY(1,1) PRIMARY KEY,
    countryName NVARCHAR(100) UNIQUE NOT NULL,
);
go



-- Bảng Islands
CREATE TABLE Islands (
    islandId INT IDENTITY(1,1) PRIMARY KEY,
    islandName NVARCHAR(100) NOT NULL,
    countryId INT NOT NULL,
    shortDescription NVARCHAR(500),
    longDescription NVARCHAR(MAX),
    bestSeason NVARCHAR(50),
    activities NVARCHAR(255),
    imageUrl NVARCHAR(255),
    location NVARCHAR(500) NULL,
    FOREIGN KEY (countryId) REFERENCES Countries(countryId) ON DELETE CASCADE
);

go
CREATE TABLE Tours (
    tourId INT PRIMARY KEY IDENTITY(1,1),
    islandId INT NOT NULL,
    tourName NVARCHAR(255) UNIQUE NOT NULL,
    description NVARCHAR(MAX),
    price INT CHECK(price >= 0),  -- dùng INT lưu VNĐ
	tourImageUrl NVARCHAR(500),  
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);

CREATE TABLE TourItinerary (
    itineraryId INT PRIMARY KEY IDENTITY(1,1),
    tourId INT NOT NULL,
    dayNumber INT NOT NULL,         -- Ngày 1, Ngày 2, ...
    title NVARCHAR(255) NOT NULL,   -- Ví dụ: "Ngày 1: HCM → Singapore"
    FOREIGN KEY (tourId) REFERENCES Tours(tourId) ON DELETE CASCADE,
    CONSTRAINT UQ_TourItinerary_Tour_Day UNIQUE (tourId, dayNumber)
);


CREATE TABLE TourActivities (
    activityId INT IDENTITY(1,1) PRIMARY KEY,
    itineraryId INT NOT NULL,
    activityOrder INT NOT NULL,           -- Thứ tự hiển thị
    activityTitle NVARCHAR(255), -- Ví dụ: "Wonder Park"
    description NVARCHAR(MAX),   -- Mô tả chi tiết
    FOREIGN KEY (itineraryId) REFERENCES TourItinerary(itineraryId),
	CONSTRAINT UQ_TourActivities_Tour_Day UNIQUE (itineraryId, activityOrder)
);

-- Bảng Hotels
CREATE TABLE Hotels (
    hotelId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    hotelName NVARCHAR(100) NOT NULL,
    roomType NVARCHAR(50) NOT NULL
        CHECK (roomType IN (N'Tiêu chuẩn', N'Cao cấp', N'Hạng sang', N'Gia đình')),
    pricePerNight INT,
    roomsAvailable INT,
    rating DECIMAL(3,1),
    hotelImageUrl VARCHAR(255), -- đường dẫn ảnh khách sạn
	area INT CHECK (area > 0),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);

-- bảng Arlines : các hãng bay
CREATE TABLE Airlines (
    airlineId INT IDENTITY(1,1) PRIMARY KEY,
    airlineName NVARCHAR(100) NOT NULL,   -- Tên hãng hàng không (Vietnam Airlines, Vietjet Air…)
    iataCode VARCHAR(5),                  -- Mã quốc tế (VN, VJ…)
    countryId int NOT NULL,                 -- Quốc gia
	hotline VARCHAR(20),                 -- Đường dây nóng
    logoUrl VARCHAR(255)                  -- Link logo hãng
	FOREIGN KEY (countryId) REFERENCES Countries(countryId)
);
go

-- bảng flights 

CREATE TABLE Flights (
    flightId INT IDENTITY(1,1) PRIMARY KEY,
    flightNumber VARCHAR(20) NOT NULL,           -- Mã chuyến bay (VD: VN123)
    airlineId INT NOT NULL,                      -- FK đến Airlines
    departure NVARCHAR(100) NOT NULL,             -- Nơi xuất phát
    destination NVARCHAR(100) NOT NULL,           -- Điểm đến
    destinationIslandId INT NULL,                -- Nếu điểm đến là đảo -> FK Islands
    departureTime TIME NOT NULL,                 -- Giờ khởi hành
    arrivalTime TIME NOT NULL,                   -- Giờ đến
    returnDepartureTime TIME NULL,               -- Giờ khởi hành chiều về
    returnArrivalTime TIME NULL,                 -- Giờ hạ cánh chiều về
    basePrice INT NOT NULL,                      -- Giá gốc (giá cơ bản)
	ticketAvailable INT NOT NULL ,
    flightType NVARCHAR(10) 
        CHECK (flightType IN ('Một chiều', 'Khứ hồi')) NOT NULL,  -- Loại chuyến bay
    flightClass NVARCHAR(50) 
        CHECK (flightClass IN ('Phổ thông', 'Thương gia', 'Hạng nhất')) NOT NULL, -- Hạng vé
    destinationImageUrl VARCHAR(255) NULL,       -- Ảnh điểm đến (nếu là đảo)
    FOREIGN KEY (airlineId) REFERENCES Airlines(airlineId),
    FOREIGN KEY (destinationIslandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);



	CREATE TABLE FlightSchedules (
		scheduleId INT IDENTITY(1,1) PRIMARY KEY,
		flightId INT NOT NULL FOREIGN KEY REFERENCES Flights(flightId),
		planeModel NVARCHAR(100) NULL,          -- loại máy bay
		departureAirport NVARCHAR(100) NOT NULL, -- sân bay khởi hành
		arrivalAirport NVARCHAR(100) NOT NULL,   -- sân bay đến
		transitAirport NVARCHAR(100) NULL,       -- sân bay trung chuyển (nếu có)
		transitDuration NVARCHAR(50) NULL,       -- thời gian dừng (VD: '7h30', '45 phút')
		notes NVARCHAR(255) NULL                 -- ghi chú (VD: "Hành khách không cần nhận lại hành lý...")
	);


INSERT INTO FlightSchedules 
(flightId, planeModel, departureAirport, arrivalAirport, transitAirport, transitDuration, notes)
VALUES
-- 1. Hà Nội → Phú Quốc
(1, N'Airbus A321neo', N'Nội Bài (HAN)', N'Phú Quốc (PQC)', NULL, NULL, 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 2. Hà Nội → Phú Quốc
(2, N'Airbus A320', N'Nội Bài (HAN)', N'Phú Quốc (PQC)', NULL, NULL, 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 3. Hà Nội → Phú Quốc
(3, N'Boeing 737 MAX 8', N'Nội Bài (HAN)', N'Phú Quốc (PQC)', NULL, NULL, 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 4. TP.HCM → Phú Quốc
(4, N'Airbus A321', N'Tân Sơn Nhất (SGN)', N'Phú Quốc (PQC)', NULL, NULL, 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 5. Hà Nội → Phú Quốc (Khứ hồi)
(5, N'Airbus A321', N'Nội Bài (HAN)', N'Phú Quốc (PQC)', NULL, NULL, 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 6. TP.HCM → Phú Quốc (Khứ hồi)
(6, N'Airbus A320', N'Tân Sơn Nhất (SGN)', N'Phú Quốc (PQC)', NULL, NULL, 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 7. TP.HCM → Langkawi (Malaysia)
(7, N'Boeing 737-800', N'Tân Sơn Nhất (SGN)', N'Langkawi (LGK)', N'Kuala Lumpur (KUL)', N'1h20', 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 8. TP.HCM → Langkawi
(8, N'Airbus A320', N'Tân Sơn Nhất (SGN)', N'Langkawi (LGK)', N'Kuala Lumpur (KUL)', N'1h15', 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 9. Hà Nội → Phuket (Thái Lan)
(9, N'Airbus A321', N'Nội Bài (HAN)', N'Phuket (HKT)', N'Bangkok (BKK)', N'1h05', 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 10. TP.HCM → Bali (Indonesia)
(10, N'Boeing 737 MAX 9', N'Tân Sơn Nhất (SGN)', N'Bali (DPS)', N'Jakarta (CGK)', N'1h30',
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 11. TP.HCM → Bali (1 chiều)
(11, N'Airbus A320', N'Tân Sơn Nhất (SGN)', N'Bali (DPS)', N'Jakarta (CGK)', N'1h20',
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 12. Hà Nội → Boracay (Philippines)
(12, N'Airbus A321neo', N'Nội Bài (HAN)', N'Boracay (MPH)', N'Manila (MNL)', N'1h10', 
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 13. TP.HCM → Sihanoukville (Campuchia)
(13, N'ATR 72-600', N'Tân Sơn Nhất (SGN)', N'Sihanoukville (KOS)', NULL, NULL,
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 14. Hà Nội → Tioman (Malaysia)
(14, N'Airbus A320', N'Nội Bài (HAN)', N'Tioman (TOD)', N'Kuala Lumpur (KUL)', N'1h25',
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 15. TP.HCM → Koh Samui (Thái Lan)
(15, N'Airbus A319', N'Tân Sơn Nhất (SGN)', N'Koh Samui (USM)', N'Bangkok (BKK)', N'50 phút',
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 16. Hà Nội → Nusa Penida (Indonesia)
(16, N'Boeing 737 MAX 8', N'Nội Bài (HAN)', N'Nusa Penida (NDP)', N'Denpasar (DPS)', N'1h10',
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.'),

-- 17. TP.HCM → Palawan (Philippines)
(17, N'Airbus A321neo', N'Tân Sơn Nhất (SGN)', N'Palawan (PPS)', N'Manila (MNL)', N'1h00',
 N'Hành khách không cần nhận lại hành lý, đã bao gồm trong dịch vụ tour.');


/* lenh join lay lich trinh bay chi tiet
SELECT 
    fs.scheduleId,
	fs.flightId,
    a.airlineName AS airlineName,
    f.flightNumber AS flightNumber,
	fs.planeModel AS planeModel,
	f.flightType   AS flightType,
    fs.departureAirport AS DiemDi,
    fs.arrivalAirport AS DiemDen,
    f.departureTime AS GioKhoiHanh,
    f.arrivalTime AS GioDen,
	f.returnDepartureTime AS GioKhoiHanhVe,
	f.returnArrivalTime AS GioDenVe,
    fs.transitAirport AS SanBayQuaCanh,
    fs.transitDuration AS ThoiGianDung,
    fs.notes AS GhiChu
FROM FlightSchedules fs
JOIN Flights f ON fs.flightId = f.flightId
JOIN Airlines a ON f.airlineId = a.airlineId
ORDER BY fs.scheduleId;

*/

/* lenh join lay thong tin chuyen bay
SELECT 
    f.flightId,
    f.flightNumber,
    f.departure,
    f.destination,
    f.departureTime,
    f.arrivalTime,
    f.basePrice,
    f.flightType,
    f.flightClass,
    f.destinationImageUrl,
    a.airlineName,
    a.iataCode,
    a.logoUrl
FROM Flights f
JOIN Airlines a ON f.airlineId = a.airlineId;





*/
GO


-- Bảng phương tiện cho thuê trong đảo
CREATE TABLE IslandVehicles (
    vehicleId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    vehicleType NVARCHAR(50)
        CHECK (vehicleType IN (N'Ô tô', N'Xe tay ga', N'Xe máy', N'Xe đạp', N'Xe điện', N'Khác')),
    modelName NVARCHAR(100),
    pricePerDay DECIMAL(10,3),
    capacity INT,
    availability INT,
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);

go


 -- tour rieng le cho customer
CREATE TABLE CustomTours (
    customTourId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    tourName NVARCHAR(150) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    totalPrice INT CHECK (totalPrice >= 0),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);


INSERT INTO CustomTours (islandId, tourName, startDate, endDate, totalPrice)
VALUES
(1, N'Tour Văn hóa & Biển Phú Quốc 2N1Đ', '2025-11-10', '2025-11-11', 3590000),
(1, N'Tour Lặn biển Phú Quốc 4N3Đ', '2025-11-1', '2025-11-7', 7990000),
(3, N'Tour Khám phá Phuket 4N3Đ', '2025-11-1', '2025-11-7', 7990000),
(4, N'Tour Văn hóa & Biển Bali 5N4Đ', '2025-10-1', '2025-10-6', 10000000),
(4, N'Tour Nghỉ dưỡng Bali 4N3Đ', '2025-10-23', '2025-10-26', 82400000),
(8, N'Tour Nghỉ dưỡng Koh Samui 4N3Đ', '2025-9-23', '2025-9-25', 79100000),
(8, N'Tour Văn hóa Koh Samui 5N4Đ', '2025-9-3', '2025-9-10', 12900000);






 -- detail tour rieng le cho customer

CREATE TABLE CustomTourDetails (
    detailId INT IDENTITY(1,1) PRIMARY KEY,
    customTourId INT NOT NULL,
    serviceType NVARCHAR(50)
        CHECK (serviceType IN (N'Khách sạn', N'Chuyến bay', N'Phương tiện', N'Địa điểm nổi bật')),
    serviceId INT NOT NULL,       -- ID từ bảng Hotels, Flights, IslandVehicles
    price INT CHECK (price >= 0),
    FOREIGN KEY (customTourId) REFERENCES CustomTours(customTourId) ON DELETE CASCADE
);

go
 -- lich trinh tour rieng le cho customer
CREATE TABLE CustomTourItinerary (
    itineraryId INT IDENTITY(1,1) PRIMARY KEY,
    customTourId INT NOT NULL,
    dayNumber INT CHECK (dayNumber > 0),
    activity NVARCHAR(255) NOT NULL,
    location NVARCHAR(150),
    timeOfDay NVARCHAR(50),
    FOREIGN KEY (customTourId) REFERENCES CustomTours(customTourId) ON DELETE CASCADE
);
go

-- trigger check role customer mới đc booking 
CREATE TRIGGER trg_Booking_CheckCustomer
ON Bookings
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ cho phép user có roleId = 3 (CUSTOMER)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Users u ON i.customerId = u.userId
        WHERE u.roleId <> 3
    )
    BEGIN
        RAISERROR('Only users with roleId = 3 (CUSTOMER) can create bookings.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    --  Nếu hợp lệ, insert dữ liệu vào Bookings
    INSERT INTO Bookings (
        profileId,
        customerId,
        tourId,
        customTourId,
        price,
        departureDate,
        endDate,
        adultQuantity,
        childQuantity,
        status,
        bookingDate
    )
    SELECT 
        profileId,
        customerId,
        tourId,
        customTourId,
        price,
        departureDate,
        endDate,
        adultQuantity,
        childQuantity,
        status,
        bookingDate
    FROM inserted;
END;
GO
select * from Bookings
CREATE TABLE Bookings (
		bookingId INT IDENTITY(1,1) PRIMARY KEY,
		customerId INT NOT NULL,
		departureDate DATE NOT NULL,
		endDate DATE    ,
		adultQuantity INT NOT NULL,
		childQuantity INT NOT NULL,
		status NVARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'COMPLETED')) DEFAULT 'PENDING',
		bookingDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (customerId) REFERENCES Users(userId),
);

-- Bảng Payments
  

  select * from HistoryBooking
  select * from CustomerProfiles
  select * from Notifications
  
  update Payments
  set status ='FAILED'
  WHERE paymentId=4
CREATE TABLE Payments (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    amount BIGINT,
    status VARCHAR(20) CHECK (status IN ('SUCCESS','FAILED','PENDING')) DEFAULT 'PENDING',
    FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId) ON DELETE CASCADE
);

go

-- triger ghi lại lịch sử booking 

CREATE TRIGGER trg_Payments_StatusChange
ON Payments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HistoryBooking (customerId, paymentId, note, tourStatus)
    SELECT 
        b.customerId,
        i.paymentId,
        CASE 
            WHEN i.status = 'SUCCESS' THEN N'Gói "' + t.tourName + N'" của bạn đã đặt thành công'
            WHEN i.status = 'FAILED'  THEN N'Gói "' + t.tourName + N'" của bạn đã đặt thất bại'
            WHEN i.status = 'PENDING' THEN N'Gói "' + t.tourName + N'" của bạn đang chờ xử lý'
        END AS note,
        CASE 
            WHEN i.status = 'SUCCESS' THEN 'COMPLETED'
            ELSE 'INCOMPLETE'
        END AS tourStatus
    FROM inserted i
    INNER JOIN Bookings b ON i.bookingId = b.bookingId
    INNER JOIN Tours t ON b.tourId = t.tourId;
END;
GO


CREATE TABLE HistoryBooking (
    historyId INT IDENTITY(1,1) PRIMARY KEY,                 -- Mã lịch sử
    customerId INT NOT NULL,                                
    paymentId INT NOT NULL,                                   
    note NVARCHAR(255) NULL,                                  -- Ghi chú
    tourStatus NVARCHAR(20) NOT NULL CHECK (
        tourStatus IN ('COMPLETED', 'INCOMPLETE')
    ) DEFAULT 'INCOMPLETE', 
--    FOREIGN KEY (customerId) REFERENCES CustomerProfiles(userId) ON DELETE CASCADE,
    FOREIGN KEY (paymentId) REFERENCES Payments(paymentId) ON DELETE CASCADE
);
GO





-- Bảng Recommendations
CREATE TABLE Recommendations (
    recId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    islandId INT,
    score DECIMAL(3,2),
    generatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE,
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);

go

-- bảng logs
CREATE TABLE Logs (
    LogId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    Action NVARCHAR(100) NOT NULL,
	Method NVARCHAR(20) NULL,    
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
go


-- Tokens
CREATE TABLE Tokens (
    TokenId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,	
    TokenValue NVARCHAR(100) NOT NULL,
    ExpiryDate DATETIME NOT NULL,
    IsUsed BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
	OtpCode VARCHAR(255) NULL,
	AttemptCount INT DEFAULT 0,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
go


-- review
CREATE TABLE Reviews (
    reviewId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN ('HOTEL','FLIGHT','CAR','ISLAND')),
    refId INT NOT NULL, -- id của dịch vụ
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(1000),
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) 
);
go
-- Notification 
CREATE TABLE Notifications (
    notificationId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    title NVARCHAR(100) NOT NULL,
    message NVARCHAR(500) NOT NULL,
    type VARCHAR(30) CHECK (type IN ('BOOKING','PAYMENT','PROMOTION','SYSTEM')) DEFAULT 'SYSTEM',
    isRead BIT DEFAULT 0, -- 0: chưa đọc, 1: đã đọc
	isDeleted BIT DEFAULT 0, -- xoa mem tren UI user thoi
    createdAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO
-- reset thông báo 
/*
UPDATE Notifications 
SET  isRead = 0
WHERE userId = 2;
	
UPDATE Notifications 
SET  isDeleted = 0
WHERE userId = 2;
*/




--- trigger khi thông báo khi người dùng đặt chỗ "chạy khi thêm bản ghi mới vào Bookings"

CREATE TRIGGER trg_Booking_Insert_Notification
ON Bookings
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notifications (userId, title, message, type)
    SELECT 
        i.customerId,
        N'Đặt chỗ thành công',
        CASE 
            --  Nếu là tour trọn gói
            WHEN i.tourId IS NOT NULL THEN 
                N'Bạn vừa đặt tour trọn gói."' + t.tourName 
            
            -- Nếu là tour riêng lẻ (custom tour)
            WHEN i.customTourId IS NOT NULL THEN 
                N'Bạn vừa đặt tour riêng. "' + ct. tourName 
               
            
            -- Trường hợp không xác định 
            ELSE 
                N'Bạn vừa tạo đặt chỗ thành công.' 
        END AS message,
        'BOOKING'
    FROM inserted i
	--Dùng LEFT JOIN để tránh lỗi nếu 1 trong 2 trường NULL
    LEFT JOIN Tours t ON i.tourId = t.tourId
    LEFT JOIN CustomTours ct ON i.customTourId = ct.customTourId;
END;
GO






--- triger khi thông báo customer thanh toán "chạy khi cập nhật trạng thái Payments"
CREATE TRIGGER trg_Payment_Success
ON Payments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notifications (userId, title, message, type)
    SELECT 
        b.customerId AS userId,
        N'Thanh toán thành công',
        CASE 
            -- Nếu là tour trọn gói
            WHEN b.tourId IS NOT NULL THEN
                N'Giao dịch thanh toán cho tour. "'
              

            --  Nếu là tour riêng lẻ 
            WHEN b.customTourId IS NOT NULL THEN
                N'Giao dịch thanh toán cho tour riêng. "' + ct.tourName 
              

            -- Trường hợp không xác định
            ELSE
                N'Giao dịch thanh toán đã được xác nhận thành công.'
        END AS message,
        'PAYMENT'
    FROM inserted p
    JOIN Bookings b ON p.bookingId = b.bookingId
    LEFT JOIN Tours t ON b.tourId = t.tourId
    LEFT JOIN CustomTours ct ON b.customTourId = ct.customTourId
    WHERE p.status = 'SUCCESS';
END;
GO




-- Users



-- favourite services
CREATE TABLE Favorites (
    favoriteId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN ('HOTEL','FLIGHT','CAR','ISLAND')),
    refId INT NOT NULL,  -- id dịch vụ được lưu
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
go

-- promotion
CREATE TABLE Promotions (
    promoId INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description NVARCHAR(255),
    discountType VARCHAR(20) CHECK (discountType IN ('PERCENT','AMOUNT')) NOT NULL,
    discountValue DECIMAL(10,3) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    usageLimit INT DEFAULT 0, -- số lần tối đa được dùng (0 = không giới hạn)
    createdAt DATETIME DEFAULT GETDATE()
);
go

-- use promotions

CREATE TABLE UserPromotions (
    userPromoId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    promoId INT NOT NULL,
    usedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE,
    FOREIGN KEY (promoId) REFERENCES Promotions(promoId) ON DELETE CASCADE
);


-----------------------------------------------------------------
-- INSERT DATA
--1. user

-- Admin
INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
VALUES 
('admin1', 'admin123!', 'admin1@example.com', N'Admin', N'0987654321', 1, 'ACTIVE');

-- Booking Manager
INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
VALUES 
('bookingmanager1', 'managerpass123!', 'nqaghuyyy6969@gmail.com', N'Booking Manager', N'0369409004', 2, 'ACTIVE');
-- Customer
INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
VALUES 
('quanghuy123', 'huyvipmn5', 'huynqhe182510@fpt.edu.vn', N'David Huy', N'0982706236', 3, 'ACTIVE');

-- (Staff)
INSERT INTO Users (username, password, email, fullName, phone, roleId, status)
VALUES 
('provider1', 'providerpass123!', 'provider@example.com', N'Staff', N'0987654321', 4, 'ACTIVE');
/*
 DELETE FROM Users
WHERE userId = 6;

select * from Users
delete from Tokens
DBCC CHECKIDENT ('Users', RESEED , 5);
*/


INSERT INTO Countries (countryName) VALUES
(N'Việt Nam'),
(N'Lào'),
(N'Campuchia'),
(N'Thái Lan'),
(N'Myanmar'),
(N'Malaysia'),
(N'Singapore'),
(N'Indonesia'),
(N'Philippines'),
(N'Brunei'),
(N'Đông Timor');


INSERT INTO Islands (islandName, countryId, shortDescription, longDescription, bestSeason, activities, imageUrl, location)
VALUES
(N'Phú Quốc', 1, 
 N'Đảo lớn nhất Việt Nam, nổi tiếng với bãi biển đẹp và hải sản tươi ngon.',
 N'Phú Quốc là hòn đảo lớn nhất Việt Nam, nổi tiếng với bãi cát trắng mịn, nước biển trong xanh và những rặng san hô đa dạng. Du khách có thể tham quan các làng chài truyền thống, trải nghiệm câu cá, lặn biển, khám phá vườn tiêu và thưởng thức hải sản tươi ngon.',
 N'Hạ',
 N'Bơi lội, Lặn biển, Ngắm san hô, Tham quan làng chài, Khám phá vườn tiêu',
 N'views/home/images/islands/phuquoc.jpg',
 N'Xã Dương Đông, Thành phố Phú Quốc, Tỉnh Kiên Giang, Việt Nam'),

(N'Langkawi', 6,
 N'Quần đảo đẹp của Malaysia với rừng mưa nhiệt đới và biển hoang sơ.',
 N'Langkawi là quần đảo nằm ở bờ biển phía Tây Bắc Malaysia, nổi bật với phong cảnh thiên nhiên tươi đẹp, rừng mưa nhiệt đới và những bãi biển hoang sơ. Du khách có thể tham gia các tour khám phá đảo, đi cáp treo ngắm toàn cảnh, hoặc trải nghiệm các hoạt động dưới nước.',
 N'Hạ',
 N'Tham quan, Lặn biển, Đi cáp treo, Khám phá rừng mưa',
 N'views/home/images/islands/langkawi.jpg',
 N'Quận Langkawi, Bang Kedah, Malaysia'),

(N'Phuket', 4,
 N'Hòn đảo du lịch nổi tiếng nhất Thái Lan với biển đẹp và nightlife sôi động.',
 N'Phuket là hòn đảo lớn nhất Thái Lan, nổi tiếng với bãi biển Patong sôi động, các khu phố ẩm thực, và nightlife náo nhiệt. Du khách có thể thư giãn trên bãi biển, tham gia các môn thể thao dưới nước, hoặc khám phá các ngôi chùa và khu di tích văn hóa.',
 N'Thu',
 N'Tắm biển, Lặn biển, Nightlife, Tham quan chùa, Tour đảo',
 N'views/home/images/islands/phuket.jpg',
 N'Phường Patong, Huyện Kathu, Tỉnh Phuket, Thái Lan'),

(N'Bali', 8,
 N'Đảo thiên đường của Indonesia, nổi tiếng với văn hóa Hindu và đền chùa cổ.',
 N'Bali nổi tiếng với văn hóa Hindu độc đáo, nhiều ngôi đền cổ kính và cảnh quan thiên nhiên tuyệt đẹp. Hòn đảo này còn hấp dẫn du khách với các bãi biển lý tưởng để lướt sóng, trải nghiệm yoga, và khám phá các làng nghề truyền thống.',
 N'Xuân',
 N'Lướt sóng, Tham quan đền chùa, Tắm biển, Yoga, Khám phá làng nghề',
 N'views/home/images/islands/bali.jpg',
 N'Huyện Badung, Tỉnh Bali, Indonesia'),

(N'Boracay', 9,
 N'Đảo nhỏ của Philippines nổi tiếng với bãi cát trắng và nightlife.',
 N'Boracay là hòn đảo nhỏ nhưng nổi tiếng với bãi cát trắng mịn trải dài, nước biển trong xanh và hoạt động nightlife sôi động. Du khách có thể tham gia các môn thể thao dưới nước, đi thuyền ngắm hoàng hôn, hoặc thư giãn tại các resort sang trọng ven biển.',
 N'Đông',
 N'Tắm biển, Thể thao dưới nước, Nightlife, Tham quan đảo bằng thuyền',
 N'views/home/images/islands/boracay.jpg',
 N'Barangay Balabag, Thị trấn Malay, Tỉnh Aklan, Philippines'),

(N'Sihanoukville', 3,
 N'Thành phố biển nổi tiếng của Campuchia với nhiều bãi tắm và đảo nhỏ.',
 N'Sihanoukville là thành phố ven biển của Campuchia với nhiều bãi biển đẹp và các đảo nhỏ xung quanh. Du khách có thể tắm biển, lặn ngắm san hô, đi thuyền khám phá các đảo hoang sơ, và trải nghiệm ẩm thực địa phương.',
 N'Đông',
 N'Tắm biển, Lặn ngắm san hô, Đi thuyền, Tham quan đảo',
 N'views/home/images/islands/sihanoukville.jpg',
 N'Phường 3, Thành phố Preah Sihanouk, Tỉnh Preah Sihanouk, Campuchia'),

(N'Tioman', 6,
 N'Hòn đảo nhiệt đới nổi tiếng của Malaysia với rừng rậm và san hô.',
 N'Tioman là hòn đảo nhiệt đới nổi tiếng với rừng rậm, rạn san hô đa dạng và thiên nhiên hoang sơ. Du khách có thể lặn biển ngắm san hô, leo núi khám phá rừng, hoặc tham gia các hoạt động dã ngoại ngoài trời.',
 N'Hạ',
 N'Lặn biển, Leo núi, Ngắm san hô, Khám phá rừng nhiệt đới',
 N'views/home/images/islands/tioman.jpg',
 N'Mukim Tioman, Quận Rompin, Bang Pahang, Malaysia'),

(N'Koh Samui', 4,
 N'Đảo lớn thứ hai Thái Lan với spa, chùa chiền và nightlife.',
 N'Koh Samui là hòn đảo nổi tiếng với bãi biển cát trắng, thác nước tuyệt đẹp và các ngôi chùa linh thiêng. Du khách có thể tắm biển, tham quan chùa, trải nghiệm spa truyền thống Thái, và thưởng thức ẩm thực địa phương.',
 N'Xuân',
 N'Tắm biển, Tham quan chùa, Nightlife, Spa truyền thống, Tham quan thác nước',
 N'views/home/images/islands/kohsamui.jpg',
 N'Xã Bo Phut, Huyện Ko Samui, Tỉnh Surat Thani, Thái Lan'),

(N'Nusa Penida', 8,
 N'Đảo hoang sơ của Indonesia nổi bật với vách đá và biển xanh.',
 N'Nusa Penida nổi bật với vách đá cao, nước biển trong xanh và các điểm lặn ngắm san hô tuyệt đẹp. Hòn đảo hoang sơ này thích hợp cho những ai yêu thiên nhiên và thích khám phá các cảnh quan độc đáo.',
 N'Thu',
 N'Lặn biển, Ngắm san hô, Tham quan vách đá, Leo núi, Khám phá thiên nhiên',
 N'views/home/images/islands/nusapenida.jpg',
 N'Huyện Klungkung, Tỉnh Bali, Indonesia'),

(N'Palawan', 9,
 N'Hòn đảo đẹp nhất Philippines với đầm phá xanh ngọc và vách đá vôi.',
 N'Palawan là hòn đảo nổi tiếng với đầm phá xanh ngọc, bãi biển đẹp và các vách đá vôi kỳ vĩ. Du khách có thể tham gia tour island-hopping, chèo kayak, khám phá hang động và trải nghiệm cuộc sống ven biển.',
 N'Hạ',
 N'Đi thuyền đảo, Kayak, Lặn ngắm san hô, Khám phá hang động, Island-hopping',
 N'views/home/images/islands/palawan.jpg',
 N'Thành phố Puerto Princesa, Tỉnh Palawan, Philippines');


--3.hotel

INSERT INTO Tours (islandId, tourName, description, price, tourImageUrl) VALUES
-- Phú Quốc (islandId = 1)
(1, N'Tour Nghỉ dưỡng Phú Quốc 3N2Đ', 
 N'Tham quan Vinpearl Safari, Bãi Sao, Chợ đêm Dinh Cậu.', 
 3500000, 
 N'views/home/images/tours/phuquoc_nghiduong.jpg'),

(1, N'Tour Lặn biển Phú Quốc 4N3Đ', 
 N'Lặn ngắm san hô Hòn Móng Tay, câu cá đêm, BBQ trên biển.', 
 5000000, 
 N'views/home/images/tours/phuquoc_lanbien.jpg'),

(1, N'Tour Văn hóa & Biển Phú Quốc 2N1Đ', 
 N'Thăm làng chài Hàm Ninh, thưởng thức đặc sản nước mắm, tắm biển.', 
 2500000, 
 N'views/home/images/tours/phuquoc_vanhoabiens.jpg'),

-- Langkawi (islandId = 2)
(2, N'Tour Khám phá Langkawi 4N3Đ', 
 N'Trải nghiệm cầu treo SkyBridge, tắm biển Pantai Cenang, mua sắm duty-free.', 
 4500000, 
 N'views/home/images/tours/langkawi_khampha.jpg'),

-- Phuket (islandId = 3)
(3, N'Tour Khám phá Phuket 4N3Đ', 
 N'Thăm đảo Phi Phi, phố cổ Phuket, show Simon Cabaret.', 
 5500000, 
 N'views/home/images/tours/phuket_khampha.jpg'),

-- Bali (islandId = 4)
(4, N'Tour Văn hóa & Biển Bali 5N4Đ', 
 N'Thăm đền Tanah Lot, ruộng bậc thang Tegallalang, nghỉ dưỡng tại Kuta Beach.', 
 9000000, 
 N'views/home/images/tours/bali_vanhoabien.jpg'),

(4, N'Tour Nghỉ dưỡng Bali 4N3Đ', 
 N'Spa truyền thống, yoga, biển Jimbaran, ngắm hoàng hôn Uluwatu.', 
 7500000, 
 N'views/home/images/tours/bali_nghiduong.jpg'),

-- Boracay (islandId = 5)
(5, N'Tour Biển Boracay 4N3Đ', 
 N'Tắm biển White Beach, lặn ngắm san hô, tham gia tiệc đêm sôi động.', 
 6000000, 
 N'views/home/images/tours/boracay_bien.jpg'),

-- Koh Samui (islandId = 8)
(8, N'Tour Nghỉ dưỡng Koh Samui 4N3Đ', 
 N'Thăm Big Buddha Temple, thác Na Muang, chợ đêm Fisherman’s Village.', 
 6500000, 
 N'views/home/images/tours/kohsamui_nghiduong.jpg'),

(8, N'Tour Văn hóa Koh Samui 5N4Đ', 
 N'Thăm chùa Wat Plai Laem, trải nghiệm massage Thái, ẩm thực địa phương.', 
 8000000, 
 N'views/home/images/tours/kohsamui_vanhoaspa.jpg');

INSERT INTO TourItinerary (tourId, dayNumber, title) VALUES
-- Tour 1: Phú Quốc 3N2Đ
(1, 1, N'Hà Nội → Phú Quốc'),
(1, 2, N'Khám phá Phú Quốc'),
(1, 3, N'Phú Quốc → Hà Nội'),

-- Tour 2: Phú Quốc 4N3Đ
(2, 1, N'Hà Nội → Phú Quốc'),
(2, 2, N'Lặn biển'),
(2, 3, N'Câu cá & BBQ'),
(2, 4, N'Phú Quốc → Hà Nội'),

-- Tour 3: Phú Quốc 2N1Đ
(3, 1, N'Hà Nội → Phú Quốc'),
(3, 2, N'Phú Quốc → Hà Nội'),

-- Tour 4: Langkawi 4N3Đ
(4, 1, N'Hà Nội → Langkawi'),
(4, 2, N'SkyBridge'),
(4, 3, N'Biển & Shopping'),
(4, 4, N'Langkawi → Hà Nội'),

-- Tour 5: Phuket 4N3Đ
(5, 1, N'Đến Phuket'),
(5, 2, N'Tham quan đảo Phi Phi'),
(5, 3, N'Phố cổ Phuket - Show Simon Cabaret'),
(5, 4, N'Trả khách'),

(6, 1, N'Đền Tanah Lot'),
(6, 2, N'Tegallalang Rice Terrace'),
(6, 3, N'Kuta Beach'),
(6, 4, N'Tham quan Ubud'),
(6, 5, N'Trả khách'),

(7, 1, N'Spa truyền thống'),
(7, 2, N'Yoga - Jimbaran Beach'),
(7, 3, N'Uluwatu Sunset'),
(7, 4, N'Trả khách'),

(8, 1, N'White Beach'),
(8, 2, N'Lặn ngắm san hô'),
(8, 3, N'Tiệc đêm'),
(8, 4, N'Trả khách'),

(9, 1, N'Big Buddha Temple'),
(9, 2, N'Thác Na Muang'),
(9, 3, N'Fisherman’s Village'),
(9, 4, N'Trả khách'),

(10, 1, N'Wat Plai Laem'),
(10, 2, N'Massage Thái'),
(10, 3, N'Ẩm thực địa phương'),
(10, 4, N'Tham quan đảo xung quanh'),
(10, 5, N'Trả khách');

-- Tour 1: Phú Quốc 3N2Đ
INSERT INTO TourActivities (itineraryId, activityOrder, activityTitle, description) VALUES
(1, 1, N'Khởi hành từ Hà Nội', N'Bay từ Hà Nội đến Phú Quốc, nhận phòng khách sạn.'),
(2, 1, N'Tham quan Vinpearl Safari', N'Khám phá vườn thú bán hoang dã lớn nhất Việt Nam.'),
(2, 2, N'Tắm biển Bãi Sao', N'Tận hưởng bãi biển đẹp nhất Phú Quốc.'),
(2, 3, N'Chợ đêm Dinh Cậu', N'Thưởng thức hải sản và mua sắm.'),
(3, 1, N'Trả phòng', N'Trả phòng khách sạn, khởi hành về Hà Nội.'),

-- Tour 2: Phú Quốc 4N3Đ
(4, 1, N'Khởi hành từ Hà Nội', N'Đến Phú Quốc, nhận phòng khách sạn.'),
(5, 1, N'Lặn ngắm san hô', N'Trải nghiệm lặn biển tại Hòn Móng Tay.'),
(5, 2, N'Tắm biển', N'Tự do nghỉ ngơi tại resort.'),
(6, 1, N'Câu cá đêm', N'Thử thách câu cá trên biển.'),
(6, 2, N'BBQ hải sản', N'Thưởng thức tiệc BBQ trên bãi biển.'),
(7, 1, N'Trả phòng', N'Về Hà Nội.'),

-- Tour 3: Phú Quốc 2N1Đ
(8, 1, N'Khởi hành', N'Bay từ Hà Nội đến Phú Quốc.'),
(8, 2, N'Thăm làng chài Hàm Ninh', N'Tìm hiểu đời sống ngư dân và thưởng thức hải sản.'),
(9, 1, N'Trả phòng', N'Trở về Hà Nội.'),

-- Tour 4: Langkawi 4N3Đ
(10, 1, N'Khởi hành', N'Bay từ Hà Nội đến Langkawi.'),
(11, 1, N'Tham quan SkyBridge', N'Chiêm ngưỡng cây cầu treo nổi tiếng.'),
(12, 1, N'Tắm biển Pantai Cenang', N'Tắm biển và tham gia trò chơi nước.'),
(12, 2, N'Shopping Duty-free', N'Mua sắm tại các cửa hàng miễn thuế.'),
(13, 1, N'Trở về Hà Nội', N'Kết thúc tour.'),

-- Tour 5: Phuket 4N3Đ
(14, 1, N'Đến Phuket', N'Đón khách tại sân bay và nhận phòng khách sạn.'),
(15, 1, N'Tham quan đảo Phi Phi', N'Tham gia tour du thuyền thăm đảo Phi Phi.'),
(16, 1, N'Phố cổ Phuket', N'Dạo chơi và tham quan kiến trúc cổ.'),
(16, 2, N'Simon Cabaret Show', N'Thưởng thức show diễn nổi tiếng tại Phuket.'),
(17, 1, N'Trả khách', N'Kết thúc hành trình.'),

-- Tour 6: Bali
(18, 1, N'Xuất phát từ Hà Nội', N'Tập trung tại sân bay Nội Bài, làm thủ tục khởi hành.'),
(18, 2, N'Đến Phuket', N'Hướng dẫn viên đón đoàn, nhận phòng khách sạn và nghỉ ngơi.'),
(19, 1, N'Du thuyền ra đảo Phi Phi', N'Tham quan vịnh Maya nổi tiếng.'),
(19, 2, N'Lặn biển ngắm san hô', N'Trải nghiệm snorkeling tại vịnh Loh Samah.'),
(19, 3, N'Tham quan Viking Cave', N'Khám phá hang động nổi tiếng.'),
(20, 1, N'Du thuyền vịnh Phang Nga', N'Tham quan đảo James Bond nổi tiếng.'),
(20, 2, N'Chèo kayak hang động', N'Trải nghiệm chèo kayak tại hòn đảo đá vôi.'),
(20, 3, N'Dùng bữa trưa trên du thuyền', N'Thưởng thức hải sản địa phương.'),
(21, 1, N'Tham quan chùa Wat Chalong', N'Ngôi chùa lớn nhất ở Phuket.'),
(21, 2, N'Tượng Phật Lớn Big Buddha', N'Chiêm ngưỡng bức tượng Phật cao 45m.'),
(21, 3, N'Tắm biển Patong', N'Thư giãn và vui chơi trên bãi biển Patong.'),
(22, 1, N'Ra sân bay', N'Làm thủ tục bay về Hà Nội, kết thúc tour.')


INSERT INTO Hotels (islandId, hotelName, roomType, pricePerNight, roomsAvailable, rating, hotelImageUrl)
VALUES
-- Phú Quốc
(1, N'Vinpearl Resort & Spa Phu Quoc', N'Cao cấp', 1500000, 20, 4.8, 'views/home/images/hotels/vinpearl_pq_main.jpg'),
(1, N'Salinda Resort Phu Quoc', N'Hạng sang', 1200000, 15, 4.9, 'views/home/images/hotels/salinda_pq_main.jpg'),
(1, N'Novotel Phu Quoc Resort', N'Tiêu chuẩn', 900000, 25, 4.5, 'views/home/images/hotels/novotel_pq_main.jpg'),
(1, N'Mövenpick Villas & Residences Phu Quoc', N'Hạng sang', 2000000, 10, 4.9, 'views/home/images/hotels/movenpick_pq_main.jpg'),

-- Langkawi
(2, N'Berjaya Langkawi Resort', N'Hạng sang', 800000, 25, 4.5, 'views/home/images/hotels/berjaya_langkawi_main.jpg'),
(2, N'The Datai Langkawi', N'Hạng sang', 2500000, 10, 4.9, 'views/home/images/hotels/datai_langkawi_main.jpg'),
(2, N'The Danna Langkawi', N'Cao cấp', 1800000, 12, 4.8, 'views/home/images/hotels/danna_langkawi_main.jpg'),
(2, N'Holiday Villa Resort & Beachclub Langkawi', N'Tiêu chuẩn', 600000, 30, 4.0, 'views/home/images/hotels/holidayvilla_langkawi_main.jpg'),

-- Phuket
(3, N'Amari Phuket', N'Tiêu chuẩn', 900000, 35, 4.6, 'views/home/images/hotels/amari_phuket_main.jpg'),
(3, N'The Shore at Katathani', N'Hạng sang', 2200000, 12, 4.8, 'views/home/images/hotels/shore_katathani_main.jpg'),
(3, N'The Nai Harn', N'Cao cấp', 1500000, 20, 4.7, 'views/home/images/hotels/the_naiharn_main.jpg'),
(3, N'Swissotel Phuket Patong Beach Resort', N'Tiêu chuẩn', 800000, 28, 4.4, 'views/home/images/hotels/swissotel_phuket_main.jpg'),

-- Bali
(4, N'Bali Mandira Beach Resort', N'Gia đình', 1000000, 20, 4.5, 'views/home/images/hotels/mandira_bali_main.jpg'),
(4, N'Four Seasons Bali at Sayan', N'Hạng sang', 3000000, 8, 4.9, 'views/home/images/hotels/fourseasons_bali_main.jpg'),
(4, N'Ayana Resort Bali', N'Hạng sang', 1800000, 15, 4.8, 'views/home/images/hotels/ayana_bali_main.jpg'),
(4, N'Komaneka at Bisma', N'Hạng sang', 1200000, 18, 4.7, 'views/home/images/hotels/komaneka_bisma_main.jpg'),

-- Boracay
(5, N'Shangri-La Boracay', N'Cao cấp', 2200000, 10, 4.9, 'views/home/images/hotels/shangrila_boracay_main.jpg'),
(5, N'Henann Lagoon Resort', N'Hạng sang', 900000, 35, 4.4, 'views/home/images/hotels/henann_boracay_main.jpg'),
(5, N'Crimson Resort & Spa Boracay', N'Hạng sang', 1500000, 12, 4.8, 'views/home/images/hotels/crimson_boracay_main.jpg'),
(5, N'The Lind Boracay', N'Cao cấp', 1300000, 20, 4.6, 'views/home/images/hotels/lind_boracay_main.jpg'),

-- Sihanoukville
(6, N'Independence Hotel Resort', N'Hạng sang', 1000000, 18, 4.3, 'views/home/images/hotels/independence_sihanoukville_main.jpg'),
(6, N'Sokha Beach Resort', N'Tiêu chuẩn', 700000, 40, 4.4, 'views/home/images/hotels/sokha_sihanoukville_main.jpg'),
(6, N'Knai Bang Chatt', N'Tiêu chuẩn', 1200000, 12, 4.7, 'views/home/images/hotels/knai_bangchatt_main.jpg'),
(6, N'Shinta Mani Resort', N'Cao cấp', 1100000, 15, 4.5, 'views/home/images/hotels/shintamani_main.jpg'),

-- Tioman
(7, N'Japamala Resort', N'Hạng sang', 1400000, 12, 4.7, 'views/home/images/hotels/japamala_tioman_main.jpg'),
(7, N'Berjaya Tioman Resort', N'Tiêu chuẩn', 800000, 25, 4.2, 'views/home/images/hotels/berjaya_tioman_main.jpg'),
(7, N'Tunamaya Beach & Spa Resort', N'Cao cấp', 900000, 20, 4.6, 'views/home/images/hotels/tunamaya_tioman_main.jpg'),
(7, N'Japamala Jungle Resort', N'Hạng sang', 1300000, 10, 4.8, 'views/home/images/hotels/japamala_jungle_main.jpg'),

-- Koh Samui
(8, N'Banyan Tree Samui', N'Hạng sang', 2500000, 15, 4.9, 'views/home/images/hotels/banyan_samui_main.jpg'),
(8, N'Chaweng Regent Beach Resort', N'Cao cấp', 1000000, 30, 4.5, 'views/home/images/hotels/chaweng_samui_main.jpg'),
(8, N'Four Seasons Koh Samui', N'Hạng sang', 3000000, 8, 4.9, 'views/home/images/hotels/fourseasons_ks_main.jpg'),
(8, N'Anantara Bophut', N'Tiêu chuẩn', 1100000, 25, 4.7, 'views/home/images/hotels/anantara_bophut_main.jpg'),

-- Nusa Penida
(9, N'Semabu Hills Hotel', N'Tiêu chuẩn', 900000, 20, 4.3, 'views/home/images/hotels/semabu_penida_main.jpg'),
(9, N'Maua Nusa Penida', N'Hạng sang', 1600000, 12, 4.6, 'views/home/images/hotels/maua_penida_main.jpg'),
(9, N'Adiwana Warnakali Resort', N'Hạng sang', 1300000, 15, 4.8, 'views/home/images/hotels/adiwana_penida_main.jpg'),
(9, N'Kusaha Luxury Villas', N'Hạng sang', 1900000, 10, 4.9, 'views/home/images/hotels/kusaha_penida_main.jpg'),

-- Palawan
(10, N'El Nido Resorts Miniloc Island', N'Hạng sang', 1800000, 15, 4.8, 'views/home/images/hotels/miniloc_palawan_main.jpg'),
(10, N'Astoria Palawan', N'Cao cấp', 1200000, 25, 4.5, 'views/home/images/hotels/astoria_palawan_main.jpg'),
(10, N'Amanpulo', N'Hạng sang', 5000000, 5, 5.0, 'views/home/images/hotels/amanpulo_main.jpg'),
(10, N'El Nido Cove Resort', N'Cao cấp', 1400000, 20, 4.7, 'views/home/images/hotels/el_nido_cove_main.jpg');


INSERT INTO Airlines (airlineName, iataCode, countryId, hotline, logoUrl)
VALUES
(N'Vietnam Airlines', 'VN142', 1, '1900 1100', 'views/home/images/flights/Vietnam_Airlines-Logo.jpg'),
(N'VietJet Air', 'VJ432', 1, '1900 1886', 'views/home/images/VietJet_Air-Logo.jpg	'),
(N'Bamboo Airways', 'QH210', 1, '1900 1166', 'images/airlines/bamboo_airways.png'),
(N'Thai Airways', 'TG021', 4, '+66 2356 1111', 'images/airlines/thai_airways.png'),
(N'Singapore Airlines', 'SQ984', 7, '+65 6223 8888', 'images/airlines/singapore_airlines.png'),
(N'Malaysia Airlines', 'MH147', 6, '+60 3 7843 3000', 'images/airlines/malaysia_airlines.png'),
(N'Garuda Indonesia', 'GA', 8, '+62 804 180 7807', 'images/airlines/garuda_indonesia.png');

--flights
INSERT INTO Flights (flightNumber, airlineId, departure, destination, destinationIslandId, departureTime, arrivalTime, price,  flightImageUrl)
VALUES ('VN142', 1, 'Ha Noi', 'Phu Quoc', 1, '08:30', '11:30', 2500000, 'views/home/images/flights/VietName_Airline-Airplane.png'),
       ('VJ432', 2, 'TP Ho Chi Minh', 'Phuket', 3, '09:15', '10:10', 1800000, 'views/home/images/flights/Vietjet_airline-Airplane.png');

-- vehicle insland
-- Phú Quốc (islandId = 1)
INSERT INTO IslandVehicles (islandId, vehicleType, modelName, pricePerDay, capacity, availability)
VALUES
-- Phú Quốc (islandId = 1)
(1, N'Xe tay ga', N'Honda Air Blade', 87500, 2, 10),
(1, N'Ô tô', N'Toyota Vios', 300000, 4, 5),
(1, N'Xe đạp', N'Giant Escape 3', 25000, 1, 15),

-- Langkawi (islandId = 2)
(2, N'Xe máy', N'Yamaha NVX 155', 75000, 2, 8),
(2, N'Ô tô', N'Perodua Myvi', 250000, 4, 4),
(2, N'Xe đạp', N'Trek FX 1', 30000, 1, 12),

-- Phuket (islandId = 3)
(3, N'Xe tay ga', N'Honda Click 125i', 80000, 2, 9),
(3, N'Ô tô', N'Toyota Yaris', 287500, 4, 6),
(3, N'Xe điện', N'Eco Scooter Phuket', 50000, 2, 7),

-- Bali (islandId = 4)
(4, N'Xe máy', N'Honda Beat', 75000, 2, 10),
(4, N'Ô tô', N'Suzuki Ertiga', 312500, 7, 4),
(4, N'Xe đạp', N'Polygon Heist 2', 27500, 1, 15),

-- Boracay (islandId = 5)
(5, N'Xe điện', N'Boracay E-Bike', 55000, 2, 10),
(5, N'Ô tô', N'Toyota Avanza', 295000, 6, 3),
(5, N'Xe tay ga', N'Yamaha Mio i125', 75000, 2, 8),

-- Sihanoukville (islandId = 6)
(6, N'Xe tay ga', N'Honda Scoopy', 77500, 2, 9),
(6, N'Ô tô', N'Toyota Camry', 325000, 5, 3),
(6, N'Xe đạp', N'Giant ATX 2', 25000, 1, 12),

-- Tioman (islandId = 7)
(7, N'Xe máy', N'Yamaha Ego Avantiz', 70000, 2, 7),
(7, N'Ô tô', N'Perodua Axia', 245000, 4, 3),
(7, N'Xe điện', N'Tioman Green Scooter', 50000, 2, 8),

-- Koh Samui (islandId = 8)
(8, N'Xe tay ga', N'Honda PCX 160', 87500, 2, 10),
(8, N'Ô tô', N'Toyota Fortuner', 375000, 7, 4),
(8, N'Xe đạp', N'Trek Marlin 5', 30000, 1, 12),

-- Nusa Penida (islandId = 9)
(9, N'Xe máy', N'Honda Scoopy-i', 75000, 2, 9),
(9, N'Ô tô', N'Toyota Innova', 320000, 7, 3),
(9, N'Xe điện', N'Nusa E-Ride', 55000, 2, 6),

-- Palawan (islandId = 10)
(10, N'Xe tay ga', N'Yamaha Aerox 155', 85000, 2, 10),
(10, N'Ô tô', N'Mitsubishi Xpander', 337500, 7, 5),
(10, N'Xe đạp', N'Palawan Mountain Bike', 25000, 1, 14);
INSERT INTO CustomTours (islandId, tourName, startDate, endDate, totalPrice)
OUTPUT INSERTED.customTourId
VALUES (1, 'Test Tour', '2025-11-10', '2025-11-12', 5000000);


CREATE TABLE Places (
    placeId INT IDENTITY(1,1) PRIMARY KEY,   -- Khóa chính tự tăng
    islandId INT NOT NULL,                   -- Mã đảo (liên kết đến bảng Islands)
    placeName NVARCHAR(255) NOT NULL,        -- Tên địa điểm
    location NVARCHAR(255),                  -- Địa chỉ / vị trí
    description NVARCHAR(MAX),               -- Mô tả chi tiết
    hasTicket BIT NOT NULL,                  -- Có vé hay không (true/false)
    ticketPrice INT NULL,                    -- Giá vé (nếu có)
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);

select * from Places



INSERT INTO Places (islandId, placeName, location, description, hasTicket, ticketPrice)
VALUES
-- === PHÚ QUỐC ===
(1, N'Suối Tranh', N'Xã Dương Tơ, TP. Phú Quốc', N'Thác nước tự nhiên giữa rừng, thích hợp dã ngoại và tắm suối.', 1, 30000),
(1, N'Bãi Sao', N'Xã An Thới, TP. Phú Quốc', N'Bãi biển nổi tiếng với cát trắng mịn và nước biển trong xanh.', 0, NULL),
(1, N'Nhà tù Phú Quốc', N'350 Đường Nguyễn Văn Cừ, TT. An Thới', N'Di tích lịch sử ghi dấu thời kỳ chiến tranh Việt Nam.', 1, 20000),

-- === LANGKAWI ===
(2, N'Langkawi Sky Bridge', N'Gunung Mat Cincang, Kedah', N'Cầu treo nổi tiếng với tầm nhìn toàn cảnh tuyệt đẹp.', 1, 40000),
(2, N'Pantai Cenang', N'Mukim Kedawang, Langkawi', N'Bãi biển sôi động với nhiều quán bar và hoạt động thể thao nước.', 0, NULL),
(2, N'Langkawi Cable Car', N'Oriental Village, Burau Bay', N'Cáp treo đưa du khách lên đỉnh núi ngắm cảnh đảo.', 1, 45000),

-- === PHUKET ===
(3, N'Patong Beach', N'Patong, Kathu District, Phuket', N'Bãi biển nổi tiếng nhất Phuket, trung tâm giải trí về đêm.', 0, NULL),
(3, N'Big Buddha', N'Karon, Mueang Phuket District', N'Tượng Phật lớn bằng đá cẩm thạch trắng, biểu tượng của Phuket.', 0, NULL),
(3, N'Phuket Old Town', N'Thalang Rd, Talat Yai, Mueang Phuket', N'Khu phố cổ với kiến trúc Bồ Đào Nha độc đáo và quán cà phê cổ điển.', 0, NULL),

-- === BALI ===
(4, N'Tanah Lot Temple', N'Tabanan Regency, Bali', N'Ngôi đền nổi trên biển, điểm du lịch tâm linh nổi tiếng của Bali.', 1, 50000),
(4, N'Ubud Monkey Forest', N'Jl. Monkey Forest, Ubud, Gianyar', N'Khu rừng linh thiêng với hàng trăm con khỉ tự nhiên.', 1, 60000),
(4, N'Tegallalang Rice Terrace', N'Tegallalang, Gianyar, Bali', N'Ruộng bậc thang xanh mướt nổi tiếng với cảnh quan ngoạn mục.', 0, NULL),

-- === BORACAY ===
(5, N'White Beach', N'Station 2, Boracay Island, Aklan', N'Bãi biển chính của Boracay, nổi tiếng với cát trắng mịn và nước trong.', 0, NULL),
(5, N'Willy’s Rock', N'Station 1, Balabag, Boracay', N'Hòn đá biểu tượng của đảo Boracay với tượng Đức Mẹ Maria.', 0, NULL),
(5, N'Puka Shell Beach', N'Yapak, Boracay Island', N'Bãi biển yên tĩnh, nổi tiếng với vỏ sò tự nhiên.', 0, NULL),

-- === SIHANOUKVILLE ===
(6, N'Otres Beach', N'Sangkat 4, Sihanoukville', N'Bãi biển yên bình với quán bar nhỏ và hoàng hôn tuyệt đẹp.', 0, NULL),
(6, N'Ream National Park', N'Ream Commune, Preah Sihanouk', N'Công viên quốc gia với rừng ngập mặn và động vật hoang dã.', 1, 25000),
(6, N'Koh Rong Island', N'Koh Rong, Sihanoukville Province', N'Hòn đảo nổi tiếng với biển xanh và cát trắng tinh khiết.', 0, NULL),

-- === TIOMAN ===
(7, N'Juara Beach', N'Juara Village, Tioman Island', N'Bãi biển yên tĩnh, lý tưởng cho bơi lội và lặn ngắm san hô.', 0, NULL),
(7, N'Asah Waterfall', N'Mukim Tioman, Pahang', N'Thác nước tự nhiên giữa rừng, điểm đến yêu thích của du khách.', 0, NULL),
(7, N'Tekek Village', N'Kampung Tekek, Tioman Island', N'Ngôi làng lớn nhất trên đảo với cửa hàng và nhà hàng địa phương.', 0, NULL),

-- === KOH SAMUI ===
(8, N'Chaweng Beach', N'Bo Put, Koh Samui District', N'Bãi biển dài với khu nghỉ dưỡng và hoạt động giải trí sôi động.', 0, NULL),
(8, N'Big Buddha Temple', N'Bang Rak, Bophut, Koh Samui', N'Tượng Phật lớn mạ vàng cao 12m, biểu tượng của Koh Samui.', 0, NULL),
(8, N'Na Muang Waterfall', N'Maret, Koh Samui', N'Thác nước đôi hùng vĩ giữa thiên nhiên xanh mát.', 0, NULL),

-- === NUSA PENIDA ===
(9, N'Kelingking Beach', N'Bunga Mekar, Nusa Penida', N'Bãi biển nổi tiếng với vách đá hình khủng long.', 0, NULL),
(9, N'Angel’s Billabong', N'Sompang Village, Nusa Penida', N'Hồ bơi tự nhiên tuyệt đẹp giữa đá vôi ven biển.', 0, NULL),
(9, N'Broken Beach', N'Sompang Village, Nusa Penida', N'Vòm đá tự nhiên tạo thành khung cảnh biển độc đáo.', 0, NULL),

-- === PALAWAN ===
(10, N'Puerto Princesa Underground River', N'Sabang, Puerto Princesa', N'Dòng sông ngầm tự nhiên dài 8km – kỳ quan thiên nhiên thế giới.', 1, 100000),
(10, N'El Nido', N'Bắc Palawan, Philippines', N'Thiên đường đảo nhỏ với nước xanh biếc và vách đá vôi dựng đứng.', 0, NULL),
(10, N'Coron Island', N'Busuanga, Palawan', N'Nổi tiếng với các hồ trong xanh và xác tàu đắm khi lặn biển.', 0, NULL);

select * from CustomTours
/*
delete from Flights
DBCC CHECKIDENT ('Flights', RESEED, 0);
*/
-- flights

INSERT INTO Flights (flightNumber, airlineId, departure, destination, destinationIslandId, 
                     departureTime, arrivalTime, returnDepartureTime, returnArrivalTime, 
                     basePrice, ticketAvailable, flightType, flightClass, destinationImageUrl)
VALUES
--  Từ Hà Nội đến Phú Quốc
('VN101', 1, N'Hà Nội', N'Phú Quốc', 1, '07:30', '09:45', '16:00', '18:15', 2200000, 50, N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/phuquoc.jpg'),
('VJ301', 2, N'Hà Nội', N'Phú Quốc', 1, '12:00', '14:10', NULL, NULL, 1100000, 50, N'Một chiều', N'Thương gia', 'views/home/images/islands/phuquoc.jpg'),
('QH210', 3, N'Hà Nội', N'Phú Quốc', 1, '08:40', '10:15', NULL, NULL, 1530000, 50, N'Một chiều', N'Thương gia', 'views/home/images/islands/phuquoc.jpg'),
('VN101', 1, N'TP.HCM', N'Phú Quốc', 1, '09:00', '10:35', NULL, NULL, 1322000, 50, N'Một chiều', N'Phổ thông', 'views/home/images/islands/phuquoc.jpg'),
('QH210', 3, N'Hà Nội', N'Phú Quốc', 1, '07:50', '10:00', '21:30', '00:15', 3530000, 50,N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/phuquoc.jpg'),
('VJ301', 2, N'TP.HCM', N'Phú Quốc', 1, '08:25', '9:55', '20:45', '21:50', 3530000, 50,N'Khứ hồi', N'Thương gia', 'views/home/images/islands/phuquoc.jpg'),

--  Từ TP.HCM đến Langkawi
('VN205', 1, N'TP.HCM', N'Langkawi', 2, '08:00', '10:30', '17:00', '19:30', 3200000,50, N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/langkawi.jpg'),
('QH505', 3, N'TP.HCM', N'Langkawi', 2, '09:15', '11:45', NULL, NULL, 1800000,50, N'Một chiều', N'Thương gia', 'views/home/images/islands/langkawi.jpg'),

--  Từ Hà Nội đến Phuket
('VN307', 1, N'Hà Nội', N'Phuket', 3, '06:45', '09:00', '15:30', '17:45', 3500000,50, N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/phuket.jpg'),

--  Từ TP.HCM đến Bali
('VJ407', 2, N'TP.HCM', N'Bali', 4, '08:15', '12:00', '18:00', '21:45', 4000000,50, N'Khứ hồi', N'Thương gia', 'views/home/images/islands/bali.jpg'),
('QH509', 3, N'TP.HCM', N'Bali', 4, '13:30', '17:15', NULL, NULL, 2100000,50, N'Một chiều', N'Phổ thông', 'views/home/images/islands/bali.jpg'),

--  Từ Hà Nội đến Boracay
('VN321', 1, N'Hà Nội', N'Boracay', 5, '09:00', '12:15', '19:00', '22:15', 3700000, 50,N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/boracay.jpg'),

--  Từ TP.HCM đến Sihanoukville
('VJ215', 2, N'TP.HCM', N'Sihanoukville', 6, '10:00', '11:30', '17:45', '19:15', 2500000,50, N'Khứ hồi', N'Thương gia', 'views/home/images/islands/sihanoukville.jpg'),

--  Từ Hà Nội đến Tioman
('VN333', 1, N'Hà Nội', N'Tioman', 7, '07:00', '10:30', '15:00', '18:30', 3200000,50, N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/tioman.jpg'),

--  Từ TP.HCM đến Koh Samui
('QH601', 3, N'TP.HCM', N'Koh Samui', 8, '08:00', '10:45', NULL, NULL, 3300000,50, N'Một chiều', N'Phổ thông', 'views/home/images/islands/kohsamui.jpg'),

--  Từ Hà Nội đến Nusa Penida
('VN901', 1, N'Hà Nội', N'Nusa Penida', 9, '06:30', '10:15', '17:00', '20:45', 4100000,50, N'Khứ hồi', N'Thương gia', 'views/home/images/islands/nusapenida.jpg'),

--  Từ TP.HCM đến Palawan
('VJ701', 2, N'TP.HCM', N'Palawan', 10, '09:00', '12:30', '18:00', '21:30', 3900000,50, N'Khứ hồi', N'Phổ thông', 'views/home/images/islands/palawan.jpg');

-- payments



INSERT INTO Payments (bookingId, amount, method, status)
VALUES
(1, 613.400, 'VNPAY', 'SUCCESS'),
(2, 421.210, 'PAYPAL', 'PENDING');

-- Recommendations
INSERT INTO Recommendations (userId, islandId, score)
VALUES
(4, 1, 4.50),
(3, 2, 3.95);

-- reviews

INSERT INTO Reviews (userId, serviceType, refId, rating, comment)
VALUES
(4, 'HOTEL', 1, 5, 'Amazing stay!'),
(4, 'FLIGHT', 2, 4, 'Good flight, comfortable seating.');

-- favorite

INSERT INTO Favorites (userId, serviceType, refId)
VALUES
(4, 'HOTEL', 1),
(4, 'FLIGHT', 2);


-- promotions

INSERT INTO Promotions (code, description, discountType, discountValue, startDate, endDate)
VALUES
('NEWYEAR2025', 'New Year 2025 Discount', 'PERCENT', 10.000, '2025-01-01', '2025-01-31'),
('HOLIDAY50', 'Holiday Discount', 'AMOUNT', 50.000, '2025-12-20', '2025-12-31');

-- user promotions
INSERT INTO UserPromotions (userId, promoId)
VALUES
(4, 1),
(4, 2);



/* test loyaltyPoints and membershipLevel

SELECT u.userId, u.fullName, cp.loyaltyPoints, cp.membershipLevel
FROM Users u
JOIN CustomerProfiles cp ON u.userId = cp.userId;

INSERT INTO Bookings (profileId ,customerId, price, status)
VALUES (2,3, 5000000, 'PENDING');

INSERT INTO BookingDetails (bookingId, tourId, adultQuantity, childQuantity, departureDate, unitPrice)
VALUES (3, 2, 2, 1, '2025-10-15', 2000000);


 

 INSERT INTO CustomerProfiles (userId, loyaltyPoints, membershipLevel)
VALUES (3, 235, 'BRONZE');

UPDATE Bookings
SET status = 'COMPLETED'
WHERE bookingId = 1;


*/
--activity


INSERT INTO TourActivities (itineraryId, activityOrder, activityTitle, description) VALUES
(1, 1, N'Khởi hành từ Hà Nội', N'Bay từ Hà Nội đến Phú Quốc, nhận phòng khách sạn.'),
(2, 1, N'Tham quan Vinpearl Safari', N'Khám phá vườn thú bán hoang dã lớn nhất Việt Nam.'),
(2, 2, N'Tắm biển Bãi Sao', N'Tận hưởng bãi biển đẹp nhất Phú Quốc.'),
(2, 3, N'Chợ đêm Dinh Cậu', N'Thưởng thức hải sản và mua sắm.'),
(3, 1, N'Trả phòng', N'Trả phòng khách sạn, khởi hành về Hà Nội.'),

-- Tour 2: Phú Quốc 4N3Đ
(4, 1, N'Khởi hành từ Hà Nội', N'Đến Phú Quốc, nhận phòng khách sạn.'),
(5, 1, N'Lặn ngắm san hô', N'Trải nghiệm lặn biển tại Hòn Móng Tay.'),
(5, 2, N'Tắm biển', N'Tự do nghỉ ngơi tại resort.'),
(6, 1, N'Câu cá đêm', N'Thử thách câu cá trên biển.'),
(6, 2, N'BBQ hải sản', N'Thưởng thức tiệc BBQ trên bãi biển.'),
(7, 1, N'Trả phòng', N'Về Hà Nội.'),

-- Tour 3: Phú Quốc 2N1Đ
(8, 1, N'Khởi hành', N'Bay từ Hà Nội đến Phú Quốc.'),
(8, 2, N'Thăm làng chài Hàm Ninh', N'Tìm hiểu đời sống ngư dân và thưởng thức hải sản.'),
(9, 1, N'Trả phòng', N'Trở về Hà Nội.'),

-- Tour 4: Langkawi 4N3Đ
(10, 1, N'Khởi hành', N'Bay từ Hà Nội đến Langkawi.'),
(11, 1, N'Tham quan SkyBridge', N'Chiêm ngưỡng cây cầu treo nổi tiếng.'),
(12, 1, N'Tắm biển Pantai Cenang', N'Tắm biển và tham gia trò chơi nước.'),
(12, 2, N'Shopping Duty-free', N'Mua sắm tại các cửa hàng miễn thuế.'),
(13, 1, N'Trở về Hà Nội', N'Kết thúc tour.'),

-- Tour 5: Phuket 4N3Đ
(14, 1, N'Đến Phuket', N'Đón khách tại sân bay và nhận phòng khách sạn.'),
(15, 1, N'Tham quan đảo Phi Phi', N'Tham gia tour du thuyền thăm đảo Phi Phi.'),
(16, 1, N'Phố cổ Phuket', N'Dạo chơi và tham quan kiến trúc cổ.'),
(16, 2, N'Simon Cabaret Show', N'Thưởng thức show diễn nổi tiếng tại Phuket.'),
(17, 1, N'Trả khách', N'Kết thúc hành trình.'),

-- Tour 6: Bali
(18, 1, N'Xuất phát từ Hà Nội', N'Tập trung tại sân bay Nội Bài, làm thủ tục khởi hành.'),
(18, 2, N'Đến Phuket', N'Hướng dẫn viên đón đoàn, nhận phòng khách sạn và nghỉ ngơi.'),
(19, 1, N'Du thuyền ra đảo Phi Phi', N'Tham quan vịnh Maya nổi tiếng.'),
(19, 2, N'Lặn biển ngắm san hô', N'Trải nghiệm snorkeling tại vịnh Loh Samah.'),
(19, 3, N'Tham quan Viking Cave', N'Khám phá hang động nổi tiếng.'),
(20, 1, N'Du thuyền vịnh Phang Nga', N'Tham quan đảo James Bond nổi tiếng.'),
(20, 2, N'Chèo kayak hang động', N'Trải nghiệm chèo kayak tại hòn đảo đá vôi.'),
(20, 3, N'Dùng bữa trưa trên du thuyền', N'Thưởng thức hải sản địa phương.'),
(21, 1, N'Tham quan chùa Wat Chalong', N'Ngôi chùa lớn nhất ở Phuket.'),
(21, 2, N'Tượng Phật Lớn Big Buddha', N'Chiêm ngưỡng bức tượng Phật cao 45m.'),
(21, 3, N'Tắm biển Patong', N'Thư giãn và vui chơi trên bãi biển Patong.'),
(22, 1, N'Ra sân bay', N'Làm thủ tục bay về Hà Nội, kết thúc tour.');


--Test trigger notification
/*

INSERT INTO Bookings (profileId, customerId) 
VALUES (1, 5);
select * from dbo.CustomerProfiles

INSERT INTO BookingDetails 
(bookingId, tourId, hotelId, flightId, vehicleId, adultQuantity, childQuantity, departureDate, unitPrice)
VALUES
(2, 1, NULL, NULL, NULL, 2, 1, '2025-10-10', 500);

INSERT INTO BookingDetails 
(bookingId, tourId, hotelId, flightId, vehicleId, adultQuantity, childQuantity, departureDate, unitPrice)
VALUES
(3, 3, NULL, NULL, NULL, 3, 1, '2025-10-10', 700);


SELECT * FROM Notifications
WHERE userId = 5;


INSERT INTO Payments (bookingId, amount, method, status)
VALUES (3, 1000, 'VNPAY', 'PENDING');

select * from dbo.Payments

UPDATE Payments
SET status = 'SUCCESS'
WHERE paymentId = 1;  

*/

select *from CustomTours

DBCC CHECKIDENT ('CustomTours', RESEED, 0)


-------------------------------------------------------------------------------------------------------

