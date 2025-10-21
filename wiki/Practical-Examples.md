# مثال‌های عملی CockroachDB با سیستم مدیریت دانشگاه

## مقدمه

این فایل شامل مثال‌های عملی و پیشرفته برای کار با CockroachDB در سیستم مدیریت دانشگاه است. تمام مثال‌ها بر اساس دیتابیس موجود طراحی شده‌اند.

## مثال‌های پایه

### 1. ایجاد و مدیریت دیتابیس

```sql
-- اتصال به CockroachDB
cockroach sql --insecure --host=localhost:26257

-- ایجاد دیتابیس
CREATE DATABASE university_management;

-- استفاده از دیتابیس
USE university_management;

-- نمایش دیتابیس‌ها
SHOW DATABASES;
```

### 2. ایجاد جداول اصلی

```sql
-- ایجاد جدول دانشکده‌ها
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

-- ایجاد جدول رشته‌ها
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
```

### 3. درج داده‌های نمونه

```sql
-- درج دانشکده‌ها
INSERT INTO departments (department_name, department_code, dean_name, dean_email, building_name) VALUES
('دانشکده مهندسی کامپیوتر', 'CE', 'دکتر احمد رضایی', 'ahmad.rezaei@university.edu', 'ساختمان مهندسی A'),
('دانشکده مهندسی برق', 'EE', 'دکتر مریم کریمی', 'maryam.karimi@university.edu', 'ساختمان مهندسی B'),
('دانشکده علوم پایه', 'BS', 'دکتر فاطمه احمدی', 'fatemeh.ahmadi@university.edu', 'ساختمان علوم');

-- درج رشته‌ها
INSERT INTO majors (major_name, major_code, department_id, degree_level, credits_required, duration_years) 
SELECT 
    'مهندسی کامپیوتر',
    'CS',
    d.department_id,
    'Bachelor',
    140,
    4
FROM departments d WHERE d.department_code = 'CE';
```

## مثال‌های پیشرفته

### 1. مدیریت دانشجویان

#### ایجاد جدول دانشجویان
```sql
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
```

#### درج دانشجویان نمونه
```sql
-- درج دانشجویان
INSERT INTO students (student_number, first_name, last_name, national_id, email, phone, date_of_birth, gender, enrollment_date, major_id, gpa) 
SELECT 
    'STU001',
    'علی',
    'احمدی',
    '1234567890',
    'ali.ahmadi@student.university.edu',
    '+98-21-12345678',
    '2000-01-15',
    'Male',
    '2024-09-01',
    m.major_id,
    3.75
FROM majors m WHERE m.major_code = 'CS';

INSERT INTO students (student_number, first_name, last_name, national_id, email, phone, date_of_birth, gender, enrollment_date, major_id, gpa) 
SELECT 
    'STU002',
    'فاطمه',
    'محمدی',
    '1234567891',
    'fatemeh.mohammadi@student.university.edu',
    '+98-21-12345679',
    '2001-03-20',
    'Female',
    '2024-09-01',
    m.major_id,
    3.90
FROM majors m WHERE m.major_code = 'CS';
```

#### جستجوی دانشجویان
```sql
-- جستجوی دانشجویان بر اساس نام
SELECT 
    student_number,
    first_name,
    last_name,
    email,
    gpa
FROM students 
WHERE first_name LIKE '%علی%' OR last_name LIKE '%احمدی%';

-- جستجوی دانشجویان با معدل بالا
SELECT 
    student_number,
    first_name,
    last_name,
    gpa,
    enrollment_date
FROM students 
WHERE gpa > 3.5 
ORDER BY gpa DESC;

-- آمار دانشجویان بر اساس وضعیت
SELECT 
    status,
    COUNT(*) AS count,
    AVG(gpa) AS average_gpa,
    MIN(gpa) AS min_gpa,
    MAX(gpa) AS max_gpa
FROM students 
GROUP BY status;
```

### 2. مدیریت دروس

