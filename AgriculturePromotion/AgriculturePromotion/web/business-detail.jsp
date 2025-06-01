<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <title>Chi tiết đơn đăng ký doanh nghiệp</title>
        <style>
            /* Reset cơ bản */
            *, *::before, *::after {
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fa;
                margin: 40px auto;
                max-width: 720px;
                padding: 25px 35px;
                border-radius: 10px;
                box-shadow: 0 8px 18px rgba(0,0,0,0.1);
                color: #333;
            }

            h2 {
                text-align: center;
                color: #00796b;
                margin-bottom: 40px;
                font-weight: 700;
                letter-spacing: 1px;
            }

            .detail-row {
                display: flex;
                padding: 12px 0;
                border-bottom: 1px solid #e1e5ea;
                align-items: center;
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .label {
                flex: 0 0 180px;
                font-weight: 600;
                color: #555;
                letter-spacing: 0.03em;
                font-size: 0.95rem;
            }

            .value {
                flex: 1;
                font-size: 1rem;
                color: #222;
                word-break: break-word;
            }

            /* Trạng thái */
            .status-approved {
                color: #388e3c;
                font-weight: 700;
            }

            .status-rejected {
                color: #d32f2f;
                font-weight: 700;
            }

            .status-pending {
                color: #f57c00;
                font-weight: 700;
            }

            /* Link tài liệu */
            .document-link {
                display: inline-block;
                padding: 7px 16px;
                background-color: #00796b;
                color: #fff;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 600;
                transition: background-color 0.25s ease;
                font-size: 0.95rem;
            }
            .document-link:hover {
                background-color: #004d40;
            }

            /* Form */
            form {
                margin-top: 30px;
                background: #ffffff;
                padding: 20px 25px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            label.reject-reason-label {
                font-weight: 600;
                margin-bottom: 8px;
                display: block;
                font-size: 0.95rem;
                color: #444;
            }

            input[type=text] {
                width: 100%;
                padding: 10px 12px;
                font-size: 1rem;
                border: 1.8px solid #ccc;
                border-radius: 6px;
                outline-offset: 2px;
                transition: border-color 0.25s ease;
                margin-bottom: 20px;
                color: #222;
            }

            input[type=text]:focus {
                border-color: #00796b;
                box-shadow: 0 0 5px #00796b66;
            }

            /* Nút */
            .button-group {
                display: flex;
                gap: 14px;
                justify-content: flex-start;
                flex-wrap: wrap;
            }

            button.btn {
                padding: 12px 28px;
                font-weight: 700;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 1rem;
                transition: background-color 0.3s ease;
                min-width: 120px;
                box-shadow: 0 3px 6px rgba(0,0,0,0.12);
                user-select: none;
            }

            button.btn-approve {
                background-color: #4caf50;
                color: #fff;
            }
            button.btn-approve:hover {
                background-color: #388e3c;
            }

            button.btn-reject {
                background-color: #f44336;
                color: #fff;
            }
            button.btn-reject:hover {
                background-color: #b71c1c;
            }

            /* Lý do từ chối */
            small.reject-reason-text {
                display: block;
                margin-top: 6px;
                color: #d32f2f;
                font-weight: 600;
                font-size: 0.9rem;
                line-height: 1.3;
            }

            /* Link quay lại */
            a.back-link {
                display: inline-block;
                margin-top: 40px;
                color: #555;
                font-weight: 600;
                text-decoration: none;
                font-size: 1rem;
                transition: color 0.25s ease;
            }

            a.back-link:hover {
                color: #00796b;
                text-decoration: underline;
            }
        </style>

        <script>
            function validateReject(form) {
                const reason = form.reason.value.trim();
                if (!reason) {
                    alert("Vui lòng nhập lý do từ chối.");
                    return false;
                }
                return confirm("Bạn có chắc chắn muốn từ chối đơn đăng ký này?");
            }
        </script>
    </head>
    <body>
        
        <h2>Chi tiết đơn đăng ký doanh nghiệp</h2>

        <div class="detail-row">
            <div class="label">Trạng thái:</div>
            <div class="value">
                <c:choose>
                    <c:when test="${registration.status == 'approved'}">
                        <span class="status-approved">Đã duyệt</span>
                    </c:when>
                    <c:when test="${registration.status == 'rejected'}">
                        <span class="status-rejected">Đã từ chối</span>
                       <small class="reject-reason-text">Lý do: ${registration.rejectionReason}</small>

                    </c:when>
                    <c:otherwise>
                        <span class="status-pending">Chờ duyệt</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="detail-row"><div class="label">Tên công ty:</div><div class="value">${registration.companyName}</div></div>
        <div class="detail-row"><div class="label">Mã số thuế:</div><div class="value">${registration.taxCode}</div></div>
        <div class="detail-row"><div class="label">Email công ty:</div><div class="value">${registration.companyEmail}</div></div>
        <div class="detail-row"><div class="label">Số điện thoại:</div><div class="value">${registration.companyPhone}</div></div>
        <div class="detail-row"><div class="label">Trụ sở chính:</div><div class="value">${registration.headOffice}</div></div>
        <div class="detail-row"><div class="label">Loại hình doanh nghiệp:</div><div class="value">${registration.businessType}</div></div>
        <div class="detail-row"><div class="label"></div><div class="value">${registration.customType}</div></div>
        <div class="detail-row"><div class="label">Họ tên đại diện:</div><div class="value">${registration.repFullName}</div></div>
        <div class="detail-row"><div class="label">Chức vụ đại diện:</div><div class="value">${registration.repPosition}</div></div>
        <div class="detail-row"><div class="label">Email đại diện:</div><div class="value">${registration.repEmail}</div></div>
        <div class="detail-row"><div class="label">SĐT đại diện:</div><div class="value">${registration.repPhone}</div></div>
        <div class="detail-row">
            <div class="label">Ngày gửi:</div>
            <div class="value"><fmt:formatDate value="${registration.submittedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></div>
        </div>
        <div class="detail-row">
            <div class="label">Tài liệu pháp lý:</div>
            <div class="value">
                <c:choose>
                    <c:when test="${not empty registration.filePath}">
                        <a href="${registration.filePath}" target="_blank" class="document-link" rel="noopener noreferrer">Xem tài liệu</a>
                    </c:when>
                    <c:otherwise>
                        <span>(Chưa có tài liệu)</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${registration.status == null || registration.status == '' || registration.status == 'pending'}">
            <form action="business-approval" method="post" onsubmit="return this.action === 'reject' ? validateReject(this) : true;">
                <input type="hidden" name="id" value="${registration.id}"/>

                <label for="reason" class="reject-reason-label">Lý do từ chối:</label>
                <input type="text" id="reason" name="reason" placeholder="Nhập lý do từ chối nếu có"/>

                <div class="button-group">
                    <button type="submit" name="action" value="approve" class="btn btn-approve">Phê duyệt</button>
                    <button type="submit" name="action" value="reject" class="btn btn-reject" onclick="return validateReject(this.form);">Từ chối</button>
                </div>
            </form>
        </c:if>

        <a href="business-registrations" class="back-link">&larr; Quay lại danh sách đăng ký doanh nghiệp</a>

    </body>
</html>
