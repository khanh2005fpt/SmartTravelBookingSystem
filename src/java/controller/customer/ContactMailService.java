/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.customer;

/**
 *
 * @author nqagh
 */

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class ContactMailService {
    private final String from = "nqaghuyyy6969@gmail.com";
    private final String password = "hcfj ldgb yyhh ssyc"; // App password Gmail

    public boolean sendFeedback(String to, String subject, String htmlContent) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        try {
            Session session = Session.getInstance(props, auth);
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(from, "Smart Island Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject(subject, "UTF-8");
            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Đã gửi mail phản hồi khách hàng!");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