#### ایجاد جدول دروس
```sql
CREATE TABLE courses (
    course_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT,
    credits INTEGER NOT NULL,
    department_id UUID NOT NULL,
    professor_id UUID,
    prerequisites TEXT,
    course_type VARCHAR(20) CHECK (course_type IN ('Core', 'Elective', 'General')),
    semester VARCHAR(20) CHECK (semester IN ('Fall', 'Spring', 'Summer')),
    academic_year INTEGER NOT NULL,
    max_students INTEGER DEFAULT 30,
    current_students INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Cancelled')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT
);
```

#### درج دروس نمونه
```sql
-- درج دروس
INSERT INTO courses (course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students) 
SELECT 
    'CS101',
    'مقدمات برنامه‌نویسی',
    'آموزش مفاهیم پایه برنامه‌نویسی با Python و Java',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO courses (course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students) 
SELECT 
    'CS102',
    'ساختمان داده‌ها',
    'آموزش ساختارهای داده و الگوریتم‌ها',
    4,
    d.department_id,
    'Core',
    'Spring',
    2024,
    35
FROM departments d WHERE d.department_code = 'CE';
```

#### جستجوی دروس
```sql
-- جستجوی دروس بر اساس دانشکده
SELECT 
    c.course_code,
    c.course_name,
    c.credits,
    c.current_students,
    c.max_students,
    d.department_name
FROM courses c
JOIN departments d ON c.department_id = d.department_id
WHERE d.department_code = 'CE';

-- جستجوی دروس با ظرفیت خالی
SELECT 
    course_code,
    course_name,
    current_students,
    max_students,
    (max_students - current_students) AS available_spots
FROM courses 
WHERE current_students < max_students AND status = 'Active';

-- آمار دروس
SELECT 
    course_type,
    COUNT(*) AS course_count,
    SUM(credits) AS total_credits,
    AVG(current_students) AS average_students
FROM courses 
GROUP BY course_type;
```

### 3. مدیریت ثبت‌نام‌ها

#### ایجاد جدول ثبت‌نام‌ها
```sql
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
```

#### ثبت‌نام دانشجو در درس
```sql
-- ثبت‌نام دانشجو در درس
INSERT INTO enrollments (student_id, course_id, enrollment_date, semester, academic_year) 
SELECT 
    s.student_id,
    c.course_id,
    CURRENT_DATE,
    'Fall',
    2024
FROM students s, courses c 
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';

-- به‌روزرسانی تعداد دانشجویان درس
UPDATE courses 
SET current_students = current_students + 1 
WHERE course_id = (
    SELECT course_id FROM courses WHERE course_code = 'CS101'
);
```

#### جستجوی ثبت‌نام‌ها
```sql
-- نمایش ثبت‌نام‌های دانشجو
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    c.credits,
    e.enrollment_date,
    e.status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_number = 'STU001';

-- نمایش دانشجویان یک درس
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    s.email,
    e.enrollment_date,
    e.status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101';
```

### 4. مدیریت نمرات

#### ایجاد جدول نمرات
```sql
CREATE TABLE grades (
    grade_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    enrollment_id UUID NOT NULL,
    assignment_type VARCHAR(50) NOT NULL,
    assignment_name VARCHAR(100),
    points_earned DECIMAL(5,2) NOT NULL,
    points_possible DECIMAL(5,2) NOT NULL,
    percentage DECIMAL(5,2) GENERATED ALWAYS AS (points_earned / points_possible * 100) STORED,
    grade_letter VARCHAR(2),
    comments TEXT,
    graded_date DATE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE
);
```

#### ثبت نمره
```sql
-- ثبت نمره
INSERT INTO grades (enrollment_id, assignment_type, assignment_name, points_earned, points_possible, grade_letter, graded_date) 
SELECT 
    e.enrollment_id,
    'Quiz',
    'کوئیز 1',
    18.0,
    20.0,
    'A',
    CURRENT_DATE
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';

-- ثبت نمره میان‌ترم
INSERT INTO grades (enrollment_id, assignment_type, assignment_name, points_earned, points_possible, grade_letter, graded_date) 
SELECT 
    e.enrollment_id,
    'Midterm',
    'امتحان میان‌ترم',
    42.0,
    50.0,
    'B',
    CURRENT_DATE
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';
```

