//package controller.post;
//
//import dal.PostDAO;
//import domain.Post;
//import domain.User;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import java.io.IOException;
//import java.sql.SQLException;
//import java.util.List;
//
//@WebServlet("/listPosts")
//public class ListPostServlet extends HttpServlet {
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        if (session == null) {
//            System.out.println("Session is null");
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//        User loggedInUser = (User) session.getAttribute("user");
//        if (loggedInUser == null) {
//            System.out.println("User is null in session");
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//        System.out.println("User logged in: " + loggedInUser.getEmail() + ", Role: " + loggedInUser.getRole());
//
//        PostDAO postDAO = new PostDAO();
//        try {
//            List<Post> posts = postDAO.getPostsByUserId(loggedInUser.getId(), loggedInUser.getRole());
//            request.setAttribute("posts", posts);
//            request.setAttribute("loggedInUser", loggedInUser);
//
//            if (request.getParameter("status") != null) {
//                request.setAttribute("statusMessage", request.getParameter("status"));
//            }
//            if (request.getParameter("error") != null) {
//                request.setAttribute("errorMessage", request.getParameter("error"));
//            }
//
//            request.getRequestDispatcher("listpost.jsp").forward(request, response);
//        } catch (SQLException e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Error loading posts: " + e.getMessage());
//            request.getRequestDispatcher("listpost.jsp").forward(request, response);
//        }
//    }
//}