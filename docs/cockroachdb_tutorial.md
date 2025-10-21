# آموزش کامل CockroachDB از صفر تا صد

## مقدمه

CockroachDB یک دیتابیس توزیع‌شده (Distributed Database) است که برای مقیاس‌پذیری، قابلیت اطمینان و عملکرد بالا طراحی شده است. این دیتابیس از SQL استاندارد پشتیبانی می‌کند و برای برنامه‌های کاربردی که نیاز به قابلیت اطمینان بالا دارند، ایده‌آل است.

## فهرست مطالب

1. [مقدمه و مفاهیم پایه](#مقدمه-و-مفاهیم-پایه)
2. [نصب و راه‌اندازی](#نصب-و-راه‌اندازی)
3. [مفاهیم اولیه](#مفاهیم-اولیه)
4. [مدیریت دیتابیس](#مدیریت-دیتابیس)
5. [مدیریت جداول](#مدیریت-جداول)
6. [مدیریت داده‌ها](#مدیریت-داده‌ها)
7. [پرس و جوها](#پرس-و-جوها)
8. [ایندکس‌ها](#ایندکس‌ها)
9. [تراکنش‌ها](#تراکنش‌ها)
10. [امنیت](#امنیت)
11. [بهینه‌سازی](#بهینه‌سازی)
12. [مانیتورینگ](#مانیتورینگ)
13. [پشتیبان‌گیری و بازیابی](#پشتیبان‌گیری-و-بازیابی)
14. [مثال‌های عملی](#مثال‌های-عملی)

## مقدمه و مفاهیم پایه

### CockroachDB چیست؟

CockroachDB یک دیتابیس SQL توزیع‌شده است که:
- **مقیاس‌پذیر**: می‌تواند به راحتی گسترش یابد
- **قابل اطمینان**: حتی در صورت خرابی گره‌ها، به کار ادامه می‌دهد
- **سازگار با SQL**: از SQL استاندارد پشتیبانی می‌کند
- **ACID**: از ویژگی‌های ACID پشتیبانی می‌کند

### ویژگی‌های کلیدی

1. **توزیع‌شده**: داده‌ها روی چندین گره ذخیره می‌شوند
2. **مقاوم در برابر خرابی**: حتی اگر نیمی از گره‌ها خراب شوند، سیستم کار می‌کند
3. **مقیاس‌پذیری افقی**: می‌توان گره‌های جدید اضافه کرد
4. **سازگاری جغرافیایی**: می‌توان گره‌ها را در مناطق مختلف قرار داد

## نصب و راه‌اندازی

### روش 1: استفاده از Docker (پیشنهادی)

```bash
# نصب CockroachDB با Docker
docker run -d \
  --name=cockroachdb \
  -p 26257:26257 \
  -p 8080:8080 \
  cockroachdb/cockroach:latest \
  start-single-node --insecure

# بررسی وضعیت
docker ps
```

### روش 2: نصب مستقیم

```bash
# دانلود و نصب CockroachDB
wget https://binaries.cockroachdb.com/cockroach-v23.1.0.linux-amd64.tgz
tar -xzf cockroach-v23.1.0.linux-amd64.tgz
sudo cp cockroach-v23.1.0.linux-amd64/cockroach /usr/local/bin/
```

### بررسی نصب

```bash
# بررسی نسخه
cockroach version

# بررسی وضعیت
cockroach node status --insecure --host=localhost:26257
```

## مفاهیم اولیه

### 1. گره (Node)
گره یک نمونه از CockroachDB است که می‌تواند داده‌ها را ذخیره و پردازش کند.

### 2. خوشه (Cluster)
خوشه مجموعه‌ای از گره‌ها است که با هم کار می‌کنند.

### 3. دیتابیس (Database)
دیتابیس مجموعه‌ای از جداول مرتبط است.

### 4. جدول (Table)
جدول ساختاری برای ذخیره داده‌ها است.

### 5. ردیف (Row)
ردیف یک رکورد در جدول است.

### 6. ستون (Column)
ستون یک فیلد در جدول است.

## مدیریت دیتابیس

### اتصال به دیتابیس

```bash
# اتصال به دیتابیس
cockroach sql --insecure --host=localhost:26257

# اتصال به دیتابیس خاص
cockroach sql --insecure --host=localhost:26257 --database=university_management
```

### ایجاد دیتابیس

```sql
-- ایجاد دیتابیس جدید
CREATE DATABASE university_management;

-- استفاده از دیتابیس
USE university_management;

-- نمایش دیتابیس‌ها
SHOW DATABASES;
```

### حذف دیتابیس

```sql
-- حذف دیتابیس
DROP DATABASE university_management;
```

## مدیریت جداول

### ایجاد جدول

```sql
-- ایجاد جدول دانشجویان
CREATE TABLE students (
    student_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT now()
);
```

### انواع داده‌ها

#### انواع داده‌های عددی
```sql
-- اعداد صحیح
INTEGER, BIGINT, SMALLINT

-- اعداد اعشاری
DECIMAL(10,2), FLOAT, REAL

-- مثال
CREATE TABLE example_numbers (
    id INTEGER,
    price DECIMAL(10,2),
    percentage FLOAT
);
```

#### انواع داده‌های متنی
```sql
-- متن
VARCHAR(100), TEXT, CHAR(10)

-- مثال
CREATE TABLE example_text (
    id INTEGER,
    name VARCHAR(100),
    description TEXT
);
```

#### انواع داده‌های تاریخ و زمان
```sql
-- تاریخ و زمان
DATE, TIME, TIMESTAMP, TIMESTAMPTZ

-- مثال
CREATE TABLE example_dates (
    id INTEGER,
    birth_date DATE,
    created_at TIMESTAMP DEFAULT now()
);
```

#### انواع داده‌های خاص
```sql
-- UUID
UUID

-- Boolean
BOOLEAN

-- JSON
JSONB

-- مثال
CREATE TABLE example_special (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    is_active BOOLEAN DEFAULT true,
    metadata JSONB
);
```

### محدودیت‌ها (Constraints)

#### محدودیت‌های اصلی
```sql
-- PRIMARY KEY
CREATE TABLE students (
    student_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_number VARCHAR(20) UNIQUE NOT NULL
);

-- FOREIGN KEY
CREATE TABLE enrollments (
    enrollment_id UUID PRIMARY KEY,
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- CHECK
CREATE TABLE students (
    student_id UUID PRIMARY KEY,
    age INTEGER CHECK (age >= 18 AND age <= 100),
    gpa DECIMAL(3,2) CHECK (gpa >= 0.0 AND gpa <= 4.0)
);
```

#### محدودیت‌های NOT NULL و UNIQUE
```sql
CREATE TABLE students (
    student_id UUID PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) -- می‌تواند NULL باشد
);
```

### نمایش جداول

```sql
-- نمایش تمام جداول
SHOW TABLES;

-- نمایش ساختار جدول
DESCRIBE students;

-- نمایش اطلاعات جدول
SHOW CREATE TABLE students;
```

### تغییر ساختار جدول

```sql
-- اضافه کردن ستون
ALTER TABLE students ADD COLUMN address TEXT;

-- حذف ستون
ALTER TABLE students DROP COLUMN phone;

-- تغییر نوع ستون
ALTER TABLE students ALTER COLUMN age TYPE INTEGER;

-- اضافه کردن محدودیت
ALTER TABLE students ADD CONSTRAINT check_age CHECK (age >= 18);
```

### حذف جدول

```sql
-- حذف جدول
DROP TABLE students;

-- حذف جدول با بررسی وجود
DROP TABLE IF EXISTS students;
```

## مدیریت داده‌ها

### درج داده (INSERT)

#### درج یک ردیف
```sql
-- درج یک دانشجوی جدید
INSERT INTO students (
    student_number, first_name, last_name, email, enrollment_date
) VALUES (
    'STU001', 'علی', 'احمدی', 'ali.ahmadi@university.edu', '2024-09-01'
);
```

#### درج چندین ردیف
```sql
-- درج چندین دانشجوی جدید
INSERT INTO students (student_number, first_name, last_name, email, enrollment_date) VALUES
('STU002', 'فاطمه', 'محمدی', 'fatemeh.mohammadi@university.edu', '2024-09-01'),
('STU003', 'حسن', 'کریمی', 'hassan.karimi@university.edu', '2024-09-01'),
('STU004', 'مریم', 'رضایی', 'maryam.rezaei@university.edu', '2024-09-01');
```

#### درج با استفاده از SELECT
```sql
-- کپی داده‌ها از جدول دیگر
INSERT INTO students_backup 
SELECT * FROM students WHERE status = 'Active';
```

### به‌روزرسانی داده (UPDATE)

#### به‌روزرسانی یک ردیف
```sql
-- به‌روزرسانی اطلاعات یک دانشجو
UPDATE students 
SET phone = '+98-21-12345678', 
    address = 'تهران، ایران'
WHERE student_number = 'STU001';
```

#### به‌روزرسانی چندین ردیف
```sql
-- به‌روزرسانی وضعیت تمام دانشجویان
UPDATE students 
SET status = 'Graduated' 
WHERE enrollment_date < '2020-09-01';
```

#### به‌روزرسانی با استفاده از JOIN
```sql
-- به‌روزرسانی بر اساس جدول دیگر
UPDATE students 
SET gpa = (
    SELECT AVG(final_grade) 
    FROM enrollments 
    WHERE enrollments.student_id = students.student_id
);
```

### حذف داده (DELETE)

#### حذف یک ردیف
```sql
-- حذف یک دانشجو
DELETE FROM students WHERE student_number = 'STU001';
```

#### حذف چندین ردیف
```sql
-- حذف دانشجویان غیرفعال
DELETE FROM students WHERE status = 'Inactive';
```

#### حذف تمام ردیف‌ها
```sql
-- حذف تمام داده‌ها از جدول
DELETE FROM students;

-- یا استفاده از TRUNCATE (سریع‌تر)
TRUNCATE TABLE students;
```

### جستجوی داده (SELECT)

#### جستجوی ساده
```sql
-- نمایش تمام دانشجویان
SELECT * FROM students;

-- نمایش ستون‌های خاص
SELECT student_number, first_name, last_name FROM students;

-- محدود کردن تعداد ردیف‌ها
SELECT * FROM students LIMIT 10;
```

#### فیلتر کردن داده‌ها
```sql
-- فیلتر بر اساس شرط
SELECT * FROM students WHERE status = 'Active';

-- فیلتر بر اساس چندین شرط
SELECT * FROM students 
WHERE status = 'Active' AND enrollment_date >= '2024-09-01';

-- فیلتر با استفاده از LIKE
SELECT * FROM students WHERE first_name LIKE 'علی%';
```

#### مرتب‌سازی داده‌ها
```sql
-- مرتب‌سازی بر اساس یک ستون
SELECT * FROM students ORDER BY first_name;

-- مرتب‌سازی بر اساس چندین ستون
SELECT * FROM students ORDER BY status, first_name;

-- مرتب‌سازی نزولی
SELECT * FROM students ORDER BY enrollment_date DESC;
```

## پرس و جوها

### JOIN ها

#### INNER JOIN
```sql
-- نمایش اطلاعات دانشجویان با رشته‌هایشان
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    m.major_name,
    d.department_name
FROM students s
INNER JOIN majors m ON s.major_id = m.major_id
INNER JOIN departments d ON m.department_id = d.department_id;
```

#### LEFT JOIN
```sql
-- نمایش تمام دانشجویان حتی اگر رشته نداشته باشند
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    m.major_name
FROM students s
LEFT JOIN majors m ON s.major_id = m.major_id;
```

#### RIGHT JOIN
```sql
-- نمایش تمام رشته‌ها حتی اگر دانشجو نداشته باشند
SELECT 
    m.major_name,
    COUNT(s.student_id) AS student_count
FROM students s
RIGHT JOIN majors m ON s.major_id = m.major_id
GROUP BY m.major_name;
```

#### FULL OUTER JOIN
```sql
-- نمایش تمام دانشجویان و رشته‌ها
SELECT 
    s.student_number,
    m.major_name
FROM students s
FULL OUTER JOIN majors m ON s.major_id = m.major_id;
```

### GROUP BY و Aggregate Functions

#### توابع تجمعی
```sql
-- شمارش دانشجویان
SELECT COUNT(*) AS total_students FROM students;

-- میانگین معدل
SELECT AVG(gpa) AS average_gpa FROM students WHERE gpa IS NOT NULL;

-- حداکثر و حداقل معدل
SELECT MAX(gpa) AS max_gpa, MIN(gpa) AS min_gpa FROM students;

-- مجموع واحدها
SELECT SUM(credits) AS total_credits FROM courses;
```

#### GROUP BY
```sql
-- شمارش دانشجویان بر اساس رشته
SELECT 
    m.major_name,
    COUNT(s.student_id) AS student_count
FROM majors m
LEFT JOIN students s ON m.major_id = s.major_id
GROUP BY m.major_name;
```

#### HAVING
```sql
-- رشته‌هایی که بیش از 10 دانشجو دارند
SELECT 
    m.major_name,
    COUNT(s.student_id) AS student_count
FROM majors m
LEFT JOIN students s ON m.major_id = s.major_id
GROUP BY m.major_name
HAVING COUNT(s.student_id) > 10;
```

### Subqueries

#### Subquery در WHERE
```sql
-- دانشجویانی که معدل بالاتر از میانگین دارند
SELECT * FROM students 
WHERE gpa > (
    SELECT AVG(gpa) FROM students WHERE gpa IS NOT NULL
);
```

#### Subquery در SELECT
```sql
-- نمایش تعداد دروس هر دانشجو
SELECT 
    student_number,
    first_name,
    last_name,
    (SELECT COUNT(*) FROM enrollments WHERE student_id = s.student_id) AS course_count
FROM students s;
```

#### Subquery در FROM
```sql
-- استفاده از subquery به عنوان جدول
SELECT 
    major_name,
    student_count
FROM (
    SELECT 
        m.major_name,
        COUNT(s.student_id) AS student_count
    FROM majors m
    LEFT JOIN students s ON m.major_id = s.major_id
    GROUP BY m.major_name
) AS major_stats
WHERE student_count > 5;
```

### Window Functions

#### ROW_NUMBER
```sql
-- شماره‌گذاری دانشجویان بر اساس معدل
SELECT 
    student_number,
    first_name,
    last_name,
    gpa,
    ROW_NUMBER() OVER (ORDER BY gpa DESC) AS rank
FROM students
WHERE gpa IS NOT NULL;
```

#### RANK و DENSE_RANK
```sql
-- رتبه‌بندی دانشجویان
SELECT 
    student_number,
    first_name,
    last_name,
    gpa,
    RANK() OVER (ORDER BY gpa DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY gpa DESC) AS dense_rank
FROM students
WHERE gpa IS NOT NULL;
```

#### LAG و LEAD
```sql
-- مقایسه معدل با دانشجوی قبلی
SELECT 
    student_number,
    first_name,
    gpa,
    LAG(gpa) OVER (ORDER BY gpa DESC) AS previous_gpa,
    gpa - LAG(gpa) OVER (ORDER BY gpa DESC) AS difference
FROM students
WHERE gpa IS NOT NULL;
```

## ایندکس‌ها

### ایجاد ایندکس

#### ایندکس ساده
```sql
-- ایجاد ایندکس بر روی یک ستون
CREATE INDEX idx_students_number ON students(student_number);

-- ایجاد ایندکس بر روی چندین ستون
CREATE INDEX idx_students_name ON students(first_name, last_name);
```

#### ایندکس یکتا
```sql
-- ایجاد ایندکس یکتا
CREATE UNIQUE INDEX idx_students_email ON students(email);
```

#### ایندکس جزئی
```sql
-- ایجاد ایندکس فقط برای دانشجویان فعال
CREATE INDEX idx_students_active ON students(student_id) 
WHERE status = 'Active';
```

### نمایش ایندکس‌ها

```sql
-- نمایش تمام ایندکس‌های یک جدول
SHOW INDEXES FROM students;

-- نمایش اطلاعات ایندکس‌ها
SELECT * FROM information_schema.statistics 
WHERE table_name = 'students';
```

### حذف ایندکس

```sql
-- حذف ایندکس
DROP INDEX idx_students_number;
```

### بهینه‌سازی ایندکس‌ها

```sql
-- بررسی استفاده از ایندکس‌ها
EXPLAIN SELECT * FROM students WHERE student_number = 'STU001';

-- بررسی پلان اجرای پرس و جو
EXPLAIN ANALYZE SELECT * FROM students WHERE status = 'Active';
```

## تراکنش‌ها

### شروع تراکنش

```sql
-- شروع تراکنش
BEGIN;

-- یا
START TRANSACTION;
```

### اجرای عملیات

```sql
-- عملیات‌های مختلف
INSERT INTO students (...) VALUES (...);
UPDATE students SET ... WHERE ...;
DELETE FROM students WHERE ...;
```

### تایید یا لغو تراکنش

```sql
-- تایید تراکنش
COMMIT;

-- لغو تراکنش
ROLLBACK;
```

### مثال عملی تراکنش

```sql
-- ثبت‌نام دانشجو در درس
BEGIN;

-- بررسی ظرفیت درس
SELECT current_students, max_students 
FROM courses 
WHERE course_id = 'course_id' FOR UPDATE;

-- ثبت‌نام دانشجو
INSERT INTO enrollments (student_id, course_id, enrollment_date, semester, academic_year)
VALUES ('student_id', 'course_id', CURRENT_DATE, 'Fall', 2024);

-- به‌روزرسانی تعداد دانشجویان
UPDATE courses 
SET current_students = current_students + 1 
WHERE course_id = 'course_id';

COMMIT;
```

### Isolation Levels

```sql
-- تنظیم سطح جداسازی
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- یا
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

## امنیت

### ایجاد کاربر

```sql
-- ایجاد کاربر جدید
CREATE USER admin_user WITH PASSWORD 'secure_password';

-- ایجاد کاربر با دسترسی‌های خاص
CREATE USER readonly_user WITH PASSWORD 'readonly_password';
```

### تنظیم دسترسی‌ها

```sql
-- اعطای دسترسی به دیتابیس
GRANT ALL ON DATABASE university_management TO admin_user;

-- اعطای دسترسی فقط خواندن
GRANT SELECT ON TABLE students TO readonly_user;

-- اعطای دسترسی به جدول خاص
GRANT INSERT, UPDATE, DELETE ON TABLE students TO admin_user;
```

### بررسی دسترسی‌ها

```sql
-- نمایش کاربران
SELECT * FROM crdb_internal.users;

-- نمایش دسترسی‌ها
SELECT * FROM crdb_internal.privileges;
```

### تغییر رمز عبور

```sql
-- تغییر رمز عبور کاربر
ALTER USER admin_user WITH PASSWORD 'new_password';
```

## بهینه‌سازی

### بهینه‌سازی پرس و جوها

#### استفاده از EXPLAIN
```sql
-- بررسی پلان اجرای پرس و جو
EXPLAIN SELECT * FROM students WHERE status = 'Active';

-- بررسی پلان با آمار
EXPLAIN ANALYZE SELECT * FROM students WHERE gpa > 3.5;
```

#### بهینه‌سازی SELECT
```sql
-- استفاده از ستون‌های خاص به جای *
SELECT student_number, first_name, last_name FROM students;

-- استفاده از LIMIT
SELECT * FROM students LIMIT 100;

-- استفاده از WHERE
SELECT * FROM students WHERE status = 'Active';
```

#### بهینه‌سازی JOIN
```sql
-- استفاده از INNER JOIN به جای LEFT JOIN
SELECT s.*, m.major_name 
FROM students s
INNER JOIN majors m ON s.major_id = m.major_id;

-- استفاده از ایندکس‌های مناسب
CREATE INDEX idx_students_major ON students(major_id);
```

### بهینه‌سازی جداول

#### ANALYZE
```sql
-- به‌روزرسانی آمار جداول
ANALYZE students;
ANALYZE professors;
ANALYZE courses;
```

#### VACUUM
```sql
-- پاکسازی فضای استفاده نشده
VACUUM students;
VACUUM professors;
```

### مانیتورینگ عملکرد

```sql
-- بررسی پرس و جوهای کند
SELECT 
    query,
    duration,
    start_time
FROM crdb_internal.cluster_queries 
WHERE status = 'running'
ORDER BY duration DESC;

-- بررسی آمار جداول
SELECT 
    table_name,
    table_rows,
    total_size
FROM crdb_internal.tables 
WHERE database_name = 'university_management';
```

## مانیتورینگ

### بررسی وضعیت سیستم

```sql
-- بررسی وضعیت گره‌ها
SELECT * FROM crdb_internal.gossip_nodes;

-- بررسی آمار کلی
SELECT * FROM crdb_internal.cluster_queries;

-- بررسی استفاده از حافظه
SELECT * FROM crdb_internal.node_metrics;
```

### بررسی لاگ‌ها

```bash
# بررسی لاگ‌های CockroachDB
tail -f /var/log/cockroach/cockroach.log

# بررسی لاگ‌های Docker
docker logs cockroachdb -f
```

### بررسی عملکرد

```sql
-- بررسی پرس و جوهای در حال اجرا
SELECT 
    query,
    duration,
    start_time,
    client_address
FROM crdb_internal.cluster_queries 
WHERE status = 'running';

-- بررسی آمار پرس و جوها
SELECT 
    query,
    count,
    avg_duration,
    max_duration
FROM crdb_internal.statement_statistics 
WHERE database_name = 'university_management';
```

## پشتیبان‌گیری و بازیابی

### پشتیبان‌گیری

#### پشتیبان‌گیری کامل
```bash
# پشتیبان‌گیری کامل دیتابیس
cockroach dump --insecure --host=localhost:26257 --database=university_management > backup_full.sql
```

#### پشتیبان‌گیری ساختاری
```bash
# پشتیبان‌گیری فقط ساختار
cockroach dump --insecure --host=localhost:26257 --database=university_management --schema-only > backup_schema.sql
```

#### پشتیبان‌گیری داده‌ای
```bash
# پشتیبان‌گیری فقط داده‌ها
cockroach dump --insecure --host=localhost:26257 --database=university_management --data-only > backup_data.sql
```

### بازیابی

#### بازیابی کامل
```bash
# بازیابی از پشتیبان
cockroach sql --insecure --host=localhost:26257 --database=university_management < backup_full.sql
```

#### بازیابی جزئی
```sql
-- بازیابی جدول خاص
INSERT INTO students SELECT * FROM students_backup;
```

### پشتیبان‌گیری خودکار

```bash
# ایجاد اسکریپت پشتیبان‌گیری
#!/bin/bash
BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"
cockroach dump --insecure --host=localhost:26257 --database=university_management > $BACKUP_FILE
echo "Backup completed: $BACKUP_FILE"
```

## مثال‌های عملی

### مثال 1: مدیریت دانشجویان

```sql
-- ایجاد جدول دانشجویان
CREATE TABLE students (
    student_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    gpa DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT now()
);

-- درج دانشجویان نمونه
INSERT INTO students (student_number, first_name, last_name, email, enrollment_date, gpa) VALUES
('STU001', 'علی', 'احمدی', 'ali.ahmadi@university.edu', '2024-09-01', 3.75),
('STU002', 'فاطمه', 'محمدی', 'fatemeh.mohammadi@university.edu', '2024-09-01', 3.90),
('STU003', 'حسن', 'کریمی', 'hassan.karimi@university.edu', '2024-09-01', 3.60);

-- جستجوی دانشجویان با معدل بالا
SELECT * FROM students WHERE gpa > 3.5 ORDER BY gpa DESC;

-- آمار دانشجویان
SELECT 
    status,
    COUNT(*) AS count,
    AVG(gpa) AS average_gpa
FROM students 
GROUP BY status;
```

### مثال 2: مدیریت دروس

```sql
-- ایجاد جدول دروس
CREATE TABLE courses (
    course_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL,
    max_students INTEGER DEFAULT 30,
    current_students INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT now()
);

-- درج دروس نمونه
INSERT INTO courses (course_code, course_name, credits, max_students) VALUES
('CS101', 'مقدمات برنامه‌نویسی', 3, 40),
('CS102', 'ساختمان داده‌ها', 4, 35),
('MATH101', 'حسابان 1', 4, 50);

-- جستجوی دروس با ظرفیت خالی
SELECT * FROM courses WHERE current_students < max_students;

-- آمار دروس
SELECT 
    course_code,
    course_name,
    current_students,
    max_students,
    ROUND((current_students::float / max_students) * 100, 2) AS occupancy_rate
FROM courses;
```

### مثال 3: مدیریت ثبت‌نام‌ها

```sql
-- ایجاد جدول ثبت‌نام‌ها
CREATE TABLE enrollments (
    enrollment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,
    enrollment_date DATE NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'Enrolled',
    final_grade DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

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

-- نمایش ثبت‌نام‌های دانشجو
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    e.enrollment_date,
    e.status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_number = 'STU001';
```

### مثال 4: مدیریت نمرات

```sql
-- ایجاد جدول نمرات
CREATE TABLE grades (
    grade_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    enrollment_id UUID NOT NULL,
    assignment_type VARCHAR(50) NOT NULL,
    assignment_name VARCHAR(100),
    points_earned DECIMAL(5,2) NOT NULL,
    points_possible DECIMAL(5,2) NOT NULL,
    percentage DECIMAL(5,2) GENERATED ALWAYS AS (points_earned / points_possible * 100) STORED,
    grade_letter VARCHAR(2),
    graded_date DATE,
    created_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

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

-- نمایش نمرات دانشجو
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    g.assignment_name,
    g.points_earned,
    g.points_possible,
    g.percentage,
    g.grade_letter
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_number = 'STU001';
```

### مثال 5: محاسبه معدل

```sql
-- محاسبه معدل دانشجو
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    COUNT(e.enrollment_id) AS completed_courses,
    AVG(e.final_grade) AS average_grade,
    CASE 
        WHEN AVG(e.final_grade) >= 90 THEN 'A'
        WHEN AVG(e.final_grade) >= 80 THEN 'B'
        WHEN AVG(e.final_grade) >= 70 THEN 'C'
        WHEN AVG(e.final_grade) >= 60 THEN 'D'
        ELSE 'F'
    END AS final_grade_letter
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Completed' AND e.final_grade IS NOT NULL
GROUP BY s.student_number, s.first_name, s.last_name;
```

### مثال 6: گزارش‌گیری پیشرفته

```sql
-- آمار کلی دانشگاه
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
FROM courses WHERE status = 'Active';

-- دانشجویان با بهترین عملکرد
SELECT 
    s.student_number,
    s.first_name,
    s.last_name,
    COUNT(e.enrollment_id) AS completed_courses,
    AVG(e.final_grade) AS average_grade,
    MAX(e.final_grade) AS best_grade,
    MIN(e.final_grade) AS worst_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Completed' AND e.final_grade IS NOT NULL
GROUP BY s.student_number, s.first_name, s.last_name
HAVING COUNT(e.enrollment_id) >= 3
ORDER BY average_grade DESC
LIMIT 10;
```

## نکات مهم

### 1. بهینه‌سازی
- همیشه از ایندکس‌های مناسب استفاده کنید
- از SELECT * اجتناب کنید
- از LIMIT برای پرس و جوهای بزرگ استفاده کنید
- از EXPLAIN برای بررسی پلان اجرا استفاده کنید

### 2. امنیت
- همیشه از پارامترهای امن در پرس و جوها استفاده کنید
- دسترسی کاربران را محدود کنید
- رمزهای عبور قوی استفاده کنید
- لاگ‌های امنیتی را بررسی کنید

### 3. پشتیبان‌گیری
- پشتیبان‌گیری منظم انجام دهید
- پشتیبان‌ها را در مکان‌های مختلف نگهداری کنید
- تست بازیابی انجام دهید
- پشتیبان‌های قدیمی را پاک کنید

### 4. مانیتورینگ
- عملکرد سیستم را نظارت کنید
- استفاده از منابع را بررسی کنید
- مشکلات را زود شناسایی کنید
- لاگ‌ها را بررسی کنید

## نتیجه‌گیری

CockroachDB یک دیتابیس قدرتمند و انعطاف‌پذیر است که برای برنامه‌های کاربردی مدرن ایده‌آل است. با استفاده از این راهنما، می‌توانید از قابلیت‌های کامل CockroachDB استفاده کنید و سیستم‌های مقیاس‌پذیر و قابل اطمینان بسازید.

برای یادگیری بیشتر، مستندات رسمی CockroachDB را مطالعه کنید و با مثال‌های عملی تمرین کنید.
