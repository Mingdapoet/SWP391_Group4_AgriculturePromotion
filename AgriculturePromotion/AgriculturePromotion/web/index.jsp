<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ | AgriPure</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #FFD700; /* Bright gold like melted cheese */
            --secondary: #FFA500; /* Warm orange like cheese sticks */
            --background: #FFF8E7; /* Soft cream base */
            --text: #5A3D2B; /* Rich brown for contrast */
            --accent: #FFECB3; /* Light cheesy yellow */
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background);
            color: var(--text);
            line-height: 1.6;
            margin: 0;
        }

        /* Header Top */
        .header-top {
            background: #fff;
            padding: 10px 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
        }
        .header-top .container-fluid {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .header-top .logo img {
            height: 50px;
        }
        .header-top .search {
            flex-grow: 1;
            max-width: 400px;
            margin: 0 20px;
        }
        .header-top .search input {
            border: 1px solid #ddd;
            border-radius: 20px;
            padding: 8px 16px;
            width: 100%;
            background: #fff;
            transition: background 0.3s, border-color 0.3s;
        }
        .header-top .search input:focus {
            background: var(--accent);
            border-color: var(--primary);
            outline: none;
        }
        .header-top .search input::placeholder {
            color: #888;
        }
        .header-top .notification a {
            color: var(--text);
            font-size: 1.2rem;
            transition: color 0.3s;
        }
        .header-top .notification a:hover {
            color: var(--secondary);
        }

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
            justify-content: space-between;
        }
        .header-bottom .navbar-nav {
            display: flex;
            align-items: center;
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
        .header-bottom .user-actions a {
            color: var(--text);
            font-size: 1rem;
            margin-left: 12px;
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

        /* Story Section */
        .story-section {
            background: #fff;
            padding: 10px 20px;
            border-bottom: 1px solid #eee;
            overflow-x: auto;
            white-space: nowrap;
        }
        .story-item {
            display: inline-block;
            width: 120px;
            height: 200px;
            margin-right: 10px;
            background: var(--accent);
            border-radius: 10px;
            text-align: center;
            overflow: hidden;
            position: relative;
            transition: transform 0.3s;
        }
        .story-item:hover {
            transform: scale(1.05);
        }
        .story-item img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 10px 10px 0 0;
        }
        .story-item span {
            display: block;
            font-size: 0.9rem;
            color: var(--text);
            padding: 5px;
            white-space: normal;
        }
        .story-item.add-story {
            background: var(--light-green);
            border: 2px dashed var(--primary);
        }
        .story-item.add-story span {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: var(--primary);
            font-weight: 500;
        }

        /* Hero Section */
        .hero-section .carousel-inner {
            height: 400px;
        }
        .hero-section .carousel-item img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            filter: brightness(0.9);
        }
        .hero-section h2 {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: var(--text);
            font-size: 2.5rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            z-index: 10;
        }

        /* Sidebar */
        .sidebar {
            background: #fff;
            padding: 30px 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: left; /* Changed to left for better readability */
            transition: transform 0.3s;
        }
        .sidebar:hover {
            transform: translateY(-4px); /* Subtle lift effect on hover */
        }
        .sidebar h3 {
            color: var(--primary);
            font-size: 1.6rem;
            font-weight: 600;
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 10px;
        }
        .sidebar h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--secondary);
            border-radius: 2px;
        }
        .sidebar .nav-list {
            list-style: none;
            padding: 0;
            justify-content: center;
        }
        .sidebar .nav-item {
            margin-bottom: 10px;
        }
        .sidebar .nav-link {
            display: flex;
            align-items: center;
            color: var(--text);
            font-size: 1.1rem;
            font-weight: 500;
            padding: 12px 16px;
            border-radius: 8px;
            transition: background 0.3s, color 0.3s, transform 0.2s;
            text-decoration: none;
            text-align: center;
        }
        .sidebar .nav-link:hover {
            background: var(--accent);
            color: var(--secondary);
            transform: translateX(5px); /* Subtle slide effect */
        }
        .sidebar .nav-link i {
            margin-right: 12px;
            font-size: 1.2rem;
            color: var(--primary);
        }
        .sidebar .nav-link:hover i {
            color: var(--secondary);
        }
        /* Active state for sidebar links */
        .sidebar .nav-link.active {
            background: var(--primary);
            color: #fff;
        }
        .sidebar .nav-link.active i {
            color: #fff;
        }

        /* News Carousel */
        .news-carousel {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .news-carousel .carousel-item img {
           width: 1400px;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
            margin: 0 auto 16px;
        }
        .news-carousel h5 {
            font-size: 1.25rem;
            color: var(--text);
        }
        .news-carousel p {
            font-size: 0.95rem;
            color: #666;
        }

        /* Cards */
        .news-card, .explore-card {
            background: #fff;
            border-radius: 12px;
            padding: 20px; /* Increased padding to accommodate larger images */
            margin-bottom: 24px; /* Slightly increased margin for spacing */
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .news-card:hover, .explore-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }
        .news-card img, .explore-card img {
            width: 100%;
            height: 250px; /* Increased from 180px to make images larger */
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 16px; /* Increased margin for better spacing */
        }
        .news-card h5, .explore-card h5 {
            font-size: 1.25rem;
            color: var(--text);
        }
        .news-card p, .explore-card p {
            font-size: 0.95rem;
            color: #666;
        }

        /* Pagination */
        .pagination .page-link {
            color: var(--primary);
            border: 1px solid #ddd;
            margin: 0 4px;
            border-radius: 4px;
        }
        .pagination .page-link:hover {
            background: var(--accent);
        }
        .pagination .page-item.active .page-link {
            background: var(--primary);
            color: #fff;
            border-color: var(--primary);
        }

        /* Footer */
        footer {
            background: var(--primary);
            color: var(--text);
            padding: 40px 0;
            text-align: center;
        }
        footer input {
            border: 1px solid #fff;
            border-radius: 20px;
            padding: 8px 16px;
            width: 250px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
        }
        footer input:focus {
            background: rgba(255, 255, 255, 0.2);
            outline: none;
        }
        footer input::placeholder {
            color: #ccc;
        }
        footer button {
            background: var(--secondary);
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 8px 20px;
            transition: background 0.3s;
        }
        footer button:hover {
            background: #e88c3d;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-top .container-fluid {
                flex-direction: column;
                gap: 12px;
            }
            .header-top .search {
                width: 100%;
                max-width: 300px;
            }
            .header-bottom .navbar-nav {
                flex-direction: column;
                width: 100%;
                gap: 8px;
            }
            .header-bottom .user-actions {
                margin-top: 12px;
            }
            .hero-section .carousel-inner {
                height: 250px;
            }
            .hero-section h2 {
                font-size: 1.8rem;
            }
            .hero-section .carousel-item img {
                height: 250px;
            }
            .sidebar, .main-content {
                width: 100%;
            }
            .dropdown-submenu > .dropdown-menu {
                left: 0;
                position: relative;
                margin-left: 16px;
                box-shadow: none;
            }
            .dropdown-menu {
                margin-top: 0;
            }
            .story-section {
                padding: 10px;
            }
            .story-item {
                width: 90px;
                height: 160px;
            }
            .story-item img {
                height: 220px;
            }
            .sidebar {
                padding: 20px;
            }
            .sidebar h3 {
                font-size: 1.4rem;
            }
            .sidebar .nav-link {
                font-size: 1rem;
                padding: 10px 12px;
            }
            .news-card, .explore-card {
                padding: 16px; /* Reduced padding on mobile */
            }
            .news-card img, .explore-card img {
                height: 400px; /* Slightly smaller on mobile for balance */
            }
        }
    </style>
