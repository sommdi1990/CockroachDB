-- University Management System - Views
-- Created for CockroachDB
-- این فایل شامل ویوهای مفید برای گزارش‌گیری و نمایش اطلاعات است

USE university_management;

-- =============================================
-- 1. STUDENT_DETAILS VIEW (اطلاعات کامل دانشجویان)
-- =============================================
CREATE VIEW student_details AS
SELECT 
    s.student_id,
    s.student_number,
    s.first_name,
    s.last_name,
    s.email,
    s.phone,
    s.enrollment_date,
    s.graduation_date,
    s.status,
    s.gpa,
    m.major_name,
    m.degree_level,
    d.department_name,
    d.department_code
FROM students s
JOIN majors m ON s.major_id = m.major_id
JOIN departments d ON m.department_id = d.department_id;

-- =============================================
-- 2. PROFESSOR_DETAILS VIEW (اطلاعات کامل اساتید)
-- =============================================
CREATE VIEW professor_details AS
SELECT 
    p.professor_id,
    p.employee_number,
    p.first_name,
    p.last_name,
    p.email,
    p.phone,
    p.hire_date,
    p.salary,
    p.rank,
    p.specialization,
    p.status,
    d.department_name,
    d.department_code
FROM professors p
JOIN departments d ON p.department_id = d.department_id;

-- =============================================
-- 3. COURSE_DETAILS VIEW (اطلاعات کامل دروس)
-- =============================================
CREATE VIEW course_details AS
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.course_description,
    c.credits,
    c.course_type,
    c.semester,
    c.academic_year,
    c.max_students,
    c.current_students,
    c.status,
    d.department_name,
    p.first_name || ' ' || p.last_name AS professor_name,
    p.email AS professor_email
FROM courses c
JOIN departments d ON c.department_id = d.department_id
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- =============================================
-- 4. ENROLLMENT_DETAILS VIEW (اطلاعات کامل ثبت‌نام‌ها)
-- =============================================
CREATE VIEW enrollment_details AS
SELECT 
    e.enrollment_id,
    e.enrollment_date,
    e.semester,
    e.academic_year,
    e.status,
    e.final_grade,
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email AS student_email,
    c.course_code,
    c.course_name,
    c.credits,
    p.first_name || ' ' || p.last_name AS professor_name,
    d.department_name
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN professors p ON c.professor_id = p.professor_id
JOIN departments d ON c.department_id = d.department_id;

-- =============================================
-- 5. GRADE_SUMMARY VIEW (خلاصه نمرات)
-- =============================================
CREATE VIEW grade_summary AS
SELECT 
    e.student_id,
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    e.course_id,
    c.course_code,
    c.course_name,
    c.credits,
    e.semester,
    e.academic_year,
    e.final_grade,
    CASE 
        WHEN e.final_grade >= 90 THEN 'A'
        WHEN e.final_grade >= 80 THEN 'B'
        WHEN e.final_grade >= 70 THEN 'C'
        WHEN e.final_grade >= 60 THEN 'D'
        ELSE 'F'
    END AS grade_letter,
    CASE 
        WHEN e.final_grade >= 90 THEN 4.0
        WHEN e.final_grade >= 80 THEN 3.0
        WHEN e.final_grade >= 70 THEN 2.0
        WHEN e.final_grade >= 60 THEN 1.0
        ELSE 0.0
    END AS grade_points
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.status = 'Completed' AND e.final_grade IS NOT NULL;

-- =============================================
-- 6. STUDENT_GPA_VIEW (محاسبه GPA دانشجویان)
-- =============================================
CREATE VIEW student_gpa AS
SELECT 
    student_id,
    student_number,
    student_name,
    major_name,
    department_name,
    total_credits,
    total_grade_points,
    CASE 
        WHEN total_credits > 0 THEN total_grade_points / total_credits
        ELSE 0
    END AS calculated_gpa,
    semester,
    academic_year
FROM (
    SELECT 
        s.student_id,
        s.student_number,
        s.first_name || ' ' || s.last_name AS student_name,
        m.major_name,
        d.department_name,
        SUM(c.credits) AS total_credits,
        SUM(
            CASE 
                WHEN e.final_grade >= 90 THEN c.credits * 4.0
                WHEN e.final_grade >= 80 THEN c.credits * 3.0
                WHEN e.final_grade >= 70 THEN c.credits * 2.0
                WHEN e.final_grade >= 60 THEN c.credits * 1.0
                ELSE 0
            END
        ) AS total_grade_points,
        e.semester,
        e.academic_year
    FROM students s
    JOIN majors m ON s.major_id = m.major_id
    JOIN departments d ON m.department_id = d.department_id
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE e.status = 'Completed' AND e.final_grade IS NOT NULL
    GROUP BY s.student_id, s.student_number, s.first_name, s.last_name, 
             m.major_name, d.department_name, e.semester, e.academic_year
);

