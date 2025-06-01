package controller.admin;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/admin/lock-user")
public class UserLockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");
        String action = request.getParameter("action"); // "lock" hoặc "unlock"

        try {
            if (idParam != null && action != null) {
                int id = Integer.parseInt(idParam);
                UserDAO dao = new UserDAO();

                boolean locked;
                if ("lock".equalsIgnoreCase(action)) {
                    locked = true;
                } else if ("unlock".equalsIgnoreCase(action)) {
                    locked = false;
                } else {
                    String message = "Thao tác không hợp lệ.";
                    response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode(message, "UTF-8"));
                    return;
                }

                boolean updated = dao.updateUserLockStatus(id, locked);

                String message = updated
                        ? (locked ? "Khóa tài khoản thành công." : "Mở khóa tài khoản thành công.")
                        : "Cập nhật trạng thái thất bại.";

                response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode("Thiếu tham số id hoặc action", "UTF-8"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode("ID không hợp lệ", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/user-list?message=" + URLEncoder.encode("Lỗi hệ thống", "UTF-8"));
        }
    }
}
