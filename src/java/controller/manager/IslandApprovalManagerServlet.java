package controller.manager;

import dao.IslandDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Island; 

@WebServlet(name = "IslandApprovalManagerServlet", urlPatterns = {"/manager/island-approval"})
public class IslandApprovalManagerServlet extends HttpServlet {

    private IslandDao islandDao;

    @Override
    public void init() throws ServletException {
        try {
            // Khởi tạo IslandDao
            islandDao = new IslandDao();
        } catch (Exception e) {
            // Xử lý ngoại lệ nếu khởi tạo DAO thất bại
            throw new ServletException("Không thể khởi tạo IslandDao", e);
        }
    }

   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ... (xóa logic duyệt/từ chối khỏi doGet, chỉ giữ lại phần list) ...

        try {
            // Giữ doGet chỉ để list (hiển thị trang duyệt)
            listPendingIslands(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/manager/island-approval.jsp").forward(request, response);
        }
    }
    
    // ⭐ THÊM PHƯƠNG THỨC doPost ĐỂ XỬ LÝ VIỆC DUYỆT/TỪ CHỐI
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 
        
        try {
            updateIslandStatus(request, response); // Gọi phương thức mới (không còn tham số status)
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            // Nếu có lỗi, chuyển hướng về trang list
            try {
                listPendingIslands(request, response);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }
    // THÊM PHƯƠNG THỨC doPost ĐỂ XỬ LÝ VIỆC DUYỆT/TỪ CHỐI --->

    private void listPendingIslands(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Island> pendingIslands = islandDao.getPendingIslands();
        request.setAttribute("islands", pendingIslands);
        request.getRequestDispatcher("/views/manager/island-approval.jsp").forward(request, response);
    }

    // ⭐ CẬP NHẬT PHƯƠNG THỨC updateIslandStatus
    private void updateIslandStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action"); // Lấy action từ form (approve/reject)
        String rejectionReason = request.getParameter("rejectionReason"); // Lấy lý do từ chối

        String statusToUpdate = null;
        String reasonToSave = null;

        if ("approve".equalsIgnoreCase(action)) {
            statusToUpdate = "APPROVED";
            reasonToSave = null;
        } else if ("reject".equalsIgnoreCase(action)) {
            statusToUpdate = "REJECTED";
            reasonToSave = rejectionReason != null ? rejectionReason.trim() : "Không có lý do cụ thể."; 
        }

        if (statusToUpdate != null) {
            // Gọi DAO với 3 tham số
            islandDao.updateIslandStatus(id, statusToUpdate, reasonToSave);
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/island-approval");
    }
}