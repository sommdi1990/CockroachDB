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
- Docker Compose

### راه‌اندازی با Docker

1. **کلون کردن پروژه**:
   ```bash
   git clone <repository-url>
   cd CockroachDB
   ```

2. **اجرای پروژه با Docker Compose**:
   ```bash
   docker-compose -f docker/docker-compose.yml up -d
   ```

3. **دسترسی به سرویس‌ها**:
   - **CockroachDB Admin UI**: http://localhost:6565
   - **Database Connection**: localhost:26257
   - **Adminer (Database Admin)**: http://localhost:8083
   - **Prometheus Monitoring**: http://localhost:9090
   - **Grafana Dashboard**: http://localhost:3001

### ورود به Adminer (Database Admin)

**آدرس**: http://localhost:8083

Adminer یک ابزار مدیریت دیتابیس است که برای اتصال به CockroachDB استفاده می‌شود.

#### اطلاعات اتصال:
| فیلد | مقدار |
|------|-------|
| **System** | `PostgreSQL` |
| **Server** | `localhost:26257` |
| **Username** | `root` |
| **Password** | (خالی) |
| **Database** | `university_management` |

#### مراحل ورود:
1. به آدرس http://localhost:8083 بروید
2. فرم ورود را با اطلاعات بالا پر کنید
3. روی "Login" کلیک کنید

#### پس از ورود:
- مشاهده جداول دیتابیس
- اجرای کوئری‌های SQL
- مدیریت داده‌ها
- بررسی ساختار دیتابیس

### مانیتورینگ و لاگ‌ها

#### Prometheus
- **آدرس**: http://localhost:9090
- **کاربرد**: جمع‌آوری و ذخیره metrics از CockroachDB
- **دسترسی**: بدون احراز هویت

### ورود به Prometheus

**آدرس**: http://localhost:9090

Prometheus برای جمع‌آوری و ذخیره metrics از CockroachDB استفاده می‌شود.

#### اطلاعات ورود:
| فیلد | مقدار |
|------|-------|
| **دسترسی** | بدون احراز هویت |
| **نکته** | مستقیماً قابل دسترسی است |

#### مراحل استفاده:
1. به آدرس http://localhost:9090 بروید
2. مستقیماً وارد پنل Prometheus می‌شوید
3. از منوهای مختلف استفاده کنید

#### پس از ورود:
- مشاهده metrics در بخش "Graph"
- بررسی وضعیت targets در "Status" > "Targets"
- اجرای کوئری‌های PromQL
- مشاهده alerts در "Alerts"

#### Grafana
- **آدرس**: http://localhost:3001
- **نام کاربری**: admin
- **رمز عبور**: admin123
- **کاربرد**: نمایش داشبوردهای مانیتورینگ و تجسم داده‌ها

### ورود به Grafana

**آدرس**: http://localhost:3001

Grafana برای نمایش داشبوردهای مانیتورینگ و تجسم داده‌ها استفاده می‌شود.

#### اطلاعات ورود:
| فیلد | مقدار |
|------|-------|
| **نام کاربری** | `admin` |
| **رمز عبور** | `admin123` |

#### مراحل ورود:
1. به آدرس http://localhost:3001 بروید
2. نام کاربری `admin` و رمز عبور `admin123` را وارد کنید
3. روی "Login" کلیک کنید

#### پس از ورود:
- مشاهده داشبوردهای مانیتورینگ
- ایجاد داشبوردهای جدید
- تنظیم alerts و notifications
- Export کردن گزارش‌ها

#### CockroachDB Admin UI
- **آدرس**: http://localhost:6565
- **کاربرد**: مدیریت دیتابیس، مشاهده کوئری‌ها، مانیتورینگ عملکرد

## مستندات

### راهنماهای اصلی
- **نصب و راه‌اندازی**: این فایل (README.md)
- **استفاده از سیستم**: `docs/usage_guide.md`
- **نگهداری**: `docs/maintenance_guide.md`

### راهنماهای تخصصی
- **مانیتورینگ**: `docs/monitoring_guide.md`
- **Prometheus Monitoring**: `docs/prometheus_guide.md`
- **Grafana Dashboard**: `docs/grafana_guide.md`
- **Adminer (Database Admin)**: `docs/adminer_guide.md`
- **راهنمای دیتابیس**: `docs/database_guide.md`
- **مثال‌های عملی**: `docs/practical_examples.md`

## پشتیبانی

در صورت بروز مشکل، لطفاً issue جدیدی در repository ایجاد کنید.
