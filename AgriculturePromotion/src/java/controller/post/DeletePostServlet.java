package controller;

import dal.PostDAO;
import domain.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet("/deletePost")
public class DeletePostServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null) {
            System.out.println("DeletePostServlet - No user in session");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        System.out.println("DeletePostServlet - User: " + user.getEmail() + ", Role: " + user.getRole() + ", Post ID: " + request.getParameter("id"));

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            System.out.println("DeletePostServlet - Invalid or missing post ID");
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalid_id");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            PostDAO postDAO = new PostDAO();
            String imageUrl = postDAO.getImageUrlById(postId);
            System.out.println("DeletePostServlet - Image URL for post ID " + postId + ": " + imageUrl);

            boolean deleted = postDAO.deletePost(postId, user.getId(), user.getRole());
            if (deleted) {
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "Uploads" + File.separator + imageUrl;
                    Path imagePath = Paths.get(uploadPath);
                    System.out.println("DeletePostServlet - Attempting to delete image: " + uploadPath);
                    if (Files.exists(imagePath)) {
                        Files.delete(imagePath);
                        System.out.println("DeletePostServlet - Image deleted: " + uploadPath);
                    } else {
                        System.out.println("DeletePostServlet - Image file does not exist: " + uploadPath);
                    }
                } else {
                    System.out.println("DeletePostServlet - No image to delete for post ID: " + postId);
                }
                response.sendRedirect(request.getContextPath() + "/posts?successMessage=success_delete");
            } else {
                System.out.println("DeletePostServlet - Failed to delete post ID: " + postId);
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            System.err.println("DeletePostServlet - Invalid post ID format: " + idParam);
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalid_id");
        } catch (SQLException e) {
            System.err.println("DeletePostServlet - SQL Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=database_error");
        } catch (Exception e) {
            System.err.println("DeletePostServlet - Unexpected Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=server_error");
        }
    }
}