<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "";
    boolean isAdmin = "admin".equalsIgnoreCase(role);
    boolean noAccess = !isAdmin && user != null && (role.equalsIgnoreCase("user") || role.equalsIgnoreCase("business"));
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Admin Dashboard | AgriPromotion</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- FontAwesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
        <style>
            /* giữ nguyên style cũ */
            html, body {
                height: 100%;
                margin: 0;
            }
            body {
                font-family: 'Arial', sans-serif;
            }
            .wrapper {
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                width: 250px;
                background-color: #28a745;
                color: white;
                padding: 20px;
            }
            .sidebar h4 {
                font-weight: bold;
                margin-bottom: 30px;
            }
            .sidebar a {
                color: white;
                display: block;
                padding: 10px 0;
                text-decoration: none;
            }
            .sidebar a:hover {
                text-decoration: underline;
            }
            .main-content {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between; /* đẩy footer xuống dưới */
                min-height: 100vh;
            }
            .content-area {
                flex-grow: 1;
                padding: 40px;
            }
            .feature-card {
                transition: transform 0.3s;
                min-height: 280px; /* chiều cao cố định cho cân đối */
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: space-between; /* đẩy button xuống dưới */
                padding: 20px;
            }
            .feature-card:hover {
                transform: translateY(-10px);
            }
            .feature-card i {
                margin-bottom: 15px;
            }
            .feature-card .card-title {
                font-weight: 600;
            }
            footer {
                background-color: #2e7d32; /* Màu xanh đậm */
                color: #f8f9fa;
                text-align: center;
                padding: 15px 0;
            }
            .no-access-message {
                color: red;
                font-weight: bold;
                font-size: 1.2rem;
                text-align: center;
                margin-top: 100px;
            }
        </style>
    </head>
    <body>

        <div class="wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <h4>Bảng Quản Trị</h4>
                <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home me-2"></i>Trang chủ</a>

            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Content Area -->
                <div class="content-area">
                    <% if (noAccess) { %>
                    <div class="no-access-message">
                        Bạn không có quyền truy cập trang này.
                    </div>
                    <% } else if (isAdmin) { %>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="mb-0">Dashboard Quản trị</h1>
                        <div>
                            <span class="me-3">Xin chào, <strong><%= user.getFullName() %></strong></span>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
                        </div>
                    </div>

                    <!-- Feature Cards -->
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card feature-card shadow-sm">
                                <div class="card-body d-flex flex-column align-items-center justify-content-between">
                                    <i class="fas fa-users-cog fa-3x text-success"></i>
                                    <h4 class="card-title text-center text-success">Quản lý người dùng</h4>
                                    <p class="card-text text-center">Xem khóa và xóa người dùng.</p>
                                    <a href="${pageContext.request.contextPath}/AdminUserListServlet" class="btn btn-success mt-3">Xem danh sách</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card feature-card shadow-sm">
                                <div class="card-body d-flex flex-column align-items-center justify-content-between">
                                    <i class="fas fa-file-alt fa-3x text-success mb-3"></i>
                                    <h4 class="card-title text-center text-success">Xem đơn yêu cầu nâng cấp vai trò</h4>
                                    <p class="card-text text-center">Duyệt yêu cầu nâng cấp vai trò.</p>
                                   <a href="${pageContext.request.contextPath}/business-registrations" class="btn btn-success mt-3">Xem danh sách đơn</a>

                                </div>
                            </div>
                        </div>
                    </div>

                    <% } else { %>
                    <!-- Nếu chưa đăng nhập hoặc role khác -->
                    <div class="no-access-message">
                        Vui lòng đăng nhập với tài khoản quản trị để truy cập trang này.
                    </div>
                    <% } %>
                </div>

                <!-- Footer -->
                <footer>
                    <div>
                        <p class="mb-1">Hotline: 0919 797 908 | Email: agri.pure@gmail.com</p>
                        <p class="mb-0">© 2025 AgriPure. All rights reserved.</p>
                    </div>
                </footer>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
