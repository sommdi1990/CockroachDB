# راهنمای نگهداری دیتابیس سیستم مدیریت دانشگاه

## مقدمه

این راهنما شامل تمام اطلاعات لازم برای نگهداری و مدیریت دیتابیس سیستم مدیریت دانشگاه است.

## نگهداری روزانه

### 1. بررسی وضعیت سیستم

#### بررسی وضعیت CockroachDB
```bash
# بررسی وضعیت گره‌ها
cockroach node status --insecure --host=localhost:26257

# بررسی وضعیت دیتابیس
cockroach sql --insecure --host=localhost:26257 --execute="SHOW DATABASES;"

# بررسی جداول
cockroach sql --insecure --host=localhost:26257 --database=university_management --execute="SHOW TABLES;"
```

#### بررسی استفاده از منابع
```bash
# بررسی استفاده از CPU
top -p $(pgrep cockroach)

# بررسی استفاده از حافظه
free -h

# بررسی استفاده از دیسک
df -h
```

### 2. بررسی لاگ‌ها

#### بررسی لاگ‌های CockroachDB
```bash
# بررسی لاگ‌های خطا
tail -f /var/log/cockroach/cockroach.log | grep ERROR

# بررسی لاگ‌های اتصال
tail -f /var/log/cockroach/cockroach.log | grep "connection"
```

#### بررسی لاگ‌های سیستم
```bash
# بررسی لاگ‌های سیستم
journalctl -u cockroach -f

# بررسی لاگ‌های Docker
docker logs university_cockroachdb -f
```

### 3. بررسی عملکرد

#### بررسی آمار دیتابیس
```sql
-- بررسی تعداد اتصالات
SELECT * FROM crdb_internal.cluster_queries;

-- بررسی آمار جداول
SELECT 
    table_name,
    table_rows,
    total_size
FROM crdb_internal.tables 
WHERE database_name = 'university_management';

-- بررسی آمار ایندکس‌ها
SELECT 
    index_name,
    table_name,
    index_size
FROM crdb_internal.indexes 
WHERE database_name = 'university_management';
```

#### بررسی پرس و جوهای کند
```sql
-- نمایش پرس و جوهای در حال اجرا
SELECT 
    query,
    start_time,
    duration,
    client_address
FROM crdb_internal.cluster_queries 
WHERE status = 'running'
ORDER BY duration DESC;
```

## نگهداری هفتگی

### 1. پشتیبان‌گیری

#### پشتیبان‌گیری کامل
```bash
# اجرای اسکریپت پشتیبان‌گیری
./scripts/backup_database.sh full

# پشتیبان‌گیری دستی
cockroach dump --insecure --host=localhost:26257 --database=university_management > backup_$(date +%Y%m%d_%H%M%S).sql
```

#### پشتیبان‌گیری ساختاری
```bash
# پشتیبان‌گیری فقط ساختار
cockroach dump --insecure --host=localhost:26257 --database=university_management --schema-only > schema_backup_$(date +%Y%m%d_%H%M%S).sql
```

#### پشتیبان‌گیری داده‌ای
```bash
# پشتیبان‌گیری فقط داده‌ها
cockroach dump --insecure --host=localhost:26257 --database=university_management --data-only > data_backup_$(date +%Y%m%d_%H%M%S).sql
```

### 2. بهینه‌سازی

#### بررسی ایندکس‌ها
```sql
-- بررسی ایندکس‌های استفاده نشده
SELECT 
    index_name,
    table_name,
    index_usage
FROM crdb_internal.index_usage_stats 
WHERE database_name = 'university_management'
ORDER BY index_usage ASC;

-- بررسی ایندکس‌های تکراری
SELECT 
    table_name,
    index_name,
    index_definition
FROM crdb_internal.indexes 
WHERE database_name = 'university_management'
GROUP BY table_name, index_definition
HAVING COUNT(*) > 1;
```

#### بهینه‌سازی جداول
```sql
-- بهینه‌سازی جداول
ANALYZE students;
ANALYZE professors;
ANALYZE courses;
ANALYZE enrollments;
ANALYZE grades;
```

