<%-- 
    Document   : profile
    Created on : May 21, 2025, 12:25:10 AM
    Author     : trvie
--%>

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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Information | Agriculture Promotion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2>Thông tin cá nhân</h2>
            <table class="table table-bordered w-75">
                <tr>
                    <th>Họ tên</th>
                    <td><%= user.getFullName() != null ? user.getFullName() : "Chưa cập nhật" %></td>
                </tr>
                <tr>
                    <th>Giới tính</th>
                    <td><%= user.getGender() != null ? user.getGender() : "Chưa cập nhật" %></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><%= user.getEmail() %></td>
                </tr>
                <tr>
                    <th>Số điện thoại</th>
                    <td><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %></td>
                </tr>
                <tr>
                    <th>Địa chỉ</th>
                    <td><%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật" %></td>
                </tr>
                <tr>
                    <th>Ngày Sinh</th>
                    <td>
                        <%= user.getBirthday() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(user.getBirthday()) : "Chưa cập nhật" %>
                    </td>
                </tr>
            </table>
            <a href="editprofile.jsp" class="btn btn-warning">Chỉnh sửa thông tin</a>  
            <a href="index.jsp" class="btn btn-primary">Quay lại trang chủ</a>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
