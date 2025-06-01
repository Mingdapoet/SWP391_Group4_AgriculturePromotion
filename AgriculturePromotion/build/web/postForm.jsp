<%-- File: postForm.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty post && not empty post.id ? 'Chỉnh sửa Bài viết' : 'Tạo Bài viết Mới'} - Agriculture Promotion</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #5D87FF; --primary-hover-color: #4A75E0;
            --secondary-color: #F6F9FC; --card-bg-color: #FFFFFF;
            --text-color: #333A47; --text-muted-color: #77808B;
            --border-color: #E5E9F2; --input-bg-color: #FDFEFF;
            --font-family: 'Inter', sans-serif; --box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            --border-radius: 8px;
            --info-color: #17a2b8; --info-hover-color: #138496; /* Màu cho nút Lưu Nháp */
        }
        body { background-color: var(--secondary-color); font-family: var(--font-family); color: var(--text-color); margin: 0; padding: 0; line-height: 1.6; }
        .navbar-custom { background-color: var(--card-bg-color); padding: 12px 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); position: sticky; top:0; z-index: 1020;}
        .navbar-custom .brand { font-size: 1.4rem; font-weight: 600; color: var(--primary-color); text-decoration: none; }
        .navbar-custom .nav-links a { color: var(--text-muted-color); text-decoration: none; margin-left: 20px; font-weight: 500; transition: color 0.3s ease; }
        .navbar-custom .nav-links a:hover { color: var(--primary-color); }
        .page-wrapper { max-width: 960px; margin: 30px auto; padding: 0 15px; }
        .page-header { margin-bottom: 30px; }
        .page-header .breadcrumb-custom { font-size: 0.9rem; color: var(--text-muted-color); margin-bottom: 8px; }
        .page-header .page-title-custom { font-size: 2rem; font-weight: 700; color: var(--text-color); }
        .form-container { background-color: var(--card-bg-color); padding: 30px 35px; border-radius: var(--border-radius); box-shadow: var(--box-shadow); }
        .form-group { margin-bottom: 1.8rem; }
        .form-group label { display: block; margin-bottom: 0.6rem; font-weight: 600; font-size: 0.95rem; color: var(--text-color); }
        .form-control { display: block; width: 100%; padding: 0.75rem 1rem; font-size: 1rem; font-weight: 400; line-height: 1.5; color: var(--text-color); background-color: var(--input-bg-color); background-clip: padding-box; border: 1px solid var(--border-color); border-radius: var(--border-radius); transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out; box-sizing: border-box;}
        .form-control:focus { border-color: var(--primary-color); outline: 0; box-shadow: 0 0 0 0.2rem rgba(93, 135, 255, 0.25); }
        .file-input-wrapper { position: relative; overflow: hidden; display: inline-block; border: 1px dashed var(--border-color); border-radius: var(--border-radius); padding: 15px; text-align: center; cursor: pointer; width: 100%; background-color: var(--input-bg-color); transition: border-color 0.3s ease; box-sizing: border-box;}
        .file-input-wrapper:hover { border-color: var(--primary-color); }
        .file-input-wrapper input[type="file"] { position: absolute; left: 0; top: 0; opacity: 0; width: 100%; height: 100%; cursor: pointer; }
        .file-input-label { color: var(--text-muted-color); font-weight: 500; }
        .file-input-label .bi-upload { font-size: 1.5rem; margin-right: 8px; vertical-align: middle; }
        .image-preview-container { margin-top: 15px; text-align: left; }
        .image-preview { max-width: 220px; max-height: 180px; border: 1px solid var(--border-color); border-radius: var(--border-radius); padding: 5px; background-color: var(--secondary-color); }
        .image-preview-placeholder { width: 100%; max-width: 220px; height: 150px; border-radius: var(--border-radius); display: flex; align-items: center; justify-content: center; color: var(--text-muted-color); font-size: 0.9rem; background-color: var(--secondary-color); border: 1px solid var(--border-color); }
        .current-image-info { font-size: 0.85rem; color: var(--text-muted-color); margin-top: 5px; }
        .title-preview-area { margin-top: 10px; padding: 15px; background-color: #f8f9fa; border: 1px solid var(--border-color); border-radius: var(--border-radius); min-height: 50px; }
        .title-preview-area h3 { margin: 0; font-size: 1.75rem; color: var(--text-color); font-weight: 600; }
        .title-preview-placeholder { color: var(--text-muted-color); font-style: italic; }
        .form-actions { margin-top: 2rem; text-align: right; display: flex; justify-content: flex-end; gap: 10px; } /* Sử dụng flex cho nút */
        .btn-custom { padding: 0.75rem 1.5rem; font-size: 1rem; font-weight: 600; border-radius: var(--border-radius); text-decoration: none; transition: all 0.3s ease; cursor: pointer; border: none; display: inline-flex; align-items: center; }
        .btn-custom i { margin-right: 8px; }
        .btn-primary-custom { background-color: var(--primary-color); color: white; }
        .btn-primary-custom:hover { background-color: var(--primary-hover-color); box-shadow: 0 2px 8px rgba(93, 135, 255, 0.3); }
        .btn-secondary-custom { background-color: #6c757d; color: white; }
        .btn-secondary-custom:hover { background-color: #5a6268; }
        .btn-info-custom { background-color: var(--info-color); color: white; } /* Nút Lưu Nháp */
        .btn-info-custom:hover { background-color: var(--info-hover-color); }
        #quill-editor-container { margin-bottom: 10px; }
        #quill-editor-container .ql-toolbar.ql-snow { border: 1px solid var(--border-color); border-bottom: none; border-top-left-radius: var(--border-radius); border-top-right-radius: var(--border-radius); background-color: #f8f9fa; padding: 8px; }
        #quill-editor-container .ql-container.ql-snow { border: 1px solid var(--border-color); border-bottom-left-radius: var(--border-radius); border-bottom-right-radius: var(--border-radius); min-height: 250px; font-size: 1rem; background-color: var(--card-bg-color); }
        #quill-editor-container .ql-editor { min-height: 230px; padding: 12px 15px; line-height: 1.6; }
        .alert { padding: 1rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: var(--border-radius); }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; }
        .alert-success { color: #0f5132; background-color: #d1e7dd; border-color: #badbcc; }
        .footer-custom { text-align: center; padding: 20px; margin-top: 40px; font-size: 0.9rem; color: var(--text-muted-color); border-top: 1px solid var(--border-color); }
    </style>
</head>
<body>
    <header class="navbar-custom">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand">AgriculturePromotion</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/posts?action=list">Quản lý Bài viết</a>
            <a href="#">Cài đặt</a>
        </nav>
    </header>

    <div class="page-wrapper">
        <div class="page-header">
            <div class="breadcrumb-custom">
                <a href="${pageContext.request.contextPath}/posts?action=list" style="color:var(--text-muted-color); text-decoration:none;">Quản lý Bài viết</a> > 
                ${not empty post && not empty post.id ? 'Chỉnh sửa Bài viết' : 'Tạo Bài viết Mới'}
                 <c:if test="${not empty post.status && post.status == 'draft'}"> (Bản nháp)</c:if>
            </div>
            <h1 class="page-title-custom">${not empty post && not empty post.id ? 'Chỉnh sửa Bài viết' : 'Tạo Bài viết Mới'}</h1>
        </div>

        <div class="form-container">
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger"><c:out value="${sessionScope.errorMessage}"/></div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success"><c:out value="${sessionScope.successMessage}"/></div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <form id="postForm" method="post" action="${pageContext.request.contextPath}/posts" enctype="multipart/form-data">
                <c:if test="${not empty post && not empty post.id}">
                    <input type="hidden" name="id" value="${post.id}" />
                    <input type="hidden" name="action" value="update" /> <%-- Action chính của servlet là update --%>
                </c:if>
                <c:if test="${empty post || empty post.id}">
                    <input type="hidden" name="action" value="save" /> <%-- Action chính của servlet là save --%>
                </c:if>

                <div class="form-group">
                    <label for="title">Tiêu đề bài viết</label>
                    <input type="text" id="title" name="title" class="form-control" value="<c:out value='${post.title}'/>" required placeholder="Nhập tiêu đề..." />
                </div>

                <div class="form-group">
                    <label>Xem trước tiêu đề bài viết</label>
                    <div id="titlePreviewContainer" class="title-preview-area">
                        <h3 id="titlePreviewContent"><span class="title-preview-placeholder">Tiêu đề sẽ hiện ở đây...</span></h3>
                    </div>
                </div>

                <div class="form-group">
                    <label for="coverImageFile">Ảnh đại diện (Ảnh bìa)</label>
                    <div class="file-input-wrapper">
                        <input type="file" id="coverImageFile" name="coverImageFile" accept="image/*" />
                        <span class="file-input-label"><i class="bi bi-upload"></i> Chọn tệp hoặc kéo thả vào đây</span>
                    </div>
                    <div class="image-preview-container">
                        <c:choose>
                            <c:when test="${not empty post.imageUrl}">
                                <img id="imagePreview" src="${pageContext.request.contextPath}/Uploads/${post.imageUrl}" alt="Xem trước ảnh bìa" class="image-preview"/>
                                <p class="current-image-info">Ảnh bìa hiện tại: <c:out value="${post.imageUrl}"/></p>
                            </c:when>
                            <c:otherwise>
                                <img id="imagePreview" src="#" alt="Xem trước ảnh bìa" class="image-preview" style="display:none;"/>
                                <div id="imagePreviewPlaceholder" class="image-preview-placeholder">
                                    <span>Chưa có ảnh bìa</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="form-group">
                    <label for="quill-editor-container">Nội dung chi tiết</label>
                    <div id="quill-editor-container"></div>
                    <input type="hidden" name="content" id="hidden-content-input">
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/posts?action=list" class="btn-custom btn-secondary-custom">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại
                    </a>
                    <%-- NÚT LƯU NHÁP --%>
                    <button type="submit" name="formAction" value="saveDraft" class="btn-custom btn-info-custom">
                        <i class="bi bi-save"></i> Lưu Nháp
                    </button>
                    <%-- NÚT GỬI DUYỆT / CẬP NHẬT & GỬI DUYỆT --%>
                    <button type="submit" name="formAction" value="submitForApproval" class="btn-custom btn-primary-custom">
                        <i class="bi bi-check-circle"></i> 
                        <c:choose>
                            <c:when test="${not empty post && not empty post.id}">
                                <c:if test="${post.status == 'draft' || post.status == 'rejected'}">Gửi Duyệt Lại</c:if>
                                <c:if test="${post.status != 'draft' && post.status != 'rejected'}">Lưu & Gửi Duyệt Lại</c:if>
                            </c:when>
                            <c:otherwise>
                                Đăng & Gửi Duyệt
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer-custom">
        <p>© ${java.time.Year.now()} Agriculture Promotion. All rights reserved.</p>
    </footer>

    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <script>
        // TOÀN BỘ SCRIPT CỦA BẠN (DOMContentLoaded, title preview, Quill init, image handlers, previewImageLocal)
        // SẼ ĐƯỢC ĐẶT Ở ĐÂY, KHÔNG THAY ĐỔI SO VỚI PHIÊN BẢN TRƯỚC ĐÓ.
        // Chỉ cần đảm bảo các hàm như quillImageHandler và window.previewImageLocal
        // được khai báo đúng cách (ví dụ: ở global scope hoặc được truyền đúng).
        document.addEventListener('DOMContentLoaded', function () {
            var quill;
            const titleInput = document.getElementById('title');
            const titlePreviewContent = document.getElementById('titlePreviewContent');
            const titlePreviewPlaceholderText = "Tiêu đề sẽ hiện ở đây...";

            if (titleInput && titlePreviewContent) {
                if (titleInput.value.trim() !== '') {
                    titlePreviewContent.textContent = titleInput.value;
                } else {
                    titlePreviewContent.innerHTML = `<span class="title-preview-placeholder">${titlePreviewPlaceholderText}</span>`;
                }
                titleInput.addEventListener('input', function() {
                    if (this.value.trim() !== '') {
                        titlePreviewContent.textContent = this.value;
                    } else {
                        titlePreviewContent.innerHTML = `<span class="title-preview-placeholder">${titlePreviewPlaceholderText}</span>`;
                    }
                });
            }

            var quillEditorContainer = document.getElementById('quill-editor-container');
            if (quillEditorContainer) {
                quill = new Quill('#quill-editor-container', { 
                    modules: {
                        toolbar: {
                            container: [
                                [{ 'header': [1, 2, 3, 4, 5, 6, false] }],['bold', 'italic', 'underline', 'strike'],
                                [{ 'list': 'ordered'}, { 'list': 'bullet' }, { 'indent': '-1'}, { 'indent': '+1' }],
                                ['link', 'image', 'blockquote'],['clean']
                            ],
                            handlers: { 'image': quillImageHandler }
                        }
                    },
                    placeholder: 'Nhập nội dung chi tiết của bạn ở đây...', theme: 'snow'
                });
                 <c:if test="${not empty post.content}">
                    var initialContent = `<c:out value="${post.content}" escapeXml="false"/>`;
                    if (quill && initialContent && initialContent.trim() !== '' && initialContent.trim() !== "<p><br></p>") {
                        try {
                            quill.clipboard.dangerouslyPasteHTML(0, initialContent);
                        } catch (e) { console.error("Lỗi khi pasteHTML: ", e); }
                    }
                </c:if>
            } 

            var postForm = document.getElementById('postForm');
            if (postForm) {
                postForm.addEventListener('submit', function(event) {
                    var contentInput = document.getElementById('hidden-content-input');
                    if (contentInput && quill) {
                        contentInput.value = quill.root.innerHTML;
                        if (contentInput.value === "<p><br></p>") { /* contentInput.value = ""; */ }
                    } 
                });
            }

            const coverImageFileInput = document.getElementById('coverImageFile');
            const imagePreviewDisplay = document.getElementById('imagePreview');
            const initialCoverImageSrc = imagePreviewDisplay ? imagePreviewDisplay.src : null;
            const hasInitialCover = initialCoverImageSrc && !initialCoverImageSrc.endsWith('#'); 

            if (imagePreviewDisplay) {
                if (hasInitialCover) {
                    imagePreviewDisplay.style.display = 'block';
                    var placeholder = document.getElementById('imagePreviewPlaceholder');
                    if(placeholder) placeholder.style.display = 'none';
                } else {
                    imagePreviewDisplay.style.display = 'none';
                    var placeholder = document.getElementById('imagePreviewPlaceholder');
                     if(placeholder) placeholder.style.display = 'flex';
                }
            }
            if (coverImageFileInput) {
                coverImageFileInput.addEventListener('change', function(event) {
                    window.previewImageLocal(event, initialCoverImageSrc, hasInitialCover);
                });
            }
        }); 

        function quillImageHandler() { /* ... code của bạn ... */ 
            const input = document.createElement('input');
            input.setAttribute('type', 'file');
            input.setAttribute('accept', 'image/*');
            input.click();
            input.onchange = async () => {
                const file = input.files[0];
                if (file) {
                    const formData = new FormData();
                    formData.append('image', file);
                    const range = this.quill.getSelection(true); 
                    this.quill.disable(); 
                    this.quill.insertText(range.index, "\n[Đang tải ảnh...]\n", Quill.sources.USER);
                    try {
                        const response = await fetch('${pageContext.request.contextPath}/posts?action=uploadContentImage', {
                            method: 'POST', body: formData
                        });
                        this.quill.enable(); 
                        const currentContent = this.quill.getContents();
                        const loadingTextPattern = /\n?\[Đang tải ảnh\.\.\.\]\n?/;
                        let textStartIndex = 0; let foundAndDeleted = false;
                        for (let i = 0; i < currentContent.ops.length; i++) {
                            const op = currentContent.ops[i];
                            if (typeof op.insert === 'string') {
                                const match = op.insert.match(loadingTextPattern);
                                if (match) {
                                    this.quill.deleteText(textStartIndex + match.index, match[0].length, Quill.sources.USER);
                                    foundAndDeleted = true; break; 
                                }
                                textStartIndex += op.insert.length;
                            } else { textStartIndex += 1; }
                        }
                        if (response.ok) {
                            const result = await response.json();
                            if (result.imageUrl) {
                                this.quill.insertEmbed(range.index, 'image', result.imageUrl, Quill.sources.USER);
                                this.quill.setSelection(range.index + 1, Quill.sources.SILENT);
                            } else if (result.error) { alert("Lỗi tải ảnh từ server: " + result.error); }
                        } else { 
                            const errorResult = await response.json().catch(() => ({error: "Lỗi không xác định."}));
                            alert("Lỗi tải ảnh lên server: " + (errorResult.error || `Mã lỗi ${response.status}`));
                        }
                    } catch (error) { 
                        if(this.quill && !this.quill.isEnabled()) this.quill.enable(); 
                        alert("Có lỗi xảy ra khi tải ảnh: " + error.message);
                    }
                }
            };
        }
        window.previewImageLocal = function(event, initialSrc, hasInitial) { /* ... code của bạn ... */
            const reader = new FileReader();
            const imagePreview = document.getElementById('imagePreview');
            const imagePreviewPlaceholder = document.getElementById('imagePreviewPlaceholder');
            const currentImageInfo = document.querySelector('.current-image-info');
            reader.onload = function() {
                if (imagePreview) { imagePreview.src = reader.result; imagePreview.style.display = 'block'; }
                if (imagePreviewPlaceholder) { imagePreviewPlaceholder.style.display = 'none'; }
                if (currentImageInfo) { currentImageInfo.style.display = 'none'; }
            }
            if (event.target.files && event.target.files[0]) {
                reader.readAsDataURL(event.target.files[0]);
            } else { 
                if (imagePreview) {
                    if (hasInitial) {
                        imagePreview.src = initialSrc; imagePreview.style.display = 'block';
                        if (currentImageInfo) currentImageInfo.style.display = 'block'; 
                        if (imagePreviewPlaceholder) imagePreviewPlaceholder.style.display = 'none';
                    } else {
                        imagePreview.src = '#'; imagePreview.style.display = 'none';
                        if (imagePreviewPlaceholder) imagePreviewPlaceholder.style.display = 'flex';
                        if (currentImageInfo) currentImageInfo.style.display = 'none';
                    }
                }
            }
        }
    </script>
</body>
</html>