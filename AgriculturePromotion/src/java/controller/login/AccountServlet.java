/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.login;

import dal.UserDAO;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author trvie
 */
@WebServlet(name = "AccountServlet", urlPatterns = {"/Account"})
public class AccountServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AccountServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AccountServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        response.sendRedirect("profile.jsp");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String birthdayStr = request.getParameter("birthday");

        Map<String, String> errors = new HashMap<>();

        // Validate fullname
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("fullNameError", "Họ tên không được để trống");
        }
        // Validate gender
        if (gender == null || !(gender.equals("Nam") || gender.equals("Nữ") || gender.equals("Khác"))) {
            errors.put("genderError", "Vui lòng chọn giới tính hợp lệ");
        }

        // Validate phone
        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phoneError", "Số điện thoại không được để trống");
        }

        java.sql.Date birthday = null;
        if (birthdayStr == null || birthdayStr.trim().isEmpty()) {
            errors.put("birthdayError", "Ngày sinh không được để trống");
        } else {
            try {
                java.util.Date parsedDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthdayStr);
                birthday = new java.sql.Date(parsedDate.getTime());
            } catch (Exception e) {
                errors.put("birthdayError", "Ngày sinh không hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);

            user.setFullName(fullName);
            user.setGender(gender);
            user.setPhone(phone);
            user.setAddress(address);
            user.setBirthday(birthday);

            request.setAttribute("user", user);
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
            return;
        }
        try {
            UserDAO userDAO = new UserDAO();
            user.setFullName(fullName);
            user.setGender(gender);
            user.setPhone(phone);
            user.setAddress(address);
            user.setBirthday(birthday);

            boolean updated = userDAO.updateUserProfile(user);

            if (updated) {
                session.setAttribute("user", user);
                response.sendRedirect("profile.jsp?msg=success");
            } else {
                errors.put("generalError", "Cập nhật không thành công");
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("editprofile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            errors.put("generalError", "Lỗi hệ thống, vui lòng thử lại");
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
