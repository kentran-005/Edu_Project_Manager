package com.poly.manager.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class GradeDao extends BaseDao {
    public void save(long groupId,long studentId,long lecturerId,double score,String comment,String status) throws SQLException {
        if(one("SELECT id FROM grades WHERE group_id=? AND student_id=?",groupId,studentId)==null)
            insert("INSERT INTO grades(group_id,student_id,graded_by_id,score,comment,status) VALUES(?,?,?,?,?,?)",
                groupId,studentId,lecturerId,score,comment,status);
        else update("UPDATE grades SET graded_by_id=?,score=?,comment=?,status=?,updated_at=SYSDATETIME() WHERE group_id=? AND student_id=?",
            lecturerId,score,comment,status,groupId,studentId);
    }
    public List<Map<String,Object>> byGroup(long groupId) throws SQLException {
        return query("SELECT g.*,s.student_code,u.full_name student_name FROM grades g " +
            "JOIN students s ON s.id=g.student_id JOIN users u ON u.id=s.user_id WHERE g.group_id=?",groupId);
    }
    public List<Map<String,Object>> publishedForStudent(long userId) throws SQLException {
        return query("SELECT g.*,pg.group_name,t.title topic_title,u.full_name lecturer_name FROM grades g " +
            "JOIN students s ON s.id=g.student_id JOIN project_groups pg ON pg.id=g.group_id " +
            "LEFT JOIN topics t ON t.id=pg.topic_id LEFT JOIN lecturers l ON l.id=g.graded_by_id " +
            "LEFT JOIN users u ON u.id=l.user_id WHERE s.user_id=? AND g.status='PUBLISHED'",userId);
    }
}
