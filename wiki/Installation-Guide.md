# راهنمای نصب و راه‌اندازی سیستم مدیریت دانشگاه

## مقدمه

این راهنما شامل تمام مراحل لازم برای نصب و راه‌اندازی سیستم مدیریت دانشگاه بر روی CockroachDB است.

## پیش‌نیازها

### نرم‌افزارهای مورد نیاز:
- Docker
- Docker Compose
- Git
- CockroachDB (اختیاری برای دسترسی مستقیم)

### حداقل سیستم:
- RAM: 4GB
- CPU: 2 Core
- Disk: 20GB
- OS: Linux, macOS, Windows

## نصب و راه‌اندازی

### مرحله 1: کلون کردن پروژه

```bash
# کلون کردن پروژه
git clone <repository-url>
cd CockroachDB

# بررسی ساختار پروژه
ls -la
```

### مرحله 2: راه‌اندازی CockroachDB

#### روش 1: استفاده از Docker (پیشنهادی)

```bash
# راه‌اندازی CockroachDB با Docker
docker run -d \
  --name=cockroachdb \
  -p 26257:26257 \
  -p 8080:8080 \
  cockroachdb/cockroach:latest \
  start-single-node --insecure

# بررسی وضعیت
docker ps
```

#### روش 2: استفاده از Docker Compose

```bash
# راه‌اندازی با Docker Compose
cd docker
docker-compose up -d

# بررسی وضعیت
docker-compose ps
```

### مرحله 3: راه‌اندازی دیتابیس

```bash
# اجرای اسکریپت راه‌اندازی
chmod +x scripts/init_database.sh
./scripts/init_database.sh
```

### مرحله 4: بررسی نصب

```bash
# اتصال به دیتابیس
cockroach sql --insecure --host=localhost:26257 --database=university_management

# بررسی جداول
SHOW TABLES;

# بررسی داده‌ها
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM professors;
SELECT COUNT(*) FROM courses;
```

## دسترسی به سیستم

### 1. رابط وب CockroachDB
```
http://localhost:8080
```

### 2. اتصال از طریق خط فرمان
```bash
cockroach sql --insecure --host=localhost:26257 --database=university_management
```

### 3. اتصال از طریق برنامه‌های کاربردی
```python
import psycopg2

# اتصال به دیتابیس
conn = psycopg2.connect(
    host="localhost",
    port=26257,
    database="university_management",
    user="root",
    password=""
)
```

## تست سیستم

### 1. تست اتصال
```sql
-- بررسی اتصال
SELECT 'Connection successful' AS status;

-- بررسی دیتابیس
SELECT current_database();
```

### 2. تست داده‌ها
```sql
-- بررسی دانشجویان
SELECT student_number, first_name, last_name, gpa 
FROM students 
LIMIT 5;

-- بررسی اساتید
SELECT employee_number, first_name, last_name, rank 
FROM professors 
LIMIT 5;

-- بررسی دروس
SELECT course_code, course_name, credits 
FROM courses 
LIMIT 5;
```

### 3. تست پرس و جوهای پیچیده
```sql
-- تست ویوها
SELECT * FROM student_details LIMIT 5;
SELECT * FROM professor_details LIMIT 5;
SELECT * FROM course_details LIMIT 5;

-- تست آمار
SELECT * FROM department_statistics;
```

## پشتیبان‌گیری

### 1. پشتیبان‌گیری دستی
```bash
# پشتیبان‌گیری کامل
./scripts/backup_database.sh full

# پشتیبان‌گیری ساختاری
./scripts/backup_database.sh schema

# پشتیبان‌گیری داده‌ای
./scripts/backup_database.sh data
```

### 2. پشتیبان‌گیری خودکار
```bash
# تنظیم cron job برای پشتیبان‌گیری روزانه
echo "0 2 * * * /path/to/backup_database.sh full" | crontab -
```

## مانیتورینگ

### 1. مانیتورینگ سیستم
```bash
# بررسی وضعیت Docker
docker ps
docker stats

# بررسی لاگ‌ها
docker logs cockroachdb -f
```

