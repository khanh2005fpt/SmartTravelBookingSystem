package controller.user;

import dao.UserDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/user")
public class UserManagerServlet extends HttpServlet {

    private final UserDao dao = UserDao.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "ban":
                updateStatus(req, resp, "LOCKED");
                break;
            case "activate":
                updateStatus(req, resp, "ACTIVE");
                break;
            case "search":
                searchUser(req, resp);
                break;
            case "filter":
                filterUser(req, resp);
                break;
            case "detail":
                getUserDetailAjax(req, resp);
                break;

            default:
                listUsers(req, resp);
        }
    }

    private void getUserDetailAjax(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        User user = dao.getUserById(userId);

        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\": \"Không tìm thấy người dùng\"}");
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{"
                + "\"userId\": " + user.getUserId() + ","
                + "\"username\": \"" + user.getUsername() + "\","
                + "\"fullName\": \"" + user.getFullName() + "\","
                + "\"email\": \"" + user.getEmail() + "\","
                + "\"phone\": \"" + user.getPhone() + "\","
                + "\"status\": \"" + user.getStatus() + "\""
                + "}");
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = getPage(req);
        int pageSize = 10;
        List<User> users = dao.getAllUsers(page, pageSize);
        int total = dao.getTotalUsers();
        int totalPages = (int) Math.ceil((double) total / pageSize);

        req.setAttribute("users", users);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("../views/user/userList.jsp").forward(req, resp);
    }

    private void searchUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        int page = getPage(req);
        List<User> users = dao.searchUsers(keyword, page, 10);
        req.setAttribute("users", users);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("../views/user/userList.jsp").forward(req, resp);
    }

    private void filterUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String status = req.getParameter("status");
        if (status == null || status.equals("ALL")) {
            listUsers(req, resp);
            return;
        }

        int page = getPage(req);
        List<User> users = dao.getUsersByStatus(status, page, 10);
        req.setAttribute("users", users);
        req.setAttribute("selectedStatus", status);
        req.getRequestDispatcher("../views/user/userList.jsp").forward(req, resp);
    }

    private void updateStatus(HttpServletRequest req, HttpServletResponse resp, String status)
            throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        dao.updateUserStatus(userId, status);
        resp.sendRedirect("user?action=list");
    }

    private int getPage(HttpServletRequest req) {
        String pageParam = req.getParameter("page");
        return (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    }
}
