# راهنمای مانیتورینگ سیستم مدیریت دانشگاه

## مقدمه

این راهنما نحوه استفاده از ابزارهای مانیتورینگ نصب شده برای سیستم مدیریت دانشگاه را توضیح می‌دهد.

## ابزارهای مانیتورینگ

### 1. Prometheus
**آدرس**: http://localhost:9090

Prometheus برای جمع‌آوری و ذخیره metrics از CockroachDB استفاده می‌شود.

#### ویژگی‌ها:
- جمع‌آوری خودکار metrics از CockroachDB
- ذخیره داده‌های تاریخی
- Query language برای تحلیل داده‌ها
- Alerting rules

#### اطلاعات ورود:
| فیلد | مقدار |
|------|-------|
| **دسترسی** | بدون احراز هویت |
| **نکته** | مستقیماً قابل دسترسی است |

#### مراحل استفاده:
1. به آدرس http://localhost:9090 بروید
2. مستقیماً وارد پنل Prometheus می‌شوید
3. از منوهای مختلف استفاده کنید

#### استفاده:
1. **مشاهده Targets**: در بخش "Status" > "Targets" وضعیت CockroachDB را بررسی کنید
2. **اجرای کوئری**: در بخش "Graph" کوئری‌های PromQL اجرا کنید
3. **مشاهده Alerts**: در بخش "Alerts" هشدارها را بررسی کنید
4. **Configuration**: در بخش "Status" > "Configuration" تنظیمات را مشاهده کنید

### 2. Grafana
**آدرس**: http://localhost:3001
**نام کاربری**: admin
**رمز عبور**: admin123

Grafana برای نمایش داشبوردهای مانیتورینگ و تجسم داده‌ها استفاده می‌شود.

#### ویژگی‌ها:
- داشبوردهای آماده برای CockroachDB
- نمودارهای تعاملی
- Alerting و notifications
- Export کردن گزارش‌ها

#### اطلاعات ورود:
| فیلد | مقدار |
|------|-------|
| **نام کاربری** | `admin` |
| **رمز عبور** | `admin123` |

#### مراحل ورود:
1. به آدرس http://localhost:3001 بروید
2. نام کاربری `admin` و رمز عبور `admin123` را وارد کنید
3. روی "Login" کلیک کنید

#### استفاده:
1. پس از ورود، در بخش "Dashboards" داشبورد CockroachDB را مشاهده کنید
2. می‌توانید داشبوردهای جدید ایجاد کنید
3. در بخش "Data Sources" اتصال به Prometheus را بررسی کنید

### 3. CockroachDB Admin UI
**آدرس**: http://localhost:6565

پنل مدیریتی CockroachDB برای مدیریت دیتابیس و مانیتورینگ عملکرد.

#### ویژگی‌ها:
- مشاهده وضعیت cluster
- اجرای کوئری‌های SQL
- مانیتورینگ performance
- مدیریت کاربران و permissions

### 4. Adminer (Database Admin)
**آدرس**: http://localhost:8083

ابزار مدیریت دیتابیس برای اتصال مستقیم به CockroachDB.

#### اطلاعات اتصال:
| فیلد | مقدار |
|------|-------|
| **System** | `PostgreSQL` |
| **Server** | `localhost:26257` |
| **Username** | `root` |
| **Password** | (خالی) |
| **Database** | `university_management` |

#### ویژگی‌ها:
- رابط کاربری ساده برای مدیریت دیتابیس
- اجرای کوئری‌های SQL
- مشاهده و ویرایش جداول
- Import/Export داده‌ها
- مدیریت ساختار دیتابیس

#### مراحل ورود:
1. به آدرس http://localhost:8083 بروید
2. فرم ورود را با اطلاعات بالا پر کنید
3. روی "Login" کلیک کنید

## Metrics مهم

### Database Metrics
- `sql_conns`: تعداد اتصالات فعال
- `sql_query_count`: تعداد کوئری‌های اجرا شده
- `sql_query_duration`: زمان اجرای کوئری‌ها
- `sql_txn_count`: تعداد تراکنش‌ها

### System Metrics
- `sys_cpu_user_ns`: استفاده از CPU
- `sys_mem_actual`: استفاده از حافظه
- `sys_disk_read_bytes`: خواندن از دیسک
- `sys_disk_write_bytes`: نوشتن روی دیسک

## Alerting

### تنظیم Alert Rules
در Prometheus می‌توانید alert rules تعریف کنید:

```yaml
groups:
- name: cockroachdb
  rules:
  - alert: HighCPUUsage
    expr: sys_cpu_user_ns > 0.8
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage detected"
```

### Grafana Alerts
در Grafana می‌توانید alerts تنظیم کنید:
1. به داشبورد مورد نظر بروید
2. روی panel کلیک کنید
3. "Alert" tab را انتخاب کنید
4. شرایط alert را تعریف کنید

## Troubleshooting

### مشکلات رایج

#### Prometheus metrics جمع‌آوری نمی‌شود
1. بررسی کنید CockroachDB در حال اجرا باشد
2. در Prometheus > Status > Targets وضعیت را بررسی کنید
3. پورت 6565 در دسترس باشد

#### Grafana به Prometheus متصل نمی‌شود
1. بررسی کنید Prometheus در حال اجرا باشد
2. در Grafana > Configuration > Data Sources تنظیمات را بررسی کنید

#### CockroachDB Admin UI در دسترس نیست
1. بررسی کنید CockroachDB container در حال اجرا باشد
2. پورت 6565 در دسترس باشد
3. لاگ‌های container را بررسی کنید: `docker logs university_cockroachdb`

## دستورات مفید

### بررسی وضعیت کانتینرها
```bash
docker ps
```

### مشاهده لاگ‌ها
```bash
# CockroachDB
docker logs university_cockroachdb

# Prometheus
docker logs university_prometheus

# Grafana
docker logs university_grafana
```

### Restart سرویس‌ها
```bash
# Restart همه سرویس‌ها
docker-compose -f docker/docker-compose.yml restart

# Restart سرویس خاص
docker-compose -f docker/docker-compose.yml restart prometheus
```

## منابع بیشتر

- [CockroachDB Monitoring](https://www.cockroachlabs.com/docs/stable/monitoring-and-alerting.html)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
