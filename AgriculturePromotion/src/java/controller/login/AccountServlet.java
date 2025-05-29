/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.login;

import dal.*;
import domain.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author trvie
 */
@MultipartConfig
@WebServlet(name = "AccountServlet", urlPatterns = {"/Account"})
public class AccountServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

    // Validate full name
    private Map<String, String> validateFullName(String fullName) {
        Map<String, String> errors = new HashMap<>();
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("fullNameError", "Họ tên không được để trống");
        } else if (!fullName.matches("^[\\p{L} .'-]+$")) { // Chỉ cho phép chữ, dấu cách, dấu chấm, dấu nháy đơn và dấu gạch ngang
            errors.put("fullNameError", "Họ tên chứa ký tự không hợp lệ");
        }
        return errors;
    }

    // Validate gender
    private Map<String, String> validateGender(String gender) {
        Map<String, String> errors = new HashMap<>();
        if (gender == null || !(gender.equals("Nam") || gender.equals("Nữ") || gender.equals("Khác"))) {
            errors.put("genderError", "Vui lòng chọn giới tính hợp lệ");
        }
        return errors;
    }

    // Validate phone number
    private Map<String, String> validatePhone(String phone) {
        Map<String, String> errors = new HashMap<>();
        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phoneError", "Số điện thoại không được để trống");
        } else if (!phone.matches("^0\\d{8,10}$")) {
            errors.put("phoneError", "Số điện thoại không hợp lệ, phải là dãy số bắt đầu bằng 0 và có từ 9 đến 11 chữ số");
        }
        return errors;
    }

    //Validate address
    private Map<String, String> validateAddress(String address) {
        Map<String, String> errors = new HashMap<>();
        if (address == null || address.trim().isEmpty()) {
            errors.put("addressError", "Địa chỉ không được để trống");
        }
        return errors;
    }

    // Validate birthday
    private Map<String, String> validateBirthday(String birthdayStr) {
        Map<String, String> errors = new HashMap<>();
        if (birthdayStr == null || birthdayStr.trim().isEmpty()) {
            errors.put("birthdayError", "Ngày sinh không được để trống");
        } else
             try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            Date birthday = sdf.parse(birthdayStr);
            Date now = new Date();

            Calendar cal = Calendar.getInstance();
            cal.setTime(now);
            cal.add(Calendar.YEAR, -16);
            if (birthday.after(cal.getTime())) {
                errors.put("birthdayError", "Tuổi phải lớn hơn hoặc bằng 16");
            }
        } catch (ParseException e) {
            errors.put("birthdayError", "Ngày sinh không hợp lệ");
        }
        return errors;
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        } else if (action.equals("editProfile")) {

            String fullName = request.getParameter("fullName");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String birthdayStr = request.getParameter("birthday");

            Map<String, String> errors = new HashMap<>();

            errors.putAll(validateFullName(fullName));
            errors.putAll(validateGender(gender));
            errors.putAll(validatePhone(phone));
            errors.putAll(validateAddress(address));
            errors.putAll(validateBirthday(birthdayStr));

            java.sql.Date birthday = null;
            if (!errors.containsKey("birthdayError")) {
                try {
                    java.util.Date parsedDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthdayStr);
                    birthday = new java.sql.Date(parsedDate.getTime());
                } catch (ParseException e) {
                    errors.put("birthdayError", "Ngày sinh không hợp lệ");
                }
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);

                User tempUser = new User();
                tempUser.setFullName(fullName);
                tempUser.setGender(gender);
                tempUser.setPhone(phone);
                tempUser.setAddress(address);
                tempUser.setBirthday(birthday);

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
        } else if (action.equals("registerBusiness")) {
            String companyName = request.getParameter("companyName");
            String headquarters = request.getParameter("headquarters");
            String businessType = request.getParameter("businessType");
            String customType = request.getParameter("customType");
            String repFullName = request.getParameter("repName");
            String repPosition = request.getParameter("repPosition");
            String repPhone = request.getParameter("repPhone");
            String repEmail = request.getParameter("repEmail");

            Map<String, String> errors = new HashMap<>();
            // Validate
            if (companyName == null || companyName.trim().isEmpty()) {
                errors.put("companyNameError", "Tên doanh nghiệp không được để trống");
            }
            if (headquarters == null || headquarters.trim().isEmpty()) {
                errors.put("headquartersError", "Địa chỉ trụ sở chính không được để trống");
            }
            if (businessType == null || businessType.trim().isEmpty()) {
                errors.put("businessTypeError", "Bạn phải chọn loại hình doanh nghiệp");
            }
            if ("Khác".equals(businessType) && (customType == null || customType.trim().isEmpty())) {
                errors.put("customTypeError", "Hãy nhập loại hình doanh nghiệp khác");
            }
            if (repFullName == null || repFullName.trim().isEmpty()) {
                errors.put("repFullNameError", "Tên người đại diện không được để trống");
            }
            if (repPosition == null || repPosition.trim().isEmpty()) {
                errors.put("repPositionError", "Chức vụ không được để trống");
            }
            if (repPhone == null || !repPhone.matches("^0\\d{8,10}$")) {
                errors.put("repPhoneError", "Số điện thoại người đại diện không hợp lệ");
            }
            if (repEmail == null || !repEmail.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                errors.put("repEmailError", "Email người đại diện không hợp lệ");
            }

            // Xử lý file upload (legalDoc)
            jakarta.servlet.http.Part legalDocPart = request.getPart("legalDoc");
            String fileName = (legalDocPart != null) ? legalDocPart.getSubmittedFileName() : null;
            String uploadDirPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            String filePath = null;
            if (fileName != null && !fileName.isEmpty()) {
                filePath = "uploads" + File.separator + fileName;
                legalDocPart.write(uploadDirPath + File.separator + fileName);
            }

            // Gọi DAO để insert (bạn cần tạo class BusinessRegistration và method insertBusinessRegistration tương ứng)
            try {
                BusinessRegistration reg = new BusinessRegistration();
                reg.setUserId(user.getId());
                reg.setCompanyName(companyName);
                reg.setHeadOffice(headquarters);
                reg.setBusinessType(businessType);
                reg.setCustomType(customType);
                reg.setRepFullName(repFullName);
                reg.setRepPosition(repPosition);
                reg.setRepPhone(repPhone);
                reg.setRepEmail(repEmail);
                reg.setLegalDocument(fileName);
                reg.setFileName(fileName);
                reg.setFilePath(filePath);
                reg.setStatus("pending"); // default
                // Insert
                UserDAO dao = new UserDAO();
                int regId = dao.BusinessRegistration(reg);
                // Thành công
                response.sendRedirect("profile.jsp?msg=business_success");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi khi đăng ký doanh nghiệp, vui lòng thử lại.");
                request.setAttribute("errors", errors);
                
                request.setAttribute("companyName", companyName);
                request.setAttribute("headquarters", headquarters);
                request.setAttribute("businessType", businessType);
                request.setAttribute("customType", customType);
                request.setAttribute("repFullName", repFullName);
                request.setAttribute("repPosition", repPosition);
                request.setAttribute("repPhone", repPhone);
                request.setAttribute("repEmail", repEmail);

                request.getRequestDispatcher("register-business.jsp").forward(request, response);
            }
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
