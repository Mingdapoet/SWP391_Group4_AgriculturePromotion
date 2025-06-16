package controller.admin;

import dal.UserDelDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/admin/delete-user")
public class AdminDeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");

        try {
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                UserDelDAO dao = new UserDelDAO();
                boolean deleted = dao.deleteUser(id);

           
                String message = deleted ? "Xóa thành công" : "Xóa thất bại";

          
                response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode("Thiếu ID", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode("Lỗi hệ thống", "UTF-8"));
        }
    }
}
