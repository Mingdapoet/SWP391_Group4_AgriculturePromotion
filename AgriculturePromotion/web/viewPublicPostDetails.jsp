<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${fn:escapeXml(postToView.title)} - Agriculture Promotion</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
     <link href="https://cdn.quilljs.com/1.3.6/quill.core.css" rel="stylesheet"> <%-- Chỉ cần core CSS của Quill để hiển thị --%>
    <style>
        :root { /* CSS variables */
            --primary-color: #5D87FF; --text-color: #333A47;
            --secondary-color: #F6F9FC; --card-bg-color: #FFFFFF;
            --text-muted-color: #77808B; --border-color: #E5E9F2;
            --font-family: 'Inter', sans-serif; --box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            --border-radius: 8px;
        }
        body { background-color: var(--secondary-color); font-family: var(--font-family); color: var(--text-color); margin: 0; padding: 0; line-height: 1.6; }
        .navbar-custom { background-color: var(--card-bg-color); padding: 12px 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .navbar-custom .brand { font-size: 1.4rem; font-weight: 600; color: var(--primary-color); text-decoration: none; }
        .navbar-custom .nav-links a { color: var(--text-muted-color); text-decoration: none; margin-left: 20px; font-weight: 500; }
        .page-wrapper { max-width: 800px; margin: 30px auto; padding: 0 15px; }
        .post-detail-container {
            background-color: var(--card-bg-color);
            padding: 30px 40px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        .post-title { font-size: 2.2rem; font-weight: 700; color: var(--text-color); margin-bottom: 15px; line-height: 1.3; }
        .post-meta { font-size: 0.9rem; color: var(--text-muted-color); margin-bottom: 25px; border-bottom: 1px solid var(--border-color); padding-bottom: 15px; }
        .post-cover-image { width: 100%; max-height: 400px; object-fit: cover; border-radius: var(--border-radius); margin-bottom: 25px; }
        .post-content { /* Quill content styles */ }
        .post-content h1, .post-content h2, .post-content h3 { margin-top: 1.5em; margin-bottom: 0.5em; line-height: 1.2; }
        .post-content p { margin-bottom: 1em; }
        .post-content blockquote { border-left: 4px solid var(--primary-color); margin-left: 0; padding-left: 1em; color: #666; font-style: italic; }
        .post-content pre.ql-syntax { background-color: #f6f8fa; padding: 1em; border-radius: var(--border-radius); overflow-x: auto; } /* Cho code block nếu có */
        .post-content img { max-width: 100%; height: auto; border-radius: var(--border-radius); margin: 10px 0; }
        .back-link { display: inline-block; margin-top: 30px; color: var(--primary-color); text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; padding: 1rem; margin-bottom: 1rem; border-radius: var(--border-radius); }
        .footer-custom { text-align: center; padding: 20px; margin-top: 40px; font-size: 0.9rem; color: var(--text-muted-color); border-top: 1px solid var(--border-color); }
    </style>
</head>
<body>
    <header class="navbar-custom">
        <a href="${contextPath}/index.jsp" class="brand">AgriculturePromotion</a>
         <nav class="nav-links">
            <a href="${contextPath}/posts?action=publicList">Xem tất cả bài viết</a>
            <c:if test="${empty sessionScope.user}">
                 <a href="${contextPath}/login.jsp">Đăng nhập</a>
            </c:if>
             <c:if test="${not empty sessionScope.user}">
                 <a href="${contextPath}/dashboard.jsp">Dashboard</a>
                 <a href="${contextPath}/logout">Đăng xuất</a>
            </c:if>
        </nav>
    </header>

    <div class="page-wrapper">
        <c:choose>
            <c:when test="${not empty postToView}">
                <article class="post-detail-container">
                    <h1 class="post-title">${fn:escapeXml(postToView.title)}</h1>
                    <p class="post-meta">
                        Đăng bởi: ${fn:escapeXml(postToView.email)} | 
                        Cập nhật lần cuối: <fmt:formatDate value="${postToView.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>

                    <c:if test="${not empty postToView.imageUrl}">
                        <img src="${contextPath}/Uploads/${postToView.imageUrl}" alt="Ảnh bìa ${fn:escapeXml(postToView.title)}" class="post-cover-image">
                    </c:if>

                    <div class="post-content ql-editor"> <%-- Thêm class ql-editor để Quill CSS có thể áp dụng --%>
                        <c:out value="${postToView.content}" escapeXml="false" />
                    </div>
                    <a href="${contextPath}/posts?action=publicList" class="back-link"><i class="bi bi-arrow-left"></i> Quay lại danh sách</a>
                </article>
            </c:when>
            <c:otherwise>
                <div class="alert alert-danger">
                    <c:choose>
                        <c:when test="${not empty errorMessage}">
                            <c:out value="${errorMessage}"/>
                        </c:when>
                        <c:otherwise>
                            Không tìm thấy bài viết hoặc bài viết không được phép hiển thị.
                        </c:otherwise>
                    </c:choose>
                </div>
                 <a href="${contextPath}/posts?action=publicList" class="back-link"><i class="bi bi-arrow-left"></i> Quay lại danh sách</a>
            </c:otherwise>
        </c:choose>
    </div>
     <footer class="footer-custom">
         <p>© ${java.time.Year.now()} Agriculture Promotion. All rights reserved.</p>
    </footer>
</body>
</html>