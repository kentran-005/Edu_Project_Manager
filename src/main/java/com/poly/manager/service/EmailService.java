package com.poly.manager.service;

import com.poly.manager.config.AppConfig;
import com.poly.manager.dao.BaseDao;
import com.poly.manager.dao.GroupDao;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailService {
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final ExecutorService EXECUTOR = Executors.newCachedThreadPool();

    private final GroupDao groupDao = new GroupDao();
    private final EmailDao emailDao = new EmailDao();

    /**
     * Send an HTML formatted email asynchronously.
     * Safely logs and skips if SMTP settings are unconfigured or placeholder.
     */
    public void sendHtmlEmail(String toEmail, String subject, String bodyHtml) {
        if (toEmail == null || toEmail.trim().isEmpty()) return;

        String host = AppConfig.get("mail.smtp.host");
        String port = AppConfig.get("mail.smtp.port");
        String username = AppConfig.get("mail.smtp.username");
        String password = AppConfig.get("mail.smtp.password");
        String fromEmail = AppConfig.get("mail.from");
        String fromName = AppConfig.get("mail.from.name");

        // Skip if SMTP settings are missing or unconfigured placeholders
        if (host.isEmpty() || username.isEmpty() || password.isEmpty()
                || "your_email@gmail.com".equalsIgnoreCase(username)
                || "your_app_password".equalsIgnoreCase(password)) {
            LOGGER.info("Email notification to [" + toEmail + "] skipped: SMTP credentials not configured in application.properties.");
            return;
        }

        EXECUTOR.submit(() -> {
            try {
                Properties props = new Properties();
                props.put("mail.smtp.host", host);
                props.put("mail.smtp.port", port.isEmpty() ? "587" : port);
                props.put("mail.smtp.auth", AppConfig.get("mail.smtp.auth").isEmpty() ? "true" : AppConfig.get("mail.smtp.auth"));
                props.put("mail.smtp.starttls.enable", AppConfig.get("mail.smtp.starttls.enable").isEmpty() ? "true" : AppConfig.get("mail.smtp.starttls.enable"));

                Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

                MimeMessage message = new MimeMessage(session);
                String from = fromEmail.isEmpty() ? username : fromEmail;
                String displayName = fromName.isEmpty() ? "Edu Project Manager" : fromName;

                message.setFrom(new InternetAddress(from, displayName, "UTF-8"));
                message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail.trim()));
                message.setSubject(subject, "UTF-8");
                message.setContent(bodyHtml, "text/html; charset=UTF-8");

                Transport.send(message);
                LOGGER.info("Successfully sent email to [" + toEmail + "], Subject: " + subject);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to send email to [" + toEmail + "]: " + e.getMessage(), e);
            }
        });
    }

    /**
     * Notify Lecturer when a student submits a progress report.
     */
    public void notifyLecturerOnReportSubmission(long groupId, String reportTitle, String studentName) {
        try {
            Map<String, Object> group = groupDao.find(groupId);
            if (group == null) return;
            String lecturerEmail = (String) group.get("lecturer_email");
            String lecturerName = (String) group.get("lecturer_name");
            String groupName = (String) group.get("group_name");
            String topicTitle = (String) group.get("topic_title");

            if (lecturerEmail != null && !lecturerEmail.trim().isEmpty()) {
                String subject = "[Edu Project] Sinh viên nộp báo cáo - Nhóm: " + groupName;
                String html = buildEmailTemplate(
                    "Thông báo nộp báo cáo tiến độ",
                    "Kính gửi thầy/cô " + (lecturerName != null ? lecturerName : "") + ",<br><br>"
                    + "Sinh viên <strong>" + studentName + "</strong> thuộc nhóm <strong>" + groupName + "</strong> "
                    + "(Đề tài: <em>" + (topicTitle != null ? topicTitle : "Chưa có") + "</em>) vừa nộp một báo cáo tiến độ mới:<br>"
                    + "<strong>Tiêu đề báo cáo:</strong> " + reportTitle + "<br><br>"
                    + "Thầy/cô vui lòng đăng nhập hệ thống để xem chi tiết và nhận xét bài làm."
                );
                sendHtmlEmail(lecturerEmail, subject, html);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error building report submission email: " + e.getMessage(), e);
        }
    }

    /**
     * Notify Lecturer when a student uploads a project submission file.
     */
    public void notifyLecturerOnProjectSubmission(long groupId, String fileName, String studentName) {
        try {
            Map<String, Object> group = groupDao.find(groupId);
            if (group == null) return;
            String lecturerEmail = (String) group.get("lecturer_email");
            String lecturerName = (String) group.get("lecturer_name");
            String groupName = (String) group.get("group_name");

            if (lecturerEmail != null && !lecturerEmail.trim().isEmpty()) {
                String subject = "[Edu Project] Sinh viên nộp bài làm - Nhóm: " + groupName;
                String html = buildEmailTemplate(
                    "Thông báo nộp bài đồ án",
                    "Kính gửi thầy/cô " + (lecturerName != null ? lecturerName : "") + ",<br><br>"
                    + "Sinh viên <strong>" + studentName + "</strong> thuộc nhóm <strong>" + groupName + "</strong> "
                    + "vừa nộp tài liệu bài làm mới:<br>"
                    + "<strong>Tên file:</strong> " + fileName + "<br><br>"
                    + "Thầy/cô vui lòng vào hệ thống để tải về và kiểm tra."
                );
                sendHtmlEmail(lecturerEmail, subject, html);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error building project submission email: " + e.getMessage(), e);
        }
    }

    /**
     * Notify Student group members when Lecturer approves/rejects topic registration.
     */
    public void notifyStudentsOnTopicReview(long registrationId, String status, String note) {
        try {
            Map<String, Object> reg = emailDao.findRegistration(registrationId);
            if (reg == null) return;
            long groupId = ((Number) reg.get("group_id")).longValue();
            String topicTitle = (String) reg.get("topic_title");
            String groupName = (String) reg.get("group_name");

            List<Map<String, Object>> members = groupDao.members(groupId);
            String statusText = "APPROVED".equals(status) ? "ĐÃ ĐƯỢC DUYỆT" : "ĐÃ BỊ TỪ CHỐI";

            for (Map<String, Object> m : members) {
                String studentEmail = (String) m.get("email");
                String studentName = (String) m.get("full_name");
                if (studentEmail != null && !studentEmail.trim().isEmpty()) {
                    String subject = "[Edu Project] Kết quả duyệt đăng ký đề tài - " + groupName;
                    String html = buildEmailTemplate(
                        "Kết quả duyệt đề tài đồ án",
                        "Chào bạn <strong>" + studentName + "</strong>,<br><br>"
                        + "Giảng viên hướng dẫn đã xử lý đăng ký đề tài cho nhóm <strong>" + groupName + "</strong>:<br>"
                        + "<strong>Đề tài:</strong> " + topicTitle + "<br>"
                        + "<strong>Trạng thái:</strong> <span style='color:" + ("APPROVED".equals(status) ? "#16a34a" : "#dc2626") + ";font-weight:bold;'>" + statusText + "</span><br>"
                        + (note != null && !note.trim().isEmpty() ? "<strong>Ghi chú từ GV:</strong> " + note + "<br><br>" : "<br>")
                        + "Vui lòng đăng nhập hệ thống để theo dõi thông tin chi tiết."
                    );
                    sendHtmlEmail(studentEmail, subject, html);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error building topic review email: " + e.getMessage(), e);
        }
    }

    /**
     * Notify Student group members when Lecturer adds a feedback comment.
     */
    public void notifyStudentsOnFeedback(long groupId, String feedbackContent, String lecturerName) {
        try {
            Map<String, Object> group = groupDao.find(groupId);
            if (group == null) return;
            String groupName = (String) group.get("group_name");
            String topicTitle = (String) group.get("topic_title");

            List<Map<String, Object>> members = groupDao.members(groupId);
            for (Map<String, Object> m : members) {
                String studentEmail = (String) m.get("email");
                String studentName = (String) m.get("full_name");
                if (studentEmail != null && !studentEmail.trim().isEmpty()) {
                    String subject = "[Edu Project] Nhận xét mới từ Giảng viên - Nhóm: " + groupName;
                    String html = buildEmailTemplate(
                        "Nhận xét mới từ Giảng viên",
                        "Chào bạn <strong>" + studentName + "</strong> (Nhóm " + groupName + "),<br><br>"
                        + "Giảng viên <strong>" + (lecturerName != null ? lecturerName : "") + "</strong> vừa gửi nhận xét mới cho đồ án <em>" + (topicTitle != null ? topicTitle : "") + "</em>:<br>"
                        + "<blockquote style='border-left:4px solid #2563eb;padding-left:12px;margin:12px 0;color:#334155;'>"
                        + feedbackContent + "</blockquote><br>"
                        + "Vui lòng kiểm tra và chỉnh sửa bài nộp theo nhận xét của Giảng viên."
                    );
                    sendHtmlEmail(studentEmail, subject, html);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error building feedback email: " + e.getMessage(), e);
        }
    }

    /**
     * Notify Student when Lecturer enters/updates grades.
     */
    public void notifyStudentOnGradeUpdate(long studentId, double score, String comment, String status) {
        try {
            Map<String, Object> student = emailDao.findStudentUser(studentId);
            if (student == null) return;
            String studentEmail = (String) student.get("email");
            String studentName = (String) student.get("full_name");

            if (studentEmail != null && !studentEmail.trim().isEmpty()) {
                String subject = "[Edu Project] Thông báo kết quả điểm đồ án";
                String html = buildEmailTemplate(
                    "Cập nhật điểm đồ án",
                    "Chào bạn <strong>" + studentName + "</strong>,<br><br>"
                    + "Giảng viên vừa cập nhật thông tin điểm số đồ án của bạn:<br>"
                    + "<strong>Điểm số:</strong> <span style='font-size:18px;font-weight:bold;color:#2563eb;'>" + score + " / 10</span><br>"
                    + (comment != null && !comment.trim().isEmpty() ? "<strong>Nhận xét:</strong> " + comment + "<br>" : "")
                    + "<strong>Trạng thái công bố:</strong> " + ("PUBLISHED".equalsIgnoreCase(status) ? "Đã công bố" : "Tạm lưu") + "<br><br>"
                    + "Bạn có thể đăng nhập vào hệ thống để tra cứu kết quả chi tiết."
                );
                sendHtmlEmail(studentEmail, subject, html);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error building grade update email: " + e.getMessage(), e);
        }
    }

    /**
     * Standard HTML email wrapper template.
     */
    private String buildEmailTemplate(String headerTitle, String bodyContent) {
        return "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
            + "<body style='font-family:Arial,sans-serif;background-color:#f8fafc;color:#0f172a;margin:0;padding:20px;'>"
            + "<div style='max-width:600px;margin:0 auto;background:#ffffff;border-radius:12px;padding:30px;border:1px solid #e2e8f0;box-shadow:0 4px 12px rgba(0,0,0,0.05);'>"
            + "<div style='display:flex;align-items:center;margin-bottom:20px;border-bottom:2px solid #2563eb;padding-bottom:12px;'>"
            + "<h2 style='color:#2563eb;margin:0;font-size:20px;'>" + headerTitle + "</h2>"
            + "</div>"
            + "<div style='font-size:14px;line-height:1.6;color:#334155;'>"
            + bodyContent
            + "</div>"
            + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:25px 0 15px 0;'>"
            + "<div style='font-size:12px;color:#94a3b8;text-align:center;'>"
            + "Đây là email tự động từ Hệ thống Quản lý Đồ án Sinh viên (Edu Project Manager). Vui lòng không trả lời trực tiếp email này."
            + "</div></div></body></html>";
    }

    /**
     * Internal helper DAO for specific email queries.
     */
    private static class EmailDao extends BaseDao {
        public Map<String, Object> findRegistration(long registrationId) throws SQLException {
            return one("SELECT r.registration_id, r.group_id, r.status, t.title AS topic_title, g.group_name " +
                       "FROM project_registrations r " +
                       "JOIN project_groups g ON g.group_id=r.group_id " +
                       "JOIN topics t ON t.topic_id=r.topic_id " +
                       "WHERE r.registration_id=?", registrationId);
        }

        public Map<String, Object> findStudentUser(long studentId) throws SQLException {
            return one("SELECT u.email, u.full_name FROM students s " +
                       "JOIN users u ON u.user_id=s.user_id " +
                       "WHERE s.student_id=?", studentId);
        }
    }
}
