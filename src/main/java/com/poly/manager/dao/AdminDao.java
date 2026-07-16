package com.poly.manager.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class AdminDao extends BaseDao {
    public List<Map<String,Object>> classes() throws SQLException {
        return query("SELECT c.class_id AS id,c.*,u.full_name advisor_name FROM academic_classes c " +
            "LEFT JOIN lecturers l ON l.lecturer_id=c.advisor_id LEFT JOIN users u ON u.user_id=l.user_id ORDER BY c.code");
    }
    public long createClass(String code,String name,String major,Integer intakeYear,Long advisorId) throws SQLException {
        if(blank(code)) throw new SQLException("Mã lớp là bắt buộc");
        if(blank(name)) throw new SQLException("Tên lớp là bắt buộc");
        if(intakeYear!=null && (intakeYear<1990 || intakeYear>2100))
            throw new SQLException("Khóa tuyển sinh phải nằm trong khoảng 1990 đến 2100");
        if(one("SELECT class_id FROM academic_classes WHERE code=?",code.trim())!=null)
            throw new SQLException("Mã lớp đã tồn tại");
        if(advisorId!=null && one("SELECT lecturer_id FROM lecturers WHERE lecturer_id=?",advisorId)==null)
            throw new SQLException("Giảng viên cố vấn không tồn tại");
        return insert("INSERT INTO academic_classes(code,name,major,intake_year,advisor_id) VALUES(?,?,?,?,?)",
            code.trim(),name.trim(),blank(major)?null:major.trim(),intakeYear,advisorId);
    }
    public List<Map<String,Object>> semesters() throws SQLException {
        return query("SELECT semester_id AS id,* FROM semesters ORDER BY start_date DESC");
    }
    public long createSemester(String code,String name,LocalDate start,LocalDate end,
                               LocalDate deadline,String status) throws SQLException {
        if(blank(code)) throw new SQLException("Mã học kỳ là bắt buộc");
        if(blank(name)) throw new SQLException("Tên học kỳ là bắt buộc");
        if(start==null || end==null) throw new SQLException("Ngày bắt đầu và ngày kết thúc là bắt buộc");
        if(!end.isAfter(start)) throw new SQLException("Ngày kết thúc phải sau ngày bắt đầu");
        if(deadline!=null && deadline.isAfter(end)) throw new SQLException("Hạn đăng ký không được sau ngày kết thúc");
        if(!"UPCOMING".equals(status) && !"ACTIVE".equals(status) && !"CLOSED".equals(status))
            throw new SQLException("Trạng thái học kỳ không hợp lệ");
        if(one("SELECT semester_id FROM semesters WHERE code=?",code.trim())!=null)
            throw new SQLException("Mã học kỳ đã tồn tại");
        return insert("INSERT INTO semesters(code,name,start_date,end_date,registration_deadline,status) VALUES(?,?,?,?,?,?)",
            code.trim(),name.trim(),start,end,deadline,status);
    }
    public List<Map<String,Object>> lecturers() throws SQLException {
        return query("SELECT l.lecturer_id AS id,l.lecturer_code,u.full_name,l.department,l.academic_rank " +
            "FROM lecturers l JOIN users u ON u.user_id=l.user_id WHERE u.status='ACTIVE' ORDER BY u.full_name");
    }
    private boolean blank(String value){return value==null||value.trim().isEmpty();}
}
