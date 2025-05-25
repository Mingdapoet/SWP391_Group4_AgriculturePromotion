<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String msg = request.getParameter("msg");
    if (msg == null) {
        msg = "";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin cá nhân</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                min-height: 100vh;
                background: #f7fef9;
                display: flex;
                flex-direction: column;
                justify-content: flex-start; /* Đẩy nội dung lên trên */
            }
            .profile-card {
                max-width: 480px;
                margin: 24px auto 16px auto;   /* Giảm top xuống 24px, bottom 16px */
                padding: 24px 18px 18px 18px;  /* Thu nhỏ padding xung quanh */
                background: #fff;
                border-radius: 24px;
                box-shadow: 0 4px 32px rgba(34,197,94,0.10), 0 1.5px 6px rgba(0,0,0,0.06);
            }
            .profile-title {
                font-weight: bold;
                font-size: 1.7rem;
                color: #15803d;
                text-align: center;
            }
            .profile-table th, .profile-table td {
                font-size: 1rem;
                vertical-align: middle;
            }
            .btn-genz {
                border-radius: 999px;
                font-weight: bold;
                transition: 0.25s;
                box-shadow: 0 2px 8px rgba(34,197,94,0.08);
            }
            .btn-genz:hover {
                transform: translateY(-3px) scale(1.04);
                opacity: 0.92;
                box-shadow: 0 4px 18px rgba(34,197,94,0.17);
            }
            @media (min-width: 800px) {
                .profile-card {
                    margin-top: 48px;
                }
            }
            @media (max-width: 799px) {
                .profile-card {
                    margin-top: 16px;
                }
            }
        </style>
    </head>
    <body style="background: #f7fef9;">
        <div class="profile-card">
            <% if ("success".equals(msg)) { %>
            <div id="success-alert" class="alert alert-success alert-dismissible fade show" role="alert">
                Cập nhật thông tin thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            <div class="profile-title mb-3">
                <%= user.getFullName() != null ? user.getFullName() : "Chưa cập nhật" %>
            </div>
            <table class="table profile-table">
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
                    <th>Ngày sinh</th>
                    <td><%= user.getBirthday() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(user.getBirthday()) : "Chưa cập nhật" %></td>
                </tr>
            </table>
            <div class="d-flex justify-content-between gap-2 mt-3">
                <a href="editprofile.jsp" class="btn btn-success btn-genz w-50">✏️ Chỉnh sửa</a>
                <a href="index.jsp" class="btn btn-outline-primary btn-genz w-50">🏡 Trang chủ</a>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            window.onload = function () {
                var alertBox = document.getElementById('success-alert');
                if (alertBox) {
                    alertBox.style.display = 'block';
                    setTimeout(function () {
                        alertBox.style.display = 'none';
                    }, 5000); // 5000ms = 5 second
                }
            };

            </body>
                    </html>
