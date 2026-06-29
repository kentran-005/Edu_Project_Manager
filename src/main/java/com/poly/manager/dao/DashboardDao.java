package com.poly.manager.dao;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDao extends BaseDao {
    public Map<String,Object> admin() throws SQLException {
        Map<String,Object> result=new LinkedHashMap<String,Object>();
        result.put("students",count("students")); result.put("lecturers",count("lecturers"));
        result.put("classes",count("academic_classes")); result.put("semesters",count("semesters"));
        result.put("topics",count("topics")); result.put("groups",count("project_groups"));
        result.put("reports",count("progress_reports")); result.put("submissions",count("submissions"));
        return result;
    }
    private long count(String table) throws SQLException {
        return ((Number)one("SELECT COUNT(*) total FROM "+table).get("total")).longValue();
    }
}
