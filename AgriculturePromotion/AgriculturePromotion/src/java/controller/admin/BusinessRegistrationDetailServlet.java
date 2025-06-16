package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dal.UserDAO;
import domain.BusinessRegistration;

import java.io.IOException;

@WebServlet("/business-detail")
public class BusinessRegistrationDetailServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo UserDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/business-registrations");
                return;
            }

            int id = Integer.parseInt(idStr);
            BusinessRegistration reg = userDAO.getBusinessRegistrationById(id);

            if (reg == null) {
                response.sendRedirect(request.getContextPath() + "/business-registrations");
                return;
            }

          
            request.setAttribute("registration", reg);
            request.getRequestDispatcher("/business-detail.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi khi lấy chi tiết đăng ký doanh nghiệp", e);
        }
    }
}
