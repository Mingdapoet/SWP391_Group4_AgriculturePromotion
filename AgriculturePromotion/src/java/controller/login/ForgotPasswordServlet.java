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
    private static final String EMAIL_HOST = "smtp.gmail.com";
    private static final String EMAIL_USERNAME = "viethoang313204@gmail.com";
    private static final String EMAIL_PASSWORD = "htsm bnwl vulq ytpa";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String step = request.getParameter("step");
        String email = request.getParameter("email");

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
                boolean saved = dao.saveResetRequest(email, otp);
                if (!saved) {
                    request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau!");
                    request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                    return;
                }
                System.out.println("ForgotPasswordServlet: OTP saved successfully for email: " + email);

                sendOtpEmail(email, otp);
                response.sendRedirect("forgotpassword.jsp?step=verify&email=" + email);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau! " + e.getMessage());
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
            }
        } else if (step.equals("resend")) {
            try {
                UserDAO dao = new UserDAO();
                User user = dao.getUserByEmail(email);

                if (user == null) {
                    request.setAttribute("error", "Email này không tồn tại!");
                    request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                    return;
                }

                // Tạo OTP mới và lưu vào database mà không xóa OTP cũ
                String otp = generateOTP();
                boolean saved = dao.saveResetRequest(email, otp);
                if (!saved) {
                    request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau!");
                    request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
                    return;
                }
                System.out.println("ForgotPasswordServlet: Resent OTP saved successfully for email: " + email);

                sendOtpEmail(email, otp);
                request.setAttribute("message", "Mã OTP mới đã được gửi!");
                request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau! " + e.getMessage());
                request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
            }
        } else {
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
                    // Xóa tất cả OTP của email sau khi đổi mật khẩu thành công
                    dao = new UserDAO();
                    dao.deleteResetRequest(email, otp);
                    response.sendRedirect("login.jsp?message=Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("error", "Đổi mật khẩu thất bại, thử lại sau!");
                    request.getRequestDispatcher("/forgotpassword.jsp?step=verify&email=" + email).forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra khi kết nối database: " + e.getMessage());
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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP của bạn", "UTF-8");
            message.setContent("Ma OTP de doi mat khau la: " + otp + ". Ma nay co hieu luc trong 10 phut.", "text/plain; charset=UTF-8");
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Không gửi được email: " + e.getMessage());
        }
    }
}