-- =============================================
-- 7. SCHEDULE_DETAILS VIEW (اطلاعات کامل برنامه‌ها)
-- =============================================
CREATE VIEW schedule_details AS
SELECT 
    sch.schedule_id,
    sch.day_of_week,
    sch.start_time,
    sch.end_time,
    sch.semester,
    sch.academic_year,
    sch.status,
    c.course_code,
    c.course_name,
    c.credits,
    p.first_name || ' ' || p.last_name AS professor_name,
    p.email AS professor_email,
    cl.room_number,
    cl.building_name,
    cl.capacity,
    cl.room_type,
    d.department_name
FROM schedules sch
JOIN courses c ON sch.course_id = c.course_id
JOIN professors p ON sch.professor_id = p.professor_id
JOIN classrooms cl ON sch.classroom_id = cl.classroom_id
JOIN departments d ON c.department_id = d.department_id;

-- =============================================
-- 8. FINANCIAL_SUMMARY VIEW (خلاصه مالی دانشجویان)
-- =============================================
CREATE VIEW financial_summary AS
SELECT 
    s.student_id,
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    m.major_name,
    d.department_name,
    SUM(CASE WHEN fr.transaction_type = 'Tuition' THEN fr.amount ELSE 0 END) AS total_tuition,
    SUM(CASE WHEN fr.transaction_type = 'Fee' THEN fr.amount ELSE 0 END) AS total_fees,
    SUM(CASE WHEN fr.transaction_type = 'Scholarship' THEN -fr.amount ELSE 0 END) AS total_scholarships,
    SUM(CASE WHEN fr.status = 'Paid' THEN fr.amount ELSE 0 END) AS total_paid,
    SUM(CASE WHEN fr.status = 'Pending' THEN fr.amount ELSE 0 END) AS total_pending,
    SUM(CASE WHEN fr.status = 'Overdue' THEN fr.amount ELSE 0 END) AS total_overdue
FROM students s
JOIN majors m ON s.major_id = m.major_id
JOIN departments d ON m.department_id = d.department_id
LEFT JOIN financial_records fr ON s.student_id = fr.student_id
GROUP BY s.student_id, s.student_number, s.first_name, s.last_name, 
         s.email, m.major_name, d.department_name;

-- =============================================
-- 9. DEPARTMENT_STATISTICS VIEW (آمار دانشکده‌ها)
-- =============================================
CREATE VIEW department_statistics AS
SELECT 
    d.department_id,
    d.department_name,
    d.department_code,
    COUNT(DISTINCT m.major_id) AS total_majors,
    COUNT(DISTINCT s.student_id) AS total_students,
    COUNT(DISTINCT p.professor_id) AS total_professors,
    COUNT(DISTINCT c.course_id) AS total_courses,
    AVG(s.gpa) AS average_gpa,
    COUNT(DISTINCT CASE WHEN s.status = 'Active' THEN s.student_id END) AS active_students,
    COUNT(DISTINCT CASE WHEN p.status = 'Active' THEN p.professor_id END) AS active_professors
FROM departments d
LEFT JOIN majors m ON d.department_id = m.department_id
LEFT JOIN students s ON m.major_id = s.major_id
LEFT JOIN professors p ON d.department_id = p.department_id
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name, d.department_code;

-- =============================================
-- 10. NOTIFICATION_SUMMARY VIEW (خلاصه اعلان‌ها)
-- =============================================
CREATE VIEW notification_summary AS
SELECT 
    recipient_id,
    recipient_type,
    COUNT(*) AS total_notifications,
    COUNT(CASE WHEN is_read = false THEN 1 END) AS unread_notifications,
    COUNT(CASE WHEN priority = 'Urgent' THEN 1 END) AS urgent_notifications,
    COUNT(CASE WHEN notification_type = 'Grade' THEN 1 END) AS grade_notifications,
    COUNT(CASE WHEN notification_type = 'Payment' THEN 1 END) AS payment_notifications,
    MAX(created_at) AS last_notification_date
FROM notifications
GROUP BY recipient_id, recipient_type;

-- =============================================
-- COMMENTS FOR VIEWS
-- =============================================
COMMENT ON VIEW student_details IS 'نمایش اطلاعات کامل دانشجویان شامل رشته و دانشکده';
COMMENT ON VIEW professor_details IS 'نمایش اطلاعات کامل اساتید شامل دانشکده';
COMMENT ON VIEW course_details IS 'نمایش اطلاعات کامل دروس شامل استاد و دانشکده';
COMMENT ON VIEW enrollment_details IS 'نمایش اطلاعات کامل ثبت‌نام‌ها';
COMMENT ON VIEW grade_summary IS 'خلاصه نمرات دانشجویان با محاسبه نمره حرفی';
COMMENT ON VIEW student_gpa IS 'محاسبه GPA دانشجویان بر اساس نمرات';
COMMENT ON VIEW schedule_details IS 'نمایش اطلاعات کامل برنامه‌های کلاس‌ها';
COMMENT ON VIEW financial_summary IS 'خلاصه وضعیت مالی دانشجویان';
COMMENT ON VIEW department_statistics IS 'آمار کلی دانشکده‌ها';
COMMENT ON VIEW notification_summary IS 'خلاصه اعلان‌های کاربران';
