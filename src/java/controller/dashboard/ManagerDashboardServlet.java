package controller.dashboard;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.SystemDao;
import model.DashboardOverview;


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

        DashboardOverview dashboard = systemDao.getDashboardOverview();

        request.setAttribute("dashboard", dashboard);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/manager/dashboard.jsp");
        dispatcher.forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
