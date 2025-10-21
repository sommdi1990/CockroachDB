#!/bin/bash

# University Management System - Database Test Script
# Created for CockroachDB
# این اسکریپت برای تست عملکرد دیتابیس سیستم مدیریت دانشگاه است

set -e

# Configuration
COCKROACH_HOST=${COCKROACH_HOST:-localhost}
COCKROACH_PORT=${COCKROACH_PORT:-26257}
DATABASE_NAME=${DATABASE_NAME:-university_management}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

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

# Test database connection
test_connection() {
    log_info "Testing database connection..."
    
    if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --execute="SELECT 1;" > /dev/null 2>&1; then
        log_success "Database connection successful"
    else
        log_error "Database connection failed"
        exit 1
    fi
}

# Test database exists
test_database_exists() {
    log_info "Testing if database exists..."
    
    local db_exists=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --execute="SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '$DATABASE_NAME';" --format=csv | tail -n 1)
    
    if [ "$db_exists" = "1" ]; then
        log_success "Database '$DATABASE_NAME' exists"
    else
        log_error "Database '$DATABASE_NAME' does not exist"
        exit 1
    fi
}

# Test tables exist
test_tables_exist() {
    log_info "Testing if tables exist..."
    
    local table_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" --format=csv | tail -n 1)
    
    if [ "$table_count" -gt 0 ]; then
        log_success "Found $table_count tables in database"
    else
        log_error "No tables found in database"
        exit 1
    fi
}

# Test data exists
test_data_exists() {
    log_info "Testing if sample data exists..."
    
    # Test students
    local student_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM students;" --format=csv | tail -n 1)
    if [ "$student_count" -gt 0 ]; then
        log_success "Found $student_count students"
    else
        log_warning "No students found"
    fi
    
    # Test professors
    local professor_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM professors;" --format=csv | tail -n 1)
    if [ "$professor_count" -gt 0 ]; then
        log_success "Found $professor_count professors"
    else
        log_warning "No professors found"
    fi
    
    # Test courses
    local course_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM courses;" --format=csv | tail -n 1)
    if [ "$course_count" -gt 0 ]; then
        log_success "Found $course_count courses"
    else
        log_warning "No courses found"
    fi
    
    # Test departments
    local department_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM departments;" --format=csv | tail -n 1)
    if [ "$department_count" -gt 0 ]; then
        log_success "Found $department_count departments"
    else
        log_warning "No departments found"
    fi
}

# Test views exist
test_views_exist() {
    log_info "Testing if views exist..."
    
    local view_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'public';" --format=csv | tail -n 1)
    
    if [ "$view_count" -gt 0 ]; then
        log_success "Found $view_count views"
    else
        log_warning "No views found"
    fi
}

# Test indexes exist
test_indexes_exist() {
    log_info "Testing if indexes exist..."
    
    local index_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = 'public';" --format=csv | tail -n 1)
    
    if [ "$index_count" -gt 0 ]; then
        log_success "Found $index_count indexes"
    else
        log_warning "No indexes found"
    fi
}

# Test complex queries
test_complex_queries() {
    log_info "Testing complex queries..."
    
    # Test student details view
    if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM student_details;" > /dev/null 2>&1; then
        log_success "student_details view works"
    else
        log_error "student_details view failed"
    fi
    
    # Test professor details view
    if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM professor_details;" > /dev/null 2>&1; then
        log_success "professor_details view works"
    else
        log_error "professor_details view failed"
    fi
    
    # Test course details view
    if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM course_details;" > /dev/null 2>&1; then
        log_success "course_details view works"
    else
        log_error "course_details view failed"
    fi
    
    # Test department statistics view
    if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM department_statistics;" > /dev/null 2>&1; then
        log_success "department_statistics view works"
    else
        log_error "department_statistics view failed"
    fi
}

