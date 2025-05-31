package controller.login;

import dal.UserDAO;
import domain.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.login(email, password);

            if (user != null) {
                if (user.isLocked()) {
                    // Tài khoản bị khóa
                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                } else {
                    // Đăng nhập thành công
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            } else {
                // Email hoặc mật khẩu sai
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
