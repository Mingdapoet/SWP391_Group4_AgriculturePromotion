<%@ page import="java.util.List" %>
<%@ page import="domain.Product" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm của event</title>
</head>
<body>
    <h1>Sản phẩm của event ID <%= request.getAttribute("eventId") %></h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Mô tả</th>
            <th>Số lượng</th>
            <th>Ảnh</th>
        </tr>
        <%
            List<Product> products = (List<Product>) request.getAttribute("products");

            for (Product p : products) {
        %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getName() %></td>
            <td><%= p.getDescription() %></td>
            <td><%= p.getStockQuantity() %></td>
            <td><img src="<%= p.getImageUrl() %>" alt="Product Image" width="100"/></td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
