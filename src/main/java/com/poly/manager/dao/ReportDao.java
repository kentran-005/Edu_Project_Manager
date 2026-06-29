package com.poly.manager.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ReportDao extends BaseDao {
    public long create(long groupId,int week,String title,String completed,String nextPlan,String difficulties) throws SQLException {
        return insert("INSERT INTO progress_reports(group_id,week_number,title,completed_work,next_plan,difficulties,report_date,status) " +
            "VALUES(?,?,?,?,?,?,?,'SUBMITTED')",groupId,week,title,completed,nextPlan,difficulties, LocalDate.now());
    }
    public List<Map<String,Object>> findByGroup(long groupId) throws SQLException {
        return query("SELECT * FROM progress_reports WHERE group_id=? ORDER BY week_number DESC",groupId);
    }
    public long feedback(long groupId,Long reportId,Long submissionId,long lecturerId,String content) throws SQLException {
        if(reportId!=null) update("UPDATE progress_reports SET status='REVIEWED',updated_at=SYSDATETIME() WHERE id=? AND group_id=?",reportId,groupId);
        return insert("INSERT INTO feedbacks(group_id,progress_report_id,submission_id,lecturer_id,content) VALUES(?,?,?,?,?)",
            groupId,reportId,submissionId,lecturerId,content);
    }
    public List<Map<String,Object>> feedbackByGroup(long groupId) throws SQLException {
        return query("SELECT f.*,u.full_name lecturer_name FROM feedbacks f " +
            "JOIN lecturers l ON l.id=f.lecturer_id JOIN users u ON u.id=l.user_id " +
            "WHERE f.group_id=? ORDER BY f.created_at DESC",groupId);
    }
    public List<Map<String,Object>> submissions(long groupId) throws SQLException {
        return query("SELECT sub.*,u.full_name submitted_by_name FROM submissions sub " +
            "JOIN students s ON s.id=sub.submitted_by_id JOIN users u ON u.id=s.user_id " +
            "WHERE sub.group_id=? ORDER BY sub.created_at DESC",groupId);
    }
    public long saveSubmission(long groupId,Long reportId,String type,String fileName,String url,
                               String publicId,String resourceType,long bytes,long studentId) throws SQLException {
        return insert("INSERT INTO submissions(group_id,progress_report_id,type,file_name,file_url,public_id,resource_type,file_size,submitted_by_id) " +
            "VALUES(?,?,?,?,?,?,?,?,?)",groupId,reportId,type,fileName,url,publicId,resourceType,bytes,studentId);
    }
    public Map<String,Object> submission(long id) throws SQLException {
        return one("SELECT * FROM submissions WHERE id=?",id);
    }
    public int deleteSubmission(long id) throws SQLException { return update("DELETE FROM submissions WHERE id=?",id); }
}
