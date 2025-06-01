<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Bài viết Công Khai - Agriculture Promotion</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #5D87FF; --primary-hover-color: #4A75E0;
            --secondary-color: #F6F9FC; --card-bg-color: #FFFFFF;
            --text-color: #333A47; --text-muted-color: #77808B;
            --border-color: #E5E9F2; --font-family: 'Inter', sans-serif;
            --box-shadow: 0 4px 12px rgba(0,0,0,0.08); --border-radius: 8px;
        }
        body { background-color: var(--secondary-color); font-family: var(--font-family); color: var(--text-color); margin: 0; padding: 0; line-height: 1.6; }
        .navbar-custom { background-color: var(--card-bg-color); padding: 12px 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 1000;}
        .navbar-custom .brand { font-size: 1.4rem; font-weight: 600; color: var(--primary-color); text-decoration: none; }
        .navbar-custom .nav-links a { color: var(--text-muted-color); text-decoration: none; margin-left: 20px; font-weight: 500; transition: color 0.3s ease; }
        .navbar-custom .nav-links a:hover { color: var(--primary-color); }
        .page-wrapper { max-width: 1140px; margin: 30px auto; padding: 0 15px; }
        .page-header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap; /* Cho responsive */
        }
        .page-title-custom { font-size: 2rem; font-weight: 700; color: var(--text-color); margin: 0 0 15px 0; text-align:left;}
        
        .search-form-public {
            display: flex;
            gap: 10px;
            margin-bottom: 25px; /* Hoặc margin-left: auto; để đẩy sang phải nếu trong .page-header-container */
        }
        .search-form-public .search-input-public {
            padding: 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: 1rem;
            flex-grow: 1; /* Cho input chiếm phần lớn không gian */
            min-width: 250px;
        }
        .search-form-public .btn-search-public {
            padding: 10px 20px;
            font-size: 1rem;
            font-weight: 500;
            border-radius: var(--border-radius);
            background-color: var(--primary-color);
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .search-form-public .btn-search-public:hover {
            background-color: var(--primary-hover-color);
        }

        .post-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }
        .post-card {
            background-color: var(--card-bg-color);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            text-decoration: none;
            color: inherit;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.12);
        }
        .post-card img.cover-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
        }
        .post-card-content {
            padding: 20px;
        }
        .post-card h2 {
            margin-top: 0;
            margin-bottom: 0;
            font-size: 1.25rem;
            font-weight: 600;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: calc(1.25rem * 1.4 * 2);
        }
        .no-posts { text-align: center; padding: 40px; font-size: 1.2rem; color: var(--text-muted-color); }
        .pagination { text-align: center; margin-top: 30px; margin-bottom: 30px; }
        .pagination a, .pagination span {
            margin: 0 5px;
            padding: 8px 12px;
            text-decoration: none;
            border: 1px solid var(--border-color);
            color: var(--primary-color);
            border-radius: var(--border-radius);
        }
        .pagination a:hover { background-color: var(--primary-color); color: white; }
        .pagination .current { background-color: var(--primary-color); color: white; border-color: var(--primary-color); }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; padding: 1rem; margin-bottom: 1rem; border-radius: var(--border-radius); }
        .footer-custom { text-align: center; padding: 20px; margin-top: 40px; font-size: 0.9rem; color: var(--text-muted-color); border-top: 1px solid var(--border-color); }
    </style>
</head>
<body>
    <header class="navbar-custom">
        <a href="${contextPath}/index.jsp" class="brand">AgriculturePromotion</a>
         <nav class="nav-links">
            <c:if test="${empty sessionScope.user}">
                 <a href="${contextPath}/login.jsp">Đăng nhập</a>
            </c:if>
            <c:if test="${not empty sessionScope.user}">
                 <a href="${contextPath}/index.jsp">Trang chủ</a>
                 <a href="${contextPath}/logout">Đăng xuất</a>
            </c:if>
        </nav>
    </header>

    <div class="page-wrapper">
        <div class="page-header-container">
            <h1 class="page-title-custom">TIN TỨC NÔNG NGHIỆP</h1>
        </div>

        <form action="${contextPath}/posts" method="get" class="search-form-public">
            <input type="hidden" name="action" value="publicList">
            <input type="text" name="searchKeyword" class="search-input-public" placeholder="Tìm kiếm bài viết..." value="${fn:escapeXml(param.searchKeyword)}">
            <button type="submit" class="btn-search-public"><i class="bi bi-search"></i> Tìm</button>
        </form>


        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger"><c:out value="${errorMessage}"/></div>
        </c:if>
        <c:if test="${not empty param.searchKeyword && empty publicPosts}">
             <p class="no-posts">Không tìm thấy bài viết nào khớp với từ khóa: "<strong><c:out value="${param.searchKeyword}"/></strong>".</p>
        </c:if>

        <c:choose>
            <c:when test="${not empty publicPosts}">
                <div class="post-grid">
                    <c:forEach items="${publicPosts}" var="post">
                        <a href="${contextPath}/posts?action=viewPublicPost&id=${post.id}" class="post-card">
                            <c:if test="${not empty post.imageUrl}">
                                <img src="${contextPath}/Uploads/${post.imageUrl}" alt="${fn:escapeXml(post.title)}" class="cover-image">
                            </c:if>
                            <c:if test="${empty post.imageUrl}">
                                <div style="height: 200px; background-color: #eee; display:flex; align-items:center; justify-content:center;">
                                    <span style="color: var(--text-muted-color);">Không có ảnh</span>
                                </div>
                            </c:if>
                            <div class="post-card-content">
                                <h2>${fn:escapeXml(post.title)}</h2>
                            </div>
                        </a>
                    </c:forEach>
                </div>

                <nav class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="${contextPath}/posts?action=publicList&page=${currentPage - 1}&searchKeyword=${fn:escapeXml(param.searchKeyword)}">&laquo; Trước</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="current">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${contextPath}/posts?action=publicList&page=${i}&searchKeyword=${fn:escapeXml(param.searchKeyword)}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${contextPath}/posts?action=publicList&page=${currentPage + 1}&searchKeyword=${fn:escapeXml(param.searchKeyword)}">Sau &raquo;</a>
                    </c:if>
                </nav>
            </c:when>
            <c:otherwise>
                <c:if test="${empty param.searchKeyword}"> <%-- Chỉ hiển thị nếu không phải là kết quả tìm kiếm rỗng --%>
                    <p class="no-posts">Hiện chưa có bài viết nào được công khai.</p>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
    <footer class="footer-custom">
    </footer>
</body>
</html>