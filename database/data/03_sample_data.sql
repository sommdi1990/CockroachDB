-- University Management System - Sample Data
-- Created for CockroachDB
-- این فایل شامل داده‌های نمونه برای دانشجویان، اساتید و سایر اطلاعات است

USE university_management;

-- =============================================
-- INSERT PROFESSORS DATA
-- =============================================

-- اساتید دانشکده مهندسی کامپیوتر
INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP001',
    'Dr. Ahmad',
    'Rezaei',
    '1234567890',
    'ahmad.rezaei@university.edu',
    '+98-21-11111111',
    'Tehran, Iran',
    '1970-05-15',
    'Male',
    '2000-09-01',
    15000000.00,
    'Full Professor',
    'Artificial Intelligence, Machine Learning',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP002',
    'Dr. Maryam',
    'Karimi',
    '1234567891',
    'maryam.karimi@university.edu',
    '+98-21-11111112',
    'Tehran, Iran',
    '1975-08-20',
    'Female',
    '2005-09-01',
    12000000.00,
    'Associate Professor',
    'Database Systems, Software Engineering',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP003',
    'Dr. Hassan',
    'Mohammadi',
    '1234567892',
    'hassan.mohammadi@university.edu',
    '+98-21-11111113',
    'Tehran, Iran',
    '1980-03-10',
    'Male',
    '2010-09-01',
    10000000.00,
    'Assistant Professor',
    'Computer Networks, Cybersecurity',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'CE';

-- اساتید دانشکده مهندسی برق
INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP004',
    'Dr. Fatemeh',
    'Ahmadi',
    '1234567893',
    'fatemeh.ahmadi@university.edu',
    '+98-21-11111114',
    'Tehran, Iran',
    '1972-12-05',
    'Female',
    '2002-09-01',
    14000000.00,
    'Full Professor',
    'Power Systems, Renewable Energy',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'EE';

INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP005',
    'Dr. Ali',
    'Tehrani',
    '1234567894',
    'ali.tehrani@university.edu',
    '+98-21-11111115',
    'Tehran, Iran',
    '1978-07-18',
    'Male',
    '2008-09-01',
    11000000.00,
    'Associate Professor',
    'Electronics, Digital Systems',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'EE';

-- اساتید دانشکده علوم پایه
INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP006',
    'Dr. Zahra',
    'Sadeghi',
    '1234567895',
    'zahra.sadeghi@university.edu',
    '+98-21-11111116',
    'Tehran, Iran',
    '1973-04-25',
    'Female',
    '2003-09-01',
    13000000.00,
    'Full Professor',
    'Applied Mathematics, Statistics',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO professors (professor_id, employee_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, hire_date, salary, rank, specialization, department_id, status) 
SELECT 
    gen_random_uuid(),
    'EMP007',
    'Dr. Mohammad',
    'Hosseini',
    '1234567896',
    'mohammad.hosseini@university.edu',
    '+98-21-11111117',
    'Tehran, Iran',
    '1976-11-12',
    'Male',
    '2006-09-01',
    10500000.00,
    'Associate Professor',
    'Theoretical Physics, Quantum Mechanics',
    d.department_id,
    'Active'
FROM departments d WHERE d.department_code = 'BS';

-- =============================================
-- INSERT STUDENTS DATA
-- =============================================

-- دانشجویان رشته کامپیوتر
INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU001',
    'Ali',
    'Ahmadi',
    '9876543210',
    'ali.ahmadi@student.university.edu',
    '+98-21-22222221',
    'Tehran, Iran',
    '2000-01-15',
    'Male',
    '2020-09-01',
    'Active',
    m.major_id,
    3.75
FROM majors m WHERE m.major_code = 'CS';

INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU002',
    'Fatemeh',
    'Mohammadi',
    '9876543211',
    'fatemeh.mohammadi@student.university.edu',
    '+98-21-22222222',
    'Tehran, Iran',
    '2001-03-20',
    'Female',
    '2020-09-01',
    'Active',
    m.major_id,
    3.90
FROM majors m WHERE m.major_code = 'CS';

INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU003',
    'Hassan',
    'Karimi',
    '9876543212',
    'hassan.karimi@student.university.edu',
    '+98-21-22222223',
    'Tehran, Iran',
    '1999-07-10',
    'Male',
    '2019-09-01',
    'Active',
    m.major_id,
    3.60
FROM majors m WHERE m.major_code = 'CS';

-- دانشجویان رشته مهندسی نرم‌افزار
INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU004',
    'Maryam',
    'Rezaei',
    '9876543213',
    'maryam.rezaei@student.university.edu',
    '+98-21-22222224',
    'Tehran, Iran',
    '2000-05-25',
    'Female',
    '2020-09-01',
    'Active',
    m.major_id,
    3.85
FROM majors m WHERE m.major_code = 'SE';

INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU005',
    'Ahmad',
    'Sadeghi',
    '9876543214',
    'ahmad.sadeghi@student.university.edu',
    '+98-21-22222225',
    'Tehran, Iran',
    '2001-09-15',
    'Male',
    '2021-09-01',
    'Active',
    m.major_id,
    3.70
FROM majors m WHERE m.major_code = 'SE';

-- دانشجویان رشته مهندسی برق
INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU006',
    'Zahra',
    'Tehrani',
    '9876543215',
    'zahra.tehrani@student.university.edu',
    '+98-21-22222226',
    'Tehran, Iran',
    '2000-11-08',
    'Female',
    '2020-09-01',
    'Active',
    m.major_id,
    3.80
FROM majors m WHERE m.major_code = 'EE';

INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU007',
    'Mohammad',
    'Hosseini',
    '9876543216',
    'mohammad.hosseini@student.university.edu',
    '+98-21-22222227',
    'Tehran, Iran',
    '1999-12-30',
    'Male',
    '2019-09-01',
    'Active',
    m.major_id,
    3.65
FROM majors m WHERE m.major_code = 'EE';

-- دانشجویان رشته ریاضی
INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU008',
    'Nasrin',
    'Vahidi',
    '9876543217',
    'nasrin.vahidi@student.university.edu',
    '+98-21-22222228',
    'Tehran, Iran',
    '2001-02-14',
    'Female',
    '2021-09-01',
    'Active',
    m.major_id,
    3.95
FROM majors m WHERE m.major_code = 'MATH';

INSERT INTO students (student_id, student_number, first_name, last_name, national_id, email, phone, address, date_of_birth, gender, enrollment_date, status, major_id, gpa) 
SELECT 
    gen_random_uuid(),
    'STU009',
    'Reza',
    'Mousavi',
    '9876543218',
    'reza.mousavi@student.university.edu',
    '+98-21-22222229',
    'Tehran, Iran',
    '2000-08-22',
    'Male',
    '2020-09-01',
    'Active',
    m.major_id,
    3.55
FROM majors m WHERE m.major_code = 'MATH';

-- =============================================
-- INSERT CLASSROOMS DATA
-- =============================================

INSERT INTO classrooms (classroom_id, room_number, building_name, capacity, room_type, equipment, floor_number, is_accessible, status) VALUES
(gen_random_uuid(), 'A101', 'Engineering Building A', 50, 'Lecture Hall', '["Projector", "Whiteboard", "Sound System"]', 1, true, 'Available'),
(gen_random_uuid(), 'A102', 'Engineering Building A', 40, 'Lecture Hall', '["Projector", "Whiteboard"]', 1, true, 'Available'),
(gen_random_uuid(), 'A201', 'Engineering Building A', 30, 'Computer Lab', '["Computers", "Projector", "Network"]', 2, true, 'Available'),
(gen_random_uuid(), 'A202', 'Engineering Building A', 25, 'Seminar Room', '["Projector", "Whiteboard", "Conference Table"]', 2, true, 'Available'),
(gen_random_uuid(), 'B101', 'Engineering Building B', 60, 'Lecture Hall', '["Projector", "Whiteboard", "Sound System", "Microphone"]', 1, true, 'Available'),
(gen_random_uuid(), 'B102', 'Engineering Building B', 35, 'Laboratory', '["Lab Equipment", "Safety Equipment", "Projector"]', 1, true, 'Available'),
(gen_random_uuid(), 'C101', 'Science Building', 45, 'Lecture Hall', '["Projector", "Whiteboard", "Sound System"]', 1, true, 'Available'),
(gen_random_uuid(), 'C102', 'Science Building', 30, 'Laboratory', '["Lab Equipment", "Safety Equipment", "Projector"]', 1, true, 'Available'),
(gen_random_uuid(), 'D101', 'Business Building', 40, 'Lecture Hall', '["Projector", "Whiteboard", "Sound System"]', 1, true, 'Available'),
(gen_random_uuid(), 'D102', 'Business Building', 20, 'Seminar Room', '["Projector", "Whiteboard", "Conference Table"]', 1, true, 'Available');

