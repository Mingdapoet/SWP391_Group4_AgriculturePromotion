package controller.post;

import dal.PostDAO;
import domain.Post;
import domain.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/loadEditPost")
public class LoadEditPostServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("LoadEditPostServlet - No session or user");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }
        User user = (User) session.getAttribute("user");
        System.out.println("LoadEditPostServlet - User: " + user.getEmail() + ", Role: " + user.getRole());

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalid_id");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            PostDAO postDAO = new PostDAO();
            Post post = postDAO.getPostById(postId);
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=post_not_found");
                return;
            }

            // Authorization: Admin or post owner
            if (!"admin".equals(user.getRole()) && post.getUserId() != user.getId()) {
                System.out.println("LoadEditPostServlet - Unauthorized edit attempt by: " + user.getEmail() + " for post ID: " + postId);
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=unauthorized");
                return;
            }

            request.setAttribute("post", post);
            request.getRequestDispatcher("/postForm.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalid_id");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=database_error");
        }
    }
}