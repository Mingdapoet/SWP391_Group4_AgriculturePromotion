package controller.post;

import dal.PostDAO;
import domain.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/approvePost")
public class AdminApproveServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("ApprovePostServlet - No session or user");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }
        User user = (User) session.getAttribute("user");
        System.out.println("ApprovePostServlet - User: " + user.getEmail() + ", Role: " + user.getRole());

        // Only admins can approve/reject
        if (!"admin".equals(user.getRole())) {
            System.out.println("ApprovePostServlet - Unauthorized approve attempt by: " + user.getEmail());
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=unauthorized");
            return;
        }

        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        String reasonForRejection = request.getParameter("reasonForRejection"); // Lấy lý do từ chối
        if (idParam == null || action == null || (!"approve".equals(action) && !"reject".equals(action))) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalid_request");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            String status = "approve".equals(action) ? "approved" : "rejected";
            PostDAO postDAO = new PostDAO();
            boolean updated = postDAO.approvePost(postId, status, "rejected".equals(status) ? reasonForRejection : null);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/listPosts?status=success_approve");
            } else {
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=post_not_found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalid_id");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=database_error");
        }
    }
}