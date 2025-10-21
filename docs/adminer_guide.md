# راهنمای استفاده از Adminer

## مقدمه

Adminer یک ابزار مدیریت دیتابیس است که برای اتصال مستقیم به CockroachDB استفاده می‌شود. این ابزار رابط کاربری ساده‌ای برای مدیریت دیتابیس فراهم می‌کند.

## دسترسی

**آدرس**: http://localhost:8083

## اطلاعات اتصال

| فیلد | مقدار | توضیحات |
|------|-------|----------|
| **System** | `PostgreSQL` | CockroachDB با PostgreSQL compatible است |
| **Server** | `localhost:26257` | آدرس و پورت CockroachDB |
| **Username** | `root` | نام کاربری پیش‌فرض CockroachDB |
| **Password** | (خالی) | CockroachDB در حالت insecure اجرا می‌شود |
| **Database** | `university_management` | نام دیتابیس پروژه |

## مراحل ورود

1. **به آدرس بروید**: http://localhost:8083
2. **فرم ورود را پر کنید**:
   - System: **PostgreSQL**
   - Server: **localhost:26257**
   - Username: **root**
   - Password: **(خالی)**
   - Database: **university_management**
3. **روی "Login" کلیک کنید**

## ویژگی‌های Adminer

### 1. مشاهده ساختار دیتابیس
- **Tables**: مشاهده تمام جداول
- **Views**: مشاهده view ها
- **Functions**: مشاهده function ها
- **Procedures**: مشاهده procedure ها

### 2. اجرای کوئری‌های SQL
- **SQL Command**: اجرای کوئری‌های SQL مستقیم
- **Query History**: تاریخچه کوئری‌های اجرا شده
- **Explain**: تحلیل performance کوئری‌ها

### 3. مدیریت داده‌ها
- **Browse**: مشاهده داده‌های جداول
- **Edit**: ویرایش رکوردها
- **Insert**: اضافه کردن رکورد جدید
- **Delete**: حذف رکوردها

### 4. Import/Export
- **Export**: خروجی گرفتن از داده‌ها
- **Import**: وارد کردن داده‌ها
- **Backup**: پشتیبان‌گیری از دیتابیس

## استفاده عملی

### مشاهده جداول
1. پس از ورود، روی نام دیتابیس کلیک کنید
2. در لیست جداول، روی نام جدول مورد نظر کلیک کنید
3. داده‌های جدول نمایش داده می‌شود

### اجرای کوئری SQL
1. روی "SQL command" کلیک کنید
2. کوئری مورد نظر را تایپ کنید
3. روی "Execute" کلیک کنید

### ویرایش داده‌ها
1. جدول مورد نظر را انتخاب کنید
2. روی رکورد مورد نظر کلیک کنید
3. تغییرات را اعمال کنید
4. روی "Save" کلیک کنید

## کوئری‌های مفید

### مشاهده جداول
```sql
SHOW TABLES;
```

### مشاهده ساختار جدول
```sql
DESCRIBE table_name;
```

### مشاهده داده‌های جدول
```sql
SELECT * FROM table_name LIMIT 10;
```

### شمارش رکوردها
```sql
SELECT COUNT(*) FROM table_name;
```

## عیب‌یابی

### مشکل اتصال
اگر نمی‌توانید به Adminer متصل شوید:

1. **بررسی وضعیت کانتینرها**:
   ```bash
   docker ps
   ```

2. **بررسی لاگ‌های CockroachDB**:
   ```bash
   docker logs university_cockroachdb
   ```

3. **تست اتصال مستقیم**:
   ```bash
   docker exec university_cockroachdb cockroach sql --insecure --host=localhost:26257
   ```

### مشکل در اجرای کوئری
- مطمئن شوید از syntax صحیح PostgreSQL استفاده می‌کنید
- برای کوئری‌های پیچیده، ابتدا در CockroachDB Admin UI تست کنید

## نکات مهم

1. **امنیت**: Adminer در حالت insecure اجرا می‌شود - فقط برای محیط development استفاده کنید
2. **Backup**: قبل از تغییرات مهم، حتماً backup بگیرید
3. **Performance**: برای کوئری‌های سنگین، از CockroachDB Admin UI استفاده کنید
4. **Monitoring**: از Prometheus و Grafana برای مانیتورینگ استفاده کنید

## منابع بیشتر

- [Adminer Documentation](https://www.adminer.org/)
- [CockroachDB SQL Reference](https://www.cockroachlabs.com/docs/stable/sql-statements.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
