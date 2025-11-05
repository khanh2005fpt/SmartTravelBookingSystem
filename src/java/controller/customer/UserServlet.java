package controller.customer;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.User;

@WebServlet(name = "UserServlet", urlPatterns = {"/manager/user"})
public class UserServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDao dao = new UserDao();
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {

                case "view":
                    int id = Integer.parseInt(request.getParameter("id"));
                    User user = dao.getUserById(id);
                    request.setAttribute("user", user);
                    request.setAttribute("roles", dao.getAllRoles());
                    request.setAttribute("statuses", dao.getAllStatuses());
                    request.getRequestDispatcher("/views/manager/customer_view.jsp").forward(request, response);
                    return;

                case "searchUsername":
                    searchByUsername(request, response, dao);
                    return;

                case "searchFullName":
                    searchByFullName(request, response, dao);
                    return;

                case "searchEmail":
                    searchByEmail(request, response, dao);
                    return;

                case "searchRole":
                    searchByRole(request, response, dao);
                    return;

                case "searchStatus":
                    searchByStatus(request, response, dao);
                    return;

                default:
                    listUsers(request, response, dao);
                    return;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    // ========================== LIST ==========================
    private void listUsers(HttpServletRequest request, HttpServletResponse response, UserDao dao)
            throws SQLException, ServletException, IOException {

        int page = 1;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        int offset = (page - 1) * PAGE_SIZE;

        List<User> users = dao.getAllUsers(offset, PAGE_SIZE);
        int total = dao.getTotalUsers();
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("users", users);
        request.setAttribute("roles", dao.getAllRoles());
        request.setAttribute("statuses", dao.getAllStatuses());
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/views/manager/customer_list.jsp").forward(request, response);
    }

    // ========================== SEARCH ==========================

    private void searchByUsername(HttpServletRequest request, HttpServletResponse response, UserDao dao)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<User> users = dao.searchByUsername(keyword);
        forwardSearch(request, response, dao, users);
    }

    private void searchByFullName(HttpServletRequest request, HttpServletResponse response, UserDao dao)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<User> users = dao.searchByFullName(keyword);
        forwardSearch(request, response, dao, users);
    }

    private void searchByEmail(HttpServletRequest request, HttpServletResponse response, UserDao dao)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<User> users = dao.searchByEmail(keyword);
        forwardSearch(request, response, dao, users);
    }

    private void searchByRole(HttpServletRequest request, HttpServletResponse response, UserDao dao)
            throws SQLException, ServletException, IOException {
        String roleId = request.getParameter("roleId");
        List<User> users;
        if (roleId == null || roleId.isEmpty()) {
            users = dao.getAllUsers(0, PAGE_SIZE);
        } else {
            users = dao.searchByRole(Integer.parseInt(roleId));
        }
        forwardSearch(request, response, dao, users);
    }

    private void searchByStatus(HttpServletRequest request, HttpServletResponse response, UserDao dao)
            throws SQLException, ServletException, IOException {
        String status = request.getParameter("status");
        List<User> users;
        if (status == null || status.isEmpty()) {
            users = dao.getAllUsers(0, PAGE_SIZE);
        } else {
            users = dao.searchByStatus(status);
        }
        forwardSearch(request, response, dao, users);
    }

    private void forwardSearch(HttpServletRequest request, HttpServletResponse response, UserDao dao, List<User> users)
            throws SQLException, ServletException, IOException {
        request.setAttribute("users", users);
        request.setAttribute("roles", dao.getAllRoles());
        request.setAttribute("statuses", dao.getAllStatuses());
        request.setAttribute("page", 1);
        request.setAttribute("totalPages", 1);
        request.getRequestDispatcher("/views/manager/customer_list.jsp").forward(request, response);
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST not supported");
    }

    @Override
    public String getServletInfo() {
        return "User Management Servlet — list, view, search, and filter users (no add/update)";
    }
}
