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

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        try {
            List<Favorite> favorites = dao.getFavoritesByUser(userId);
            req.setAttribute("favoriteList", favorites);

            // forward về trang profile.jsp, hiển thị tab favorites
            req.getRequestDispatcher("/views/customer_profile/profile.jsp?section=favorites")
               .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải danh sách yêu thích.");
            req.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(req, resp);
        }
    }
}
