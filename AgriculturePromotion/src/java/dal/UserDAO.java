package dal;

import domain.*;
import java.sql.*;

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
        String sql = "UPDATE users SET phone = ?, address = ?, birthday = ?, fullname = ?, gender = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getPhone());
            ps.setString(2, user.getAddress());
            ps.setDate(3, user.getBirthday());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getGender());
            ps.setInt(6, user.getId());
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
    String sql = "INSERT INTO business_registration (user_id, company_name, head_office, business_type, custom_type, rep_full_name, rep_position, rep_phone, rep_email, legal_document, file_name, file_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setInt(1, reg.getUserId());
        ps.setString(2, reg.getCompanyName());
        ps.setString(3, reg.getHeadOffice());
        ps.setString(4, reg.getBusinessType());
        ps.setString(5, reg.getCustomType());
        ps.setString(6, reg.getRepFullName());
        ps.setString(7, reg.getRepPosition());
        ps.setString(8, reg.getRepPhone());
        ps.setString(9, reg.getRepEmail());
        ps.setString(10, reg.getLegalDocument());
        ps.setString(11, reg.getFileName());
        ps.setString(12, reg.getFilePath());
        ps.setString(13, reg.getStatus());
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

}
