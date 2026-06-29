package com.poly.manager.dao;

import com.poly.manager.util.Database;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public abstract class BaseDao {
    protected List<Map<String,Object>> query(String sql, Object... params) throws SQLException {
        List<Map<String,Object>> rows = new ArrayList<Map<String,Object>>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            bind(statement, params);
            try (ResultSet result = statement.executeQuery()) {
                ResultSetMetaData meta = result.getMetaData();
                while (result.next()) {
                    Map<String,Object> row = new LinkedHashMap<String,Object>();
                    for (int i=1; i<=meta.getColumnCount(); i++) {
                        row.put(meta.getColumnLabel(i), result.getObject(i));
                    }
                    rows.add(row);
                }
            }
        }
        return rows;
    }

    protected Map<String,Object> one(String sql, Object... params) throws SQLException {
        List<Map<String,Object>> rows = query(sql, params);
        return rows.isEmpty() ? null : rows.get(0);
    }

    protected int update(String sql, Object... params) throws SQLException {
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            bind(statement, params);
            return statement.executeUpdate();
        }
    }

    protected long insert(String sql, Object... params) throws SQLException {
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(statement, params);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) throw new SQLException("Không nhận được ID sau khi thêm dữ liệu");
                return keys.getLong(1);
            }
        }
    }

    protected void transaction(TransactionWork work) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            connection.setAutoCommit(false);
            try {
                work.execute(connection);
                connection.commit();
            } catch (Exception ex) {
                connection.rollback();
                if (ex instanceof SQLException) throw (SQLException) ex;
                throw new SQLException(ex);
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    protected void bind(PreparedStatement statement, Object... params) throws SQLException {
        for (int i=0; i<params.length; i++) {
            Object value = params[i];
            if (value instanceof LocalDate) statement.setDate(i+1, java.sql.Date.valueOf((LocalDate)value));
            else statement.setObject(i+1, value);
        }
    }

    protected interface TransactionWork { void execute(Connection connection) throws Exception; }
}
