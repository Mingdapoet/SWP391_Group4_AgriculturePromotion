<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Agriculture Promotion</title>
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
        .login-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 2rem 3rem;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            width: 100%;
        }
        .login-container h2 {
            color: #28a745;
            text-align: center;
            margin-bottom: 1.5rem;
            font-weight: bold;
        }
        .form-label {
            color: #333;
            font-weight: 500;
        }
        .btn-login {
            background-color: #28a745;
            border: none;
            padding: 0.75rem;
            font-size: 1.1rem;
            font-weight: 500;
        }
        .btn-login:hover {
            background-color: #218838;
        }
        .register-link {
            text-align: center;
            margin-top: 1rem;
        }
        .register-link a {
            color: #28a745;
            font-weight: 500;
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .error-message {
            text-align: center;
            margin-top: 1rem;
        }
        .google-signin-button {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #e0e0e0;
            border: 1px solid #dadce0;
            border-radius: 24px;
            padding: 10px 16px;
            text-decoration: none;
            color: #3c4043;
            font-family: 'Roboto', sans-serif;
            font-size: 14px;
            font-weight: 500;
            width: 100%;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            margin-top: 1rem;
        }
        .google-signin-button:hover {
            background-color: #cccccc;
            border: none;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }
        .google-icon {
            width: 18px;
            height: 18px;
            margin-right: 8px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2><i class="fas fa-leaf me-2"></i>Login</h2>
    <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return checkCaptcha()">
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
            <div class="g-recaptcha mt-2" data-sitekey="6LcboUErAAAAAGZkSfxj-9fL7Z7FgeyP-DsULZ3b"></div>
            <p id="errorCaptcha" class="text-danger text-center mt-2"></p>
        </div>
        <button type="submit" class="btn btn-login w-100 text-white">Login</button>
    </form>
    <div class="register-link">
        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký tại đây</a></p>
        <a href="https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:8080/AgriculturePromotion/googleCallback&response_type=code&client_id=799257369726-5f4bmtll9vr8hb1e066asncb2c1i0m4t.apps.googleusercontent.com&access_type=offline&prompt=consent"
           class="google-signin-button">
            <img class="google-icon" src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google logo">
            Sign in with Google
        </a>
    </div>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error-message text-danger"><%= request.getAttribute("error") %></p>
    <% } %>
</div>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function checkCaptcha() {
        var response = grecaptcha.getResponse();
        var errorCaptcha = document.getElementById("errorCaptcha");

        if (!response) {
            errorCaptcha.textContent = "Vui lòng xác nhận bạn không phải robot!";
            return false;
        }
        return true;
    }
</script>
</body>
</html>