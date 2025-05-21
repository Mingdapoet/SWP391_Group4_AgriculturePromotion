<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Chỉnh sửa người dùng</h2>
    <form action="${pageContext.request.contextPath}/AdminEditUserServlet" method="post">
        <input type="hidden" name="id" value="${user.id}"/>

        <div class="mb-3">
            <label>Họ và tên</label>
            <input type="text" name="fullname" value="${user.fullname}" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" value="${user.email}" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Giới tính</label>
            <select name="gender" class="form-select">
                <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                <option value="Nữ" ${user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
            </select>
        </div>

        <div class="mb-3">
            <label>Ngày sinh</label>
            <input type="date" name="birthday" value="<fmt:formatDate value='${user.birthday}' pattern='yyyy-MM-dd'/>" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Số điện thoại</label>
            <input type="text" name="phone" value="${user.phone}" class="form-control">
        </div>

        <div class="mb-3">
            <label>Địa chỉ</label>
            <input type="text" name="address" value="${user.address}" class="form-control">
        </div>

        <div class="mb-3">
            <label>Vai trò</label>
            <select name="role" class="form-select">
                <option value="student" ${user.role == 'student' ? 'selected' : ''}>Học viên</option>
                <option value="instructor" ${user.role == 'instructor' ? 'selected' : ''}>Giảng viên</option>
                <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Quản trị</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success">Cập nhật</button>
        <a href="${pageContext.request.contextPath}/AdminUserListServlet" class="btn btn-secondary">Hủy</a>
    </form>
</div>
</body>
</html>
