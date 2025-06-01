<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="domain.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    String message = (String) request.getAttribute("message");
    String keyword = (String) request.getAttribute("keyword");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f0f4f8, #e6f2ea);
            padding: 2rem;
            min-height: 100vh;
        }
        h2 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 1.5rem;
            color: #1b4332;
            text-transform: uppercase;
        }
        .table-container {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            padding: 1rem;
            overflow-x: auto;
        }
        table {
            width: 100%;
            table-layout: fixed;
        }
        th, td {
            text-align: center;
            padding: 0.75rem;
            vertical-align: middle;
            word-break: break-word;
            font-size: 0.95rem;
        }
        thead {
            background-color: #1b4332;
            color: white;
        }
        .action-icons a {
            color: #333;
            margin: 0 5px;
            font-size: 1.1rem;
            transition: color 0.2s;
        }
        .action-icons a:hover {
            color: #0d6efd;
        }
        .btn-back {
            margin-bottom: 1rem;
        }
        .message {
            color: #198754;
            font-weight: 600;
            text-align: center;
            margin-bottom: 1rem;
        }
        .no-users {
            text-align: center;
            padding: 1rem;
            color: #888;
            font-style: italic;
        }
        @media (max-width: 768px) {
            th, td {
                font-size: 0.85rem;
            }
            .action-icons a {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">

    <div class="btn-back">
        <a href="<%= contextPath %>/adminDashboard.jsp" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Quay lại trang quản trị
        </a>
    </div>

    <h2>Danh sách người dùng</h2>

    <!-- Form tìm kiếm -->
    <form method="get" action="<%= contextPath %>/admin/user-list" class="d-flex justify-content-center mb-4 gap-2 flex-wrap">
        <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên" style="max-width: 300px;"
               value="<%= keyword != null ? keyword : "" %>"/>
        <button type="submit" class="btn btn-success">Tìm kiếm</button>
    </form>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <div class="table-container">
        <table class="table table-hover align-middle">
            <thead>
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 15%;">Họ tên</th>
                    <th style="width: 20%;">Email</th>
                    <th style="width: 10%;">Giới tính</th>
                    <th style="width: 12%;">Ngày sinh</th>
                    <th style="width: 12%;">SĐT</th>
                    <th style="width: 15%;">Địa chỉ</th>
                    <th style="width: 10%;">Vai trò</th>
                    <th style="width: 10%;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean hasUser = false;
                    if (users != null && !users.isEmpty()) {
                        for (User u : users) {
                            if ("admin".equalsIgnoreCase(u.getRole())) continue;
                            hasUser = true;
                %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getFullName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getGender() %></td>
                    <td><%= u.getBirthday() != null ? u.getBirthday().toString() : "" %></td>
                    <td><%= u.getPhone() %></td>
                    <td><%= u.getAddress() %></td>
                    <td><%= u.getRole() %></td>
                    <td class="action-icons">
                        <% if (u.isLocked()) { %>
                            <a href="<%= contextPath %>/admin/lock-user?id=<%= u.getId() %>&action=unlock"
                               title="Mở khóa" onclick="return confirm('Bạn có chắc muốn mở khóa tài khoản này?');">
                                <i class="bi bi-unlock"></i>
                            </a>
                        <% } else { %>
                            <a href="<%= contextPath %>/admin/lock-user?id=<%= u.getId() %>&action=lock"
                               title="Khóa tài khoản" onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?');">
                                <i class="bi bi-lock"></i>
                            </a>
                        <% } %>
                        <a href="<%= contextPath %>/admin/delete-user?id=<%= u.getId() %>"
                           title="Xóa người dùng" onclick="return confirm('Bạn có chắc muốn xóa người dùng này?');">
                            <i class="bi bi-trash"></i>
                        </a>
                    </td>
                </tr>
                <%      }
                    }
                    if (!hasUser) {
                %>
                <tr>
                    <td colspan="9" class="no-users">Không có người dùng nào</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
