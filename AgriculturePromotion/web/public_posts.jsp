<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bài viết nổi bật - Agriculture Promotion</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root { /* Biến màu cơ bản */
            --primary-color: #28a745; /* Màu xanh lá cây cho nông nghiệp */
            --secondary-color: #f8f9fa;
            --text-color: #333;
            --font-family: 'Inter', sans-serif;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        body { font-family: var(--font-family); line-height: 1.6; margin: 0; padding: 0; background-color: #eef2f5; color: var(--text-color); }
        .public-navbar { background-color: #fff; padding: 15px 0; box-shadow: var(--box-shadow); border-bottom: 3px solid var(--primary-color); }
        .public-navbar .container { display: flex; justify-content: space-between; align-items: center; max-width: 1140px; margin: 0 auto; padding: 0 15px;}
        .public-navbar .brand { font-size: 1.8rem; font-weight: 700; color: var(--primary-color); text-decoration: none; }
        .public-navbar .nav-links a { color: #555; text-decoration: none; margin-left: 20px; font-weight: 500; transition: color 0.3s ease; }
        .public-navbar .nav-links a:hover { color: var(--primary-color); }

        .page-container { max-width: 1140px; margin: 30px auto; padding: 0 15px; }
        .page-title { font-size: 2.2rem; font-weight: 700; color: var(--primary-color); margin-bottom: 30px; text-align: center; }
        
        .post-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 25px; }
        .post-card { background-color: #fff; border-radius: var(--border-radius); box-shadow: var(--box-shadow); overflow: hidden; display: flex; flex-direction: column; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .post-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.15); }
        .post-card-image-link { display: block; width: 100%; height: 200px; overflow: hidden; }
        .post-card-image { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease; }
        .post-card:hover .post-card-image { transform: scale(1.05); }
        .post-card-content { padding: 20px; flex-grow: 1; display: flex; flex-direction: column;}
        .post-card-title { font-size: 1.4rem; font-weight: 600; margin-top: 0; margin-bottom: 10px; }
        .post-card-title a { text-decoration: none; color: #333; transition: color 0.3s ease; }
        .post-card-title a:hover { color: var(--primary-color); }
        .post-card-meta { font-size: 0.85rem; color: #777; margin-bottom: 15px; }
        .post-card-excerpt { font-size: 0.95rem; color: #555; flex-grow: 1; margin-bottom: 15px; /* Giới hạn số dòng nếu cần */ overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; }
        .post-card-readmore a { display: inline-block; font-weight: 500; color: var(--primary-color); text-decoration: none; transition: background-color 0.3s ease; padding: 8px 15px; border: 1px solid var(--primary-color); border-radius: 20px; }
        .post-card-readmore a:hover { background-color: var(--primary-color); color: white; }
        .no-posts-message { text-align: center; font-size: 1.2rem; color: #777; padding: 50px 0; }
        .public-footer { text-align: center; padding: 30px 15px; font-size: 0.9rem; color: #777; margin-top: 40px; background-color: #fff; border-top: 1px solid #eee;}
    </style>
</head>
<body>
    <header class="public-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/posts?action=publicList" class="brand">AgriculturePromotion</a>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/posts?action=publicList">Trang chủ</a>
                <a href="#">Giới thiệu</a>
                <a href="#">Sản phẩm</a>
                <a href="#">Liên hệ</a>
                <%-- Link đăng nhập/đăng ký hoặc trang quản trị nếu cần --%>
                <c:if test="${empty loggedInUser}">
                    <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                </c:if>
                <c:if test="${not empty loggedInUser}">
                     <a href="${pageContext.request.contextPath}/posts?action=list">Quản lý bài viết</a>
                </c:if>
            </nav>
        </div>
    </header>

    <div class="page-container">
        <h1 class="page-title">${empty viewTitle ? 'Tin tức Nông nghiệp' : viewTitle}</h1>

        <c:if test="${not empty errorMessage}">
            <p class="error-message-box" style="text-align:center; padding:15px; background-color:#f8d7da; color:#721c24; border-radius:var(--border-radius); margin-bottom:20px;">${errorMessage}</p>
        </c:if>

        <c:choose>
            <c:when test="${not empty posts && fn:length(posts) > 0}">
                <div class="post-grid">
                    <c:forEach var="post" items="${posts}">
                        <div class="post-card">
                            <a href="${pageContext.request.contextPath}/posts?action=view&id=${post.id}" class="post-card-image-link">
                                <c:choose>
                                    <c:when test="${not empty post.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/${fn:startsWith(post.imageUrl, 'uploads/') ? '' : 'uploads/'}${post.imageUrl}" alt="<c:out value='${post.title}'/>" class="post-card-image">
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Ảnh placeholder nếu không có ảnh bìa --%>
                                        <img src="https://via.placeholder.com/400x250.png?text=No+Image" alt="No image available" class="post-card-image">
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="post-card-content">
                                <h2 class="post-card-title">
                                    <a href="${pageContext.request.contextPath}/posts?action=view&id=${post.id}"><c:out value="${post.title}"/></a>
                                </h2>
                                <div class="post-card-meta">
                                    <i class="bi bi-person-fill"></i> <c:out value="${not empty post.authorUsername ? post.authorUsername : 'Ẩn danh'}"/> | 
                                    <i class="bi bi-calendar-event-fill"></i> <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy"/>
                                </div>
                                <%--
                                <p class="post-card-excerpt">
                                    <%-- Trích đoạn ngắn (nếu có, hoặc lấy từ content) --%>
                                    <%-- <c:out value="${fn:substring(post.content, 0, 150)}"/>... --%>
                                </p>
                                --%>
                                <div class="post-card-readmore">
                                    <a href="${pageContext.request.contextPath}/posts?action=view&id=${post.id}">Đọc thêm <i class="bi bi-arrow-right-short"></i></a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <p class="no-posts-message">Hiện chưa có bài viết nào được công khai.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="public-footer">
        <p>&copy; ${java.time.Year.now()} Agriculture Promotion. All rights reserved.</p>
    </footer>
</body>
</html>