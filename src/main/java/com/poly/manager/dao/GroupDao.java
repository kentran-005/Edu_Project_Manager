package com.poly.manager.dao;

import com.poly.manager.util.InviteCodeUtils;

import java.sql.*;
import java.util.List;
import java.util.Map;

public class GroupDao extends BaseDao {
    public Long studentIdByUser(long userId) throws SQLException {
        Map<String,Object> row=one("SELECT id FROM students WHERE user_id=?",userId);
        return row==null?null:((Number)row.get("id")).longValue();
    }
    public long create(final long studentId,final long semesterId,final String groupName) throws SQLException {
        if (one("SELECT gm.id FROM group_members gm JOIN project_groups g ON g.id=gm.group_id " +
                "WHERE gm.student_id=? AND g.semester_id=?",studentId,semesterId)!=null)
            throw new SQLException("Sinh viên đã thuộc một nhóm trong học kỳ");
        final long[] id=new long[1];
        transaction(new TransactionWork() {
            public void execute(Connection c) throws Exception {
                try (PreparedStatement ps=c.prepareStatement(
                        "INSERT INTO project_groups(group_name,invite_code,semester_id,status) VALUES(?,?,?,'FORMING')",
                        Statement.RETURN_GENERATED_KEYS)) {
                    bind(ps,groupName, InviteCodeUtils.generate(),semesterId); ps.executeUpdate();
                    try(ResultSet keys=ps.getGeneratedKeys()){keys.next();id[0]=keys.getLong(1);}
                }
                try(PreparedStatement ps=c.prepareStatement(
                        "INSERT INTO group_members(group_id,student_id,role) VALUES(?,?,'LEADER')")){
                    bind(ps,id[0],studentId);ps.executeUpdate();
                }
            }
        });
        return id[0];
    }
    public void join(long studentId,String inviteCode) throws SQLException {
        Map<String,Object> group=one("SELECT * FROM project_groups WHERE invite_code=? AND status='FORMING'",inviteCode);
        if(group==null) throw new SQLException("Mã mời không hợp lệ hoặc nhóm đã khóa");
        long semesterId=((Number)group.get("semester_id")).longValue();
        if(one("SELECT gm.id FROM group_members gm JOIN project_groups g ON g.id=gm.group_id " +
                "WHERE gm.student_id=? AND g.semester_id=?",studentId,semesterId)!=null)
            throw new SQLException("Sinh viên đã thuộc nhóm trong học kỳ");
        update("INSERT INTO group_members(group_id,student_id,role) VALUES(?,?,'MEMBER')",group.get("id"),studentId);
    }
    public Map<String,Object> find(long id) throws SQLException {
        return one("SELECT g.*,t.title topic_title,s.name semester_name,u.full_name lecturer_name " +
            "FROM project_groups g LEFT JOIN topics t ON t.id=g.topic_id " +
            "LEFT JOIN lecturers l ON l.id=t.lecturer_id LEFT JOIN users u ON u.id=l.user_id " +
            "JOIN semesters s ON s.id=g.semester_id WHERE g.id=?",id);
    }
    public List<Map<String,Object>> members(long groupId) throws SQLException {
        return query("SELECT gm.*,s.student_code,u.full_name,u.email FROM group_members gm " +
            "JOIN students s ON s.id=gm.student_id JOIN users u ON u.id=s.user_id WHERE gm.group_id=? ORDER BY gm.role DESC",groupId);
    }
    public Map<String,Object> membership(long groupId,long userId) throws SQLException {
        return one("SELECT gm.*,s.user_id FROM group_members gm JOIN students s ON s.id=gm.student_id " +
            "WHERE gm.group_id=? AND s.user_id=?",groupId,userId);
    }
    public boolean isSupervisor(long groupId,long userId) throws SQLException {
        return one("SELECT g.id FROM project_groups g JOIN topics t ON t.id=g.topic_id " +
            "JOIN lecturers l ON l.id=t.lecturer_id WHERE g.id=? AND l.user_id=?",groupId,userId)!=null;
    }
    public List<Map<String,Object>> groupsForUser(long userId,String role) throws SQLException {
        if("ADMIN".equals(role)) return query("SELECT g.*,t.title topic_title FROM project_groups g LEFT JOIN topics t ON t.id=g.topic_id ORDER BY g.created_at DESC");
        if("LECTURER".equals(role)) return query("SELECT g.*,t.title topic_title FROM project_groups g JOIN topics t ON t.id=g.topic_id " +
            "JOIN lecturers l ON l.id=t.lecturer_id WHERE l.user_id=? ORDER BY g.created_at DESC",userId);
        return query("SELECT g.*,t.title topic_title,gm.role member_role FROM project_groups g " +
            "JOIN group_members gm ON gm.group_id=g.id JOIN students s ON s.id=gm.student_id " +
            "LEFT JOIN topics t ON t.id=g.topic_id WHERE s.user_id=? ORDER BY g.created_at DESC",userId);
    }
    public long register(long groupId,long topicId,String note,long userId) throws SQLException {
        Map<String,Object> member=membership(groupId,userId);
        if(member==null || !"LEADER".equals(member.get("role"))) throw new SQLException("Chỉ trưởng nhóm được đăng ký đề tài");
        if(one("SELECT id FROM project_registrations WHERE group_id=? AND status IN('PENDING','APPROVED')",groupId)!=null)
            throw new SQLException("Nhóm đã có đăng ký đang xử lý");
        update("UPDATE project_groups SET status='REGISTERED',updated_at=SYSDATETIME() WHERE id=?",groupId);
        return insert("INSERT INTO project_registrations(group_id,topic_id,status,note) VALUES(?,?,'PENDING',?)",groupId,topicId,note);
    }
    public List<Map<String,Object>> registrationsForLecturer(long userId) throws SQLException {
        return query("SELECT r.*,g.group_name,t.title topic_title FROM project_registrations r " +
            "JOIN project_groups g ON g.id=r.group_id JOIN topics t ON t.id=r.topic_id " +
            "JOIN lecturers l ON l.id=t.lecturer_id WHERE l.user_id=? ORDER BY r.created_at DESC",userId);
    }
    public void review(final long registrationId,final long lecturerId,final String status,final String note) throws SQLException {
        transaction(new TransactionWork() {
            public void execute(Connection c) throws Exception {
                Map<String,Object> r;
                try(PreparedStatement ps=c.prepareStatement("SELECT r.* FROM project_registrations r JOIN topics t ON t.id=r.topic_id " +
                        "WHERE r.id=? AND t.lecturer_id=? AND r.status='PENDING'")){
                    bind(ps,registrationId,lecturerId);
                    try(ResultSet rs=ps.executeQuery()){
                        if(!rs.next()) throw new SQLException("Đăng ký không tồn tại hoặc không thuộc giảng viên");
                        r=new java.util.HashMap<String,Object>();
                        r.put("group_id",rs.getLong("group_id"));r.put("topic_id",rs.getLong("topic_id"));
                    }
                }
                try(PreparedStatement ps=c.prepareStatement("UPDATE project_registrations SET status=?,note=?,reviewed_by_id=?,reviewed_at=SYSDATETIME(),updated_at=SYSDATETIME() WHERE id=?")){
                    bind(ps,status,note,lecturerId,registrationId);ps.executeUpdate();
                }
                if("APPROVED".equals(status)){
                    try(PreparedStatement ps=c.prepareStatement("UPDATE project_groups SET topic_id=?,status='IN_PROGRESS',updated_at=SYSDATETIME() WHERE id=?")){
                        bind(ps,r.get("topic_id"),r.get("group_id"));ps.executeUpdate();
                    }
                    try(PreparedStatement ps=c.prepareStatement("UPDATE topics SET status='ASSIGNED',updated_at=SYSDATETIME() WHERE id=?")){
                        bind(ps,r.get("topic_id"));ps.executeUpdate();
                    }
                }else{
                    try(PreparedStatement ps=c.prepareStatement("UPDATE project_groups SET status='FORMING',updated_at=SYSDATETIME() WHERE id=?")){
                        bind(ps,r.get("group_id"));ps.executeUpdate();
                    }
                }
            }
        });
    }
}
