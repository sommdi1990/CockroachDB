# راهنمای استفاده از دیتابیس سیستم مدیریت دانشگاه

## مقدمه

این راهنما شامل تمام دستورات و روش‌های استفاده از دیتابیس سیستم مدیریت دانشگاه است.

## اتصال به دیتابیس

### روش‌های اتصال

#### 1. اتصال از طریق خط فرمان
```bash
# اتصال به دیتابیس
cockroach sql --insecure --host=localhost:26257 --database=university_management

# اتصال به دیتابیس با کاربر خاص
cockroach sql --insecure --host=localhost:26257 --database=university_management --user=admin
```

#### 2. اتصال از طریق رابط وب
```
http://localhost:8080
```

#### 3. اتصال از طریق برنامه‌های کاربردی
```python
import psycopg2

# اتصال به دیتابیس
conn = psycopg2.connect(
    host="localhost",
    port=26257,
    database="university_management",
    user="admin",
    password="password"
)
```

## دستورات اصلی

### 1. مدیریت دانشجویان

#### اضافه کردن دانشجوی جدید
```sql
INSERT INTO students (
    student_number, first_name, last_name, national_id, 
    email, phone, address, date_of_birth, gender, 
    enrollment_date, status, major_id
) VALUES (
    'STU100', 'علی', 'احمدی', '1234567890',
    'ali.ahmadi@student.university.edu', '+98-21-12345678',
    'تهران، ایران', '2000-01-15', 'Male',
    '2024-09-01', 'Active', 
    (SELECT major_id FROM majors WHERE major_code = 'CS')
);
```

#### جستجوی دانشجویان
```sql
-- جستجوی دانشجویان بر اساس نام
SELECT * FROM students 
WHERE first_name LIKE '%علی%' OR last_name LIKE '%احمدی%';

-- جستجوی دانشجویان بر اساس رشته
SELECT s.*, m.major_name, d.department_name 
FROM students s
JOIN majors m ON s.major_id = m.major_id
JOIN departments d ON m.department_id = d.department_id
WHERE m.major_code = 'CS';

-- جستجوی دانشجویان بر اساس وضعیت
SELECT * FROM students WHERE status = 'Active';
```

#### به‌روزرسانی اطلاعات دانشجو
```sql
UPDATE students 
SET phone = '+98-21-87654321', 
    address = 'تهران، خیابان ولیعصر'
WHERE student_number = 'STU100';
```

#### حذف دانشجو
```sql
DELETE FROM students WHERE student_number = 'STU100';
```

### 2. مدیریت اساتید

#### اضافه کردن استاد جدید
```sql
INSERT INTO professors (
    employee_number, first_name, last_name, national_id,
    email, phone, address, date_of_birth, gender,
    hire_date, salary, rank, specialization, department_id, status
) VALUES (
    'EMP100', 'دکتر', 'محمدی', '0987654321',
    'dr.mohammadi@university.edu', '+98-21-23456789',
    'تهران، ایران', '1975-05-20', 'Male',
    '2020-09-01', 15000000.00, 'Associate Professor',
    'مهندسی نرم‌افزار', 
    (SELECT department_id FROM departments WHERE department_code = 'CE'),
    'Active'
);
```

#### جستجوی اساتید
```sql
-- جستجوی اساتید بر اساس دانشکده
SELECT p.*, d.department_name 
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_code = 'CE';

-- جستجوی اساتید بر اساس رتبه علمی
SELECT * FROM professors WHERE rank = 'Full Professor';
```

### 3. مدیریت دروس

#### اضافه کردن درس جدید
```sql
INSERT INTO courses (
    course_code, course_name, course_description, credits,
    department_id, professor_id, course_type, semester,
    academic_year, max_students, prerequisites
) VALUES (
    'CS401', 'هوش مصنوعی', 'مبانی هوش مصنوعی و یادگیری ماشین',
    3, 
    (SELECT department_id FROM departments WHERE department_code = 'CE'),
    (SELECT professor_id FROM professors WHERE employee_number = 'EMP100'),
    'Core', 'Fall', 2024, 30, '["CS102", "MATH201"]'
);
```

#### جستجوی دروس
```sql
-- جستجوی دروس بر اساس دانشکده
SELECT c.*, d.department_name, p.first_name || ' ' || p.last_name AS professor_name
FROM courses c
JOIN departments d ON c.department_id = d.department_id
LEFT JOIN professors p ON c.professor_id = p.professor_id
WHERE d.department_code = 'CE';

-- جستجوی دروس بر اساس ترم
SELECT * FROM courses 
WHERE semester = 'Fall' AND academic_year = 2024;
```

### 4. مدیریت ثبت‌نام‌ها

