<%-- 
    Document   : register-business-list
    Created on : May 30, 2025, 3:02:12 AM
    Author     : trvie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<BusinessRegistration> registrations = (List<BusinessRegistration>) request.getAttribute("registrations");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem danh sách đơn</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #f7fef9;
                color: #333;
                margin: 0;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
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
            /* Sidebar */
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
            @media (max-width: 799px) {
                .sidebar {
                    height: auto;
                    position: relative;
                    top: 0;
                    margin-bottom: 20px;
                }
                .form-container {
                    margin: 20px 10px;
                    padding: 20px 15px;
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
                    <input type="text" placeholder="Tìm kiếm...">
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
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/event.jsp">Sự kiện</a>
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

            <!-- Danh sách đơn -->
            <div class="col-md-9">
                <div class="form-container">
                    <h5>Danh sách đơn đăng ký doanh nghiệp đã gửi</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle">
                            <thead class="table-success">
                                <tr>
                                    <th>STT</th>
                                    <th>Tên công ty</th>
                                    <th>Người đại diện</th>
                                    <th>Ngày gửi</th>
                                    <th>Trạng thái</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (registrations == null || registrations.isEmpty()) {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted">Chưa có đơn nào.</td>
                                </tr>
                                <%
                                    } else {
                                        int stt = 1;
                                        for (BusinessRegistration reg : registrations) {
                                %>
                                <tr>
                                    <td><%= stt++ %></td>
                                    <td><%= reg.getCompanyName() %></td>
                                    <td><%= reg.getRepFullName() %></td>
                                    <td><%= reg.getSubmittedAt() != null ? sdf.format(reg.getSubmittedAt()) : "" %></td>
                                    <td>
                                        <% String status = reg.getStatus();
                                           String color = "text-secondary";
                                           if ("pending".equalsIgnoreCase(status)) color = "text-warning";
                                           else if ("approved".equalsIgnoreCase(status)) color = "text-success";
                                           else if ("rejected".equalsIgnoreCase(status)) color = "text-danger";
                                        %>
                                        <span class="<%= color %> fw-bold">
                                            <%= "pending".equals(status) ? "Đang chờ duyệt"
                                                    : "approved".equals(status) ? "Đã duyệt"
                                                    : "rejected".equals(status) ? "Từ chối"
                                                    : status %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="Account?action=detailBusiness&id=<%= reg.getId() %>" class="btn btn-outline-success btn-sm">
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function toggleBusinessDropdown() {
            var dropdown = document.getElementById("business-dropdown");
            dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