### 2. مانیتورینگ دیتابیس
```sql
-- بررسی وضعیت دیتابیس
SELECT * FROM crdb_internal.cluster_queries;

-- بررسی آمار جداول
SELECT 
    table_name,
    table_rows,
    total_size
FROM crdb_internal.tables 
WHERE database_name = 'university_management';
```

## عیب‌یابی

### 1. مشکلات رایج

#### مشکل اتصال
```bash
# بررسی وضعیت سرویس
docker ps | grep cockroach

# بررسی پورت‌ها
netstat -tlnp | grep 26257

# راه‌اندازی مجدد
docker restart cockroachdb
```

#### مشکل عملکرد
```sql
-- بررسی پرس و جوهای کند
SELECT 
    query,
    duration,
    start_time
FROM crdb_internal.cluster_queries 
WHERE status = 'running'
ORDER BY duration DESC;
```

### 2. راه‌حل‌ها

#### راه‌حل مشکل اتصال
```bash
# بررسی لاگ‌ها
docker logs cockroachdb

# راه‌اندازی مجدد
docker restart cockroachdb

# بررسی پورت‌ها
docker port cockroachdb
```

#### راه‌حل مشکل عملکرد
```sql
-- بهینه‌سازی جداول
ANALYZE students;
ANALYZE professors;
ANALYZE courses;

-- بررسی ایندکس‌ها
SHOW INDEXES FROM students;
```

## به‌روزرسانی

### 1. به‌روزرسانی CockroachDB
```bash
# توقف سرویس
docker stop cockroachdb

# حذف کانتینر قدیمی
docker rm cockroachdb

# راه‌اندازی نسخه جدید
docker run -d \
  --name=cockroachdb \
  -p 26257:26257 \
  -p 8080:8080 \
  cockroachdb/cockroach:latest \
  start-single-node --insecure
```

### 2. به‌روزرسانی پروژه
```bash
# به‌روزرسانی کد
git pull origin main

# اجرای اسکریپت‌های جدید
./scripts/init_database.sh
```

## امنیت

### 1. تنظیمات امنیتی
```bash
# محدود کردن دسترسی به پورت‌ها
ufw allow 26257
ufw allow 8080

# تنظیم فایروال
ufw enable
```

### 2. بررسی امنیت
```sql
-- بررسی کاربران
SELECT * FROM crdb_internal.users;

-- بررسی دسترسی‌ها
SELECT * FROM crdb_internal.privileges;
```

## نگهداری

### 1. نگهداری روزانه
- بررسی وضعیت سیستم
- بررسی لاگ‌ها
- بررسی عملکرد

### 2. نگهداری هفتگی
- پشتیبان‌گیری
- بهینه‌سازی
- پاکسازی

### 3. نگهداری ماهانه
- بررسی امنیت
- بررسی عملکرد
- به‌روزرسانی

## پشتیبانی

### 1. مستندات
- `docs/database_guide.md`: راهنمای کامل دیتابیس
- `docs/usage_guide.md`: راهنمای استفاده
- `docs/maintenance_guide.md`: راهنمای نگهداری

### 2. اسکریپت‌ها
- `scripts/init_database.sh`: راه‌اندازی دیتابیس
- `scripts/backup_database.sh`: پشتیبان‌گیری

### 3. فایل‌های Docker
- `docker/docker-compose.yml`: تنظیمات Docker Compose
- `docker/Dockerfile`: تنظیمات Docker

## نکات مهم

### 1. بهینه‌سازی
- استفاده از ایندکس‌های مناسب
- بهینه‌سازی پرس و جوها
- نظارت بر عملکرد سیستم

### 2. امنیت
- به‌روزرسانی منظم سیستم
- بررسی لاگ‌های امنیتی
- محدود کردن دسترسی‌ها

### 3. پشتیبان‌گیری
- پشتیبان‌گیری منظم
- تست بازیابی
- نگهداری چندین نسخه پشتیبان

### 4. مانیتورینگ
- نظارت بر عملکرد سیستم
- بررسی استفاده از منابع
- شناسایی مشکلات احتمالی
