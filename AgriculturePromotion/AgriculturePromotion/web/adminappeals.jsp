<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách kháng cáo</title>
</head>
<body>
    <h1>Danh sách kháng cáo</h1>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>Lý do kháng cáo</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>

        <c:forEach var="appeal" items="${appeals}">
            <tr>
                <td>${appeal.id}</td>
                <td>${appeal.fullname}</td>
                <td>${appeal.email}</td>
                <td>${appeal.reason}</td>
                <td>${appeal.status}</td>
                <td>
                    <a href="resolve-appeal?email=${appeal.email}">
                        Giải quyết kháng cáo
                    </a>
                </td>
            </tr>
        </c:forEach>
    </table>

</body>
</html>