#### جستجوی نمرات
```sql
-- نمایش نمرات دانشجو
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    g.assignment_type,
    g.assignment_name,
    g.points_earned,
    g.points_possible,
    g.percentage,
    g.grade_letter,
    g.graded_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_number = 'STU001'
ORDER BY g.graded_date DESC;

-- محاسبه معدل دانشجو
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    AVG(g.percentage) AS average_percentage,
    CASE 
        WHEN AVG(g.percentage) >= 90 THEN 'A'
        WHEN AVG(g.percentage) >= 80 THEN 'B'
        WHEN AVG(g.percentage) >= 70 THEN 'C'
        WHEN AVG(g.percentage) >= 60 THEN 'D'
        ELSE 'F'
    END AS final_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_number = 'STU001'
GROUP BY s.student_number, s.first_name, s.last_name, c.course_code, c.course_name;
```

## مثال‌های پیشرفته

### 1. ویوها

#### ایجاد ویو اطلاعات دانشجویان
```sql
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
```

#### استفاده از ویو
```sql
-- نمایش اطلاعات کامل دانشجویان
SELECT * FROM student_details WHERE status = 'Active';

-- جستجوی دانشجویان بر اساس رشته
SELECT * FROM student_details WHERE major_name = 'مهندسی کامپیوتر';

-- آمار دانشجویان بر اساس دانشکده
SELECT 
    department_name,
    COUNT(*) AS student_count,
    AVG(gpa) AS average_gpa
FROM student_details 
GROUP BY department_name;
```

### 2. ایندکس‌ها

#### ایجاد ایندکس‌های بهینه
```sql
-- ایندکس بر روی شماره دانشجویی
CREATE INDEX idx_students_number ON students(student_number);

-- ایندکس بر روی ایمیل
CREATE INDEX idx_students_email ON students(email);

-- ایندکس ترکیبی
CREATE INDEX idx_students_major_status ON students(major_id, status);

-- ایندکس جزئی
CREATE INDEX idx_students_active ON students(student_id) WHERE status = 'Active';
```

#### بررسی عملکرد ایندکس‌ها
```sql
-- بررسی پلان اجرای پرس و جو
EXPLAIN SELECT * FROM students WHERE student_number = 'STU001';

-- بررسی آمار ایندکس‌ها
SELECT 
    index_name,
    table_name,
    index_definition
FROM information_schema.statistics 
WHERE table_name = 'students';
```

### 3. تراکنش‌ها

#### تراکنش ثبت‌نام
```sql
-- شروع تراکنش
BEGIN;

-- بررسی ظرفیت درس
SELECT current_students, max_students 
FROM courses 
WHERE course_code = 'CS101' FOR UPDATE;

-- ثبت‌نام دانشجو
INSERT INTO enrollments (student_id, course_id, enrollment_date, semester, academic_year)
SELECT 
    s.student_id,
    c.course_id,
    CURRENT_DATE,
    'Fall',
    2024
FROM students s, courses c 
WHERE s.student_number = 'STU001' AND c.course_code = 'CS101';

-- به‌روزرسانی تعداد دانشجویان
UPDATE courses 
SET current_students = current_students + 1 
WHERE course_code = 'CS101';

-- تایید تراکنش
COMMIT;
```

### 4. پرس و جوهای پیچیده

#### آمار کلی دانشگاه
```sql
-- آمار کلی
SELECT 
    'Total Students' AS metric,
    COUNT(*) AS count
FROM students
UNION ALL
SELECT 
    'Active Students' AS metric,
    COUNT(*) AS count
FROM students WHERE status = 'Active'
UNION ALL
SELECT 
    'Total Courses' AS metric,
    COUNT(*) AS count
FROM courses
UNION ALL
SELECT 
    'Active Courses' AS metric,
    COUNT(*) AS count
FROM courses WHERE status = 'Active'
UNION ALL
SELECT 
    'Total Enrollments' AS metric,
    COUNT(*) AS count
FROM enrollments;
```

