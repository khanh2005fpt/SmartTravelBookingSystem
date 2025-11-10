
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nfs://netbeans/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile.avatar;

import dao.CustomerDao;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import model.CustomerProfile;

/**
 *
 * @author nqagh
 */
@WebServlet(name = "Upload_AvatarServlet", urlPatterns = {"/Upload_AvatarServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB: tạm lưu trong bộ nhớ trước khi ghi ra file
    maxFileSize = 1024 * 1024 * 5,       // 5MB: dung lượng tối đa 1 file
    maxRequestSize = 1024 * 1024 * 50    // 50MB: tổng dung lượng tất cả file
)

public class UploadAvatarServlet extends HttpServlet {

    public CustomerDao customerDao;

    @Override
    public void init() throws ServletException {
        try {
            customerDao = CustomerDao.INSTANCE;
            System.out.println("profileDAO initialized successfully in loginServlet");
        } catch (Exception e) {
            System.out.println("Error initializing profileDAO in loginServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize information", e);
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Upload_AvatarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Upload_AvatarServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      request.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     // Kiểm tra session
  HttpSession session = request.getSession();
if (session == null || session.getAttribute("profile_customer") == null) {
      session.setAttribute("errorMess", "Tài khoản này chưa có profile, vui lòng đăng ký!");
    response.sendRedirect(request.getContextPath() + "/views/account/login.jsp");
    return;
}
System.out.println("Session ID: " + session.getId());
System.out.println("Profile in session: " + session.getAttribute("profile_customer"));

    // Lấy profile từ session
    CustomerProfile profile = (CustomerProfile) session.getAttribute("profile_customer");
    String userIdStr = String.valueOf(profile.getUserId());
    String error = null;
    String avatar = null;

    // Kiểm tra file upload
    Part filePart = request.getPart("avatarFile");
    if (filePart != null && filePart.getSize() > 0) {
        String fileName = filePart.getSubmittedFileName();
        if (fileName != null && !fileName.isBlank()) {
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            // Kiểm tra định dạng file
            if (!fileExtension.equals(".jpg") && !fileExtension.equals(".png") && !fileExtension.equals(".jpeg")) {
                error = "Định dạng không hợp lệ. Chỉ chấp nhận .png, .jpg, .jpeg. Vui lòng chọn lại ảnh!";
            } else {
                // Kiểm tra kích thước file (<= 5MB)
                long maxSize = 5 * 1024 * 1024;
                if (filePart.getSize() > maxSize) {
                    error = "Kích thước ảnh vượt quá 5 MB. Vui lòng chọn ảnh nhỏ hơn.";
                } else {
                    // Thư mục lưu file
                    String uploadDir = getServletContext().getRealPath("/web/views/UploadData/Avatars");
                    System.out.println("uploadDir: " + uploadDir); // Log để kiểm tra
                    File uploadPath = new File(uploadDir);
                    if (!uploadPath.exists()) {
                        uploadPath.mkdirs();
                        System.out.println("Created directory: " + uploadDir);
                    }
                    String uniqueName = "avatar_" + System.currentTimeMillis() + fileExtension;
                    String filePath = uploadDir + File.separator + uniqueName;

                    // Xóa file avatar cũ nếu có
                    if (profile.getProfilePicture() != null && !profile.getProfilePicture().isEmpty()) {
                        File oldFile = new File(uploadDir, profile.getProfilePicture());
                        try {
                            Files.deleteIfExists(oldFile.toPath());
                        } catch (IOException ex) {
                            System.err.println("Không thể xóa avatar cũ: " + ex.getMessage());
                        }
                    }

                    // Ghi file mới
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    } catch (IOException e) {
                        error = "Lỗi khi tải lên file: " + e.getMessage();
                    }
                    avatar = uniqueName;
                }
            }
        }
    } else {
        avatar = request.getParameter("oldAvatar");
        if (avatar == null || avatar.isBlank()) {
            error = "Không có file được tải lên và không có avatar cũ.";
        }
    }

    // Xử lý lỗi nếu có
    if (error != null) {
        session.setAttribute("errorMessage", error);
        response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
        return;
    }

    // Cập nhật database
    try {
      boolean updated = customerDao.updateProfilePicture(profile.getUserId(), avatar);
        System.out.println("DB update result: " + updated); // ← Bạn thấy in ra false?
    } catch (Exception e) {
        // Xóa file vừa tải lên nếu cập nhật database thất bại
        if (filePart != null && filePart.getSize() > 0) {
            Files.deleteIfExists(Paths.get(getServletContext().getRealPath("/web/views/UploadData/Avatars"), avatar));
        }
        session.setAttribute("errorMessage", "Lỗi khi cập nhật avatar trong cơ sở dữ liệu.");
        response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
        return;
    }

    // Cập nhật session
    profile.setProfilePicture(avatar);
    session.setAttribute("profile_customer", profile);

    // Chuyển hướng với thông báo thành công
    session.setAttribute("successMessage", "Cập nhật avatar thành công.");
    response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?ts=" + System.currentTimeMillis());
}

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
