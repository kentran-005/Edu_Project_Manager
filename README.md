# Manager Edu Project - Servlet/JSP

Website quản lý đồ án sinh viên sử dụng Java Servlet/JSP, JDBC và SQL Server.

## Công nghệ

- Java 21
- Maven WAR
- Apache Tomcat 11
- Jakarta Servlet 6.1, JSP 4.0, Jakarta Tags/JSTL 3
- JDBC + HikariCP
- Microsoft SQL Server
- BCrypt, Cloudinary, OpenPDF

## Cấu hình SQL Server

1. Mở SQL Server Management Studio hoặc Azure Data Studio.
2. Chạy `database/schema.sql`.
3. Sửa `src/main/resources/application.properties` hoặc thiết lập biến môi trường:

```text
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=Manager_Edu_Project;encrypt=true;trustServerCertificate=true
DB_USERNAME=sa
DB_PASSWORD=your_password
```

Nếu dùng SQL Server Express trên Windows, URL có thể là:

```text
jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=Manager_Edu_Project;encrypt=true;trustServerCertificate=true
```

## Cloudinary

```text
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

Không đưa API secret vào JSP hoặc JavaScript.

## Chạy bằng Eclipse

### Cách import khuyến nghị cho thành viên nhóm

1. Clone project về máy.
2. Trong Eclipse chọn `File → Import → Maven → Existing Maven Projects`.
3. Chọn đúng thư mục chứa `pom.xml`.
4. Sau khi import xong: chuột phải project → `Maven → Update Project...` → tick `Force Update of Snapshots/Releases`.
5. Kiểm tra `Project Facets`: Java 21, Dynamic Web Module 6.0 hoặc 6.1 tùy bản Eclipse hỗ trợ.
6. Add project vào Apache Tomcat 11.
7. Run on Server.
8. Truy cập `http://localhost:8080/Manager_Edu_Project/`.

Lưu ý: không import bằng `General → Existing Projects into Workspace` nếu Eclipse báo lỗi descriptor. Đây là Maven WAR project, nên import bằng Maven để Eclipse tự sinh lại cấu hình cần thiết.

Nếu Eclipse đã import lỗi trước đó:

1. Xóa project khỏi Eclipse, chọn `Remove from workspace`, không tick xóa source.
2. Xóa thư mục `target/` nếu có.
3. Import lại bằng `Maven → Existing Maven Projects`.


## Build

```bash
mvn clean test package
```

WAR được tạo tại `target/Manager_Edu_Project.war`.
# Edu_Project_Manager
