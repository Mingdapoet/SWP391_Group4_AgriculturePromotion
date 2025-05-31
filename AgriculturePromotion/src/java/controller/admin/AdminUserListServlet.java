package controller.admin;

import dal.UserDelDAO;
import domain.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/user-list")
public class AdminUserListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            UserDelDAO dao = new UserDelDAO(); // DAO đã có search

            String keyword = request.getParameter("keyword");

            List<User> users;

            if (keyword != null && !keyword.trim().isEmpty()) {
                users = dao.searchUsersByName(keyword.trim());
                request.setAttribute("keyword", keyword);
            } else {
                users = dao.getAllUsers();
            }

            request.setAttribute("users", users);

            String message = request.getParameter("message");
            if (message != null) {
                request.setAttribute("message", message);
            }

            request.getRequestDispatcher("/user_list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi server khi lấy danh sách người dùng");
        }
    }
}
