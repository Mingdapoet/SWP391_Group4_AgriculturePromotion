<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    String step = request.getParameter("step");
    String error = (String) request.getAttribute("error");
    String email = (String) request.getParameter("email");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên Mật Khẩu</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
            .forgot-password-container {
                background: rgba(255, 255, 255, 0.9);
                padding: 2rem 3rem;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                max-width: 400px;
                width: 100%;
            }
            .forgot-password-container h2 {
                color: #28a745;
                text-align: center;
                margin-bottom: 1.5rem;
                font-weight: bold;
            }
            .btn-reset {
                background-color: #dc3545;
                border: none;
                padding: 0.75rem;
                font-size: 1rem;
                font-weight: 500;
            }
            .btn-reset:hover {
                background-color: #c82333;
            }
            .position-relative {
                position: relative;
            }
            .eye-button {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: transparent;
                cursor: pointer;
                opacity: 0.7;
                transition: opacity 0.3s ease;
            }

            .eye-button:hover {
                opacity: 1;
            }

        </style>
    </head>
    <body>
        <div class="forgot-password-container">
            <h2>Quên Mật Khẩu</h2>

            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <% if ("verify".equals(step)) { %>
            <!-- Form nhập OTP và mật khẩu mới -->
            <form action="ForgotPassword" method="post">
                <input type="hidden" name="step" value="reset">
                <input type="hidden" name="email" value="<%= email %>">

                <div class="mb-3">
                    <label for="otp" class="form-label">Nhập mã OTP</label>
                    <input type="text" class="form-control" id="otp" name="otp" required placeholder="Nhập mã OTP từ email">
                </div>
                <div class="mb-3">
                    <label for="newpassword" class="form-label">Mật khẩu mới</label>
                    <div class="position-relative">
                        <input type="password" class="form-control pe-5" id="newpassword" name="newpassword" required placeholder="Tối thiểu 8 ký tự">
                        <button type="button" class="eye-button" onclick="togglePasswordVisibility('newpassword', this)">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>

                </div>
                <div class="mb-3">
                    <label for="confirmpassword" class="form-label">Xác nhận mật khẩu</label>
                    <div class="position-relative">
                        <input type="password" class="form-control pe-5" id="confirmpassword" name="confirmpassword" required placeholder="Nhập lại mật khẩu">
                        <button type="button" class="eye-button" onclick="togglePasswordVisibility('confirmpassword', this)">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>

                </div>

                <button type="submit" class="btn btn-reset w-100 text-white">Đổi mật khẩu</button>
            </form>

            <!-- Gửi lại OTP -->
            <form action="ForgotPassword" method="post" class="mt-2">
                <input type="hidden" name="step" value="resend">
                <input type="hidden" name="email" value="<%= email %>">
                <button type="submit" class="btn btn-warning w-100">Gửi lại mã OTP</button>
            </form>

            <a href="login.jsp" class="btn btn-secondary w-100 mt-2">Quay lại</a>

            <% } else { %>
            <!-- Form nhập email ban đầu -->
            <form action="ForgotPassword" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email của bạn</label>
                    <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email đã đăng ký">
                </div>
                <button type="submit" class="btn btn-reset w-100 text-white">Gửi mã OTP</button>
                <a href="login.jsp" class="btn btn-secondary w-100 mt-2">Quay lại</a>
            </form>
            <% } %>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
        <script>
                            function togglePasswordVisibility(fieldId, button) {
                                var passwordField = document.getElementById(fieldId);
                                var eyeIcon = button.querySelector("i");

                                if (passwordField.type === "password") {
                                    passwordField.type = "text";
                                    eyeIcon.classList.remove("fa-eye");
                                    eyeIcon.classList.add("fa-eye-slash");
                                } else {
                                    passwordField.type = "password";
                                    eyeIcon.classList.remove("fa-eye-slash");
                                    eyeIcon.classList.add("fa-eye");
                                }
                            }
        </script>
    </body>
</html>
