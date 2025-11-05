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
        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "list":
            case "search": {
                String name = request.getParameter("name");
                String type = request.getParameter("type");
                String priceMinRaw = request.getParameter("priceMin");
                String priceMaxRaw = request.getParameter("priceMax");
                String status = request.getParameter("status");
                String sort = request.getParameter("sort");

                Double priceMin = null, priceMax = null;
                try {
                    if (priceMinRaw != null && !priceMinRaw.isEmpty()) {
                        priceMin = Double.parseDouble(priceMinRaw);
                    }
                    if (priceMaxRaw != null && !priceMaxRaw.isEmpty()) {
                        priceMax = Double.parseDouble(priceMaxRaw);
                    }
                } catch (NumberFormatException ignored) {
                }

                int pageIndex = 1;
                int pageSize = 10;
                try {
                    String pageRaw = request.getParameter("page");
                    if (pageRaw != null) {
                        pageIndex = Integer.parseInt(pageRaw);
                    }
                } catch (NumberFormatException e) {
                    pageIndex = 1;
                }

                List<Service> services = dao.searchServices(name, type, priceMin, priceMax, status, sort);

                int total = services.size();
                int totalPages = (int) Math.ceil((double) total / pageSize);
                int fromIndex = (pageIndex - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, total);
                List<Service> pagedList = new ArrayList<>();
                if (fromIndex < toIndex) {
                    pagedList = services.subList(fromIndex, toIndex);
                }

                request.setAttribute("services", pagedList);
                request.setAttribute("page", pageIndex);
                request.setAttribute("totalPages", totalPages);

                request.setAttribute("search_name", name);
                request.setAttribute("search_type", type);
                request.setAttribute("search_priceMin", priceMinRaw);
                request.setAttribute("search_priceMax", priceMaxRaw);
                request.setAttribute("search_status", status);
                request.setAttribute("sort", sort);

                request.getRequestDispatcher("/views/manager/service_list.jsp").forward(request, response);
                break;
            }

            // 🟢 ĐÃ THAY ĐỔI TỪ "update" -> "detail"
            case "detail": {
                String type = request.getParameter("type");
                int id = Integer.parseInt(request.getParameter("id"));

                Map<String, Object> data = dao.getServiceDetail(type, id);

                request.setAttribute("id", id);
                request.setAttribute("type", type);
                request.setAttribute("data", data);

                // ✅ Chuyển hướng sang trang xem chi tiết thay vì cập nhật
                request.getRequestDispatcher("/views/manager/service_detail.jsp").forward(request, response);
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/manager/service?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu chỉ dùng để xem chi tiết, không cần post update nữa
        response.sendRedirect(request.getContextPath() + "/manager/service?action=list");
    }
}
