# Superset Docker Compose 部署

使用 Docker Compose 快速部署 Apache Superset，包含数据持久化和示例数据导入功能。

## 版本信息

- **Superset**: 4.1.3
- **PostgreSQL**: 16
- **Redis**: 7-alpine
- **访问端口**: 8089

## 功能特性

- ✅ 数据持久化（PostgreSQL 数据、Superset 配置、数据文件）
- ✅ 支持示例数据导入
- ✅ 健康检查和自动重启
- ✅ 使用私有镜像源：`zlsmshoqvwt6q1.xuanyuan.run`

## 快速开始

### 前置要求

- Docker
- Docker Compose

### 启动服务

```bash
docker-compose up -d
```

### 查看服务状态

```bash
docker-compose ps
```

### 查看日志

```bash
docker-compose logs -f superset
```

## 访问 Superset

- **URL**: http://localhost:8089
- **用户名**: admin
- **密码**: admin

## 数据持久化

所有数据都通过 Docker 卷持久化存储，容器重启或删除后数据不会丢失：

- `superset-docker-compose_db_data` - PostgreSQL 数据库数据
- `superset-docker-compose_superset_home` - Superset 配置和元数据
- `superset-docker-compose_superset_data` - Superset 数据文件

### 验证数据持久化

```bash
# 停止服务
docker-compose down

# 查看卷是否仍然存在
docker volume ls | Select-String superset-docker-compose

# 重新启动服务
docker-compose up -d
```

## 配置说明

### 环境变量

所有配置都在 `.env` 文件中：

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

### 修改端口

如需修改访问端口，编辑 `docker-compose.yml` 中的端口映射：

```yaml
ports:
  - "新端口:8088"  # 例如：- "8090:8088"
```

## 常用命令

### 服务管理

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f [服务名]
```

### 数据管理

```bash
# 查看所有卷
docker volume ls

# 删除卷（会丢失所有数据，谨慎使用）
docker-compose down -v

# 备份数据
docker run --rm -v superset-docker-compose_db_data:/data -v $(pwd)/backup:/backup alpine \
  tar czf /backup/db_data.tar.gz -C /data .

# 恢复数据
docker run --rm -v superset-docker-compose_db_data:/data -v $(pwd)/backup:/backup alpine \
  tar xzf /backup/db_data.tar.gz -C /data
```

### 数据库操作

```bash
# 连接到 PostgreSQL
docker exec -it superset_db psql -U superset -d superset

# 备份数据库
docker exec superset_db pg_dump -U superset superset > backup.sql

# 恢复数据库
docker exec -i superset_db psql -U superset superset < backup.sql
```

## 故障排查

### 服务无法启动

```bash
# 查看详细日志
docker-compose logs

# 检查端口占用
netstat -ano | findstr :8089
```

### 数据库连接失败

```bash
# 检查数据库状态
docker-compose ps db

# 查看数据库日志
docker-compose logs db
```

### 示例数据未导入

```bash
# 手动执行初始化
docker-compose run --rm superset-init
```

## 安全建议

生产环境使用前，请务必修改以下配置：

1. **修改 SECRET_KEY**：在 `.env` 文件中使用强随机密钥
2. **修改管理员密码**：设置强密码
3. **配置 HTTPS**：使用反向代理（如 Nginx）配置 SSL/TLS
4. **限制网络访问**：使用防火墙限制访问端口
5. **定期备份**：设置定期备份数据库和配置

## 许可证

Apache Superset 使用 Apache 2.0 许可证。

## 参考资源

- [Apache Superset 官方文档](https://superset.apache.org/docs/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