#### ثبت‌نام دانشجو در درس
```sql
INSERT INTO enrollments (
    student_id, course_id, enrollment_date, semester, academic_year, status
) VALUES (
    (SELECT student_id FROM students WHERE student_number = 'STU100'),
    (SELECT course_id FROM courses WHERE course_code = 'CS101'),
    '2024-09-01', 'Fall', 2024, 'Enrolled'
);
```

#### جستجوی ثبت‌نام‌ها
```sql
-- جستجوی ثبت‌نام‌های دانشجو
SELECT e.*, c.course_name, s.first_name || ' ' || s.last_name AS student_name
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_number = 'STU100';

-- جستجوی دانشجویان یک درس
SELECT s.*, e.enrollment_date, e.status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101';
```

### 5. مدیریت نمرات

#### ثبت نمره
```sql
INSERT INTO grades (
    enrollment_id, assignment_type, assignment_name,
    points_earned, points_possible, grade_letter,
    graded_by, graded_date
) VALUES (
    (SELECT enrollment_id FROM enrollments e
     JOIN students s ON e.student_id = s.student_id
     JOIN courses c ON e.course_id = c.course_id
     WHERE s.student_number = 'STU100' AND c.course_code = 'CS101'),
    'Quiz', 'کوئیز 1', 18.0, 20.0, 'A',
    (SELECT professor_id FROM professors WHERE employee_number = 'EMP100'),
    '2024-10-15'
);
```

#### جستجوی نمرات
```sql
-- جستجوی نمرات دانشجو
SELECT g.*, c.course_name, s.first_name || ' ' || s.last_name AS student_name
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_number = 'STU100';

-- محاسبه معدل دانشجو
SELECT 
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    AVG(e.final_grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE s.student_number = 'STU100' AND e.status = 'Completed'
GROUP BY s.student_number, s.first_name, s.last_name;
```

### 6. مدیریت برنامه‌ها

#### اضافه کردن برنامه کلاس
```sql
INSERT INTO schedules (
    course_id, classroom_id, professor_id, day_of_week,
    start_time, end_time, semester, academic_year, status
) VALUES (
    (SELECT course_id FROM courses WHERE course_code = 'CS101'),
    (SELECT classroom_id FROM classrooms WHERE room_number = 'A101'),
    (SELECT professor_id FROM professors WHERE employee_number = 'EMP100'),
    'Monday', '08:00:00', '10:00:00', 'Fall', 2024, 'Active'
);
```

#### جستجوی برنامه‌ها
```sql
-- جستجوی برنامه‌های استاد
SELECT s.*, c.course_name, cl.room_number, cl.building_name
FROM schedules s
JOIN courses c ON s.course_id = c.course_id
JOIN classrooms cl ON s.classroom_id = cl.classroom_id
JOIN professors p ON s.professor_id = p.professor_id
WHERE p.employee_number = 'EMP100';

-- جستجوی برنامه‌های کلاس
SELECT s.*, c.course_name, p.first_name || ' ' || p.last_name AS professor_name
FROM schedules s
JOIN courses c ON s.course_id = c.course_id
JOIN professors p ON s.professor_id = p.professor_id
JOIN classrooms cl ON s.classroom_id = cl.classroom_id
WHERE cl.room_number = 'A101';
```

## پرس و جوهای پیشرفته

### 1. گزارش‌گیری آمار

#### آمار دانشجویان بر اساس رشته
```sql
SELECT 
    m.major_name,
    d.department_name,
    COUNT(s.student_id) AS student_count,
    AVG(s.gpa) AS average_gpa
FROM majors m
JOIN departments d ON m.department_id = d.department_id
LEFT JOIN students s ON m.major_id = s.major_id
GROUP BY m.major_name, d.department_name
ORDER BY student_count DESC;
```

#### آمار دروس بر اساس دانشکده
```sql
SELECT 
    d.department_name,
    COUNT(c.course_id) AS course_count,
    SUM(c.credits) AS total_credits,
    AVG(c.current_students) AS average_students
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_name
ORDER BY course_count DESC;
```

#### آمار نمرات بر اساس درس
```sql
SELECT 
    c.course_name,
    COUNT(g.grade_id) AS grade_count,
    AVG(g.points_earned) AS average_points,
    AVG(g.percentage) AS average_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_name
ORDER BY average_percentage DESC;
```

### 2. پرس و جوهای پیچیده

#### دانشجویان با معدل بالا
```sql
SELECT 
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    m.major_name,
    s.gpa,
    COUNT(e.enrollment_id) AS completed_courses
FROM students s
JOIN majors m ON s.major_id = m.major_id
LEFT JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Completed'
WHERE s.gpa >= 3.5
GROUP BY s.student_number, s.first_name, s.last_name, m.major_name, s.gpa
ORDER BY s.gpa DESC;
```

