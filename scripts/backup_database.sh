#!/bin/bash

# University Management System - Database Backup Script
# Created for CockroachDB
# این اسکریپت برای پشتیبان‌گیری از دیتابیس سیستم مدیریت دانشگاه است

set -e

# Configuration
COCKROACH_HOST=${COCKROACH_HOST:-localhost}
COCKROACH_PORT=${COCKROACH_PORT:-26257}
DATABASE_NAME=${DATABASE_NAME:-university_management}
BACKUP_DIR=${BACKUP_DIR:-./backups}
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

# Create backup directory
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        log_info "Creating backup directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi
}

# Check if CockroachDB is running
check_cockroachdb() {
    log_info "Checking if CockroachDB is running..."
    
    if ! cockroach node status --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT > /dev/null 2>&1; then
        log_error "CockroachDB is not running or not accessible at $COCKROACH_HOST:$COCKROACH_PORT"
        exit 1
    fi
    
    log_success "CockroachDB is running and accessible"
}

# Create full database backup
create_full_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/university_full_backup_$timestamp.sql"
    
    log_info "Creating full database backup..."
    log_info "Backup file: $backup_file"
    
    if cockroach dump --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME > "$backup_file"; then
        log_success "Full backup completed: $backup_file"
        
        # Get backup file size
        local file_size=$(du -h "$backup_file" | cut -f1)
        log_info "Backup file size: $file_size"
    else
        log_error "Failed to create full backup"
        exit 1
    fi
}

# Create schema-only backup
create_schema_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/university_schema_backup_$timestamp.sql"
    
    log_info "Creating schema-only backup..."
    log_info "Backup file: $backup_file"
    
    if cockroach dump --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --schema-only > "$backup_file"; then
        log_success "Schema backup completed: $backup_file"
        
        # Get backup file size
        local file_size=$(du -h "$backup_file" | cut -f1)
        log_info "Backup file size: $file_size"
    else
        log_error "Failed to create schema backup"
        exit 1
    fi
}

# Create data-only backup
create_data_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/university_data_backup_$timestamp.sql"
    
    log_info "Creating data-only backup..."
    log_info "Backup file: $backup_file"
    
    if cockroach dump --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME --data-only > "$backup_file"; then
        log_success "Data backup completed: $backup_file"
        
        # Get backup file size
        local file_size=$(du -h "$backup_file" | cut -f1)
        log_info "Backup file size: $file_size"
    else
        log_error "Failed to create data backup"
        exit 1
    fi
}

# Clean old backups
clean_old_backups() {
    local days_to_keep=${DAYS_TO_KEEP:-30}
    
    log_info "Cleaning backups older than $days_to_keep days..."
    
    local deleted_count=0
    while IFS= read -r -d '' file; do
        rm "$file"
        ((deleted_count++))
    done < <(find "$BACKUP_DIR" -name "university_*_backup_*.sql" -type f -mtime +$days_to_keep -print0)
    
    if [ $deleted_count -gt 0 ]; then
        log_success "Cleaned $deleted_count old backup files"
    else
        log_info "No old backup files to clean"
    fi
}

# List existing backups
list_backups() {
    log_info "Existing backups in $BACKUP_DIR:"
    
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        ls -lah "$BACKUP_DIR"/university_*_backup_*.sql 2>/dev/null | while read -r line; do
            echo "  $line"
        done
    else
        log_warning "No backup files found in $BACKUP_DIR"
    fi
}

# Restore from backup
restore_backup() {
    local backup_file=$1
    
    if [ -z "$backup_file" ]; then
        log_error "Backup file not specified"
        log_info "Usage: $0 restore <backup_file>"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    log_warning "This will restore the database from backup: $backup_file"
    log_warning "This operation will overwrite existing data!"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Restore operation cancelled"
        exit 0
    fi
    
    log_info "Restoring database from backup..."
    
    if cockroach sql --insecure --host=$COCKROACH_HOST:$COCKROACH_PORT --database=$DATABASE_NAME < "$backup_file"; then
        log_success "Database restored successfully from $backup_file"
    else
        log_error "Failed to restore database from $backup_file"
        exit 1
    fi
}

# Show help
show_help() {
    echo "University Management System - Database Backup Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  full        Create full database backup (default)"
    echo "  schema      Create schema-only backup"
    echo "  data        Create data-only backup"
    echo "  restore     Restore database from backup"
    echo "  list        List existing backups"
    echo "  clean       Clean old backups"
    echo "  help        Show this help message"
    echo ""
    echo "Options:"
    echo "  --host HOST        CockroachDB host (default: localhost)"
    echo "  --port PORT        CockroachDB port (default: 26257)"
    echo "  --database NAME    Database name (default: university_management)"
    echo "  --backup-dir DIR   Backup directory (default: ./backups)"
    echo "  --days-to-keep N   Days to keep backups (default: 30)"
    echo ""
    echo "Examples:"
    echo "  $0 full"
    echo "  $0 schema"
    echo "  $0 restore /path/to/backup.sql"
    echo "  $0 list"
    echo "  $0 clean"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --host)
                COCKROACH_HOST="$2"
                shift 2
                ;;
            --port)
                COCKROACH_PORT="$2"
                shift 2
                ;;
            --database)
                DATABASE_NAME="$2"
                shift 2
                ;;
            --backup-dir)
                BACKUP_DIR="$2"
                shift 2
                ;;
            --days-to-keep)
                DAYS_TO_KEEP="$2"
                shift 2
                ;;
            full|schema|data|restore|list|clean|help)
                COMMAND="$1"
                shift
                ;;
            *)
                if [ "$COMMAND" = "restore" ]; then
                    RESTORE_FILE="$1"
                else
                    log_error "Unknown option: $1"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
}

# Main execution
main() {
    # Set default command
    COMMAND=${COMMAND:-full}
    
    log_info "Starting University Management Database Backup..."
    log_info "Project root: $PROJECT_ROOT"
    log_info "Database: $DATABASE_NAME"
    log_info "Host: $COCKROACH_HOST:$COCKROACH_PORT"
    log_info "Backup directory: $BACKUP_DIR"
    
    case $COMMAND in
        full)
            create_backup_dir
            check_cockroachdb
            create_full_backup
            clean_old_backups
            ;;
        schema)
            create_backup_dir
            check_cockroachdb
            create_schema_backup
            ;;
        data)
            create_backup_dir
            check_cockroachdb
            create_data_backup
            ;;
        restore)
            restore_backup "$RESTORE_FILE"
            ;;
        list)
            list_backups
            ;;
        clean)
            clean_old_backups
            ;;
        help)
            show_help
            ;;
        *)
            log_error "Unknown command: $COMMAND"
            show_help
            exit 1
            ;;
    esac
    
    log_success "Backup operation completed successfully!"
}

# Parse arguments and run main function
parse_arguments "$@"
main
