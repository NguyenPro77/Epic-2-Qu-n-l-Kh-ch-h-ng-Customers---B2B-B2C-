package com.crm.dao;

import java.sql.*;
import java.util.*;
import com.crm.model.Customer;

public class CustomerDAO {

    private String jdbcURL = "jdbc:mysql://localhost:3306/crm_qlbanhang";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    private Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // =========================================
    // 🔥 LẤY DANH SÁCH CUSTOMER
    // =========================================
    public List<Customer> getAll() {
        List<Customer> list = new ArrayList<>();

        try {
            Connection conn = getConnection();

            String sql = "SELECT c.*, t.tier_name " +
                         "FROM customers c " +
                         "LEFT JOIN customer_tiers t ON c.tier_id = t.id " +
                         "WHERE c.is_deleted = 0";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Customer c = new Customer(
                        rs.getInt("id"),
                        rs.getString("customer_code"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("customer_type"),
                        rs.getString("tier_name")
                );
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================================
    // 🔥 CONVERT LEAD → CUSTOMER
    // =========================================
    public void convertFromLead(int leadId) throws SQLException {

        Connection conn = getConnection();

        // 👉 CHECK TRÙNG PHONE
        String checkSql = "SELECT phone FROM leads WHERE id = ?";
        PreparedStatement checkPs = conn.prepareStatement(checkSql);
        checkPs.setInt(1, leadId);
        ResultSet rs = checkPs.executeQuery();

        if (rs.next()) {
            String phone = rs.getString("phone");

            String checkCustomer = "SELECT id FROM customers WHERE phone = ?";
            PreparedStatement psCheckCustomer = conn.prepareStatement(checkCustomer);
            psCheckCustomer.setString(1, phone);
            ResultSet rs2 = psCheckCustomer.executeQuery();

            if (rs2.next()) {
                System.out.println("⚠️ Customer đã tồn tại");
                return;
            }
        }

        // 👉 INSERT
        String sql = "INSERT INTO customers " +
                "(customer_code, name, phone, email, customer_type, tier_id, is_deleted) " +
                "SELECT CONCAT('KH', id), contact_name, phone, email, customer_type, 1, 0 " +
                "FROM leads WHERE id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, leadId);
        ps.executeUpdate();

        // 👉 UPDATE LEAD
        String updateLead = "UPDATE leads SET status = 'Converted' WHERE id = ?";
        PreparedStatement psUpdate = conn.prepareStatement(updateLead);
        psUpdate.setInt(1, leadId);
        psUpdate.executeUpdate();

        System.out.println("✅ Convert thành công");
    }

    // =========================================
    // 🔥 UPDATE CUSTOMER (QUAN TRỌNG NHẤT)
    // =========================================
    public void updateCustomer(int id, String type, String tier) throws SQLException {

        Connection conn = getConnection();

        String sql = "UPDATE customers SET customer_type=?, " +
                     "tier_id = (SELECT id FROM customer_tiers WHERE tier_name=?) " +
                     "WHERE id=?";

        PreparedStatement ps = conn.prepareStatement(sql);

        ps.setString(1, type);
        ps.setString(2, tier);
        ps.setInt(3, id);

        ps.executeUpdate();

        System.out.println("✅ Update Customer thành công ID = " + id);
    }
}