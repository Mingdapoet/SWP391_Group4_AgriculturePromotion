package controller.appeal;

import dal.AppealDAO;
import dal.UserDAO;
import domain.Appeal;
import domain.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/submit-appeal")
public class SubmitAppealServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String reason = request.getParameter("reason");

        if (fullname == null || email == null ||
            reason == null ||
            fullname.trim().isEmpty() ||
            email.trim().isEmpty() ||
            reason.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/appeal.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = null;
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể khởi tạo UserDAO.");
            request.getRequestDispatcher("/appeal.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.getBasicUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email chưa được đăng ký.");
            request.getRequestDispatcher("/appeal.jsp").forward(request, response);
            return;
        }
        
        if (!user.isLocked()) {
            request.setAttribute("error", "Tài khoản chưa bị khóa.");
            request.getRequestDispatcher("/appeal.jsp").forward(request, response);
            return;
        }
        
        Appeal appeal = new Appeal(fullname, email, reason);
        AppealDAO appealDAO = new AppealDAO();

        boolean success = appealDAO.insertAppeal(appeal);

        if (success) {
            request.setAttribute("message", "Đơn kháng cáo đã được gửi thành công.");
        } else {
            request.setAttribute("error", "Gửi đơn kháng cáo thất bại, vui lòng thử lại sau.");
        }
        
        request.getRequestDispatcher("/appeal.jsp").forward(request, response);
    }
}
