<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String msg = request.getParameter("msg");
    if (msg == null) {
        msg = "";
    }
    String avatarPath = user.getAvatar();
    String defaultAvatar = "img/default-avatar.jpg";
    String displayAvatar = (avatarPath == null || avatarPath.trim().isEmpty()) ? defaultAvatar : avatarPath;
    
    String roleVN = "";
    if ("admin".equals(user.getRole())) {
        roleVN = "Quản trị viên";
    } else if ("business".equals(user.getRole())) {
        roleVN = "Doanh nghiệp";
    } else {
        roleVN = "Chưa xác định";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin cá nhân</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #f5f5f5;
                color: #333;
                line-height: 1.6;
                margin: 0;
                min-height: 100vh;
                background: #f7fef9;
                display: flex;
                flex-direction: column;
                justify-content: flex-start; /* Đẩy nội dung lên trên */
            }
            /* Header Top (White Background) */
            .header-top {
                background: #fff;
                color: #333;
                padding: 10px 0;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .header-top .container-fluid {
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
            }
            .header-top .logo img {
                width: 50px;
                height: auto;
            }
            .header-top .search {
                flex-grow: 1;
                max-width: 400px;
                margin: 0 20px;
            }
            .header-top .search input {
                border: 1px solid #ccc;
                border-radius: 25px;
                padding: 8px 15px;
                width: 100%;
                background: #f9f9f9;
                color: #333;
                transition: background 0.3s ease;
                text-align: center;
            }
            .header-top .search input:focus {
                background: #fff;
                outline: none;
            }
            .header-top .search input::placeholder {
                color: #888;
            }
            .header-top .notification a {
                color: #333;
                font-size: 1.2rem;
                transition: color 0.3s ease;
            }
            .header-top .notification a:hover {
                color: #2e7d32;
            }
            .nav-item.dropdown::marker {
                content: none !important;
            }

            /* Header Bottom (Green Background) */
            .header-bottom {
                background: #2e7d32;
                color: #fff;
                padding: 10px 0;
            }
            .header-bottom .container-fluid {
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
            }
            .header-bottom .navbar-nav {
                display: flex;
                align-items: center;
            }
            .header-bottom .nav-link {
                color: #fff !important;
                font-size: 1rem;
                font-weight: 400;
                padding: 0.5rem 1rem;
                transition: color 0.3s ease;
            }
            .header-bottom .nav-link:hover {
                color: #a5d6a7 !important;
            }
            .header-bottom .user-actions {
                margin-left: 20px;
            }
            .header-bottom .user-actions a {
                color: #000;
                font-size: 1rem;
                margin-left: 10px;
                transition: color 0.3s ease;
            }
            .header-bottom .user-actions a:hover {
                color: #a5d6a7;
            }

            .sidebar {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgb(34 197 94 / 10%);
                min-height: 300px;
            }
            .sidebar h4 {
                font-weight: 700;
                color: #15803d;
                margin-bottom: 20px;
            }
            .sidebar a {
                display: block;
                padding: 10px 0;
                color: #15803d;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.3s ease;
            }
            .sidebar a:hover, .sidebar a.active {
                color: #0b4a1e;
                font-weight: 700;
            }
            #business-dropdown a {
                padding-left: 18px;
                font-weight: normal;
                font-size: 0.97em;
            }
            .main-content-wrapper {
                margin-left: 220px; /* để không bị sidebar che */
                flex-grow: 1;
                display: flex;
                justify-content: center; /* căn giữa ngang */
                align-items: flex-start; /* canh top */
                padding: 40px 20px;
                min-height: 100vh;
            }
            .profile-card {
                max-width: 480px;
                margin: 24px auto 16px auto;   /* Giảm top xuống 24px, bottom 16px */
                padding: 24px 18px 18px 18px;  /* Thu nhỏ padding xung quanh */
                background: #fff;
                border-radius: 24px;
                box-shadow: 0 4px 32px rgba(34,197,94,0.10), 0 1.5px 6px rgba(0,0,0,0.06);
            }
            .profile-title {
                font-weight: bold;
                font-size: 1.7rem;
                color: #15803d;
                text-align: center;
            }
            .profile-table th, .profile-table td {
                font-size: 1rem;
                vertical-align: middle;
            }
            .btn-genz {
                border-radius: 999px;
                font-weight: bold;
                transition: 0.25s;
                box-shadow: 0 2px 8px rgba(34,197,94,0.08);
            }
            .btn-genz:hover {
                transform: translateY(-3px) scale(1.04);
                opacity: 0.92;
                box-shadow: 0 4px 18px rgba(34,197,94,0.17);
            }
            @media (min-width: 800px) {
                .profile-card {
                    margin-top: 48px;
                }
            }
            @media (max-width: 799px) {
                .profile-card {
                    margin-top: 16px;
                }
            }
        </style>
    </head>
    <body style="background: #f7fef9;">
        <div class="header-top">
            <div class="container-fluid">
                <div class="logo">
                     <a href="${pageContext.request.contextPath}/index.jsp">
                            <img src="images/logonongsan.png" style="height: 48px;">
                        </a>
                </div>
                <div class="search">
                    <input type="text" placeholder="Tìm kiếm sản phẩm...">
                </div>
                <div class="notification">
                    <a href="#"><i class="fas fa-bell"></i></a>
                </div>
            </div>
        </div>

        <div class="header-bottom bg-success text-white py-2">
            <div class="container-fluid d-flex align-items-center position-relative">

                <ul class="navbar-nav d-flex flex-row gap-4 mb-0 position-absolute start-50 translate-middle-x">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/products.jsp">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/news.jsp">Tin tức</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/foods.jsp">Đặc sản</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a>
                    </li>
                </ul>

                <div class="user-actions ms-auto d-flex gap-3">
                    <% if (user == null) { %>
                    <a class="text-white" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                    <a class="text-white" href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
                    <% } else { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user"></i> <%= user.getFullName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accountDropdown">
                            <li><a class="dropdown-item" href="profile.jsp">Thông tin cá nhân</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                        </ul>
                    </li>
                    <% } %>
                </div>
            </div>
        </div>
        <div class="container-fluid py-4">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3">
                    <div class="sidebar">
                        <h4>Menu</h4>
                        <a href="profile.jsp" class="sidebar-link">Thông tin cá nhân</a>
                        <% 
                            String role = user.getRole();
                            if ("customer".equals(role) || "business".equals(role)) { 
                        %>
                        <a href="#" class="sidebar-link" onclick="toggleBusinessDropdown(); return false;">
                            Đăng ký doanh nghiệp <span style="font-size:0.8em;">▼</span>
                        </a>
                        <div id="business-dropdown" style="display: none; margin-left: 16px;">
                            <a href="register-business.jsp" class="sidebar-link">Viết đơn</a>
                            <a href="Account?action=listBusiness" class="sidebar-link">Xem danh sách đơn</a>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="col-md-9 center-content">
                    <div class="profile-card w-100" style="max-width: 500px;">
                        <%-- Tích hợp notification.jsp để hiển thị thông báo --%>
                        <%@ include file="notification.jsp" %>

                        <% if ("success".equals(msg)) { %>
                        <div class="alert alert-success" id="success-alert">Cập nhật thông tin thành công!</div>
                        <% } else if ("business_success".equals(msg)) { %>
                        <div class="alert alert-success" id="success-alert">Đăng ký doanh nghiệp thành công!</div>
                        <% } %>


                        <div class="d-flex flex-column align-items-center mb-3">
                            <div style="width: 112px; height: 112px; border-radius: 50%; overflow: hidden; box-shadow: 0 2px 8px #ccc;">
                                <img src="<%= user.getAvatar() != null && !user.getAvatar().isEmpty() ? user.getAvatar() : "img/default-avatar.jpg" %>" 
                                     alt="Avatar" style="width:112px;height:112px;object-fit:cover;">
                            </div>
                        </div>
                        <table class="table profile-table">
                            <tr>
                                <th>Họ tên</th>
                                <td><%= user.getFullName() != null ? user.getFullName() : "Chưa cập nhật" %></td>
                            </tr>
                            <% if ("admin".equals(user.getRole()) || "business".equals(user.getRole())) { %>
                            <tr>
                                <th>Vai trò</th>
                                <td><%= roleVN %></td>
                            </tr>
                            <% } %>
                            <tr>
                                <th>Giới tính</th>
                                <td><%= user.getGender() != null ? user.getGender() : "Chưa cập nhật" %></td>
                            </tr>
                            <tr>
                                <th>Email</th>
                                <td><%= user.getEmail() %></td>
                            </tr>
                            <tr>
                                <th>Số điện thoại</th>
                                <td><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %></td>
                            </tr>
                            <tr>
                                <th>Địa chỉ</th>
                                <td><%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật" %></td>
                            </tr>
                            <tr>
                                <th>Ngày sinh</th>
                                <td><%= user.getBirthday() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(user.getBirthday()) : "Chưa cập nhật" %></td>
                            </tr>
                        </table>
                        <div class="d-flex justify-content-between gap-2 mt-3">
                            <a href="editprofile.jsp" class="btn btn-success btn-genz w-50">✏️ Chỉnh sửa</a>
                            <a href="index.jsp" class="btn btn-outline-primary btn-genz w-50">🏡 Trang chủ</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
             document.addEventListener('DOMContentLoaded', function() {
                var alerts = document.querySelectorAll('.alert');
                if (alerts.length > 0) {
                    setTimeout(function() {
                        alerts.forEach(function(alert) {
                            alert.classList.remove('show');
                            alert.classList.add('fade');
                            setTimeout(() => alert.remove(), 150);
                        });
                    }, 5000);
                }
            });

            window.onload = function () {
                var alertBox = document.getElementById('success-alert');
                if (alertBox) {
                    alertBox.style.display = 'block';
                    setTimeout(function () {
                        alertBox.style.display = 'none';
                    }, 5000); // 5000ms = 5 second
                }
            };
        </script>

        <script>
            function toggleBusinessDropdown() {
                var dropdown = document.getElementById("business-dropdown");
                dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
