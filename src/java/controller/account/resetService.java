/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.account;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;


/**
 *
 * @author nqagh
 */
public class resetService {

    // nqaghuyyy6969@gmail.com mail Server
    public final String from = "nqaghuyyy6969@gmail.com";
    // tao lay password ung dung tren google
    public final String password = "hcfj ldgb yyhh ssyc";

    // Sinh OTP 6 chữ số
    public static final SecureRandom random = new SecureRandom();
    private final int LIMIT_MINUS = 5;

    public String generateOtp() {
        int otp = 100000 + random.nextInt(900000); // từ 100000 -> 999999
        return String.valueOf(otp);
    }
    // Sinh token (UUID)

    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    //time ton tai otp
    public LocalDateTime expireDateTime() {
        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
    }

    // CHECK TOKEN HET HAN CHUA
    public boolean isExpireTime(LocalDateTime time) {
        return LocalDateTime.now().isAfter(time);
    }

    // send email den link resetpassword
    public boolean sendEmail(String to, String link, String name, String otp) {
        //thiet lap cac ket noi may chu http
        Properties props = new Properties();
        //email.smtp.host : dia chi may chu gmail
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        //mail.smtp.auth ket noi yeu cau phai xac thuc
        props.put("mail.smtp.auth", "true");
        // mail.smtp.starttle.enable : giup bao thong tin giua sever -> client
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                //mail cua may chu , password ung dung gg
                return new PasswordAuthentication(from, password);
            }
        };

        try {

            Session session = Session.getInstance(props, auth);
            // gui cho email  1 van ban html
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html ; charset=UTF-8");
            // thiet lap dia chi email nguoi gui
            msg.setFrom(from);
            // thiet lap dia chi email nguoi nhan
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Reset Password - Smart Island Travel Booking", "UTF-8");
            String content
                    = "<html><body>"
                    + "<div style='max-width:600px;margin:0 auto;border:1px solid #ddd;border-radius:10px;overflow:hidden;font-family:Arial,sans-serif;'>"
                    + "   <div style='background:#0077b6;color:#fff;text-align:center;padding:15px;font-size:20px;font-weight:bold;'>"
                    + "       Smart Island Travel Booking"
                    + "       <div style='font-size:13px;font-weight:normal;'>Đặt chuyến – Trải nghiệm biển</div>"
                    + "   </div>"
                    + "   <div style='padding:20px;font-size:15px;color:#333;line-height:1.6;'>"
                    + "       <p>Xin chào <b>" + name + "</b>,</p>"
                    + "       <p>Đây là mã OTP dùng để xác thực hành động của bạn:</p>"
                    + "       <div style='background:#f1f9ff;padding:15px;text-align:center;border-radius:8px;margin:20px 0;'>"
                    + "           <div style='font-size:28px;font-weight:bold;color:#023e8a;letter-spacing:3px;'>" + otp + "</div>"
                    + "           <div style='font-size:13px;color:#555;'>Mã này có hiệu lực trong <b>5 phút</b>. Vui lòng không chia sẻ mã cho bất kỳ ai.</div>"
                    + "       </div>"
                    + "       <p style='text-align:center;'>Hoặc bạn có thể mở trang nhập mã trực tiếp bằng nút bên dưới:</p>"
                    + "       <div style='text-align:center;margin-top:15px;'>"
                    + "           <a href='" + link + "' style='display:inline-block;padding:12px 22px;"
                    + "               background:#0077b6;color:#fff;text-decoration:none;border-radius:8px;font-weight:600;"
                    + "               transition:all 0.3s ease;'>Nhập mã / Reset password</a>"
                    + "       </div>"
                    + "   </div>"
                    + "   <div style='font-size:12px;color:#777;text-align:center;padding:15px;border-top:1px solid #eee;'>"
                    + "       Nếu bạn không yêu cầu thay đổi mật khẩu, bạn có thể bỏ qua email này.<br><br>"
                    + "       &copy; 2025 Smart Island Travel Booking — Hệ thống quản lý chuyến đi"
                    + "   </div>"
                    + "</div>"
                    + "</body></html>";

            msg.setContent(content, "text/html ; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Gửi email thành cônggg" + " " + to);
            return true;
        } catch (Exception e) {
            System.out.println("Lỗi gửi email!");
            System.out.println(e);

        }
        return false;
    }
    /*
    fix loi
      public static void main(String[] args) {
       resetService reset = new resetService();
        // Test tạo OTP
        String otp = reset.generateOtp();
        String token = reset.generateToken();
        System.out.println("Mã OTP: " + otp);   

        // Test thời gian hết hạn
        LocalDateTime expiryTime = reset.expireDateTime();
        System.out.println("Thời gian hết hạn: " + expiryTime);

        // Test gửi OTP qua email
        String toEmail = "nqaghuyyy6969@gmail.com";
        String fullName = "Nguyen Quang Huy";
        String link = "http://localhost:9090/SWP391_Group3_SE1957-KS/views/home/resetPassword?token="+token;
        boolean isSent = reset.sendEmail(toEmail,link, fullName, otp);
        System.out.println(isSent ? "Gửi email OTP thành công." : "Gửi email OTP thất bại.");
    
    }
     */

}
