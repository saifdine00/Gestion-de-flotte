# Docker Guide for LubeLogger

## 📋 Understanding the Docker Compose Files

LubeLogger provides **3 different docker-compose files** for different deployment scenarios. They all serve the same application but with different configurations:

### 1. `docker-compose.yml` - **Basic Setup (Default)**
- **Purpose**: Simple standalone setup
- **Database**: Uses **LiteDB** (file-based, no separate database container)
- **Use Case**: Quick start, development, single-user scenarios
- **Services**: Just the LubeLogger app
- **Port**: 8080

### 2. `docker-compose.postgresql.yml` - **PostgreSQL Setup**
- **Purpose**: Production-ready setup with PostgreSQL database
- **Database**: **PostgreSQL 14** (separate container)
- **Use Case**: Multi-user, production, when you need a real database
- **Services**: 
  - LubeLogger app
  - PostgreSQL database
  - Adminer (database management UI on port 8085)
- **Ports**: 
  - 8080 (LubeLogger app)
  - 8085 (Adminer - database admin tool)

### 3. `docker-compose.traefik.yml` - **Reverse Proxy Setup**
- **Purpose**: For use with Traefik reverse proxy
- **Database**: Uses **LiteDB** (file-based)
- **Use Case**: When you have Traefik handling SSL/HTTPS and routing
- **Services**: Just the LubeLogger app (configured for Traefik)
- **Features**: 
  - Automatic HTTPS via Traefik
  - Domain-based routing
  - No direct port exposure needed

---

## 🚀 How to Run with Your Custom Changes

Since you've made changes to the codebase (CSS improvements), you need to **build a custom Docker image** instead of using the pre-built one.

### Option 1: Basic Setup (LiteDB - Recommended for Development)

#### Step 1: Create a custom docker-compose file
Create `docker-compose.local.yml`:

```yaml
---
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: lubelogger:local
    restart: unless-stopped
    volumes:
      - data:/App/data
      - keys:/root/.aspnet/DataProtection-Keys
    ports:
      - 8080:8080

volumes:
  data:
  keys:
```

#### Step 2: Build and Run
```bash
cd lubelog-main
docker-compose -f docker-compose.local.yml up --build
```

#### Step 3: Access
Open browser: `http://localhost:8080`

---

### Option 2: PostgreSQL Setup (Production-like)

#### Step 1: Create `docker-compose.postgresql.local.yml`:

```yaml
---
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: lubelogger:local
    restart: unless-stopped
    depends_on:
      - postgres
    environment:
      - POSTGRES_CONNECTION=Host=postgres;Port=5432;Database=lubelogger;Username=lubelogger;Password=lubepass
    volumes:
      - data:/App/data
      - keys:/root/.aspnet/DataProtection-Keys
    ports:
      - 8080:8080

  postgres:
    image: postgres:14
    restart: unless-stopped
    environment:
      POSTGRES_USER: "lubelogger"
      POSTGRES_PASSWORD: "lubepass"
      POSTGRES_DB: "lubelogger"
    volumes:
      - postgres:/var/lib/postgresql/data
      - /etc/localtime:/etc/localtime:ro

  adminer:
    image: adminer
    restart: unless-stopped
    ports:
      - 8085:8080

volumes:
  data:
  keys:
  postgres:
```

#### Step 2: Build and Run
```bash
cd lubelog-main
docker-compose -f docker-compose.postgresql.local.yml up --build
```

#### Step 3: Access
- **LubeLogger**: `http://localhost:8080`
- **Adminer (Database UI)**: `http://localhost:8085`
  - Server: `postgres`
  - Username: `lubelogger`
  - Password: `lubepass`
  - Database: `lubelogger`

---

## 🔄 Rebuilding After Code Changes

### Quick Rebuild (Docker Compose)
```bash
# Stop containers
docker-compose -f docker-compose.local.yml down

# Rebuild and start
docker-compose -f docker-compose.local.yml up --build --force-recreate
```

### Full Clean Rebuild
```bash
# Stop and remove containers
docker-compose -f docker-compose.local.yml down

# Remove old image
docker rmi lubelogger:local

# Rebuild from scratch
docker-compose -f docker-compose.local.yml build --no-cache

# Start
docker-compose -f docker-compose.local.yml up
```

---

## 📊 Comparison Table

| Feature | docker-compose.yml | docker-compose.postgresql.yml | docker-compose.traefik.yml |
|---------|-------------------|------------------------------|---------------------------|
| **Database** | LiteDB (file) | PostgreSQL | LiteDB (file) |
| **Best For** | Development | Production | Production with Traefik |
| **Services** | 1 (app) | 3 (app, postgres, adminer) | 1 (app) |
| **Ports** | 8080 | 8080, 8085 | Via Traefik |
| **Setup Complexity** | ⭐ Simple | ⭐⭐ Medium | ⭐⭐⭐ Advanced |
| **Data Persistence** | ✅ Yes | ✅ Yes | ✅ Yes |

---

## 🛠️ Docker Commands Reference

### View Running Containers
```bash
docker ps
```

### View Logs
```bash
# Docker Compose
docker-compose -f docker-compose.local.yml logs -f

# Docker directly
docker logs <container-name>
```

### Stop Containers
```bash
docker-compose -f docker-compose.local.yml down
```

### Stop and Remove Volumes (⚠️ Deletes Data!)
```bash
docker-compose -f docker-compose.local.yml down -v
```

### Access Container Shell
```bash
docker exec -it <container-name> /bin/bash
```

### Clean Up Docker
```bash
# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Full cleanup (⚠️ Removes everything)
docker system prune -a --volumes
```

---

## 📝 Important Notes

### Data Persistence
- **LiteDB**: Data stored in Docker volume `data` → `/App/data`
- **PostgreSQL**: Data stored in Docker volume `postgres` → `/var/lib/postgresql/data`
- **Keys**: Encryption keys stored in volume `keys` → `/root/.aspnet/DataProtection-Keys`

### Port Conflicts
If port 8080 is already in use:
```yaml
ports:
  - 8081:8080  # Change 8081 to any available port
```

### Environment Variables
For PostgreSQL setup, you may need to set:
```yaml
environment:
  - POSTGRES_CONNECTION=Host=postgres;Port=5432;Database=lubelogger;Username=lubelogger;Password=lubepass
```

### Building for Different Architectures
The Dockerfile supports multi-architecture builds:
```bash
# For ARM64 (Apple Silicon, Raspberry Pi)
docker build --platform linux/arm64 -t lubelogger:local .

# For AMD64 (Intel/AMD)
docker build --platform linux/amd64 -t lubelogger:local .
```

---

## 🐛 Troubleshooting

### Build Fails
```bash
# Clear Docker build cache
docker builder prune -a

# Rebuild without cache
docker-compose -f docker-compose.local.yml build --no-cache
```

### Container Won't Start
```bash
# Check logs
docker-compose -f docker-compose.local.yml logs

# Check if port is in use
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Linux/Mac
```

### CSS Changes Not Showing
1. Hard refresh browser: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
2. Clear browser cache
3. Rebuild Docker image (CSS is baked into the image)

### Database Connection Issues (PostgreSQL)
- Ensure PostgreSQL container is running: `docker ps`
- Check connection string in environment variables
- Verify credentials match in both app and postgres services

---

## 🎯 Quick Start Summary

**For Development (with your CSS changes):**

1. Create `docker-compose.local.yml` (see Option 1 above)
2. Run: `docker-compose -f docker-compose.local.yml up --build`
3. Open: `http://localhost:8080`
4. After changes: `docker-compose -f docker-compose.local.yml up --build --force-recreate`

That's it! 🎉

