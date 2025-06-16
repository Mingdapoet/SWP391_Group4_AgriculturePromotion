<%-- 
    Document   : header
    Created on : Jun 12, 2025, 12:10:33 AM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<style>
    /* Header Bottom */
    .header-bottom {
        background: var(--primary);
        color: var(--text);
        padding: 12px 20px;
        position: relative;
        z-index: 1000;
    }
    .header-bottom .container-fluid {
        display: flex;
        align-items: center;
        justify-content: center; /* Center the entire content */
        position: relative;
    }
    .header-bottom .navbar-nav {
        display: flex;
        align-items: center;
        justify-content: center; /* Center the nav items */
        flex-grow: 1; /* Allow nav to take available space */
    }
    .header-bottom .nav-link {
        color: var(--text) !important;
        font-size: 1rem;
        padding: 8px 16px;
        transition: color 0.3s;
    }
    .header-bottom .nav-link:hover {
        color: var(--secondary) !important;
    }
    .header-bottom .user-actions {
        position: absolute;
        right: 0; /* Align user actions to the right */
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .header-bottom .user-actions a {
        color: var(--text);
        font-size: 1rem;
        transition: color 0.3s;
    }
    .header-bottom .user-actions a:hover {
        color: var(--secondary);
    }
    /* Dropdown Menu */
    .nav-item.dropdown {
        position: relative;
    }
    .dropdown-menu {
        background: var(--accent);
        border: none;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        margin-top: 8px;
        z-index: 2000;
        min-width: 200px;
    }
    .dropdown-menu .dropdown-item {
        color: var(--text);
        padding: 10px 16px;
        font-size: 0.95rem;
        transition: background 0.3s, color 0.3s;
    }
    .dropdown-menu .dropdown-item:hover {
        background: var(--primary);
        color: #fff;
    }
    .dropdown-submenu {
        position: relative;
    }
    .dropdown-submenu > .dropdown-menu {
        top: 0;
        left: 100%;
        margin-left: 2px;
        display: none;
        position: absolute;
        min-width: 180px;
    }
    .dropdown-submenu:hover > .dropdown-menu {
        display: block;
    }
    .dropdown-submenu > .dropdown-item::after {
        content: "\f054";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        float: right;
        margin-top: 2px;
    }
    .dropdown-toggle::after {
        border: none;
        content: "\f078";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        vertical-align: middle;
    }
    /* Responsive */
    @media (max-width: 768px) {
        .header-bottom .container-fluid {
            flex-direction: column;
            justify-content: center;
        }
        .header-bottom .navbar-nav {
            flex-direction: column;
            width: 100%;
            gap: 8px;
            text-align: center;
        }
        .header-bottom .user-actions {
            position: static;
            margin-top: 12px;
            justify-content: center;
        }
    }
</style>

<div class="header-top">
    <div class="container-fluid">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/index.jsp">
                <img src="images/logonongsan.png" alt="AgriPure Logo">
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

<div class="header-bottom">
    <div class="container-fluid">
        <ul class="navbar-nav d-flex flex-row gap-3">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/even.jsp">Sự kiện</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/posts?action=publicList">Tin tức</a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="specialtiesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    Đặc sản
                </a>
           <ul class="dropdown-menu" aria-labelledby="specialtiesDropdown">
                    <li class="dropdown-submenu">
                        <a class="dropdown-item dropdown-toggle" href="#">Miền Bắc</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Hà Nội</a></li>
                            <li><a class="dropdown-item" href="#">Hải Phòng</a></li>
                            <li><a class="dropdown-item" href="#">Lào Cai</a></li>
                             <li><a class="dropdown-item" href="#">Lạng Sơn</a></li>
                            <li><a class="dropdown-item" href="#">Bắc Giang</a></li>
                            <li><a class="dropdown-item" href="#">Hà Giang</a></li>
                        </ul>
                    </li>
                    <li class="dropdown-submenu">
                        <a class="dropdown-item dropdown-toggle" href="#">Miền Trung</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Huế</a></li>
                            <li><a class="dropdown-item" href="#">Đà Nẵng</a></li>
                            <li><a class="dropdown-item" href="#">Quảng Nam</a></li>
                             <li><a class="dropdown-item" href="#">Nghệ An</a></li>
                            <li><a class="dropdown-item" href="#">Hà Tĩnh</a></li>
                            <li><a class="dropdown-item" href="#">Thanh Hóa</a></li>
                        </ul>
                    </li>
                    <li class="dropdown-submenu">
                        <a class="dropdown-item dropdown-toggle" href="#">Miền Nam</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Hồ Chí Minh</a></li>
                            <li><a class="dropdown-item" href="#">Cần Thơ</a></li>
                            <li><a class="dropdown-item" href="#">An Giang</a></li>
                             <li><a class="dropdown-item" href="#">Đồng Nai</a></li>
                            <li><a class="dropdown-item" href="#">Đà Lạt</a></li>
                            <li><a class="dropdown-item" href="#">Long An</a></li>
                            
                        </ul>
                    </li>
                </ul>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a>
            </li>
        </ul>
        <div class="user-actions d-flex gap-3">
            <% if (user == null) { %>
                <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
            <% } else { %>
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user"></i> <%= user.getFullName() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accountDropdown">
                        <li><a class="dropdown-item" href="profile.jsp">Thông tin cá nhân</a></li>
                        <% if ("admin".equals(user.getRole())) { %>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/adminDashboard.jsp">Quản lý</a></li>
                        <% } %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                    </ul>
                </div>
            <% } %>
        </div>
    </div>
</div>