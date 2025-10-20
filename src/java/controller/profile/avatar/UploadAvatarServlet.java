/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
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
import java.nio.file.Path;//để truy xuất tệp đã tải lên từ client.
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import model.CustomerProfile;

/**
 *
 * @author nqagh
 */
@WebServlet(name="Upload_AvatarServlet", urlPatterns={"/Upload_AvatarServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB: tạm lưu trong bộ nhớ trước khi ghi ra file
    maxFileSize = 1024 * 1024 * 10,       // 10MB: dung lượng tối đa 1 file
    maxRequestSize = 1024 * 1024 * 50    // 15MB: tổng dung lượng tất cả file
   
)

public class UploadAvatarServlet extends HttpServlet {
   
     public CustomerDao customerDao;
   
       @Override
    public void init() throws ServletException {
        try {
            customerDao = CustomerDao.INSTANCE;
            System.out.println("profileDAO initialized successfully in loginServlet");
        } catch (Exception e) {
            System.out.println("Error initializingprofileDAO in loginServlet: " + e.getMessage());
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
            out.println("<h1>Servlet Upload_AvatarServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("/views/customer_profile/profile.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // xu lu upload
 
        
     
        // Lấy phần file từ form
        Part filePart = request.getPart("avatarFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp");
            return;
        }

        // Tên file gốc
        String originalName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dotIndex = originalName.lastIndexOf(".");
        if (dotIndex > 0) {
            ext = originalName.substring(dotIndex);
        }

        // Tạo tên file mới duy nhất (vd: avatar_20251011234855.jpg)
        String uniqueName = "avatar_" + System.currentTimeMillis() + ext;

       // Thư mục lưu file
        String uploadDir = "E:/FALL_2025/SWP/SmartBookingTravelSystem/UploadData/Avatars";
        File uploadPath = new File(uploadDir);
        if (!uploadPath.exists()) uploadPath.mkdirs();

        // Đường dẫn file đích
        Path filePath = Paths.get(uploadDir, uniqueName);

        // Ghi file vào thư mục
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        // Cập nhật vào session profile
        HttpSession session = request.getSession();
        CustomerProfile profile = (CustomerProfile) session.getAttribute("profile_customer");
        
        
  
        if (profile != null) {
            // Xóa file cũ nếu có
            if (profile.getProfilePicture() != null) {
                File oldFile = new File(uploadDir, profile.getProfilePicture());
                if (oldFile.exists()) {
                    try {
                        Files.deleteIfExists(oldFile.toPath());
                    } catch (IOException ex) {
                        System.err.println(" Không thể xóa avatar cũ: " + ex.getMessage());
                    }
                }
            }

        // 
    
    profile.setProfilePicture(uniqueName);
    session.setAttribute("profile_customer", profile);
        
        // update avatar trong db
       customerDao.updateProfilePicture(profile.getUserId(), uniqueName);
        
  //sendRedirect tránh cache ảnh cũ
 response.sendRedirect(request.getContextPath() + "/views/customer_profile/profile.jsp?ts=" + System.currentTimeMillis());
    }
        
       
    }
    

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
