package controller.admin;

import dal.AppealDAO;
import domain.Appeal;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/appeals-list")
public class ViewAppealsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AppealDAO dao = new AppealDAO();
        List<Appeal> appeals = dao.getAllAppeals();

        request.setAttribute("appeals", appeals);
        request.getRequestDispatcher("/adminappeals.jsp").forward(request, response);
    }
}
