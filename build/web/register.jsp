a<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Agriculture Promotion</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            background: rgba(255, 255, 255, 0.9);
            padding: 2rem 3rem;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 500px;
            width: 100%;
        }
        .register-container h2 {
            color: #28a745;
            text-align: center;
            margin-bottom: 1.5rem;
            font-weight: bold;
        }
        .form-label {
            color: #333;
            font-weight: 500;
        }
        .btn-register {
            background-color: #28a745;
            border: none;
            padding: 0.75rem;
            font-size: 1.1rem;
            font-weight: 500;
        }
        .btn-register:hover {
            background-color: #218838;
        }
        .error-message {
            text-align: center;
            margin-top: 1rem;
        }
        .input-hint {
            font-size: 0.9rem;
            color: #555;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2><i class="fas fa-leaf me-2"></i>Register</h2>
    <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
        <div class="mb-3">
            <label for="fullname" class="form-label">Full Name</label>
            <input type="text" class="form-control" id="fullname" name="fullname" required>
            
        </div>
        <div class="mb-3">
            <label for="gender" class="form-label">Gender</label>
            <select class="form-select" id="gender" name="gender" required>
                <option value="Nam">Nam</option>
                <option value="Nữ">Nữ</option>
                <option value="Khác">Khác</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
           
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
            
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Phone</label>
            <input type="text" class="form-control" id="phone" name="phone" required>
            
        </div>
        <div class="mb-3">
            <label for="address" class="form-label">Address</label>
            <input type="text" class="form-control" id="address" name="address" required>
           
        </div>
        <div class="mb-3">
            <label for="birthday" class="form-label">Birthday</label>
            <input type="date" class="form-control" id="birthday" name="birthday" required>
            
        </div>
        <button type="submit" class="btn btn-register w-100 text-white">Register</button>
    </form>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error-message text-danger"><%= request.getAttribute("error") %></p>
    <% } %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('registerForm').addEventListener('submit', function (e) {
        const fullname = document.getElementById('fullname').value;
        const password = document.getElementById('password').value;
        const email = document.getElementById('email').value;
        const phone = document.getElementById('phone').value;
        const address = document.getElementById('address').value;
        const birthday = document.getElementById('birthday').value;

        // Kiểm tra tên
        const fullnameRegex = /^[A-Z][A-Za-z\s]*$/;
        if (!fullnameRegex.test(fullname) || fullname.length < 2) {
            e.preventDefault();
            alert('Tên phải có ít nhất 2 ký tự, chỉ chứa chữ cái và dấu cách, chữ cái đầu viết hoa.');
            return;
        }

        // Kiểm tra mật khẩu
        if (password.length < 8 || !/^[A-Z]/.test(password)) {
            e.preventDefault();
            alert('Mật khẩu phải có ít nhất 8 ký tự và chữ cái đầu tiên phải viết hoa.');
            return;
        }

        // Kiểm tra email
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Email không hợp lệ.');
            return;
        }

        // Kiểm tra số điện thoại
        const phoneRegex = /^0[0-9]{9}$/;
        if (!phoneRegex.test(phone)) {
            e.preventDefault();
            alert('Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng 0.');
            return;
        }

        // Kiểm tra địa chỉ
        if (address.length < 5) {
            e.preventDefault();
            alert('Địa chỉ phải có ít nhất 5 ký tự.');
            return;
        }

        // Kiểm tra ngày sinh (trên 16 tuổi)
        const birthDate = new Date(birthday);
        const currentDate = new Date('2025-05-21');
        let age = currentDate.getFullYear() - birthDate.getFullYear();
        const monthDiff = currentDate.getMonth() - birthDate.getMonth();
        const dayDiff = currentDate.getDate() - birthDate.getDate();
        if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
            age--;
        }
        if (age < 16) {
            e.preventDefault();
            alert('Người dùng phải từ 16 tuổi trở lên.');
            return;
        }
    });
</script>
</body>
</html>