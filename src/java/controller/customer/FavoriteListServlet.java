package controller.customer;

import dao.CustomerDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Favorite;
import model.User;

@WebServlet("/customer/favorites")
public class FavoriteListServlet extends HttpServlet {

    private final CustomerDao dao = CustomerDao.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
   HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            session.setAttribute("errorMess", "Vui lòng đăng nhập để tiếp tục!");
            resp.sendRedirect(req.getContextPath() + "/views/account/login.jsp");
            return;
        }

        int roleId = currentUser.getRoleId();
        if (roleId != 1 && roleId != 3) {
            session.setAttribute("errorMess", "Bạn không có quyền truy cập trang này!");
            resp.sendRedirect(req.getContextPath() + "/views/account/access_denied.jsp");
            return;
        }
        // Lấy section từ navbar
    String section = req.getParameter("section");
    if (section == null || section.isEmpty()) {
        section = "account"; // mặc định
    }
        try {
            int userId = currentUser.getUserId();
            List<Favorite> favorites = dao.getFavoritesByUser(userId);
            req.setAttribute("favoriteList", favorites);
             req.setAttribute("section", section);

            // forward về trang profile.jsp, hiển thị tab favorites
            req.getRequestDispatcher("/views/customer_profile/profile.jsp?section=favorites#")
               .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải danh sách yêu thích.");
            req.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(req, resp);
        }
    }
}
