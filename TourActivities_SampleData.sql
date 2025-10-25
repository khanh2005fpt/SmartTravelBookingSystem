-- Sample data for TourActivities table
-- Detailed activities for each itinerary day

-- Tour 1: Tour Nghỉ dưỡng Phú Quốc mới
-- Day 1 Activities (itineraryId = 1)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(1, 1, 1, 'Đón khách tại sân bay Phú Quốc', 'Xe đưa đón tại sân bay, check-in khách sạn'),
(2, 1, 2, 'Tham quan Vinpearl Safari', 'Khám phá vườn thú hoang dã lớn nhất Việt Nam với hơn 3000 động vật'),
(3, 1, 3, 'Ăn tối tại nhà hàng địa phương', 'Thưởng thức hải sản tươi sống đặc trưng Phú Quốc');

-- Day 2 Activities (itineraryId = 2)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(4, 2, 1, 'Tắm biển tại Bãi Sao', 'Thư giãn tại bãi biển đẹp nhất Phú Quốc với cát trắng mịn'),
(5, 2, 2, 'Ăn trưa hải sản', 'Thưởng thức các món hải sản nướng tại bãi biển'),
(6, 2, 3, 'Tham quan Chợ đêm Dinh Cậu', 'Mua sắm đặc sản và thưởng thức ẩm thực đường phố'),
(7, 2, 4, 'Đưa ra sân bay', 'Kết thúc chuyến du lịch, đưa khách ra sân bay');

-- Tour 2: Tour Lặn biển Phú Quốc 4N3Đ
-- Day 1 Activities (itineraryId = 3)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(8, 3, 1, 'Đón khách tại sân bay', 'Xe đưa đón và check-in resort'),
(9, 3, 2, 'Khám phá thành phố Dương Đông', 'Tham quan trung tâm thành phố, mua sắm tại chợ'),
(10, 3, 3, 'Ăn tối BBQ tại resort', 'Tiệc BBQ bên bờ biển với âm nhạc sống');

-- Day 2 Activities (itineraryId = 4)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(11, 4, 1, 'Lặn ngắm san hô Hòn Móng Tay', 'Tour lặn biển khám phá rạn san hô đa dạng'),
(12, 4, 2, 'Ăn trưa trên đảo', 'Picnic trên đảo hoang sơ với hải sản tươi sống'),
(13, 4, 3, 'Snorkeling và bơi lội', 'Hoạt động thể thao dưới nước tự do'),
(14, 4, 4, 'Ngắm hoàng hôn trên biển', 'Thư giãn và chụp ảnh hoàng hôn tuyệt đẹp');

-- Day 3 Activities (itineraryId = 5)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(15, 5, 1, 'Câu cá đêm', 'Trải nghiệm câu cá mực đêm trên biển'),
(16, 5, 2, 'BBQ trên biển', 'Nướng hải sản vừa câu được ngay trên thuyền'),
(17, 5, 3, 'Ngắm sao trời', 'Thưởng thức không gian yên tĩnh dưới bầu trời sao'),
(18, 5, 4, 'Về resort nghỉ ngơi', 'Trở về resort vào sáng sớm');

