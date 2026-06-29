package com.poly.manager.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class AdminDao extends BaseDao {
    public List<Map<String,Object>> classes() throws SQLException {
        return query("SELECT c.*,u.full_name advisor_name FROM academic_classes c " +
            "LEFT JOIN lecturers l ON l.id=c.advisor_id LEFT JOIN users u ON u.id=l.user_id ORDER BY c.code");
    }
    public long createClass(String code,String name,String major,Integer intakeYear,Long advisorId) throws SQLException {
        return insert("INSERT INTO academic_classes(code,name,major,intake_year,advisor_id) VALUES(?,?,?,?,?)",
            code,name,major,intakeYear,advisorId);
    }
    public List<Map<String,Object>> semesters() throws SQLException {
        return query("SELECT * FROM semesters ORDER BY start_date DESC");
    }
    public long createSemester(String code,String name,LocalDate start,LocalDate end,
                               LocalDate deadline,String status) throws SQLException {
        return insert("INSERT INTO semesters(code,name,start_date,end_date,registration_deadline,status) VALUES(?,?,?,?,?,?)",
            code,name,start,end,deadline,status);
    }
    public List<Map<String,Object>> lecturers() throws SQLException {
        return query("SELECT l.id,l.lecturer_code,u.full_name,l.department,l.academic_rank " +
            "FROM lecturers l JOIN users u ON u.id=l.user_id WHERE u.status='ACTIVE' ORDER BY u.full_name");
    }
}