#### اساتید با بیشترین تعداد دانشجو
```sql
SELECT 
    p.first_name || ' ' || p.last_name AS professor_name,
    d.department_name,
    COUNT(DISTINCT e.student_id) AS student_count,
    COUNT(DISTINCT c.course_id) AS course_count
FROM professors p
JOIN departments d ON p.department_id = d.department_id
JOIN courses c ON p.professor_id = c.professor_id
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY p.professor_id, p.first_name, p.last_name, d.department_name
ORDER BY student_count DESC;
```

#### دروس با بیشترین تقاضا
```sql
SELECT 
    c.course_name,
    d.department_name,
    c.current_students,
    c.max_students,
    ROUND((c.current_students::float / c.max_students) * 100, 2) AS occupancy_rate
FROM courses c
JOIN departments d ON c.department_id = d.department_id
WHERE c.status = 'Active'
ORDER BY occupancy_rate DESC;
```

### 3. پرس و جوهای زمانی

#### دانشجویان جدید در ترم جاری
```sql
SELECT 
    s.student_number,
    s.first_name || ' ' || s.last_name AS student_name,
    m.major_name,
    s.enrollment_date
FROM students s
JOIN majors m ON s.major_id = m.major_id
WHERE s.enrollment_date >= '2024-09-01'
ORDER BY s.enrollment_date DESC;
```

#### نمرات اخیر
```sql
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    g.assignment_name,
    g.points_earned,
    g.points_possible,
    g.grade_letter,
    g.graded_date
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE g.graded_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY g.graded_date DESC;
```

## استفاده از ویوها

### 1. ویو اطلاعات دانشجویان
```sql
-- نمایش اطلاعات کامل دانشجویان
SELECT * FROM student_details WHERE status = 'Active';

-- جستجوی دانشجویان بر اساس رشته
SELECT * FROM student_details WHERE major_name = 'Computer Science';
```

### 2. ویو اطلاعات اساتید
```sql
-- نمایش اطلاعات کامل اساتید
SELECT * FROM professor_details WHERE status = 'Active';

-- جستجوی اساتید بر اساس دانشکده
SELECT * FROM professor_details WHERE department_name = 'Faculty of Computer Engineering';
```

### 3. ویو اطلاعات دروس
```sql
-- نمایش اطلاعات کامل دروس
SELECT * FROM course_details WHERE status = 'Active';

-- جستجوی دروس بر اساس ترم
SELECT * FROM course_details WHERE semester = 'Fall' AND academic_year = 2024;
```

### 4. ویو محاسبه GPA
```sql
-- نمایش GPA دانشجویان
SELECT * FROM student_gpa ORDER BY calculated_gpa DESC;

-- جستجوی دانشجویان با GPA بالا
SELECT * FROM student_gpa WHERE calculated_gpa >= 3.5;
```

### 5. ویو آمار دانشکده‌ها
```sql
-- نمایش آمار کلی دانشکده‌ها
SELECT * FROM department_statistics ORDER BY total_students DESC;

-- جستجوی دانشکده با بیشترین تعداد دانشجو
SELECT * FROM department_statistics WHERE total_students = (SELECT MAX(total_students) FROM department_statistics);
```

## مدیریت تراکنش‌ها

### 1. شروع تراکنش
```sql
BEGIN;
```

### 2. اجرای عملیات
```sql
-- عملیات‌های مختلف
INSERT INTO students (...) VALUES (...);
UPDATE students SET ... WHERE ...;
DELETE FROM students WHERE ...;
```

### 3. تایید یا لغو تراکنش
```sql
-- تایید تراکنش
COMMIT;

-- لغو تراکنش
ROLLBACK;
```

## مدیریت خطاها

### 1. بررسی خطاها
```sql
-- بررسی وضعیت دیتابیس
SHOW DATABASES;
SHOW TABLES;
SHOW INDEXES FROM students;
```

### 2. عیب‌یابی پرس و جوها
```sql
-- نمایش پلان اجرای پرس و جو
EXPLAIN SELECT * FROM students WHERE student_number = 'STU100';

-- نمایش آمار جداول
SHOW STATISTICS FOR TABLE students;
```

## نکات مهم

### 1. بهینه‌سازی پرس و جوها
- استفاده از ایندکس‌های مناسب
- اجتناب از SELECT *
- استفاده از LIMIT برای پرس و جوهای بزرگ
- استفاده از WHERE برای فیلتر کردن داده‌ها

### 2. امنیت
- استفاده از پارامترهای امن در پرس و جوها
- محدود کردن دسترسی کاربران
- رمزگذاری اطلاعات حساس

### 3. پشتیبان‌گیری
- پشتیبان‌گیری منظم از دیتابیس
- تست بازیابی پشتیبان‌ها
- نگهداری چندین نسخه پشتیبان

### 4. مانیتورینگ
- نظارت بر عملکرد دیتابیس
- بررسی استفاده از منابع
- شناسایی مشکلات احتمالی
