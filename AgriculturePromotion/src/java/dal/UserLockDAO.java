package dal;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;

public class UserLockDAO {
    private Connection conn;

    public UserLockDAO() throws SQLException {
        conn = new DBContext().getConnection();
    }

    // Hàm tự động khóa user inactive hơn 30 ngày
    public int lockUsersInactive30Days() {
        String sql = "UPDATE users SET locked = 1 WHERE locked = 0 AND DATEDIFF(day, last_login, GETDATE()) > 30";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate(); // trả về số user bị khóa
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Hàm mở khóa user (do admin)
    public boolean unlockUser(int userId) {
        String sql = "UPDATE users SET locked = 0 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm kiểm tra user có bị khóa không
    public boolean isUserLocked(int userId) {
        String sql = "SELECT locked FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("locked");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
