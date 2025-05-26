package controller.login;

import dal.UserDAO;
import domain.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/ChangePassword"})
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        System.out.println("ChangePasswordServlet - User email: " + user.getEmail() + ", Password: " + user.getPassword());

        String newPassword = request.getParameter("newpassword");
        String confirmPassword = request.getParameter("confirmpassword");

        Map<String, String> errors = new HashMap<>();

        if (newPassword == null || newPassword.length() < 8) {
            errors.put("newpassword", "Mật khẩu mới phải có ít nhất 8 ký tự.");
        } else if (!newPassword.equals(confirmPassword)) {
            errors.put("confirmpassword", "Mật khẩu xác nhận không khớp.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/changepassword.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            boolean success = dao.updatePassword(user.getEmail(), newPassword); // Lưu plaintext

            if (success) {
                // Cập nhật user trong session với password mới
                User updatedUser = new User(
                    user.getId(),
                    user.getEmail(),
                    user.getRole(),
                    user.getPhone(),
                    user.getAddress(),
                    user.getBirthday(),
                    user.getCreatedAt(),
                    user.getFullName(),
                    user.getGender(),
                    newPassword // Lưu plaintext
                );
                request.getSession().setAttribute("user", updatedUser);
                request.getSession().setAttribute("message", "Đổi mật khẩu thành công!");
                response.sendRedirect(request.getContextPath() + "/profile.jsp");
            } else {
                errors.put("error", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/changepassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            errors.put("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/changepassword.jsp").forward(request, response);
        }
    }
}