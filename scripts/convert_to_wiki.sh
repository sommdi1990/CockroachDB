#!/bin/bash

# University Management System - Convert Documentation to Wiki
# این اسکریپت مستندات پروژه را به فرمت Wiki تبدیل می‌کند

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WIKI_DIR="$PROJECT_ROOT/wiki"
DOCS_DIR="$PROJECT_ROOT/docs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create wiki directory
create_wiki_directory() {
    log_info "Creating wiki directory..."
    
    if [ -d "$WIKI_DIR" ]; then
        log_warning "Wiki directory already exists, removing..."
        rm -rf "$WIKI_DIR"
    fi
    
    mkdir -p "$WIKI_DIR"
    log_success "Wiki directory created: $WIKI_DIR"
}

# Convert main README to wiki home page
convert_home_page() {
    log_info "Converting README to wiki home page..."
    
    # Create home page with enhanced content
    cat > "$WIKI_DIR/Home.md" << 'EOF'
# سیستم مدیریت دانشگاه - University Management System

## معرفی

این پروژه یک سیستم مدیریت دانشگاه کامل و حرفه‌ای است که بر روی CockroachDB پیاده‌سازی شده است. این سیستم شامل تمام جداول، روابط، ایندکس‌ها، ویوها و مستندات لازم برای مدیریت یک دانشگاه است.

## ویژگی‌های اصلی

- **دیتابیس کامل**: 14 جدول اصلی با روابط مناسب
- **ایندکس‌های بهینه**: 50+ ایندکس برای عملکرد بهتر
- **ویوهای مفید**: 10 ویو برای گزارش‌گیری
- **مستندات کامل**: راهنمای فارسی کامل
- **اسکریپت‌های خودکار**: راه‌اندازی، پشتیبان‌گیری و تست
- **Docker Support**: راه‌اندازی آسان با Docker

## ساختار پروژه

```
├── database/          # فایل‌های دیتابیس
├── docker/           # فایل‌های Docker
├── docs/             # مستندات کامل
├── scripts/          # اسکریپت‌های خودکار
└── فایل‌های اصلی
```

## نصب و راه‌اندازی

### پیش‌نیازها
- Docker
- Docker Compose
- Git

### مراحل نصب
1. کلون کردن پروژه
2. راه‌اندازی CockroachDB
3. اجرای اسکریپت راه‌اندازی
4. تست سیستم

### دستورات سریع
```bash
# راه‌اندازی CockroachDB
docker run -d --name=cockroachdb -p 26257:26257 -p 8080:8080 cockroachdb/cockroach:latest start-single-node --insecure

# راه‌اندازی دیتابیس
./scripts/init_database.sh

# تست سیستم
./scripts/test_database.sh
```

## لینک‌های مفید

- [آموزش CockroachDB](CockroachDB-Tutorial)
- [راهنمای استفاده](Usage-Guide)
- [راهنمای نگهداری](Maintenance-Guide)
- [مثال‌های عملی](Practical-Examples)
- [راهنمای نصب](Installation-Guide)

## پشتیبانی

در صورت بروز مشکل، لطفاً issue جدیدی در repository ایجاد کنید.

## مجوز

این پروژه تحت مجوز MIT منتشر شده است.
EOF

    log_success "Home page created"
}

# Convert documentation files to wiki pages
convert_documentation() {
    log_info "Converting documentation files to wiki pages..."
    
    # Convert CockroachDB tutorial
    if [ -f "$DOCS_DIR/cockroachdb_tutorial.md" ]; then
        log_info "Converting CockroachDB tutorial..."
        cp "$DOCS_DIR/cockroachdb_tutorial.md" "$WIKI_DIR/CockroachDB-Tutorial.md"
        log_success "CockroachDB tutorial converted"
    fi
    
    # Convert usage guide
    if [ -f "$DOCS_DIR/usage_guide.md" ]; then
        log_info "Converting usage guide..."
        cp "$DOCS_DIR/usage_guide.md" "$WIKI_DIR/Usage-Guide.md"
        log_success "Usage guide converted"
    fi
    
    # Convert maintenance guide
    if [ -f "$DOCS_DIR/maintenance_guide.md" ]; then
        log_info "Converting maintenance guide..."
        cp "$DOCS_DIR/maintenance_guide.md" "$WIKI_DIR/Maintenance-Guide.md"
        log_success "Maintenance guide converted"
    fi
    
    # Convert database guide
    if [ -f "$DOCS_DIR/database_guide.md" ]; then
        log_info "Converting database guide..."
        cp "$DOCS_DIR/database_guide.md" "$WIKI_DIR/Database-Guide.md"
        log_success "Database guide converted"
    fi
    
    # Convert practical examples
    if [ -f "$DOCS_DIR/practical_examples.md" ]; then
        log_info "Converting practical examples..."
        cp "$DOCS_DIR/practical_examples.md" "$WIKI_DIR/Practical-Examples.md"
        log_success "Practical examples converted"
    fi
}

