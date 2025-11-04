/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.home;

import dao.IslandDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Country;
import model.Island;

/**
 *
 * @author Admin
 */
public class SearchIslandController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        doGet(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String country = request.getParameter("country");
        String bestSeason = request.getParameter("bestSeason");

// Lấy số trang hiện tại từ request, mặc định trang 1
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = 6; // so dao moi trang
        IslandDao id = new IslandDao();
        List<Country> countries = null;
        try {
            countries = id.getAllCountries();
        } catch (SQLException ex) {
            Logger.getLogger(SearchIslandController.class.getName()).log(Level.SEVERE, null, ex);
        }
        // Lay tong so dao theo dieu kien tim kiem
        int totalIslands = 0;
        try {
            totalIslands = id.getTotalIslands(); // Lay tong so dao

        } catch (SQLException ex) {
            Logger.getLogger(SearchIslandController.class.getName()).log(Level.SEVERE, null, ex);
        }
        int totalPages = (int) Math.ceil((double) totalIslands / pageSize);

        // Lay danh sach dao tim kiem va phan trang
        List<Island> list = null;
        try {
            list = id.searchIslands(country, bestSeason);
        } catch (SQLException ex) {
            Logger.getLogger(SearchIslandController.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Phan trang danh sach dao sau khi tim kiem
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, list.size());
        List<Island> pagedList = new ArrayList<>();
        if (list.size() < pageSize) {
            totalPages = 1;
        }
        if (fromIndex <= toIndex) {
            pagedList = list.subList(fromIndex, toIndex);
        }
        request.setAttribute("countries", countries);
        request.setAttribute("islands", pagedList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/home/index.jsp").forward(request, response);

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
