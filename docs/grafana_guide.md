# راهنمای استفاده از Grafana

## مقدمه

Grafana یک ابزار تجسم و مانیتورینگ است که برای نمایش داشبوردهای مانیتورینگ CockroachDB استفاده می‌شود.

## دسترسی

**آدرس**: http://localhost:3001

## اطلاعات ورود

| فیلد | مقدار |
|------|-------|
| **نام کاربری** | `admin` |
| **رمز عبور** | `admin123` |

## مراحل ورود

1. **به آدرس بروید**: http://localhost:3001
2. **اطلاعات ورود را وارد کنید**:
   - Username: **admin**
   - Password: **admin123**
3. **روی "Login" کلیک کنید**

## ویژگی‌های Grafana

### 1. داشبوردها (Dashboards)
- **مشاهده داشبوردهای آماده**: داشبورد CockroachDB
- **ایجاد داشبورد جدید**: برای نیازهای خاص
- **Import داشبورد**: از Grafana.com
- **Export داشبورد**: برای اشتراک‌گذاری

### 2. Data Sources
- **Prometheus**: اتصال به Prometheus برای دریافت metrics
- **Configuration**: تنظیم اتصال به منابع داده
- **Testing**: تست اتصال به منابع

### 3. Panels و Visualizations
- **Graph**: نمودارهای خطی
- **Stat**: نمایش مقادیر عددی
- **Table**: جداول داده
- **Gauge**: نمایش مقادیر در محدوده
- **Heatmap**: نقشه‌های حرارتی

### 4. Alerting
- **Alert Rules**: تعریف قوانین هشدار
- **Notification Channels**: کانال‌های اطلاع‌رسانی
- **Alert History**: تاریخچه هشدارها

## استفاده عملی

### مشاهده داشبورد CockroachDB
1. پس از ورود، روی "Dashboards" کلیک کنید
2. داشبورد "CockroachDB Monitoring" را انتخاب کنید
3. metrics مختلف CockroachDB را مشاهده کنید

### ایجاد داشبورد جدید
1. روی "+" کلیک کنید
2. "Dashboard" را انتخاب کنید
3. "Add Panel" کلیک کنید
4. نوع visualization را انتخاب کنید
5. Query را تنظیم کنید

### تنظیم Data Source
1. روی "Configuration" > "Data Sources" کلیک کنید
2. "Prometheus" را انتخاب کنید
3. URL: `http://prometheus:9090`
4. روی "Save & Test" کلیک کنید

## کوئری‌های مفید

### Database Metrics
```promql
# تعداد اتصالات فعال
sql_conns{job="cockroachdb"}

# تعداد کوئری‌های اجرا شده
sql_query_count{job="cockroachdb"}

# زمان اجرای کوئری‌ها
sql_query_duration{job="cockroachdb"}

# تعداد تراکنش‌ها
sql_txn_count{job="cockroachdb"}
```

### System Metrics
```promql
# استفاده از CPU
sys_cpu_user_ns{job="cockroachdb"}

# استفاده از حافظه
sys_mem_actual{job="cockroachdb"}

# خواندن از دیسک
sys_disk_read_bytes{job="cockroachdb"}

# نوشتن روی دیسک
sys_disk_write_bytes{job="cockroachdb"}
```

## تنظیم Alert

### ایجاد Alert Rule
1. روی Panel مورد نظر کلیک کنید
2. "Alert" tab را انتخاب کنید
3. شرایط alert را تعریف کنید
4. کانال اطلاع‌رسانی را تنظیم کنید

### مثال Alert Rule
```yaml
# High CPU Usage Alert
- alert: HighCPUUsage
  expr: sys_cpu_user_ns > 0.8
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "High CPU usage detected"
    description: "CPU usage is above 80%"
```

## عیب‌یابی

### مشکل اتصال به Prometheus
1. **بررسی وضعیت Prometheus**:
   ```bash
   docker logs university_prometheus
   ```

2. **تست اتصال**:
   ```bash
   curl http://localhost:9090/api/v1/query?query=up
   ```

3. **بررسی Data Source در Grafana**:
   - Configuration > Data Sources
   - URL: `http://prometheus:9090`
   - Test connection

### مشکل در نمایش داده‌ها
1. **بررسی Query**:
   - از Prometheus query استفاده کنید
   - syntax را بررسی کنید

2. **بررسی Time Range**:
   - Last 5 minutes
   - Last 1 hour
   - Last 24 hours

### مشکل در Alert
1. **بررسی Alert Rules**:
   - شرایط alert را بررسی کنید
   - threshold ها را تنظیم کنید

2. **بررسی Notification Channels**:
   - کانال‌های اطلاع‌رسانی را تست کنید

## نکات مهم

1. **امنیت**: رمز عبور پیش‌فرض را تغییر دهید
2. **Backup**: داشبوردها را export کنید
3. **Performance**: برای کوئری‌های سنگین، time range را محدود کنید
4. **Monitoring**: از خود Grafana نیز مانیتورینگ کنید

## منابع بیشتر

- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/)
- [CockroachDB Metrics](https://www.cockroachlabs.com/docs/stable/monitoring-and-alerting.html)
