package controller.manager;

import dao.TourDao;
import model.Tour;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.User;

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

         HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
           if (!isStaffAuthorized(session, request, response)) {
        return;
    }
        try {
            listPendingTours(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/manager/tour-approval.jsp").forward(request, response);
        }
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
            tourDao.updateTourStatus(id, statusToUpdate, reasonToSave);
        }
        
        // Chuyển hướng về trang danh sách sau khi hoàn tất
        response.sendRedirect(request.getContextPath() + "/manager/tour-approval");
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