package com.oceanview.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    public static void sendLoginAlert(String username, String role) {

        final String fromEmail = "pasindumaleesha121@gmail.com";
        final String password = "dmwo pzed tjzb qsco";
        final String toEmail = "pasindumaleesha121@gmail.com";

        String subject = "Ocean View Resort - User Login Alert";

        String message =
                "User Login Notification\n\n" +
                "Username: " + username + "\n" +
                "Role: " + role + "\n" +
                "Login Time: " + new java.util.Date();

        Properties props = new Properties();

        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, password);
                    }
                });

        try {

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));

            msg.setSubject(subject);
            msg.setText(message);

            Transport.send(msg);

            System.out.println("Email sent successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    public static void sendReservationEmail(String guestName, String toEmail,
            String roomNumber, String roomType,
            String checkIn, String checkOut) {

final String fromEmail = "pasindumaleesha121@gmail.com";
final String password = "dmwo pzed tjzb qsco";

String subject = "Ocean View Resort - Reservation Confirmed";

String message = "Dear " + guestName + ",\n\n" +
"Your reservation has been successfully confirmed!\n\n" +
"Reservation Details:\n" +
"Room Type: " + roomType + "\n" +
"Room Number: " + roomNumber + "\n" +
"Check-in: " + checkIn + "\n" +
"Check-out: " + checkOut + "\n\n" +
"Thank you for choosing Ocean View Resort.\n\n" +
"Best Regards,\nOcean View Resort Team";

Properties props = new Properties();
props.put("mail.smtp.host", "smtp.gmail.com");
props.put("mail.smtp.port", "465");
props.put("mail.smtp.auth", "true");
props.put("mail.smtp.ssl.enable", "true");
props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

Session session = Session.getInstance(props,
new Authenticator() {
protected PasswordAuthentication getPasswordAuthentication() {
return new PasswordAuthentication(fromEmail, password);
}
});

try {
Message msg = new MimeMessage(session);
msg.setFrom(new InternetAddress(fromEmail));
msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
msg.setSubject(subject);
msg.setText(message);
Transport.send(msg);
System.out.println("Reservation email sent successfully!");
} catch (Exception e) {
e.printStackTrace();
}
}
    
    
    public static void sendCheckoutEmail(String guestName, String toEmail, String roomNumber, double totalAmount) {
        final String fromEmail = "pasindumaleesha121@gmail.com";
        final String password = "dmwo pzed tjzb qsco"; 

        String subject = "Ocean View Resort - Checkout & Bill Summary";

        String message = "Dear " + guestName + ",\n\n" +
                "Thank you for staying with us at Ocean View Resort!\n\n" +
                "Your checkout for Room " + roomNumber + " has been successfully processed.\n" +
                "Total Bill Amount Settled: Rs. " + String.format("%.2f", totalAmount) + "\n\n" +
                "We hope you had a wonderful time and look forward to welcoming you back soon!\n\n" +
                "Best Regards,\nOcean View Resort Team";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, password);
                    }
                });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(message);
            Transport.send(msg);
            System.out.println("Checkout email sent successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}