### 3. پاکسازی

#### پاکسازی لاگ‌های قدیمی
```bash
# پاکسازی لاگ‌های قدیمی
find /var/log/cockroach -name "*.log" -mtime +30 -delete

# پاکسازی پشتیبان‌های قدیمی
find ./backups -name "*.sql" -mtime +30 -delete
```

#### پاکسازی داده‌های قدیمی
```sql
-- پاکسازی اعلان‌های قدیمی
DELETE FROM notifications 
WHERE created_at < CURRENT_DATE - INTERVAL '90 days';

-- پاکسازی لاگ‌های قدیمی
DELETE FROM audit_log 
WHERE changed_at < CURRENT_DATE - INTERVAL '365 days';
```

## نگهداری ماهانه

### 1. بررسی امنیت

#### بررسی کاربران
```sql
-- نمایش کاربران
SELECT * FROM crdb_internal.users;

-- بررسی دسترسی‌ها
SELECT * FROM crdb_internal.privileges;
```

#### بررسی لاگ‌های امنیتی
```sql
-- بررسی لاگ‌های ورود
SELECT 
    user_name,
    login_time,
    client_address
FROM crdb_internal.session_variables 
WHERE user_name IS NOT NULL;
```

### 2. بررسی عملکرد

#### بررسی آمار عملکرد
```sql
-- بررسی آمار پرس و جوها
SELECT 
    query,
    count,
    avg_duration,
    max_duration
FROM crdb_internal.statement_statistics 
WHERE database_name = 'university_management'
ORDER BY count DESC;
```

#### بررسی استفاده از حافظه
```sql
-- بررسی استفاده از حافظه
SELECT 
    table_name,
    total_size,
    index_size,
    data_size
FROM crdb_internal.tables 
WHERE database_name = 'university_management'
ORDER BY total_size DESC;
```

### 3. به‌روزرسانی

#### بررسی نسخه‌ها
```bash
# بررسی نسخه CockroachDB
cockroach version

# بررسی نسخه Docker
docker version
```

#### به‌روزرسانی سیستم
```bash
# به‌روزرسانی سیستم
sudo apt update && sudo apt upgrade -y

# به‌روزرسانی Docker
sudo apt install docker-ce docker-ce-cli containerd.io
```

## نگهداری فصلی

### 1. بررسی کامل سیستم

#### بررسی یکپارچگی داده‌ها
```sql
-- بررسی محدودیت‌های خارجی
SELECT 
    table_name,
    constraint_name,
    constraint_type
FROM information_schema.table_constraints 
WHERE constraint_type = 'FOREIGN KEY';

-- بررسی ایندکس‌ها
SELECT 
    table_name,
    index_name,
    index_type
FROM information_schema.statistics 
WHERE table_schema = 'public';
```

#### بررسی عملکرد کلی
```sql
-- بررسی آمار کلی
SELECT 
    'Total Students' AS metric,
    COUNT(*) AS count
FROM students
UNION ALL
SELECT 
    'Total Professors' AS metric,
    COUNT(*) AS count
FROM professors
UNION ALL
SELECT 
    'Total Courses' AS metric,
    COUNT(*) AS count
FROM courses
UNION ALL
SELECT 
    'Total Enrollments' AS metric,
    COUNT(*) AS count
FROM enrollments;
```

### 2. بهینه‌سازی پیشرفته

#### بازسازی ایندکس‌ها
```sql
-- بازسازی ایندکس‌ها
REINDEX TABLE students;
REINDEX TABLE professors;
REINDEX TABLE courses;
REINDEX TABLE enrollments;
REINDEX TABLE grades;
```

#### بهینه‌سازی جداول
```sql
-- بهینه‌سازی جداول
VACUUM students;
VACUUM professors;
VACUUM courses;
VACUUM enrollments;
VACUUM grades;
```

### 3. پشتیبان‌گیری کامل

