# University Management System - Dockerfile
# Created for CockroachDB
# این فایل شامل تنظیمات Docker برای سیستم مدیریت دانشگاه است

FROM cockroachdb/cockroach:latest

# Set environment variables
ENV COCKROACH_DATABASE=university_management
ENV COCKROACH_HOST=localhost
ENV COCKROACH_PORT=26257

# Create directories for scripts and data
RUN mkdir -p /app/database/schema \
    /app/database/data \
    /app/database/procedures \
    /app/scripts \
    /app/backups \
    /app/logs

# Copy database scripts
COPY database/schema/ /app/database/schema/
COPY database/data/ /app/database/data/
COPY database/procedures/ /app/database/procedures/
COPY scripts/ /app/scripts/

# Set permissions
RUN chmod +x /app/scripts/*.sh

# Create initialization script
RUN echo '#!/bin/bash\n\
echo "Starting University Management Database Initialization..."\n\
\n\
# Wait for database to be ready\n\
echo "Waiting for database to be ready..."\n\
sleep 10\n\
\n\
# Create database if not exists\n\
echo "Creating database..."\n\
cockroach sql --insecure --host=localhost:26257 --execute="CREATE DATABASE IF NOT EXISTS university_management;"\n\
\n\
# Run schema scripts\n\
echo "Running schema scripts..."\n\
for file in /app/database/schema/*.sql; do\n\
  if [ -f "$file" ]; then\n\
    echo "Executing $file"\n\
    cockroach sql --insecure --host=localhost:26257 --database=university_management < "$file"\n\
  fi\n\
done\n\
\n\
# Run data scripts\n\
echo "Running data scripts..."\n\
for file in /app/database/data/*.sql; do\n\
  if [ -f "$file" ]; then\n\
    echo "Executing $file"\n\
    cockroach sql --insecure --host=localhost:26257 --database=university_management < "$file"\n\
  fi\n\
done\n\
\n\
# Run procedure scripts\n\
echo "Running procedure scripts..."\n\
for file in /app/database/procedures/*.sql; do\n\
  if [ -f "$file" ]; then\n\
    echo "Executing $file"\n\
    cockroach sql --insecure --host=localhost:26257 --database=university_management < "$file"\n\
  fi\n\
done\n\
\n\
echo "Database initialization completed!"\n\
' > /app/scripts/init_database.sh

# Make initialization script executable
RUN chmod +x /app/scripts/init_database.sh

# Create backup script
RUN echo '#!/bin/bash\n\
echo "Starting database backup..."\n\
BACKUP_FILE="/app/backups/university_backup_$(date +%Y%m%d_%H%M%S).sql"\n\
cockroach dump --insecure --host=localhost:26257 --database=university_management > "$BACKUP_FILE"\n\
echo "Backup completed: $BACKUP_FILE"\n\
' > /app/scripts/backup_database.sh

# Make backup script executable
RUN chmod +x /app/scripts/backup_database.sh

# Create health check script
RUN echo '#!/bin/bash\n\
cockroach node status --insecure --host=localhost:26257\n\
' > /app/scripts/health_check.sh

# Make health check script executable
RUN chmod +x /app/scripts/health_check.sh

# Expose ports
EXPOSE 26257 6565

# Set working directory
WORKDIR /app

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD /app/scripts/health_check.sh

# Default command
CMD ["start-single-node", "--insecure", "--http-addr=0.0.0.0:6565", "--listen-addr=0.0.0.0:26257"]
