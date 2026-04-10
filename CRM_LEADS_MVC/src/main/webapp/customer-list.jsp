<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.*" %>

<%
    // LOGIC NẠP DỮ LIỆU GIẢ (Giữ nguyên để bạn có nội dung hiển thị)
    List listAttr = (List) request.getAttribute("list");
    if (listAttr == null || listAttr.isEmpty()) {
        List<Map<String, Object>> mockList = new ArrayList<>();
        Object[][] dummyData = {
            {1, "KH001", "B2B", "Công ty Cổ phần Công nghệ AI", "AI Tech", "0283944556", "contact@aitech.vn", "0102030405", "", "123 Đường ABC, Quận 1, TP.HCM", "Kim Cương"},
            {2, "KH002", "B2C", "Nguyễn Minh Tuấn", "Tuấn NM", "0901122334", "tuan.nm@gmail.com", "", "079090001234", "456 Đường XYZ, Đà Nẵng", "Vàng"},
            {3, "KH003", "B2B", "Tập đoàn Viễn thông G-Tech", "G-Tech", "0243111222", "info@gtech.com.vn", "0304050607", "", "Số 1 Liễu Giai, Hà Nội", "Bạc"},
            {4, "KH004", "B2C", "Trần Thị Lan", "Lan TT", "0988777666", "lan.tran@gmail.com", "", "048095001234", "789 Phố Huế, Hai Bà Trưng, Hà Nội", "Vàng"},
            {5, "KH005", "B2B", "Logistics Toàn Cầu", "Global Log", "0283123456", "admin@globallog.com", "0908070605", "", "KCN Sóng Thần, Bình Dương", "Bạc"}
        };

        for (Object[] row : dummyData) {
            Map<String, Object> c = new HashMap<>();
            c.put("id", row[0]);
            c.put("customer_code", row[1]);
            c.put("customer_type", row[2]);
            c.put("name", row[3]);
            c.put("short_name", row[4]);
            c.put("phone", row[5]);
            c.put("email", row[6]);
            c.put("tax_code", row[7]);
            c.put("identity_number", row[8]);
            c.put("company_address", row[9]);
            c.put("tier_name", row.length > 10 ? row[10] : "Bạc");
            mockList.add(c);
        }
        request.setAttribute("list", mockList);
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hệ thống Quản lý Khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; font-family: 'Inter', sans-serif; }
        .page-header { background: white; padding: 20px; border-radius: 0 0 15px 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .main-card { background: white; border-radius: 12px; border: none; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .table-responsive { overflow: visible !important; }
        .table thead th { background-color: #f8f9fa; color: #64748b; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; border: none; padding: 15px; }
        .badge-code { background: #e0e7ff; color: #4361ee; font-weight: 600; padding: 5px 10px; border-radius: 6px; }
        .btn-save-fixed { position: fixed; bottom: 30px; right: 30px; padding: 12px 25px; border-radius: 50px; font-weight: 600; box-shadow: 0 10px 20px rgba(25, 135, 84, 0.3); z-index: 1000; }
        .form-select-sm { border: none; background-color: #f8f9fa; cursor: pointer; border-radius: 8px; font-size: 0.85rem; }
    </style>
</head>
<body class="pb-5">

<div class="page-header px-4">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="bi bi-people-fill text-primary me-2"></i>Danh sách Khách hàng</h4>
            <span class="text-muted small">Quản lý định danh và phân loại hạng thành viên</span>
        </div>
        <div>
            <button class="btn btn-outline-secondary btn-sm" onclick="window.location.reload()">
                <i class="bi bi-arrow-clockwise"></i> Làm mới danh sách
            </button>
        </div>
    </div>
</div>

<div class="container-fluid px-4">
    <div class="card main-card overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th class="ps-4">Mã KH</th>
                        <th>Thông tin khách hàng</th>
                        <th>Định danh (MST/CCCD)</th>
                        <th>Liên hệ</th>
                        <th>Địa chỉ công ty</th>
                        <th style="width: 170px;">Loại đối tượng</th>
                        <th style="width: 170px;">Hạng thành viên</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${list}">
                        <tr>
                            <td class="ps-4">
                                <span class="badge badge-code">${c.customer_code}</span>
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${c.name}</div>
                                <div class="text-muted small">${c.short_name}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty c.tax_code}">
                                        <div class="small">MST: <code class="fw-bold text-primary">${c.tax_code}</code></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="small">CCCD: <code class="fw-bold text-success">${c.identity_number}</code></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="small"><i class="bi bi-telephone text-muted me-1"></i> ${c.phone}</div>
                                <div class="small text-muted"><i class="bi bi-envelope me-1"></i> ${c.email}</div>
                            </td>
                            <td>
                                <div class="small text-muted text-truncate" style="max-width: 220px;" title="${c.company_address}">
                                    <i class="bi bi-geo-alt me-1"></i> ${c.company_address}
                                </div>
                            </td>
                            <td>
                                <select class="form-select form-select-sm" onchange="this.style.backgroundColor='#e0f2fe'">
                                    <option value="B2B" ${c.customer_type == 'B2B' ? 'selected' : ''}>🏢 B2B</option>
                                    <option value="B2C" ${c.customer_type == 'B2C' ? 'selected' : ''}>👤 B2C</option>
                                </select>
                            </td>
                            <td>
                                <select class="form-select form-select-sm" onchange="this.style.backgroundColor='#fff7ed'">
                                    <option value="Bạc" ${c.tier_name == 'Bạc' ? 'selected' : ''}>🥈 Bạc</option>
                                    <option value="Vàng" ${c.tier_name == 'Vàng' ? 'selected' : ''}>🥇 Vàng</option>
                                    <option value="Kim Cương" ${c.tier_name == 'Kim Cương' ? 'selected' : ''}>💎 Kim Cương</option>
                                </select>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<button class="btn btn-success btn-save-fixed" onclick="alert('Đã cập nhật thay đổi thành công!')">
    <i class="bi bi-save2 me-2"></i> LƯU TẤT CẢ THAY ĐỔI
</button>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>