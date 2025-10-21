-- University Management System - Indexes
-- Created for CockroachDB
-- این فایل شامل ایندکس‌های بهینه‌سازی برای جداول سیستم مدیریت دانشگاه است

USE university_management;

-- =============================================
-- INDEXES FOR DEPARTMENTS TABLE
-- =============================================
CREATE INDEX idx_departments_code ON departments(department_code);
CREATE INDEX idx_departments_name ON departments(department_name);

-- =============================================
-- INDEXES FOR MAJORS TABLE
-- =============================================
CREATE INDEX idx_majors_department ON majors(department_id);
CREATE INDEX idx_majors_code ON majors(major_code);
CREATE INDEX idx_majors_degree_level ON majors(degree_level);

-- =============================================
-- INDEXES FOR STUDENTS TABLE
-- =============================================
CREATE INDEX idx_students_number ON students(student_number);
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_students_major ON students(major_id);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_students_enrollment_date ON students(enrollment_date);
CREATE INDEX idx_students_gpa ON students(gpa);
CREATE INDEX idx_students_name ON students(first_name, last_name);

-- =============================================
-- INDEXES FOR PROFESSORS TABLE
-- =============================================
CREATE INDEX idx_professors_employee_number ON professors(employee_number);
CREATE INDEX idx_professors_email ON professors(email);
CREATE INDEX idx_professors_department ON professors(department_id);
CREATE INDEX idx_professors_status ON professors(status);
CREATE INDEX idx_professors_rank ON professors(rank);
CREATE INDEX idx_professors_name ON professors(first_name, last_name);

-- =============================================
-- INDEXES FOR COURSES TABLE
-- =============================================
CREATE INDEX idx_courses_code ON courses(course_code);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_courses_professor ON courses(professor_id);
CREATE INDEX idx_courses_semester ON courses(semester, academic_year);
CREATE INDEX idx_courses_status ON courses(status);
CREATE INDEX idx_courses_type ON courses(course_type);

-- =============================================
-- INDEXES FOR ENROLLMENTS TABLE
-- =============================================
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_enrollments_semester ON enrollments(semester, academic_year);
CREATE INDEX idx_enrollments_status ON enrollments(status);
CREATE INDEX idx_enrollments_date ON enrollments(enrollment_date);

-- =============================================
-- INDEXES FOR GRADES TABLE
-- =============================================
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
CREATE INDEX idx_grades_type ON grades(assignment_type);
CREATE INDEX idx_grades_graded_by ON grades(graded_by);
CREATE INDEX idx_grades_date ON grades(graded_date);
CREATE INDEX idx_grades_letter ON grades(grade_letter);

-- =============================================
-- INDEXES FOR CLASSROOMS TABLE
-- =============================================
CREATE INDEX idx_classrooms_building ON classrooms(building_name);
CREATE INDEX idx_classrooms_capacity ON classrooms(capacity);
CREATE INDEX idx_classrooms_type ON classrooms(room_type);
CREATE INDEX idx_classrooms_status ON classrooms(status);

-- =============================================
-- INDEXES FOR SCHEDULES TABLE
-- =============================================
CREATE INDEX idx_schedules_course ON schedules(course_id);
CREATE INDEX idx_schedules_classroom ON schedules(classroom_id);
CREATE INDEX idx_schedules_professor ON schedules(professor_id);
CREATE INDEX idx_schedules_day ON schedules(day_of_week);
CREATE INDEX idx_schedules_time ON schedules(start_time, end_time);
CREATE INDEX idx_schedules_semester ON schedules(semester, academic_year);
CREATE INDEX idx_schedules_status ON schedules(status);

-- =============================================
-- INDEXES FOR ACADEMIC_YEARS TABLE
-- =============================================
CREATE INDEX idx_academic_years_name ON academic_years(year_name);
CREATE INDEX idx_academic_years_current ON academic_years(is_current);
CREATE INDEX idx_academic_years_status ON academic_years(status);

-- =============================================
-- INDEXES FOR FINANCIAL_RECORDS TABLE
-- =============================================
CREATE INDEX idx_financial_student ON financial_records(student_id);
CREATE INDEX idx_financial_type ON financial_records(transaction_type);
CREATE INDEX idx_financial_date ON financial_records(transaction_date);
CREATE INDEX idx_financial_status ON financial_records(status);
CREATE INDEX idx_financial_due_date ON financial_records(due_date);

