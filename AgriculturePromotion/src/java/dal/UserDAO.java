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
                    rs.getString("gender")
//                    rs.getString("password") // Sử dụng constructor mới
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
