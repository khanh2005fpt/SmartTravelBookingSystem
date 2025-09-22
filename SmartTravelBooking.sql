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
    fullName VARCHAR(100),
    phone NVARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('CUSTOMER','ADMIN','SERVICE PROVIDER','BOOKING MANAGER')) DEFAULT 'CUSTOMER',
    createdAt DATETIME DEFAULT GETDATE()
);
go



-- Bảng UserProfiles
CREATE TABLE UserProfiles (
    profileId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,              
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
go 

-- Bảng Islands
CREATE TABLE Islands (
    islandId INT IDENTITY(1,1) PRIMARY KEY,
    islandName NVARCHAR(100) NOT NULL,
    country NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    bestSeason NVARCHAR(50),
    activities NVARCHAR(255),
    imageUrl NVARCHAR(255)
);


select * from Islands where 1=1 and islandName like 'Phu Quoc'
go

-- Bảng Hotels
CREATE TABLE Hotels (
    hotelId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    hotelName VARCHAR(100) NOT NULL,
    roomType VARCHAR(50) NOT NULL
        CHECK (roomType IN ('Standard', 'Deluxe', 'Suite', 'Family')),
    pricePerNight INT,
    roomsAvailable INT,
    rating DECIMAL(3,1),
    hotelImageUrl VARCHAR(255), -- đường dẫn ảnh khách sạn
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);





go
select * from hotels a join islands b on a.islandId = b.islandId

-- Bảng VehiclesToIsland (phương tiện đến đảo)
CREATE TABLE VehiclesToIsland (
    vehicleId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    vehicleType NVARCHAR(50) CHECK (vehicleType IN ('CAR','BOAT')),
    providerName NVARCHAR(100),
    pricePerDay DECIMAL(10,3),
    capacity INT,
    description NVARCHAR(255),
    FOREIGN KEY (islandId) REFERENCES Islands(islandId)
);
go



-- bảng Arlines : các hãng bay
CREATE TABLE Airlines (
    airlineId INT IDENTITY(1,1) PRIMARY KEY,
    airlineName NVARCHAR(100) NOT NULL,   -- Tên hãng hàng không (Vietnam Airlines, Vietjet Air…)
    iataCode VARCHAR(5),                  -- Mã quốc tế (VN, VJ…)
    country NVARCHAR(50),                 -- Quốc gia
	hotline VARCHAR(20),                 -- Đường dây nóng
    logoUrl VARCHAR(255)                  -- Link logo hãng
);
go

-- bảng flights 
CREATE TABLE Flights (
    flightId INT IDENTITY(1,1) PRIMARY KEY,
    flightNumber VARCHAR(20) NOT NULL,       -- Mã chuyến bay (VD: VN123)
    airlineId INT NOT NULL,                  -- FK đến Airlines
    departure VARCHAR(100) NOT NULL,         -- Xuất phát (thành phố hoặc đảo)
    destination VARCHAR(100) NOT NULL,       -- Điểm đến (thành phố hoặc đảo)
    destinationIslandId INT NULL,            -- Nếu destination là đảo -> FK Islands
    departureTime DATETIME NOT NULL,
    arrivalTime DATETIME NOT NULL,
    price DECIMAL(10,3) NOT NULL,
    FOREIGN KEY (airlineId) REFERENCES Airlines(airlineId),
    FOREIGN KEY (destinationIslandId) REFERENCES Islands(islandId)
);
GO


-- Bảng phương tiện cho thuê trong đảo
CREATE TABLE IslandVehicles (
    vehicleId INT IDENTITY(1,1) PRIMARY KEY,
    islandId INT NOT NULL,
    companyName NVARCHAR(100),
    vehicleType NVARCHAR(50) CHECK (vehicleType IN ('CAR','SCOOTER','MOTORBIKE','BICYCLE','ELECTRIC_CART','OTHER')),
    modelName NVARCHAR(100),
    pricePerDay DECIMAL(10,3),
    capacity INT,
    availability BIT DEFAULT 1,
    FOREIGN KEY (islandId) REFERENCES Islands(islandId) ON DELETE CASCADE
);


go

--  Bảng Trips (gói tour tổng quan)
CREATE TABLE Trips (
    tripId INT IDENTITY(1,1) PRIMARY KEY,
    tripName NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    basePrice DECIMAL(10,3),          -- giá cơ bản của gói tour
    startDate DATE,
    endDate DATE,
    createdAt DATETIME DEFAULT GETDATE()
);
go

-- Bảng Bookings (đặt tour hoặc dịch vụ lẻ)
CREATE TABLE Bookings (
    bookingId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN ('HOTEL','FLIGHT','VEHICLE')) NULL,  -- dịch vụ riêng lẻ
    refId INT NOT NULL,         -- id của hotel/flight/vehicle
    tripsId INT NOT NULL,        -- id của gói tour (package)
    bookingDate DATETIME DEFAULT GETDATE(),
    checkIn DATE,
    checkOut DATE,
    totalAmount DECIMAL(10,3),
    status VARCHAR(20) CHECK (status IN ('CONFIRMED','CANCELLED','PENDING')) DEFAULT 'PENDING',
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (tripsId) REFERENCES Trips(tripId) ON DELETE CASCADE
);

