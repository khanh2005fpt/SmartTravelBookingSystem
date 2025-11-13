package controller.dashboard;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.SystemDao;
import model.DashboardOverview;
import model.User;


@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private SystemDao systemDao;

    @Override
    public void init() throws ServletException {
        systemDao = new SystemDao();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     HttpSession session = request.getSession(false);
           if (!isStaffAuthorized(session, request, response)) {
        return;
    }

        
        
        DashboardOverview dashboard = systemDao.getDashboardOverview();

        request.setAttribute("dashboard", dashboard);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/dashboard.jsp");
        dispatcher.forward(request, response);
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
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
