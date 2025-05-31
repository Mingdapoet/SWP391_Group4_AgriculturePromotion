<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, domain.BusinessRegistration" %>
<%@ page import="dal.UserDAO" %>
<%
    UserDAO dao = new UserDAO();
    List<BusinessRegistration> list = dao.getAllBusinessRegistrations();
%>
<html>
<head>
    <title>Danh sách đăng ký doanh nghiệp</title>
</head>
<body>
    <h2>Danh sách đăng ký doanh nghiệp</h2>
    <table border="1" cellpadding="10">
        <tr>
            <th>Tên công ty</th>
            <th>Mã số thuế</th>
            <th>Họ tên đại diện</th>
            <th>Trạng thái</th>
            <th>Ngày gửi</th>
            <th>Chi tiết</th>
        </tr>
        <%
            for (BusinessRegistration br : list) {
        %>
        <tr>
            <td><%= br.getCompanyName() %></td>
            <td><%= br.getTaxCode() %></td>
            <td><%= br.getRepFullName() %></td>
            <td><%= br.getStatus() %></td>
            <td><%= br.getSubmittedAt() %></td>
            <td>
                <a href="businessRegistrationDetail.jsp?id=<%= br.getId() %>">Chi tiết</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
