<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ | AgriPure</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
            margin: 0;
        }
        /* Header Top (White Background) */
        .header-top {
            background: #fff;
            color: #333;
            padding: 10px 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .header-top .container-fluid {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            padding: 10px 20px;
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

        /* Header Bottom (Green Background) */
        .header-bottom {
            background: #2e7d32;
            color: #fff;
            padding: 10px 20px;
            margin: 0px 0px 140px 0px;
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
            color: #fff;
            font-size: 1rem;
            margin-left: 10px;
            transition: color 0.3s ease;
        }
        .header-bottom .user-actions a:hover {
            color: #a5d6a7;
        }

        /* Dropdown menu styling */
        .nav-item.dropdown:hover > .dropdown-menu {
            display: block;
            margin-top: 0;
        }
        .dropdown-submenu {
            position: relative;
        }
        .dropdown-submenu > .dropdown-menu {
            display: none;
            top: 0;
            left: 100%;
            margin-top: -1px;
            margin-left: 0;
            position: absolute;
            min-width: 150px;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            z-index: 2000; /* Ensure submenu appears above hero section */
        }
        .dropdown-submenu:hover > .dropdown-menu {
            display: block;
        }
        .dropdown-submenu > .dropdown-item.dropdown-toggle::after {
            content: "";
            display: inline-block;
            margin-left: 0.5em;
            vertical-align: middle;
            border-left: 0.3em solid #333;
            border-top: 0.3em solid transparent;
            border-bottom: 0.3em solid transparent;
        }
        .dropdown-menu {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            z-index: 2000; /* Increased to appear above hero section */
        }
        .dropdown-menu .dropdown-item {
            color: #333;
            padding: 8px 15px;
            font-size: 0.9rem;
        }
        .dropdown-menu .dropdown-item:hover {
            background: #e8f5e9;
            color: #2e7d32;
        }

        /* Hero Section (Banner) */
        .hero-section .carousel-inner {
            height: 350px;
        }
        .hero-section .carousel-item {
            height: 100%;
        }
        .hero-section .carousel-item img {
            object-fit: cover;
            width: 100%;
            height: 350px;
        }
        .hero-section h2 {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 3rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            z-index: 1;
            text-align: center;
            color: white;
        }
        .hero-section .carousel-control-prev, .hero-section .carousel-control-next {
            width: 5%;
        }

        /* Main Content Layout */
        .container-fluid {
            padding: 0;
        }
        .row {
            margin: 0;
        }
        .sidebar {
            background: #fff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            min-height: 400px;
            overflow: hidden;
            text-align: center;
        }
        .sidebar h3 {
            color: #2e7d32;
            font-size: 2rem;
            margin-top: 0;
            margin-bottom: 20px;
            font-weight: 700;
        }
        .sidebar .nav-link {
            color: #2e7d32;
            font-weight: 500;
            padding: 10px 0;
            display: block;
            align-items: center;
            justify-content: center;
            width: 100%;
            transition: color 0.3s ease;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        .sidebar .nav-link:hover {
            color: #a5d6a7;
        }
        .main-content {
            padding: 20px;
            text-align: center;
        }
        .news-carousel {
            background: #fff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            min-height: 400px;
            overflow: hidden;
        }
        .news-carousel .carousel-inner {
            padding: 15px;
        }
        .news-carousel .carousel-item {
            text-align: center;
        }
        .news-carousel .carousel-item img {
            width: 100%;
            max-width: 300px;
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
            margin: 0 auto 15px auto;
            display: block;
        }
        .news-carousel .carousel-item h5 {
            font-size: 1.2rem;
            color: #333;
            margin: 10px 0;
            font-weight: 500;
        }
        .news-carousel .carousel-item p {
            font-size: 0.9rem;
            color: #666;
        }
        .news-carousel .carousel-control-prev, .news-carousel .carousel-control-next {
            width: 5%;
        }
        .news-card, .explore-card {
            border: none;
            border-radius: 10px;
            background: #fff;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            min-height: 300px;
        }
        .news-card:hover, .explore-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .news-card img, .explore-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .news-card h5, .explore-card h5 {
            font-size: 1.2rem;
            color: #333;
            margin: 10px 0;
            font-weight: 500;
        }
        .news-card p, .explore-card p {
            font-size: 0.9rem;
            color: #666;
        }

        /* Pagination */
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
        .pagination .page-link {
            color: #2e7d32;
            background: #fff;
            border: 1px solid #ddd;
            margin: 0 5px;
        }
        .pagination .page-link:hover {
            background: #e8f5e9;
        }
        .pagination .page-item.active .page-link {
            background: #2e7d32;
            color: #fff;
            border-color: #2e7d32;
        }

        /* Footer */
        footer {
            background: #2e7d32;
            color: #fff;
            padding: 30px 0;
            text-align: center;
            box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
            clear: both;
        }
        footer input {
            border: 1px solid #fff;
            border-radius: 20px;
            padding: 8px 15px;
            width: 250px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            margin-bottom: 15px;
            transition: background 0.3s ease;
        }
        footer input:focus {
            background: rgba(255, 255, 255, 0.2);
            outline: none;
        }
        footer input::placeholder {
            color: #a5d6a7;
        }
        footer button {
            background: #fff;
            color: #2e7d32;
            border: none;
            border-radius: 20px;
            padding: 8px 20px;
            font-weight: 500;
            transition: background 0.3s ease, color 0.3s ease;
        }
        footer button:hover {
            background: #a5d6a7;
            color: #fff;
        }
        footer p {
            margin: 5px 0;
            font-size: 0.9rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-top .container-fluid {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .header-top .search {
                width: 90%;
                max-width: 300px;
                margin: 10px 0;
            }
            .header-top .notification {
                margin: 10px 0;
            }
            .header-bottom .container-fluid {
                flex-direction: column;
                align-items: center;
            }
            .header-bottom .navbar-nav {
                flex-direction: column;
                width: 100%;
                margin: 10px 0;
            }
            .header-bottom .nav-link {
                padding: 0.5rem 0;
                text-align: center;
            }
            .header-bottom .user-actions {
                margin: 10px 0;
            }
            .sidebar, .main-content {
                width: 100% !important;
                max-width: 100% !important;
                flex: 0 0 100% !important;
                float: none;
                text-align: center;
            }
            .hero-section {
                height: 250px;
            }
            .hero-section h2 {
                font-size: 2rem;
            }
            .hero-section .carousel-item img {
                height: 250px;
            }
            .news-carousel .carousel-item img {
                max-width: 250px;
                height: 150px;
            }
            .row-cols-2 > * {
                flex: 0 0 100%;
                max-width: 100%;
            }
            .carousel-item img {
                width: 60%;
                height: auto;
                display: block;
                margin: 0 auto;
                border-radius: 10px;
            }
            .nav-item.dropdown:hover > .dropdown-menu,
            .dropdown-submenu:hover > .dropdown-menu {
                display: none;
            }
            .nav-item.dropdown.show > .dropdown-menu,
            .dropdown-submenu.show > .dropdown-menu {
                display: block;
            }
            .dropdown-submenu > .dropdown-menu {
                left: 0;
                position: relative;
                box-shadow: none;
                margin-left: 15px;
                z-index: 2000; /* Ensure submenu appears above hero section on mobile */
            }
        }
    </style>
</head>
<body>
    <div class="layout-1">
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
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/even.jsp">Sự kiện</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/posts?action=publicList">Tin tức</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-white" href="#" id="specialtiesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Đặc sản
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="specialtiesDropdown">
                            <li class="dropdown-submenu">
                                <a class="dropdown-item dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Miền Bắc</a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Hà Nội</a></li>
                                    <li><a class="dropdown-item" href="#">Hải Phòng</a></li>
                                    <li><a class="dropdown-item" href="#">Lào Cai</a></li>
                                </ul>
                            </li>
                            <li class="dropdown-submenu">
                                <a class="dropdown-item dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Miền Trung</a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Huế</a></li>
                                    <li><a class="dropdown-item" href="#">Đà Nẵng</a></li>
                                    <li><a class="dropdown-item" href="#">Quảng Nam</a></li>
                                </ul>
                            </li>
                            <li class="dropdown-submenu">
                                <a class="dropdown-item dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Miền Nam</a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Hồ Chí Minh</a></li>
                                    <li><a class="dropdown-item" href="#">Cần Thơ</a></li>
                                    <li><a class="dropdown-item" href="#">Phú Quốc</a></li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a>
                    </li>
                </ul>


                </div>
            </div>
        </div>

        <section class="hero-section">
            <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?auto=format&fit=crop&w=1920&q=80" alt="Banner 1">
                        <h2>Tin tức nổi bật</h2>
                    </div>
                    <div class="carousel-item">
                        
                        <img src="https://th.bing.com/th/id/R.2685c1c18640baf699aafa8a8054a514?pid=ImgRaw&r=0&rik=Yf06GksnY%2B0ASA" alt="Banner 2">
                        <h2>Tin tức nổi bật</h2>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </section>

        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-md-3">
                    <div class="sidebar bg-light p-3 rounded shadow-sm">
                        <h3 class="mb-3">Danh mục</h3>
                        <ul class="nav flex-column">
                            <li class="nav-item mb-2">
                                <a class="nav-link" href="#"><i class="fas fa-leaf me-2"></i> Sống xanh</a>
                            </li>
                            <li class="nav-item mb-2">
                                <a class="nav-link" href="#"><i class="fas fa-truck me-2"></i> Nguồn cung cấp</a>
                            </li>
                            <li class="nav-item mb-2">
                                <a class="nav-link" href="#"><i class="fas fa-map-marker-alt me-2"></i> Đặc sản vùng miền</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#"><i class="fas fa-utensils me-2"></i> Ẩm thực</a>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-9">
                    <div class="main-content bg-white p-4 rounded shadow-sm">
                        <h2 class="mb-4">Tin tức nông dân</h2>
                        <div id="newsCarousel" class="carousel slide" data-bs-ride="carousel">
                            <div class="carousel-inner">
                                <div class="carousel-item active text-center">
                                    <img src="https://bcp.cdnchinhphu.vn/334894974524682240/2024/5/16/sau-rieng-16717642220481128148835-16717643380231430934237-1673694102520436236236-1715848634477708279754.png" class="d-block mx-auto rounded mb-3" alt="Tin tức 1" width="400" height="300">
                                    <h5>Tin tức nông dân 1</h5>
                                    <p>Cập nhật mới nhất từ cộng đồng nông dân.</p>
                                </div>
                                <div class="carousel-item text-center">
                                    <img src="https://danviet.ex-cdn.com/files/f1/upload/3-2018/images/2018-07-27/15-nong-san-ngon-nhat-Viet-Nam-tranh-hung-vai-1532663563-width640height481.jpg" class="d-block mx-auto rounded mb-3" alt="Tin tức 2" width="400" height="300">
                                    <h5>Tin tức nông dân 2</h5>
                                    <p>Thông tin về mùa vụ mới tại vùng nông thôn.</p>
                                </div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#newsCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#newsCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <div class="col text-center">
                    <h2 class="mb-4">Nhịp sống nông dân</h2>
                    <div class="news-card">
                        <img src="https://cdn.pixabay.com/photo/2024/10/27/07/12/women-9152739_1280.jpg" class="rounded mb-3" alt="Nhịp sống 1"  >
                        <h5>Nhịp sống nông dân 1</h5>
                        <p>Chia sẻ về cuộc sống hàng ngày của nông dân.</p>
                    </div>
                    <div class="news-card">
                        <img src="https://media.istockphoto.com/id/1223968655/vi/anh/l%E1%BB%91i-s%E1%BB%91ng-c%E1%BB%A7a-kh%C3%A1i-ni%E1%BB%87m-ch%C3%A2u-%C3%A1-n%C3%B4ng-d%C3%A2n-tr%E1%BB%93ng-tr%E1%BB%8Dt-tr%C3%AAn-s%C3%A2n-th%C6%B0%E1%BB%A3ng-n%C3%B4ng-d%C3%A2n-l%E1%BA%AFc-%C4%91%E1%BA%A5t-t%E1%BB%AB-c%C3%A2y-gi%E1%BB%91ng.jpg?s=2048x2048&w=is&k=20&c=IuO8I2QX_-a3tlWCQ_PF7IpyUMlqm8AkYWM-jpkpN00=" class="rounded mb-3" alt="Nhịp sống 2">
                        <h5>Nhịp sống nông dân 2</h5>
                        <p>Câu chuyện về việc áp dụng công nghệ.</p>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                        </ul>
                    </nav>
                </div>
                <div class="col text-center">
                    <h2 class="mb-4">Khám phá</h2>
                    <div class="explore-card">
                        <img src="https://media.istockphoto.com/id/1346460655/vi/anh/ng%C6%B0%E1%BB%9Di-ph%E1%BB%A5-n%E1%BB%AF-c%E1%BA%A7m-h%E1%BA%A1t-g%E1%BA%A1o.jpg?s=612x612&w=0&k=20&c=hnf4pes20tu14GbzSLxOOtLEqaxNsqzfRkZutNjUqek=" class="rounded mb-3" alt="Khám phá 1">
                        <h5>Khám phá 1</h5>
                        <p>Khám phá quy trình sản xuất nông sản sạch.</p>
                    </div>
                    <div class="explore-card">
                        <img src="https://file.hstatic.net/200000684957/article/nong-san-viet_3a8b189ad6174bbeb0a117ad4b85e4fa.jpg" class="rounded mb-3" alt="Khám phá 2">
                        <h5>Khám phá 2</h5>
                        <p>Tìm hiểu về các loại trái cây đặc sản.</p>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <footer>
            <div class="container">
                <div class="newsletter mb-3 text-center">
                    <input type="email" placeholder="Nhập email để nhận tin" class="text-center">
                    <button type="button" class="ms-2">Gửi</button>
                </div>
                <p class="mb-1">Hotline: 0919 797 908 | Email: agri.pure@gmail.com</p>
                <p>© 2025 AgriPure. All rights reserved.</p>
            </div>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>