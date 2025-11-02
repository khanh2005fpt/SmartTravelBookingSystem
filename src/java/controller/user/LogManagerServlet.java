package controller.user;

import dao.LogDAO;
import dao.RoleDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Log;
import model.Role;

@WebServlet(name = "LogManagerServlet", urlPatterns = {"/admin/logs"})
public class LogManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LogDAO logDao = new LogDAO();
        RoleDAO roleDao = new RoleDAO();

        // Lấy dropdown từ DB
        List<Role> roleList = roleDao.getAllRoles();
        List<String> actionList = logDao.getAllActions();

        String id = request.getParameter("id");
        String searchUser = request.getParameter("searchUser");
        String searchAction = request.getParameter("searchAction");
        String searchRole = request.getParameter("searchRole");

        // 1️⃣ Xem chi tiết log
        if (id != null) {
            int logId = Integer.parseInt(id);
            Log log = logDao.getLogById(logId);
            request.setAttribute("log", log);
            request.setAttribute("roles", roleList);
            request.setAttribute("actions", actionList);
            request.getRequestDispatcher("/views/admin/log_detail.jsp").forward(request, response);
            return;
        }

        List<Log> logs;

        // 2️⃣ Tìm theo User
        if (searchUser != null && !searchUser.trim().isEmpty()) {
            logs = logDao.searchLogsByUser(searchUser.trim());
            request.setAttribute("keywordUser", searchUser);
        }
        // 3️⃣ Lọc theo Action
        else if (searchAction != null && !searchAction.equalsIgnoreCase("ALL")) {
            logs = logDao.searchLogsByAction(searchAction);
            request.setAttribute("selectedAction", searchAction);
        }
        // 4️⃣ Lọc theo Role
        else if (searchRole != null && !searchRole.equalsIgnoreCase("ALL")) {
            logs = logDao.searchLogsByRole(searchRole);
            request.setAttribute("selectedRole", searchRole);
        }
        // 5️⃣ Hiển thị toàn bộ
        else {
            logs = logDao.getAllLogs();
        }

        // Set các list dropdown
        request.setAttribute("logs", logs);
        request.setAttribute("roles", roleList);
        request.setAttribute("actions", actionList);

        request.getRequestDispatcher("/views/admin/log_list.jsp").forward(request, response);
    }
}
