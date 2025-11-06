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
            case "addForm":
                showAddForm(req, resp);
                break;
            case "editForm":
                showEditForm(req, resp);
                break;
            default:
                listUsers(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect("user?action=list");
            return;
        }

        switch (action) {
            case "add":
                addUser(req, resp);
                break;
            case "update":
                updateUser(req, resp);
                break;
            default:
                resp.sendRedirect("user?action=list");
        }
    }

    // ===================== ADD USER =====================
    private void addUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");
        int roleId = Integer.parseInt(req.getParameter("roleId"));

        // Kiểm tra trùng username/email
        if (dao.checkUsernameExist(username) || dao.checkEmailExist(email)) {
            req.setAttribute("error", "Tên đăng nhập hoặc Email đã tồn tại!");
            req.getRequestDispatcher("../views/user/addUser.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setStatus(status);
        user.setRoleId(roleId);

        boolean success = dao.addUser(user);
        if (success) {
            resp.sendRedirect("user?action=list");
        } else {
            req.setAttribute("error", "Không thể thêm người dùng mới!");
            req.getRequestDispatcher("../views/user/addUser.jsp").forward(req, resp);
        }
    }

    // ===================== UPDATE USER =====================
    private void updateUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");
        int roleId = Integer.parseInt(req.getParameter("roleId"));

        User user = dao.getUserById(userId);
        if (user == null) {
            req.setAttribute("error", "Không tìm thấy người dùng cần cập nhật!");
            req.getRequestDispatcher("../views/user/updateUser.jsp").forward(req, resp);
            return;
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setStatus(status);
        user.setRoleId(roleId);

        boolean success = dao.updateUser(user);
        if (success) {
            resp.sendRedirect("user?action=list");
        } else {
            req.setAttribute("error", "Cập nhật thất bại!");
            req.getRequestDispatcher("../views/user/updateUser.jsp").forward(req, resp);
        }
    }

    // ===================== SHOW ADD FORM =====================
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("../views/user/addUser.jsp").forward(req, resp);
    }

    // ===================== SHOW EDIT FORM =====================
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        User user = dao.getUserById(userId);
        if (user == null) {
            resp.sendRedirect("user?action=list");
            return;
        }
        req.setAttribute("user", user);
        req.getRequestDispatcher("../views/user/updateUser.jsp").forward(req, resp);
    }

    // ===================== AJAX DETAIL =====================
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

    // ===================== LIST USERS =====================
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

    // ===================== SEARCH USERS =====================
    private void searchUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        int page = getPage(req);
        List<User> users = dao.searchUsers(keyword, page, 10);
        req.setAttribute("users", users);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("../views/user/userList.jsp").forward(req, resp);
    }

    // ===================== FILTER USERS =====================
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

    // ===================== UPDATE STATUS =====================
    private void updateStatus(HttpServletRequest req, HttpServletResponse resp, String status)
            throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        dao.updateUserStatus(userId, status);
        resp.sendRedirect("user?action=list");
    }

    // ===================== PAGINATION HELPER =====================
    private int getPage(HttpServletRequest req) {
        String pageParam = req.getParameter("page");
        return (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    }
}
