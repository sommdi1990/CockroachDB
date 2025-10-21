# راهنمای استفاده از Wiki برای پروژه سیستم مدیریت دانشگاه

## مقدمه

این راهنما شامل تمام اطلاعات لازم برای استفاده از مستندات پروژه به عنوان Wiki در Git است. تمام فایل‌های مستندات موجود در پروژه به راحتی می‌توانند به عنوان Wiki استفاده شوند.

## ساختار Wiki ایجاد شده

### فایل‌های اصلی Wiki
```
wiki/
├── Home.md                    # صفحه اصلی
├── Index.md                   # فهرست مطالب
├── _Sidebar.md               # منوی کناری
├── _Footer.md                # پاورقی
├── README.md                 # راهنمای Wiki
├── CockroachDB-Tutorial.md   # آموزش CockroachDB
├── Database-Guide.md         # راهنمای دیتابیس
├── Usage-Guide.md            # راهنمای استفاده
├── Maintenance-Guide.md      # راهنمای نگهداری
├── Practical-Examples.md     # مثال‌های عملی
├── Installation-Guide.md      # راهنمای نصب
├── Project-Summary.md         # خلاصه پروژه
├── Complete-Overview.md       # نمای کامل
└── scripts/                  # اسکریپت‌ها
    ├── init_database.sh
    ├── backup_database.sh
    ├── test_database.sh
    └── README.md
```

## نحوه استفاده از Wiki

### 1. فعال‌سازی Wiki در GitHub

#### مراحل:
1. به repository خود در GitHub بروید
2. روی تب "Settings" کلیک کنید
3. در بخش "Features" گزینه "Wikis" را فعال کنید
4. روی "Save" کلیک کنید

#### تصویر راهنما:
```
Repository Settings → Features → Wikis → Enable
```

### 2. آپلود فایل‌های Wiki

#### روش 1: استفاده از رابط وب GitHub
1. به تب "Wiki" در repository بروید
2. روی "Create the first page" کلیک کنید
3. محتوای فایل‌های markdown را کپی کنید
4. صفحه را ذخیره کنید

#### روش 2: استفاده از Git (پیشنهادی)
```bash
# کلون کردن Wiki repository
git clone https://github.com/username/repository.wiki.git

# کپی کردن فایل‌های Wiki
cp -r /path/to/project/wiki/* .

# Commit و Push
git add .
git commit -m "Add wiki documentation"
git push origin master
```

### 3. ساختار پیشنهادی صفحات Wiki

#### صفحه اصلی (Home.md)
```markdown
# سیستم مدیریت دانشگاه

## معرفی
این پروژه یک سیستم مدیریت دانشگاه کامل و حرفه‌ای است که بر روی CockroachDB پیاده‌سازی شده است.

## ویژگی‌های اصلی
- دیتابیس کامل با 14 جدول
- 50+ ایندکس بهینه
- 10 ویو مفید
- مستندات کامل فارسی
- اسکریپت‌های خودکار

## لینک‌های مفید
- [آموزش CockroachDB](CockroachDB-Tutorial)
- [راهنمای استفاده](Usage-Guide)
- [راهنمای نگهداری](Maintenance-Guide)
- [مثال‌های عملی](Practical-Examples)
```

#### منوی کناری (_Sidebar.md)
```markdown
# فهرست مطالب

## صفحه اصلی
- [Home](Home)

## آموزش‌ها
- [آموزش CockroachDB](CockroachDB-Tutorial)
- [مثال‌های عملی](Practical-Examples)

## راهنماها
- [راهنمای دیتابیس](Database-Guide)
- [راهنمای استفاده](Usage-Guide)
- [راهنمای نگهداری](Maintenance-Guide)
- [راهنمای نصب](Installation-Guide)

## خلاصه‌ها
- [خلاصه پروژه](Project-Summary)
- [نمای کامل](Complete-Overview)
```

## تنظیمات پیشنهادی Wiki

### 1. ساختار منو
```
Home
├── Tutorials
│   ├── CockroachDB Tutorial
│   └── Practical Examples
├── Guides
│   ├── Database Guide
│   ├── Usage Guide
│   ├── Maintenance Guide
│   └── Installation Guide
├── Summaries
│   ├── Project Summary
│   └── Complete Overview
└── Scripts
    ├── Database Initialization
    ├── Backup and Restore
    └── Testing
```

### 2. لینک‌های داخلی
```markdown
# لینک به صفحات دیگر
[راهنمای استفاده](Usage-Guide)
[مثال‌های عملی](Practical-Examples)

# لینک به بخش‌های خاص
[مدیریت دانشجویان](Usage-Guide#مدیریت-دانشجویان)
[پرس و جوهای پیشرفته](Usage-Guide#پرس-و-جوهای-پیشرفته)
```

### 3. تصاویر و نمودارها
```markdown
# نمودار ساختار دیتابیس
![Database Structure](images/database-structure.png)

# نمودار روابط جداول
![Table Relationships](images/table-relationships.png)
```

## مزایای استفاده از Wiki

### 1. دسترسی آسان
- **دسترسی از هر جا**: از هر دستگاه و مکان
- **جستجوی سریع**: جستجوی آسان در محتوا
- **لینک‌های داخلی**: پیمایش آسان بین صفحات

### 2. همکاری
- **ویرایش توسط چندین نفر**: امکان همکاری تیمی
- **تاریخچه تغییرات**: پیگیری تغییرات
- **نظرات و بحث**: امکان بحث و تبادل نظر