-- Bảng Payments
  
CREATE TABLE Payments (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    amount DECIMAL(10,3) NOT NULL,
    method VARCHAR(20) CHECK (method IN ('VNPAY','PAYPAL','STRIPE','CREDITCARD')) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('SUCCESS','FAILED','PENDING')) DEFAULT 'PENDING',
    transactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId) ON DELETE CASCADE
);
go

-- Bảng TripServices (các dịch vụ con trong Trip)
CREATE TABLE TripServices (
    tripServiceId INT IDENTITY(1,1) PRIMARY KEY,
    tripId INT NOT NULL,
    serviceType VARCHAR(20) CHECK (serviceType IN ('HOTEL','FLIGHT','VEHICLE')),
    refId INT NOT NULL,  -- id của Hotel/Flight/Vehicle
    FOREIGN KEY (tripId) REFERENCES Trips(tripId) ON DELETE CASCADE
);
go

--  Bảng TripItineraries (lộ trình chi tiết theo ngày)
CREATE TABLE TripItineraries (
    itineraryId INT IDENTITY(1,1) PRIMARY KEY,
    tripId INT NOT NULL,
    dayNumber INT NOT NULL,
    activity VARCHAR(255),
    location NVARCHAR(100),
    FOREIGN KEY (tripId) REFERENCES Trips(tripId) ON DELETE CASCADE
);
go

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
    message NVARCHAR(500) NOT NULL,
    type VARCHAR(50) CHECK (type IN ('BOOKING','PAYMENT','PROMOTION','SYSTEM')) DEFAULT 'SYSTEM',
    isRead BIT DEFAULT 0,
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
go

-- favourite trips , servies
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

 INSERT INTO Users (username, password, email, fullName, phone, role)
VALUES 
('admin1', 'admin123!', 'admin1@example.com', 'Admin', '0987654321', 'ADMIN');
-- Booking Manager
INSERT INTO Users (username, password, email, fullName, phone, role)
VALUES 
('bookingmanager1', 'managerpass123!', 'nqaghuyyy6969@gmail.com', 'Booking Manager', '0369409004', 'BOOKING MANAGER');

-- Service Provider
INSERT INTO Users (username, password, email, fullName, phone, role)
VALUES 
('provider1', 'providerpass123!', 'provider@example.com', 'Service Provider', '0987654321', 'SERVICE PROVIDER');

INSERT INTO Users (username, password, email, fullName, phone, role)
VALUES 
('quanghuy123', 'huyvipmn5', 'huynqhe182510@fpt.edu.vn', 'David Huy', '0982706236', 'CUSTOMER');