# Convert main project files
convert_main_files() {
    log_info "Converting main project files..."
    
    # Convert installation guide
    if [ -f "$PROJECT_ROOT/INSTALLATION_GUIDE.md" ]; then
        log_info "Converting installation guide..."
        cp "$PROJECT_ROOT/INSTALLATION_GUIDE.md" "$WIKI_DIR/Installation-Guide.md"
        log_success "Installation guide converted"
    fi
    
    # Convert project summary
    if [ -f "$PROJECT_ROOT/PROJECT_SUMMARY.md" ]; then
        log_info "Converting project summary..."
        cp "$PROJECT_ROOT/PROJECT_SUMMARY.md" "$WIKI_DIR/Project-Summary.md"
        log_success "Project summary converted"
    fi
    
    # Convert complete overview
    if [ -f "$PROJECT_ROOT/COMPLETE_PROJECT_OVERVIEW.md" ]; then
        log_info "Converting complete overview..."
        cp "$PROJECT_ROOT/COMPLETE_PROJECT_OVERVIEW.md" "$WIKI_DIR/Complete-Overview.md"
        log_success "Complete overview converted"
    fi
}

# Create wiki navigation
create_navigation() {
    log_info "Creating wiki navigation..."
    
    cat > "$WIKI_DIR/_Sidebar.md" << 'EOF'
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

## اسکریپت‌ها
- [راه‌اندازی دیتابیس](scripts/init_database.sh)
- [پشتیبان‌گیری](scripts/backup_database.sh)
- [تست سیستم](scripts/test_database.sh)
EOF

    log_success "Navigation created"
}

# Create wiki footer
create_footer() {
    log_info "Creating wiki footer..."
    
    cat > "$WIKI_DIR/_Footer.md" << 'EOF'
---
**سیستم مدیریت دانشگاه** - University Management System

برای اطلاعات بیشتر، به [صفحه اصلی](Home) مراجعه کنید.

**آخرین به‌روزرسانی**: $(date)
EOF

    log_success "Footer created"
}

# Create wiki configuration
create_wiki_config() {
    log_info "Creating wiki configuration..."
    
    cat > "$WIKI_DIR/.gitignore" << 'EOF'
# Wiki specific ignore file
*.tmp
*.temp
.DS_Store
Thumbs.db
EOF

    log_success "Wiki configuration created"
}

# Create README for wiki
create_wiki_readme() {
    log_info "Creating wiki README..."
    
    cat > "$WIKI_DIR/README.md" << 'EOF'
# Wiki Documentation

این دایرکتوری شامل مستندات Wiki برای سیستم مدیریت دانشگاه است.

## ساختار

- `Home.md` - صفحه اصلی
- `CockroachDB-Tutorial.md` - آموزش CockroachDB
- `Usage-Guide.md` - راهنمای استفاده
- `Maintenance-Guide.md` - راهنمای نگهداری
- `Database-Guide.md` - راهنمای دیتابیس
- `Practical-Examples.md` - مثال‌های عملی
- `Installation-Guide.md` - راهنمای نصب
- `Project-Summary.md` - خلاصه پروژه
- `Complete-Overview.md` - نمای کامل

## استفاده

برای استفاده از این Wiki:

1. فایل‌ها را در repository Wiki خود کپی کنید
2. در GitHub، Wiki را فعال کنید
3. فایل‌ها را به عنوان صفحات Wiki آپلود کنید

## نکات

- تمام فایل‌ها به فرمت Markdown هستند
- لینک‌های داخلی باید به‌روزرسانی شوند
- تصاویر باید در repository اصلی نگهداری شوند
EOF

    log_success "Wiki README created"
}