-- Day 4 Activities (itineraryId = 6)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(19, 6, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort, spa, massage'),
(20, 6, 2, 'Mua sắm đặc sản', 'Mua nước mắm, tiêu, sim rượu đặc trưng'),
(21, 6, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 3: Tour Văn hóa & Biển Phú Quốc 2N1Đ
-- Day 1 Activities (itineraryId = 7)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(22, 7, 1, 'Thăm làng chài Hàm Ninh', 'Khám phá đời sống ngư dân địa phương'),
(23, 7, 2, 'Tham quan nhà máy nước mắm', 'Tìm hiểu quy trình sản xuất nước mắm truyền thống'),
(24, 7, 3, 'Ăn trưa đặc sản', 'Thưởng thức bún quậy, bánh canh cua đặc trưng'),
(25, 7, 4, 'Tắm biển Ông Lang', 'Thư giãn tại bãi biển hoang sơ');

-- Day 2 Activities (itineraryId = 8)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(26, 8, 1, 'Tắm biển Sao', 'Tận hưởng bãi biển đẹp nhất đảo'),
(27, 8, 2, 'Mua sắm đặc sản', 'Mua tiêu, sim rượu, mật ong rừng'),
(28, 8, 3, 'Ăn trưa hải sản', 'Thưởng thức ghẹ, cua, tôm hùm tươi sống'),
(29, 8, 4, 'Đưa ra sân bay', 'Kết thúc tour và đưa khách ra sân bay');

-- Tour 4: Tour Khám phá Langkawi 4N3Đ
-- Day 1 Activities (itineraryId = 9)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(30, 9, 1, 'Đón khách tại sân bay Langkawi', 'Xe đưa đón và check-in khách sạn'),
(31, 9, 2, 'Khám phá Kuah Town', 'Tham quan trung tâm thành phố, Eagle Square'),
(32, 9, 3, 'Ăn tối ẩm thực Malaysia', 'Thưởng thức các món đặc trưng Malaysia');

-- Day 2 Activities (itineraryId = 10)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(33, 10, 1, 'Cáp treo lên đỉnh núi', 'Trải nghiệm cáp treo Langkawi Cable Car'),
(34, 10, 2, 'Cầu treo SkyBridge', 'Đi bộ trên cầu treo nổi tiếng thế giới'),
(35, 10, 3, 'Ăn trưa trên núi', 'Thưởng thức ẩm thực với view toàn cảnh đảo'),
(36, 10, 4, 'Tham quan Seven Wells Waterfall', 'Khám phá thác nước 7 tầng tuyệt đẹp');

-- Day 3 Activities (itineraryId = 11)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(37, 11, 1, 'Tắm biển Pantai Cenang', 'Thư giãn tại bãi biển đẹp nhất Langkawi'),
(38, 11, 2, 'Thể thao biển', 'Jet ski, parasailing, banana boat'),
(39, 11, 3, 'Mua sắm duty-free', 'Shopping tại các cửa hàng miễn thuế'),
(40, 11, 4, 'Ăn tối hải sản', 'BBQ hải sản tại bãi biển');

-- Day 4 Activities (itineraryId = 12)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(41, 12, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(42, 12, 2, 'Mua sắm quà lưu niệm', 'Mua chocolate, rượu, đồ lưu niệm'),
(43, 12, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 5: Tour Khám phá Phuket 4N3Đ
-- Day 1 Activities (itineraryId = 13)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(44, 13, 1, 'Đón khách tại sân bay Phuket', 'Xe đưa đón và check-in khách sạn'),
(45, 13, 2, 'Tham quan phố cổ Phuket Town', 'Khám phá kiến trúc Sino-Portuguese'),
(46, 13, 3, 'Ăn tối ẩm thực Thái', 'Thưởng thức Tom Yum, Pad Thai, Green Curry');

-- Day 2 Activities (itineraryId = 14)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(47, 14, 1, 'Tour đảo Phi Phi', 'Khám phá đảo Phi Phi nổi tiếng thế giới'),
(48, 14, 2, 'Snorkeling tại Maya Bay', 'Lặn ngắm san hô tại vịnh Maya Bay'),
(49, 14, 3, 'Ăn trưa trên đảo', 'Buffet hải sản tại đảo Phi Phi'),
(50, 14, 4, 'Monkey Beach', 'Thăm bãi biển khỉ độc đáo');

-- Day 3 Activities (itineraryId = 15)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(51, 15, 1, 'Show Simon Cabaret', 'Xem show ca múa nổi tiếng Phuket'),
(52, 15, 2, 'Tắm biển Patong', 'Thư giãn tại bãi biển sôi động nhất Phuket'),
(53, 15, 3, 'Mua sắm tại Bangla Road', 'Shopping và trải nghiệm cuộc sống đêm'),
(54, 15, 4, 'Massage Thái truyền thống', 'Thư giãn với massage chân, toàn thân');

-- Day 4 Activities (itineraryId = 16)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(55, 16, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(56, 16, 2, 'Mua sắm quà lưu niệm', 'Mua đồ thủ công, trang sức, gia vị'),
(57, 16, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 6: Tour Văn hóa & Biển Bali 5N4Đ
-- Day 1 Activities (itineraryId = 17)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(58, 17, 1, 'Đón khách tại sân bay Bali', 'Xe đưa đón và check-in khách sạn'),
(59, 17, 2, 'Tham quan đền Tanah Lot', 'Khám phá ngôi đền nổi tiếng trên biển'),
(60, 17, 3, 'Ngắm hoàng hôn', 'Chụp ảnh hoàng hôn tuyệt đẹp tại Tanah Lot'),
(61, 17, 4, 'Ăn tối ẩm thực Bali', 'Thưởng thức Nasi Goreng, Satay, Gado-gado');

-- Day 2 Activities (itineraryId = 18)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(62, 18, 1, 'Ruộng bậc thang Tegallalang', 'Khám phá cảnh quan ruộng lúa tuyệt đẹp'),
(63, 18, 2, 'Tham quan Ubud', 'Khám phá trung tâm văn hóa nghệ thuật Bali'),
(64, 18, 3, 'Sacred Monkey Forest', 'Thăm khu rừng khỉ thiêng liêng'),
(65, 18, 4, 'Ubud Traditional Market', 'Mua sắm đồ thủ công truyền thống');

-- Day 3 Activities (itineraryId = 19)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(66, 19, 1, 'Tắm biển Kuta Beach', 'Thư giãn tại bãi biển nổi tiếng nhất Bali'),
(67, 19, 2, 'Học lướt sóng', 'Trải nghiệm môn thể thao lướt sóng'),
(68, 19, 3, 'Spa truyền thống Bali', 'Massage với tinh dầu thảo mộc'),
(69, 19, 4, 'Ăn tối BBQ bãi biển', 'Tiệc nướng hải sản bên bờ biển');

-- Day 4 Activities (itineraryId = 20)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(70, 20, 1, 'Tham quan Uluwatu Temple', 'Khám phá ngôi đền trên vách đá'),
(71, 20, 2, 'Xem múa Kecak', 'Thưởng thức điệu múa truyền thống Bali'),
(72, 20, 3, 'Jimbaran Beach', 'Ăn tối hải sản tại bãi biển Jimbaran'),
(73, 20, 4, 'Ngắm hoàng hôn', 'Chụp ảnh hoàng hôn tuyệt đẹp');

-- Day 5 Activities (itineraryId = 21)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(74, 21, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(75, 21, 2, 'Mua sắm quà lưu niệm', 'Mua đồ thủ công, cà phê, gia vị'),
(76, 21, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 7: Tour Nghỉ dưỡng Bali 4N3Đ
-- Day 1 Activities (itineraryId = 22)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(77, 22, 1, 'Đón khách tại sân bay', 'Xe đưa đón và check-in resort cao cấp'),
(78, 22, 2, 'Spa truyền thống Bali', 'Massage toàn thân với tinh dầu thảo mộc'),
(79, 22, 3, 'Ăn tối tại resort', 'Thưởng thức ẩm thực quốc tế cao cấp');

-- Day 2 Activities (itineraryId = 23)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(80, 23, 1, 'Yoga buổi sáng', 'Lớp yoga với view ruộng lúa'),
(81, 23, 2, 'Meditation', 'Thiền định trong không gian yên tĩnh'),
(82, 23, 3, 'Healthy lunch', 'Ăn trưa healthy với thực phẩm organic'),
(83, 23, 4, 'Thư giãn tại pool', 'Nghỉ ngơi bên hồ bơi vô cực');

-- Day 3 Activities (itineraryId = 24)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(84, 24, 1, 'Tắm biển Jimbaran', 'Thư giãn tại bãi biển yên tĩnh'),
(85, 24, 2, 'Ăn trưa hải sản', 'Thưởng thức hải sản tươi sống'),
(86, 24, 3, 'Ngắm hoàng hôn Uluwatu', 'Chụp ảnh hoàng hôn tại vách đá'),
(87, 24, 4, 'Romantic dinner', 'Ăn tối lãng mạn bên bờ biển');

-- Day 4 Activities (itineraryId = 25)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(88, 25, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(89, 25, 2, 'Mua sắm quà lưu niệm', 'Mua đồ thủ công, trang sức bạc'),
(90, 25, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 8: Tour Biển Boracay 4N3Đ
-- Day 1 Activities (itineraryId = 26)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(91, 26, 1, 'Đón khách tại sân bay', 'Xe đưa đón và check-in resort'),
(92, 26, 2, 'Tắm biển White Beach', 'Thư giãn tại bãi biển cát trắng nổi tiếng'),
(93, 26, 3, 'Ăn tối BBQ', 'Tiệc nướng hải sản bên bờ biển'),
(94, 26, 4, 'Fire dancing show', 'Xem biểu diễn múa lửa truyền thống');

-- Day 2 Activities (itineraryId = 27)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(95, 27, 1, 'Island hopping', 'Tour khám phá các đảo nhỏ xung quanh'),
(96, 27, 2, 'Lặn ngắm san hô', 'Snorkeling tại các điểm san hô đẹp'),
(97, 27, 3, 'Ăn trưa trên đảo', 'Picnic với hải sản tươi sống'),
(98, 27, 4, 'Thể thao biển', 'Jet ski, parasailing, banana boat');

-- Day 3 Activities (itineraryId = 28)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(99, 28, 1, 'Mua sắm tại D\'Mall', 'Shopping tại trung tâm thương mại'),
(100, 28, 2, 'Ăn trưa Filipino', 'Thưởng thức ẩm thực Philippines'),
(101, 28, 3, 'Tiệc đêm sôi động', 'Trải nghiệm cuộc sống đêm Boracay'),
(102, 28, 4, 'Beach party', 'Tiệc bãi biển với DJ và cocktail');

-- Day 4 Activities (itineraryId = 29)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(103, 29, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(104, 29, 2, 'Mua sắm quà lưu niệm', 'Mua đồ thủ công, trang sức ngọc trai'),
(105, 29, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 9: Tour Nghỉ dưỡng Koh Samui 4N3Đ
-- Day 1 Activities (itineraryId = 30)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(106, 30, 1, 'Đón khách tại sân bay', 'Xe đưa đón và check-in resort'),
(107, 30, 2, 'Tham quan Big Buddha Temple', 'Khám phá tượng Phật khổng lồ nổi tiếng'),
(108, 30, 3, 'Ăn tối ẩm thực Thái', 'Thưởng thức các món đặc trưng Thái Lan'),
(109, 30, 4, 'Massage Thái', 'Thư giãn với massage truyền thống');

-- Day 2 Activities (itineraryId = 31)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(110, 31, 1, 'Tham quan thác Na Muang', 'Khám phá thác nước tự nhiên tuyệt đẹp'),
(111, 31, 2, 'Jungle tour', 'Trekking khám phá rừng nhiệt đới'),
(112, 31, 3, 'Ăn trưa trong rừng', 'Picnic với đặc sản địa phương'),
(113, 31, 4, 'Tắm thác', 'Tắm mát dưới thác nước Na Muang');

-- Day 3 Activities (itineraryId = 32)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(114, 32, 1, 'Chợ đêm Fisherman\'s Village', 'Khám phá chợ đêm nổi tiếng Bophut'),
(115, 32, 2, 'Ăn tối hải sản', 'Thưởng thức hải sản tươi sống'),
(116, 32, 3, 'Mua sắm đồ lưu niệm', 'Shopping tại các gian hàng thủ công'),
(117, 32, 4, 'Ngắm hoàng hôn', 'Chụp ảnh hoàng hôn tại bãi biển');

-- Day 4 Activities (itineraryId = 33)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(118, 33, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(119, 33, 2, 'Mua sắm quà lưu niệm', 'Mua dầu dừa, xà phòng thảo mộc'),
(120, 33, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');

-- Tour 10: Tour Văn hóa Koh Samui 5N4Đ
-- Day 1 Activities (itineraryId = 34)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(121, 34, 1, 'Đón khách tại sân bay', 'Xe đưa đón và check-in khách sạn'),
(122, 34, 2, 'Tham quan chùa Wat Plai Laem', 'Khám phá ngôi chùa với tượng Phật 18 tay'),
(123, 34, 3, 'Ăn tối ẩm thực địa phương', 'Thưởng thức Som Tam, Larb, Sticky Rice'),
(124, 34, 4, 'Tìm hiểu văn hóa Thái', 'Giao lưu với người dân địa phương');

-- Day 2 Activities (itineraryId = 35)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(125, 35, 1, 'Massage Thái truyền thống', 'Trải nghiệm massage chính thống'),
(126, 35, 2, 'Học làm massage', 'Khóa học massage Thái cơ bản'),
(127, 35, 3, 'Ăn trưa healthy', 'Thưởng thức ẩm thực chay Thái'),
(128, 35, 4, 'Yoga và meditation', 'Thư giãn với yoga và thiền định');

-- Day 3 Activities (itineraryId = 36)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(129, 36, 1, 'Cooking class', 'Học nấu các món ẩm thực Thái'),
(130, 36, 2, 'Thăm chợ địa phương', 'Mua nguyên liệu và tìm hiểu gia vị'),
(131, 36, 3, 'Ăn trưa món tự nấu', 'Thưởng thức thành quả của mình'),
(132, 36, 4, 'Food tour', 'Khám phá ẩm thực đường phố');

-- Day 4 Activities (itineraryId = 37)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(133, 37, 1, 'Thăm làng nghề truyền thống', 'Tìm hiểu nghề dệt, làm gốm'),
(134, 37, 2, 'Trải nghiệm làm nghề', 'Thực hành làm đồ thủ công'),
(135, 37, 3, 'Ăn trưa với gia đình địa phương', 'Trải nghiệm văn hóa gia đình Thái'),
(136, 37, 4, 'Tham quan bảo tàng văn hóa', 'Tìm hiểu lịch sử Koh Samui');

-- Day 5 Activities (itineraryId = 38)
INSERT INTO TourActivities (activityId, itineraryId, activityOrder, activityTitle, description) VALUES
(137, 38, 1, 'Tự do nghỉ dưỡng', 'Thời gian tự do tại resort'),
(138, 38, 2, 'Mua sắm quà lưu niệm', 'Mua đồ thủ công, gia vị, trà thảo mộc'),
(139, 38, 3, 'Đưa ra sân bay', 'Check-out và đưa khách ra sân bay');