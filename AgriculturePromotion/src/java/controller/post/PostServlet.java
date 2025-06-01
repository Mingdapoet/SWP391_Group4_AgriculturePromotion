package controller.post; // Hoặc package controller; tùy theo cấu trúc của bạn

import dal.PostDAO;
import domain.Post;
import domain.User; // Đảm bảo bạn có class User với các getter getId(), getRole(), getEmail()

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
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@WebServlet("/posts") // Tất cả request liên quan đến post sẽ qua đây với param "action"
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class PostServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;
    private static final String UPLOAD_DIR_BASE = "Uploads";
    private static final String CONTENT_IMAGE_SUBDIR = "content_images";

    @Override
    public void init() {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        String actionParam = request.getParameter("action");

        boolean isPublicAction = "publicList".equals(actionParam) || "viewPublicPost".equals(actionParam);

        if (user == null && !isPublicAction) {
            System.out.println("PostServlet - GET: No user in session for protected action: " + actionParam);
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (user != null) {
            System.out.println("PostServlet - GET User: " + user.getEmail() + ", Role: " + user.getRole() + ", Action: " + actionParam);
        } else if (isPublicAction) {
            System.out.println("PostServlet - GET Public Action: " + actionParam);
        }

        String action = actionParam;
        if (action == null || action.isEmpty()) {
            action = (user != null) ? "list" : "publicList";
        }

        // Xử lý session messages
        if (session != null) {
            String sessionErrorMessage = (String) session.getAttribute("errorMessage");
            if (sessionErrorMessage != null) {
                request.setAttribute("errorMessage", sessionErrorMessage);
                session.removeAttribute("errorMessage");
            }
            String sessionSuccessMessage = (String) session.getAttribute("successMessage");
            if (sessionSuccessMessage != null) {
                request.setAttribute("successMessage", sessionSuccessMessage);
                session.removeAttribute("successMessage");
            }
        }

        try {
            switch (action) {
                case "list": // Danh sách bài viết của người dùng (thay thế ListPostServlet)
                    if (user == null) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp");
                        return;
                    }
                    listPosts(request, response, user);
                    break;
                case "create": // Hiển thị form tạo mới
                    if (user == null || (!"admin".equals(user.getRole()) && !"business".equals(user.getRole()))) {
                        if (session != null) {
                            session.setAttribute("errorMessage", "Bạn không có quyền tạo bài viết.");
                        }
                        response.sendRedirect(request.getContextPath() + (user != null ? "/posts?action=list" : "/login.jsp"));
                        return;
                    }
                    request.setAttribute("action", "create"); // Cho postForm.jsp biết là đang tạo
                    showForm(request, response, null);
                    break;
                case "edit": // Hiển thị form sửa (thay thế LoadEditPostServlet)
                    if (user == null) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp");
                        return;
                    }
                    handleLoadEditForm(request, response, user, session);
                    break;
                case "delete": // Xử lý xóa bài viết (thay thế DeletePostServlet) - Cân nhắc chuyển sang doPost
                    if (user == null) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp");
                        return;
                    }
                    handleDeletePost(request, response, user, session);
                    break;
                case "publicList": // Danh sách bài viết công khai
                    listPublicPosts(request, response);
                    break;
                case "viewPublicPost": // Xem chi tiết một bài viết công khai
                    viewSinglePublicPost(request, response);
                    break;
                case "previewOwnPost": // Xem trước bài viết của chính mình
                    if (user == null) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired_preview");
                        return;
                    }
                    previewOwnPost(request, response, user, session);
                    break;
                default:
                    if (user != null) {
                        listPosts(request, response, user);
                    } else {
                        listPublicPosts(request, response);
                    }
                    break;
            }
        } catch (SQLException ex) {
            handleGenericError(ex, "Lỗi SQL trong GET action " + action + ": ", request, response, user, isPublicAction);
        } catch (NumberFormatException ex) {
            handleGenericError(ex, "ID không hợp lệ trong GET action " + action + ": ", request, response, user, isPublicAction);
        } catch (Exception ex) {
            handleGenericError(ex, "Lỗi không mong muốn trong GET action " + action + ": ", request, response, user, isPublicAction);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // Không set response content type vội vì uploadContentImage trả JSON

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        String action = request.getParameter("action");
        System.out.println("PostServlet - POST User: " + (user != null ? user.getEmail() : "Guest") + ", Role: " + (user != null ? user.getRole() : "N/A") + ", Action: " + action);

        // Action upload ảnh content có thể không cần user hoặc có cơ chế riêng (nhưng nên có)
        if ("uploadContentImage".equals(action)) {
            handleContentImageUpload(request, response, user);
            return;
        }

        // Các action còn lại yêu cầu user
        if (user == null) {
            System.out.println("PostServlet - POST: No user in session for action " + action);
            // Nếu là AJAX call, trả lỗi JSON, nếu không thì redirect
            if ("approve".equals(action)) { // Ví dụ approve có thể từ AJAX
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"Phiên làm việc hết hạn hoặc chưa đăng nhập.\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        // Đặt content type cho các response HTML thông thường
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            switch (action) {
                case "save": // Lưu bài viết mới (thay thế CreatePostServlet)
                case "update": // Cập nhật bài viết (thay thế EditPostServlet)
                    if (!"admin".equals(user.getRole()) && !"business".equals(user.getRole())) {
                        session.setAttribute("errorMessage", "Bạn không có quyền thực hiện hành động này.");
                        response.sendRedirect(request.getContextPath() + "/posts?action=list");
                        return;
                    }
                    handleSaveOrUpdatePost(request, response, user, session, action);
                    break;
                case "approve": // Duyệt hoặc từ chối bài viết (thay thế AdminApproveServlet)
                    if (!"admin".equals(user.getRole())) {
                        session.setAttribute("errorMessage", "Bạn không có quyền thực hiện hành động này.");
                        response.sendRedirect(request.getContextPath() + "/posts?action=list");
                        return;
                    }
                    handleApproveOrRejectPost(request, response, user, session);
                    break;
                // THÊM CASE SAU VÀO ĐÂY:
                case "submitDraftForApproval":
                    // Quyền đã được kiểm tra chi tiết trong handleSubmitDraftForApproval
                    // (là admin hoặc chủ sở hữu bài viết và bài viết phải ở trạng thái draft/rejected)
                    handleSubmitDraftForApproval(request, response, user, session);
                    break;
                // Cân nhắc chuyển action "delete" sang doPost cho an toàn hơn
                // case "delete": 
                // handleDeletePost(request, response, user, session);
                // break;
                default:
                    session.setAttribute("errorMessage", "Hành động POST không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/posts?action=list");
                    break;
            }
        } catch (SQLException ex) {
            handleGenericError(ex, "Lỗi SQL trong POST action " + action + ": ", request, response, user, false);
        } catch (Exception ex) {
            handleGenericError(ex, "Lỗi không mong muốn trong POST action " + action + ": ", request, response, user, false);
        }
    }

    private void handleLoadEditForm(HttpServletRequest request, HttpServletResponse response, User user, HttpSession session)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID bài viết để chỉnh sửa.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }
        int idToEdit = Integer.parseInt(idParam);
        Post existingPost = postDAO.getPostById(idToEdit);

        if (existingPost == null) {
            session.setAttribute("errorMessage", "Không tìm thấy bài viết để sửa.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }
        if (!"admin".equals(user.getRole()) && existingPost.getUserId() != user.getId()) {
            session.setAttribute("errorMessage", "Bạn không có quyền sửa bài viết này.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }
        request.setAttribute("action", "edit"); // Cho postForm.jsp biết là đang edit
        showForm(request, response, existingPost);
    }

    private void handleSaveOrUpdatePost(HttpServletRequest request, HttpServletResponse response, User user, HttpSession session, String servletAction)
            throws SQLException, ServletException, IOException {

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        Part coverImageFilePart = request.getPart("coverImageFile");
        // Lấy hành động cụ thể từ nút bấm (lưu nháp hay gửi duyệt)
        String formButtonAction = request.getParameter("formAction");

        String newStatus;
        if ("saveDraft".equals(formButtonAction)) {
            newStatus = "draft";
        } else { // Mặc định là "submitForApproval" hoặc nếu không có param formAction (trường hợp form chỉ có 1 nút submit chính)
            newStatus = "pending";
        }

        String coverImageUrl = null;
        if (coverImageFilePart != null && coverImageFilePart.getSize() > 0) {
            String originalFileName = Paths.get(coverImageFilePart.getSubmittedFileName()).getFileName().toString();
            if (originalFileName != null && !originalFileName.isEmpty()) {
                String fileExtension = "";
                int i = originalFileName.lastIndexOf('.');
                if (i > 0) {
                    fileExtension = originalFileName.substring(i);
                }
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_BASE;
                Path uploadDir = Paths.get(uploadPath);
                if (!Files.exists(uploadDir)) {
                    Files.createDirectories(uploadDir);
                }
                Path filePath = Paths.get(uploadPath + File.separator + uniqueFileName);
                try (var inputStream = coverImageFilePart.getInputStream()) {
                    Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                coverImageUrl = uniqueFileName;
            }
        }

        if ("save".equals(servletAction)) { // Tạo bài viết mới
            Post post = new Post();
            post.setTitle(title);
            post.setContent(content);
            if (coverImageUrl != null) {
                post.setImageUrl(coverImageUrl);
            }
            post.setUserId(user.getId());
            post.setEmail(user.getEmail()); // Gán email người tạo
            post.setStatus(newStatus);
            // reasonForRejection mặc định là null cho bài mới

            postDAO.addPost(post);
            if ("draft".equals(newStatus)) {
                session.setAttribute("successMessage", "Bài viết đã được lưu nháp thành công!");
            } else {
                session.setAttribute("successMessage", "Bài viết mới đã được gửi chờ duyệt!");
            }
        } else if ("update".equals(servletAction)) { // Cập nhật bài viết hiện có
            int postId = Integer.parseInt(request.getParameter("id"));
            Post post = postDAO.getPostById(postId);

            if (post == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết để cập nhật.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }
            // Kiểm tra quyền sở hữu trước khi cập nhật (trừ admin)
            if (!"admin".equals(user.getRole()) && post.getUserId() != user.getId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền cập nhật bài viết này.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }

            post.setTitle(title);
            post.setContent(content);

            String oldCoverImageNameToDelete = null;
            if (coverImageUrl != null) {
                oldCoverImageNameToDelete = post.getImageUrl();
                post.setImageUrl(coverImageUrl);
            }

            post.setStatus(newStatus);
            if ("pending".equals(newStatus)) { // Khi gửi duyệt (hoặc gửi duyệt lại), xóa lý do từ chối cũ
                post.setReasonForRejection(null);
            }

            boolean updateSuccess = postDAO.updatePost(post);

            if (updateSuccess && coverImageUrl != null && oldCoverImageNameToDelete != null && !oldCoverImageNameToDelete.isEmpty()) {
                try {
                    String oldCoverImagePathStr = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_BASE + File.separator + oldCoverImageNameToDelete;
                    Files.deleteIfExists(Paths.get(oldCoverImagePathStr));
                } catch (IOException e) {
                    System.err.println("Lỗi xóa ảnh bìa cũ khi cập nhật: " + oldCoverImageNameToDelete + " - " + e.getMessage());
                }
            }

            if (updateSuccess) {
                if ("draft".equals(newStatus)) {
                    session.setAttribute("successMessage", "Bản nháp đã được cập nhật thành công!");
                } else {
                    session.setAttribute("successMessage", "Cập nhật bài viết thành công! Đang chờ duyệt lại.");
                }
            } else {
                session.setAttribute("errorMessage", "Cập nhật bài viết thất bại.");
                if (coverImageUrl != null) { // Nếu update DB lỗi, xóa ảnh mới vừa upload
                    try {
                        Path newCoverPath = Paths.get(getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_BASE + File.separator + coverImageUrl);
                        Files.deleteIfExists(newCoverPath);
                    } catch (IOException e) {
                        /* log error */ }
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/posts?action=list");
    }

    private void handleSubmitDraftForApproval(HttpServletRequest request, HttpServletResponse response, User user, HttpSession session)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID bài viết để gửi duyệt.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            Post post = postDAO.getPostById(postId);

            if (post == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }

            // Kiểm tra quyền: user phải là admin hoặc chủ sở hữu bài viết
            if (!"admin".equals(user.getRole()) && post.getUserId() != user.getId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền gửi duyệt bài viết này.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }

            if (!"draft".equals(post.getStatus()) && !"rejected".equals(post.getStatus())) { // Chỉ gửi duyệt từ trạng thái draft hoặc rejected
                session.setAttribute("errorMessage", "Chỉ có thể gửi duyệt bài viết từ trạng thái Nháp hoặc Bị từ chối.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }

            post.setStatus("pending");
            post.setReasonForRejection(null); // Xóa lý do từ chối cũ nếu có

            // Sử dụng phương thức updatePost hiện có, vì nó cũng cập nhật updated_at
            boolean updated = postDAO.updatePost(post);

            if (updated) {
                session.setAttribute("successMessage", "Bài viết đã được gửi đi chờ duyệt thành công!");
            } else {
                session.setAttribute("errorMessage", "Gửi duyệt bài viết thất bại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài viết không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/posts?action=list");
    }

    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response, User user, HttpSession session)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID bài viết để xóa.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }
        try {
            int postId = Integer.parseInt(idParam);
            // Lấy URL ảnh trước khi xóa post khỏi DB
            String imageUrl = postDAO.getImageUrlById(postId);
            Post postToDelete = postDAO.getPostById(postId); // Cần check quyền trước khi xóa

            if (postToDelete == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết để xóa.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }
            // Kiểm tra quyền xóa (admin hoặc chủ sở hữu)
            if (!"admin".equals(user.getRole()) && postToDelete.getUserId() != user.getId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền xóa bài viết này.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }

            boolean deleted = postDAO.deletePost(postId, user.getId(), user.getRole()); // DAO có thể tự check role lần nữa

            if (deleted) {
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    try {
                        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_BASE;
                        Path imagePath = Paths.get(uploadPath + File.separator + imageUrl);
                        Files.deleteIfExists(imagePath);
                        System.out.println("PostServlet - Image deleted: " + imagePath);
                    } catch (IOException e) {
                        System.err.println("PostServlet - Error deleting image file " + imageUrl + ": " + e.getMessage());
                        session.setAttribute("errorMessage", "Xóa bài viết thành công nhưng có lỗi khi xóa file ảnh: " + e.getMessage());
                        // Không nên fail hoàn toàn chỉ vì không xóa được ảnh
                    }
                }
                session.setAttribute("successMessage", "Bài viết đã được xoá thành công!");
            } else {
                session.setAttribute("errorMessage", "Xóa bài viết thất bại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài viết không hợp lệ để xóa.");
        }
        response.sendRedirect(request.getContextPath() + "/posts?action=list");
    }

    private void handleApproveOrRejectPost(HttpServletRequest request, HttpServletResponse response, User user, HttpSession session)
            throws SQLException, ServletException, IOException {
        // Quyền admin đã được check ở doPost
        String idParam = request.getParameter("id");
        String approveAction = request.getParameter("actionToPerform"); // Tên param này có thể là "approveAction" hoặc tương tự, thay vì "action" để tránh nhầm lẫn với action chính của servlet
        if (approveAction == null) {
            approveAction = request.getParameter("approveAction"); // Check tên khác nếu có
        }
        if (approveAction == null) {
            approveAction = request.getParameter("task"); // Check tên khác nếu có
        }        // Hoặc nếu bạn dùng chung param 'action' cho cả servlet và cho approve/reject
        // thì cần đổi tên 1 trong 2. Giả sử param là `task_type` = "approve" hoặc "reject"
        // String taskType = request.getParameter("task_type");

        // Lấy theo tên param trong form của bạn: `name="action"` trong form approve/reject
        String taskType = request.getParameter("sub_action"); // Giả sử bạn dùng sub_action
        if (taskType == null) {
            taskType = request.getParameter("task"); // Thử tên khác
        }
        if (taskType == null && request.getParameter("action") != null && (request.getParameter("action").equals("approve") || request.getParameter("action").equals("reject"))) {
            taskType = request.getParameter("action"); // Nếu form dùng name="action"
        }

        String reasonForRejection = request.getParameter("reasonForRejection");

        if (idParam == null || taskType == null || (!"approve".equals(taskType) && !"reject".equals(taskType))) {
            session.setAttribute("errorMessage", "Yêu cầu duyệt/từ chối không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }
        if ("reject".equals(taskType) && (reasonForRejection == null || reasonForRejection.trim().isEmpty())) {
            session.setAttribute("errorMessage", "Vui lòng cung cấp lý do từ chối.");
            // Có thể chuyển lại trang chi tiết bài viết hoặc form duyệt với lỗi
            response.sendRedirect(request.getContextPath() + "/posts?action=list"); // Hoặc previewOwnPost nếu có
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            String newStatus = "approve".equals(taskType) ? "approved" : "rejected";
            String finalReason = "rejected".equals(newStatus) ? reasonForRejection : null;

            boolean updated = postDAO.approvePost(postId, newStatus, finalReason);
            if (updated) {
                session.setAttribute("successMessage", "approve".equals(taskType) ? "Duyệt bài viết thành công!" : "Từ chối bài viết thành công!");
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết hoặc có lỗi khi cập nhật trạng thái.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài viết không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/posts?action=list");
    }

    // --- Các phương thức private đã có hoặc đã được cung cấp ở các phản hồi trước ---
    private void listPosts(HttpServletRequest request, HttpServletResponse response, User user)
            throws SQLException, ServletException, IOException {

        String searchKeywordParam = request.getParameter("searchKeyword");
        String emailKeywordParam = request.getParameter("emailKeyword"); // Chỉ admin mới dùng
        String statusKeywordParam = request.getParameter("statusKeyword");
        String pageParam = request.getParameter("page");

        // Xử lý giá trị null hoặc rỗng cho keyword để tránh lỗi SQL LIKE '%%' không cần thiết
        String searchKeyword = (searchKeywordParam != null && !searchKeywordParam.trim().isEmpty()) ? searchKeywordParam.trim() : null;
        String emailKeyword = (emailKeywordParam != null && !emailKeywordParam.trim().isEmpty() && "admin".equals(user.getRole())) ? emailKeywordParam.trim() : null;
        String statusKeyword = (statusKeywordParam != null && !statusKeywordParam.trim().isEmpty()) ? statusKeywordParam.trim() : null;

        int page = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
        int pageSize = 10; // Số bài viết mỗi trang, có thể điều chỉnh

        List<Post> postsList = postDAO.getPostsByUserId(user.getId(), user.getRole(),
                searchKeyword, emailKeyword, statusKeyword,
                page, pageSize);
        int totalPosts = postDAO.getTotalPostsByUserIdCount(user.getId(), user.getRole(),
                searchKeyword, emailKeyword, statusKeyword);
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize);

        request.setAttribute("posts", postsList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Gửi lại các tham số filter để JSP có thể hiển thị lại chúng
        request.setAttribute("searchKeyword", searchKeywordParam); // Gửi lại giá trị gốc (có thể rỗng)
        if ("admin".equals(user.getRole())) {
            request.setAttribute("emailKeyword", emailKeywordParam);
        }
        request.setAttribute("statusKeyword", statusKeywordParam);
        request.setAttribute("contextPath", request.getContextPath());

        request.getRequestDispatcher("/listpost.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Post post)
            throws ServletException, IOException {
        if (post != null) {
            request.setAttribute("post", post);
            // request.setAttribute("action", "edit"); // action đã được set ở doGet
        } else {
            // request.setAttribute("action", "create"); // action đã được set ở doGet
        }
        request.getRequestDispatcher("/postForm.jsp").forward(request, response);
    }

    private void listPublicPosts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pageParam = request.getParameter("page");
        String searchKeyword = request.getParameter("searchKeyword"); // Lấy từ khóa tìm kiếm

        int page = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
        int pageSize = 9; // Số bài viết mỗi trang, có thể điều chỉnh (ví dụ 3x3 grid)

        // Truyền searchKeyword vào DAO
        List<Post> publicPosts = postDAO.getAllApprovedPosts(page, pageSize, searchKeyword);
        int totalPosts = postDAO.getTotalApprovedPostsCount(searchKeyword);
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize);

        request.setAttribute("publicPosts", publicPosts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("contextPath", request.getContextPath());
        if (searchKeyword != null) { // Gửi lại searchKeyword để JSP có thể điền vào ô tìm kiếm và link phân trang
            request.setAttribute("searchKeyword", searchKeyword);
        }
        request.getRequestDispatcher("/publicPostsList.jsp").forward(request, response);
    }

    private void viewSinglePublicPost(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("errorMessage", "Không có ID bài viết được cung cấp.");
            request.getRequestDispatcher("/publicPostsList.jsp").forward(request, response);
            return;
        }
        try {
            int postId = Integer.parseInt(idParam);
            Post postToView = postDAO.getPostById(postId);

            if (postToView == null || !"approved".equals(postToView.getStatus())) {
                request.setAttribute("errorMessage", "Bài viết không tồn tại hoặc chưa được duyệt.");
                listPublicPosts(request, response);
                return;
            }
            request.setAttribute("postToView", postToView);
            request.setAttribute("contextPath", request.getContextPath());
            request.getRequestDispatcher("/viewPublicPostDetails.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID bài viết không hợp lệ.");
            listPublicPosts(request, response);
        }
    }

    private void previewOwnPost(HttpServletRequest request, HttpServletResponse response, User currentUser, HttpSession session) // Thêm session
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("errorMessage", "Không có ID bài viết được cung cấp để xem trước.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
            return;
        }
        try {
            int postId = Integer.parseInt(idParam);
            Post postToPreview = postDAO.getPostById(postId);

            if (postToPreview == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết để xem trước.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }
            if (!"admin".equals(currentUser.getRole()) && postToPreview.getUserId() != currentUser.getId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền xem trước bài viết này.");
                response.sendRedirect(request.getContextPath() + "/posts?action=list");
                return;
            }
            request.setAttribute("postToPreview", postToPreview);
            request.setAttribute("contextPath", request.getContextPath());
            request.getRequestDispatcher("/previewOwnPostDetails.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài viết không hợp lệ để xem trước.");
            response.sendRedirect(request.getContextPath() + "/posts?action=list");
        }
    }

    private void handleContentImageUpload(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Kiểm tra quyền upload ảnh content (quan trọng)
        if (user == null || (!"admin".equals(user.getRole()) && !"business".equals(user.getRole()))) {
            System.out.println("PostServlet - Unauthorized content image upload by: " + (user != null ? user.getEmail() : "Guest"));
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Bạn không có quyền tải ảnh lên.\"}");
            out.flush();
            return;
        }
        try {
            Part filePart = request.getPart("image"); // QuillJS gửi với name 'image'
            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Không có file ảnh nào được gửi lên.\"}");
                out.flush();
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = "";
            int i = originalFileName.lastIndexOf('.');
            if (i > 0) {
                fileExtension = originalFileName.substring(i);
            }
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

            String applicationPath = request.getServletContext().getRealPath("");
            String targetUploadDir = applicationPath + File.separator + UPLOAD_DIR_BASE + File.separator + CONTENT_IMAGE_SUBDIR;

            Path uploadDirPath = Paths.get(targetUploadDir);
            if (!Files.exists(uploadDirPath)) {
                Files.createDirectories(uploadDirPath);
            }

            Path filePath = Paths.get(targetUploadDir + File.separator + uniqueFileName);
            try (var inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            String imageUrl = request.getContextPath() + "/" + UPLOAD_DIR_BASE + "/" + CONTENT_IMAGE_SUBDIR + "/" + uniqueFileName;
            out.print("{\"imageUrl\": \"" + imageUrl + "\"}");
            System.out.println("DEBUG [Servlet uploadContentImage]: Image uploaded: " + imageUrl);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Lỗi server khi xử lý upload: " + e.getMessage().replace("\"", "'") + "\"}");
            e.printStackTrace();
        }
        out.flush();
    }

    private void handleGenericError(Exception ex, String logMessagePrefix, HttpServletRequest request, HttpServletResponse response, User user, boolean isPublicAction)
            throws ServletException, IOException {
        System.err.println(logMessagePrefix + ex.getMessage());
        ex.printStackTrace();
        HttpSession session = request.getSession(false); // Không tạo mới
        String errorMessage = "Đã có lỗi xảy ra. Vui lòng thử lại sau."; // Thông báo chung cho người dùng

        // Ghi log chi tiết hơn cho admin/dev
        // LogManager.getLogger(this.getClass()).error(logMessagePrefix, ex); 
        if (isPublicAction) {
            request.setAttribute("errorMessage", errorMessage);
        } else if (session != null) {
            session.setAttribute("errorMessage", errorMessage);
        } else {
            request.setAttribute("errorMessage", errorMessage); // Fallback
        }

        try {
            if (!response.isCommitted()) {
                String redirectPath;
                if (isPublicAction) {
                    redirectPath = "/posts?action=publicList";
                } else if (user != null) {
                    redirectPath = "/posts?action=list";
                } else {
                    redirectPath = "/login.jsp";
                }
                response.sendRedirect(request.getContextPath() + redirectPath);
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi redirect từ handleGenericError: " + e.getMessage());
        }
    }
}