--2.island
select * from bookings
INSERT INTO Islands (islandName, country, description, bestSeason, activities, imageUrl)
VALUES
(N'Phú Quốc', N'Vietnam', N'Hòn đảo xinh đẹp với nhiều bãi biển', N'Hạ', N'Bơi lội, Lặn biển, Ngắm san hô', N'views/home/images/islands/phuquoc.jpg'),
(N'Langkawi', N'Malaysia', N'Hòn đảo lịch sử nổi tiếng', N'Hạ', N'Tham quan, Lặn biển', N'views/home/images/islands/Langkawi.jpg'),
(N'Phuket', N'Thailand', N'Đảo du lịch nổi tiếng với cuộc sống về đêm sôi động', N'Thu', N'Tắm biển, Lặn, Nightlife', N'views/home/images/islands/phuket.jpg'),
(N'Bali', N'Indonesia', N'Nổi tiếng với văn hoá, bãi biển và lướt sóng', N'Xuân', N'Lướt sóng, Tham quan đền chùa, Tắm biển', N'views/home/images/islands/bali.jpg'),
(N'Boracay', N'Philippines', N'Nổi tiếng với bãi cát trắng và cuộc sống về đêm sôi động', N'Đông', N'Tắm biển, Thể thao dưới nước, Nightlife', N'views/home/images/islands/boracay.jpg'),
(N'Sihanoukville', N'Cambodia', N'Thành phố ven biển với nhiều đảo và bãi biển đẹp', N'Đông', N'Tắm biển, Lặn ngắm san hô, Đi thuyền', N'views/home/images/islands/sihanoukville.jpg'),
(N'Tioman', N'Malaysia', N'Đảo nhiệt đới với rừng rậm và rạn san hô', N'Hạ', N'Lặn, Leo núi, Ngắm san hô', N'views/home/images/islands/tioman.jpg'),
(N'Koh Samui', N'Thailand', N'Đảo nổi tiếng với bãi biển, thác nước và chùa chiền', N'Xuân', N'Tắm biển, Tham quan chùa, Nightlife', N'views/home/images/islands/kohsamui.jpg'),
(N'Nusa Penida', N'Indonesia', N'Đảo có vách đá và làn nước trong xanh tuyệt đẹp', N'Thu', N'Lặn ngắm san hô, Tham quan, Leo núi', N'views/home/images/islands/nusapenida.jpg'),
(N'Palawan', N'Philippines', N'Nổi tiếng với đầm phá, bãi biển và vách đá vôi', N'Hạ', N'Đi thuyền đảo, Kayak, Lặn ngắm san hô', N'views/home/images/islands/palawan.jpg');
select * from hotels


--3.hotel

INSERT INTO Hotels (islandId, hotelName, roomType, pricePerNight, roomsAvailable, rating, hotelImageUrl)
VALUES
-- Phu Quoc
(1, 'Vinpearl Resort Phu Quoc', 'Deluxe', 150000, 30, 4.6, 'views/home/images/hotels/vinpearl_pq_main.jpg'),
(1, 'Salinda Resort Phu Quoc', 'Suite', 200000, 15, 4.8, 'views/home/images/hotels/salinda_pq_main.jpg'),

-- Langkawi
(2, 'Berjaya Langkawi Resort', 'Suite', 120000, 25, 4.4, 'views/home/images/hotels/berjaya_langkawi_main.jpg'),
(2, 'The Datai Langkawi', 'Suite', 250000, 10, 4.9, 'views/home/images/hotels/datai_langkawi_main.jpg'),

-- Phuket
(3, 'Amari Phuket', 'Standard', 110000, 40, 4.5, 'views/home/images/hotels/amari_phuket_main.jpg'),
(3, 'The Shore at Katathani', 'Suite', 220000, 12, 4.8, 'views/home/images/hotels/shore_katathani_main.jpg'),

-- Bali
(4, 'Bali Mandira Beach Resort', 'Family', 130000, 20, 4.5, 'views/home/images/hotels/mandira_bali_main.jpg'),
(4, 'Four Seasons Bali at Sayan', 'Suite', 300000, 8, 4.9, 'views/home/images/hotels/fourseasons_bali_main.jpg'),

-- Boracay
(5, 'Shangri-La Boracay', 'Family', 280000, 10, 4.9, 'views/home/images/hotels/shangrila_boracay_main.jpg'),
(5, 'Henann Lagoon Resort', 'Deluxe', 100000, 35, 4.3, 'views/home/images/hotels/henann_boracay_main.jpg'),

-- Sihanoukville
(6, 'Independence Hotel Resort', 'Suite', 140000, 18, 4.2, 'views/home/images/hotels/independence_sihanoukville_main.jpg'),
(6, 'Sokha Beach Resort', 'Standard', 95000, 40, 4.4, 'views/home/images/hotels/sokha_sihanoukville_main.jpg'),

