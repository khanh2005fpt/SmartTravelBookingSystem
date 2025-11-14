package controller.manager;

import dao.IslandDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Island; 
import model.User;

@WebServlet(name = "IslandApprovalManagerServlet", urlPatterns = {"/manager/island-approval"})
public class IslandApprovalManagerServlet extends HttpServlet {

    private IslandDao islandDao;

    @Override
    public void init() throws ServletException {
        try {
        
            islandDao = new IslandDao();
        } catch (Exception e) {
           
            throw new ServletException("Không thể khởi tạo IslandDao", e);
        }
    }

   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

          HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
            if (!isStaffAuthorized(session, request, response)) {
        return;
    }


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
    
    private boolean isStaffAuthorized(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
    if (session == null) {
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return false;
    }

    User user = (User) session.getAttribute("user");
    if (user == null) {
        session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
        response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
        return false;
    }

    // Map roleId -> roleName
 String role;
        switch (user.getRoleId()) {
            case 1:
                role = "ADMIN";
                break;
            case 2:
                role = "BOOKING MANAGER";
                break;
            case 3:
                role = "CUSTOMER";
                break;
            default:
                role = "STAFF";
                break;
        }

        if (!"BOOKING MANAGER".equals(role) && !"ADMIN".equals(role)) {
            session.setAttribute("errorMess", "Bạn không có quyền truy cập!");
            response.sendRedirect(request.getContextPath() + "/views/account/access_denied.jsp");
            return false;
        }

        return true;
    }

    
    
}