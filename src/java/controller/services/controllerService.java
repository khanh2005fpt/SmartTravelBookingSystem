package controller.services;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import dao.ServiceDao;
import model.Service;

@WebServlet("/manager/service")
public class controllerService extends HttpServlet {

    private final ServiceDao dao = new ServiceDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            // === 1️⃣ DANH SÁCH + TÌM KIẾM + SẮP XẾP ===
            case "list":
            case "search": {
                // Lấy tham số tìm kiếm / sắp xếp
                String name = request.getParameter("name");
                String type = request.getParameter("type");
                String priceMinRaw = request.getParameter("priceMin");
                String priceMaxRaw = request.getParameter("priceMax");
                String status = request.getParameter("status");
                String sort = request.getParameter("sort");

                Double priceMin = null, priceMax = null;
                try {
                    if (priceMinRaw != null && !priceMinRaw.isEmpty())
                        priceMin = Double.parseDouble(priceMinRaw);
                    if (priceMaxRaw != null && !priceMaxRaw.isEmpty())
                        priceMax = Double.parseDouble(priceMaxRaw);
                } catch (NumberFormatException ignored) {}

                // Lấy trang hiện tại
                int pageIndex = 1;
                int pageSize = 10;
                try {
                    String pageRaw = request.getParameter("page");
                    if (pageRaw != null) pageIndex = Integer.parseInt(pageRaw);
                } catch (NumberFormatException e) { pageIndex = 1; }

                // Gọi DAO để lấy danh sách dịch vụ (lọc + sắp xếp)
                List<Service> services = dao.searchServices(name, type, priceMin, priceMax, status, sort);

                // Cắt phân trang trong Java (đơn giản)
                int total = services.size();
                int totalPages = (int) Math.ceil((double) total / pageSize);
                int fromIndex = (pageIndex - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, total);
                List<Service> pagedList = new ArrayList<>();
                if (fromIndex < toIndex) {
                    pagedList = services.subList(fromIndex, toIndex);
                }

                // Gửi dữ liệu sang JSP
                request.setAttribute("services", pagedList);
                request.setAttribute("page", pageIndex);
                request.setAttribute("totalPages", totalPages);

                // Giữ lại giá trị đã search
                request.setAttribute("search_name", name);
                request.setAttribute("search_type", type);
                request.setAttribute("search_priceMin", priceMinRaw);
                request.setAttribute("search_priceMax", priceMaxRaw);
                request.setAttribute("search_status", status);
                request.setAttribute("sort", sort);

                request.getRequestDispatcher("/views/manager/service_list.jsp").forward(request, response);
                break;
            }

            // === 2️⃣ TRANG CẬP NHẬT ===
            case "update": {
                String type = request.getParameter("type");
                int id = Integer.parseInt(request.getParameter("id"));

                Map<String, Object> data = dao.getServiceDetail(type, id);

                request.setAttribute("id", id);
                request.setAttribute("type", type);
                request.setAttribute("data", data);

                request.getRequestDispatcher("/views/manager/service_update.jsp").forward(request, response);
                break;
            }

            // === 3️⃣ MẶC ĐỊNH: chuyển về danh sách ===
            default:
                response.sendRedirect(request.getContextPath() + "/manager/service?action=list");
        }
    }

    // === 4️⃣ POST: CẬP NHẬT DỊCH VỤ ===
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        int id = Integer.parseInt(request.getParameter("id"));
        Map<String, Object> form = new HashMap<>();

        try {
            switch (type) {
                case "Hotel":
                    form.put("name", request.getParameter("name"));
                    form.put("price", Double.parseDouble(request.getParameter("price")));
                    form.put("rooms", Integer.parseInt(request.getParameter("rooms")));
                    form.put("rating", Float.parseFloat(request.getParameter("rating")));
                    break;

                case "Flight":
                    form.put("flightNumber", request.getParameter("flightNumber"));
                    form.put("departure", request.getParameter("departure"));
                    form.put("destination", request.getParameter("destination"));
                    form.put("price", Double.parseDouble(request.getParameter("price")));
                    form.put("tickets", Integer.parseInt(request.getParameter("tickets")));
                    break;

                case "Vehicle":
                    form.put("modelName", request.getParameter("modelName"));
                    form.put("price", Double.parseDouble(request.getParameter("price")));
                    form.put("available", Integer.parseInt(request.getParameter("available")));
                    break;

                case "Place":
                    form.put("placeName", request.getParameter("placeName"));
                    form.put("price", Double.parseDouble(request.getParameter("price")));
                    form.put("hasTicket", Boolean.parseBoolean(request.getParameter("hasTicket")));
                    break;
            }

            boolean updated = dao.updateService(type, id, form);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/manager/service?action=list");
            } else {
                request.setAttribute("error", "Update failed!");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid data format!");
            doGet(request, response);
        }
    }
}
