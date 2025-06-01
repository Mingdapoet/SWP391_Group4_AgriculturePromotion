<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký doanh nghiệp</title>
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
            /* Form container */
            .form-container {
                background: #fff;
                padding: 30px 40px;
                border-radius: 30px;
                box-shadow: 0 6px 18px rgb(34 197 94 / 20%);
                max-width: 1000px;
                margin: 24px auto;
                border: 1px solid #15803d;
            }
            .form-container h5 {
                font-weight: 700;
                color: #15803d;
                margin-bottom: 20px;
            }
            .form-group {
                display: flex;
                align-items: center;
                margin-bottom: 18px;
            }
            .form-group label {
                font-weight: 600;
                width: 180px; /* width cố định cho label */
                margin-bottom: 0;
            }

            .form-group input,
            .form-group select {
                flex-grow: 1;
                padding: 8px 12px;
                font-size: 1rem;
                border: 1px solid #ccc;
                border-radius: 6px;
                outline-offset: 0;
                transition: border-color 0.3s ease;
            }
            .form-group input:focus,
            .form-group select:focus {
                border-color: #15803d;
                outline: none;
            }
            .checkbox-group {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 20px;
                font-weight: 700;
                color: #15803d;
            }
            .submit-btn {
                background-color: #15803d;
                color: white;
                border-radius: 30px;
                padding: 10px 20px;
                border: none;
                font-weight: 600;
                width: 150px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .submit-btn:hover {
                background-color: #0b4a1e;
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
                        <a href="#" class="sidebar-link" onclick="toggleBusinessDropdown(); return false;">
                            Đăng ký doanh nghiệp <span style="font-size:0.8em;">▼</span>
                        </a>
                        <div id="business-dropdown" style="display: none; margin-left: 16px;">
                            <a href="register-business.jsp" class="sidebar-link">Viết đơn</a>
                            <a href="register-business-list.jsp" class="sidebar-link">Xem danh sách đơn</a>
                        </div>
                    </div>
                </div>
                <!-- Form đăng ký doanh nghiệp -->
                <div class="col-md-9 d-flex justify-content-center">
                    <form class="form-container" method="post" action="Account" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="registerBusiness">
                        <h5>1 Thông tin doanh nghiệp</h5>
                        <div class="form-group">
                            <label for="companyName">Tên doanh nghiệp</label>
                            <input type="text" id="companyName" name="companyName" required>
                        </div>
                        <div class="form-group">
                            <label for="headquarters">Địa chỉ trụ sở chính</label>
                            <input type="text" id="headquarters" name="headquarters" required>
                        </div>
                        <div class="form-group">
                            <label for="businessType">Loại hình doanh nghiệp</label>
                            <select id="businessType" name="businessType" required onchange="toggleCustomType()">
                                <option value="" selected>-- Chọn loại hình --</option>
                                <option value="TNHH">Công ty TNHH</option>
                                <option value="CP">Công ty Cổ phần</option>
                                <option value="TN">Doanh nghiệp tư nhân</option>
                                <option value="HTX">Hợp tác xã</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                        <div class="form-group" id="customTypeWrapper" style="display:none;">
                            <label for="customType">Nhập loại hình khác</label>
                            <input type="text" id="customType" name="customType" class="form-control" placeholder="Nhập loại hình khác...">
                        </div>


                        <h5>2 Thông tin người đại diện pháp luật</h5>
                        <div class="form-group">
                            <label for="repName">Họ và tên</label>
                            <input type="text" id="repName" name="repName" required>
                        </div>
                        <div class="form-group">
                            <label for="repPosition">Chức vụ</label>
                            <input type="text" id="repPosition" name="repPosition" required>
                        </div>
                        <div class="form-group">
                            <label for="repPhone">Số điện thoại</label>
                            <input type="tel" id="repPhone" name="repPhone" required>
                        </div>
                        <div class="form-group">
                            <label for="repEmail">Email</label>
                            <input type="email" id="repEmail" name="repEmail" required>
                        </div>
                        <div class="form-group">
                            <label for="legalDoc">Giấy chứng nhận đăng ký kinh doanh</label>
                            <input type="file" id="legalDoc" name="legalDoc" accept=".pdf,.doc,.docx">
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" id="commitment" name="commitment" required>
                            <label for="commitment">Cam kết</label>
                        </div>
                        <button type="submit" class="submit-btn">Gửi đơn</button>
                    </form>
                </div>
            </div>
        </div>
        <script>
            function toggleCustomType() {
                const selected = document.getElementById("businessType").value;
                const wrapper = document.getElementById("customTypeWrapper");
                const input = document.getElementById("customType");

                if (selected === "Khác") {
                    wrapper.style.display = "flex";
                } else {
                    wrapper.style.display = "none";
                    input.value = "";
                }
            }
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
