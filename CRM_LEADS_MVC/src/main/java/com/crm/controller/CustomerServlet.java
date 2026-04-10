package com.crm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.crm.dao.CustomerDAO;

@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CustomerDAO dao;

    @Override
    public void init() {
        dao = new CustomerDAO();
        System.out.println("✅ CustomerServlet loaded");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        try {

            // 👉 mặc định list
            if (action == null || action.trim().isEmpty()) {
                action = "list";
            }

            switch (action) {

                case "convert":
                    handleConvert(request, response);
                    break;

                case "update":
                    handleUpdate(request, response);
                    break;

                default:
                    request.setAttribute("list", dao.getAll());
                    request.getRequestDispatcher("/customer-list.jsp")
                           .forward(request, response);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3 style='color:red'>Lỗi: " + e.getMessage() + "</h3>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        doGet(request, response);
    }

    // ===============================
    // 🔥 CONVERT LEAD → CUSTOMER
    // ===============================
    private void handleConvert(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            throw new Exception("Thiếu ID Lead");
        }

        int id = Integer.parseInt(idStr);

        dao.convertFromLead(id);

        System.out.println("✅ Convert Lead ID = " + id);

        response.sendRedirect("customers");
    }

    // ===============================
    // 🔥 UPDATE CUSTOMER
    // ===============================
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String idStr = request.getParameter("id");
        String type = request.getParameter("type");
        String tier = request.getParameter("tier");

        // validate
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new Exception("Thiếu ID Customer");
        }

        if (type == null || tier == null) {
            throw new Exception("Thiếu dữ liệu type/tier");
        }

        int id = Integer.parseInt(idStr);

        // 👉 gọi DAO
        dao.updateCustomer(id, type, tier);

        System.out.println("✅ Update Customer: ID=" + id +
                " | Type=" + type +
                " | Tier=" + tier);

        response.sendRedirect("customers");
    }
}