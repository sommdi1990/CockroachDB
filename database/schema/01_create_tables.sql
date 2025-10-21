-- University Management System Database Schema
-- Created for CockroachDB
-- All table names and column names are in English
-- Comments are in Persian for better understanding

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS university_management;

-- Use the database
USE university_management;

-- =============================================
-- 1. DEPARTMENTS TABLE (دانشکده‌ها)
-- =============================================
CREATE TABLE departments (
    department_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(10) UNIQUE NOT NULL,
    dean_name VARCHAR(100),
    dean_email VARCHAR(100),
    dean_phone VARCHAR(20),
    building_name VARCHAR(100),
    floor_number INTEGER,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- =============================================
-- 2. MAJORS TABLE (رشته‌های تحصیلی)
-- =============================================
CREATE TABLE majors (
    major_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    major_name VARCHAR(100) NOT NULL,
    major_code VARCHAR(10) UNIQUE NOT NULL,
    department_id UUID NOT NULL,
    degree_level VARCHAR(20) NOT NULL CHECK (degree_level IN ('Bachelor', 'Master', 'PhD')),
    credits_required INTEGER NOT NULL,
    duration_years INTEGER NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- =============================================
-- 3. STUDENTS TABLE (دانشجویان)
-- =============================================
CREATE TABLE students (
    student_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    national_id VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    enrollment_date DATE NOT NULL,
    graduation_date DATE,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Graduated', 'Suspended', 'Dropped')),
    major_id UUID NOT NULL,
    gpa DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (major_id) REFERENCES majors(major_id) ON DELETE RESTRICT
);

-- =============================================
-- 4. PROFESSORS TABLE (اساتید)
-- =============================================
CREATE TABLE professors (
    professor_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    national_id VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    rank VARCHAR(50) CHECK (rank IN ('Assistant Professor', 'Associate Professor', 'Full Professor', 'Lecturer')),
    specialization TEXT,
    department_id UUID NOT NULL,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Retired', 'On Leave')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT
);

-- =============================================
-- 5. COURSES TABLE (دروس)
-- =============================================
CREATE TABLE courses (
    course_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT,
    credits INTEGER NOT NULL,
    department_id UUID NOT NULL,
    professor_id UUID,
    prerequisites TEXT, -- JSON string of prerequisite course codes
    course_type VARCHAR(20) CHECK (course_type IN ('Core', 'Elective', 'General')),
    semester VARCHAR(20) CHECK (semester IN ('Fall', 'Spring', 'Summer')),
    academic_year INTEGER NOT NULL,
    max_students INTEGER DEFAULT 30,
    current_students INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Cancelled')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- =============================================
-- 6. ENROLLMENTS TABLE (ثبت‌نام دروس)
-- =============================================
CREATE TABLE enrollments (
    enrollment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,
    enrollment_date DATE NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'Enrolled' CHECK (status IN ('Enrolled', 'Completed', 'Dropped', 'Failed')),
    final_grade DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE(student_id, course_id, semester, academic_year)
);

-- =============================================
-- 7. GRADES TABLE (نمرات)
-- =============================================
CREATE TABLE grades (
    grade_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    enrollment_id UUID NOT NULL,
    assignment_type VARCHAR(50) NOT NULL, -- 'Quiz', 'Midterm', 'Final', 'Project', 'Homework'
    assignment_name VARCHAR(100),
    points_earned DECIMAL(5,2) NOT NULL,
    points_possible DECIMAL(5,2) NOT NULL,
    percentage DECIMAL(5,2) GENERATED ALWAYS AS (points_earned / points_possible * 100) STORED,
    grade_letter VARCHAR(2),
    comments TEXT,
    graded_by UUID,
    graded_date DATE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (graded_by) REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- =============================================
-- 8. CLASSROOMS TABLE (کلاس‌ها)
-- =============================================
CREATE TABLE classrooms (
    classroom_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_number VARCHAR(20) NOT NULL,
    building_name VARCHAR(100) NOT NULL,
    capacity INTEGER NOT NULL,
    room_type VARCHAR(50) CHECK (room_type IN ('Lecture Hall', 'Laboratory', 'Seminar Room', 'Computer Lab')),
    equipment TEXT, -- JSON string of available equipment
    floor_number INTEGER,
    is_accessible BOOLEAN DEFAULT true,
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Under Maintenance', 'Out of Order')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    UNIQUE(room_number, building_name)
);

-- =============================================
-- 9. SCHEDULES TABLE (برنامه کلاس‌ها)
-- =============================================
CREATE TABLE schedules (
    schedule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL,
    classroom_id UUID NOT NULL,
    professor_id UUID NOT NULL,
    day_of_week VARCHAR(10) NOT NULL CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Cancelled', 'Completed')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id) ON DELETE RESTRICT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE RESTRICT
);

-- =============================================
-- 10. ACADEMIC_YEARS TABLE (سال‌های تحصیلی)
-- =============================================
CREATE TABLE academic_years (
    academic_year_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    year_name VARCHAR(20) NOT NULL, -- e.g., "2023-2024"
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    fall_semester_start DATE,
    fall_semester_end DATE,
    spring_semester_start DATE,
    spring_semester_end DATE,
    summer_semester_start DATE,
    summer_semester_end DATE,
    is_current BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Completed', 'Cancelled')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- =============================================
-- 11. FINANCIAL_RECORDS TABLE (سوابق مالی)
-- =============================================
CREATE TABLE financial_records (
    record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('Tuition', 'Fee', 'Scholarship', 'Refund', 'Penalty')),
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    transaction_date DATE NOT NULL,
    due_date DATE,
    payment_date DATE,
    payment_method VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Paid', 'Overdue', 'Cancelled')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- =============================================
-- 12. NOTIFICATIONS TABLE (اعلان‌ها)
-- =============================================
CREATE TABLE notifications (
    notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID NOT NULL,
    recipient_type VARCHAR(20) NOT NULL CHECK (recipient_type IN ('Student', 'Professor', 'Admin')),
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL, -- 'Grade', 'Payment', 'Schedule', 'General'
    is_read BOOLEAN DEFAULT false,
    priority VARCHAR(10) DEFAULT 'Normal' CHECK (priority IN ('Low', 'Normal', 'High', 'Urgent')),
    created_at TIMESTAMP DEFAULT now(),
    read_at TIMESTAMP,
    expires_at TIMESTAMP
);

-- =============================================
-- 13. USER_ACCOUNTS TABLE (حساب‌های کاربری)
-- =============================================
CREATE TABLE user_accounts (
    account_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- References student_id or professor_id
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('Student', 'Professor', 'Admin')),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- =============================================
-- 14. AUDIT_LOG TABLE (لاگ تغییرات)
-- =============================================
CREATE TABLE audit_log (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name VARCHAR(50) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_values JSONB,
    new_values JSONB,
    changed_by UUID,
    changed_at TIMESTAMP DEFAULT now(),
    ip_address INET,
    user_agent TEXT
);

-- =============================================
-- COMMENTS FOR TABLES
-- =============================================
COMMENT ON TABLE departments IS 'جدول دانشکده‌ها - شامل اطلاعات دانشکده‌های دانشگاه';
COMMENT ON TABLE majors IS 'جدول رشته‌های تحصیلی - شامل اطلاعات رشته‌های مختلف در هر دانشکده';
COMMENT ON TABLE students IS 'جدول دانشجویان - شامل اطلاعات شخصی و تحصیلی دانشجویان';
COMMENT ON TABLE professors IS 'جدول اساتید - شامل اطلاعات اساتید و کارکنان آموزشی';
COMMENT ON TABLE courses IS 'جدول دروس - شامل کاتالوگ دروس دانشگاه';
COMMENT ON TABLE enrollments IS 'جدول ثبت‌نام - شامل اطلاعات ثبت‌نام دانشجویان در دروس';
COMMENT ON TABLE grades IS 'جدول نمرات - شامل نمرات مختلف دانشجویان';
COMMENT ON TABLE classrooms IS 'جدول کلاس‌ها - شامل اطلاعات سالن‌ها و کلاس‌های درس';
COMMENT ON TABLE schedules IS 'جدول برنامه‌ریزی - شامل زمان‌بندی کلاس‌ها';
COMMENT ON TABLE academic_years IS 'جدول سال‌های تحصیلی - شامل اطلاعات سال‌های تحصیلی';
COMMENT ON TABLE financial_records IS 'جدول سوابق مالی - شامل اطلاعات مالی دانشجویان';
COMMENT ON TABLE notifications IS 'جدول اعلان‌ها - شامل پیام‌ها و اعلان‌های سیستم';
COMMENT ON TABLE user_accounts IS 'جدول حساب‌های کاربری - شامل اطلاعات ورود کاربران';
COMMENT ON TABLE audit_log IS 'جدول لاگ تغییرات - شامل تاریخچه تغییرات در سیستم';
