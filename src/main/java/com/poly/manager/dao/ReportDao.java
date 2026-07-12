package com.poly.manager.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ReportDao extends BaseDao {
    public long create(long groupId,int week,String title,String completed,String nextPlan,String difficulties) throws SQLException {
        if (week < 1) throw new SQLException("Tuần báo cáo phải lớn hơn hoặc bằng 1");
        if (title == null || title.trim().isEmpty()) throw new SQLException("Tiêu đề báo cáo là bắt buộc");
        if (completed == null || completed.trim().isEmpty()) throw new SQLException("Nội dung đã hoàn thành là bắt buộc");
        if (one("SELECT progress_report_id FROM progress_reports WHERE group_id=? AND week_number=?", groupId, week) != null)
            throw new SQLException("Nhóm đã nộp báo cáo cho tuần này");
        return insert("INSERT INTO progress_reports(group_id,week_number,title,completed_work,next_plan,difficulties,report_date,status) " +
            "VALUES(?,?,?,?,?,?,?,'SUBMITTED')",groupId,week,title,completed,nextPlan,difficulties, LocalDate.now());
    }
    public List<Map<String,Object>> findByGroup(long groupId) throws SQLException {
        return query("SELECT progress_report_id AS id,* FROM progress_reports WHERE group_id=? ORDER BY week_number DESC",groupId);
    }
    public long feedback(long groupId,Long reportId,Long submissionId,long lecturerId,String content) throws SQLException {
        if (content == null || content.trim().isEmpty()) throw new SQLException("Nội dung nhận xét là bắt buộc");
        if(reportId!=null) update("UPDATE progress_reports SET status='REVIEWED',updated_at=SYSDATETIME() WHERE progress_report_id=? AND group_id=?",reportId,groupId);
        return insert("INSERT INTO feedbacks(group_id,progress_report_id,submission_id,lecturer_id,content) VALUES(?,?,?,?,?)",
            groupId,reportId,submissionId,lecturerId,content);
    }
    public List<Map<String,Object>> feedbackByGroup(long groupId) throws SQLException {
        return query("SELECT f.feedback_id AS id,f.*,u.full_name lecturer_name FROM feedbacks f " +
            "JOIN lecturers l ON l.lecturer_id=f.lecturer_id JOIN users u ON u.user_id=l.user_id " +
            "WHERE f.group_id=? ORDER BY f.created_at DESC",groupId);
    }
    public List<Map<String,Object>> submissions(long groupId) throws SQLException {
        return query("SELECT sub.submission_id AS id,sub.*,u.full_name submitted_by_name FROM submissions sub " +
            "JOIN students s ON s.student_id=sub.submitted_by_id JOIN users u ON u.user_id=s.user_id " +
            "WHERE sub.group_id=? ORDER BY sub.created_at DESC",groupId);
    }
    public long saveSubmission(long groupId,Long reportId,String type,String fileName,String url,
                               String publicId,String resourceType,long bytes,long studentId) throws SQLException {
        if (!"PROPOSAL".equals(type) && !"PROGRESS".equals(type) && !"FINAL_REPORT".equals(type)
                && !"SOURCE_CODE".equals(type) && !"OTHER".equals(type))
            throw new SQLException("Loại bài nộp không hợp lệ");
        if (fileName == null || fileName.trim().isEmpty()) throw new SQLException("Tên file là bắt buộc");
        if (url == null || url.trim().isEmpty()) throw new SQLException("URL file là bắt buộc");
        return insert("INSERT INTO submissions(group_id,progress_report_id,type,file_name,file_url,public_id,resource_type,file_size,submitted_by_id) " +
            "VALUES(?,?,?,?,?,?,?,?,?)",groupId,reportId,type,fileName,url,publicId,resourceType,bytes,studentId);
    }
    public Map<String,Object> submission(long id) throws SQLException {
        return one("SELECT submission_id AS id,* FROM submissions WHERE submission_id=?",id);
    }
    public int deleteSubmission(long id) throws SQLException { return update("DELETE FROM submissions WHERE submission_id=?",id); }
}
