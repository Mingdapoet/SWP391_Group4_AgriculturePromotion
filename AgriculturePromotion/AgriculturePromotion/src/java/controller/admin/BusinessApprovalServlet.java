package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dal.UserDAO;

import java.io.IOException;

@WebServlet("/business-approval")
public class BusinessApprovalServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new ServletException("Lỗi khi khởi tạo UserDAO", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String action = request.getParameter("action");

        if (idStr == null || idStr.isEmpty() || action == null || action.isEmpty()) {
          
            response.sendRedirect("business-registrations");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            if ("approve".equals(action)) {
                userDAO.approveBusinessRegistration(id);

            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                   
                    response.sendRedirect("business-detail?id=" + id + "&error=missingReason");
                    return;
                }
                userDAO.rejectBusinessRegistration(id, reason.trim());

            } else {
              
                response.sendRedirect("business-registrations");
                return;
            }

            response.sendRedirect("business-detail?id=" + id);

        } catch (NumberFormatException e) {
           
            response.sendRedirect("business-registrations");

        } catch (Exception e) {
            
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi server, vui lòng thử lại sau.");
        }
    }
}
