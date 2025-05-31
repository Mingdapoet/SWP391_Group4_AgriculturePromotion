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
                    reg.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    return reg;
                }
            }
        }
        return null;
    }

}
