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
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật thông tin cá nhân</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <style>
            .edit-card {
                max-width: 440px;
                margin: 32px auto;
                background: #fff;
                border-radius: 24px;
                box-shadow: 0 4px 32px rgba(34,197,94,0.09), 0 1.5px 6px rgba(0,0,0,0.05);
                padding: 30px 26px 18px 26px;
            }
            .custom-file-input {
                display: none;
            }
            .custom-file-label {
                display: block;
                background: #f1f5f9;
                color: #15803d;
                border-radius: 999px;
                padding: 7px 22px;
                font-size: 1rem;
                text-align: center;
                cursor: pointer;
                margin: 0 auto 10px auto;
                transition: 0.2s;
                width: fit-content;
            }
            .custom-file-label:hover {
                background: #def7e2;
            }
            .btn-genz {
                border-radius: 999px;
                font-weight: bold;
                transition: 0.22s;
            }
            .btn-genz:hover {
                transform: translateY(-2px) scale(1.03);
                opacity: 0.93;
            }
            .form-label {
                font-weight: 500;
            }
            @media (max-width: 600px) {
                .edit-card {
                    padding: 16px;
                }
            }
        </style>
    </head>
    <body style="background: #f7fef9;">
        <div class="edit-card">
            <h3 class="mb-3 text-center" style="color: #16a34a;">Cập nhật thông tin cá nhân</h3>

            <% if (errors != null && errors.get("generalError") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errors.get("generalError") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <form action="Account" method="post">
                <div class="mb-3">
                    <label for="fullName" class="form-label">Họ tên</label>
                    <input type="text" class="form-control" id="fullName" name="fullName"
                           value="<%= user.getFullName() != null ? user.getFullName() : "" %>" />
                    <% if (errors != null && errors.get("fullNameError") != null) { %>
                    <div class="text-danger"><%= errors.get("fullNameError") %></div>
                    <% } %>
                </div>

                <div class="mb-3">
                    <label for="gender" class="form-label">Giới tính</label>
                    <select class="form-select" id="gender" name="gender">
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
                    <% if (errors != null && errors.get("addressError") != null) { %>
                    <div class="text-danger"><%= errors.get("addressError") %></div>
                    <% } %>
                </div>

                <div class="mb-3">
                    <label for="birthday" class="form-label">Ngày sinh</label>
                    <input type="text" class="form-control" id="birthday" name="birthday"
                           value="<%= user.getBirthday() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getBirthday()) : "" %>" autocomplete="off" />
                    <% if (errors != null && errors.get("birthdayError") != null) { %>
                    <div class="text-danger"><%= errors.get("birthdayError") %></div>
                    <% } %>
                </div>
                <div class="d-flex gap-2 mt-3 justify-content-center">
                    <button type="submit" class="btn btn-success btn-genz px-4 py-2" style="font-size: 0.9rem;">
                        <i class="fas fa-save me-2"></i> Lưu thay đổi
                    </button>
                    <a href="profile.jsp" class="btn btn-danger btn-genz px-4 py-2" style="font-size: 0.9rem;">
                        <i class="fas fa-times me-2"></i> Hủy
                    </a>
                </div>
                  <div class="text-center mt-3">
            <a href="changepassword.jsp" class="btn btn-warning btn-genz px-4 py-2" style="font-size: 0.9rem;">
                <i class="fas fa-lock me-2"></i> Đổi mật khẩu
            </a>
        </div>

        </div>


    </form>
              
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- Flatpickr CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<!-- Flatpickr JS -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<script>
    flatpickr("#birthday", {
        dateFormat: "Y-m-d",
        maxDate: "today",
        altInput: true,
        altFormat: "d/m/Y"
    });
</script>
</body>
</html>
