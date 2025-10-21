#!/bin/bash

# University Management System - Database Initialization Script
# Created for CockroachDB
# این اسکریپت برای راه‌اندازی اولیه دیتابیس سیستم مدیریت دانشگاه است

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

# Check if CockroachDB is running
check_cockroachdb() {
    log_info "Checking if CockroachDB is running..."
    
    if ! cockroach node status --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT > /dev/null 2>&1; then
        log_error "CockroachDB is not running or not accessible at $COCKROACH_HOST:$COCKROACH_PORT"
        log_info "Please make sure CockroachDB is running with:"
        log_info "docker run -d --name=cockroachdb -p 26257:26257 -p 8080:8080 cockroachdb/cockroach:latest start-single-node --insecure"
        exit 1
    fi
    
    log_success "CockroachDB is running and accessible"
}

# Create database
create_database() {
    log_info "Creating database '$DATABASE_NAME'..."
    
    cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --execute="CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"
    
    if [ $? -eq 0 ]; then
        log_success "Database '$DATABASE_NAME' created successfully"
    else
        log_error "Failed to create database '$DATABASE_NAME'"
        exit 1
    fi
}

# Execute SQL scripts
execute_sql_scripts() {
    local script_dir=$1
    local script_type=$2
    
    if [ ! -d "$script_dir" ]; then
        log_warning "Directory $script_dir does not exist, skipping $script_type scripts"
        return
    fi
    
    log_info "Executing $script_type scripts from $script_dir..."
    
    # Find all SQL files and sort them
    local sql_files=$(find "$script_dir" -name "*.sql" -type f | sort)
    
    if [ -z "$sql_files" ]; then
        log_warning "No SQL files found in $script_dir"
        return
    fi
    
    # Execute each SQL file
    for sql_file in $sql_files; do
        log_info "Executing $(basename "$sql_file")..."
        
        if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME < "$sql_file"; then
            log_success "Successfully executed $(basename "$sql_file")"
        else
            log_error "Failed to execute $(basename "$sql_file")"
            exit 1
        fi
    done
}

# Verify database setup
verify_database() {
    log_info "Verifying database setup..."
    
    # Check if tables exist
    local table_count=$(cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" --format=csv | tail -n 1)
    
    if [ "$table_count" -gt 0 ]; then
        log_success "Database verification successful: $table_count tables created"
    else
        log_error "Database verification failed: No tables found"
        exit 1
    fi
    
    # Display table information
    log_info "Database tables:"
    cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --execute="SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;" --format=table
}

# Main execution
main() {
    log_info "Starting University Management Database Initialization..."
    log_info "Project root: $PROJECT_ROOT"
    log_info "Database: $DATABASE_NAME"
    log_info "Host: $COCKROACH_HOST:$COCKROACH_PORT"
    
    # Check if CockroachDB is running
    check_cockroachdb
    
    # Create database
    create_database
    
    # Execute schema scripts
    execute_sql_scripts "$PROJECT_ROOT/database/schema" "schema"
    
    # Execute data scripts
    execute_sql_scripts "$PROJECT_ROOT/database/data" "data"
    
    # Execute procedure scripts
    execute_sql_scripts "$PROJECT_ROOT/database/procedures" "procedure"
    
    # Verify database setup
    verify_database
    
    log_success "Database initialization completed successfully!"
    log_info "You can now access the database at:"
    log_info "  - Database: cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME"
    log_info "  - Admin UI: http://localhost:8080"
    log_info "  - Database name: $DATABASE_NAME"
}

# Run main function
main "$@"
