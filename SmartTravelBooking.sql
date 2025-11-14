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


CREATE TABLE Roles (
    roleId INT IDENTITY(1,1) PRIMARY KEY,
    roleName NVARCHAR(50) UNIQUE NOT NULL
);
GO


-- trigger tạo profile sau khi dang ky thanh cong
CREATE OR ALTER TRIGGER trg_AfterInsertUser
ON Users
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Tạo CustomerProfile cho mỗi user mới
    INSERT INTO CustomerProfiles (userId, fullName)
    SELECT userId, fullName
    FROM inserted;
END;
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
go

-- Cộng điểm khi trạng thái chuyển sang COMPLETED và  cập nhật cấp độ thành viên tự động
CREATE OR ALTER TRIGGER trg_AddLoyaltyPoints_AfterBookingCompleted
ON Bookings
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Tạo bảng tạm để lưu điểm cần cộng cho mỗi khách hàng
    DECLARE @PointsToAdd TABLE (
        customerId INT PRIMARY KEY,
        points INT
    );

    -- Tính điểm 0,5% của totalPrice cho tất cả booking vừa COMPLETED
    INSERT INTO @PointsToAdd (customerId, points)
    SELECT 
        i.customerId,
        CAST(SUM(b.totalPrice * 0.005) AS INT) AS points
    FROM inserted i
    INNER JOIN deleted d ON i.bookingId = d.bookingId
    INNER JOIN Bookings b ON i.bookingId = b.bookingId
    WHERE i.status = 'COMPLETED' AND d.status <> 'COMPLETED'
    GROUP BY i.customerId;

    -- Cộng điểm vào CustomerProfiles
    UPDATE cp
    SET cp.loyaltyPoints = cp.loyaltyPoints + p.points
    FROM CustomerProfiles cp
    INNER JOIN @PointsToAdd p ON cp.userId = p.customerId;

    -- Cập nhật cấp độ thành viên dựa trên loyaltyPoints mới
    UPDATE cp
    SET cp.membershipLevel = 
        CASE
            WHEN cp.loyaltyPoints >= 10000000 THEN 'PLATINUM'
            WHEN cp.loyaltyPoints >= 5000000 THEN 'GOLD'
            WHEN cp.loyaltyPoints >= 800000 THEN 'SILVER'
            ELSE 'BRONZE'
        END
    FROM CustomerProfiles cp
    WHERE cp.userId IN (SELECT customerId FROM @PointsToAdd);
END;
GO

-- Contact of customer

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

CREATE OR ALTER TRIGGER TR_ManagePrimaryEmail
ON CustomerContacts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(isPrimary)
    BEGIN
        -- 1️ Reset tất cả email về 0 cho userId tương ứng
        UPDATE CustomerContacts
        SET isPrimary = 0
        WHERE userId IN (SELECT userId FROM inserted)
          AND contactType = 'EMAIL';

        -- 2️ Set isPrimary = 1 cho contactId vừa chọn
        UPDATE CustomerContacts
        SET isPrimary = 1
        WHERE contactId IN (SELECT contactId FROM inserted WHERE isPrimary = 1 AND contactType = 'EMAIL');

        -- 3️ Đồng bộ email chính sang bảng Users
        UPDATE u
        SET u.email = i.contactValue
        FROM Users u
        JOIN inserted i ON u.userId = i.userId
        WHERE i.contactType = 'EMAIL' AND i.isPrimary = 1;
    END
END;
GO

-- trigger update fullName đồng bộ với fullName user

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
	approvalStatus VARCHAR(20) DEFAULT 'PENDING' CHECK (approvalStatus IN ('PENDING','APPROVED','REJECTED')),
    FOREIGN KEY (countryId) REFERENCES Countries(countryId) ON DELETE CASCADE
);

go

