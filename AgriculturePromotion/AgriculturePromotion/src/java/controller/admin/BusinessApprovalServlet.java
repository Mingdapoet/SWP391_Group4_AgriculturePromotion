package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dal.UserDAO;

import java.io.IOException;

@WebServlet("/business-approval")
public class BusinessApprovalServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new ServletException("Lỗi khi khởi tạo UserDAO", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đặt charset để xử lý tiếng Việt
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String action = request.getParameter("action");

        if (idStr == null || idStr.isEmpty() || action == null || action.isEmpty()) {
            // Nếu thiếu tham số, chuyển về danh sách
            response.sendRedirect("business-registrations");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            if ("approve".equals(action)) {
                userDAO.approveBusinessRegistration(id);

            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    // Nếu thiếu lý do từ chối, chuyển về chi tiết kèm lỗi
                    response.sendRedirect("business-detail?id=" + id + "&error=missingReason");
                    return;
                }
                userDAO.rejectBusinessRegistration(id, reason.trim());

            } else {
                // Action không hợp lệ
                response.sendRedirect("business-registrations");
                return;
            }

            // Nếu thành công, quay lại trang chi tiết
            response.sendRedirect("business-detail?id=" + id);

        } catch (NumberFormatException e) {
            // id không hợp lệ (không phải số)
            response.sendRedirect("business-registrations");

        } catch (Exception e) {
            // Bắt tất cả lỗi khác, tránh lỗi 500 tràn lan
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi server, vui lòng thử lại sau.");
        }
    }
}
