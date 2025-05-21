package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import dal.UserDAO;
import domain.User;

@WebServlet("/AdminEditUserServlet")
public class AdminEditUserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy người dùng.");
                response.sendRedirect(request.getContextPath() + "/AdminUserListServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi tải thông tin người dùng.");
            response.sendRedirect(request.getContextPath() + "/AdminUserListServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            Date birthday = Date.valueOf(request.getParameter("birthday"));
            String gender = request.getParameter("gender");
            String role = request.getParameter("role");

            // Tạo đối tượng User sử dụng constructor phù hợp với class bạn cung cấp
            User updatedUser = new User(
                id,
                email,
                role,
                phone,
                address,
                birthday,
                null, // createdAt không cập nhật
                fullname,
                gender
            );

            boolean updated = userDAO.updateUser(updatedUser);

            if (updated) {
                request.getSession().setAttribute("success", "Cập nhật người dùng thành công!");
            } else {
                request.getSession().setAttribute("error", "Cập nhật người dùng thất bại!");
            }

            response.sendRedirect(request.getContextPath() + "/AdminUserListServlet");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi cập nhật người dùng!");
            response.sendRedirect(request.getContextPath() + "/AdminUserListServlet");
        }
    }
}
