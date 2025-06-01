<%-- File: listpost.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách Bài viết</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            /* ... (CSS giữ nguyên như phiên bản trước đó của listpost.jsp) ... */
            :root {
                --primary-color: #5D87FF;
                --primary-hover-color: #4A75E0;
                --secondary-color: #F6F9FC;
                --card-bg-color: #FFFFFF;
                --text-color: #333A47;
                --text-muted-color: #77808B;
                --border-color: #E5E9F2;
                --input-bg-color: #FDFEFF;
                --font-family: 'Inter', sans-serif;
                --box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                --border-radius: 8px;
                --danger-color: #fa896b;
                --danger-hover-color: #e67e5f;
                --success-color: #13deb9;
                --success-hover-color: #11c5a1;
                --info-color: #17a2b8;
                --info-hover-color: #138496; /* Màu cho nút submit bản nháp */
                --warning-color: #ffc107;
                --warning-hover-color: #e0a800; /* Màu cho trạng thái nháp */
            }
            body {
                background-color: var(--secondary-color);
                font-family: var(--font-family);
                color: var(--text-color);
                margin: 0;
                padding: 0;
                line-height: 1.6;
            }
            .navbar-custom {
                background-color: var(--card-bg-color);
                padding: 12px 30px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid var(--border-color);
                position: sticky;
                top:0;
                z-index: 1020;
            }
            .navbar-custom .brand {
                font-size: 1.4rem;
                font-weight: 600;
                color: var(--primary-color);
                text-decoration: none;
            }
            .navbar-custom .nav-links a {
                color: var(--text-muted-color);
                text-decoration: none;
                margin-left: 20px;
                font-weight: 500;
                transition: color 0.3s ease;
            }
            .navbar-custom .nav-links a:hover {
                color: var(--primary-color);
            }
            .page-wrapper {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0 15px;
            } /* Tăng độ rộng một chút */
            .page-header-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .page-title-custom {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--text-color);
                margin:0;
            }
            .btn-custom {
                padding: 0.6rem 1.2rem;
                font-size: 0.9rem;
                font-weight: 500;
                border-radius: var(--border-radius);
                text-decoration: none;
                transition: all 0.3s ease;
                cursor: pointer;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                box-sizing: border-box;
            }
            .btn-custom i {
                margin-right: 6px;
            }
            .btn-primary-custom {
                background-color: var(--primary-color);
                color: white;
            }
            .btn-primary-custom:hover {
                background-color: var(--primary-hover-color);
            }
            .btn-submit-approval-custom {
                background-color: var(--info-color);
                color: white;
            } /* Nút gửi duyệt từ bản nháp */
            .btn-submit-approval-custom:hover {
                background-color: var(--info-hover-color);
            }

            .table-container {
                background-color: var(--card-bg-color);
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                overflow-x: auto;
            }
            .table-custom {
                width: 100%;
                border-collapse: collapse;
                min-width: 1000px;
            } /* Tăng min-width */
            .table-custom th, .table-custom td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid var(--border-color);
                vertical-align: middle;
            }
            .table-custom th {
                background-color: #f8f9fa;
                font-weight: 600;
                font-size: 0.9rem;
                text-transform: uppercase;
                color: var(--text-muted-color);
            }
            .table-custom td {
                font-size: 0.95rem;
            }
            .table-custom .cover-image-small {
                max-width: 80px;
                max-height: 60px;
                border-radius: 4px;
                object-fit: cover;
            }
            .status-badge {
                padding: .25em .6em;
                font-size: .75em;
                font-weight: 700;
                line-height: 1;
                text-align: center;
                white-space: nowrap;
                vertical-align: baseline;
                border-radius: .25rem;
            }
            .status-pending {
                background-color: #fff3cd;
                color: #664d03;
            }
            .status-approved {
                background-color: #d1e7dd;
                color: #0f5132;
            }
            .status-rejected {
                background-color: #f8d7da;
                color: #842029;
            }
            .status-draft {
                background-color: var(--warning-color);
                color: #fff;
            } /* Màu cho trạng thái Nháp */

            .filter-container {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                align-items: center;
                flex-wrap: wrap;
            }
            .search-input {
                padding: 8px;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                font-size: 0.9rem;
            }
            .status-filter {
                padding: 8px;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                font-size: 0.9rem;
            }
            /* ... (CSS khác giữ nguyên) ... */
            .table-custom .actions {
                white-space: nowrap;
            }
            .table-custom .actions .action-icon {
                margin-right: 10px;
                vertical-align: middle;
                font-size: 1.1rem;
                color: var(--text-muted-color);
                text-decoration: none;
            }
            .table-custom .actions .action-icon:hover {
                color: var(--primary-color);
            }
            .table-custom .actions .action-icon.delete:hover {
                color: var(--danger-color);
            }
            .table-custom .actions .action-buttons-wrapper {
                display: inline-flex;
                flex-direction: column;
                gap: 6px;
                align-items: flex-start;
            }
            .table-custom .actions .action-form-inline, .table-custom .actions .reject-action-group {
                margin: 0;
            }
            .table-custom .actions .action-buttons-wrapper .btn-custom {
                min-width: 80px;
                height: 32px;
                padding: 0.4rem 0.8rem;
                font-size: 0.8rem;
            }
            .table-custom .actions .reject-form-inline {
                display: none;
                flex-direction: column;
                gap: 6px;
                padding: 8px;
                border: 1px solid var(--border-color);
                border-radius: var(--border-radius);
                background-color: var(--input-bg-color);
                margin-top: 4px;
                min-width: 200px;
                max-width: 250px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .table-custom .actions .reject-reason-input {
                width: 100%;
                padding: 6px 8px;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                font-size: 0.8rem;
                min-height: 40px;
                max-height: 60px;
                box-sizing: border-box;
                resize: vertical;
                font-family: inherit;
            }
            .table-custom .actions .reject-form-inline .btn-custom {
                width: 100%;
                padding: 0.4rem 0.6rem;
                height: 30px;
                font-size: 0.8rem;
                justify-self: center;
            }
            .table-custom td.reason-column {
                max-width: 200px;
                word-wrap: break-word;
                word-break: break-word;
                white-space: normal;
                line-height: 1.4;
                font-size: 0.85rem;
                color: var(--text-muted-color);
            }
            .post-title-link {
                font-weight: 500;
                color: var(--text-color);
                text-decoration: none;
            }
            .post-title-link:hover {
                color: var(--primary-color);
                text-decoration: underline;
            }
            .status-message, .error-message-box {
                padding: 10px 15px;
                margin-bottom: 20px;
                border-radius: var(--border-radius);
                font-size: 0.9rem;
            }
            .status-message {
                background-color: #e6fffa;
                border: 1px solid var(--success-color);
                color: #00695c;
            }
            .error-message-box {
                background-color: #ffebee;
                border: 1px solid var(--danger-color);
                color: #c62828;
            }
            .footer-custom {
                text-align: center;
                padding: 30px 15px;
                font-size: 0.9rem;
                color: var(--text-muted-color);
                margin-top: 40px;
            }

        </style>
    </head>
    <body>
        <header class="navbar-custom">
            <a href="${pageContext.request.contextPath}/index.jsp" class="brand">AgriculturePromotion</a>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/posts?action=list">Quản lý Bài viết</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Cài đặt</a>
            </nav>
        </header>

        <div class="page-wrapper">
            <div class="page-header-flex">
                <h1 class="page-title-custom">Danh sách Bài viết của Bạn</h1>
                <c:if test="${sessionScope.user.role == 'admin' || sessionScope.user.role == 'business'}">
                    <a href="${pageContext.request.contextPath}/posts?action=create" class="btn-custom btn-primary-custom">
                        <i class="bi bi-plus-circle"></i> Tạo Bài viết Mới
                    </a>
                </c:if>
            </div>

            <div class="filter-container">
                <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm theo tiêu đề..." style="width: 250px;" value="${fn:escapeXml(param.searchKeyword)}">
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <input type="text" id="emailFilter" class="search-input" placeholder="Lọc theo email người đăng..." style="width: 200px;" value="${fn:escapeXml(param.emailKeyword)}">
                </c:if>
                <select id="statusFilter" class="status-filter">
                    <option value="">Tất cả trạng thái</option>
                    <option value="draft" ${param.statusKeyword == 'draft' ? 'selected' : ''}>Nháp</option>
                    <option value="pending" ${param.statusKeyword == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                    <option value="approved" ${param.statusKeyword == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                    <option value="rejected" ${param.statusKeyword == 'rejected' ? 'selected' : ''}>Bị từ chối</option>
                </select>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="status-message"><c:out value="${sessionScope.successMessage}"/></div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="error-message-box"><c:out value="${sessionScope.errorMessage}"/></div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty posts}">
                        <table class="table-custom" id="postTable">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Ảnh bìa</th>
                                    <th>Tiêu đề</th>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                        <th>Người đăng</th>
                                        </c:if>
                                    <th>Trạng thái</th>
                                    <th>Note</th>
                                    <th>Ngày tạo</th>
                                    <th>Ngày cập nhật</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${posts}" varStatus="loop">
                                    <tr data-status="${p.status}" data-email="${fn:toLowerCase(p.email)}" data-title="${fn:toLowerCase(p.title)}">
                                        <td>${loop.index + 1}</td>
                                        <td>
                                            <c:if test="${not empty p.imageUrl}">
                                                <img src="${pageContext.request.contextPath}/Uploads/${p.imageUrl}" alt="Cover" class="cover-image-small"/>
                                            </c:if>
                                            <c:if test="${empty p.imageUrl}"><span>N/A</span></c:if>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/posts?action=previewOwnPost&id=${p.id}" class="post-title-link" title="Xem trước bài viết">
                                                <c:out value="${p.title}"/>
                                            </a>
                                        </td>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                            <td><c:out value="${p.email}"/></td>
                                        </c:if>
                                        <td>
                                            <span class="status-badge
                                                  <c:choose>
                                                      <c:when test="${p.status == 'pending'}">status-pending</c:when>
                                                      <c:when test="${p.status == 'approved'}">status-approved</c:when>
                                                      <c:when test="${p.status == 'rejected'}">status-rejected</c:when>
                                                      <c:when test="${p.status == 'draft'}">status-draft</c:when> <%-- Thêm class cho draft --%>
                                                  </c:choose>
                                                  ">
                                                <c:choose>
                                                    <c:when test="${p.status == 'pending'}">Chờ duyệt</c:when>
                                                    <c:when test="${p.status == 'approved'}">Đã duyệt</c:when>
                                                    <c:when test="${p.status == 'rejected'}">Bị từ chối</c:when>
                                                    <c:when test="${p.status == 'draft'}">Nháp</c:when> <%-- Hiển thị text cho draft --%>
                                                    <c:otherwise><c:out value="${p.status}"/></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="reason-column"><c:out value="${p.reasonForRejection}"/></td>
                                        <td><fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><fmt:formatDate value="${p.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="actions">
                                            <div class="action-buttons-wrapper">
                                                <%-- Nút "Gửi Duyệt" cho bài nháp hoặc bị từ chối, chỉ chủ sở hữu hoặc admin --%>
                                                <c:if test="${(p.status == 'draft' || p.status == 'rejected') && (sessionScope.user.role == 'admin' || p.userId == sessionScope.user.id)}">
                                                    <form action="${pageContext.request.contextPath}/posts" method="post" class="action-form-inline">
                                                        <input type="hidden" name="action" value="submitDraftForApproval"/>
                                                        <input type="hidden" name="id" value="${p.id}"/>
                                                        <button type="submit" class="btn-custom btn-submit-approval-custom" title="Gửi duyệt bài viết này">
                                                            <i class="bi bi-send-check"></i> Gửi Duyệt
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <%-- Các icon Sửa/Xóa --%>
                                                <div style="display:flex; gap: 5px; margin-top: <c:if test='${(p.status == "draft" || p.status == "rejected") && (sessionScope.user.role == "admin" || p.userId == sessionScope.user.id)}'>8px</c:if>;">
                                                    <c:if test="${sessionScope.user.role == 'admin' || p.userId == sessionScope.user.id}">
                                                        <a href="${pageContext.request.contextPath}/posts?action=edit&id=${p.id}" title="Chỉnh sửa" class="action-icon"><i class="bi bi-pencil-square"></i></a>
                                                        <a href="${pageContext.request.contextPath}/posts?action=delete&id=${p.id}" class="action-icon delete" title="Xoá" onclick="return confirm('Bạn có chắc chắn muốn xoá bài viết này không?');"><i class="bi bi-trash"></i></a>
                                                        </c:if>
                                                </div>

                                                <%-- Admin: Duyệt/Từ chối bài viết 'pending' --%>
                                                <c:if test="${sessionScope.user.role == 'admin' && p.status == 'pending'}">
                                                    <div class="approve-action-group">
                                                        <form action="${pageContext.request.contextPath}/posts" method="post" class="action-form-inline">
                                                            <input type="hidden" name="action" value="approve"/> <%-- Đây là action của servlet --%>
                                                            <input type="hidden" name="sub_action" value="approve"/> <%-- Đây là hành động cụ thể --%>
                                                            <input type="hidden" name="id" value="${p.id}"/>
                                                            <button type="submit" class="btn-custom btn-approve-custom" title="Duyệt">
                                                                <i class="bi bi-check-circle"></i> Duyệt
                                                            </button>
                                                        </form>
                                                    </div>
                                                    <div class="reject-action-group">
                                                        <button type="button" class="btn-custom btn-reject-custom btn-show-reason" title="Từ chối" data-post-id="${p.id}">
                                                            <i class="bi bi-x-circle"></i> Từ chối
                                                        </button>
                                                        <div class="reject-form-inline" data-form-for-post-id="${p.id}">
                                                            <form action="${pageContext.request.contextPath}/posts" method="post" style="display: flex; flex-direction: column; gap: 6px; width: 100%;">
                                                                <input type="hidden" name="action" value="approve"/> <%-- Action của servlet --%>
                                                                <input type="hidden" name="sub_action" value="reject"/> <%-- Hành động cụ thể --%>
                                                                <input type="hidden" name="id" value="${p.id}"/>
                                                                <textarea name="reasonForRejection" class="reject-reason-input" placeholder="Nhập lý do từ chối..." required></textarea>
                                                                <button type="submit" class="btn-custom btn-reject-custom" title="Gửi lý do từ chối">
                                                                    <i class="bi bi-send"></i> Gửi
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="no-posts">Chưa có bài viết nào. 
                            <c:if test="${sessionScope.user.role == 'admin' || sessionScope.user.role == 'business'}">
                                Hãy <a href="${pageContext.request.contextPath}/posts?action=create">tạo bài viết mới</a>!
                            </c:if>
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <footer class="footer-custom">
            <p>© ${java.time.Year.now()} Agriculture Promotion. All rights reserved.</p>
        </footer>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const searchInput = document.getElementById('searchInput');
                const emailFilterInput = document.getElementById('emailFilter');
                const statusFilter = document.getElementById('statusFilter');
                const table = document.getElementById('postTable');
                const rows = table ? table.tBodies[0].getElementsByTagName('tr') : [];

                // Function to apply all filters
                function applyFilters() {
                    if (!table)
                        return;
                    const searchText = searchInput.value.toLowerCase();
                    const emailText = emailFilterInput ? emailFilterInput.value.toLowerCase() : "";
                    const selectedStatus = statusFilter.value;

                    for (let i = 0; i < rows.length; i++) {
                        const row = rows[i];
                        const title = row.getAttribute('data-title') ? row.getAttribute('data-title').toLowerCase() : "";
                        const email = row.getAttribute('data-email') ? row.getAttribute('data-email').toLowerCase() : "";
                        const status = row.getAttribute('data-status');

                        const matchesSearch = title.includes(searchText);
                        const matchesEmail = (!emailFilterInput || emailFilterInput.value.trim() === "") || email.includes(emailText);
                        const matchesStatus = selectedStatus === "" || status === selectedStatus;

                        if (matchesSearch && matchesEmail && matchesStatus) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                }

                // Event listeners for filters
                if (searchInput)
                    searchInput.addEventListener('input', applyFilters);
                if (emailFilterInput)
                    emailFilterInput.addEventListener('input', applyFilters);
                if (statusFilter)
                    statusFilter.addEventListener('change', applyFilters);

                // Initial filter application if there are pre-filled filter values (e.g. from URL params)
                applyFilters();


                // Handle showing/hiding reject reason form
                const allShowReasonButtons = document.querySelectorAll('.btn-show-reason');
                allShowReasonButtons.forEach(button => {
                    button.addEventListener('click', function (event) {
                        event.preventDefault();
                        event.stopPropagation();
                        const postId = this.getAttribute('data-post-id');
                        const rejectForm = document.querySelector('.reject-form-inline[data-form-for-post-id="' + postId + '"]');
                        const actionButtonsWrapper = this.closest('.action-buttons-wrapper');
                        const approveGroup = actionButtonsWrapper ? actionButtonsWrapper.querySelector('.approve-action-group') : null;

                        if (rejectForm) {
                            document.querySelectorAll('.reject-form-inline').forEach(form => {
                                if (form !== rejectForm) {
                                    form.style.display = 'none';
                                    const otherPostId = form.getAttribute('data-form-for-post-id');
                                    const otherButton = document.querySelector('.btn-show-reason[data-post-id="' + otherPostId + '"]');
                                    if (otherButton)
                                        otherButton.style.display = 'inline-flex';
                                    const otherApproveGroup = otherButton ? otherButton.closest('.action-buttons-wrapper').querySelector('.approve-action-group') : null;
                                    if (otherApproveGroup)
                                        otherApproveGroup.style.display = 'block';
                                }
                            });

                            if (rejectForm.style.display === 'flex') {
                                rejectForm.style.display = 'none';
                                this.style.display = 'inline-flex';
                                if (approveGroup)
                                    approveGroup.style.display = 'block';
                            } else {
                                this.style.display = 'none';
                                rejectForm.style.display = 'flex';
                                if (approveGroup)
                                    approveGroup.style.display = 'none';
                                const reasonInput = rejectForm.querySelector('.reject-reason-input');
                                if (reasonInput) {
                                    setTimeout(() => reasonInput.focus(), 0);
                                }
                            }
                        }
                    });
                });

                document.addEventListener('click', function (event) {
                    document.querySelectorAll('.reject-form-inline').forEach(form => {
                        if (form.style.display === 'flex') {
                            const postId = form.getAttribute('data-form-for-post-id');
                            const correspondingButton = document.querySelector('.btn-show-reason[data-post-id="' + postId + '"]');
                            if (!form.contains(event.target) && (correspondingButton && !correspondingButton.contains(event.target))) {
                                form.style.display = 'none';
                                if (correspondingButton)
                                    correspondingButton.style.display = 'inline-flex';
                                const actionButtonsWrapper = correspondingButton.closest('.action-buttons-wrapper');
                                const approveGroup = actionButtonsWrapper ? actionButtonsWrapper.querySelector('.approve-action-group') : null;
                                if (approveGroup)
                                    approveGroup.style.display = 'block';
                            }
                        }
                    });
                });

                document.querySelectorAll('.reject-form-inline').forEach(form => {
                    form.addEventListener('click', function (event) {
                        event.stopPropagation();
                    });
                });
            });
        </script>
    </body>
</html>