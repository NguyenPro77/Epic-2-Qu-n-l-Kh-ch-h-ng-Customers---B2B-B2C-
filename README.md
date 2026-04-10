Báo cáo task: Quản lý Customer & Phân loại khách hàng

Thời gian:** Thứ 4, 05/04/2026

---

Tổng quan
Module này cho phép quản lý danh sách Khách hàng (Customer) trong hệ thống CRM. Khác với CRUD thông thường, hệ thống này:

- Không tạo mới Customer trực tiếp
- Customer được sinh ra từ Lead (khách tiềm năng)
- Cho phép phân loại (B2B/B2C) và phân hạng (Bạc/Vàng/Kim Cương)

Đảm bảo:
- Dữ liệu không bị trùng (check theo phone)
- Quy trình đúng chuẩn CRM: Lead -> Customer
- Hỗ trợ đội ngũ kinh doanh phân nhóm khách hàng

---

Danh Sách Task Hoàn Thành

| # | Task | Chi tiết triển khai | Trạng thái |
|---|---|---|---|
| 1 | Xem danh sách | Hiển thị danh sách khách hàng từ DB | - Done |
| 2 | Convert Lead | Chuyển Lead -> Customer, check trùng phone | - Done |
| 3 | Phân loại | B2B / B2C | - Done |
| 4 | Phân hạng | Bạc / Vàng / Kim Cương | - Done |
| 5 | Cập nhật | Update loại & hạng khách hàng | - Done |

---

1. Xem danh sách khách hàng
<img width="692" height="330" alt="image" src="https://github.com/user-attachments/assets/d8267897-cf69-4157-b424-c8a7f83abe2e" />

Thông tin hiển thị:
- Mã khách hàng
- Tên khách hàng
- MST / CCCD
- Số điện thoại
- Email
- Địa chỉ
- Loại khách hàng
- Hạng thành viên

**Điều kiện nghiệp vụ:**
- Chỉ hiển thị: `is_deleted = 0`
- Join bảng: `customer_tiers`

---

2. Convert Lead -> Customer

Luồng xử lý:
- Lấy dữ liệu từ bảng `leads`
- Kiểm tra trùng số điện thoại
- Nếu chưa tồn tại:
  - Insert vào `customers`
  - Gán mặc định: **Bạc**
- Update trạng thái lead -> `Converted`

SQL thực tế:
sql
INSERT INTO customers 
(customer_code, name, phone, email, customer_type, tier_id, is_deleted)
SELECT CONCAT('KH', id), contact_name, phone, email, customer_type, 1, 0
FROM leads WHERE id = ?
3. Cập nhật loại & hạng khách hàng
<img width="1919" height="907" alt="image" src="https://github.com/user-attachments/assets/95fba65e-a435-4b2a-a5a9-bc98c3ba4670" />

Chức năng:

Chọn trực tiếp trên table:

B2B / B2C

Bạc / Vàng / Kim Cương

Nghiệp vụ:

SQL
UPDATE customers 
SET customer_type=?, 
    tier_id = (SELECT id FROM customer_tiers WHERE tier_name=?)
WHERE id=?
Các chức năng KHÔNG có
Không thêm customer thủ công

Không xóa customer

Không sửa thông tin cơ bản (name, phone)

Vì:

Customer được sinh từ Lead

Đảm bảo dữ liệu chuẩn & không trùng

Cấu trúc bảng cơ sở dữ liệu
Bảng leads

id: ID

contact_name: Tên

phone: SĐT

email: Email

customer_type: B2B/B2C

status: New / Converted

Bảng customers

id: ID

customer_code: KH001...

name: Tên

phone: SĐT

email: Email

customer_type: B2B/B2C

tier_id: FK

is_deleted: 0/1

Bảng customer_tiers

1: Bạc

2: Vàng

3: Kim Cương

Công Nghệ Sử Dụng
Core: Java Servlet (Jakarta EE)

Frontend: JSP + JSTL + Bootstrap

Database: MySQL

Data Access: JDBC

Server: Apache Tomcat

Cài Đặt & Chạy Dự Án
Yêu cầu hệ thống:

Java 17+

MySQL

Apache Tomcat 10

Git

Hướng dẫn chạy môi trường Local:

Bước 1: Clone repository
git clone https://github.com/your-repo/crm-leads-mvc.git

Bước 2: Cấu hình Database
Tạo database: CREATE DATABASE crm_qlbanhang;
Cấu hình trong CustomerDAO.java:

private String jdbcURL = "jdbc:mysql://localhost:3306/crm_qlbanhang";

private String jdbcUsername = "root";

private String jdbcPassword = "";

Bước 3: Build & Chạy

Deploy project lên Tomcat

Run server

Bước 4: Truy cập
http://localhost:8081/CRM_LEADS_MVC/customers
