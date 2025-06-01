package domain;

import java.sql.Timestamp;

public class Post {
    private int id;
    private String title;
    private String content;
    private String imageUrl;
    private int userId;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String email; // Thêm email
    private String reasonForRejection; // Thêm lý do từ chối

    // Constructors
    public Post() {
    }

    public Post(int id, String title, String content, String imageUrl, int userId, String status, Timestamp createdAt, Timestamp updatedAt, String email, String reasonForRejection) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.imageUrl = imageUrl;
        this.userId = userId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.email = email;
        this.reasonForRejection = reasonForRejection;
    }

    public Post(String title, String content, String imageUrl, int userId, String status, String email, String reasonForRejection) {
        this.title = title;
        this.content = content;
        this.imageUrl = imageUrl;
        this.userId = userId;
        this.status = status;
        this.email = email;
        this.reasonForRejection = reasonForRejection;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getReasonForRejection() {
        return reasonForRejection;
    }

    public void setReasonForRejection(String reasonForRejection) {
        this.reasonForRejection = reasonForRejection;
    }

    @Override
    public String toString() {
        return "Post{" +
               "id=" + id +
               ", title='" + title + '\'' +
               ", imageUrl='" + imageUrl + '\'' +
               ", userId=" + userId +
               ", status='" + status + '\'' +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               ", email='" + email + '\'' +
               ", reasonForRejection='" + reasonForRejection + '\'' +
               '}';
    }
}