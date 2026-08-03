package com.poly.manager.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class AdminDao extends BaseDao {
    public List<Map<String,Object>> classes() throws SQLException {
        return query("SELECT c.class_id AS id, c.*, u.full_name AS advisor_name, " +
            "COALESCE(l.department, 'Công nghệ thông tin') AS department, " +
            "(SELECT COUNT(*) FROM students s WHERE s.class_id = c.class_id) AS student_count, " +
            "(SELECT TOP 1 sem.name FROM semesters sem ORDER BY sem.start_date DESC) AS semester_name, " +
            "CASE WHEN c.intake_year >= 2024 THEN 'ACTIVE' WHEN c.intake_year = 2023 THEN 'PAUSED' ELSE 'CLOSED' END AS status " +
            "FROM academic_classes c " +
            "LEFT JOIN lecturers l ON l.lecturer_id=c.advisor_id " +
            "LEFT JOIN users u ON u.user_id=l.user_id ORDER BY c.code");
    }

    public List<Map<String,Object>> adminTopics() throws SQLException {
        return query("SELECT t.topic_id AS id, t.*, u.full_name AS lecturer_name, s.name AS semester_name, " +
            "c.code AS class_code, " +
            "(SELECT TOP 1 g.group_name FROM project_groups g WHERE g.topic_id = t.topic_id) AS group_name " +
            "FROM topics t " +
            "JOIN lecturers l ON l.lecturer_id=t.lecturer_id JOIN users u ON u.user_id=l.user_id " +
            "JOIN semesters s ON s.semester_id=t.semester_id " +
            "LEFT JOIN project_groups g2 ON g2.topic_id=t.topic_id " +
            "LEFT JOIN group_members gm ON gm.group_id=g2.group_id AND gm.role='LEADER' " +
            "LEFT JOIN students st ON st.student_id=gm.student_id " +
            "LEFT JOIN academic_classes c ON c.class_id=st.class_id " +
            "ORDER BY t.created_at DESC");
    }

    public List<Map<String,Object>> adminGroups() throws SQLException {
        return query("SELECT g.group_id AS id, g.*, t.title AS topic_title, s.name AS semester_name, " +
            "u.full_name AS lecturer_name, c.code AS class_code, " +
            "CASE WHEN g.status='COMPLETED' THEN 100 WHEN g.status='IN_PROGRESS' THEN 65 ELSE 30 END AS progress " +
            "FROM project_groups g " +
            "LEFT JOIN topics t ON t.topic_id=g.topic_id " +
            "LEFT JOIN lecturers l ON l.lecturer_id=t.lecturer_id " +
            "LEFT JOIN users u ON u.user_id=l.user_id " +
            "JOIN semesters s ON s.semester_id=g.semester_id " +
            "LEFT JOIN group_members gm ON gm.group_id=g.group_id AND gm.role='LEADER' " +
            "LEFT JOIN students st ON st.student_id=gm.student_id " +
            "LEFT JOIN academic_classes c ON c.class_id=st.class_id " +
            "ORDER BY g.created_at DESC");
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

    public long createTopic(long lecturerId, long semesterId, String title, String description, String requirements, String technology, int maxMembers, String status) throws SQLException {
        if (blank(title)) throw new SQLException("Tên đề tài là bắt buộc");
        if (blank(description)) throw new SQLException("Mô tả đề tài là bắt buộc");
        String topicStatus = (status == null || status.trim().isEmpty()) ? "APPROVED" : status.trim();
        return insert("INSERT INTO topics(lecturer_id, semester_id, title, description, requirements, technology, max_members, status) VALUES(?,?,?,?,?,?,?,?)",
                lecturerId, semesterId, title.trim(), description.trim(), blank(requirements) ? null : requirements.trim(), blank(technology) ? null : technology.trim(), maxMembers, topicStatus);
    }

    public int updateTopic(long id, String title, String description, String status) throws SQLException {
        if (blank(title)) throw new SQLException("Tên đề tài là bắt buộc");
        if (blank(description)) throw new SQLException("Mô tả đề tài là bắt buộc");
        return update("UPDATE topics SET title=?, description=?, status=? WHERE topic_id=?", title.trim(), description.trim(), status, id);
    }

    public int updateClass(long id, String name, String major, Integer intakeYear, Long advisorId) throws SQLException {
        if (blank(name)) throw new SQLException("Tên lớp là bắt buộc");
        if (intakeYear != null && (intakeYear < 1990 || intakeYear > 2100))
            throw new SQLException("Khóa tuyển sinh phải nằm trong khoảng 1990 đến 2100");
        return update("UPDATE academic_classes SET name=?, major=?, intake_year=?, advisor_id=? WHERE class_id=?",
                name.trim(), blank(major) ? null : major.trim(), intakeYear, advisorId, id);
    }

    public int updateSemester(long id, String name, LocalDate start, LocalDate end, LocalDate deadline, String status) throws SQLException {
        if (blank(name)) throw new SQLException("Tên học kỳ là bắt buộc");
        if (start == null || end == null) throw new SQLException("Ngày bắt đầu và ngày kết thúc là bắt buộc");
        if (!end.isAfter(start)) throw new SQLException("Ngày kết thúc phải sau ngày bắt đầu");
        if (deadline != null && deadline.isAfter(end)) throw new SQLException("Hạn đăng ký không được sau ngày kết thúc");
        return update("UPDATE semesters SET name=?, start_date=?, end_date=?, registration_deadline=?, status=? WHERE semester_id=?",
                name.trim(), start, end, deadline, status, id);
    }

    public List<Map<String,Object>> lecturers() throws SQLException {
        return query("SELECT l.lecturer_id AS id,l.lecturer_code,u.full_name,l.department,l.academic_rank " +
            "FROM lecturers l JOIN users u ON u.user_id=l.user_id WHERE u.status='ACTIVE' ORDER BY u.full_name");
    }

    private boolean blank(String value){return value==null||value.trim().isEmpty();}
}

