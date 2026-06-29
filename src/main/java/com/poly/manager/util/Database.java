package com.poly.manager.util;

import com.poly.manager.config.AppConfig;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public final class Database {
    private static final HikariDataSource DATA_SOURCE;

    static {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        config.setJdbcUrl(AppConfig.get("db.url"));
        config.setUsername(AppConfig.get("db.username"));
        config.setPassword(AppConfig.get("db.password"));
        config.setMaximumPoolSize(AppConfig.getInt("db.pool.maximum", 10));
        config.setMinimumIdle(2);
        config.setConnectionTimeout(15000);
        config.setPoolName("EduProjectPool");
        DATA_SOURCE = new HikariDataSource(config);
    }

    private Database() {}

    public static Connection getConnection() throws SQLException {
        return DATA_SOURCE.getConnection();
    }

    public static void close() {
        if (!DATA_SOURCE.isClosed()) DATA_SOURCE.close();
    }
}
