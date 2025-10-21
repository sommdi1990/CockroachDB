#!/bin/bash

# Setup Monitoring Script for University Management System
# این اسکریپت برای راه‌اندازی سیستم مانیتورینگ با Prometheus و Grafana است

set -e

echo "🚀 Starting University Management System Monitoring Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Check if Docker is installed
check_docker() {
    print_header "Checking Docker Installation"
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_status "Docker and Docker Compose are installed ✓"
}

# Check if monitoring directory exists
check_monitoring_setup() {
    print_header "Checking Monitoring Configuration"
    
    if [ ! -d "docker/monitoring" ]; then
        print_error "Monitoring directory not found. Please run this script from the project root."
        exit 1
    fi
    
    if [ ! -f "docker/monitoring/prometheus.yml" ]; then
        print_error "Prometheus configuration not found."
        exit 1
    fi
    
    if [ ! -f "docker/monitoring/grafana/provisioning/datasources/prometheus.yml" ]; then
        print_error "Grafana datasource configuration not found."
        exit 1
    fi
    
    print_status "Monitoring configuration files found ✓"
}

# Create necessary directories
create_directories() {
    print_header "Creating Required Directories"
    
    mkdir -p docker/monitoring/grafana/provisioning/dashboards
    mkdir -p docker/monitoring/grafana/provisioning/datasources
    mkdir -p docker/backups
    
    print_status "Directories created ✓"
}

# Start monitoring services
start_monitoring() {
    print_header "Starting Monitoring Services"
    
    print_status "Starting Prometheus and Grafana..."
    docker-compose up -d prometheus grafana
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 30
    
    # Check if services are running
    if docker-compose ps | grep -q "university_prometheus.*Up"; then
        print_status "Prometheus is running ✓"
    else
        print_error "Prometheus failed to start"
        exit 1
    fi
    
    if docker-compose ps | grep -q "university_grafana.*Up"; then
        print_status "Grafana is running ✓"
    else
        print_error "Grafana failed to start"
        exit 1
    fi
}

# Configure Grafana
configure_grafana() {
    print_header "Configuring Grafana"
    
    print_status "Waiting for Grafana to be ready..."
    sleep 10
    
    # Check if Grafana is accessible
    if curl -s http://localhost:3001 > /dev/null; then
        print_status "Grafana is accessible ✓"
    else
        print_warning "Grafana might not be ready yet. Please check manually."
    fi
    
    print_status "Grafana configuration completed ✓"
}

# Display access information
show_access_info() {
    print_header "Access Information"
    
    echo -e "${GREEN}🎉 Monitoring setup completed successfully!${NC}"
    echo ""
    echo -e "${BLUE}Access URLs:${NC}"
    echo -e "  📊 Grafana Dashboard: ${YELLOW}http://localhost:3001${NC}"
    echo -e "     Username: ${YELLOW}admin${NC}"
    echo -e "     Password: ${YELLOW}admin123${NC}"
    echo ""
    echo -e "  📈 Prometheus: ${YELLOW}http://localhost:9090${NC}"
    echo ""
    echo -e "  🗄️  CockroachDB Admin: ${YELLOW}http://localhost:8083${NC}"
    echo ""
    echo -e "${BLUE}Useful Commands:${NC}"
    echo -e "  View logs: ${YELLOW}docker-compose logs -f prometheus grafana${NC}"
    echo -e "  Stop services: ${YELLOW}docker-compose down${NC}"
    echo -e "  Restart services: ${YELLOW}docker-compose restart prometheus grafana${NC}"
    echo ""
    echo -e "${BLUE}Dashboard Features:${NC}"
    echo -e "  • Real-time database monitoring"
    echo -e "  • Performance metrics"
    echo -e "  • Resource usage tracking"
    echo -e "  • Alert management"
    echo -e "  • Business metrics"
    echo ""
    echo -e "${GREEN}Happy Monitoring! 🚀${NC}"
}

# Main execution
main() {
    print_header "University Management System Monitoring Setup"
    
    check_docker
    check_monitoring_setup
    create_directories
    start_monitoring
    configure_grafana
    show_access_info
}

# Run main function
main "$@"
