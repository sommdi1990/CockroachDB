# راهنمای استفاده از Prometheus

## مقدمه

Prometheus یک سیستم مانیتورینگ و alerting است که برای جمع‌آوری و ذخیره metrics از CockroachDB استفاده می‌شود.

## دسترسی

**آدرس**: http://localhost:9090

## اطلاعات ورود

| فیلد | مقدار |
|------|-------|
| **دسترسی** | بدون احراز هویت |
| **نکته** | مستقیماً قابل دسترسی است |

## مراحل استفاده

1. **به آدرس بروید**: http://localhost:9090
2. **مستقیماً وارد شوید**: هیچ نام کاربری و رمز عبوری نیاز نیست
3. **از منوهای مختلف استفاده کنید**

## ویژگی‌های Prometheus

### 1. Graph (اجرای کوئری)
- **Query**: اجرای کوئری‌های PromQL
- **Execute**: اجرای کوئری و نمایش نتایج
- **Graph**: نمایش نتایج به صورت نمودار
- **Console**: نمایش نتایج به صورت جدول

### 2. Status
- **Targets**: وضعیت targets (CockroachDB)
- **Configuration**: تنظیمات Prometheus
- **Rules**: قوانین alerting
- **Service Discovery**: کشف سرویس‌ها

### 3. Alerts
- **Active Alerts**: هشدارهای فعال
- **Inactive Alerts**: هشدارهای غیرفعال
- **Alert Rules**: قوانین هشدار

## استفاده عملی

### مشاهده وضعیت CockroachDB
1. روی "Status" > "Targets" کلیک کنید
2. وضعیت CockroachDB را بررسی کنید
3. اگر "UP" باشد، اتصال برقرار است

### اجرای کوئری PromQL
1. روی "Graph" کلیک کنید
2. کوئری مورد نظر را در فیلد Query وارد کنید
3. روی "Execute" کلیک کنید
4. نتایج را مشاهده کنید

### مشاهده Configuration
1. روی "Status" > "Configuration" کلیک کنید
2. تنظیمات Prometheus را مشاهده کنید
3. targets و scrape intervals را بررسی کنید

## کوئری‌های مفید

### Database Metrics
```promql
# وضعیت CockroachDB
up{job="cockroachdb"}

# تعداد اتصالات فعال
sql_conns{job="cockroachdb"}

# تعداد کوئری‌های اجرا شده
sql_query_count{job="cockroachdb"}

# زمان اجرای کوئری‌ها (میلی‌ثانیه)
sql_query_duration{job="cockroachdb"}

# تعداد تراکنش‌ها
sql_txn_count{job="cockroachdb"}
```

### System Metrics
```promql
# استفاده از CPU
sys_cpu_user_ns{job="cockroachdb"}

# استفاده از حافظه (بایت)
sys_mem_actual{job="cockroachdb"}

# خواندن از دیسک (بایت)
sys_disk_read_bytes{job="cockroachdb"}

# نوشتن روی دیسک (بایت)
sys_disk_write_bytes{job="cockroachdb"}

# تعداد goroutines
sys_goroutines{job="cockroachdb"}
```

### Performance Metrics
```promql
# تعداد اتصالات جدید در ثانیه
rate(sql_conns{job="cockroachdb"}[5m])

# تعداد کوئری‌های اجرا شده در ثانیه
rate(sql_query_count{job="cockroachdb"}[5m])

# میانگین زمان اجرای کوئری‌ها
avg(sql_query_duration{job="cockroachdb"})

# تعداد تراکنش‌ها در ثانیه
rate(sql_txn_count{job="cockroachdb"}[5m])
```

## تنظیم Alert Rules

### ایجاد Alert Rule
1. فایل `prometheus.yml` را ویرایش کنید
2. بخش `rule_files` را اضافه کنید
3. فایل rule را ایجاد کنید

### مثال Alert Rule
```yaml
groups:
- name: cockroachdb
  rules:
  - alert: CockroachDBDown
    expr: up{job="cockroachdb"} == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "CockroachDB is down"
      description: "CockroachDB has been down for more than 1 minute"

  - alert: HighCPUUsage
    expr: sys_cpu_user_ns{job="cockroachdb"} > 0.8
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage"
      description: "CPU usage is above 80%"

  - alert: HighMemoryUsage
    expr: sys_mem_actual{job="cockroachdb"} > 1000000000
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High memory usage"
      description: "Memory usage is above 1GB"
```

## عیب‌یابی

### مشکل در جمع‌آوری Metrics
1. **بررسی Targets**:
   - Status > Targets
   - وضعیت CockroachDB را بررسی کنید

2. **بررسی Configuration**:
   - Status > Configuration
   - تنظیمات scrape را بررسی کنید

3. **بررسی Logs**:
   ```bash
   docker logs university_prometheus
   ```

### مشکل در اجرای کوئری
1. **بررسی Syntax**:
   - از PromQL syntax استفاده کنید
   - نام metrics را درست بنویسید

2. **بررسی Time Range**:
   - Last 5 minutes
   - Last 1 hour
   - Last 24 hours

3. **بررسی Data**:
   - مطمئن شوید metrics جمع‌آوری می‌شود
   - از کوئری‌های ساده شروع کنید

### مشکل در Alert
1. **بررسی Alert Rules**:
   - Status > Rules
   - قوانین alert را بررسی کنید

2. **بررسی Alertmanager**:
   - اگر Alertmanager نصب شده، تنظیمات را بررسی کنید

## نکات مهم

1. **امنیت**: Prometheus در حالت insecure اجرا می‌شود
2. **Performance**: برای کوئری‌های سنگین، time range را محدود کنید
3. **Storage**: داده‌های تاریخی در volume ذخیره می‌شود
4. **Backup**: تنظیمات و rules را backup کنید

## منابع بیشتر

- [Prometheus Documentation](https://prometheus.io/docs/)
- [PromQL Query Language](https://prometheus.io/docs/prometheus/latest/querying/)
- [CockroachDB Metrics](https://www.cockroachlabs.com/docs/stable/monitoring-and-alerting.html)
- [Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)