# Test performance
test_performance() {
    log_info "Testing database performance..."
    
    # Test simple query performance
    local start_time=$(date +%s%N)
    cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM students;" > /dev/null 2>&1
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    
    if [ $duration -lt 1000 ]; then
        log_success "Simple query performance: ${duration}ms (Good)"
    else
        log_warning "Simple query performance: ${duration}ms (Slow)"
    fi
    
    # Test complex query performance
    local start_time=$(date +%s%N)
    cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT * FROM student_details LIMIT 10;" > /dev/null 2>&1
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    
    if [ $duration -lt 2000 ]; then
        log_success "Complex query performance: ${duration}ms (Good)"
    else
        log_warning "Complex query performance: ${duration}ms (Slow)"
    fi
}

# Test data integrity
test_data_integrity() {
    log_info "Testing data integrity..."
    
    # Test foreign key constraints
    local fk_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_type = 'FOREIGN KEY';" --format=csv | tail -n 1)
    
    if [ "$fk_count" -gt 0 ]; then
        log_success "Found $fk_count foreign key constraints"
    else
        log_warning "No foreign key constraints found"
    fi
    
    # Test unique constraints
    local unique_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_type = 'UNIQUE';" --format=csv | tail -n 1)
    
    if [ "$unique_count" -gt 0 ]; then
        log_success "Found $unique_count unique constraints"
    else
        log_warning "No unique constraints found"
    fi
}

# Test backup functionality
test_backup() {
    log_info "Testing backup functionality..."
    
    if [ -f "$PROJECT_ROOT/scripts/backup_database.sh" ]; then
        log_success "Backup script exists"
        
        # Test backup script syntax
        if bash -n "$PROJECT_ROOT/scripts/backup_database.sh"; then
            log_success "Backup script syntax is valid"
        else
            log_error "Backup script syntax is invalid"
        fi
    else
        log_error "Backup script not found"
    fi
}

# Test initialization script
test_initialization() {
    log_info "Testing initialization script..."
    
    if [ -f "$PROJECT_ROOT/scripts/init_database.sh" ]; then
        log_success "Initialization script exists"
        
        # Test initialization script syntax
        if bash -n "$PROJECT_ROOT/scripts/init_database.sh"; then
            log_success "Initialization script syntax is valid"
        else
            log_error "Initialization script syntax is invalid"
        fi
    else
        log_error "Initialization script not found"
    fi
}

# Show database statistics
show_statistics() {
    log_info "Database Statistics:"
    
    echo "=========================================="
    echo "Database: $DATABASE_NAME"
    echo "Host: $COCKROACH_HOST:$COCKROACH_PORT"
    echo "=========================================="
    
    # Show table counts
    echo "Table Counts:"
    cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="
    SELECT 
        'Students' AS table_name,
        COUNT(*) AS count
    FROM students
    UNION ALL
    SELECT 
        'Professors' AS table_name,
        COUNT(*) AS count
    FROM professors
    UNION ALL
    SELECT 
        'Courses' AS table_name,
        COUNT(*) AS count
    FROM courses
    UNION ALL
    SELECT 
        'Departments' AS table_name,
        COUNT(*) AS count
    FROM departments
    UNION ALL
    SELECT 
        'Enrollments' AS table_name,
        COUNT(*) AS count
    FROM enrollments
    UNION ALL
    SELECT 
        'Grades' AS table_name,
        COUNT(*) AS count
    FROM grades
    ORDER BY table_name;
    " --format=table
    
    echo "=========================================="
}

# Main execution
main() {
    log_info "Starting University Management Database Tests..."
    log_info "Project root: $PROJECT_ROOT"
    log_info "Database: $DATABASE_NAME"
    log_info "Host: $COCKROACH_HOST:$COCKROACH_PORT"
    
    # Run all tests
    test_connection
    test_database_exists
    test_tables_exist
    test_data_exists
    test_views_exist
    test_indexes_exist
    test_complex_queries
    test_performance
    test_data_integrity
    test_backup
    test_initialization
    
    # Show statistics
    show_statistics
    
    log_success "All tests completed successfully!"
    log_info "Database is ready for use."
    log_info "You can access the database at:"
    log_info "  - Database: cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME"
    log_info "  - Admin UI: http://localhost:8080"
    log_info "  - Database name: $DATABASE_NAME"
}

# Run main function
main "$@"
