<%@ page import="domain.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Product product = (Product) request.getAttribute("product");

    if (product == null) {
%>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Không tìm thấy sản phẩm</title>
        <style>
            body {
                font-family:'Helvetica Neue', sans-serif;
                color:#333;
                padding:20px;
                text-align:center
            }
            a {
                color:#ff4d4f;
                text-decoration:none;
                margin-top:20px;
                display:inline-block;
                padding:10px 20px;
                background:#ffcccb;
                border-radius:5px;
            }
            a:hover {
                background:#ffb3b3;
                color:#fff;
            }
        </style>
    </head>
    <body>
        <h1>Sản phẩm không tồn tại</h1>
        <a href="products-list">↪ Quay lại</a>
    </body>
</html>
<%
    } else {
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title><%= product.getName() %> - Chi tiết sản phẩm</title>
        <style>
            body {
                font-family:'Helvetica Neue', sans-serif;
                color:#333;
                margin: 0;
                padding: 20px;
                background: #f5f5f5;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
                background: #ffffff;
                padding: 30px;
                box-shadow: 0 5px 15px -5px #000;
                border-radius: 10px;
            }
            .product {
                display: flex;
                gap: 30px;
                margin-bottom: 30px;
            }
            .product img {
                max-width: 40%;
                border-radius: 10px;
                border: 1px solid #eee;
            }
            .product-info {
                flex: 1;
            }
            .product-info h1 {
                color: #ff4d4f;
                margin-bottom: 20px;
                font-size: 24px;
            }
            .product-info p {
                margin-bottom: 15px;
                font-size: 16px;
            }
            .details {
                background: #edf5e9;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
                border: 1px solid #c2d9b7;
                box-shadow: 0 2px 5px -1px #0003;
            }
            .details h2 {
                color: #4e7a42;
                margin-bottom: 15px;
                font-size: 20px;
            }
            .details ul {
                list-style: none;
                padding: 0;
            }
            .details ul li {
                margin-bottom: 10px;
                font-size: 16px;
                color: #3a5d39;
            }

            .back-link {
                display: inline-block;
                margin-top: 20px;
                color: #ff4d4f;
                text-decoration: none;
                padding: 10px 20px;
                background: #ffcccb;
                border-radius: 5px;
                transition: all 0.3s ease;
            }
            .back-link:hover {
                background: #ffb3b3;
                color: #fff;
            }
            @media (max-width: 768px) {
                .product {
                    flex-direction: column;
                }
                .product img {
                    max-width: 100%;
                }
            }
        </style>
    </head>
    <body>

        <div class="container">
            <div class="product">
                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                <div class="product-info">
                    <h1><%= product.getName() %></h1>
                    <p><strong>Số lượng trong kho:</strong> <%= product.getStockQuantity() %></p>
                    <p><strong>Mô tả:</strong> <%= product.getDescription() %></p>
                    <p><strong>Xuất xứ:</strong> <%= product.getOrigin() %></p>
                    <p><strong>Giống:</strong> <%= product.getVariety() %></p>
                </div>
            </div>

            <div class="details">
                <h2>Chi tiết sản phẩm</h2>
                <ul>
                    <li><strong>Phương pháp trồng:</strong> <%= product.getFarmingMethod() %></li>
                    <li><strong>Thời gian thu hoạch:</strong> <%= product.getHarvestTime() %></li>
                    <li><strong>Bảo quản:</strong> <%= product.getStorage() %></li>
                    <li><strong>Lợi ích sức khoẻ:</strong> <%= product.getHealthBenefits() %></li>
                    <li><strong>Cách sử dụng:</strong> <%= product.getUsageTips() %></li>
                </ul>
            </div>

            <a class="back-link" href="/AgriculturePromotion/products">↪ Quay lại</a>

        </div>

    </body>
</html>

<%
    }
%>

