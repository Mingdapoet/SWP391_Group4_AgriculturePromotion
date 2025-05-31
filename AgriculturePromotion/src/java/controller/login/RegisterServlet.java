package controller.login;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String birthdayStr = request.getParameter("birthday"); // Updated to match JSP
        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String role = "customer"; // Hardcode role as customer

        try {
            // Kiểm tra định dạng tên
            if (!isValidFullName(fullName)) {
                request.setAttribute("fullNameError", "Họ và tên phải có ít nhất 2 ký tự, chỉ chứa chữ cái và khoảng trắng, có thể có dấu.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra định dạng mật khẩu
            if (!isValidPassword(password)) {
                request.setAttribute("passwordError", "Mật khẩu phải có ít nhất 8 ký tự và bắt đầu bằng chữ cái in hoa.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra định dạng email
            if (!isValidEmail(email)) {
                request.setAttribute("emailError", "Email không hợp lệ. Vui lòng nhập email có phần domain như .com, .vn, .org, hoặc .net.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra số điện thoại
            if (!isValidPhone(phone)) {
                request.setAttribute("phoneError", "Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng 0.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra địa chỉ
            if (!isValidAddress(address)) {
                request.setAttribute("addressError", "Địa chỉ phải có ít nhất 5 ký tự và không được chứa ký tự đặc biệt (chỉ cho phép chữ, số, khoảng trắng, dấu chấm, dấu phẩy, dấu gạch ngang).");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra ngày sinh
            Date birthday;
            try {
                birthday = Date.valueOf(birthdayStr); // Matches Flatpickr's Y-m-d format
            } catch (IllegalArgumentException e) {
                request.setAttribute("birthdayError", "Ngày sinh không hợp lệ. Vui lòng chọn lại.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            if (!isValidBirthday(birthday)) {
                request.setAttribute("birthdayError", "Người dùng phải từ 16 tuổi trở lên.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            UserDAO dao = new UserDAO();
            boolean success = dao.register(email, password, role, phone, address, birthday, fullName, gender);

            if (success) {
                request.getSession().setAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                request.setAttribute("emailError", "Email đã tồn tại hoặc có lỗi xảy ra.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("generalError", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    // Kiểm tra định dạng mật khẩu
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        return password.matches("^[A-Z].*");
    }

    // Kiểm tra định dạng tên
    private boolean isValidFullName(String fullName) {
        if (fullName == null || fullName.length() < 2) {
            return false;
        }
        return fullName.matches("^[A-Za-zÀ-ỹ\\s]+$");
    }

    // Kiểm tra định dạng email
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.(com|vn|org|net)$");
    }

    // Kiểm tra số điện thoại
    private boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return phone.matches("^0[0-9]{9}$");
    }

    // Kiểm tra địa chỉ
    private boolean isValidAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            return false;
        }
        return address.length() >= 5 && address.matches("^[A-Za-zÀ-ỹ0-9\\s.,-]+$");
    }

    // Kiểm tra ngày sinh (trên 16 tuổi)
    private boolean isValidBirthday(Date birthday) {
        LocalDate birthDate = birthday.toLocalDate();
        LocalDate currentDate = LocalDate.now();
        Period period = Period.between(birthDate, currentDate);
        return period.getYears() >= 16;
    }
}