#### پشتیبان‌گیری کامل سیستم
```bash
# پشتیبان‌گیری کامل
./scripts/backup_database.sh full

# پشتیبان‌گیری ساختاری
./scripts/backup_database.sh schema

# پشتیبان‌گیری داده‌ای
./scripts/backup_database.sh data
```

#### تست بازیابی
```bash
# تست بازیابی از پشتیبان
cockroach sql --insecure --host=localhost:26257 --database=test_restore < backup_file.sql
```

## عیب‌یابی

### 1. مشکلات رایج

#### مشکل اتصال
```bash
# بررسی وضعیت سرویس
systemctl status cockroach

# بررسی پورت‌ها
netstat -tlnp | grep 26257

# بررسی فایروال
ufw status
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

-- بررسی استفاده از حافظه
SELECT 
    table_name,
    total_size
FROM crdb_internal.tables 
WHERE database_name = 'university_management'
ORDER BY total_size DESC;
```

### 2. راه‌حل‌ها

#### راه‌حل مشکل اتصال
```bash
# راه‌اندازی مجدد سرویس
systemctl restart cockroach

# بررسی لاگ‌ها
tail -f /var/log/cockroach/cockroach.log
```

#### راه‌حل مشکل عملکرد
```sql
-- بهینه‌سازی پرس و جوها
EXPLAIN SELECT * FROM students WHERE student_number = 'STU100';

-- بررسی ایندکس‌ها
SHOW INDEXES FROM students;
```

## مانیتورینگ

### 1. مانیتورینگ سیستم

#### مانیتورینگ منابع
```bash
# مانیتورینگ CPU
htop

# مانیتورینگ حافظه
free -h

# مانیتورینگ دیسک
df -h
```

#### مانیتورینگ دیتابیس
```sql
-- مانیتورینگ اتصالات
SELECT COUNT(*) FROM crdb_internal.cluster_queries;

-- مانیتورینگ پرس و جوها
SELECT 
    query,
    duration,
    start_time
FROM crdb_internal.cluster_queries 
WHERE status = 'running';
```

### 2. هشدارها

#### تنظیم هشدارها
```bash
# هشدار استفاده از حافظه
echo "Memory usage: $(free | grep Mem | awk '{print $3/$2 * 100.0}')%"

# هشدار استفاده از دیسک
echo "Disk usage: $(df / | tail -1 | awk '{print $5}')"
```

## امنیت

### 1. بررسی امنیت

#### بررسی کاربران
```sql
-- نمایش کاربران
SELECT * FROM crdb_internal.users;

-- بررسی دسترسی‌ها
SELECT * FROM crdb_internal.privileges;
```

#### بررسی لاگ‌های امنیتی
```sql
-- بررسی لاگ‌های ورود
SELECT 
    user_name,
    login_time,
    client_address
FROM crdb_internal.session_variables 
WHERE user_name IS NOT NULL;
```

### 2. به‌روزرسانی امنیتی

#### به‌روزرسانی سیستم
```bash
# به‌روزرسانی سیستم
sudo apt update && sudo apt upgrade -y

# به‌روزرسانی Docker
sudo apt install docker-ce docker-ce-cli containerd.io
```

## پشتیبان‌گیری و بازیابی

### 1. پشتیبان‌گیری

#### پشتیبان‌گیری خودکار
```bash
# تنظیم cron job برای پشتیبان‌گیری روزانه
echo "0 2 * * * /path/to/backup_database.sh full" | crontab -
```

#### پشتیبان‌گیری دستی
```bash
# پشتیبان‌گیری کامل
./scripts/backup_database.sh full

# پشتیبان‌گیری ساختاری
./scripts/backup_database.sh schema

# پشتیبان‌گیری داده‌ای
./scripts/backup_database.sh data
```

### 2. بازیابی

#### بازیابی کامل
```bash
# بازیابی از پشتیبان
cockroach sql --insecure --host=localhost:26257 --database=university_management < backup_file.sql
```

#### بازیابی جزئی
```sql
-- بازیابی جدول خاص
INSERT INTO students SELECT * FROM students_backup;
```

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
