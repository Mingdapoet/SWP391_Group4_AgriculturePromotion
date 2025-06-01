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
            .social-login {
                display: flex;
                justify-content: center;
                gap: 1rem;
                margin-bottom: 1.5rem;
            }
            .social-login a {
                text-decoration: none;
            }
            .social-login img {
                width: 24px;
                height: 24px;
            }
            .separator {
                display: flex;
                align-items: center;
                text-align: center;
                color: #666;
                margin: 1.5rem 0;
            }
            .separator::before,
            .separator::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid #ccc;
            }
            .separator span {
                padding: 0 1rem;
            }
            .form-group {
                margin-bottom: 1rem;
            }
            .eye-button {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: transparent;
                cursor: pointer;
                opacity: 0.7;
                transition: opacity 0.3s ease;
            }

            .eye-button:hover {
                opacity: 1;
            }


        </style>
    </head>
    <body>
        <div class="login-container">
            <h2><i class="fas fa-leaf me-2"></i>Đăng nhập</h2>
            <%-- Tích hợp notification.jsp để hiển thị thông báo --%>
            <%@ include file="notification.jsp" %>

            <div class="social-login">
                <a href="https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:8080/AgriculturePromotion/googleCallback&response_type=code&client_id=799257369726-5f4bmtll9vr8hb1e066asncb2c1i0m4t.apps.googleusercontent.com&access_type=offline&prompt=consent" class="google-signin-button">
                    <img class="google-icon" src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google logo">
                    Sign in with Google
                </a>

            </div>
            <div class="separator"><span>hoặc</span></div>
            <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return checkCaptcha()">
                <div class="form-group">
                    <label for="email" class="form-label">Nhập Email</label>
                    <input type="text" class="form-control" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Nhập mật khẩu</label>
                    <div class="position-relative">
                        <input type="password" class="form-control pe-5" id="password" name="password" required>
                        <button type="button" class="eye-button" onclick="togglePasswordVisibility()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>

                    <div class="forgot-password text-end mt-1">
                        <a href="forgotpassword.jsp" class="text-decoration-none text-success fw-medium">Quên mật khẩu?</a>
                    </div>

                    <div class="g-recaptcha mt-2" data-sitekey="6LcboUErAAAAAGZkSfxj-9fL7Z7FgeyP-DsULZ3b"></div>
                    <p id="errorCaptcha" class="text-danger text-center mt-2"></p>

                </div>
                <button type="submit" class="btn btn-login w-100 text-white">Đăng nhập</button>
                <% if (request.getAttribute("error") != null) { %>
                <p class="error-message text-danger"><%= request.getAttribute("error") %></p>
                <% } %>
            </form>
            <div class="register-now">
                Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký ngay</a>
            </div>

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
                            document.addEventListener('DOMContentLoaded', function () {
                                var alerts = document.querySelectorAll('.alert');
                                if (alerts.length > 0) {
                                    setTimeout(function () {
                                        alerts.forEach(function (alert) {
                                            alert.classList.remove('show');
                                            alert.classList.add('fade');
                                            setTimeout(() => alert.remove(), 150);
                                        });
                                    }, 5000);
                                }
                            });
                            function togglePasswordVisibility() {
                                var passwordField = document.getElementById("password");
                                var eyeIcon = document.querySelector(".eye-button i");

                                if (passwordField.type === "password") {
                                    passwordField.type = "text";
                                    eyeIcon.classList.remove("fa-eye");
                                    eyeIcon.classList.add("fa-eye-slash");
                                } else {
                                    passwordField.type = "password";
                                    eyeIcon.classList.remove("fa-eye-slash");
                                    eyeIcon.classList.add("fa-eye");
                                }
                            }
        </script>
    </body>
</html>