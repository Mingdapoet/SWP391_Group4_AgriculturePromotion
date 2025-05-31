<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng ký | Agriculture Production</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background: url('https://images.unsplash.com/photo-1500595046743-ee5a8a2c7e5d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80') no-repeat center center fixed;
                background-size: cover;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
            }
            .register-container {
                background: rgba(255, 255, 255, 0.95);
                padding: 1.5rem;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                max-width: 500px;
                width: 100%;
            }
            .register-container h2 {
                color: #28a745;
                text-align: center;
                margin-bottom: 1rem;
                font-weight: bold;
                font-size: 1.5rem;
            }
            .form-label {
                color: #333;
                font-weight: 500;
                font-size: 0.85rem;
            }
            .btn-register {
                background-color: #28a745;
                border: none;
                padding: 0.5rem;
                font-size: 1rem;
                font-weight: 500;
            }
            .btn-register:hover {
                background-color: #218838;
            }
            .error-message {
                color: #dc3545;
                font-size: 0.75rem;
                margin-top: 0.2rem;
            }
            .input-hint {
                font-size: 0.75rem;
                color: #555;
                margin-top: 0.2rem;
            }
            .form-control, .form-select {
                font-size: 0.85rem;
                padding: 0.3rem 0.5rem;
            }
            .row {
                margin: 0 -0.5rem;
            }
            .col-md-6 {
                padding: 0 0.5rem;
            }
            .form-group {
                margin-bottom: 0.75rem;
            }
            .birthdate-row {
                display: flex;
                margin-top: 0.25rem;
            }

            .birthdate-col {
                flex: 1;
            }



            .birthdate-row .form-select {
                flex: 1;
                padding: 0.3rem 0.5rem;

            }

        </style>
    </head>
    <body>
        <div class="register-container">
            <h2><i class="fa-solid fa-leaf me-2"></i>Đăng ký tài khoản</h2>
            <form action="${pageContext.request.contextPath}/register" method="POST" id="formValidation" novalidate>
                <div class="row">
                    <!-- left column -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="fullName" class="form-label">Họ và tên</label>
                            <input
                                type="text"
                                class="form-control"
                                id="fullName"
                                name="fullName"
                                required
                                value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>"
                                />
                            <% if (request.getAttribute("fullNameError") != null) { %>
                            <div class="error-message"><%= request.getAttribute("fullNameError") %></div>
                            <% } %>
                        </div>
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input
                                type="email"
                                class="form-control"
                                id="email"
                                name="email"
                                required
                                value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                                />
                            <% if (request.getAttribute("emailError") != null) { %>
                            <div class="error-message"><%= request.getAttribute("emailError") %></div>
                            <% } %>
                        </div>
                        <div class="form-group">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input
                                type="text"
                                class="form-control"
                                id="phone"
                                name="phone"
                                required
                                value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
                                />
                            <% if (request.getAttribute("phoneError") != null) { %>
                            <div class="error-message"><%= request.getAttribute("phoneError") %></div>
                            <% } %>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Ngày sinh</label>
                            <div class="birthdate-row">
                                <div class="birthdate-col">
                                    <select class="form-select" id="birthDay" name="birthDay" required>
                                        <option value="">Ngày</option>
                                        <% for (int day = 1; day <= 31; day++) { %>
                                        <option value="<%= day < 10 ? "0" + day : day %>" <%= String.valueOf(day).equals(request.getParameter("birthDay")) ? "selected" : "" %>>
                                            <%= day %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="birthdate-col">
                                    <select class="form-select" id="birthMonth" name="birthMonth" required>
                                        <option value="">Tháng</option>
                                        <% for (int month = 1; month <= 12; month++) { %>
                                        <option value="<%= month < 10 ? "0" + month : month %>" <%= String.valueOf(month).equals(request.getParameter("birthMonth")) ? "selected" : "" %>>
                                            <%= month %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="birthdate-col">
                                    <select class="form-select" id="birthYear" name="birthYear" required>
                                        <option value="">Năm</option>
                                        <% 
                                            int currentYear = java.time.Year.now().getValue();
                                            for (int year = currentYear; year >= 1900; year--) { 
                                        %>
                                        <option value="<%= year %>" <%= String.valueOf(year).equals(request.getParameter("birthYear")) ? "selected" : "" %>>
                                            <%= year %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>

                            <% if (request.getAttribute("birthDayError") != null) { %>
                            <div class="error-message"><%= request.getAttribute("birthDayError") %></div>
                            <% } %>
                        </div>
                    </div>
                    <!-- right column -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="gender" class="form-label">Giới tính</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="Nam" <%= "Nam".equals(request.getParameter("gender")) ? "selected" : "" %>>Nam</option>
                                <option value="Nữ" <%= "Nữ".equals(request.getParameter("gender")) ? "selected" : "" %>>Nữ</option>
                                <option value="Other" <%= "Other".equals(request.getParameter("gender")) ? "selected" : "" %>>Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input
                                type="password"
                                class="form-control"
                                id="password"
                                name="password"
                                required
                                />
                            <% if (request.getAttribute("passwordError") != null) { %>
                            <div class="error-message"><%= request.getAttribute("passwordError") %></div>
                            <% } %>
                        </div>
                        <div class="form-group">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <input
                                type="text"
                                class="form-control"
                                id="address"
                                name="address"
                                required
                                value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>"
                                />
                            <% if (request.getAttribute("addressError") != null) { %>
                            <div class="error-message"><%= request.getAttribute("addressError") %></div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-register w-100 text-white mt-2">Đăng ký</button>
                <% if (request.getAttribute("generalError") != null) { %>
                <div class="error-message text-center mt-2"><%= request.getAttribute("generalError") %></div>
                <% } %>
                <div class="text-center mt-2">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="text-decoration-none">Bạn đã có tài khoản ư?</a>
                </div>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.getElementById('formValidation').addEventListener('submit', function (e) {
                // Remove previous error messages
                document.querySelectorAll('.error-message').forEach(el => el.remove());

                const fullName = document.getElementById('fullName').value;
                const password = document.getElementById('password').value;
                const email = document.getElementById('email').value;
                const phone = document.getElementById('phone').value;
                const address = document.getElementById('address').value;
                const birthDay = document.getElementById('birthDay').value;
                const birthMonth = document.getElementById('birthMonth').value;
                const birthYear = document.getElementById('birthYear').value;

                let hasError = false;

                // Check full name
                const fullNameRegex = /^[A-Za-zÀ-ỹ\s]+$/;
                if (!fullNameRegex.test(fullName) || fullName.length < 2) {
                    hasError = true;
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    errorDiv.textContent = 'Họ và tên phải có ít nhất 2 ký tự, chỉ chứa chữ cái và khoảng trắng, có thể có dấu.';
                    document.getElementById('fullName').parentNode.appendChild(errorDiv);
                }

                // Check password
                if (password.length < 8 || !/^[A-Z]/.test(password)) {
                    hasError = true;
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    errorDiv.textContent = 'Mật khẩu phải có ít nhất 8 ký tự và bắt đầu bằng chữ cái in hoa.';
                    document.getElementById('password').parentNode.appendChild(errorDiv);
                }

                // Check email
                const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.(com|vn|org|net)$/;
                if (!emailRegex.test(email)) {
                    hasError = true;
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    errorDiv.textContent = 'Email không hợp lệ. Vui lòng nhập email có phần domain như .com, .vn, .org, hoặc .net.';
                    document.getElementById('email').parentNode.appendChild(errorDiv);
                }

                // Check phone number
                const phoneRegex = /^0[0-9]{9}$/;
                if (!phoneRegex.test(phone)) {
                    hasError = true;
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    errorDiv.textContent = 'Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng 0.';
                    document.getElementById('phone').parentNode.appendChild(errorDiv);
                }

                // Check address
                const addressRegex = /^[A-Za-zÀ-ỹ0-9\s.,-]+$/;
                if (address.length < 5 || !addressRegex.test(address)) {
                    hasError = true;
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    errorDiv.textContent = 'Địa chỉ phải có ít nhất 5 ký tự và không được chứa ký tự đặc biệt (chỉ cho phép chữ, số, khoảng trắng, dấu chấm, dấu phẩy, dấu gạch ngang).';
                    document.getElementById('address').parentNode.appendChild(errorDiv);
                }

                // Check birthday (16 or older)
                if (!birthDay || !birthMonth || !birthYear) {
                    hasError = true;
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    errorDiv.textContent = 'Vui lòng chọn đầy đủ ngày, tháng, năm sinh.';
                    document.getElementById('birthDay').parentNode.parentNode.appendChild(errorDiv);
                } else {
                    const birthDate = new Date(`${birthYear}-${birthMonth}-${birthDay}`);
                                const currentDate = new Date();
                                let age = currentDate.getFullYear() - birthDate.getFullYear();
                                const monthDiff = currentDate.getMonth() - birthDate.getMonth();
                                const dayDiff = currentDate.getDate() - birthDate.getDate();
                                if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
                                    age--;
                                }
                                if (isNaN(birthDate.getTime())) {
                                    hasError = true;
                                    const errorDiv = document.createElement('div');
                                    errorDiv.className = 'error-message';
                                    errorDiv.textContent = 'Ngày sinh không hợp lệ. Vui lòng kiểm tra lại ngày, tháng, năm.';
                                    document.getElementById('birthDay').parentNode.parentNode.appendChild(errorDiv);
                                } else if (age < 16) {
                                    hasError = true;
                                    const errorDiv = document.createElement('div');
                                    errorDiv.className = 'error-message';
                                    errorDiv.textContent = 'Người dùng phải từ 16 tuổi trở lên.';
                                    document.getElementById('birthDay').parentNode.parentNode.appendChild(errorDiv);
                                }
                            }

                            if (hasError) {
                                e.preventDefault();
                            }
                        });
        </script>
    </body>
</html> 