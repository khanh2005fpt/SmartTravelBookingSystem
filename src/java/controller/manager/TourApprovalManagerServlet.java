package controller.manager;

import dao.TourDao;
import model.Tour;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "TourApprovalManagerServlet", urlPatterns = {"/manager/tour-approval"})
public class TourApprovalManagerServlet extends HttpServlet {

    private TourDao tourDao;

    @Override
    public void init() throws ServletException {
        try {
            tourDao = new TourDao();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo TourDao", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession();
//        String role = (String) session.getAttribute("role");
//
//        // ✅ Chỉ cho phép role = MANAGER
//        if (role == null || !"MANAGER".equalsIgnoreCase(role)) {
//            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
//            return;
//        }

       // ... (code kiểm tra role nếu cần) ...

        // Giữ doGet chỉ để list (hiển thị trang duyệt)
        try {
            listPendingTours(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/manager/tour-approval.jsp").forward(request, response);
        }
    }


    private void updateTourStatus(HttpServletRequest request, HttpServletResponse response, String status)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        tourDao.updateTourStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/manager/tour-approval");
    }
    
      // <--- THÊM PHƯƠNG THỨC doPost ĐỂ XỬ LÝ VIỆC DUYỆT/TỪ CHỐI
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cần đảm bảo encoding là UTF-8 để nhận ký tự tiếng Việt
        request.setCharacterEncoding("UTF-8"); 
        
        // Gọi updateStatus trong doPost
        try {
            updateTourStatus(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            // Nếu có lỗi, chuyển hướng về trang list
            try {
                listPendingTours(request, response);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }
    
     // THÊM PHƯƠNG THỨC doPost ĐỂ XỬ LÝ VIỆC DUYỆT/TỪ CHỐI --->

    private void listPendingTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Tour> pendingTours = tourDao.getPendingTours();
        request.setAttribute("tours", pendingTours);
        request.getRequestDispatcher("/views/manager/tour-approval.jsp").forward(request, response);
    }

    // <--- CẬP NHẬT PHƯƠNG THỨC updateTourStatus
    private void updateTourStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action"); // action là 'approve' hoặc 'reject'
        String rejectionReason = request.getParameter("rejectionReason"); // Lý do từ chối

        String statusToUpdate = null;
        String reasonToSave = null;

        if ("approve".equalsIgnoreCase(action)) {
            statusToUpdate = "APPROVED";
            reasonToSave = null; // Không cần lý do khi duyệt
        } else if ("reject".equalsIgnoreCase(action)) {
            statusToUpdate = "REJECTED";
            // Đảm bảo lý do không null, nếu user không nhập thì có thể là chuỗi rỗng
            reasonToSave = rejectionReason != null ? rejectionReason.trim() : "Không có lý do cụ thể."; 
        }

        if (statusToUpdate != null) {
            // Gọi DAO với 3 tham số
           // tourDao.updateTourStatus(id, statusToUpdate, reasonToSave);
        }
        
        // Chuyển hướng về trang danh sách sau khi hoàn tất
        response.sendRedirect(request.getContextPath() + "/manager/tour-approval");
    }
    // CẬP NHẬT PHƯƠNG THỨC updateTourStatus --->
}
    

