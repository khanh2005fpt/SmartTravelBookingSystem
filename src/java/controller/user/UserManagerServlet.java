package controller.user;

import dao.RoleDao;
import dao.userDao;
import model.User;
import model.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin/user")
public class UserManagerServlet extends HttpServlet {

    private final userDao dao = userDao.INSTANCE;
    private final RoleDao roleDao = RoleDao.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

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
            case "add":
                showAddForm(req, resp);
                break;
            case "edit":
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
        if (action == null) action = "";

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

    // ====== HIỂN THỊ DANH SÁCH NGƯỜI DÙNG ======
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

    // ====== AJAX LẤY CHI TIẾT USER ======
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

    // ====== FILTER / SEARCH ======
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

    // ====== CẬP NHẬT TRẠNG THÁI ======
    private void updateStatus(HttpServletRequest req, HttpServletResponse resp, String status)
            throws IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        dao.updateUserStatus(userId, status);
        resp.sendRedirect("user?action=list");
    }

    // ====== THÊM NGƯỜI DÙNG ======
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Role> roles = roleDao.getAllRoles();
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("../views/user/addUser.jsp").forward(req, resp);
    }

    private void addUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");
        int roleId = Integer.parseInt(req.getParameter("roleId"));

        if (username == null || password == null || email == null ||
            username.isEmpty() || password.isEmpty() || email.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đủ các trường bắt buộc!");
            List<Role> roles = roleDao.getAllRoles();
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("../views/user/addUser.jsp").forward(req, resp);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        User user = new User();
        user.setUsername(username);
        user.setPassword(hashedPassword);
        user.setEmail(email);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setRoleId(roleId);
        user.setStatus(status != null ? status : "ACTIVE");

        boolean success = dao.addUser(user);
        if (success) {
            resp.sendRedirect("user?action=list");
        } else {
            req.setAttribute("error", "Không thể thêm người dùng mới!");
            List<Role> roles = roleDao.getAllRoles();
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("../views/user/addUser.jsp").forward(req, resp);
        }
    }

    // ====== CHỈNH SỬA NGƯỜI DÙNG ======
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        User user = dao.getUserById(userId);
        List<Role> roles = roleDao.getAllRoles();
        req.setAttribute("roles", roles);
        req.setAttribute("user", user);
        req.getRequestDispatcher("../views/user/editUser.jsp").forward(req, resp);
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int userId = Integer.parseInt(req.getParameter("userId"));
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");
        int roleId = Integer.parseInt(req.getParameter("roleId"));

        User user = dao.getUserById(userId);
        if (user == null) {
            req.setAttribute("error", "Không tìm thấy người dùng!");
            List<Role> roles = roleDao.getAllRoles();
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("../views/user/editUser.jsp").forward(req, resp);
            return;
        }

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRoleId(roleId);
        user.setStatus(status);

        boolean updated = dao.updateUserInfo(user);
        if (updated) {
            resp.sendRedirect("user?action=list");
        } else {
            req.setAttribute("error", "Không thể cập nhật người dùng!");
            List<Role> roles = roleDao.getAllRoles();
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("../views/user/editUser.jsp").forward(req, resp);
        }
    }
//lấy số trang hiện tại
    private int getPage(HttpServletRequest req) {
        String pageParam = req.getParameter("page");
        return (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    }
}
