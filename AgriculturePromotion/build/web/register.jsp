<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register | Agriculture Production</title>
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
            max-width: 500px; /* Tăng nhẹ để chứa 2 cột */
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
            font-size: 0.85rem; /* Giảm nhẹ kích thước nhãn */
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
            font-size: 0.75rem; /* Giảm kích thước thông báo lỗi */
            margin-top: 0.2rem;
        }
        .input-hint {
            font-size: 0.75rem; /* Giảm kích thước gợi ý */
            color: #555;
            margin-top: 0.2rem;
        }
        .form-control, .form-select {
            font-size: 0.85rem; /* Giảm font input */
            padding: 0.3rem 0.5rem; /* Giảm padding input */
        }
        .row {
            margin: 0 -0.5rem; /* Điều chỉnh margin để căn chỉnh */
        }
        .col-md-6 {
            padding: 0 0.5rem; /* Khoảng cách giữa các cột */
        }
        .form-group {
            margin-bottom: 0.75rem; /* Giảm khoảng cách giữa các trường */
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2><i class="fa-solid fa-leaf me-2"></i>Register</h2>
    <form action="${pageContext.request.contextPath}/register" method="POST" id="formValidation" novalidate>
        <div class="row">
            <!-- left column -->
            <div class="col-md-6">
                <div class="form-group">
                    <label for="fullName" class="form-label">Full Name</label>
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
                    <label for="email" class="form-label">Email Address</label>
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
                    <label for="phone" class="form-label">Phone Number</label>
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
                    <label for="birthday" class="form-label">Birthday</label>
                    <input
                        type="date"
                        class="form-control"
                        id="birthday"
                        name="birthDay"
                        required
                        value="<%= request.getParameter("birthDay") != null ? request.getParameter("birthDay") : "" %>"
                    />
                    <% if (request.getAttribute("birthDayError") != null) { %>
                        <div class="error-message"><%= request.getAttribute("birthDayError") %></div>
                    <% } %>
                </div>
            </div>
            <!-- right column -->
            <div class="col-md-6">
                <div class="form-group">
                    <label for="gender" class="form-label">Gender</label>
                    <select class="form-select" id="gender" name="gender" required>
                        <option value="Nam" <%= "Nam".equals(request.getParameter("gender")) ? "selected" : "" %>>Male</option>
                        <option value="Nữ" <%= "Nữ".equals(request.getParameter("gender")) ? "selected" : "" %>>Female</option>
                        <option value="Other" <%= "Other".equals(request.getParameter("gender")) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
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
                    <label for="address" class="form-label">Address</label>
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
        <button type="submit" class="btn btn-register w-100 text-white mt-2">Register</button>
        <% if (request.getAttribute("generalError") != null) { %>
            <div class="error-message text-center mt-2"><%= request.getAttribute("generalError") %></div>
        <% } %>
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
        const birthDay = document.getElementById('birthday').value;

        let hasError = false;

        // Check full name
        const fullNameRegex = /^[A-Z][A-Za-z\s]*$/;
        if (!fullNameRegex.test(fullName) || fullName.length < 2) {
            hasError = true;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = 'Full name must be at least 2 characters, letters and spaces only, capitalized first letter.';
            document.getElementById('fullName').parentNode.appendChild(errorDiv);
        }

        // Check password
        if (password.length < 8 || !/^[A-Z]/.test(password)) {
            hasError = true;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = 'Password must be at least 8 characters, starting with an uppercase letter.';
            document.getElementById('password').parentNode.appendChild(errorDiv);
        }

        // Check email
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
        if (!emailRegex.test(email)) {
            hasError = true;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = 'Invalid email address.';
            document.getElementById('email').parentNode.appendChild(errorDiv);
        }

        // Check phone number
        const phoneRegex = /^0[0-9]{9}$/;
        if (!phoneRegex.test(phone)) {
            hasError = true;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = 'Phone number must be exactly 10 digits, starting with 0.';
            document.getElementById('phone').parentNode.appendChild(errorDiv);
        }

        // Check address
        if (address.length < 5) {
            hasError = true;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = 'Address must be at least 5 characters.';
            document.getElementById('address').parentNode.appendChild(errorDiv);
        }

        // Check birthday (16 or older)
        const birthDate = new Date(birthDay);
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
            errorDiv.textContent = 'Invalid birthday format. Please use YYYY-MM-DD.';
            document.getElementById('birthday').parentNode.appendChild(errorDiv);
        } else if (age < 16) {
            hasError = true;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = 'Users must be 16 or older.';
            document.getElementById('birthday').parentNode.appendChild(errorDiv);
        }

        if (hasError) {
            e.preventDefault();
        }
    });
</script>
</body>
</html>