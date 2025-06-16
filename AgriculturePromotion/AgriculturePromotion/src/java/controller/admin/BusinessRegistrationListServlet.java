package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dal.UserDAO;
import domain.BusinessRegistration;

import java.io.IOException;
import java.util.List;

@WebServlet("/business-registrations")
public class BusinessRegistrationListServlet extends HttpServlet {

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
            
            String statusFilter = request.getParameter("status");

            List<BusinessRegistration> registrations;
            if (statusFilter == null || statusFilter.isEmpty()) {
               registrations = userDAO.getAllBusinessRegistrations();
            } else {
              
                registrations = userDAO.getBusinessRegistrationsByStatus(statusFilter);
            }

           
            for (BusinessRegistration reg : registrations) {
                reg.setStatus(mapStatusToVietnamese(reg.getStatus()));
            }

           
            request.setAttribute("selectedStatus", statusFilter);

            request.setAttribute("registrations", registrations);
            request.getRequestDispatcher("/business-requests.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi khi lấy danh sách đăng ký doanh nghiệp", e);
        }
    }

    private String mapStatusToVietnamese(String status) {
        if (status == null) return "Không xác định";
        switch (status) {
            case "approved": return "Đã duyệt";
            case "rejected": return "Bị từ chối";
            case "pending": return "Đang chờ";
            default: return "Không xác định";
        }
    }
}
