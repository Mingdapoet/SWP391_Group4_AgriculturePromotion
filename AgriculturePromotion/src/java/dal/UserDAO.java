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
                    rs.getString("gender")    // Added
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
}