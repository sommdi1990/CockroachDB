-- University Management System - Sample Departments Data
-- Created for CockroachDB
-- این فایل شامل داده‌های نمونه برای دانشکده‌ها است

USE university_management;

-- =============================================
-- INSERT DEPARTMENTS DATA
-- =============================================

-- دانشکده مهندسی کامپیوتر
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Computer Engineering', 'CE', 'Dr. Ahmad Rezaei', 'ahmad.rezaei@university.edu', '+98-21-12345678', 'Engineering Building A', 3);

-- دانشکده مهندسی برق
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Electrical Engineering', 'EE', 'Dr. Maryam Karimi', 'maryam.karimi@university.edu', '+98-21-12345679', 'Engineering Building B', 2);

-- دانشکده مهندسی مکانیک
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Mechanical Engineering', 'ME', 'Dr. Hassan Mohammadi', 'hassan.mohammadi@university.edu', '+98-21-12345680', 'Engineering Building C', 4);

-- دانشکده علوم پایه
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Basic Sciences', 'BS', 'Dr. Fatemeh Ahmadi', 'fatemeh.ahmadi@university.edu', '+98-21-12345681', 'Science Building', 1);

-- دانشکده مدیریت و اقتصاد
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Management and Economics', 'ME', 'Dr. Ali Tehrani', 'ali.tehrani@university.edu', '+98-21-12345682', 'Business Building', 2);

-- دانشکده علوم انسانی
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Humanities', 'HU', 'Dr. Zahra Sadeghi', 'zahra.sadeghi@university.edu', '+98-21-12345683', 'Humanities Building', 1);

-- دانشکده پزشکی
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Medicine', 'MD', 'Dr. Mohammad Hosseini', 'mohammad.hosseini@university.edu', '+98-21-12345684', 'Medical Building', 3);

-- دانشکده حقوق
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Law', 'LW', 'Dr. Nasrin Vahidi', 'nasrin.vahidi@university.edu', '+98-21-12345685', 'Law Building', 2);

-- دانشکده هنر
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Arts', 'AR', 'Dr. Reza Mousavi', 'reza.mousavi@university.edu', '+98-21-12345686', 'Arts Building', 1);

-- دانشکده کشاورزی
INSERT INTO departments (department_id, department_name, department_code, dean_name, dean_email, dean_phone, building_name, floor_number) VALUES
(gen_random_uuid(), 'Faculty of Agriculture', 'AG', 'Dr. Leila Ghorbani', 'leila.ghorbani@university.edu', '+98-21-12345687', 'Agriculture Building', 1);

-- =============================================
-- INSERT MAJORS DATA
-- =============================================

-- رشته‌های دانشکده مهندسی کامپیوتر
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Computer Science',
    'CS',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Computer Science focusing on programming, algorithms, and software development'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Software Engineering',
    'SE',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Software Engineering focusing on software development lifecycle and project management'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Computer Engineering',
    'CE',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Computer Engineering focusing on hardware and software integration'
FROM departments d WHERE d.department_code = 'CE';

-- رشته‌های دانشکده مهندسی برق
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Electrical Engineering',
    'EE',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Electrical Engineering focusing on power systems and electronics'
FROM departments d WHERE d.department_code = 'EE';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Electronics Engineering',
    'EL',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Electronics Engineering focusing on electronic circuits and devices'
FROM departments d WHERE d.department_code = 'EE';

-- رشته‌های دانشکده مهندسی مکانیک
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Mechanical Engineering',
    'ME',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Mechanical Engineering focusing on design, manufacturing, and thermal systems'
FROM departments d WHERE d.department_code = 'ME';

-- رشته‌های دانشکده علوم پایه
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Mathematics',
    'MATH',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Mathematics focusing on pure and applied mathematics'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Physics',
    'PHY',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Physics focusing on theoretical and experimental physics'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Chemistry',
    'CHEM',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Chemistry focusing on organic, inorganic, and physical chemistry'
FROM departments d WHERE d.department_code = 'BS';

-- رشته‌های دانشکده مدیریت و اقتصاد
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Business Administration',
    'BA',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Business Administration focusing on management principles and business operations'
FROM departments d WHERE d.department_code = 'ME';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Economics',
    'ECON',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Economics focusing on economic theory and policy analysis'
FROM departments d WHERE d.department_code = 'ME';

-- رشته‌های دانشکده علوم انسانی
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'English Literature',
    'EL',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in English Literature focusing on literary analysis and critical thinking'
FROM departments d WHERE d.department_code = 'HU';

INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Psychology',
    'PSY',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Psychology focusing on human behavior and mental processes'
FROM departments d WHERE d.department_code = 'HU';

-- رشته‌های دانشکده پزشکی
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'General Medicine',
    'GM',
    d.department_id,
    'Bachelor',
    200,
    6,
    'Bachelor degree in General Medicine focusing on medical diagnosis and treatment'
FROM departments d WHERE d.department_code = 'MD';

-- رشته‌های دانشکده حقوق
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Law',
    'LAW',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Law focusing on legal principles and judicial processes'
FROM departments d WHERE d.department_code = 'LW';

-- رشته‌های دانشکده هنر
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Fine Arts',
    'FA',
    d.department_id,
    'Bachelor',
    130,
    4,
    'Bachelor degree in Fine Arts focusing on visual arts and creative expression'
FROM departments d WHERE d.department_code = 'AR';

-- رشته‌های دانشکده کشاورزی
INSERT INTO majors (major_id, major_name, major_code, department_id, degree_level, credits_required, duration_years, description) 
SELECT 
    gen_random_uuid(),
    'Agricultural Engineering',
    'AE',
    d.department_id,
    'Bachelor',
    140,
    4,
    'Bachelor degree in Agricultural Engineering focusing on agricultural technology and farm management'
FROM departments d WHERE d.department_code = 'AG';

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- نمایش تعداد دانشکده‌ها
SELECT 'Total Departments' AS description, COUNT(*) AS count FROM departments;

-- نمایش تعداد رشته‌ها
SELECT 'Total Majors' AS description, COUNT(*) AS count FROM majors;

-- نمایش رشته‌ها بر اساس دانشکده
SELECT 
    d.department_name,
    COUNT(m.major_id) AS major_count
FROM departments d
LEFT JOIN majors m ON d.department_id = m.department_id
GROUP BY d.department_name, d.department_code
ORDER BY d.department_name;
