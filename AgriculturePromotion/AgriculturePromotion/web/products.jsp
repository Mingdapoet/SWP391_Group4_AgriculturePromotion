<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="domain.Product" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <style>
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); 
            gap: 20px;
        }
        .product-item {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        .product-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
        .buy-button {
            margin-top: 10px;
            padding: 5px 10px;
            background: green;
            color: #fff;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
<h1>Danh sách sản phẩm</h1>
<div class="product-grid">
    <%
        List<Product> products = (List<Product>) request.getAttribute("products");

        if (products == null || products.isEmpty()) {
    %>
        <p>Không có sản phẩm</p>
    <%
        } else {
            for (Product p : products) {
    %>
    <div class="product-item">
        <a href="product?id=<%= p.getId() %>">
            <img src="<%= p.getImageUrl() %>" alt="Hình ảnh"><br>
            <%= p.getName() %>
        </a>
        <br>
        <span>Số lượng còn: <%= p.getStockQuantity() %></span> <br>
     
    </div>
    <%
            }
        }
    %>
</div>
</body>
</html>
