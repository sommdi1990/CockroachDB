# سیستم مدیریت دانشگاه - University Management System

## توضیحات پروژه

این پروژه یک سیستم مدیریت دانشگاه کامل است که بر روی CockroachDB پیاده‌سازی شده است. این سیستم شامل تمام جداول و روابط لازم برای مدیریت دانشجویان، اساتید، دروس، نمرات و سایر جنبه‌های دانشگاهی می‌باشد.

## ویژگی‌های سیستم

- **مدیریت دانشجویان**: ثبت‌نام، اطلاعات شخصی، وضعیت تحصیلی
- **مدیریت اساتید**: اطلاعات اساتید، تخصص‌ها، ساعات کاری
- **مدیریت دروس**: کاتالوگ دروس، پیش‌نیازها، واحدها
- **مدیریت نمرات**: ثبت نمرات، محاسبه معدل، گزارش‌گیری
- **مدیریت کلاس‌ها**: برنامه‌ریزی کلاس‌ها، سالن‌ها، زمان‌بندی
- **مدیریت دانشکده‌ها**: سازماندهی دانشکده‌ها و گروه‌های آموزشی

## ساختار پروژه

```
├── database/
│   ├── schema/
│   │   ├── 01_create_tables.sql
│   │   ├── 02_create_indexes.sql
│   │   └── 03_create_views.sql
│   ├── data/
│   │   ├── 01_insert_departments.sql
│   │   ├── 02_insert_courses.sql
│   │   └── 03_sample_data.sql
│   └── procedures/
│       ├── 01_student_procedures.sql
│       └── 02_grade_procedures.sql
├── docker/
│   ├── docker-compose.yml
│   └── Dockerfile
├── docs/
│   ├── database_guide.md
│   ├── maintenance_guide.md
│   └── usage_guide.md
└── scripts/
    ├── init_database.sh
    └── backup_database.sh
```

## نصب و راه‌اندازی

### پیش‌نیازها

- Docker
- CockroachDB (در حال اجرا روی پورت 26257)

### راه‌اندازی

1. **کلون کردن پروژه**:
   ```bash
   git clone <repository-url>
   cd CockroachDB
   ```

2. **راه‌اندازی دیتابیس**:
   ```bash
   chmod +x scripts/init_database.sh
   ./scripts/init_database.sh
   ```

3. **تست اتصال**:
   ```bash
   cockroach sql --insecure --host=localhost:26257
   ```

## استفاده از سیستم

برای راهنمای کامل استفاده از سیستم، فایل `docs/usage_guide.md` را مطالعه کنید.

## نگهداری

برای راهنمای نگهداری سیستم، فایل `docs/maintenance_guide.md` را مطالعه کنید.

## پشتیبانی

در صورت بروز مشکل، لطفاً issue جدیدی در repository ایجاد کنید.
