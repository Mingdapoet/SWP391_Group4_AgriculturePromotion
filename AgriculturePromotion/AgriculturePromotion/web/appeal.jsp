<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gửi kháng cáo tài khoản</title>
    <link rel="stylesheet" 
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <h1>Gửi kháng cáo tài khoản</h1>

    <!-- Hiển thị thông báo nếu có -->
    <%
        String error = (String) request.getAttribute("error");
        String message = (String) request.getAttribute("message");

        if (error != null) {
    %>
        <div class="alert alert-danger"><%= error %></div>
    <%
        }
        if (message != null) {
    %>
        <div class="alert alert-success"><%= message %></div>
    <%
        }
    %>

    <form action="${pageContext.request.contextPath}/submit-appeal" method="post">
        <div class="mb-3">
            <label for="fullname" class="form-label">Họ tên</label>
            <input type="text" id="fullname" name="fullname" 
                   class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email (đã đăng ký)</label>
            <input type="email" id="email" name="email" 
                   class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="reason" class="form-label">Lý do kháng cáo</label>
            <textarea id="reason" name="reason" 
                      class="form-control" rows="5" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Gửi kháng cáo</button>
    </form>

    <br>
    <a class="btn btn-secondary" 
       href="${pageContext.request.contextPath}/index.jsp">
        Quay lại
    </a>
</body>
</html>
