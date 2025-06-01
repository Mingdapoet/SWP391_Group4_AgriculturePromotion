package dal;

import domain.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn;

    public UserDAO() throws Exception {
        conn = new DBContext().getConnection(); // Assuming DBContext provides the connection
    }

    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getDate("birthday"),
                        rs.getTimestamp("created_at"),
                        rs.getString("fullname"), // Added
                        rs.getString("gender"),
                        rs.getString("password")// Added
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(String email, String password, String role, String phone, String address, Date birthday, String fullname, String gender) {
        String sql = "INSERT INTO users (email, password, role, phone, address, birthday, fullname, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setDate(6, birthday);
            ps.setString(7, fullname); // Added
            ps.setString(8, gender);   // Added
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getDate("birthday"),
                        rs.getTimestamp("created_at"),
                        rs.getString("fullName"),
                        rs.getString("gender"),
                        rs.getString("password") // Sử dụng constructor mới

                );
                System.out.println("UserDAO.getUserByEmail - Email: " + email + ", Password: " + user.getPassword());
                return user;
            }
        } catch (SQLException e) {
            System.err.println("SQLException trong getUserByEmail: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUserProfile(User user) {
        String sql = "UPDATE users SET phone = ?, address = ?, birthday = ?, fullname = ?, gender = ?, avatar=? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getPhone());
            ps.setString(2, user.getAddress());
            ps.setDate(3, user.getBirthday());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getGender());
            ps.setString(6, user.getAvatar());
            ps.setInt(7, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword); // Lưu plaintext
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            System.out.println("UserDAO.updatePassword - Email: " + email + ", Rows updated: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException trong updatePassword: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveResetRequest(String email, String otp) {
        if (conn == null) {
            System.err.println("UserDAO.saveResetRequest: Database connection is null at " + new Timestamp(System.currentTimeMillis()));
            return false;
        }

        // Xóa các OTP đã hết hạn của email này
        String deleteExpiredSql = "DELETE FROM password_resets WHERE email = ? AND expires_at < GETDATE()";
        try (PreparedStatement deleteStmt = conn.prepareStatement(deleteExpiredSql)) {
            deleteStmt.setString(1, email);
            int rowsDeleted = deleteStmt.executeUpdate();
            System.out.println("UserDAO.saveResetRequest - Deleted expired OTPs for email: " + email + ", Rows deleted: " + rowsDeleted);
        } catch (SQLException e) {
            System.err.println("UserDAO.saveResetRequest: Error deleting expired OTPs: " + e.getMessage());
            e.printStackTrace();
        }

        // Chèn OTP mới
        String insertSql = "INSERT INTO password_resets (email, otp, expires_at) VALUES (?, ?, DATEADD(MINUTE, 10, GETDATE()))";
        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
            insertStmt.setString(1, email);
            insertStmt.setString(2, otp);
            int rowsInserted = insertStmt.executeUpdate();
            System.out.println("UserDAO.saveResetRequest - Email: " + email + ", OTP: " + otp + ", Rows inserted: " + rowsInserted + " at " + new Timestamp(System.currentTimeMillis()));
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.err.println("UserDAO.saveResetRequest: SQLException during insert: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean verifyOtp(String email, String otp) {
        if (conn == null) {
            System.err.println("UserDAO.verifyOtp: Database connection is null at " + new Timestamp(System.currentTimeMillis()));
            return false;
        }

        String sql = "SELECT expires_at FROM password_resets WHERE email = ? AND otp = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, otp);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Timestamp expiresAt = rs.getTimestamp("expires_at");
                Timestamp now = new Timestamp(System.currentTimeMillis());
                boolean isValid = now.before(expiresAt);
                System.out.println("UserDAO.verifyOtp - Email: " + email + ", OTP: " + otp + ", Valid: " + isValid + ", Expires at: " + expiresAt + " at " + now);
                return isValid;
            } else {
                System.out.println("UserDAO.verifyOtp - No OTP found for email: " + email + " at " + new Timestamp(System.currentTimeMillis()));
                return false;
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.verifyOtp: SQLException: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean verifyPassword(String email, String password) throws SQLException {
        String sql = "SELECT password FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                boolean isMatch = password.equals(storedPassword);
                System.out.println("UserDAO.verifyPassword - Email: " + email + ", Password match: " + isMatch);
                return isMatch;
            }
        }
        System.err.println("UserDAO.verifyPassword: No user found for email: " + email);
        return false;
    }
    public void deleteResetRequest(String email, String otp) {
        String sql = "DELETE FROM password_resets WHERE email = ? AND otp = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("SQLException trong deleteResetRequest: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int BusinessRegistration(BusinessRegistration reg) throws SQLException {
        String sql = "INSERT INTO business_registration (user_id, company_name, tax_code, head_office, business_type, custom_type, company_email, company_phone, rep_full_name, rep_position, rep_phone, rep_email, legal_document, file_name, file_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, reg.getUserId());
            ps.setString(2, reg.getCompanyName());
            ps.setString(3, reg.getTaxCode());
            ps.setString(4, reg.getHeadOffice());
            ps.setString(5, reg.getBusinessType());
            ps.setString(6, reg.getCustomType());
            ps.setString(7, reg.getCompanyEmail());
            ps.setString(8, reg.getCompanyPhone());
            ps.setString(9, reg.getRepFullName());
            ps.setString(10, reg.getRepPosition());
            ps.setString(11, reg.getRepPhone());
            ps.setString(12, reg.getRepEmail());
            ps.setString(13, reg.getLegalDocument());
            ps.setString(14, reg.getFileName());
            ps.setString(15, reg.getFilePath());
            ps.setString(16, reg.getStatus());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }
    // Kiểm tra taxCode đã tồn tại chưa

    public boolean isTaxCodeExists(String taxCode) {
        String sql = "SELECT COUNT(*) FROM business_registration WHERE tax_code = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, taxCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Kiểm tra companyName đã tồn tại chưa
    public boolean isCompanyNameExists(String companyName) {
        String sql = "SELECT COUNT(*) FROM business_registration WHERE company_name = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, companyName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Kiểm tra companyEmail đã tồn tại chưa
    public boolean isCompanyEmailExists(String companyEmail) {
        String sql = "SELECT COUNT(*) FROM business_registration WHERE company_email = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, companyEmail);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Kiểm tra companyPhone đã tồn tại chưa
    public boolean isCompanyPhoneExists(String companyPhone) {
        String sql = "SELECT COUNT(*) FROM business_registration WHERE company_phone = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, companyPhone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BusinessRegistration> getBusinessRegistrationsByUser(int userId) throws Exception {
        List<BusinessRegistration> list = new ArrayList<>();
        String sql = "SELECT * FROM business_registration WHERE user_id = ? ORDER BY submitted_at DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusinessRegistration reg = new BusinessRegistration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setCompanyName(rs.getString("company_name"));
                    reg.setTaxCode(rs.getString("tax_code"));
                    reg.setCompanyEmail(rs.getString("company_email"));
                    reg.setCompanyPhone(rs.getString("company_phone"));
                    reg.setHeadOffice(rs.getString("head_office"));
                    reg.setBusinessType(rs.getString("business_type"));
                    reg.setCustomType(rs.getString("custom_type"));
                    reg.setRepFullName(rs.getString("rep_full_name"));
                    reg.setRepPosition(rs.getString("rep_position"));
                    reg.setRepPhone(rs.getString("rep_phone"));
                    reg.setRepEmail(rs.getString("rep_email"));
                    reg.setLegalDocument(rs.getString("legal_document"));
                    reg.setFileName(rs.getString("file_name"));
                    reg.setFilePath(rs.getString("file_path"));
                    reg.setStatus(rs.getString("status"));
                    reg.setRejectionReason(rs.getString("rejection_reason"));
                    reg.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    list.add(reg);
                }
            }
        }
        return list;
    }

    public BusinessRegistration getBusinessRegistrationById(int id) throws Exception {
        String sql = "SELECT * FROM business_registration WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BusinessRegistration reg = new BusinessRegistration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setCompanyName(rs.getString("company_name"));
                    reg.setTaxCode(rs.getString("tax_code"));
                    reg.setCompanyEmail(rs.getString("company_email"));
                    reg.setCompanyPhone(rs.getString("company_phone"));
                    reg.setHeadOffice(rs.getString("head_office"));
                    reg.setBusinessType(rs.getString("business_type"));
                    reg.setCustomType(rs.getString("custom_type"));
                    reg.setRepFullName(rs.getString("rep_full_name"));
                    reg.setRepPosition(rs.getString("rep_position"));
                    reg.setRepPhone(rs.getString("rep_phone"));
                    reg.setRepEmail(rs.getString("rep_email"));
                    reg.setLegalDocument(rs.getString("legal_document"));
                    reg.setFileName(rs.getString("file_name"));
                    reg.setFilePath(rs.getString("file_path"));
                    reg.setStatus(rs.getString("status"));
                    reg.setRejectionReason(rs.getString("rejection_reason"));
                    reg.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    return reg;
                }
            }
        }
        return null;
    }
     public List<BusinessRegistration> getAllBusinessRegistrations() throws Exception {
        List<BusinessRegistration> list = new ArrayList<>();
        String sql = "SELECT * FROM business_registration ORDER BY submitted_at DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusinessRegistration reg = new BusinessRegistration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setCompanyName(rs.getString("company_name"));
                    reg.setTaxCode(rs.getString("tax_code"));
                    reg.setCompanyEmail(rs.getString("company_email"));
                    reg.setCompanyPhone(rs.getString("company_phone"));
                    reg.setHeadOffice(rs.getString("head_office"));
                    reg.setBusinessType(rs.getString("business_type"));
                    reg.setCustomType(rs.getString("custom_type"));
                    reg.setRepFullName(rs.getString("rep_full_name"));
                    reg.setRepPosition(rs.getString("rep_position"));
                    reg.setRepPhone(rs.getString("rep_phone"));
                    reg.setRepEmail(rs.getString("rep_email"));
                    reg.setLegalDocument(rs.getString("legal_document"));
                    reg.setFileName(rs.getString("file_name"));
                    reg.setFilePath(rs.getString("file_path"));
                    reg.setStatus(rs.getString("status"));
                    reg.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    list.add(reg);
                }
            }
        }
        return list;
    }

    public void updateStatus(int id, String status) throws Exception {
        String sql = "UPDATE business_registration SET status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
// Cập nhật trạng thái + lý do từ chối

    public void updateStatusWithReason(int id, String status, String reason) throws Exception {
        String sql = "UPDATE business_registration SET status = ?, rejection_reason = ? WHERE id = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, reason);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

// Đổi role user thành business (dựa trên user_id trong business_registration)
    public void upgradeUserRoleToBusiness(int registrationId) throws Exception {
        String sql = """
        UPDATE users
        SET role = 'business'
        WHERE id = (
            SELECT user_id FROM business_registration WHERE id = ?
        )
    """;
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            ps.executeUpdate();
        }
    }

// Hàm duyệt đơn đăng ký doanh nghiệp
    public void approveBusinessRegistration(int id) throws SQLException {
        String updateRegistrationSql = "UPDATE business_registration SET status = 'approved' WHERE id = ?";
        String updateUserRoleSql = "UPDATE users SET role = 'business' WHERE id = (SELECT user_id FROM business_registration WHERE id = ?)";

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(updateRegistrationSql); PreparedStatement ps2 = conn.prepareStatement(updateUserRoleSql)) {

                ps1.setInt(1, id);
                ps1.executeUpdate();

                ps2.setInt(1, id);
                ps2.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // Hàm từ chối đơn đăng ký doanh nghiệp kèm lý do
    public void rejectBusinessRegistration(int id, String reason) throws SQLException {
        String sql = "UPDATE business_registration SET status = 'rejected', rejection_reason = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reason);
            ps.setInt(2, id);

            ps.executeUpdate();
        }
    }

    public List<BusinessRegistration> getBusinessRegistrationsByStatus(String status) throws Exception {
        List<BusinessRegistration> list = new ArrayList<>();
        String sql = "SELECT * FROM business_registration WHERE status = ? ORDER BY submitted_at DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusinessRegistration reg = new BusinessRegistration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setCompanyName(rs.getString("company_name"));
                    reg.setTaxCode(rs.getString("tax_code"));
                    reg.setCompanyEmail(rs.getString("company_email"));
                    reg.setCompanyPhone(rs.getString("company_phone"));
                    reg.setHeadOffice(rs.getString("head_office"));
                    reg.setBusinessType(rs.getString("business_type"));
                    reg.setCustomType(rs.getString("custom_type"));
                    reg.setRepFullName(rs.getString("rep_full_name"));
                    reg.setRepPosition(rs.getString("rep_position"));
                    reg.setRepPhone(rs.getString("rep_phone"));
                    reg.setRepEmail(rs.getString("rep_email"));
                    reg.setLegalDocument(rs.getString("legal_document"));
                    reg.setFileName(rs.getString("file_name"));
                    reg.setFilePath(rs.getString("file_path"));
                    reg.setStatus(rs.getString("status"));
                    reg.setRejectReason(rs.getString("rejection_reason")); // <- BỔ SUNG DÒNG NÀY
                    reg.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    
                    list.add(reg);
                }
            }
        }
        return list;
    }

    public boolean updateUserLockStatus(int userId, boolean locked) {
        String sql = "UPDATE users SET locked = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, locked);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0; // Nếu có bản ghi được cập nhật thì trả về true

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setLocked(rs.getBoolean("locked")); // lấy trạng thái khóa
                // lấy các trường khác...
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
