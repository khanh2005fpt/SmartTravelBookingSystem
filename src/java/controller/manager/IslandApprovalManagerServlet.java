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

        // Lấy tham số hành động (approve, reject, list)
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "approve":
                    updateIslandStatus(request, response, "APPROVED");
                    break;
                case "reject":
                    updateIslandStatus(request, response, "REJECTED");
                    break;
                default:
                    listPendingIslands(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            // Chuyển tiếp đến trang JSP duyệt đảo khi có lỗi
            request.getRequestDispatcher("/views/manager/island-approval.jsp").forward(request, response);
        }
    }

    private void listPendingIslands(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Island> pendingIslands = islandDao.getPendingIslands();
        request.setAttribute("islands", pendingIslands); // Đặt danh sách vào request attribute
        request.getRequestDispatcher("/views/manager/island-approval.jsp").forward(request, response);
    }

    private void updateIslandStatus(HttpServletRequest request, HttpServletResponse response, String status)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        islandDao.updateIslandStatus(id, status);
        // Chuyển hướng về trang duyệt đảo sau khi cập nhật thành công
        response.sendRedirect(request.getContextPath() + "/manager/island-approval");
    }
}