package dal;

import domain.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDelDAO {

    private Connection conn;

    public UserDelDAO() throws Exception {
        conn = new DBContext().getConnection();
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = mapResultSetToUser(rs);
                list.add(u);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi truy vấn danh sách người dùng", e);
        }

        return list;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("id"),
                rs.getString("email"),
                rs.getString("role"),
                rs.getString("phone"),
                rs.getString("address"),
                rs.getDate("birthday"),
                rs.getTimestamp("created_at"),
                rs.getString("fullname"),
                rs.getString("gender"),
                rs.getBoolean("locked"),
                rs.getTimestamp("last_login")
        );
    }

    public List<User> searchUsersByName(String keyword) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE fullname LIKE ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = mapResultSetToUser(rs);
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi tìm kiếm người dùng", e);
        }

        return list;
    }

}
