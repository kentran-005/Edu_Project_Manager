package com.poly.manager.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class TopicDao extends BaseDao {
    public List<Map<String,Object>> findAll(Long semesterId,String status) throws SQLException {
        StringBuilder sql=new StringBuilder(
            "SELECT t.*,u.full_name lecturer_name,s.name semester_name FROM topics t " +
            "JOIN lecturers l ON l.id=t.lecturer_id JOIN users u ON u.id=l.user_id " +
            "JOIN semesters s ON s.id=t.semester_id WHERE 1=1");
        java.util.List<Object> args=new java.util.ArrayList<Object>();
        if (semesterId!=null) { sql.append(" AND t.semester_id=?"); args.add(semesterId); }
        if (status!=null && !status.isEmpty()) { sql.append(" AND t.status=?"); args.add(status); }
        sql.append(" ORDER BY t.created_at DESC");
        return query(sql.toString(),args.toArray());
    }
    public List<Map<String,Object>> findByLecturer(long userId) throws SQLException {
        return query("SELECT t.*,s.name semester_name FROM topics t JOIN semesters s ON s.id=t.semester_id " +
            "JOIN lecturers l ON l.id=t.lecturer_id WHERE l.user_id=? ORDER BY t.created_at DESC",userId);
    }
    public Map<String,Object> find(long id) throws SQLException {
        return one("SELECT t.*,u.full_name lecturer_name,s.name semester_name FROM topics t " +
            "JOIN lecturers l ON l.id=t.lecturer_id JOIN users u ON u.id=l.user_id " +
            "JOIN semesters s ON s.id=t.semester_id WHERE t.id=?",id);
    }
    public long create(long lecturerId,long semesterId,String title,String description,String requirements,
                       String technology,int maxMembers,String status) throws SQLException {
        return insert("INSERT INTO topics(lecturer_id,semester_id,title,description,requirements,technology,max_members,status) " +
            "VALUES(?,?,?,?,?,?,?,?)",lecturerId,semesterId,title,description,requirements,technology,maxMembers,status);
    }
    public int update(long id,long lecturerId,String title,String description,String requirements,
                      String technology,int maxMembers,String status) throws SQLException {
        return update("UPDATE topics SET title=?,description=?,requirements=?,technology=?,max_members=?,status=?,updated_at=SYSDATETIME() " +
            "WHERE id=? AND lecturer_id=? AND status<>'ASSIGNED'",
            title,description,requirements,technology,maxMembers,status,id,lecturerId);
    }
    public Long lecturerIdByUser(long userId) throws SQLException {
        Map<String,Object> row=one("SELECT id FROM lecturers WHERE user_id=?",userId);
        return row==null?null:((Number)row.get("id")).longValue();
    }
}