-- =============================================
-- INDEXES FOR NOTIFICATIONS TABLE
-- =============================================
CREATE INDEX idx_notifications_recipient ON notifications(recipient_id, recipient_type);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_created ON notifications(created_at);

-- =============================================
-- INDEXES FOR USER_ACCOUNTS TABLE
-- =============================================
CREATE INDEX idx_accounts_username ON user_accounts(username);
CREATE INDEX idx_accounts_email ON user_accounts(email);
CREATE INDEX idx_accounts_user ON user_accounts(user_id, user_type);
CREATE INDEX idx_accounts_active ON user_accounts(is_active);
CREATE INDEX idx_accounts_last_login ON user_accounts(last_login);

-- =============================================
-- INDEXES FOR AUDIT_LOG TABLE
-- =============================================
CREATE INDEX idx_audit_table ON audit_log(table_name);
CREATE INDEX idx_audit_record ON audit_log(record_id);
CREATE INDEX idx_audit_action ON audit_log(action);
CREATE INDEX idx_audit_changed_by ON audit_log(changed_by);
CREATE INDEX idx_audit_date ON audit_log(changed_at);

-- =============================================
-- COMPOSITE INDEXES FOR COMMON QUERIES
-- =============================================

-- برای جستجوی دانشجویان بر اساس رشته و وضعیت
CREATE INDEX idx_students_major_status ON students(major_id, status);

-- برای جستجوی دروس بر اساس دانشکده و ترم
CREATE INDEX idx_courses_dept_semester ON courses(department_id, semester, academic_year);

-- برای جستجوی ثبت‌نام‌ها بر اساس دانشجو و ترم
CREATE INDEX idx_enrollments_student_semester ON enrollments(student_id, semester, academic_year);

-- برای جستجوی برنامه‌ها بر اساس استاد و روز
CREATE INDEX idx_schedules_professor_day ON schedules(professor_id, day_of_week);

-- برای جستجوی نمرات بر اساس نوع و تاریخ
CREATE INDEX idx_grades_type_date ON grades(assignment_type, graded_date);

-- برای جستجوی سوابق مالی بر اساس دانشجو و نوع
CREATE INDEX idx_financial_student_type ON financial_records(student_id, transaction_type);

-- =============================================
-- PARTIAL INDEXES FOR PERFORMANCE
-- =============================================

-- ایندکس برای دانشجویان فعال
CREATE INDEX idx_students_active ON students(student_id) WHERE status = 'Active';

-- ایندکس برای اساتید فعال
CREATE INDEX idx_professors_active ON professors(professor_id) WHERE status = 'Active';

-- ایندکس برای دروس فعال
CREATE INDEX idx_courses_active ON courses(course_id) WHERE status = 'Active';

-- ایندکس برای اعلان‌های خوانده نشده
CREATE INDEX idx_notifications_unread ON notifications(notification_id) WHERE is_read = false;

-- ایندکس برای حساب‌های فعال
CREATE INDEX idx_accounts_active_users ON user_accounts(account_id) WHERE is_active = true;

-- =============================================
-- COMMENTS FOR INDEXES
-- =============================================
COMMENT ON INDEX idx_students_major_status IS 'ایندکس ترکیبی برای جستجوی دانشجویان بر اساس رشته و وضعیت';
COMMENT ON INDEX idx_courses_dept_semester IS 'ایندکس ترکیبی برای جستجوی دروس بر اساس دانشکده و ترم';
COMMENT ON INDEX idx_enrollments_student_semester IS 'ایندکس ترکیبی برای جستجوی ثبت‌نام‌ها بر اساس دانشجو و ترم';
COMMENT ON INDEX idx_schedules_professor_day IS 'ایندکس ترکیبی برای جستجوی برنامه‌ها بر اساس استاد و روز';
COMMENT ON INDEX idx_grades_type_date IS 'ایندکس ترکیبی برای جستجوی نمرات بر اساس نوع و تاریخ';
COMMENT ON INDEX idx_financial_student_type IS 'ایندکس ترکیبی برای جستجوی سوابق مالی بر اساس دانشجو و نوع';
