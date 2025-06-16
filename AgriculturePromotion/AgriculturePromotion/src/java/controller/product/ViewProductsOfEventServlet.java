package controller.product;

import dal.ProductDAO;
import domain.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.*;
 
@WebServlet("/admin/event-products")
public class ViewProductsOfEventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        ProductDAO dao = new ProductDAO();

        List<Product> products = dao.getProductsByEventId(eventId);
        request.setAttribute("products", products);
        request.setAttribute("eventId", eventId);
        
        request.getRequestDispatcher("/event_products.jsp").forward(request, response);
    }
}