#### دانشجویان با بهترین عملکرد
```sql
-- دانشجویان با بهترین عملکرد
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    m.major_name,
    d.department_name,
    COUNT(e.enrollment_id) AS completed_courses,
    AVG(g.percentage) AS average_percentage,
    MAX(g.percentage) AS best_grade,
    MIN(g.percentage) AS worst_grade
FROM students s
JOIN majors m ON s.major_id = m.major_id
JOIN departments d ON m.department_id = d.department_id
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE e.status = 'Completed' AND g.percentage IS NOT NULL
GROUP BY s.student_number, s.first_name, s.last_name, m.major_name, d.department_name
HAVING COUNT(e.enrollment_id) >= 3
ORDER BY average_percentage DESC
LIMIT 10;
```

#### آمار دروس
```sql
-- آمار دروس
SELECT 
    c.course_code,
    c.course_name,
    d.department_name,
    c.current_students,
    c.max_students,
    ROUND((c.current_students::float / c.max_students) * 100, 2) AS occupancy_rate,
    AVG(g.percentage) AS average_grade
FROM courses c
JOIN departments d ON c.department_id = d.department_id
LEFT JOIN enrollments e ON c.course_id = e.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE c.status = 'Active'
GROUP BY c.course_code, c.course_name, d.department_name, c.current_students, c.max_students
ORDER BY occupancy_rate DESC;
```

### 5. گزارش‌گیری

#### گزارش عملکرد دانشجویان
```sql
-- گزارش عملکرد دانشجویان
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    m.major_name,
    d.department_name,
    COUNT(e.enrollment_id) AS total_enrollments,
    COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) AS completed_courses,
    COUNT(CASE WHEN e.status = 'Failed' THEN 1 END) AS failed_courses,
    AVG(CASE WHEN e.status = 'Completed' THEN g.percentage END) AS average_grade,
    s.gpa
FROM students s
JOIN majors m ON s.major_id = m.major_id
JOIN departments d ON m.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_number, s.first_name, s.last_name, m.major_name, d.department_name, s.gpa
ORDER BY s.gpa DESC;
```

#### گزارش دروس
```sql
-- گزارش دروس
SELECT 
    c.course_code,
    c.course_name,
    d.department_name,
    c.credits,
    c.current_students,
    c.max_students,
    ROUND((c.current_students::float / c.max_students) * 100, 2) AS occupancy_rate,
    COUNT(g.grade_id) AS total_grades,
    AVG(g.percentage) AS average_grade,
    MAX(g.percentage) AS highest_grade,
    MIN(g.percentage) AS lowest_grade
FROM courses c
JOIN departments d ON c.department_id = d.department_id
LEFT JOIN enrollments e ON c.course_id = e.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE c.status = 'Active'
GROUP BY c.course_code, c.course_name, d.department_name, c.credits, c.current_students, c.max_students
ORDER BY occupancy_rate DESC;
```

## نکات مهم

### 1. بهینه‌سازی پرس و جوها
- همیشه از ایندکس‌های مناسب استفاده کنید
- از SELECT * اجتناب کنید
- از LIMIT برای پرس و جوهای بزرگ استفاده کنید
- از EXPLAIN برای بررسی پلان اجرا استفاده کنید

### 2. مدیریت تراکنش‌ها
- از تراکنش‌ها برای عملیات‌های پیچیده استفاده کنید
- از FOR UPDATE برای قفل کردن ردیف‌ها استفاده کنید
- تراکنش‌ها را کوتاه نگه دارید

### 3. امنیت
- از پارامترهای امن در پرس و جوها استفاده کنید
- دسترسی کاربران را محدود کنید
- لاگ‌های امنیتی را بررسی کنید

### 4. پشتیبان‌گیری
- پشتیبان‌گیری منظم انجام دهید
- پشتیبان‌ها را در مکان‌های مختلف نگهداری کنید
- تست بازیابی انجام دهید

این مثال‌ها به شما کمک می‌کنند تا با CockroachDB و سیستم مدیریت دانشگاه کار کنید و از قابلیت‌های کامل آن استفاده کنید.