### 3. سازماندهی
- **ساختار منظم**: سازماندهی منطقی محتوا
- **فهرست مطالب**: دسترسی آسان به موضوعات
- **دسته‌بندی موضوعات**: گروه‌بندی مناسب

### 4. به‌روزرسانی
- **ویرایش آسان**: ویرایش ساده محتوا
- **نسخه‌گیری**: کنترل نسخه‌ها
- **همگام‌سازی با کد**: همگام‌سازی با repository

## نکات مهم

### 1. فرمت‌بندی
- **استفاده از Markdown**: فرمت استاندارد
- **لینک‌های صحیح**: بررسی لینک‌های داخلی
- **تصاویر مناسب**: استفاده از تصاویر با کیفیت

### 2. سازماندهی
- **ساختار منطقی**: ترتیب منطقی صفحات
- **نام‌گذاری مناسب**: نام‌های واضح و قابل فهم
- **فهرست مطالب**: فهرست کامل و به‌روز

### 3. به‌روزرسانی
- **همگام‌سازی با کد**: همگام‌سازی با تغییرات کد
- **بررسی لینک‌ها**: بررسی صحت لینک‌ها
- **تست محتوا**: تست محتوا و مثال‌ها

### 4. همکاری
- **قوانین ویرایش**: تعیین قوانین ویرایش
- **مسئولیت‌ها**: تعیین مسئولیت‌ها
- **فرآیند بررسی**: فرآیند بررسی تغییرات

## دستورات مفید

### 1. تبدیل مستندات به Wiki
```bash
# اجرای اسکریپت تبدیل
./scripts/convert_to_wiki.sh

# بررسی ساختار Wiki
ls -la wiki/
```

### 2. آپلود Wiki به GitHub
```bash
# کلون کردن Wiki repository
git clone https://github.com/username/repository.wiki.git

# کپی کردن فایل‌ها
cp -r wiki/* repository.wiki/

# Commit و Push
cd repository.wiki
git add .
git commit -m "Add wiki documentation"
git push origin master
```

### 3. به‌روزرسانی Wiki
```bash
# به‌روزرسانی فایل‌های Wiki
./scripts/convert_to_wiki.sh

# آپلود تغییرات
cd repository.wiki
git pull origin master
cp -r ../wiki/* .
git add .
git commit -m "Update wiki documentation"
git push origin master
```

## مثال‌های عملی

### 1. ایجاد صفحه جدید
```markdown
# عنوان صفحه جدید

## مقدمه
توضیحات کلی

## محتوا
محتوای اصلی

## لینک‌های مرتبط
- [صفحه مرتبط](Related-Page)
- [بخش خاص](Page#Section)
```

### 2. ویرایش صفحه موجود
```markdown
# ویرایش صفحه موجود

## تغییرات
- اضافه کردن بخش جدید
- به‌روزرسانی اطلاعات
- تصحیح لینک‌ها

## بررسی
- تست لینک‌ها
- بررسی فرمت‌بندی
- تست محتوا
```

### 3. مدیریت تصاویر
```markdown
# استفاده از تصاویر

## تصاویر محلی
![Local Image](images/image.png)

## تصاویر خارجی
![External Image](https://example.com/image.png)

## تصاویر با لینک
[![Image](image.png)](https://example.com)
```

## عیب‌یابی

### 1. مشکلات رایج

#### لینک‌های شکسته
```bash
# بررسی لینک‌های داخلی
grep -r "\[.*\](.*)" wiki/
grep -r "\[.*\](.*)" wiki/ | grep -v "http"
```

#### فرمت‌بندی نادرست
```bash
# بررسی فرمت Markdown
markdownlint wiki/*.md
```

#### تصاویر گمشده
```bash
# بررسی تصاویر
find wiki/ -name "*.png" -o -name "*.jpg" -o -name "*.gif"
```

### 2. راه‌حل‌ها

#### تصحیح لینک‌ها
```markdown
# لینک صحیح
[صفحه مرتبط](Page-Name)

# لینک به بخش خاص
[بخش خاص](Page-Name#Section-Name)
```

#### تصحیح فرمت‌بندی
```markdown
# فرمت صحیح
## عنوان بخش
**متن مهم**
*متن تاکیدی*
```

#### تصحیح تصاویر
```markdown
# تصویر صحیح
![توضیح تصویر](path/to/image.png)
```

## نتیجه‌گیری

استفاده از مستندات پروژه به عنوان Wiki در Git مزایای زیادی دارد:

### مزایا:
- **دسترسی آسان**: از هر جا قابل دسترسی
- **همکاری**: ویرایش توسط چندین نفر
- **سازماندهی**: ساختار منظم و منطقی
- **به‌روزرسانی**: همگام‌سازی با کد

### مراحل:
1. **فعال‌سازی Wiki**: در GitHub repository
2. **آپلود فایل‌ها**: استفاده از اسکریپت تبدیل
3. **تنظیم ساختار**: ایجاد منو و لینک‌ها
4. **به‌روزرسانی**: همگام‌سازی با تغییرات

### نکات مهم:
- **فرمت‌بندی صحیح**: استفاده از Markdown
- **لینک‌های صحیح**: بررسی لینک‌های داخلی
- **سازماندهی مناسب**: ساختار منطقی
- **همکاری موثر**: قوانین ویرایش

با استفاده از این راهنما، می‌توانید مستندات پروژه خود را به راحتی به عنوان Wiki در Git استفاده کنید و از مزایای آن بهره‌مند شوید.
