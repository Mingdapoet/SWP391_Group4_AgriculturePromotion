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
import jakarta.servlet.http.Part;
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
        String action = request.getParameter("action");
        if ("listBusiness".equals(action)) {
            // Xem danh sách đơn
            try {
                UserDAO userDAO = new UserDAO();
                List<BusinessRegistration> registrations = userDAO.getBusinessRegistrationsByUser(user.getId());
                request.setAttribute("registrations", registrations);
                request.getRequestDispatcher("register-business-list.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(500, "Lỗi hệ thống khi lấy danh sách đơn");
            }
            return;
        } else if ("detailBusiness".equals(action)) {
            // Xem chi tiết đơn
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                UserDAO userDAO = new UserDAO();
                BusinessRegistration reg = userDAO.getBusinessRegistrationById(id);

                // Đảm bảo chỉ user chủ đơn mới được xem
                if (reg == null || reg.getUserId() != user.getId()) {
                    response.sendError(403, "Bạn không có quyền xem đơn này.");
                    return;
                }
                request.setAttribute("registration", reg);
                request.getRequestDispatcher("register-business-detail.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(500, "Lỗi hệ thống khi xem chi tiết đơn.");
            }
            return;
        }

        // Mặc định về profile
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
            String taxCode = request.getParameter("taxCode");
            String headquarters = request.getParameter("headquarters");
            String businessType = request.getParameter("businessType");
            String customType = request.getParameter("customType");
            String companyEmail = request.getParameter("companyEmail");
            String companyPhone = request.getParameter("companyPhone");
            String repFullName = request.getParameter("repFullName");
            String repPosition = request.getParameter("repPosition");
            String repPhone = request.getParameter("repPhone");
            String repEmail = request.getParameter("repEmail");

            Map<String, String> errors = new HashMap<>();
            // Validate
            if (companyName == null || companyName.trim().isEmpty()) {
                errors.put("companyNameError", "Tên doanh nghiệp không được để trống");
            } else if (companyName.trim().length() < 3) {
                errors.put("companyNameError", "Tên doanh nghiệp phải từ 3 ký tự trở lên");
            } else if (companyName.trim().length() > 255) {
                errors.put("companyNameError", "Tên doanh nghiệp quá dài (tối đa 255 ký tự)");
            } else if (!companyName.matches("^[\\p{L}\\d ._\\-]+$")) {
                errors.put("companyNameError", "Tên doanh nghiệp chứa ký tự không hợp lệ");
            }

            if (taxCode == null || taxCode.trim().isEmpty()) {
                errors.put("taxCodeError", "Mã số thuế không được để trống");
            } else if (!taxCode.matches("^\\d{3,}-?\\d{3,}-?\\d{3,}$") && !taxCode.matches("^[\\d\\-]{10,15}$")) {
                errors.put("taxCodeError", "Mã số thuế chỉ gồm 10-15 chữ số");
            }

            if (headquarters == null || headquarters.trim().isEmpty()) {
                errors.put("headquartersError", "Địa chỉ trụ sở chính không được để trống");
            } else if (headquarters.trim().length() > 255) {
                errors.put("headquartersError", "Địa chỉ trụ sở quá dài (tối đa 255 ký tự)");
            } else if (!headquarters.matches("^[\\p{L}\\d\\s,./\\-()']+$")) {
                errors.put("headquartersError", "Địa chỉ trụ sở chứa ký tự không hợp lệ");
            }

            if (businessType == null || businessType.trim().isEmpty()) {
                errors.put("businessTypeError", "Bạn phải chọn loại hình doanh nghiệp");
            }
            if ("Khác".equals(businessType)) {
                if (customType == null || customType.trim().isEmpty()) {
                    errors.put("customTypeError", "Vui lòng nhập loại hình doanh nghiệp khác");
                } else if (customType.length() > 50) {
                    errors.put("customTypeError", "Tên loại hình khác không quá 50 ký tự");
                }
            }

            if (companyEmail == null || companyEmail.trim().isEmpty()) {
                errors.put("companyEmailError", "Email doanh nghiệp không được để trống");
            } else if (!companyEmail.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
                errors.put("companyEmailError", "Email doanh nghiệp không hợp lệ");
            }

            if (companyPhone == null || companyPhone.trim().isEmpty()) {
                errors.put("companyPhoneError", "Số điện thoại doanh nghiệp không được để trống");
            } else if (!companyPhone.matches("^0\\d{9,10}$")) {
                errors.put("companyPhoneError", "Số điện thoại doanh nghiệp phải bắt đầu bằng 0 và có 10 hoặc 11 số");
            } else if (companyPhone.matches("^(0{10,11}|1{10,11})$")) {
                errors.put("companyPhoneError", "Số điện thoại không hợp lệ (toàn số giống nhau)");
            }

            if (repFullName == null || repFullName.trim().isEmpty()) {
                errors.put("repFullNameError", "Tên người đại diện không được để trống");
            } else if (!repFullName.matches("^[\\p{L}\\s.'’-]{3,100}$")) {
                errors.put("repFullNameError", "Tên người đại diện không hợp lệ");
            }
            if (repPosition == null || repPosition.trim().isEmpty()) {
                errors.put("repPositionError", "Chức vụ không được để trống");
            } else if (repPosition.length() < 3 || repPosition.length() > 50) {
                errors.put("repPositionError", "Chức vụ phải từ 3 đến 50 ký tự");
            } else if (!repPosition.matches("^[\\p{L}\\s.'’-]+$")) {
                errors.put("repPositionError", "Chức vụ chứa ký tự không hợp lệ");
            }
            if (repPhone == null || repPhone.trim().isEmpty()) {
                errors.put("repPhoneError", "Số điện thoại người đại diện không được để trống");
            } else if (!repPhone.matches("^0\\d{9,10}$")) {
                errors.put("repPhoneError", "Số điện thoại phải bắt đầu bằng 0 và có 10 hoặc 11 số");
            } else if (repPhone.matches("^(0{10,11}|1{10,11})$")) {
                errors.put("repPhoneError", "Số điện thoại không hợp lệ (toàn số giống nhau)");
            }
            if (repEmail == null || repEmail.trim().isEmpty()) {
                errors.put("repEmailError", "Email người đại diện không được để trống");
            } else if (!repEmail.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
                errors.put("repEmailError", "Email người đại diện không hợp lệ");
            }

            if (request.getParameter("commitment") == null) {
                errors.put("commitmentError", "Bạn phải đồng ý cam kết");
            }

            try {
                UserDAO dao = new UserDAO();

                // Check unique
                if (!errors.containsKey("taxCodeError") && dao.isTaxCodeExists(taxCode)) {
                    errors.put("taxCodeError", "Mã số thuế này đã tồn tại trên hệ thống");
                }
                if (!errors.containsKey("companyNameError") && dao.isCompanyNameExists(companyName)) {
                    errors.put("companyNameError", "Tên doanh nghiệp này đã tồn tại trên hệ thống");
                }
                if (!errors.containsKey("companyEmailError") && dao.isCompanyEmailExists(companyEmail)) {
                    errors.put("companyEmailError", "Email doanh nghiệp này đã tồn tại trên hệ thống");
                }
                if (!errors.containsKey("companyPhoneError") && dao.isCompanyPhoneExists(companyPhone)) {
                    errors.put("companyPhoneError", "Số điện thoại doanh nghiệp này đã tồn tại trên hệ thống");
                }

                // Xử lý upload file
                Part legalDocPart = request.getPart("legalDoc");
                String fileName = (legalDocPart != null) ? legalDocPart.getSubmittedFileName() : null;
                if (fileName == null || fileName.trim().isEmpty()) {
                    errors.put("legalDocError", "Bạn phải chọn file giấy tờ hợp lệ");
                } else {
                    // Check size file (giới hạn 5MB)
                    long size = legalDocPart.getSize();
                    if (size > 5 * 1024 * 1024) {
                        errors.put("legalDocError", "File không được lớn hơn 5MB");
                    }
                }
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

                // Nếu có lỗi, trả lại form
                if (!errors.isEmpty()) {
                    request.setAttribute("errors", errors);
                    request.setAttribute("companyName", companyName);
                    request.setAttribute("taxCode", taxCode);
                    request.setAttribute("headquarters", headquarters);
                    request.setAttribute("businessType", businessType);
                    request.setAttribute("customType", customType);
                    request.setAttribute("companyEmail", companyEmail);
                    request.setAttribute("companyPhone", companyPhone);
                    request.setAttribute("repFullName", repFullName);
                    request.setAttribute("repPosition", repPosition);
                    request.setAttribute("repPhone", repPhone);
                    request.setAttribute("repEmail", repEmail);
                    request.getRequestDispatcher("register-business.jsp").forward(request, response);
                    return;
                }

                // Nếu không lỗi, lưu vào DB
                BusinessRegistration reg = new BusinessRegistration();
                reg.setUserId(user.getId());
                reg.setCompanyName(companyName);
                reg.setTaxCode(taxCode);
                reg.setHeadOffice(headquarters);
                reg.setBusinessType(businessType);
                reg.setCustomType(customType);
                reg.setCompanyEmail(companyEmail);
                reg.setCompanyPhone(companyPhone);
                reg.setRepFullName(repFullName);
                reg.setRepPosition(repPosition);
                reg.setRepPhone(repPhone);
                reg.setRepEmail(repEmail);
                reg.setLegalDocument(fileName);
                reg.setFileName(fileName);
                reg.setFilePath(filePath);
                reg.setStatus("pending");

                dao.BusinessRegistration(reg);
                response.sendRedirect("profile.jsp?msg=business_success");
                return;
            } catch (Exception e) {
                String msg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
                if (msg.contains("tax_code")) {
                    errors.put("taxCodeError", "Mã số thuế đã tồn tại (SQL)");
                } else if (msg.contains("company_name")) {
                    errors.put("companyNameError", "Tên doanh nghiệp đã tồn tại (SQL)");
                } else if (msg.contains("company_email")) {
                    errors.put("companyEmailError", "Email doanh nghiệp đã tồn tại (SQL)");
                } else if (msg.contains("company_phone")) {
                    errors.put("companyPhoneError", "Số điện thoại doanh nghiệp đã tồn tại (SQL)");
                } else {
                    errors.put("generalError", "Có lỗi khi đăng ký doanh nghiệp, vui lòng thử lại.");
                }
                request.setAttribute("errors", errors);
                request.setAttribute("companyName", companyName);
                request.setAttribute("taxCode", taxCode);
                request.setAttribute("headquarters", headquarters);
                request.setAttribute("businessType", businessType);
                request.setAttribute("customType", customType);
                request.setAttribute("companyEmail", companyEmail);
                request.setAttribute("companyPhone", companyPhone);
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
