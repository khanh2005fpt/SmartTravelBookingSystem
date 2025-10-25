-- Sample data for TourItinerary table
-- Based on the 10 tours provided with realistic day-by-day breakdown

-- Tour 1: Tour Nghỉ dưỡng Phú Quốc mới (2N1Đ - assuming 2 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(1, 1, 1, 'Ngày 1: Đến Phú Quốc - Vinpearl Safari'),
(2, 1, 2, 'Ngày 2: Bãi Sao - Chợ đêm Dinh Cậu');

-- Tour 2: Tour Lặn biển Phú Quốc 4N3Đ (4 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(3, 2, 1, 'Ngày 1: Đến Phú Quốc - Khám phá thành phố'),
(4, 2, 2, 'Ngày 2: Lặn ngắm san hô Hòn Móng Tay'),
(5, 2, 3, 'Ngày 3: Câu cá đêm - BBQ trên biển'),
(6, 2, 4, 'Ngày 4: Tự do - Về');

-- Tour 3: Tour Văn hóa & Biển Phú Quốc 2N1Đ (2 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(7, 3, 1, 'Ngày 1: Làng chài Hàm Ninh - Nước mắm truyền thống'),
(8, 3, 2, 'Ngày 2: Tắm biển - Mua sắm đặc sản');

-- Tour 4: Tour Khám phá Langkawi 4N3Đ (4 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(9, 4, 1, 'Ngày 1: Đến Langkawi - Khám phá thành phố'),
(10, 4, 2, 'Ngày 2: Cầu treo SkyBridge - Cable Car'),
(11, 4, 3, 'Ngày 3: Pantai Cenang Beach - Mua sắm duty-free'),
(12, 4, 4, 'Ngày 4: Tự do - Về');

-- Tour 5: Tour Khám phá Phuket 4N3Đ (4 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(13, 5, 1, 'Ngày 1: Đến Phuket - Phố cổ Phuket Town'),
(14, 5, 2, 'Ngày 2: Đảo Phi Phi - Snorkeling'),
(15, 5, 3, 'Ngày 3: Show Simon Cabaret - Patong Beach'),
(16, 5, 4, 'Ngày 4: Tự do - Về');

-- Tour 6: Tour Văn hóa & Biển Bali 5N4Đ (5 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(17, 6, 1, 'Ngày 1: Đến Bali - Đền Tanah Lot'),
(18, 6, 2, 'Ngày 2: Ruộng bậc thang Tegallalang - Ubud'),
(19, 6, 3, 'Ngày 3: Kuta Beach - Nghỉ dưỡng'),
(20, 6, 4, 'Ngày 4: Uluwatu Temple - Kecak Dance'),
(21, 6, 5, 'Ngày 5: Tự do - Về');

-- Tour 7: Tour Nghỉ dưỡng Bali 4N3Đ (4 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(22, 7, 1, 'Ngày 1: Đến Bali - Spa truyền thống'),
(23, 7, 2, 'Ngày 2: Yoga - Meditation'),
(24, 7, 3, 'Ngày 3: Biển Jimbaran - Ngắm hoàng hôn Uluwatu'),
(25, 7, 4, 'Ngày 4: Tự do - Về');

-- Tour 8: Tour Biển Boracay 4N3Đ (4 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(26, 8, 1, 'Ngày 1: Đến Boracay - White Beach'),
(27, 8, 2, 'Ngày 2: Lặn ngắm san hô - Hoạt động biển'),
(28, 8, 3, 'Ngày 3: Tiệc đêm sôi động - D\'Mall'),
(29, 8, 4, 'Ngày 4: Tự do - Về');

-- Tour 9: Tour Nghỉ dưỡng Koh Samui 4N3Đ (4 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(30, 9, 1, 'Ngày 1: Đến Koh Samui - Big Buddha Temple'),
(31, 9, 2, 'Ngày 2: Thác Na Muang - Jungle Tour'),
(32, 9, 3, 'Ngày 3: Chợ đêm Fisherman\'s Village'),
(33, 9, 4, 'Ngày 4: Tự do - Về');

-- Tour 10: Tour Văn hóa Koh Samui 5N4Đ (5 days)
INSERT INTO TourItinerary (itineraryId, tourId, dayNumber, title) VALUES
(34, 10, 1, 'Ngày 1: Đến Koh Samui - Chùa Wat Plai Laem'),
(35, 10, 2, 'Ngày 2: Massage Thái truyền thống'),
(36, 10, 3, 'Ngày 3: Ẩm thực địa phương - Cooking Class'),
(37, 10, 4, 'Ngày 4: Khám phá văn hóa - Làng nghề'),
(38, 10, 5, 'Ngày 5: Tự do - Về');