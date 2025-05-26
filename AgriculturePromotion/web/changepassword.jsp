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
    // Log để debug
    System.out.println("changepassword.jsp - User email: " + user.getEmail() + ", Password: " + user.getPassword());
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu | Agriculture Promotion</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: url('https://images.unsplash.com/photo-1500595046743-ee5a8a2c7e5d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .change-password-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 2rem 3rem;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            width: 100%;
        }
        .change-password-container h2 {
            color: #28a745;
            text-align: center;
            margin-bottom: 1.5rem;
            font-weight: bold;
        }
        .btn-change {
            background-color: #28a745;
            border: none;
            padding: 0.75rem;
            font-size: 1rem;
            font-weight: 500;
        }
        .btn-change:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="change-password-container">
        <h2>Đổi mật khẩu</h2>

        <% if (user.getPassword() == null) { %>
            <div class="alert alert-warning" role="alert">
                Tài khoản này sử dụng đăng nhập Google hoặc không có mật khẩu hợp lệ. Vui lòng liên hệ quản trị viên nếu bạn đăng ký thông thường.
            </div>
            <a href="editprofile.jsp" class="btn btn-secondary w-100">Quay lại</a>
        <% } else { %>
            <% if (errors != null && errors.get("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= errors.get("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <form action="ChangePassword" method="post">
                <div class="mb-3">
                    <label for="newpassword" class="form-label">Mật khẩu mới</label>
                    <input type="password" class="form-control" id="newpassword" name="newpassword" required />
                    <% if (errors != null && errors.get("newpassword") != null) { %>
                        <div class="text-danger"><%= errors.get("newpassword") %></div>
                    <% } %>
                </div>

                <div class="mb-3">
                    <label for="confirmpassword" class="form-label">Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" id="confirmpassword" name="confirmpassword" required />
                    <% if (errors != null && errors.get("confirmpassword") != null) { %>
                        <div class="text-danger"><%= errors.get("confirmpassword") %></div>
                    <% } %>
                </div>

                <button type="submit" class="btn btn-change w-100 text-white">Đổi mật khẩu</button>
                <a href="editprofile.jsp" class="btn btn-secondary w-100 mt-2">Hủy</a>
            </form>
        <% } %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>