/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.customer;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.User;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/manager/customer"})
public class CustomerServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    
    private static final String CUSTOMER_LIST_VIEW = "/views/customer/customerList.jsp";
    private static final String CUSTOMER_DETAIL_VIEW = "/views/customer/customerDetail.jsp";
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "detail":
                showCustomerDetail(req, resp);
                break;
            case "search":
                searchCustomers(req, resp);
                break;
            case "filter":
                filterCustomers(req, resp);
                break;
            default:
                listCustomers(req, resp);
                break;
        }
    }

    private void listCustomers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        List<User> list = customerDAO.getAllCustomers(page, pageSize);
        int totalCustomers = customerDAO.getTotalCustomers();
        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);

        req.setAttribute("customers", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher(CUSTOMER_LIST_VIEW).forward(req, resp);
    }

    private void showCustomerDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        User customer = customerDAO.getCustomerById(id);
        req.setAttribute("customer", customer);
        req.getRequestDispatcher(CUSTOMER_DETAIL_VIEW).forward(req, resp);
    }

    private void searchCustomers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";

        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        List<User> list = customerDAO.searchCustomers(keyword, page, pageSize);
        req.setAttribute("customers", list);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("views/customer/customerList.jsp").forward(req, resp);
    }

    private void filterCustomers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String status = req.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "ALL";
        }

        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        List<User> list = customerDAO.filterCustomersByStatus(status, page, pageSize);
        req.setAttribute("customers", list);
        req.setAttribute("status", status);
        req.getRequestDispatcher("views/customer/customerList.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
