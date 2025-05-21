package controller.login;

import domain.LoginGoogle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/login-google"})
public class LoginGoogleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String code = request.getParameter("code");
        if (code != null) {
            LoginGoogle gg = new LoginGoogle();
            String accessToken = gg.getToken(code);
            System.out.println("Access Token: " + accessToken);
            // Gửi token đến JSP để hiển thị (tùy chọn)
            request.setAttribute("accessToken", accessToken);
            request.getRequestDispatcher("/login-result.jsp").forward(request, response);
        } else {
            response.getWriter().println("Error: No authorization code received.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Chuyển hướng POST sang GET nếu cần
    }
}