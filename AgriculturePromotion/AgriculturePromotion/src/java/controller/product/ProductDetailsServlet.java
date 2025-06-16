package controller.product;

import dal.ProductDAO;
import domain.Product;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/product")
public class ProductDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không tìm thấy sản phẩm.");
            return;
        }
        int id = Integer.parseInt(idParam);
        ProductDAO dao = new ProductDAO();

        Product product = dao.getProductById(id);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại.");
            return;
        }
        request.setAttribute("product", product);
        request.getRequestDispatcher("/product_detail.jsp").forward(request, response);
    }
}
