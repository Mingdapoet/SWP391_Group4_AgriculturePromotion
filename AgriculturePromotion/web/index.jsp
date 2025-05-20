<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home | Agriculture Promotion</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .hero-section {
            background: url('https://images.unsplash.com/photo-1500595046743-ee5a8a2c7e5d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80') no-repeat center center;
            background-size: cover;
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .hero-section h1 {
            font-size: 3rem;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        .feature-card {
            transition: transform 0.3s;
        }
        .feature-card:hover {
            transform: translateY(-10px);
        }
        footer {
            background-color: #28a745;
        }
        .modal-content {
            border-radius: 0;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">AgriPromotion</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <% if (user == null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link disabled">Hello, <%= user.getEmail() %></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Banner -->
<section class="hero-section">
    <div class="container">
        <h1 class="display-4">Welcome to Agriculture Promotion</h1>
        <p class="lead">Connecting farmers, customers, and innovation in agriculture.</p>
        <button class="btn btn-light btn-lg mt-3" data-bs-toggle="modal" data-bs-target="#searchModal">
            <i class="fas fa-search"></i> Search Products
        </button>
    </div>
</section>

<!-- Features Section -->
<section class="container py-5">
    <div class="row text-center">
        <div class="col-md-4 mb-4">
            <div class="card feature-card shadow-sm">
                <div class="card-body">
                    <i class="fas fa-tractor fa-3x text-success mb-3"></i>
                    <h3>For Farmers</h3>
                    <p>Share your products and reach customers easily.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card feature-card shadow-sm">
                <div class="card-body">
                    <i class="fas fa-shopping-basket fa-3x text-success mb-3"></i>
                    <h3>For Customers</h3>
                    <p>Find fresh products from trusted farmers.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card feature-card shadow-sm">
                <div class="card-body">
                    <i class="fas fa-tags fa-3x text-success mb-3"></i>
                    <h3>Promotions</h3>
                    <p>Explore exclusive deals and seasonal offers.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Search Modal -->
<form action="/products" id="filterForm">
    <div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-fullscreen">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="searchModalLabel">Search Agricultural Products</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-flex align-items-center">
                    <div class="input-group w-75 mx-auto">
                        <input type="search" class="form-control p-3" placeholder="Enter keywords (e.g., organic apples)" name="keySearch" aria-describedby="search-icon">
                        <button class="input-group-text p-3 bg-success text-white" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- Footer -->
<footer class="bg-success text-white text-center py-4">
    <div class="container">
        <p class="mb-0">© 2025 Agriculture Promotion Platform. All rights reserved.</p>
        <p class="mb-0">
            <a href="#" class="text-white me-3">Privacy Policy</a> |
            <a href="#" class="text-white ms-3">Terms of Service</a>
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>