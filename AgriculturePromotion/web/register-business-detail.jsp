<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.*" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    BusinessRegistration reg = (BusinessRegistration) request.getAttribute("registration");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem chi tiết đơn</title>
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

            .detail-card {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 18px rgb(34 197 94 / 12%);
                padding: 32px 36px;
                max-width: 700px;
                margin: 28px auto;
                border: 1px solid #15803d;
            }
            .detail-title {
                color: #15803d;
                font-weight: 700;
                margin-bottom: 32px;
                letter-spacing: 1px;
            }
            .detail-label {
                font-weight: 500;
                color: #555;
            }
            .detail-value {
                font-weight: 500;
                color: #222;
            }
            .table-detail th, .table-detail td {
                padding: 12px 14px;
                border: none;
            }
            .file-preview {
                margin: 10px 0 4px 0;
            }
            .back-btn {
                border-radius: 18px;
                padding: 6px 20px;
                font-weight: 600;
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
                        <img src="https://img.icons8.com/color/48/000000/plant.png" alt="Logo">
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

                <!-- Nội dung chi tiết đơn -->
                <div class="col-md-9">
                    <div class="detail-card">
                        <h2 class="detail-title">Chi tiết đơn đăng ký doanh nghiệp</h2>
                        <% if (reg == null) { %>
                        <div class="alert alert-danger">Không tìm thấy thông tin đơn!</div>
                        <% } else { %>
                        <table class="table table-borderless table-detail">
                            <tr>
                                <th class="detail-label">Trạng thái</th>
                                <td>
                                    <% String status = reg.getStatus(); %>
                                    <% if ("pending".equals(status)) { %>
                                    <span class="badge bg-warning text-dark">Đang chờ duyệt</span>
                                    <% } else if ("approved".equals(status)) { %>
                                    <span class="badge bg-success">Đã duyệt</span>
                                    <% } else if ("rejected".equals(status)) { %>
                                    <span class="badge bg-danger">Bị từ chối</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary"><%= status %></span>
                                    <% } %>
                                </td>
                            </tr>
                            <%-- Hiển thị lý do bị từ chối nếu có --%>
                            <% if ("rejected".equals(reg.getStatus()) && reg.getRejectionReason() != null && !reg.getRejectionReason().trim().isEmpty()) { %>
                            <tr>
                                <th class="detail-label text-danger">Lý do bị từ chối</th>
                                <td class="detail-value text-danger"><%= reg.getRejectionReason() %></td>
                            </tr>
                            <% } %>
                            <tr>
                                <th class="detail-label">Tên công ty</th>
                                <td class="detail-value"><%= reg.getCompanyName() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Mã số thuế</th>
                                <td class="detail-value"><%= reg.getTaxCode() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Loại hình doanh nghiệp</th>
                                <td class="detail-value">
                                    <%= reg.getBusinessType() %>
                                    <% if ("Khác".equals(reg.getBusinessType()) && reg.getCustomType() != null) { %>
                                    (<%= reg.getCustomType() %>)
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <th class="detail-label">Email công ty</th>
                                <td class="detail-value"><%= reg.getCompanyEmail() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Số điện thoại công ty</th>
                                <td class="detail-value"><%= reg.getCompanyPhone() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Địa chỉ trụ sở</th>
                                <td class="detail-value"><%= reg.getHeadOffice() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Người đại diện</th>
                                <td class="detail-value"><%= reg.getRepFullName() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Chức vụ đại diện</th>
                                <td class="detail-value"><%= reg.getRepPosition() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">SĐT đại diện</th>
                                <td class="detail-value"><%= reg.getRepPhone() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Email đại diện</th>
                                <td class="detail-value"><%= reg.getRepEmail() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Ngày gửi</th>
                                <td class="detail-value"><%= reg.getSubmittedAt() %></td>
                            </tr>
                            <tr>
                                <th class="detail-label">Giấy phép kinh doanh</th>
                                <td>
                                    <%
                                        String filePath = reg.getFilePath();
                                        String fileName = reg.getFileName();
                                        String ext = "";
                                        if (fileName != null && fileName.lastIndexOf(".") > 0) {
                                            ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
                                        }
                                    %>
                                    <% if (filePath != null && (ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png") || ext.equals("gif"))) { %>
                                    <div class="file-preview">
                                        <img src="<%= filePath %>" alt="Ảnh giấy phép" style="max-width:250px;max-height:320px;border:1px solid #ccc;border-radius:8px;">
                                    </div>
                                    <% } %>
                                    <% if (filePath != null) { %>
                                    <a href="<%= filePath %>" class="btn btn-outline-success btn-sm" target="_blank">Tải về / Xem file gốc</a>
                                    <% } else { %>
                                    <span class="text-danger">Không có file đính kèm</span>
                                    <% } %>
                                </td>
                            </tr>
                        </table>
                        <div class="mt-3">
                            <a href="Account?action=listBusiness" class="btn btn-secondary back-btn">← Quay lại danh sách</a>
                        </div>
                        <% } %>
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
