package controller.login;

import dal.UserDAO;
import domain.User;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {
    // Thông tin email gửi OTP
    private static final String EMAIL_HOST = "smtp.gmail.com";
    private static final String EMAIL_USERNAME = "viethoang313204@gmail.com"; // Thay bằng Gmail của bạn
    private static final String EMAIL_PASSWORD = "htsm bnwl vulq ytpa"; // Thay bằng app password của bạn

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");
        String email = request.getParameter("email");

        // Bước 1: Kiểm tra email và gửi OTP
        if (step == null || !step.equals("reset")) {
            try {
                UserDAO dao = new UserDAO();
                User user = dao.getUserByEmail(email);

                if (user == null) {
                    request.setAttribute("error", "Email này không tồn tại!");
                    request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                    return;
                }

                String otp = generateOTP();
                dao = new UserDAO();
                dao.saveResetRequest(email, otp);

                sendOtpEmail(email, otp);
                response.sendRedirect("forgotpassword.jsp?step=verify&email=" + email);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
            }
        }
        // Bước 2: Kiểm tra OTP và đổi mật khẩu
        else {
            String otp = request.getParameter("otp");
            String newPassword = request.getParameter("newpassword");
            String confirmPassword = request.getParameter("confirmpassword");

            try {
                UserDAO dao = new UserDAO();
                boolean isOtpValid = dao.verifyOtp(email, otp);

                if (!isOtpValid) {
                    request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
                    request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
                    return;
                }

                if (newPassword == null || newPassword.length() < 8 || !newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "Mật khẩu mới phải dài ít nhất 8 ký tự và khớp với mật khẩu xác nhận!");
                    request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
                    return;
                }

                dao = new UserDAO();
                boolean success = dao.updatePassword(email, newPassword);

                if (success) {
                    response.sendRedirect("login.jsp?message=Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("error", "Đổi mật khẩu thất bại, thử lại sau!");
                    request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
            }
        }
    }

    private String generateOTP() {
        Random random = new Random();
        int otpNumber = 100000 + random.nextInt(900000);
        return String.valueOf(otpNumber);
    }

    private void sendOtpEmail(String toEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", EMAIL_HOST);
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP của bạn");
            message.setText("Mã OTP để đổi mật khẩu là: " + otp + ". Mã này có hiệu lực trong 10 phút.");
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Không gửi được email: " + e.getMessage());
        }
    }
}