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
        <meta charset="UTF-8" />
        <title>Danh sách người dùng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #f5f7fa 0%, #e6f2ea 100%);
                color: #1b263b;
                margin: 0;
                padding: 0;
                min-height: 100vh;
            }
            .container {
                max-width: 100%;
                margin: 2rem auto;
                padding: 0 2rem;
            }
            h2 {
                color: #1b4332;
                font-weight: 700;
                font-size: 2rem;
                text-align: center;
                margin-bottom: 1.5rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .table-container {
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(27, 67, 50, 0.15);
                overflow-x: auto;
                border: 1px solid #e0e0e0;
            }
            table {
                width: 100%;
                table-layout: auto;
            }
            thead {
                background: #1b4332;
                color: #ffffff;
                font-weight: 600;
                text-transform: uppercase;
            }
            th, td {
                padding: 1rem;
                font-size: 0.95rem;
                vertical-align: middle;
                white-space: normal;
                word-wrap: break-word;
                word-break: break-word;
            }
            tbody tr:hover {
                background: #f1f9f1;
                transition: background 0.2s ease;
            }
            td:last-child {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
                justify-content: center;
            }
            .btn-action {
                border-radius: 12px;
                font-size: 0.85rem;
                padding: 0.4rem 0.75rem;
                display: flex;
                align-items: center;
                gap: 0.4rem;
                white-space: nowrap;
            }
            .btn-lock {
                background: #ffc107;
                color: #000;
            }
            .btn-lock:hover {
                background: #e0a800;
            }
            .btn-delete {
                background: #dc3545;
                color: #fff;
            }
            .btn-delete:hover {
                background: #c82333;
            }
            .message {
                text-align: center;
                font-weight: 600;
                color: #198754;
                margin-bottom: 1rem;
            }
            .no-users {
                text-align: center;
                color: #888;
                font-style: italic;
                padding: 2rem;
            }
            @media (max-width: 768px) {
                th, td {
                    font-size: 0.85rem;
                    padding: 0.75rem;
                }
                .btn-action {
                    font-size: 0.8rem;
                    padding: 0.3rem 0.6rem;
                }
                td:last-child {
                    flex-direction: column;
                    align-items: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">

            <div class="d-flex justify-content-start mb-3">
                <a href="<%= contextPath %>/adminDashboard.jsp" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại trang quản trị
                </a>
            </div>

            <h2>Danh sách người dùng</h2>

            <form method="get" action="<%= contextPath %>/admin/user-list" class="d-flex justify-content-center mb-4 gap-2 flex-wrap">
                <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên"
                       style="max-width: 300px;" value="<%= keyword != null ? keyword : "" %>"/>
                <button type="submit" class="btn btn-success">Tìm kiếm</button>
            </form>

            <% if (message != null) { %>
            <div class="message"><%= message %></div>
            <% } %>       

            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Giới tính</th>
                        <th>Ngày sinh</th>
                        <th>SĐT</th>
                        <th>Địa chỉ</th>
                        <th>Vai trò</th>
                        <th class="text-center">Hành động</th><!-- thêm text-center ở đây -->
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
                        <td class="text-center"><!-- thêm text-center ở đây -->
                            <% if (u.isLocked()) { %>
                            <a href="<%= contextPath %>/admin/lock-user?id=<%= u.getId() %>&action=unlock"
                               class="btn btn-warning btn-action"
                               onclick="return confirm('Bạn có chắc muốn mở khóa tài khoản này?');">
                                <i class="bi bi-unlock"></i> Mở khóa
                            </a>
                            <% } else { %>
                            <a href="<%= contextPath %>/admin/lock-user?id=<%= u.getId() %>&action=lock"
                               class="btn btn-warning btn-action"
                               onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?');">
                                <i class="bi bi-lock"></i> Khóa
                            </a>
                            <% } %>
                            <a href="<%= contextPath %>/admin/delete-user?id=<%= u.getId() %>"
                               class="btn btn-danger btn-action"
                               onclick="return confirm('Bạn có chắc muốn xóa người dùng này?');">
                                <i class="bi bi-trash"></i> Xóa
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                        if (!hasUser) {
                    %>
                    <tr>
                        <td colspan="9" class="text-center text-muted p-4">
                            Không có người dùng nào
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>


        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
