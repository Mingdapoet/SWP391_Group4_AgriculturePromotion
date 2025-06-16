package dal;

import domain.Product;

import java.util.*;
import java.sql.*;
 
public class ProductDAO {

    public List<Product> getProductsByEventId(int eventId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE event_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setImageUrl(rs.getString("image_url"));
                p.setEventId(rs.getInt("event_id"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                p.setOrigin(rs.getString("origin"));
                p.setVariety(rs.getString("variety"));
                p.setFarmingMethod(rs.getString("farming_method"));
                p.setHarvestTime(rs.getString("harvest_time"));
                p.setStorage(rs.getString("storage"));
                p.setHealthBenefits(rs.getString("health_benefits"));
                p.setUsageTips(rs.getString("usage_tips"));
                
                products.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }
    

    public List<Product> getAllProducts(){
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setImageUrl(rs.getString("image_url"));
                p.setEventId(rs.getInt("event_id"));
                
                p.setOrigin(rs.getString("origin"));
                p.setVariety(rs.getString("variety"));
                p.setFarmingMethod(rs.getString("farming_method"));
                p.setHarvestTime(rs.getString("harvest_time"));
                p.setStorage(rs.getString("storage"));
                p.setHealthBenefits(rs.getString("health_benefits"));
                p.setUsageTips(rs.getString("usage_tips"));
                
                products.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return products;
    }
    

    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setImageUrl(rs.getString("image_url"));
                product.setEventId(rs.getInt("event_id"));
                product.setCreatedAt(rs.getTimestamp("created_at"));
                product.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                product.setOrigin(rs.getString("origin"));
                product.setVariety(rs.getString("variety"));
                product.setFarmingMethod(rs.getString("farming_method"));
                product.setHarvestTime(rs.getString("harvest_time"));
                product.setStorage(rs.getString("storage"));
                product.setHealthBenefits(rs.getString("health_benefits"));
                product.setUsageTips(rs.getString("usage_tips"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }
}
