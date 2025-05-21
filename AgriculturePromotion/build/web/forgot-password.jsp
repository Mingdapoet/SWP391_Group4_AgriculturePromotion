<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quên mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-5">
    <h3 class="text-center mb-4">Quên mật khẩu</h3>
    <form action="forgot-password" method="post">
        <div class="mb-3">
            <label for="email" class="form-label">Nhập địa chỉ email đã đăng ký</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Gửi yêu cầu</button>
    </form>
    <div class="text-center mt-3">
        <a href="login.jsp">Quay lại trang đăng nhập</a>
    </div>
</div>
</body>
</html>
