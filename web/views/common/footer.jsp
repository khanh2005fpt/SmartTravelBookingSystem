<%--
    Document : footer
    Created on : Sep 11, 2025
    Author : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="position-relative text-white pt-5 pb-4 overflow-hidden" style="min-height: 300px;">
    <!-- NỀN ẢNH + FALLBACK -->
    <div class="position-absolute top-0 start-0 w-100 h-100" 
         style="background: 
                linear-gradient(rgba(0,0,0,0.75), rgba(0,0,0,0.75)), 
                url('${pageContext.request.contextPath}/views/home/images/island_Bg.jpg') center/cover no-repeat,
                url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80') center/cover no-repeat;
                z-index: 1;">
    </div>

    <!-- NỘI DUNG -->
    <div class="container position-relative mt-4" style="max-width: 1400px; z-index: 3;">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h4 class="fw-bold mb-3 text-warning">Meland</h4>
                <p  class="small"><strong>  Chuyên tổ chức tour du lịch đảo hấp dẫn...</strong></p>
                <p class="fst-italic text-light small"> Hãy để <strong>   MelandBooking </strong> đồng hành cùng bạn 
                    trên mỗi hành trình và nơi du lịch không chỉ là khám phá, mà còn là cảm nhận, 
                    kết nối và tận hưởng trọn vẹn Đông Nam Á.</p>
            
                <p class="fst-italic text-light small">"Hành trình khám phá hạnh phúc..."</p>
            </div>
            <div class="col-md-5 mb-4">
                <h4 class="fw-bold mb-3 text-warning">Lời chúc</h4>
                <ul class="list-unstyled small text-light">
                    <p> <strong> Chúc bạn có những trải nghiệm tuyệt vời...</strong></p>
                    <li>Mỗi chuyến đi là một hành trình của bạn qua 11 quốc gia Đông Nam Á, 
                        từ những bãi biển trong xanh của Việt Nam, hòn đảo huyền thoại ở 
                        Indonesia đến nền văn hóa sôi động của Thái Lan</li>
                    <p>Hãy để Meland Travel đồng hành...</p>
                    <p>Gió biển mát lành...</p>
                </ul>
            </div>
            <div class="col-md-3 mb-4">
                <h4 class="fw-bold mb-3 text-warning">Liên hệ</h4>
                <p class="small"><i class="fa fa-map-marker-alt me-2 text-warning"></i> Đại học FPT Hà Nội</p>
                <p class="small"><i class="fa fa-phone me-2 text-warning"></i> 0912 459 092</p>
                <p class="small"><i class="fa fa-envelope me-2 text-warning"></i> nguyenhuubaokhanh2005@gmail.com</p>
            </div>
        </div>
        <div class="text-center mt-4 pt-3 border-top border-light border-opacity-25 small">
            © 2025 <span class="text-warning">Meland Travel</span>. All rights reserved.
        </div>
    </div>
</footer>