package dal;

import domain.User;
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
        String sql = "INSERT INTO password_resets (email, otp, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            int rows = ps.executeUpdate();
            System.out.println("UserDAO.saveResetRequest - Email: " + email + ", OTP: " + otp + ", Rows: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException trong saveResetRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean verifyOtp(String email, String otp) {
        String sql = "SELECT COUNT(*) FROM password_resets WHERE email = ? AND otp = ? AND expires_at > NOW()";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Xóa bản ghi sau khi xác minh thành công
                deleteResetRequest(email, otp);
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("SQLException trong verifyOtp: " + e.getMessage());
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
}
