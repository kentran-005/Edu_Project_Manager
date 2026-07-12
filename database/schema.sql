IF DB_ID(N'Manager_Edu_Project') IS NULL
BEGIN
    CREATE DATABASE [Manager_Edu_Project];
END;
GO

USE [Manager_Edu_Project];
GO

/* =========================================================
   DROP TABLES - đúng thứ tự phụ thuộc khóa ngoại
   ========================================================= */
IF OBJECT_ID(N'dbo.grades', N'U') IS NOT NULL DROP TABLE dbo.grades;
IF OBJECT_ID(N'dbo.feedbacks', N'U') IS NOT NULL DROP TABLE dbo.feedbacks;
IF OBJECT_ID(N'dbo.submissions', N'U') IS NOT NULL DROP TABLE dbo.submissions;
IF OBJECT_ID(N'dbo.progress_reports', N'U') IS NOT NULL DROP TABLE dbo.progress_reports;
IF OBJECT_ID(N'dbo.project_registrations', N'U') IS NOT NULL DROP TABLE dbo.project_registrations;
IF OBJECT_ID(N'dbo.group_members', N'U') IS NOT NULL DROP TABLE dbo.group_members;
IF OBJECT_ID(N'dbo.project_groups', N'U') IS NOT NULL DROP TABLE dbo.project_groups;
IF OBJECT_ID(N'dbo.topics', N'U') IS NOT NULL DROP TABLE dbo.topics;
IF OBJECT_ID(N'dbo.students', N'U') IS NOT NULL DROP TABLE dbo.students;
IF OBJECT_ID(N'dbo.academic_classes', N'U') IS NOT NULL DROP TABLE dbo.academic_classes;
IF OBJECT_ID(N'dbo.lecturers', N'U') IS NOT NULL DROP TABLE dbo.lecturers;
IF OBJECT_ID(N'dbo.semesters', N'U') IS NOT NULL DROP TABLE dbo.semesters;
IF OBJECT_ID(N'dbo.users', N'U') IS NOT NULL DROP TABLE dbo.users;
GO

/* =========================================================
   1. USERS
   ========================================================= */
CREATE TABLE dbo.users (
    user_id     BIGINT IDENTITY(1,1) NOT NULL,
    username    NVARCHAR(50)         NOT NULL,
    email       NVARCHAR(255)        NOT NULL,
    password    NVARCHAR(255)        NOT NULL,
    full_name   NVARCHAR(120)        NOT NULL,
    phone       NVARCHAR(20)         NULL,
    avatar_url  NVARCHAR(1000)       NULL,
    role        VARCHAR(20)          NOT NULL,
    status      VARCHAR(20)          NOT NULL
        CONSTRAINT DF_users_status DEFAULT ('ACTIVE'),
    created_at  DATETIME2           NOT NULL
        CONSTRAINT DF_users_created_at DEFAULT SYSDATETIME(),
    updated_at  DATETIME2           NOT NULL
        CONSTRAINT DF_users_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_users PRIMARY KEY CLUSTERED (user_id),
    CONSTRAINT UQ_users_username UNIQUE (username),
    CONSTRAINT UQ_users_email UNIQUE (email),
    CONSTRAINT CK_users_username_not_blank CHECK (LEN(LTRIM(RTRIM(username))) > 0),
    CONSTRAINT CK_users_email_not_blank CHECK (LEN(LTRIM(RTRIM(email))) > 0),
    CONSTRAINT CK_users_password_not_blank CHECK (LEN(LTRIM(RTRIM(password))) > 0),
    CONSTRAINT CK_users_full_name_not_blank CHECK (LEN(LTRIM(RTRIM(full_name))) > 0),
    CONSTRAINT CK_users_role CHECK (role IN ('ADMIN', 'LECTURER', 'STUDENT')),
    CONSTRAINT CK_users_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),
    CONSTRAINT CK_users_phone CHECK (phone IS NULL OR LEN(LTRIM(RTRIM(phone))) > 0),
    CONSTRAINT CK_users_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   2. LECTURERS
   ========================================================= */
