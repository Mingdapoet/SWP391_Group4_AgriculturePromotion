<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><c:out value="${post.title}" default="Chi tiết Bài viết"/> - Agriculture Promotion</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <%-- CSS của QuillJS Snow theme để hiển thị nội dung đúng định dạng --%>
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <style>
            :root { /* Biến màu cơ bản */
                --primary-color: #28a745;
                --secondary-color: #f8f9fa;
                --text-color: #212529;
                --font-family: 'Inter', sans-serif;
                --border-radius: 8px;
            }
            body {
                font-family: var(--font-family);
                line-height: 1.7;
                margin: 0;
                padding: 0;
                background-color: #eef2f5;
                color: var(--text-color);
            }
            .public-navbar { /* ... (giống như public_posts.jsp) ... */
                background-color: #fff;
                padding: 15px 0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                border-bottom: 3px solid var(--primary-color);
            }
            .public-navbar .container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1140px;
                margin: 0 auto;
                padding: 0 15px;
            }
            .public-navbar .brand {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--primary-color);
                text-decoration: none;
            }
            .public-navbar .nav-links a {
                color: #555;
                text-decoration: none;
                margin-left: 20px;
                font-weight: 500;
            }

            .post-detail-container {
                max-width: 820px;
                margin: 30px auto;
                padding: 30px;
                background-color: #fff;
                border-radius: var(--border-radius);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .post-breadcrumb {
                font-size: 0.9rem;
                color: #6c757d;
                margin-bottom: 15px;
            }
            .post-breadcrumb a {
                color: var(--primary-color);
                text-decoration: none;
            }
            .post-detail-title {
                font-size: 2.5rem;
                font-weight: 700;
                margin-top: 0;
                margin-bottom: 15px;
                color: #333;
            }
            .post-detail-meta {
                font-size: 0.9em;
                color: #777;
                margin-bottom: 25px;
                padding-bottom:15px;
                border-bottom: 1px solid #eee;
            }
            .post-detail-meta i {
                margin-right: 5px;
            }
            .post-detail-cover-image {
                width: 100%;
                max-height: 450px;
                object-fit: cover;
                border-radius: var(--border-radius);
                margin-bottom: 25px;
                border: 1px solid #eee;
            }

            /* Quan trọng: Áp dụng theme Quill cho nội dung được render */
            .post-detail-content.ql-snow {
                font-size: 1.05rem; /* Hoặc kích thước bạn muốn */
            }
            .post-detail-content .ql-editor {
                padding: 0; /* Bỏ padding mặc định của ql-editor nếu không muốn */
            }
            .post-detail-content img {
                max-width: 100%;
                height: auto;
                border-radius: var(--border-radius);
                margin: 15px 0;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .post-detail-content h1, .post-detail-content h2, .post-detail-content h3 {
                margin-top: 1.5em;
                margin-bottom: 0.5em;
                color: #333;
            }
            .post-detail-content p {
                margin-bottom: 1em;
            }
            .post-detail-content ul, .post-detail-content ol {
                padding-left: 1.5em;
                margin-bottom: 1em;
            }
            .post-detail-content blockquote {
                border-left: 4px solid var(--primary-color);
                margin: 1.5em 0;
                padding: 0.5em 1em;
                color: #555;
                background-color: #f9f9f9;
            }
            .post-detail-content pre.ql-syntax {
                background-color: #2d2d2d;
                color: #f8f8f2;
                padding: 1em;
                border-radius: var(--border-radius);
                overflow-x: auto;
            }

            .back-link-container {
                margin-top: 30px;
                text-align: center;
            }
            .back-link-container a {
                display: inline-block;
                padding: 10px 20px;
                background-color: var(--primary-color);
                color: white;
                text-decoration: none;
                border-radius: 20px;
                font-weight: 500;
                transition: background-color 0.3s ease;
            }
            .back-link-container a:hover {
                background-color: #218838;
            }
            .public-footer { /* ... (giống như public_posts.jsp) ... */
                text-align: center;
                padding: 30px 15px;
                font-size: 0.9rem;
                color: #777;
                margin-top: 40px;
                background-color: #fff;
                border-top: 1px solid #eee;
            }

        </style>
    </head>
    <body>
        <header class="public-navbar">
            <div class="container">
                <a href="${pageContext.request.contextPath}/posts?action=publicList" class="brand">AgriculturePromotion</a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/posts?action=publicList">Trang chủ</a>
                    <a href="#">Về chúng tôi</a>
                    <a href="#">Liên hệ</a>
                </nav>
            </div>
        </header>

        <div class="post-detail-container">
            <c:choose>
                <c:when test="${not empty post}">
                    <div class="post-breadcrumb">
                        <a href="${pageContext.request.contextPath}/posts?action=publicList">Trang chủ</a> &gt; 
                        <span><c:out value="${post.title}"/></span>
                    </div>

                    <h1 class="post-detail-title"><c:out value="${post.title}"/></h1>
                    <div class="post-detail-meta">
                        <span><i class="bi bi-person"></i> Tác giả: <c:out value="${not empty post.authorUsername ? post.authorUsername : 'N/A'}"/></span> |
                        <span><i class="bi bi-calendar3"></i> Ngày đăng: <fmt:formatDate value="${post.createdAt}" pattern="EEEE, dd MMMM yyyy 'lúc' HH:mm" locale="vi_VN"/></span>
                        <%-- Bạn có thể không muốn hiển thị status cho public view --%>
                        <%-- <span><i class="bi bi-patch-check"></i> Trạng thái: <c:out value="${post.status}"/></span> --%>
                    </div>

                    <c:if test="${not empty post.imageUrl}">
                        <img src="${pageContext.request.contextPath}/${fn:startsWith(post.imageUrl, 'uploads/') ? '' : 'uploads/'}${post.imageUrl}" alt="Ảnh bìa: <c:out value="${post.title}"/>" class="post-detail-cover-image">
                    </c:if>

                    <%-- Hiển thị nội dung HTML (bao gồm cả ảnh Base64) --%>
                    <%-- Thêm class ql-snow và ql-editor để áp dụng styles của Quill --%>
                    <div class="post-detail-content ql-snow">
                        <div class="ql-editor">
                            ${post.content} <%-- EL sẽ tự escape HTML. Để render HTML, dùng c:out escapeXml="false" CẨN THẬN --%>
                            <%-- <c:out value="${post.content}" escapeXml="false"/> --%> 
                            <%-- CẢNH BÁO: escapeXml="false" có thể gây ra lỗ hổng XSS nếu content không được làm sạch.
                                 Tuy nhiên, để hiển thị định dạng từ QuillJS (bao gồm Base64 images), bạn CẦN render HTML.
                                 Đảm bảo bạn hiểu rõ rủi ro hoặc có cơ chế làm sạch HTML nếu nguồn gốc content không đáng tin cậy.
                                 Vì content này do admin/business tạo, có thể chấp nhận rủi ro này ở mức độ nào đó.
                            --%>
                        </div>
                    </div>
                    <div class="back-link-container">
                        <a href="${pageContext.request.contextPath}/posts?action=publicList"><i class="bi bi-arrow-left-circle"></i> Quay lại danh sách</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>Không tìm thấy bài viết hoặc bạn không có quyền xem.</p>
                    <div class="back-link-container">
                        <a href="${pageContext.request.contextPath}/posts?action=publicList"><i class="bi bi-arrow-left-circle"></i> Quay lại danh sách</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <footer class="public-footer">
            <p>&copy; ${java.time.Year.now()} Agriculture Promotion. All rights reserved.</p>
        </footer>
    </body>
</html>