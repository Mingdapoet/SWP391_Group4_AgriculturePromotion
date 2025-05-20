package controller.login;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String birthdayStr = request.getParameter("birthday");

        try {
            Date birthday = Date.valueOf(birthdayStr);
            UserDAO dao = new UserDAO();
            boolean success = dao.register(email, password, role, phone, address, birthday);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("error", "Email đã tồn tại hoặc có lỗi xảy ra.");
                request.getRequestDispatcher("/resources/register.jsp").forward(request, response); // Updated path
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp"); // Use context path
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/resources/register.jsp"); // Updated path
    }
}