CREATE TABLE Tours (
    tourId INT PRIMARY KEY IDENTITY(1,1),
    islandId INT NOT NULL,
    tourName NVARCHAR(255) UNIQUE NOT NULL,
    description NVARCHAR(MAX),
    price INT CHECK(price >= 0),
    availableQuantity INT CHECK (availableQuantity >= 0) DEFAULT 0,
    approvalStatus VARCHAR(20) DEFAULT 'PENDING' CHECK (approvalStatus IN ('PENDING','APPROVED','REJECTED')),
    tourImageUrl NVARCHAR(500),
	rejectionReason NVARCHAR(255),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);
go

CREATE TABLE TourServices (
    tourServiceId INT IDENTITY(1,1) PRIMARY KEY,
    tourId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN (N'Khách sạn', N'Chuyến bay', N'Phương tiện', N'Địa điểm nổi bật')),
    serviceId INT NOT NULL,
    FOREIGN KEY (tourId) REFERENCES Tours(tourId) ON DELETE CASCADE
);
GO


CREATE TABLE TourItinerary (
    itineraryId INT PRIMARY KEY IDENTITY(1,1),
    tourId INT NOT NULL,
    dayNumber INT NOT NULL,         -- Ngày 1, Ngày 2, ...
    title NVARCHAR(255) NOT NULL,   -- Ví dụ: "Ngày 1: HCM → Singapore"
    FOREIGN KEY (tourId) REFERENCES Tours(tourId) ON DELETE CASCADE,
    CONSTRAINT UQ_TourItinerary_Tour_Day UNIQUE (tourId, dayNumber)
);

go
CREATE TABLE TourActivities (
    activityId INT IDENTITY(1,1) PRIMARY KEY,
    itineraryId INT NOT NULL,
    activityOrder INT NOT NULL,           -- Thứ tự hiển thị
    activityTitle NVARCHAR(255), -- Ví dụ: "Wonder Park"
    description NVARCHAR(MAX),   -- Mô tả chi tiết
    FOREIGN KEY (itineraryId) REFERENCES TourItinerary(itineraryId),
	CONSTRAINT UQ_TourActivities_Tour_Day UNIQUE (itineraryId, activityOrder)
);
go

CREATE TABLE CustomTours (
    customTourId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    tourName NVARCHAR(150) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    totalPrice INT CHECK (totalPrice >= 0),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);
go


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
	totalRooms INT DEFAULT 0 CHECK (totalRooms >= 0),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);


-- bảng Arlines : các hãng bay
CREATE TABLE Airlines (
    airlineId INT IDENTITY(1,1) PRIMARY KEY,
    airlineName NVARCHAR(100) NOT NULL,   -- Tên hãng hàng không (Vietnam Airlines, Vietjet Air…)
    iataCode VARCHAR(5),                  -- Mã quốc tế (VN, VJ…)
	hotline VARCHAR(20),                 -- Đường dây nóng
    logoUrl VARCHAR(255)                  -- Link logo hãng
);
go

-- bảng flights 

CREATE TABLE Flights (
    flightId INT IDENTITY(1,1) PRIMARY KEY,
    flightNumber VARCHAR(20) NOT NULL,           
    airlineId INT NOT NULL,                      
    departure NVARCHAR(100) NOT NULL,            
    destination NVARCHAR(100) NOT NULL,          
    destinationIslandId INT NULL,                
    basePrice INT NOT NULL,                      
    ticketAvailable INT NOT NULL,
    flightType NVARCHAR(10) NOT NULL
        CONSTRAINT CK_Flights_flightType CHECK (flightType IN (N'Một chiều', N'Khứ hồi')),
    flightClass NVARCHAR(50) NOT NULL
        CONSTRAINT CK_Flights_flightClass CHECK (flightClass IN (N'Phổ thông', N'Thương gia', N'Hạng nhất')),
    destinationImageUrl NVARCHAR(255) NULL,
    FOREIGN KEY (airlineId) REFERENCES Airlines(airlineId),
    FOREIGN KEY (destinationIslandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);
GO


CREATE TABLE FlightSchedules (
    scheduleId INT IDENTITY(1,1) PRIMARY KEY,
    flightId INT NOT NULL FOREIGN KEY REFERENCES Flights(flightId),
    departureAirport NVARCHAR(100) NOT NULL, -- sân bay khởi hành
    arrivalAirport NVARCHAR(100) NOT NULL,   -- sân bay đến
    departureTime TIME NOT NULL,             -- giờ khởi hành
    arrivalTime TIME NOT NULL,               -- giờ đến
    returnDepartureTime TIME NULL,           -- giờ khởi hành chiều về
    returnArrivalTime TIME NULL,             -- giờ hạ cánh chiều về
    transitAirport NVARCHAR(100) NULL,       -- sân bay trung chuyển (nếu có)
    transitDuration NVARCHAR(50) NULL,       -- thời gian dừng (VD: '7h30', '45 phút')
    notes NVARCHAR(255) NULL                 -- ghi chú
);
select * from FlightSchedules



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
	vehicleImageUrl VARCHAR(255),
	totalQuantity INT DEFAULT 0 CHECK (totalQuantity >= 0),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);


