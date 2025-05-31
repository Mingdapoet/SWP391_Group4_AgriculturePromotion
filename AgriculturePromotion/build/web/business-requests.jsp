<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Danh sách đăng ký doanh nghiệp</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e6f2ea 100%);
            color: #1b263b;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
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
            overflow: hidden;
            border: 1px solid #e0e0e0;
        }
        .table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }
        thead {
            background: #1b4332;
            color: #ffffff;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        th {
            padding: 1rem;
            font-size: 0.9rem;
        }
        tbody tr {
            transition: all 0.2s ease;
            background: #ffffff;
        }
        tbody tr:hover {
            background: #f1f9f1;
            transform: translateY(-2px);
        }
        td {
            padding: 1rem;
            vertical-align: middle;
            font-size: 0.95rem;
            border-bottom: 1px solid #e9ecef;
        }
        .status-approved {
            background: #e6f4ea !important;
            color: #2e7d32 !important;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            text-align: center;
            display: inline-block;
        }
        .status-pending {
            background: #fff3cd !important;
            color: #f57c00 !important;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            text-align: center;
            display: inline-block;
        }
        .status-rejected {
            background: #fce4ec !important;
            color: #d32f2f !important;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            text-align: center;
            display: inline-block;
        }
        .status-other {
            background: #e9ecef !important;
            color: #495057 !important;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            text-align: center;
            display: inline-block;
        }
        .btn-details {
            background: #1b5e20;
            border: none;
            padding: 0.5rem 1.25rem;
            font-size: 0.9rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            color: #ffffff;
            text-decoration: none;
        }
        .btn-details:hover {
            background: #134e14;
            box-shadow: 0 4px 12px rgba(27, 94, 32, 0.3);
            transform: translateY(-1px);
            text-decoration: none;
            color: #ffffff;
        }
        .bi-eye {
            font-size: 1rem;
        }
        td:first-child, th:first-child {
            text-align: left;
        }
        td:last-child, th:last-child {
            text-align: center;
            vertical-align: middle;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
        }
        @media (max-width: 768px) {
            h2 {
                font-size: 1.5rem;
            }
            th, td {
                font-size: 0.85rem;
                padding: 0.75rem;
            }
            .btn-details {
                padding: 0.4rem 1rem;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Nút quay lại trang quản trị -->
        <div class="d-flex justify-content-start mb-3">
            <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại trang quản trị
            </a>
        </div>

        <h2>Danh sách đăng ký doanh nghiệp</h2>

        <!-- Form lọc trạng thái -->
        <form method="get" action="${pageContext.request.contextPath}/business-registrations" class="mb-4 d-flex align-items-center gap-3">
            <label for="statusFilter" class="fw-semibold mb-0">Lọc theo trạng thái:</label>
            <select name="status" id="statusFilter" class="form-select" style="width: 200px;">
                <option value="" <c:if test="${empty selectedStatus}">selected</c:if>>Tất cả</option>
                <option value="approved" <c:if test="${selectedStatus == 'approved'}">selected</c:if>>Đã duyệt</option>
                <option value="pending" <c:if test="${selectedStatus == 'pending'}">selected</c:if>>Đang chờ</option>
                <option value="rejected" <c:if test="${selectedStatus == 'rejected'}">selected</c:if>>Bị từ chối</option>
            </select>
            <button type="submit" class="btn btn-success">Lọc</button>
        </form>

        <div class="table-container">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>Tên công ty</th>
                        <th>Mã số thuế</th>
                        <th>Người đại diện</th>
                        <th>Trạng thái</th>
                        <th>Ngày gửi</th>
                        <th>Chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="reg" items="${registrations}">
                        <tr>
                            <td>${reg.companyName}</td>
                            <td>${reg.taxCode}</td>
                            <td>${reg.repFullName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${reg.status == 'Đã duyệt'}">
                                        <span class="status-approved">${reg.status}</span>
                                    </c:when>
                                    <c:when test="${reg.status == 'Đang chờ'}">
                                        <span class="status-pending">${reg.status}</span>
                                    </c:when>
                                    <c:when test="${reg.status == 'Bị từ chối'}">
                                        <span class="status-rejected">${reg.status}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-other">${reg.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${reg.submittedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/business-detail?id=${reg.id}" 
                                   class="btn btn-details" 
                                   title="Xem chi tiết">
                                    <i class="bi bi-eye"></i> Chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty registrations}">
                        <tr>
                            <td colspan="6" class="text-center fst-italic">Không có đăng ký nào phù hợp.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
