<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Danh sách người dùng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container mt-5">
            <h2>Danh sách người dùng</h2>
            <hr>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Số điện thoại</th>
                        <th>Địa chỉ</th>
                        <th>Ngày sinh</th>
                        <th>Giới tính</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.fullname}</td>
                            <td>${user.email}</td>
                            <td>${user.role}</td>
                            <td>${user.phone}</td>
                            <td>${user.address}</td>
                            <td><fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy" /></td>
                            <td>${user.gender}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/AdminEditUserServlet?id=${user.id}" class="btn btn-sm btn-primary">Sửa</a>
                                <a href="${pageContext.request.contextPath}/AdminDeleteUserServlet?id=${user.id}" 
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?');">Xóa</a>

                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr><td colspan="9" class="text-center">Không có người dùng nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </body>
</html>
