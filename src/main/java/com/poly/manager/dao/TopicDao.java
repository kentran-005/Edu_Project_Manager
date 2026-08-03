package com.poly.manager.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class TopicDao extends BaseDao {
    public List<Map<String, Object>> findAll(Long semesterId, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT t.topic_id AS id,t.*,u.full_name lecturer_name,s.name semester_name FROM topics t " +
                        "JOIN lecturers l ON l.lecturer_id=t.lecturer_id JOIN users u ON u.user_id=l.user_id " +
                        "JOIN semesters s ON s.semester_id=t.semester_id WHERE 1=1");
        java.util.List<Object> args = new java.util.ArrayList<Object>();
        if (semesterId != null) {
            sql.append(" AND t.semester_id=?");
            args.add(semesterId);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.status=?");
            args.add(status);
        }
        sql.append(" ORDER BY t.created_at DESC");
        return query(sql.toString(), args.toArray());
    }

    public List<Map<String, Object>> findByLecturer(long userId) throws SQLException {
        return query("SELECT t.topic_id AS id, t.*, s.name AS semester_name, " +
                "g.group_id, g.group_name, " +
                "COALESCE((SELECT COUNT(*) FROM group_members gm WHERE gm.group_id = g.group_id), 0) AS member_count, "
                +
                "(SELECT AVG(gr.score) FROM grades gr WHERE gr.group_id = g.group_id) AS avg_score " +
                "FROM topics t " +
                "JOIN semesters s ON s.semester_id = t.semester_id " +
                "JOIN lecturers l ON l.lecturer_id = t.lecturer_id " +
                "LEFT JOIN project_groups g ON g.topic_id = t.topic_id AND g.status IN ('IN_PROGRESS','COMPLETED') " +
                "WHERE l.user_id=? ORDER BY t.created_at DESC", userId);
    }

    public Map<String,Object> getLecturerStats(long userId) throws SQLException {
        return one("SELECT " +
            "COUNT(*) AS total_topics, " +
            "COALESCE(SUM(CASE WHEN stats.status IN ('OPEN','ASSIGNED') THEN 1 ELSE 0 END), 0) AS in_progress_topics, " +
            "COALESCE(SUM(CASE WHEN stats.status = 'DRAFT' THEN 1 ELSE 0 END), 0) AS pending_topics, " +
            "COALESCE(SUM(CASE WHEN stats.status = 'CLOSED' THEN 1 ELSE 0 END), 0) AS completed_topics, " +
            "COALESCE(SUM(CASE WHEN stats.avg_score >= 8.0 THEN 1 ELSE 0 END), 0) AS good_topics " +
            "FROM ( " +
            "   SELECT t.topic_id, t.status, " +
            "          (SELECT AVG(gr.score) FROM project_groups g JOIN grades gr ON gr.group_id = g.group_id WHERE g.topic_id = t.topic_id) AS avg_score " +
            "   FROM topics t JOIN lecturers l ON l.lecturer_id = t.lecturer_id WHERE l.user_id = ? " +
            ") AS stats", userId);
    }

    public Map<String, Object> find(long id) throws SQLException {
        return one("SELECT t.topic_id AS id,t.*,u.full_name lecturer_name,s.name semester_name FROM topics t " +
                "JOIN lecturers l ON l.lecturer_id=t.lecturer_id JOIN users u ON u.user_id=l.user_id " +
                "JOIN semesters s ON s.semester_id=t.semester_id WHERE t.topic_id=?", id);
    }

    public long create(long lecturerId, long semesterId, String title, String description, String requirements,
            String technology, int maxMembers, String status) throws SQLException {
        if (title == null || title.trim().isEmpty())
            throw new SQLException("Tiêu đề đề tài là bắt buộc");
        if (description == null || description.trim().isEmpty())
            throw new SQLException("Mô tả đề tài là bắt buộc");
        if (maxMembers < 1 || maxMembers > 10)
            throw new SQLException("Số thành viên phải từ 1 đến 10");
        if (!"DRAFT".equals(status) && !"OPEN".equals(status))
            throw new SQLException("Trạng thái đề tài không hợp lệ");
        return insert(
                "INSERT INTO topics(lecturer_id,semester_id,title,description,requirements,technology,max_members,status) "
                        +
                        "VALUES(?,?,?,?,?,?,?,?)",
                lecturerId, semesterId, title, description, requirements, technology, maxMembers, status);
    }

    public int update(long id, long lecturerId, String title, String description, String requirements,
            String technology, int maxMembers, String status) throws SQLException {
        if (title == null || title.trim().isEmpty())
            throw new SQLException("Tiêu đề đề tài là bắt buộc");
        if (description == null || description.trim().isEmpty())
            throw new SQLException("Mô tả đề tài là bắt buộc");
        if (maxMembers < 1 || maxMembers > 10)
            throw new SQLException("Số thành viên phải từ 1 đến 10");
        if (!"DRAFT".equals(status) && !"OPEN".equals(status) && !"CLOSED".equals(status))
            throw new SQLException("Trạng thái đề tài không hợp lệ");
        return update(
                "UPDATE topics SET title=?,description=?,requirements=?,technology=?,max_members=?,status=?,updated_at=SYSDATETIME() "
                        +
                        "WHERE topic_id=? AND lecturer_id=? AND status<>'ASSIGNED'",
                title, description, requirements, technology, maxMembers, status, id, lecturerId);
    }

    public int updateStatus(long id, long lecturerId, String status) throws SQLException {
        if (!"DRAFT".equals(status) && !"OPEN".equals(status) && !"CLOSED".equals(status))
            throw new SQLException("Trạng thái đề tài không hợp lệ");
        return update("UPDATE topics SET status=?, updated_at=SYSDATETIME() WHERE topic_id=? AND lecturer_id=? AND status<>'ASSIGNED'", status, id, lecturerId);
    }

    public int delete(long id, long lecturerId) throws SQLException {
        return update("DELETE FROM topics WHERE topic_id=? AND lecturer_id=? AND status NOT IN ('ASSIGNED') AND topic_id NOT IN (SELECT topic_id FROM project_groups WHERE topic_id IS NOT NULL)", id, lecturerId);
    }

    public Long lecturerIdByUser(long userId) throws SQLException {
        Map<String, Object> row = one("SELECT lecturer_id AS id FROM lecturers WHERE user_id=?", userId);
        return row == null ? null : ((Number) row.get("id")).longValue();
    }
}