</head>
<body>
    <%@ include file="/header.jsp" %>

    <!-- Story Section -->
    <div class="story-section">
        <div class="container-fluid">
            <div class="d-flex gap-3">
                <div class="story-item">
                    <img src="https://img.freepik.com/premium-photo/farmer-hands-agriculture-with-soil-dirt-dust-plants-growth-farming-closeup-black-woman-land-farm-with-field-earth-nutrition-ground-sustainability-fertility-zoom_590464-112649.jpg?ga=GA1.1.1329629689.1749419219&semt=ais_items_boosted&w=740" alt="Story 1">
                    <span>Nông dân Bắc</span>
                </div>
                <div class="story-item">
                    <img src="https://img.freepik.com/premium-photo/farmers-are-planting-rice-farm-farmers-bend-grow-rice-agriculture-asia-cultivation-using-people_41722-1571.jpg?ga=GA1.1.1329629689.1749419219&semt=ais_items_boosted&w=740" alt="Story 2">
                    <span>Nông dân Trung</span>
                </div>
                <div class="story-item">
                    <img src="https://img.freepik.com/premium-photo/asian-farmer-man-wears-yellow-shirt-standing-hold-tool-green-rice-farm_37129-1680.jpg?ga=GA1.1.1329629689.1749419219&semt=ais_items_boosted&w=740" alt="Story 3">
                    <span>Nông dân Nam</span>
                </div>
                <div class="story-item add-story">
                    <span>Thêm story</span>
                </div>
            </div>
        </div>
    </div>

    <section class="hero-section">
        <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://cdn.pixabay.com/photo/2024/10/27/07/12/women-9152739_1280.jpg" alt="Banner 1">
                    <h2>Tin tức nổi bật</h2>
                </div>
                <div class="carousel-item">
                    <img src="https://img.freepik.com/free-photo/large-green-rice-field-with-green-rice-plants-rows_181624-28862.jpg?ga=GA1.1.1329629689.1749419219&semt=ais_items_boosted&w=740" alt="Banner 2">
                    <h2>Khám phá nông sản</h2>
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

    <div class="container-fluid py-5">
        <div class="row">
            <div class="col-md-4">
                <div class="sidebar">
                    <h3>Danh mục</h3>
                    <ul class="nav-list">
                        <li class="nav-item"><a class="nav-link" href="#"><i class="fas fa-leaf"></i> Sống xanh</a></li>
                        <li class="nav-item"><a class="nav-link" href="#"><i class="fas fa-truck"></i> Nguồn gốc</a></li>
                        <li class="nav-item"><a class="nav-link" href="#"><i class="fas fa-map"></i> Đặc sản</a></li>
                        <li class="nav-item"><a class="nav-link" href="#"><i class="fas fa-utensils"></i> Ẩm thực</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-md-8">
                <div class="news-carousel">
                    <h2 class="mb-4">Tin tức nông dân</h2>
                    <div id="newsCarousel" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="https://cdn.pixabay.com/photo/2017/05/20/19/51/potatoes-2329648_1280.jpg" alt="Tin tức 1">
                                <h5>Tin tức nông dân 01</h5>
                                <p>Cập nhật mới nhất từ cộng đồng nông dân.</p>
                            </div>
                            <div class="carousel-item">
                                <img src="https://cdn.pixabay.com/photo/2015/07/17/13/44/cucumbers-849269_1280.jpg" alt="Tin tức 2">
                                <h5>Tin tức nông dân 02</h5>
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

    <div class="container-fluid py-5">
        <div class="row row-cols-1 row-cols-md-2 g-4">
            <div class="col">
                <h2 class="mb-4">Nhịp sống nông dân</h2>
                <div class="news-card">
                    <img src="https://cdn.pixabay.com/photo/2024/10/27/07/12/women-9152739_1280.jpg" alt="Nhịp sống 1">
                    <h5>Nhịp sống nông dân 01</h5>
                    <p>Chia sẻ về cuộc sống hàng ngày của nông dân.</p>
                </div>
                <div class="news-card">
                    <img src="https://cdn.pixabay.com/photo/2021/09/18/02/27/vietnam-6634082_1280.jpg" alt="Nhịp sống 2">
                    <h5>Nhịp sống nông dân 02</h5>
                    <p>Câu chuyện về áp dụng công nghệ mới.</p>
                </div>
                <nav aria-label="Pagination">
                    <ul class="pagination">
                        <li class="page-item"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                    </ul>
                </nav>
            </div>
            <div class="col">
                <h2 class="mb-4">Khám phá</h2>
                <div class="explore-card">
                    <img src="https://cdn.pixabay.com/photo/2021/06/21/03/08/blueberries-6352547_1280.jpg" alt="Khám phá 1">
                    <h5>Khám phá 01</h5>
                    <p>Quy trình sản xuất nông sản sạch.</p>
                </div>
                <div class="explore-card">
                    <img src="https://cdn.pixabay.com/photo/2016/11/21/16/40/agriculture-1846358_1280.jpg" alt="Khám phá 2">
                    <h5>Khám phá 02</h5>
                    <p>Tìm hiểu về trái cây đặc sản.</p>
                </div>
                <nav aria-label="Pagination">
                    <ul class="pagination">
                        <li class="page-item"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <%@ include file="/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Handle dropdown submenu toggling on mobile
        document.querySelectorAll('.dropdown-submenu > .dropdown-item').forEach(item => {
            item.addEventListener('click', function(e) {
                if (window.innerWidth <= 768) {
                    e.preventDefault();
                    const submenu = this.nextElementSibling;
                    submenu.style.display = submenu.style.display === 'block' ? 'none' : 'block';
                }
            });
        });
    </script>
</body>
</html>