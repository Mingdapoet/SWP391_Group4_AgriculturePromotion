package dal;

import domain.Appeal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

public class AppealDAO {

    public boolean insertAppeal(Appeal appeal) {
        String sql = " INSERT INTO appeals (fullname, email, reason) VALUES (?, ?, ?) ";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appeal.getFullname());
            ps.setString(2, appeal.getEmail());
            ps.setString(3, appeal.getReason());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả kháng cáo từ cơ sở dữ liệu
    public List<Appeal> getAllAppeals() {
        List<Appeal> appeals = new ArrayList<>();
        String sql = "SELECT * FROM appeals";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Appeal appeal = new Appeal();
                appeal.setId(rs.getInt("id"));
                appeal.setFullname(rs.getString("fullname"));
                appeal.setEmail(rs.getString("email"));
                appeal.setReason(rs.getString("reason"));
                appeal.setStatus(rs.getString("status"));

                appeals.add(appeal);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appeals;
    }

    // Giải quyết kháng cáo bằng email
    public boolean resolveAppealByEmail(String email) {
        String sql = "UPDATE appeals SET status = 'resolved' WHERE email = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            int row = ps.executeUpdate();

            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
