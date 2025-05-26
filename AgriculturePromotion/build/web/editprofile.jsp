<%-- 
    Document   : editprofile
    Created on : May 21, 2025, 12:56:11 AM
    Author     : trvie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.User" %>
<%@ page import="java.util.Map" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit User Information | Agriculture Promotion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2>Chỉnh sửa thông tin cá nhân</h2>

            <% if (errors != null && errors.get("generalError") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errors.get("generalError") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <form action="Account" method="post" class="w-50">

                <div class="mb-3">
                    <label for="fullName" class="form-label">Họ tên</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required />
                    <% if (errors != null && errors.get("fullNameError") != null) { %>
                    <div class="text-danger"><%= errors.get("fullNameError") %></div>
                    <% } %>
                </div>

                <div class="mb-3">
                    <label for="gender" class="form-label">Giới tính</label>
                    <select class="form-select" id="gender" name="gender" required>
                        <option value="Nam" <%= "Nam".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                        <option value="Nữ" <%= "Nữ".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                        <option value="Khác" <%= "Khác".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                    </select>
                    <% if (errors != null && errors.get("genderError") != null) { %>
                    <div class="text-danger"><%= errors.get("genderError") %></div>
                    <% } %>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" readonly class="form-control-plaintext" id="email" name="email" value="<%= user.getEmail() %>" />
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" />
                    <% if (errors != null && errors.get("phoneError") != null) { %>
                    <div class="text-danger"><%= errors.get("phoneError") %></div>
                    <% } %>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Địa chỉ</label>
                    <textarea class="form-control" id="address" name="address" rows="3"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>

                <div class="mb-3">
                    <label for="birthday" class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" id="birthday" name="birthday" 
                           value="<%= user.getBirthday() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getBirthday()) : "" %>" />
                    <% if (errors != null && errors.get("birthdayError") != null) { %>
                    <div class="text-danger"><%= errors.get("birthdayError") %></div>
                    <% } %>
                </div>
                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                <a href="profile.jsp" class="btn btn-secondary ms-2">Hủy</a>
                <a href="changepassword.jsp" class="btn btn-primary ms-2">Đổi mật khẩu</a>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