-- Tioman
(7, 'Japamala Resort', 'Suite', 160000, 12, 4.7, 'views/home/images/hotels/japamala_tioman_main.jpg'),
(7, 'Berjaya Tioman Resort', 'Standard', 90000, 25, 4.1, 'views/home/images/hotels/berjaya_tioman_main.jpg'),

-- Koh Samui
(8, 'Banyan Tree Samui', 'Suite', 270000, 15, 4.9, 'views/home/images/hotels/banyan_samui_main.jpg'),
(8, 'Chaweng Regent Beach Resort', 'Deluxe', 120000, 30, 4.4, 'views/home/images/hotels/chaweng_samui_main.jpg'),

-- Nusa Penida
(9, 'Semabu Hills Hotel', 'Standard', 110000, 20, 4.3, 'views/home/images/hotels/semabu_penida_main.jpg'),
(9, 'Maua Nusa Penida', 'Suite', 190000, 12, 4.6, 'views/home/images/hotels/maua_penida_main.jpg'),

-- Palawan
(10, 'El Nido Resorts Miniloc Island', 'Suite', 200000, 15, 4.8, 'views/home/images/hotels/miniloc_palawan_main.jpg'),
(10, 'Astoria Palawan', 'Deluxe', 130000, 25, 4.5, 'views/home/images/hotels/astoria_palawan_main.jpg');

-- Xem dữ liệu
select * from Hotels;


-- vehicle to island
INSERT INTO VehiclesToIsland (islandId, vehicleType, providerName, pricePerDay, capacity, description)
VALUES
(1, 'BOAT', 'Phuket Ferry', 100.000, 20, 'Ferry from mainland to phuket'),
(2, 'CAR', 'Phu Quoc Car Service', 70.000,6, 'Private car rental');
 
-- arilines

INSERT INTO Airlines (airlineName, iataCode, country, hotline, logoUrl)
VALUES
('Vietnam Airlines', 'VN', 'Vietnam', '19001100', 'views/home/images/VietnamAirlines.jpg'),
('Vietjet Air', 'VJ', 'Vietnam', '19001886', 'views/home/images/VietjetAir.jpg');

--flights

INSERT INTO Flights (flightNumber, airlineId, departure, destination, destinationIslandId, departureTime, arrivalTime, price)
VALUES
('VN123', 1, 'Hanoi', 'Phu Quoc', 1, '2025-10-20 08:00', '2025-10-20 10:00', 500.000),
('VJ456', 2, 'Ho Chi Minh', 'Phuket', 2, '2025-10-21 18:30', '2025-10-21 23:00', 850.000);
select * from flights
-- vehicle insland
INSERT INTO IslandVehicles (islandId, companyName, vehicleType, modelName, pricePerDay, capacity)
VALUES
(1, 'Phu Quoc Rentals', 'MOTORBIKE', 'Honda Air Blade', 15.000, 2),
(2, 'Con Dao Rentals', 'CAR', 'Toyota Innova', 50.000, 4)
-- trips

INSERT INTO Trips (tripName, description, basePrice, startDate, endDate)
VALUES
('Phu Quoc Adventure', '3-day adventure on Phu Quoc island', 520.000, '2025-11-01', '2025-11-03'),
('Bali History Tour', '2-day historical tour', 879.899, '2025-11-05', '2025-11-06');

-- trip services

INSERT INTO TripServices (tripId, serviceType, refId)
VALUES
(1, 'HOTEL', 1),
(1, 'FLIGHT', 2),
(1, 'VEHICLE', 1),
(2, 'HOTEL', 3),
(2, 'FLIGHT', 2);

--  TripItineraries
INSERT INTO TripItineraries (tripId, dayNumber, activity, location)
VALUES
(1, 1, 'Tham quan bãi biển Sunrise', 'Bãi biển Sunrise'),
(1, 2, 'Leo núi và chụp ảnh', 'Núi Dragon');


-- bookings

INSERT INTO Bookings 
(userId, serviceType, refId, tripsId, checkIn, checkOut, totalAmount, status)
VALUES
(4, 'FLIGHT', 1, 1, '2025-11-01', '2025-11-03', 567.150, 'CONFIRMED'),
(4, 'HOTEL', 2, 2, '2025-12-16', '2025-12-19', 380.000, 'PENDING');

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


-------------------------------------------------------------------------------------------------------

