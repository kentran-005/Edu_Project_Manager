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
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=edu_project;encrypt=true;trustServerCertificate=true
DB_USERNAME=sa
DB_PASSWORD=your_password
```

Nếu dùng SQL Server Express trên Windows, URL có thể là:

```text
jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=edu_project;encrypt=true;trustServerCertificate=true
```

## Cloudinary

```text
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

Không đưa API secret vào JSP hoặc JavaScript.

## Chạy bằng Eclipse

1. Maven → Update Project.
2. Project Facets: Java 21, Dynamic Web Module 6.1.
3. Add project vào Apache Tomcat 11.
4. Run on Server.
5. Truy cập `http://localhost:8080/Manager_Edu_Project/`.


## Build

```bash
mvn clean test package
```

WAR được tạo tại `target/Manager_Edu_Project.war`.
# Edu_Project_Manager