-- =============================================
-- INSERT ACADEMIC_YEARS DATA
-- =============================================

INSERT INTO academic_years (academic_year_id, year_name, start_date, end_date, fall_semester_start, fall_semester_end, spring_semester_start, spring_semester_end, summer_semester_start, summer_semester_end, is_current, status) VALUES
(gen_random_uuid(), '2023-2024', '2023-09-01', '2024-08-31', '2023-09-01', '2024-01-15', '2024-02-01', '2024-06-15', '2024-07-01', '2024-08-31', false, 'Completed'),
(gen_random_uuid(), '2024-2025', '2024-09-01', '2025-08-31', '2024-09-01', '2025-01-15', '2025-02-01', '2025-06-15', '2025-07-01', '2025-08-31', true, 'Active');

-- =============================================
-- INSERT ENROLLMENTS DATA
-- =============================================

-- ثبت‌نام دانشجویان در دروس
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU001' AND c.course_code = 'MATH101';

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU002' AND c.course_code = 'CS101';

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU002' AND c.course_code = 'MATH101';

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU004' AND c.course_code = 'CS101';

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU006' AND c.course_code = 'EE101';

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, semester, academic_year, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    c.course_id,
    '2024-09-01',
    'Fall',
    2024,
    'Enrolled'
FROM students s, courses c 
WHERE s.student_number = 'STU008' AND c.course_code = 'MATH101';

-- =============================================
-- INSERT GRADES DATA
-- =============================================

-- نمرات دانشجویان
INSERT INTO grades (grade_id, enrollment_id, assignment_type, assignment_name, points_earned, points_possible, grade_letter, graded_by, graded_date) 
SELECT 
    gen_random_uuid(),
    e.enrollment_id,
    'Quiz',
    'Quiz 1',
    18.0,
    20.0,
    'A',
    p.professor_id,
    '2024-10-15'
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN professors p ON c.professor_id = p.professor_id
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';

INSERT INTO grades (grade_id, enrollment_id, assignment_type, assignment_name, points_earned, points_possible, grade_letter, graded_by, graded_date) 
SELECT 
    gen_random_uuid(),
    e.enrollment_id,
    'Midterm',
    'Midterm Exam',
    42.0,
    50.0,
    'B',
    p.professor_id,
    '2024-11-01'
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN professors p ON c.professor_id = p.professor_id
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';

INSERT INTO grades (grade_id, enrollment_id, assignment_type, assignment_name, points_earned, points_possible, grade_letter, graded_by, graded_date) 
SELECT 
    gen_random_uuid(),
    e.enrollment_id,
    'Quiz',
    'Quiz 1',
    19.0,
    20.0,
    'A',
    p.professor_id,
    '2024-10-15'
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN professors p ON c.professor_id = p.professor_id
WHERE s.student_number = 'STU002' AND c.course_code = 'CS101';

-- =============================================
-- INSERT FINANCIAL_RECORDS DATA
-- =============================================