go

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

-- Bảng bookings
	CREATE TABLE Bookings (
		bookingId INT IDENTITY(1,1) PRIMARY KEY,
		customerId INT NOT NULL,
		customTourId INT NULL,
		tourId INT NULL,
		departureDate DATE NOT NULL,
		endDate DATE,
		adultQuantity INT NOT NULL,
		childQuantity INT NOT NULL,
		status NVARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'COMPLETED')) DEFAULT 'PENDING',
		totalPrice INT,
		bookingDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (customerId) REFERENCES Users(userId),
		FOREIGN KEY (customTourId) REFERENCES CustomTours(customTourId),
		FOREIGN KEY (tourId) REFERENCES Tours(tourId)
	);
	go


-- Bảng Payments
  


CREATE TABLE Payments (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    amount BIGINT,
    status VARCHAR(20) CHECK (status IN ('SUCCESS','FAILED','PENDING')) DEFAULT 'PENDING',
    FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId) ON DELETE CASCADE
);
go

CREATE TABLE HistoryBooking (
    historyId INT IDENTITY(1,1) PRIMARY KEY,
    paymentId INT NOT NULL,
    accountUserId INT NULL,
    customerName NVARCHAR(100) NOT NULL,
    customerEmail NVARCHAR(100) NOT NULL,
    customerPhone NVARCHAR(20) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    tourStatus NVARCHAR(20) NOT NULL CHECK (tourStatus IN ('COMPLETED', 'INCOMPLETE')) DEFAULT 'INCOMPLETE',
    FOREIGN KEY (paymentId) REFERENCES Payments(paymentId) ON DELETE CASCADE,
    -- Cho phép null nếu user bị xóa
    FOREIGN KEY (accountUserId) REFERENCES Users(userId) ON DELETE SET NULL
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

-- Notification 

CREATE TABLE Notifications (
    notificationId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    title NVARCHAR(100) NOT NULL,
    message NVARCHAR(500) NOT NULL,
    type VARCHAR(30) CHECK (type IN ('BOOKING','SYSTEM','TOUR')) DEFAULT 'SYSTEM',
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO


-- trigger booking
CREATE OR ALTER TRIGGER trg_Booking_Insert_Notification
ON Bookings
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notifications (userId, title, message, type)
    SELECT
        i.customerId,
        N'🎉 Đặt chỗ thành công!',
        CASE
            WHEN i.tourId IS NOT NULL THEN
                N'🎫 Bạn vừa đặt tour trọn gói: "' + ISNULL(t.tourName, N'') + 
                N'" ✈️ Khởi hành ngày ' + CONVERT(NVARCHAR(10), i.departureDate, 120) + N'. Chúc bạn có chuyến đi tuyệt vời!'
           
            WHEN i.customTourId IS NOT NULL THEN
                N'🧳 Bạn vừa đặt tour riêng: "' + ISNULL(ct.tourName, N'') + 
                N'" ✈️ Khởi hành ngày ' + CONVERT(NVARCHAR(10), i.departureDate, 120) +
                N', kết thúc ngày ' + CONVERT(NVARCHAR(10), ISNULL(i.endDate, i.departureDate), 120) + 
                N'. Chúc bạn có chuyến đi đáng nhớ!'
           
            ELSE
                N'🎉 Bạn vừa tạo đặt chỗ thành công! Cảm ơn bạn đã tin tưởng dịch vụ của chúng tôi ❤️'
        END,
        'BOOKING'
    FROM inserted i
    LEFT JOIN Tours t ON i.tourId = t.tourId
    LEFT JOIN CustomTours ct ON i.customTourId = ct.customTourId;
END;
GO

--- triger khi thông báo customer những tour mới "chạy khi cập nhật trạng thái Tours"

CREATE TRIGGER trg_Tour_Approved_Notification
ON Tours
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.tourId = d.tourId
        WHERE i.approvalStatus = 'APPROVED' 
          AND d.approvalStatus <> 'APPROVED'
    )
        RETURN;

    BEGIN TRY
        INSERT INTO Notifications (userId, title, message, type, createdAt)
        SELECT
            u.userId,
            N'Tour mới hấp dẫn!',
             N'🎉 ' + N'Vừa có gói tour mới vô cùng thú vị tại ' + ISNULL(isl.islandName, N'Đảo') +
            N'! Tên: "' + i.tourName +
            N'", Giá chỉ với: ' + 
            REPLACE(FORMAT(ISNULL(i.price, 0), 'N0'), ',', '.') + 
            N' VND',
            'TOUR',
            GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.tourId = d.tourId
        INNER JOIN Islands isl ON i.islandId = isl.islandId
        CROSS JOIN Users u
        WHERE i.approvalStatus = 'APPROVED'
          AND d.approvalStatus <> 'APPROVED'
          AND u.roleId = 3;
    END TRY
    BEGIN CATCH
        PRINT 'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


---------------- triger khi thông báo customer về system "sau khi đổi mật khẩu "chạy khi cập nhật trạng thái Users"--------------------

CREATE TRIGGER trg_User_Update_Password_Notification
ON Users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
	    
    -- Chỉ tạo notification nếu mật khẩu thực sự thay đổi
    INSERT INTO Notifications (userId, title, message, type)
    SELECT 
        i.userId,
        N'Cập nhật mật khẩu thành công',
        N'Mật khẩu của bạn vừa được thay đổi. Nếu không phải bạn, vui lòng liên hệ bộ phận hỗ trợ ngay.',
        'SYSTEM'
    FROM inserted i
    INNER JOIN deleted d ON i.userId = d.userId
    WHERE i.password <> d.password;
END;
GO


-- ----favourite services
CREATE TABLE Favorites (
    favoriteId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN ('HOTEL','FLIGHT','CAR','TOUR')),
    refId INT NOT NULL,  -- id dịch vụ được lưu
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
go

CREATE TABLE Places (
    placeId INT IDENTITY(1,1) PRIMARY KEY,   -- Khóa chính tự tăng
    islandId INT NOT NULL,                   -- Mã đảo (liên kết đến bảng Islands)
    placeName NVARCHAR(255) NOT NULL,        -- Tên địa điểm
    location NVARCHAR(255),                  -- Địa chỉ / vị trí
    description NVARCHAR(MAX),               -- Mô tả chi tiết
    hasTicket BIT NOT NULL,                  -- Có vé hay không (true/false)
    ticketPrice INT NULL,                    -- Giá vé (nếu có)
	placeImageUrl VARCHAR(255),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);

go


-- TourServices table to manage services in tours
CREATE TABLE TourServices (
    tourServiceId INT IDENTITY(1,1) PRIMARY KEY,
    tourId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN ('HOTEL','FLIGHT','VEHICLE','PLACE')) NOT NULL,
    serviceId INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (tourId) REFERENCES Tours(tourId) ON DELETE CASCADE
);
GO

-------------------------------------- Log systen
