package com.poly.manager.dao;

import java.sql.SQLException;
import java.util.List;
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

    public Map<String,Object> adminGroupStatus() throws SQLException {
        return one("SELECT " +
            "SUM(CASE WHEN status='IN_PROGRESS' THEN 1 ELSE 0 END) AS in_progress, " +
            "SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END) AS completed, " +
            "SUM(CASE WHEN status='REGISTERED' THEN 1 ELSE 0 END) AS registered, " +
            "SUM(CASE WHEN status='FORMING' THEN 1 ELSE 0 END) AS forming, COUNT(*) AS total " +
            "FROM project_groups");
    }

    public List<Map<String,Object>> adminRecentReports() throws SQLException {
        return query("SELECT TOP 6 g.group_id AS id,g.group_name,t.title AS topic_title,pr.week_number,pr.status AS report_status,pr.updated_at " +
            "FROM progress_reports pr JOIN project_groups g ON g.group_id=pr.group_id " +
            "LEFT JOIN topics t ON t.topic_id=g.topic_id ORDER BY pr.updated_at DESC");
    }

    public List<Map<String,Object>> adminActivities() throws SQLException {
        return query("SELECT TOP 6 activity_name,activity_type,occurred_at FROM (" +
            "SELECT N'Tài khoản mới: ' + full_name AS activity_name,N'Tài khoản' AS activity_type,created_at AS occurred_at FROM users " +
            "UNION ALL SELECT N'Đề tài mới: ' + title,N'Đề tài',created_at FROM topics " +
            "UNION ALL SELECT N'Nhóm mới: ' + group_name,N'Nhóm',created_at FROM project_groups " +
            "UNION ALL SELECT N'Báo cáo đã nộp: ' + title,N'Báo cáo',created_at FROM progress_reports" +
            ") AS activities ORDER BY occurred_at DESC");
    }

    public Map<String,Object> lecturer(long userId) throws SQLException {
        return one("SELECT " +
            "(SELECT COUNT(*) FROM topics t JOIN lecturers l ON l.lecturer_id=t.lecturer_id WHERE l.user_id=?) AS topics, " +
            "(SELECT COUNT(*) FROM project_groups g JOIN topics t ON t.topic_id=g.topic_id JOIN lecturers l ON l.lecturer_id=t.lecturer_id WHERE l.user_id=?) AS groups, " +
            "(SELECT COUNT(*) FROM project_registrations r JOIN topics t ON t.topic_id=r.topic_id JOIN lecturers l ON l.lecturer_id=t.lecturer_id WHERE l.user_id=? AND r.status='PENDING') AS pending_registrations, " +
            "(SELECT COUNT(*) FROM feedbacks f JOIN lecturers l ON l.lecturer_id=f.lecturer_id WHERE l.user_id=?) AS feedbacks, " +
            "(SELECT COUNT(*) FROM group_members gm JOIN project_groups g ON g.group_id=gm.group_id JOIN topics t ON t.topic_id=g.topic_id JOIN lecturers l ON l.lecturer_id=t.lecturer_id " +
            " LEFT JOIN grades gr ON gr.group_id=g.group_id AND gr.student_id=gm.student_id WHERE l.user_id=? AND g.status IN ('IN_PROGRESS','COMPLETED') AND gr.grade_id IS NULL) AS ungraded_students", userId,userId,userId,userId,userId);
    }

    public Map<String,Object> lecturerReportStatus(long userId) throws SQLException {
        return one("SELECT " +
            "SUM(CASE WHEN x.report_status='REVIEWED' THEN 1 ELSE 0 END) AS reviewed, " +
            "SUM(CASE WHEN x.report_status='SUBMITTED' THEN 1 ELSE 0 END) AS submitted, " +
            "SUM(CASE WHEN x.report_status IS NULL THEN 1 ELSE 0 END) AS no_report, COUNT(*) AS total " +
            "FROM (SELECT g.group_id,latest.status AS report_status FROM project_groups g JOIN topics t ON t.topic_id=g.topic_id JOIN lecturers l ON l.lecturer_id=t.lecturer_id " +
            "OUTER APPLY (SELECT TOP 1 pr.status FROM progress_reports pr WHERE pr.group_id=g.group_id ORDER BY pr.week_number DESC,pr.updated_at DESC) latest WHERE l.user_id=?) x",userId);
    }

    public List<Map<String,Object>> lecturerRecentReports(long userId) throws SQLException {
        return query("SELECT TOP 6 g.group_id AS id,g.group_name,pr.week_number,pr.title,pr.report_date,pr.status " +
            "FROM progress_reports pr JOIN project_groups g ON g.group_id=pr.group_id JOIN topics t ON t.topic_id=g.topic_id " +
            "JOIN lecturers l ON l.lecturer_id=t.lecturer_id WHERE l.user_id=? ORDER BY pr.updated_at DESC",userId);
    }

    public Map<String,Object> student(long userId) throws SQLException {
        return one("SELECT " +
            "(SELECT COUNT(*) FROM group_members gm JOIN students s ON s.student_id=gm.student_id WHERE s.user_id=?) AS group_count, " +
            "(SELECT COUNT(*) FROM progress_reports pr JOIN group_members gm ON gm.group_id=pr.group_id JOIN students s ON s.student_id=gm.student_id WHERE s.user_id=?) AS report_count, " +
            "(SELECT COUNT(*) FROM submissions sub JOIN students s ON s.student_id=sub.submitted_by_id WHERE s.user_id=?) AS submission_count, " +
            "(SELECT AVG(CAST(gr.score AS DECIMAL(5,2))) FROM grades gr JOIN students s ON s.student_id=gr.student_id WHERE s.user_id=? AND gr.status='PUBLISHED') AS average_score",userId,userId,userId,userId);
    }

    public Map<String,Object> studentReportStatus(long userId) throws SQLException {
        return one("SELECT SUM(CASE WHEN pr.status='REVIEWED' THEN 1 ELSE 0 END) AS reviewed, " +
            "SUM(CASE WHEN pr.status='SUBMITTED' THEN 1 ELSE 0 END) AS submitted, COUNT(pr.progress_report_id) AS total " +
            "FROM group_members gm JOIN students s ON s.student_id=gm.student_id LEFT JOIN progress_reports pr ON pr.group_id=gm.group_id WHERE s.user_id=?",userId);
    }

    public List<Map<String,Object>> studentRecentItems(long userId) throws SQLException {
        return query("SELECT TOP 6 item_name,item_type,item_date,item_status FROM (" +
            "SELECT pr.title AS item_name,N'Báo cáo tiến độ' AS item_type,CAST(pr.report_date AS DATETIME2) AS item_date,pr.status AS item_status " +
            "FROM progress_reports pr JOIN group_members gm ON gm.group_id=pr.group_id JOIN students s ON s.student_id=gm.student_id WHERE s.user_id=? " +
            "UNION ALL SELECT sub.file_name,N'Bài nộp',sub.created_at,sub.type FROM submissions sub JOIN students s ON s.student_id=sub.submitted_by_id WHERE s.user_id=?" +
            ") AS items ORDER BY item_date DESC",userId,userId);
    }

    public List<Map<String,Object>> studentMilestones(long userId) throws SQLException {
        return query("SELECT N'Hạn đăng ký đề tài' AS milestone_name,CAST(se.registration_deadline AS DATETIME2) AS milestone_date FROM group_members gm " +
            "JOIN students st ON st.student_id=gm.student_id JOIN project_groups g ON g.group_id=gm.group_id JOIN semesters se ON se.semester_id=g.semester_id " +
            "WHERE st.user_id=? AND se.registration_deadline IS NOT NULL UNION ALL " +
            "SELECT N'Kết thúc học kỳ',CAST(se.end_date AS DATETIME2) FROM group_members gm JOIN students st ON st.student_id=gm.student_id " +
            "JOIN project_groups g ON g.group_id=gm.group_id JOIN semesters se ON se.semester_id=g.semester_id WHERE st.user_id=? ORDER BY milestone_date",userId,userId);
    }
    private long count(String table) throws SQLException {
        return ((Number)one("SELECT COUNT(*) total FROM "+table).get("total")).longValue();
    }
}
