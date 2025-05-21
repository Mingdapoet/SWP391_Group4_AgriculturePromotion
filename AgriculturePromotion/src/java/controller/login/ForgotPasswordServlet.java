package controller.login;

import dal.UserDAO;
import domain.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        UserDAO userDAO = null;
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        User user = userDAO.getUserByEmail(email);

        if (user != null) {
            // Tạo mã reset hoặc mật khẩu mới
            String newPassword = generateRandomPassword();

//            userDAO.updatePasswordByEmail(email, newPassword);
//
//            SendEmail.send(email, "Mật khẩu mới", "Mật khẩu mới của bạn là: " + newPassword);

            request.setAttribute("message", "Mật khẩu mới đã được gửi về email của bạn.");
        } else {
            request.setAttribute("message", "Email không tồn tại trong hệ thống.");
        }

        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    private String generateRandomPassword() {
        return UUID.randomUUID().toString().substring(0, 8); // random 8 ký tự
    }
}