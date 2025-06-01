package controller.post;

import dal.PostDAO;
import domain.Post;
import domain.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/editpost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
public class EditPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "Uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session != null ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null || (!"admin".equals(loggedInUser.getRole()) && !"business".equals(loggedInUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=unauthorized");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        Part filePart = request.getPart("image");

        PostDAO postDAO = new PostDAO();
        int postId = 0;
        Post currentPost = null;

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=missingIdForEdit");
            return;
        }

        try {
            postId = Integer.parseInt(idStr);
            currentPost = postDAO.getPostById(postId);
            if (currentPost == null) {
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=notFound");
                return;
            }
            if (!"admin".equals(loggedInUser.getRole()) && currentPost.getUserId() != loggedInUser.getId()) {
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=unauthorizedEdit");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=invalidIdForEdit");
            return;
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error fetching current post: " + e.getMessage());
            request.getRequestDispatcher("postForm.jsp").forward(request, response);
            return;
        }

        String newFileName = null;
        String dbImageUrlForUpdate = currentPost.getImageUrl();

        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (originalFileName != null && !originalFileName.isEmpty()) {
                String fileExtension = "";
                int i = originalFileName.lastIndexOf('.');
                if (i > 0) {
                    fileExtension = originalFileName.substring(i);
                }
                newFileName = UUID.randomUUID().toString() + fileExtension;
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(uploadPath + File.separator + newFileName), StandardCopyOption.REPLACE_EXISTING);
                    dbImageUrlForUpdate = newFileName;
                    if (currentPost.getImageUrl() != null && !currentPost.getImageUrl().isEmpty()) {
                        File oldImageFile = new File(uploadPath + File.separator + currentPost.getImageUrl());
                        if (oldImageFile.exists()) {
                            oldImageFile.delete();
                        }
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    request.setAttribute("errorMessage", "File upload failed during edit: " + e.getMessage());
                    request.setAttribute("post", currentPost);
                    request.getRequestDispatcher("postForm.jsp").forward(request, response);
                    return;
                }
            }
        }

        Post postToUpdate = new Post();
        postToUpdate.setId(postId);
        postToUpdate.setTitle(title);
        postToUpdate.setContent(content);
        postToUpdate.setImageUrl(dbImageUrlForUpdate);
        postToUpdate.setUserId(currentPost.getUserId());
        postToUpdate.setStatus("business".equals(loggedInUser.getRole()) ? "pending" : currentPost.getStatus());

        try {
            if (postDAO.updatePost(postToUpdate)) {
                response.sendRedirect(request.getContextPath() + "/listpost.jsp?status=success_edit");
            } else {
                request.setAttribute("errorMessage", "Failed to update post.");
                request.setAttribute("post", postToUpdate);
                request.getRequestDispatcher("postForm.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error during update: " + e.getMessage());
            request.setAttribute("post", postToUpdate);
            request.getRequestDispatcher("postForm.jsp").forward(request, response);
        }
    }
}