package dal;

import domain.Post;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {

    public boolean addPost(Post post) throws SQLException {
        String sql = "INSERT INTO posts (title, content, image_url, user_id, status, reason_for_rejection) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, post.getTitle());
            pstmt.setString(2, post.getContent());
            pstmt.setString(3, post.getImageUrl());
            pstmt.setInt(4, post.getUserId());
            pstmt.setString(5, post.getStatus());
            pstmt.setString(6, post.getReasonForRejection());
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Post> getAllApprovedPosts(int page, int pageSize, String searchKeyword) throws SQLException {
        List<Post> posts = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT p.id, p.title, p.image_url, p.user_id, p.status, p.created_at, p.updated_at, u.email "
                + // Bỏ p.content ở đây để nhẹ hơn
                "FROM posts p JOIN users u ON p.user_id = u.id "
                + "WHERE p.status = 'approved' "
        );

        List<Object> params = new ArrayList<>();

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sqlBuilder.append("AND p.title LIKE ? ");
            params.add("%" + searchKeyword.trim() + "%");
        }

        sqlBuilder.append("ORDER BY p.updated_at DESC, p.created_at DESC ");
        sqlBuilder.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    // Không lấy content đầy đủ ở list view nữa
                    // post.setContent(rs.getString("content")); 
                    post.setImageUrl(rs.getString("image_url"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setStatus(rs.getString("status"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUpdatedAt(rs.getTimestamp("updated_at"));
                    post.setEmail(rs.getString("email"));
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    // Sửa đổi phương thức này
    public int getTotalApprovedPostsCount(String searchKeyword) throws SQLException {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM posts WHERE status = 'approved' ");
        List<Object> params = new ArrayList<>();

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sqlBuilder.append("AND title LIKE ? ");
            params.add("%" + searchKeyword.trim() + "%");
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean updatePost(Post post) throws SQLException {
        String sql = "UPDATE posts SET title = ?, content = ?, image_url = ?, status = ?, updated_at = GETDATE(), reason_for_rejection = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, post.getTitle());
            pstmt.setString(2, post.getContent());
            pstmt.setString(3, post.getImageUrl());
            pstmt.setString(4, post.getStatus());
            pstmt.setString(5, post.getReasonForRejection());
            pstmt.setInt(6, post.getId());
            pstmt.setInt(7, post.getUserId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public Post getPostById(int id) throws SQLException {
        String sql = "SELECT p.id, p.title, p.content, p.image_url, p.user_id, p.status, p.created_at, p.updated_at, p.reason_for_rejection, u.email "
                + "FROM posts p JOIN users u ON p.user_id = u.id WHERE p.id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setStatus(rs.getString("status"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUpdatedAt(rs.getTimestamp("updated_at"));
                    post.setEmail(rs.getString("email"));
                    post.setReasonForRejection(rs.getString("reason_for_rejection"));
                    return post;
                }
            }
        }
        return null;
    }

    public List<Post> getPostsByUserId(int loggedInUserId, String loggedInUserRole,
                                       String searchKeyword, String emailKeyword, String statusKeyword,
                                       int page, int pageSize) throws SQLException {
        List<Post> posts = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.id, p.title, p.image_url, p.user_id, p.status, p.created_at, p.updated_at, p.reason_for_rejection, u.email " +
                // Không lấy p.content cho danh sách để nhẹ hơn
                "FROM posts p JOIN users u ON p.user_id = u.id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if ("admin".equals(loggedInUserRole)) {
            // Logic cho Admin
            if (emailKeyword != null && !emailKeyword.trim().isEmpty()) {
                // Admin đang tìm kiếm bài viết của một người dùng cụ thể qua email
                sql.append("AND u.email LIKE ? ");
                params.add("%" + emailKeyword.trim() + "%");

                if (statusKeyword != null && !statusKeyword.trim().isEmpty()) {
                    if ("draft".equals(statusKeyword)) {
                        // Admin lọc theo email người khác VÀ trạng thái "Nháp" -> không hiển thị gì cả
                        // vì admin không được xem nháp của người khác.
                        sql.append("AND p.status = 'draft' AND 1=0 "); // Điều kiện luôn sai để không trả về kết quả
                    } else {
                        // Admin lọc theo email người khác VÀ trạng thái khác "Nháp"
                        sql.append("AND p.status = ? ");
                        params.add(statusKeyword);
                    }
                } else {
                    // Admin lọc theo email người khác, xem tất cả các trạng thái (trừ nháp) của người đó
                    sql.append("AND p.status <> 'draft' ");
                }
            } else {
                // Admin KHÔNG lọc theo email cụ thể (xem ευρύτερα)
                if (statusKeyword != null && !statusKeyword.trim().isEmpty()) {
                    if ("draft".equals(statusKeyword)) {
                        // Admin muốn xem trạng thái "Nháp" -> chỉ hiển thị nháp của chính admin
                        sql.append("AND p.status = 'draft' AND p.user_id = ? ");
                        params.add(loggedInUserId);
                    } else {
                        // Admin muốn xem các trạng thái khác "Nháp" -> hiển thị của tất cả user
                        sql.append("AND p.status = ? ");
                        params.add(statusKeyword);
                    }
                } else {
                    // Admin không lọc email, không lọc trạng thái cụ thể
                    // -> Hiển thị: (tất cả bài không phải nháp của mọi người) HOẶC (nháp của chính admin)
                    sql.append("AND (p.status <> 'draft' OR p.user_id = ?) ");
                    params.add(loggedInUserId);
                }
            }
        } else {
            // Logic cho người dùng không phải Admin (ví dụ: business, editor)
            sql.append("AND p.user_id = ? ");
            params.add(loggedInUserId); // Chỉ thấy bài của chính mình
            if (statusKeyword != null && !statusKeyword.trim().isEmpty()) {
                sql.append("AND p.status = ? ");
                params.add(statusKeyword);
            }
            // Nếu statusKeyword rỗng, họ sẽ thấy tất cả bài của mình (bao gồm cả nháp)
        }

        // Lọc theo tiêu đề (chung cho cả admin và non-admin)
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND p.title LIKE ? ");
            params.add("%" + searchKeyword.trim() + "%");
        }

        sql.append("ORDER BY p.updated_at DESC, p.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"); // SQL Server syntax

        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setStatus(rs.getString("status"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUpdatedAt(rs.getTimestamp("updated_at"));
                    post.setEmail(rs.getString("email")); // Lấy từ join với bảng users
                    post.setReasonForRejection(rs.getString("reason_for_rejection"));
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    public int getTotalPostsByUserIdCount(int loggedInUserId, String loggedInUserRole,
                                          String searchKeyword, String emailKeyword, String statusKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM posts p JOIN users u ON p.user_id = u.id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // SAO CHÉP LOGIC TẠO ĐIỀU KIỆN WHERE TỪ getPostsByUserId VÀO ĐÂY
        if ("admin".equals(loggedInUserRole)) {
            if (emailKeyword != null && !emailKeyword.trim().isEmpty()) {
                sql.append("AND u.email LIKE ? ");
                params.add("%" + emailKeyword.trim() + "%");
                if (statusKeyword != null && !statusKeyword.trim().isEmpty()) {
                    if ("draft".equals(statusKeyword)) {
                        sql.append("AND p.status = 'draft' AND 1=0 ");
                    } else {
                        sql.append("AND p.status = ? ");
                        params.add(statusKeyword);
                    }
                } else {
                    sql.append("AND p.status <> 'draft' ");
                }
            } else { // Admin, không lọc email cụ thể
                if (statusKeyword != null && !statusKeyword.trim().isEmpty()) {
                    if ("draft".equals(statusKeyword)) {
                        sql.append("AND p.status = 'draft' AND p.user_id = ? ");
                        params.add(loggedInUserId);
                    } else {
                        sql.append("AND p.status = ? ");
                        params.add(statusKeyword);
                    }
                } else { // Admin, không lọc email, không lọc trạng thái
                    sql.append("AND (p.status <> 'draft' OR p.user_id = ?) ");
                    params.add(loggedInUserId);
                }
            }
        } else { // Người dùng không phải Admin
            sql.append("AND p.user_id = ? ");
            params.add(loggedInUserId);
            if (statusKeyword != null && !statusKeyword.trim().isEmpty()) {
                sql.append("AND p.status = ? ");
                params.add(statusKeyword);
            }
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND p.title LIKE ? ");
            params.add("%" + searchKeyword.trim() + "%");
        }
        // KẾT THÚC PHẦN SAO CHÉP

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean deletePost(int id, int userId, String role) throws SQLException {
        String sql;
        if ("admin".equals(role)) {
            sql = "DELETE FROM posts WHERE id = ?";
        } else {
            sql = "DELETE FROM posts WHERE id = ? AND user_id = ?";
        }
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            if (!"admin".equals(role)) {
                pstmt.setInt(2, userId);
            }
            return pstmt.executeUpdate() > 0;
        }
    }

    public String getImageUrlById(int postId) throws SQLException {
        String sql = "SELECT image_url FROM posts WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("image_url");
                }
            }
        }
        return null;
    }

    public boolean approvePost(int id, String status, String reasonForRejection) throws SQLException {
        String sql = "UPDATE posts SET status = ?, updated_at = GETDATE(), reason_for_rejection = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, reasonForRejection);
            pstmt.setInt(3, id);
            return pstmt.executeUpdate() > 0;
        }
    }
}