# Create script documentation
create_script_docs() {
    log_info "Creating script documentation..."
    
    # Create script documentation directory
    mkdir -p "$WIKI_DIR/scripts"
    
    # Copy scripts with documentation
    if [ -f "$PROJECT_ROOT/scripts/init_database.sh" ]; then
        cp "$PROJECT_ROOT/scripts/init_database.sh" "$WIKI_DIR/scripts/"
        log_success "Database initialization script copied"
    fi
    
    if [ -f "$PROJECT_ROOT/scripts/backup_database.sh" ]; then
        cp "$PROJECT_ROOT/scripts/backup_database.sh" "$WIKI_DIR/scripts/"
        log_success "Backup script copied"
    fi
    
    if [ -f "$PROJECT_ROOT/scripts/test_database.sh" ]; then
        cp "$PROJECT_ROOT/scripts/test_database.sh" "$WIKI_DIR/scripts/"
        log_success "Test script copied"
    fi
    
    # Create script documentation
    cat > "$WIKI_DIR/scripts/README.md" << 'EOF'
# اسکریپت‌های سیستم

این دایرکتوری شامل اسکریپت‌های خودکار سیستم است.

## اسکریپت‌ها

### init_database.sh
اسکریپت راه‌اندازی دیتابیس
- بررسی اتصال به دیتابیس
- ایجاد جداول و ایندکس‌ها
- وارد کردن داده‌های نمونه
- بررسی صحت نصب

### backup_database.sh
اسکریپت پشتیبان‌گیری
- پشتیبان‌گیری کامل
- پشتیبان‌گیری ساختاری
- پشتیبان‌گیری داده‌ای
- پاکسازی پشتیبان‌های قدیمی

### test_database.sh
اسکریپت تست سیستم
- تست اتصال
- تست جداول
- تست داده‌ها
- تست عملکرد

## استفاده

```bash
# راه‌اندازی دیتابیس
./scripts/init_database.sh

# پشتیبان‌گیری
./scripts/backup_database.sh full

# تست سیستم
./scripts/test_database.sh
```
EOF

    log_success "Script documentation created"
}

# Create wiki index
create_wiki_index() {
    log_info "Creating wiki index..."
    
    cat > "$WIKI_DIR/Index.md" << 'EOF'
# فهرست مطالب Wiki

## آموزش‌ها
- [آموزش CockroachDB](CockroachDB-Tutorial) - آموزش کامل از صفر تا صد
- [مثال‌های عملی](Practical-Examples) - مثال‌های پیشرفته و کاربردی

## راهنماها
- [راهنمای دیتابیس](Database-Guide) - ساختار کامل دیتابیس
- [راهنمای استفاده](Usage-Guide) - دستورات و پرس و جوها
- [راهنمای نگهداری](Maintenance-Guide) - نگهداری و مانیتورینگ
- [راهنمای نصب](Installation-Guide) - نصب و راه‌اندازی

## خلاصه‌ها
- [خلاصه پروژه](Project-Summary) - توضیحات کلی پروژه
- [نمای کامل](Complete-Overview) - نمای کامل و جزئیات

## اسکریپت‌ها
- [راه‌اندازی دیتابیس](scripts/init_database.sh)
- [پشتیبان‌گیری](scripts/backup_database.sh)
- [تست سیستم](scripts/test_database.sh)

## لینک‌های مفید
- [صفحه اصلی](Home)
- [فهرست مطالب](Index)
- [اسکریپت‌ها](scripts/README)
EOF

    log_success "Wiki index created"
}

# Main execution
main() {
    log_info "Starting conversion to wiki format..."
    log_info "Project root: $PROJECT_ROOT"
    log_info "Wiki directory: $WIKI_DIR"
    
    # Create wiki directory
    create_wiki_directory
    
    # Convert documentation
    convert_documentation
    
    # Convert main files
    convert_main_files
    
    # Create wiki structure
    create_navigation
    create_footer
    create_wiki_config
    create_wiki_readme
    create_script_docs
    create_wiki_index
    
    # Show summary
    log_success "Wiki conversion completed successfully!"
    log_info "Wiki files created in: $WIKI_DIR"
    log_info "Total files: $(find "$WIKI_DIR" -type f | wc -l)"
    
    # Show file structure
    log_info "Wiki structure:"
    tree "$WIKI_DIR" 2>/dev/null || find "$WIKI_DIR" -type f | sort
    
    log_info "To use the wiki:"
    log_info "1. Copy files to your GitHub wiki repository"
    log_info "2. Enable wiki in GitHub repository settings"
    log_info "3. Upload files as wiki pages"
    log_info "4. Update internal links if needed"
}

# Run main function
main "$@"
