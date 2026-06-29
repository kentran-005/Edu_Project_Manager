IF DB_ID(N'edu_project') IS NULL
BEGIN
    CREATE DATABASE edu_project;
END
GO

USE edu_project;
GO

IF OBJECT_ID('dbo.grades', 'U') IS NOT NULL DROP TABLE dbo.grades;
IF OBJECT_ID('dbo.feedbacks', 'U') IS NOT NULL DROP TABLE dbo.feedbacks;
IF OBJECT_ID('dbo.submissions', 'U') IS NOT NULL DROP TABLE dbo.submissions;
IF OBJECT_ID('dbo.progress_reports', 'U') IS NOT NULL DROP TABLE dbo.progress_reports;
IF OBJECT_ID('dbo.project_registrations', 'U') IS NOT NULL DROP TABLE dbo.project_registrations;
IF OBJECT_ID('dbo.group_members', 'U') IS NOT NULL DROP TABLE dbo.group_members;
IF OBJECT_ID('dbo.project_groups', 'U') IS NOT NULL DROP TABLE dbo.project_groups;
IF OBJECT_ID('dbo.topics', 'U') IS NOT NULL DROP TABLE dbo.topics;
IF OBJECT_ID('dbo.students', 'U') IS NOT NULL DROP TABLE dbo.students;
IF OBJECT_ID('dbo.academic_classes', 'U') IS NOT NULL DROP TABLE dbo.academic_classes;
IF OBJECT_ID('dbo.lecturers', 'U') IS NOT NULL DROP TABLE dbo.lecturers;
IF OBJECT_ID('dbo.semesters', 'U') IS NOT NULL DROP TABLE dbo.semesters;
IF OBJECT_ID('dbo.users', 'U') IS NOT NULL DROP TABLE dbo.users;
GO

CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(120) NOT NULL,
    phone NVARCHAR(20),
    avatar_url NVARCHAR(1000),
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN','LECTURER','STUDENT')),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE','INACTIVE','LOCKED')),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE lecturers (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    lecturer_code NVARCHAR(30) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL UNIQUE REFERENCES users(id),
    department NVARCHAR(255),
    academic_rank NVARCHAR(100),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE academic_classes (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(30) NOT NULL UNIQUE,
    name NVARCHAR(255) NOT NULL,
    major NVARCHAR(255),
    intake_year INT,
    advisor_id BIGINT REFERENCES lecturers(id),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE students (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    student_code NVARCHAR(30) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL UNIQUE REFERENCES users(id),
    class_id BIGINT REFERENCES academic_classes(id),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE semesters (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(30) NOT NULL UNIQUE,
    name NVARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    registration_deadline DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('UPCOMING','ACTIVE','CLOSED')),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CHECK (end_date > start_date)
);

CREATE TABLE topics (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    requirements NVARCHAR(MAX),
    technology NVARCHAR(255),
    max_members INT NOT NULL DEFAULT 3 CHECK (max_members BETWEEN 1 AND 10),
    lecturer_id BIGINT NOT NULL REFERENCES lecturers(id),
    semester_id BIGINT NOT NULL REFERENCES semesters(id),
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT','OPEN','ASSIGNED','CLOSED')),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE project_groups (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_name NVARCHAR(255) NOT NULL,
    invite_code VARCHAR(20) NOT NULL UNIQUE,
    semester_id BIGINT NOT NULL REFERENCES semesters(id),
    topic_id BIGINT REFERENCES topics(id),
    status VARCHAR(20) NOT NULL DEFAULT 'FORMING'
        CHECK (status IN ('FORMING','REGISTERED','IN_PROGRESS','COMPLETED','CANCELLED')),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE group_members (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES project_groups(id) ON DELETE CASCADE,
    student_id BIGINT NOT NULL REFERENCES students(id),
    role VARCHAR(20) NOT NULL CHECK (role IN ('LEADER','MEMBER')),
    joined_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT uq_group_member UNIQUE(group_id, student_id)
);

CREATE TABLE project_registrations (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES project_groups(id) ON DELETE CASCADE,
    topic_id BIGINT NOT NULL REFERENCES topics(id),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','APPROVED','REJECTED','CANCELLED')),
    note NVARCHAR(MAX),
    reviewed_at DATETIME2,
    reviewed_by_id BIGINT REFERENCES lecturers(id),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE progress_reports (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES project_groups(id) ON DELETE CASCADE,
    week_number INT NOT NULL CHECK (week_number >= 1),
    title NVARCHAR(255) NOT NULL,
    completed_work NVARCHAR(MAX) NOT NULL,
    next_plan NVARCHAR(MAX),
    difficulties NVARCHAR(MAX),
    report_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'SUBMITTED'
        CHECK (status IN ('DRAFT','SUBMITTED','REVIEWED')),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT uq_progress_week UNIQUE(group_id, week_number)
);

CREATE TABLE submissions (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES project_groups(id) ON DELETE CASCADE,
    progress_report_id BIGINT REFERENCES progress_reports(id),
    type VARCHAR(30) NOT NULL
        CHECK (type IN ('PROPOSAL','PROGRESS','FINAL_REPORT','SOURCE_CODE','OTHER')),
    file_name NVARCHAR(255) NOT NULL,
    file_url NVARCHAR(1000) NOT NULL,
    public_id NVARCHAR(255),
    resource_type VARCHAR(30),
    file_size BIGINT,
    submitted_by_id BIGINT NOT NULL REFERENCES students(id),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE feedbacks (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES project_groups(id) ON DELETE CASCADE,
    progress_report_id BIGINT REFERENCES progress_reports(id),
    submission_id BIGINT REFERENCES submissions(id),
    lecturer_id BIGINT NOT NULL REFERENCES lecturers(id),
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE grades (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES project_groups(id) ON DELETE CASCADE,
    student_id BIGINT NOT NULL REFERENCES students(id),
    graded_by_id BIGINT NOT NULL REFERENCES lecturers(id),
    score DECIMAL(4,2) NOT NULL CHECK (score BETWEEN 0 AND 10),
    comment NVARCHAR(MAX),
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT','PUBLISHED')),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT uq_grade_group_student UNIQUE(group_id, student_id)
);

CREATE INDEX ix_topics_semester_status ON topics(semester_id, status);
CREATE INDEX ix_groups_semester ON project_groups(semester_id);
CREATE INDEX ix_registrations_topic_status ON project_registrations(topic_id, status);
CREATE INDEX ix_reports_group ON progress_reports(group_id, week_number);
CREATE INDEX ix_submissions_group ON submissions(group_id, created_at DESC);
CREATE INDEX ix_feedbacks_group ON feedbacks(group_id, created_at DESC);
GO

-- Mật khẩu mặc định: Admin@123 (BCrypt)
INSERT INTO users(username,email,password,full_name,role,status)
VALUES (N'admin',N'admin@edu.local',
        N'$2a$12$INf873dRCfLMZ6eunnOxTeAaosV.SfewmO9.FUbcGXwGNEIEbXeca',
        N'Quản trị hệ thống','ADMIN','ACTIVE');
GO
