package controller.profile.avatar;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 *
 * @author nqagh
 */
@WebServlet(name = "Avatar_DisplayServlet", urlPatterns = {"/Avatar_DisplayServlet"})
public class AvatarDisplayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tên file từ tham số
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tên file");
            return;
        }

        // Đường dẫn lưu file (đồng bộ với UploadAvatarServlet)
        String uploadDir = getServletContext().getRealPath("/web/views/UploadData/Avatars");
        File file = new File(uploadDir, fileName);
        System.out.println("Trying to display file: " + file.getAbsolutePath()); // Log để debug

        // Kiểm tra file tồn tại
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ảnh không tồn tại: " + file.getAbsolutePath());
            return;
        }

        // Xác định MIME type
        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) {
            mime = "application/octet-stream";
        }
        response.setContentType(mime);

        // Đọc và stream ảnh
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi đọc file: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST giống GET
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}