-- سوابق مالی دانشجویان
INSERT INTO financial_records (record_id, student_id, transaction_type, amount, description, transaction_date, due_date, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Tuition',
    5000000.00,
    'Fall 2024 Tuition Fee',
    '2024-09-01',
    '2024-09-15',
    'Paid'
FROM students s WHERE s.student_number = 'STU001';

INSERT INTO financial_records (record_id, student_id, transaction_type, amount, description, transaction_date, due_date, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Tuition',
    5000000.00,
    'Fall 2024 Tuition Fee',
    '2024-09-01',
    '2024-09-15',
    'Paid'
FROM students s WHERE s.student_number = 'STU002';

INSERT INTO financial_records (record_id, student_id, transaction_type, amount, description, transaction_date, due_date, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Tuition',
    5000000.00,
    'Fall 2024 Tuition Fee',
    '2024-09-01',
    '2024-09-15',
    'Pending'
FROM students s WHERE s.student_number = 'STU003';

INSERT INTO financial_records (record_id, student_id, transaction_type, amount, description, transaction_date, due_date, status) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Scholarship',
    -1000000.00,
    'Academic Excellence Scholarship',
    '2024-09-01',
    '2024-09-01',
    'Paid'
FROM students s WHERE s.student_number = 'STU002';

-- =============================================
-- INSERT NOTIFICATIONS DATA
-- =============================================

-- اعلان‌های دانشجویان
INSERT INTO notifications (notification_id, recipient_id, recipient_type, title, message, notification_type, is_read, priority, created_at) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Student',
    'New Grade Available',
    'Your grade for CS101 Quiz 1 has been posted.',
    'Grade',
    false,
    'Normal',
    '2024-10-16 10:00:00'
FROM students s WHERE s.student_number = 'STU001';

INSERT INTO notifications (notification_id, recipient_id, recipient_type, title, message, notification_type, is_read, priority, created_at) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Student',
    'Payment Reminder',
    'Your tuition payment for Fall 2024 is due soon.',
    'Payment',
    false,
    'High',
    '2024-09-10 09:00:00'
FROM students s WHERE s.student_number = 'STU003';

-- =============================================
-- INSERT USER_ACCOUNTS DATA
-- =============================================

-- حساب‌های کاربری دانشجویان
INSERT INTO user_accounts (account_id, user_id, user_type, username, password_hash, email, is_active, created_at) 
SELECT 
    gen_random_uuid(),
    s.student_id,
    'Student',
    s.student_number,
    '$2b$10$example_hash_here',
    s.email,
    true,
    '2024-09-01 00:00:00'
FROM students s WHERE s.student_number IN ('STU001', 'STU002', 'STU003', 'STU004', 'STU005');

-- حساب‌های کاربری اساتید
INSERT INTO user_accounts (account_id, user_id, user_type, username, password_hash, email, is_active, created_at) 
SELECT 
    gen_random_uuid(),
    p.professor_id,
    'Professor',
    p.employee_number,
    '$2b$10$example_hash_here',
    p.email,
    true,
    '2024-09-01 00:00:00'
FROM professors p WHERE p.employee_number IN ('EMP001', 'EMP002', 'EMP003', 'EMP004', 'EMP005');

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- نمایش آمار کلی
SELECT 'Total Professors' AS description, COUNT(*) AS count FROM professors;
SELECT 'Total Students' AS description, COUNT(*) AS count FROM students;
SELECT 'Total Classrooms' AS description, COUNT(*) AS count FROM classrooms;
SELECT 'Total Enrollments' AS description, COUNT(*) AS count FROM enrollments;
SELECT 'Total Grades' AS description, COUNT(*) AS count FROM grades;
SELECT 'Total Financial Records' AS description, COUNT(*) AS count FROM financial_records;
SELECT 'Total Notifications' AS description, COUNT(*) AS count FROM notifications;
SELECT 'Total User Accounts' AS description, COUNT(*) AS count FROM user_accounts;

-- نمایش دانشجویان بر اساس رشته
SELECT 
    m.major_name,
    COUNT(s.student_id) AS student_count
FROM majors m
LEFT JOIN students s ON m.major_id = s.major_id
GROUP BY m.major_name
ORDER BY m.major_name;

-- نمایش اساتید بر اساس دانشکده
SELECT 
    d.department_name,
    COUNT(p.professor_id) AS professor_count
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_name
ORDER BY d.department_name;
