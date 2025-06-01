//package controller.post;
//
//import dal.PostDAO;
//import domain.Post;
//import domain.User;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import jakarta.servlet.http.Part;
//
//import java.io.File;
//import java.io.IOException;
//import java.io.InputStream;
//import java.nio.file.Files;
//import java.nio.file.Paths;
//import java.nio.file.StandardCopyOption;
//import java.sql.SQLException;
//import java.util.UUID;
//
//@WebServlet("/createpost")
//@MultipartConfig(
//    fileSizeThreshold = 1024 * 1024 * 1,
//    maxFileSize = 1024 * 1024 * 10,
//    maxRequestSize = 1024 * 1024 * 15
//)
//public class CreatePostServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//    private static final String UPLOAD_DIRECTORY = "Uploads";
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        User loggedInUser = session != null ? (User) session.getAttribute("loggedInUser") : null;
//
//        if (loggedInUser == null || (!"admin".equals(loggedInUser.getRole()) && !"business".equals(loggedInUser.getRole()))) {
//            response.sendRedirect(request.getContextPath() + "/listpost.jsp?error=unauthorized");
//            return;
//        }
//
//        request.setCharacterEncoding("UTF-8");
//        String title = request.getParameter("title");
//        String content = request.getParameter("content");
//        Part filePart = request.getPart("image");
//
//        String fileName = null;
//        String dbImageUrl = null;
//
//        if (filePart != null && filePart.getSize() > 0) {
//            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//            if (originalFileName != null && !originalFileName.isEmpty()) {
//                String fileExtension = "";
//                int i = originalFileName.lastIndexOf('.');
//                if (i > 0) {
//                    fileExtension = originalFileName.substring(i);
//                }
//                fileName = UUID.randomUUID().toString() + fileExtension;
//                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
//                File uploadDir = new File(uploadPath);
//                if (!uploadDir.exists()) {
//                    uploadDir.mkdirs();
//                }
//                try (InputStream fileContent = filePart.getInputStream()) {
//                    Files.copy(fileContent, Paths.get(uploadPath + File.separator + fileName), StandardCopyOption.REPLACE_EXISTING);
//                    dbImageUrl = fileName;
//                } catch (IOException e) {
//                    e.printStackTrace();
//                    request.setAttribute("errorMessage", "File upload failed: " + e.getMessage());
//                    request.getRequestDispatcher("postForm.jsp").forward(request, response);
//                    return;
//                }
//            }
//        }
//
//        String status = "business".equals(loggedInUser.getRole()) ? "pending" : "approved";
//        Post post = new Post(title, content, dbImageUrl, loggedInUser.getId(), status);
//        PostDAO postDAO = new PostDAO();
//
//        try {
//            if (postDAO.addPost(post)) {
//                response.sendRedirect(request.getContextPath() + "/listpost.jsp?status=success_create");
//            } else {
//                request.setAttribute("errorMessage", "Failed to create post. Please try again.");
//                request.setAttribute("post", post);
//                request.getRequestDispatcher("postForm.jsp").forward(request, response);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
//            request.setAttribute("post", post);
//            request.getRequestDispatcher("postForm.jsp").forward(request, response);
//        }
//    }
//}