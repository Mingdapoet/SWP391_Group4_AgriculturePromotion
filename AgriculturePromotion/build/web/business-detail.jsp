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

</html>