CREATE TABLE dbo.lecturers (
    lecturer_id   BIGINT IDENTITY(1,1) NOT NULL,
    lecturer_code NVARCHAR(30)         NOT NULL,
    user_id       BIGINT               NOT NULL,
    department    NVARCHAR(255)        NULL,
    academic_rank NVARCHAR(100)        NULL,
    created_at    DATETIME2            NOT NULL
        CONSTRAINT DF_lecturers_created_at DEFAULT SYSDATETIME(),
    updated_at    DATETIME2            NOT NULL
        CONSTRAINT DF_lecturers_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_lecturers PRIMARY KEY CLUSTERED (lecturer_id),
    CONSTRAINT UQ_lecturers_lecturer_code UNIQUE (lecturer_code),
    CONSTRAINT UQ_lecturers_user_id UNIQUE (user_id),
    CONSTRAINT FK_lecturers_users FOREIGN KEY (user_id)
        REFERENCES dbo.users(user_id),
    CONSTRAINT CK_lecturers_lecturer_code_not_blank CHECK (LEN(LTRIM(RTRIM(lecturer_code))) > 0),
    CONSTRAINT CK_lecturers_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   3. ACADEMIC_CLASSES
   ========================================================= */
CREATE TABLE dbo.academic_classes (
    class_id    BIGINT IDENTITY(1,1) NOT NULL,
    code        NVARCHAR(30)         NOT NULL,
    name        NVARCHAR(255)        NOT NULL,
    major       NVARCHAR(255)        NULL,
    intake_year INT                  NULL,
    advisor_id  BIGINT               NULL,
    created_at  DATETIME2            NOT NULL
        CONSTRAINT DF_academic_classes_created_at DEFAULT SYSDATETIME(),
    updated_at  DATETIME2            NOT NULL
        CONSTRAINT DF_academic_classes_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_academic_classes PRIMARY KEY CLUSTERED (class_id),
    CONSTRAINT UQ_academic_classes_code UNIQUE (code),
    CONSTRAINT FK_academic_classes_lecturers_advisor FOREIGN KEY (advisor_id)
        REFERENCES dbo.lecturers(lecturer_id),
    CONSTRAINT CK_academic_classes_code_not_blank CHECK (LEN(LTRIM(RTRIM(code))) > 0),
    CONSTRAINT CK_academic_classes_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
    CONSTRAINT CK_academic_classes_intake_year CHECK (intake_year IS NULL OR intake_year BETWEEN 1990 AND 2100),
    CONSTRAINT CK_academic_classes_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   4. STUDENTS
   ========================================================= */
CREATE TABLE dbo.students (
    student_id   BIGINT IDENTITY(1,1) NOT NULL,
    student_code NVARCHAR(30)         NOT NULL,
    user_id      BIGINT               NOT NULL,
    class_id     BIGINT               NULL,
    created_at   DATETIME2            NOT NULL
        CONSTRAINT DF_students_created_at DEFAULT SYSDATETIME(),
    updated_at   DATETIME2            NOT NULL
        CONSTRAINT DF_students_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_students PRIMARY KEY CLUSTERED (student_id),
    CONSTRAINT UQ_students_student_code UNIQUE (student_code),
    CONSTRAINT UQ_students_user_id UNIQUE (user_id),
    CONSTRAINT FK_students_users FOREIGN KEY (user_id)
        REFERENCES dbo.users(user_id),
    CONSTRAINT FK_students_academic_classes FOREIGN KEY (class_id)
        REFERENCES dbo.academic_classes(class_id),
    CONSTRAINT CK_students_student_code_not_blank CHECK (LEN(LTRIM(RTRIM(student_code))) > 0),
    CONSTRAINT CK_students_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   5. SEMESTERS
   ========================================================= */
CREATE TABLE dbo.semesters (
    semester_id           BIGINT IDENTITY(1,1) NOT NULL,
    code                  NVARCHAR(30)         NOT NULL,
    name                  NVARCHAR(255)        NOT NULL,
    start_date            DATE                 NOT NULL,
    end_date              DATE                 NOT NULL,
    registration_deadline DATE                 NULL,
    status                VARCHAR(20)          NOT NULL,
    created_at            DATETIME2            NOT NULL
        CONSTRAINT DF_semesters_created_at DEFAULT SYSDATETIME(),
    updated_at            DATETIME2            NOT NULL
        CONSTRAINT DF_semesters_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_semesters PRIMARY KEY CLUSTERED (semester_id),
    CONSTRAINT UQ_semesters_code UNIQUE (code),
    CONSTRAINT CK_semesters_code_not_blank CHECK (LEN(LTRIM(RTRIM(code))) > 0),
    CONSTRAINT CK_semesters_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
    CONSTRAINT CK_semesters_date_range CHECK (end_date > start_date),
    CONSTRAINT CK_semesters_registration_deadline CHECK (registration_deadline IS NULL OR registration_deadline <= end_date),
    CONSTRAINT CK_semesters_status CHECK (status IN ('UPCOMING', 'ACTIVE', 'CLOSED')),
    CONSTRAINT CK_semesters_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   6. TOPICS
   ========================================================= */
CREATE TABLE dbo.topics (
    topic_id     BIGINT IDENTITY(1,1) NOT NULL,
    title        NVARCHAR(255)        NOT NULL,
    description  NVARCHAR(MAX)        NOT NULL,
    requirements NVARCHAR(MAX)        NULL,
    technology   NVARCHAR(255)        NULL,
    max_members  INT                  NOT NULL
        CONSTRAINT DF_topics_max_members DEFAULT (3),
    lecturer_id  BIGINT               NOT NULL,
    semester_id  BIGINT               NOT NULL,
    status       VARCHAR(20)          NOT NULL
        CONSTRAINT DF_topics_status DEFAULT ('DRAFT'),
    created_at   DATETIME2            NOT NULL
        CONSTRAINT DF_topics_created_at DEFAULT SYSDATETIME(),
    updated_at   DATETIME2            NOT NULL
        CONSTRAINT DF_topics_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_topics PRIMARY KEY CLUSTERED (topic_id),
    CONSTRAINT FK_topics_lecturers FOREIGN KEY (lecturer_id)
        REFERENCES dbo.lecturers(lecturer_id),
    CONSTRAINT FK_topics_semesters FOREIGN KEY (semester_id)
        REFERENCES dbo.semesters(semester_id),
    CONSTRAINT CK_topics_title_not_blank CHECK (LEN(LTRIM(RTRIM(title))) > 0),
    CONSTRAINT CK_topics_description_not_blank CHECK (LEN(LTRIM(RTRIM(description))) > 0),
    CONSTRAINT CK_topics_max_members CHECK (max_members BETWEEN 1 AND 10),
    CONSTRAINT CK_topics_status CHECK (status IN ('DRAFT', 'OPEN', 'ASSIGNED', 'CLOSED')),
    CONSTRAINT CK_topics_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   7. PROJECT_GROUPS
   ========================================================= */
CREATE TABLE dbo.project_groups (
    group_id    BIGINT IDENTITY(1,1) NOT NULL,
    group_name  NVARCHAR(255)        NOT NULL,
    invite_code VARCHAR(20)          NOT NULL,
    semester_id BIGINT               NOT NULL,
    topic_id    BIGINT               NULL,
    status      VARCHAR(20)          NOT NULL
        CONSTRAINT DF_project_groups_status DEFAULT ('FORMING'),
    created_at  DATETIME2            NOT NULL
        CONSTRAINT DF_project_groups_created_at DEFAULT SYSDATETIME(),
    updated_at  DATETIME2            NOT NULL
        CONSTRAINT DF_project_groups_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_project_groups PRIMARY KEY CLUSTERED (group_id),
    CONSTRAINT UQ_project_groups_invite_code UNIQUE (invite_code),
    CONSTRAINT FK_project_groups_semesters FOREIGN KEY (semester_id)
        REFERENCES dbo.semesters(semester_id),
    CONSTRAINT FK_project_groups_topics FOREIGN KEY (topic_id)
        REFERENCES dbo.topics(topic_id),
    CONSTRAINT CK_project_groups_group_name_not_blank CHECK (LEN(LTRIM(RTRIM(group_name))) > 0),
    CONSTRAINT CK_project_groups_invite_code_not_blank CHECK (LEN(LTRIM(RTRIM(invite_code))) >= 6),
    CONSTRAINT CK_project_groups_status CHECK (status IN ('FORMING', 'REGISTERED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT CK_project_groups_topic_required CHECK (
        (status IN ('FORMING', 'REGISTERED', 'CANCELLED') AND topic_id IS NULL)
        OR (status IN ('IN_PROGRESS', 'COMPLETED') AND topic_id IS NOT NULL)
    ),
    CONSTRAINT CK_project_groups_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   8. GROUP_MEMBERS
   ========================================================= */
CREATE TABLE dbo.group_members (
    group_member_id BIGINT IDENTITY(1,1) NOT NULL,
    group_id        BIGINT               NOT NULL,
    student_id      BIGINT               NOT NULL,
    role            VARCHAR(20)          NOT NULL,
    joined_at       DATETIME2            NOT NULL
        CONSTRAINT DF_group_members_joined_at DEFAULT SYSDATETIME(),
    created_at      DATETIME2            NOT NULL
        CONSTRAINT DF_group_members_created_at DEFAULT SYSDATETIME(),
    updated_at      DATETIME2            NOT NULL
        CONSTRAINT DF_group_members_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_group_members PRIMARY KEY CLUSTERED (group_member_id),
    CONSTRAINT UQ_group_members_group_student UNIQUE (group_id, student_id),
    CONSTRAINT FK_group_members_project_groups FOREIGN KEY (group_id)
        REFERENCES dbo.project_groups(group_id) ON DELETE CASCADE,
    CONSTRAINT FK_group_members_students FOREIGN KEY (student_id)
        REFERENCES dbo.students(student_id),
    CONSTRAINT CK_group_members_role CHECK (role IN ('LEADER', 'MEMBER')),
    CONSTRAINT CK_group_members_updated_at CHECK (updated_at >= created_at),
    CONSTRAINT CK_group_members_joined_at CHECK (joined_at >= created_at)
);
GO

/* =========================================================
   9. PROJECT_REGISTRATIONS
   ========================================================= */
CREATE TABLE dbo.project_registrations (
    registration_id BIGINT IDENTITY(1,1) NOT NULL,
    group_id        BIGINT               NOT NULL,
    topic_id        BIGINT               NOT NULL,
    status          VARCHAR(20)          NOT NULL
        CONSTRAINT DF_project_registrations_status DEFAULT ('PENDING'),
    note            NVARCHAR(MAX)        NULL,
    reviewed_at     DATETIME2            NULL,
    reviewed_by_id  BIGINT               NULL,
    created_at      DATETIME2            NOT NULL
        CONSTRAINT DF_project_registrations_created_at DEFAULT SYSDATETIME(),
    updated_at      DATETIME2            NOT NULL
        CONSTRAINT DF_project_registrations_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_project_registrations PRIMARY KEY CLUSTERED (registration_id),
    CONSTRAINT FK_project_registrations_project_groups FOREIGN KEY (group_id)
        REFERENCES dbo.project_groups(group_id) ON DELETE CASCADE,
    CONSTRAINT FK_project_registrations_topics FOREIGN KEY (topic_id)
        REFERENCES dbo.topics(topic_id),
    CONSTRAINT FK_project_registrations_lecturers_reviewer FOREIGN KEY (reviewed_by_id)
        REFERENCES dbo.lecturers(lecturer_id),
    CONSTRAINT CK_project_registrations_status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED')),
    CONSTRAINT CK_project_registrations_review_info CHECK (
        (status = 'PENDING' AND reviewed_at IS NULL AND reviewed_by_id IS NULL)
        OR (status <> 'PENDING')
    ),
    CONSTRAINT CK_project_registrations_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   10. PROGRESS_REPORTS
   ========================================================= */
CREATE TABLE dbo.progress_reports (
    progress_report_id BIGINT IDENTITY(1,1) NOT NULL,
    group_id           BIGINT               NOT NULL,
    week_number        INT                  NOT NULL,
    title              NVARCHAR(255)        NOT NULL,
    completed_work     NVARCHAR(MAX)        NOT NULL,
    next_plan          NVARCHAR(MAX)        NULL,
    difficulties       NVARCHAR(MAX)        NULL,
    report_date        DATE                 NOT NULL
        CONSTRAINT DF_progress_reports_report_date DEFAULT CONVERT(DATE, SYSDATETIME()),
    status             VARCHAR(20)          NOT NULL
        CONSTRAINT DF_progress_reports_status DEFAULT ('SUBMITTED'),
    created_at         DATETIME2            NOT NULL
        CONSTRAINT DF_progress_reports_created_at DEFAULT SYSDATETIME(),
    updated_at         DATETIME2            NOT NULL
        CONSTRAINT DF_progress_reports_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_progress_reports PRIMARY KEY CLUSTERED (progress_report_id),
    CONSTRAINT UQ_progress_reports_group_week UNIQUE (group_id, week_number),
    CONSTRAINT FK_progress_reports_project_groups FOREIGN KEY (group_id)
        REFERENCES dbo.project_groups(group_id) ON DELETE CASCADE,
    CONSTRAINT CK_progress_reports_week_number CHECK (week_number >= 1),
    CONSTRAINT CK_progress_reports_title_not_blank CHECK (LEN(LTRIM(RTRIM(title))) > 0),
    CONSTRAINT CK_progress_reports_completed_work_not_blank CHECK (LEN(LTRIM(RTRIM(completed_work))) > 0),
    CONSTRAINT CK_progress_reports_status CHECK (status IN ('DRAFT', 'SUBMITTED', 'REVIEWED')),
    CONSTRAINT CK_progress_reports_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   11. SUBMISSIONS
   ========================================================= */
CREATE TABLE dbo.submissions (
    submission_id      BIGINT IDENTITY(1,1) NOT NULL,
    group_id           BIGINT               NOT NULL,
    progress_report_id BIGINT               NULL,
    type               VARCHAR(30)          NOT NULL,
    file_name          NVARCHAR(255)        NOT NULL,
    file_url           NVARCHAR(1000)       NOT NULL,
    public_id          NVARCHAR(255)        NULL,
    resource_type      VARCHAR(30)          NULL,
    file_size          BIGINT               NULL,
    submitted_by_id    BIGINT               NOT NULL,
    created_at         DATETIME2            NOT NULL
        CONSTRAINT DF_submissions_created_at DEFAULT SYSDATETIME(),
    updated_at         DATETIME2            NOT NULL
        CONSTRAINT DF_submissions_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_submissions PRIMARY KEY CLUSTERED (submission_id),
    CONSTRAINT FK_submissions_project_groups FOREIGN KEY (group_id)
        REFERENCES dbo.project_groups(group_id) ON DELETE CASCADE,
    CONSTRAINT FK_submissions_progress_reports FOREIGN KEY (progress_report_id)
        REFERENCES dbo.progress_reports(progress_report_id),
    CONSTRAINT FK_submissions_students_submitter FOREIGN KEY (submitted_by_id)
        REFERENCES dbo.students(student_id),
    CONSTRAINT CK_submissions_type CHECK (type IN ('PROPOSAL', 'PROGRESS', 'FINAL_REPORT', 'SOURCE_CODE', 'OTHER')),
    CONSTRAINT CK_submissions_file_name_not_blank CHECK (LEN(LTRIM(RTRIM(file_name))) > 0),
    CONSTRAINT CK_submissions_file_url_not_blank CHECK (LEN(LTRIM(RTRIM(file_url))) > 0),
    CONSTRAINT CK_submissions_file_size CHECK (file_size IS NULL OR file_size >= 0),
    CONSTRAINT CK_submissions_resource_type CHECK (resource_type IS NULL OR resource_type IN ('image', 'raw', 'video', 'auto')),
    CONSTRAINT CK_submissions_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   12. FEEDBACKS
   ========================================================= */
CREATE TABLE dbo.feedbacks (
    feedback_id        BIGINT IDENTITY(1,1) NOT NULL,
    group_id           BIGINT               NOT NULL,
    progress_report_id BIGINT               NULL,
    submission_id      BIGINT               NULL,
    lecturer_id        BIGINT               NOT NULL,
    content            NVARCHAR(MAX)        NOT NULL,
    created_at         DATETIME2            NOT NULL
        CONSTRAINT DF_feedbacks_created_at DEFAULT SYSDATETIME(),
    updated_at         DATETIME2            NOT NULL
        CONSTRAINT DF_feedbacks_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_feedbacks PRIMARY KEY CLUSTERED (feedback_id),
    CONSTRAINT FK_feedbacks_project_groups FOREIGN KEY (group_id)
        REFERENCES dbo.project_groups(group_id) ON DELETE CASCADE,
    CONSTRAINT FK_feedbacks_progress_reports FOREIGN KEY (progress_report_id)
        REFERENCES dbo.progress_reports(progress_report_id),
    CONSTRAINT FK_feedbacks_submissions FOREIGN KEY (submission_id)
        REFERENCES dbo.submissions(submission_id),
    CONSTRAINT FK_feedbacks_lecturers FOREIGN KEY (lecturer_id)
        REFERENCES dbo.lecturers(lecturer_id),
    CONSTRAINT CK_feedbacks_content_not_blank CHECK (LEN(LTRIM(RTRIM(content))) > 0),
    CONSTRAINT CK_feedbacks_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   13. GRADES
   ========================================================= */
CREATE TABLE dbo.grades (
    grade_id     BIGINT IDENTITY(1,1) NOT NULL,
    group_id     BIGINT               NOT NULL,
    student_id   BIGINT               NOT NULL,
    graded_by_id BIGINT               NOT NULL,
    score        DECIMAL(4,2)         NOT NULL,
    comment      NVARCHAR(MAX)        NULL,
    status       VARCHAR(20)          NOT NULL
        CONSTRAINT DF_grades_status DEFAULT ('DRAFT'),
    created_at   DATETIME2            NOT NULL
        CONSTRAINT DF_grades_created_at DEFAULT SYSDATETIME(),
    updated_at   DATETIME2            NOT NULL
        CONSTRAINT DF_grades_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT PK_grades PRIMARY KEY CLUSTERED (grade_id),
    CONSTRAINT UQ_grades_group_student UNIQUE (group_id, student_id),
    CONSTRAINT FK_grades_project_groups FOREIGN KEY (group_id)
        REFERENCES dbo.project_groups(group_id) ON DELETE CASCADE,
    CONSTRAINT FK_grades_students FOREIGN KEY (student_id)
        REFERENCES dbo.students(student_id),
    CONSTRAINT FK_grades_lecturers_grader FOREIGN KEY (graded_by_id)
        REFERENCES dbo.lecturers(lecturer_id),
    CONSTRAINT CK_grades_score CHECK (score BETWEEN 0 AND 10),
    CONSTRAINT CK_grades_status CHECK (status IN ('DRAFT', 'PUBLISHED')),
    CONSTRAINT CK_grades_updated_at CHECK (updated_at >= created_at)
);
GO

/* =========================================================
   INDEXES
   ========================================================= */
CREATE INDEX IX_users_role_status
    ON dbo.users(role, status);

CREATE INDEX IX_lecturers_user_id
    ON dbo.lecturers(user_id);

CREATE INDEX IX_academic_classes_advisor_id
    ON dbo.academic_classes(advisor_id);

CREATE INDEX IX_students_user_id
    ON dbo.students(user_id);

CREATE INDEX IX_students_class_id
    ON dbo.students(class_id);

CREATE INDEX IX_semesters_status
    ON dbo.semesters(status);

CREATE INDEX IX_topics_lecturer_id
    ON dbo.topics(lecturer_id);

CREATE INDEX IX_topics_semester_status
    ON dbo.topics(semester_id, status);

CREATE INDEX IX_project_groups_semester_status
    ON dbo.project_groups(semester_id, status);

CREATE INDEX IX_project_groups_topic_id
    ON dbo.project_groups(topic_id);

CREATE INDEX IX_group_members_group_id
    ON dbo.group_members(group_id);

CREATE INDEX IX_group_members_student_id
    ON dbo.group_members(student_id);

CREATE UNIQUE INDEX UQ_group_members_one_leader
    ON dbo.group_members(group_id)
    WHERE role = 'LEADER';

CREATE INDEX IX_project_registrations_group_status
    ON dbo.project_registrations(group_id, status);

CREATE INDEX IX_project_registrations_topic_status
    ON dbo.project_registrations(topic_id, status);

CREATE INDEX IX_project_registrations_reviewed_by_id
    ON dbo.project_registrations(reviewed_by_id);

CREATE INDEX IX_progress_reports_group_week
    ON dbo.progress_reports(group_id, week_number);

CREATE INDEX IX_progress_reports_status
    ON dbo.progress_reports(status);

CREATE INDEX IX_submissions_group_created_at
    ON dbo.submissions(group_id, created_at DESC);

CREATE INDEX IX_submissions_progress_report_id
    ON dbo.submissions(progress_report_id);

CREATE INDEX IX_submissions_submitted_by_id
    ON dbo.submissions(submitted_by_id);

CREATE INDEX IX_feedbacks_group_created_at
    ON dbo.feedbacks(group_id, created_at DESC);

CREATE INDEX IX_feedbacks_progress_report_id
    ON dbo.feedbacks(progress_report_id);

CREATE INDEX IX_feedbacks_submission_id
    ON dbo.feedbacks(submission_id);

CREATE INDEX IX_feedbacks_lecturer_id
    ON dbo.feedbacks(lecturer_id);

CREATE INDEX IX_grades_group_id
    ON dbo.grades(group_id);

CREATE INDEX IX_grades_student_id
    ON dbo.grades(student_id);

CREATE INDEX IX_grades_graded_by_id
    ON dbo.grades(graded_by_id);
GO

/* =========================================================
   SEED ADMIN
   Mật khẩu mặc định: Admin@123 (BCrypt)
   ========================================================= */
INSERT INTO dbo.users (
    username,
    email,
    password,
    full_name,
    role,
    status
)
VALUES (
    N'admin',
    N'admin@edu.local',
    N'$2a$12$INf873dRCfLMZ6eunnOxTeAaosV.SfewmO9.FUbcGXwGNEIEbXeca',
    N'Quản trị hệ thống',
    'ADMIN',
    'ACTIVE'
);
GO
