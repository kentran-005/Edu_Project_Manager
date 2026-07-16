package com.poly.manager.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class GradeDao extends BaseDao {
    public void save(long groupId,long studentId,long lecturerId,double score,String comment,String status) throws SQLException {
        if (score < 0 || score > 10) throw new SQLException("Điểm phải nằm trong khoảng 0 đến 10");
        if (!"DRAFT".equals(status) && !"PUBLISHED".equals(status)) throw new SQLException("Trạng thái điểm không hợp lệ");
        if(one("SELECT group_member_id FROM group_members WHERE group_id=? AND student_id=?",groupId,studentId)==null)
            throw new SQLException("Sinh viên không thuộc nhóm được chấm");
        if(one("SELECT group_id FROM project_groups WHERE group_id=?",groupId)==null)
            throw new SQLException("Nhóm không tồn tại");
        if(one("SELECT grade_id FROM grades WHERE group_id=? AND student_id=?",groupId,studentId)==null)
            insert("INSERT INTO grades(group_id,student_id,graded_by_id,score,comment,status) VALUES(?,?,?,?,?,?)",
                groupId,studentId,lecturerId,score,comment,status);
        else update("UPDATE grades SET graded_by_id=?,score=?,comment=?,status=?,updated_at=SYSDATETIME() WHERE group_id=? AND student_id=?",
            lecturerId,score,comment,status,groupId,studentId);
    }
    public List<Map<String,Object>> byGroup(long groupId) throws SQLException {
        return query("SELECT g.grade_id AS id,g.*,s.student_code,u.full_name student_name FROM grades g " +
            "JOIN students s ON s.student_id=g.student_id JOIN users u ON u.user_id=s.user_id WHERE g.group_id=?",groupId);
    }
    public List<Map<String,Object>> publishedForStudent(long userId) throws SQLException {
        return query("SELECT g.grade_id AS id,g.*,pg.group_name,t.title topic_title,u.full_name lecturer_name FROM grades g " +
            "JOIN students s ON s.student_id=g.student_id JOIN project_groups pg ON pg.group_id=g.group_id " +
            "LEFT JOIN topics t ON t.topic_id=pg.topic_id LEFT JOIN lecturers l ON l.lecturer_id=g.graded_by_id " +
            "LEFT JOIN users u ON u.user_id=l.user_id WHERE s.user_id=? AND g.status='PUBLISHED'",userId);
    }
}
