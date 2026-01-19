# Superset Docker Compose Deployment

Quick deployment of Apache Superset using Docker Compose with data persistence and example data import.

## Version Information

- **Superset**: 4.1.3
- **PostgreSQL**: 16
- **Redis**: 7-alpine
- **Access Port**: 8089

## Features

- ✅ Data persistence (PostgreSQL data, Superset configuration, data files)
- ✅ Example data import support
- ✅ Health checks and auto-restart
- ✅ Using private image source: `zlsmshoqvwt6q1.xuanyuan.run`

## Quick Start

### Prerequisites

- Docker
- Docker Compose

### Start Services

```bash
docker-compose up -d
```

### Check Service Status

```bash
docker-compose ps
```

### View Logs

```bash
docker-compose logs -f superset
```

## Access Superset

- **URL**: http://localhost:8089
- **Username**: admin
- **Password**: admin

## Data Persistence

All data is persisted through Docker volumes, so data won't be lost after container restart or deletion:

- `superset-docker-compose_db_data` - PostgreSQL database data
- `superset-docker-compose_superset_home` - Superset configuration and metadata
- `superset-docker-compose_superset_data` - Superset data files

### Verify Data Persistence

```bash
# Stop services
docker-compose down

# Check if volumes still exist
docker volume ls | Select-String superset-docker-compose

# Restart services
docker-compose up -d
```

## Configuration

### Environment Variables

All configuration is in the `.env` file:

```env
SUPERSET_SECRET_KEY=your-secret-key-change-this-in-production
SUPERSET_LOAD_EXAMPLES=yes

DATABASE_DIALECT=postgresql
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_USER=superset
DATABASE_PASSWORD=superset
DATABASE_DB=superset

REDIS_HOST=redis
REDIS_PORT=6379

ADMIN_USERNAME=admin
ADMIN_FIRSTNAME=Admin
ADMIN_LASTNAME=User
ADMIN_EMAIL=admin@superset.com
ADMIN_PASSWORD=admin
```

### Changing Port

To change the access port, edit the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "new_port:8088"  # For example: - "8090:8088"
```

## Common Commands

### Service Management

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# Check service status
docker-compose ps

# View logs
docker-compose logs -f [service_name]
```

### Data Management

```bash
# List all volumes
docker volume ls

# Remove volumes (will lose all data, use with caution)
docker-compose down -v

# Backup data
docker run --rm -v superset-docker-compose_db_data:/data -v $(pwd)/backup:/backup alpine \
  tar czf /backup/db_data.tar.gz -C /data .

# Restore data
docker run --rm -v superset-docker-compose_db_data:/data -v $(pwd)/backup:/backup alpine \
  tar xzf /backup/db_data.tar.gz -C /data
```

### Database Operations

```bash
# Connect to PostgreSQL
docker exec -it superset_db psql -U superset -d superset

# Backup database
docker exec superset_db pg_dump -U superset superset > backup.sql

# Restore database
docker exec -i superset_db psql -U superset superset < backup.sql
```

## Troubleshooting

### Services Won't Start

```bash
# View detailed logs
docker-compose logs

# Check port usage
netstat -ano | findstr :8089
```

### Database Connection Failed

```bash
# Check database status
docker-compose ps db

# View database logs
docker-compose logs db
```

### Example Data Not Imported

```bash
# Manually run initialization
docker-compose run --rm superset-init
```

## Security Recommendations

Before using in production, make sure to modify the following:

1. **Change SECRET_KEY**: Use a strong random key in the `.env` file
2. **Change Admin Password**: Set a strong password
3. **Configure HTTPS**: Use a reverse proxy (like Nginx) to configure SSL/TLS
4. **Restrict Network Access**: Use firewall to restrict access ports
5. **Regular Backups**: Set up regular database and configuration backups

## License

Apache Superset uses the Apache 2.0 license.

## References

- [Apache Superset Official Documentation](https://superset.apache.org/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
