<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem trước: ${fn:escapeXml(postToPreview.title)} - Agriculture Promotion</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://cdn.quilljs.com/1.3.6/quill.core.css" rel="stylesheet"> 
    <style>
        :root { /* CSS variables */
            --primary-color: #5D87FF; --text-color: #333A47;
            --secondary-color: #F6F9FC; --card-bg-color: #FFFFFF;
            --text-muted-color: #77808B; --border-color: #E5E9F2;
            --font-family: 'Inter', sans-serif; --box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            --border-radius: 8px;
            --status-pending-bg: #fff3cd; --status-pending-text: #664d03;
            --status-approved-bg: #d1e7dd; --status-approved-text: #0f5132;
            --status-rejected-bg: #f8d7da; --status-rejected-text: #842029;
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
            position: relative; /* Để định vị nút Edit tuyệt đối nếu muốn */
        }
        .post-title { font-size: 2.2rem; font-weight: 700; color: var(--text-color); margin-bottom: 10px; line-height: 1.3; }
        .post-status-badge {
            display: inline-block;
            padding: 0.35em 0.65em;
            font-size: .8em;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: .25rem;
            margin-bottom: 15px;
        }
        .status-pending { background-color: var(--status-pending-bg); color: var(--status-pending-text); }
        .status-approved { background-color: var(--status-approved-bg); color: var(--status-approved-text); }
        .status-rejected { background-color: var(--status-rejected-bg); color: var(--status-rejected-text); }
        .post-meta { font-size: 0.9rem; color: var(--text-muted-color); margin-bottom: 25px; border-bottom: 1px solid var(--border-color); padding-bottom: 15px; }
        .post-cover-image { width: 100%; max-height: 400px; object-fit: cover; border-radius: var(--border-radius); margin-bottom: 25px; }
        .post-content { /* Quill content styles */ }
        .post-content h1, .post-content h2, .post-content h3 { margin-top: 1.5em; margin-bottom: 0.5em; line-height: 1.2; }
        .post-content p { margin-bottom: 1em; }
        .post-content blockquote { border-left: 4px solid var(--primary-color); margin-left: 0; padding-left: 1em; color: #666; font-style: italic; }
        .post-content pre.ql-syntax { background-color: #f6f8fa; padding: 1em; border-radius: var(--border-radius); overflow-x: auto; }
        .post-content img { max-width: 100%; height: auto; border-radius: var(--border-radius); margin: 10px 0; }
        .action-buttons { margin-top: 30px; padding-top:20px; border-top: 1px solid var(--border-color); text-align:right; }
        .btn-custom { padding: 0.65rem 1.2rem; font-size: 0.9rem; font-weight: 600; border-radius: var(--border-radius); text-decoration: none; transition: all 0.3s ease; cursor: pointer; border: none; margin-left: 10px; }
        .btn-primary-custom { background-color: var(--primary-color); color: white; }
        .btn-primary-custom:hover { background-color: #4A75E0; }
        .btn-secondary-custom { background-color: #6c757d; color: white; }
        .btn-secondary-custom:hover { background-color: #5a6268; }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; padding: 1rem; margin-bottom: 1rem; border-radius: var(--border-radius); }
        .rejection-reason { margin-top: -10px; margin-bottom: 15px; padding: 10px; background-color: var(--status-rejected-bg); color: var(--status-rejected-text); border: 1px solid var(--border-color); border-radius: var(--border-radius); font-size: 0.9em;}
        .footer-custom { text-align: center; padding: 20px; margin-top: 40px; font-size: 0.9rem; color: var(--text-muted-color); border-top: 1px solid var(--border-color); }

    </style>
</head>
<body>
    <header class="navbar-custom">
        <a href="${contextPath}/index.jsp" class="brand">AgriculturePromotion</a>
         <nav class="nav-links">
            <a href="${contextPath}/posts?action=list">Quản lý Bài viết</a> <%-- Link về trang quản lý của user --%>
            <c:if test="${not empty sessionScope.user}">
                 <a href="${contextPath}/index.jsp">Trang chủ</a>
                 <a href="${contextPath}/logout">Đăng xuất</a>
            </c:if>
        </nav>
    </header>

    <div class="page-wrapper">
        <c:choose>
            <c:when test="${not empty postToPreview}">
                <article class="post-detail-container">
                    <h1 class="post-title">${fn:escapeXml(postToPreview.title)}</h1>

                    <c:set var="statusClass" value=""/>
                    <c:set var="statusText" value="${fn:escapeXml(postToPreview.status)}"/>
                    <c:if test="${postToPreview.status == 'pending'}">
                        <c:set var="statusClass" value="status-pending"/>
                        <c:set var="statusText" value="Chờ duyệt"/>
                    </c:if>
                    <c:if test="${postToPreview.status == 'approved'}">
                        <c:set var="statusClass" value="status-approved"/>
                        <c:set var="statusText" value="Đã duyệt"/>
                    </c:if>
                    <c:if test="${postToPreview.status == 'rejected'}">
                        <c:set var="statusClass" value="status-rejected"/>
                        <c:set var="statusText" value="Bị từ chối"/>
                    </c:if>
                    <span class="post-status-badge ${statusClass}">${statusText}</span>
                    
                    <c:if test="${postToPreview.status == 'rejected' && not empty postToPreview.reasonForRejection}">
                        <div class="rejection-reason">
                            <strong>Lý do từ chối:</strong> ${fn:escapeXml(postToPreview.reasonForRejection)}
                        </div>
                    </c:if>

                    <p class="post-meta">
                        Đăng bởi: ${fn:escapeXml(postToPreview.email)} | 
                        Cập nhật lần cuối: <fmt:formatDate value="${postToPreview.updatedAt}" pattern="dd/MM/yyyy HH:mm"/> |
                        Tạo lúc: <fmt:formatDate value="${postToPreview.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>

                    <c:if test="${not empty postToPreview.imageUrl}">
                        <img src="${contextPath}/Uploads/${postToPreview.imageUrl}" alt="Ảnh bìa ${fn:escapeXml(postToPreview.title)}" class="post-cover-image">
                    </c:if>

                    <div class="post-content ql-editor">
                        <c:out value="${postToPreview.content}" escapeXml="false" />
                    </div>

                    <div class="action-buttons">
                        <a href="${contextPath}/posts?action=list" class="btn-custom btn-secondary-custom">
                            <i class="bi bi-list-ul"></i> Về danh sách quản lý
                        </a>
                        <a href="${contextPath}/posts?action=edit&id=${postToPreview.id}" class="btn-custom btn-primary-custom">
                            <i class="bi bi-pencil-square"></i> Chỉnh sửa bài viết
                        </a>
                    </div>
                </article>
            </c:when>
            <c:otherwise>
                <div class="alert alert-danger">
                     <c:choose>
                        <c:when test="${not empty requestScope.errorMessage}"> <%-- Ưu tiên lỗi từ request do redirect/forward --%>
                            <c:out value="${requestScope.errorMessage}"/>
                        </c:when>
                        <c:when test="${not empty sessionScope.errorMessage}"> <%-- Sau đó là lỗi từ session --%>
                             <c:out value="${sessionScope.errorMessage}"/>
                             <c:remove var="errorMessage" scope="session"/>
                        </c:when>
                        <c:otherwise>
                            Không tìm thấy bài viết hoặc bạn không có quyền xem trước bài viết này.
                        </c:otherwise>
                    </c:choose>
                </div>
                 <a href="${contextPath}/posts?action=list" class="btn-custom btn-secondary-custom"><i class="bi bi-arrow-left"></i> Về danh sách quản lý</a>
            </c:otherwise>
        </c:choose>
    </div>
     <footer class="footer-custom">
    </footer>
</body>
</html>