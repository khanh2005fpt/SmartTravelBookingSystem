/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.account;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
/**
 *
 * @author nqagh
 */
public class resetService {
    
    // nqaghuyyy6969@gmail.com mail Server
     public final String from ="nqaghuyyy6969@gmail.com";
        // tao lay password ung dung tren google
       public final String password ="hcfj ldgb yyhh ssyc";
    
    
    // Sinh OTP 6 chữ số
      public static final SecureRandom random = new SecureRandom(); 
      private final int LIMIT_MINUS =10;
      
    public String generateOtp() {
        int otp = 100000 + random.nextInt(900000); // từ 100000 -> 999999
        return String.valueOf(otp);
    }
        // Sinh token (UUID)
    public String generateToken() {
        return UUID.randomUUID().toString();
    }
    
    //time ton tai otp
    public LocalDateTime expireDateTime(){
        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
    }
    // CHECK TOKEN HET HAN CHUA
    public boolean isExpireTime(LocalDateTime time){
        return LocalDateTime.now().isAfter(time);
    }
    // send email den link resetpassword
    public void sendEmail(String to , String link , String name , String otp)
    {
        //thiet lap cac ket noi may chu http
        Properties props = new Properties();
        //email.smtp.host : dia chi may chu gmail
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smpt.port", "587");
        //mail.smtp.auth ket noi yeu cau phai xac thuc
        props.put("mail.smtp.auth", "true");
       // mail.smtp.starttle.enable : giup bao thong tin giua sever -> client
        props.put("mail.smtp.starttls.enable", "true");
        
        Authenticator auth = new Authenticator() {
            @Override
           protected PasswordAuthentication getPasswordAuthentication(){
               //mail cua may chu , password ung dung gg
               return new PasswordAuthentication(from , password);
           }
        };
        
       
      try{
          
           Session session = Session.getInstance(props);
        // gui cho email  1 van ban html
         MimeMessage msg= new MimeMessage(session);
          msg.addHeader("Content-type","text/html ; charset=UTF-8");
          // thiet lap dia chi email nguoi gui
          msg.setFrom(from);
           // thiet lap dia chi email nguoi nhan
           msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to , false));
           msg.setSubject("Reset Password" , "UTF-8");
             String content = "<h3>Xin chào " + name + "</h3>"
                    + "<p>Mã OTP của bạn là: <b>" + otp + "</b></p>"
                    + "<p>Hoặc click link sau để mở trang nhập OTP trực tiếp:</p>"
                    + "<a href=\"" + link + "\">Reset password</a>";
           
           
          msg.setContent(content , "text/html , charset=UTF-8");
          Transport.send(msg);
          System.out.println("Gửi email thành cônggg");
      }catch(Exception e){
          System.out.println("Lỗi gửi email!");
          System.out.println(e);
      }              
                
    }
}
