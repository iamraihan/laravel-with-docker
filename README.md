# Laravel + React + PostgreSQL + Redis + Docker Template

A complete, reusable Docker template for Laravel projects with React frontend, PostgreSQL database, Redis cache, and web-based management tools.

## 🚀 Quick Start

### For New Projects:

1. **Clone this template:**

   ```bash
   git clone <your-repo-url> laravel-template
   cd laravel-template
   ```

2. **Create a new project:**

   ```bash
   ./setup-new-project.sh my-awesome-project
   ```

3. **Start development:**
   ```bash
   cd my-awesome-project
   ./dev.sh
   ```

### For Existing Projects:

1. **Copy the Docker configuration:**

   ```bash
   cp -r docker/ /path/to/your/project/
   cp docker-compose.yml /path/to/your/project/
   cp .dockerignore /path/to/your/project/
   cp env.example /path/to/your/project/
   ```

2. **Update configuration for your project name**
3. **Start services:**
   ```bash
   docker-compose up -d
   ```

## 🌐 Access Points

- **Laravel Application**: http://localhost:8080
- **pgAdmin (PostgreSQL GUI)**: http://localhost:5050
- **Redis Commander (Redis GUI)**: http://localhost:8081
- **Mailpit (Email Testing)**: http://localhost:8025

## 🔑 Database Access

### pgAdmin Login:

- **Email**: admin@admin.com
- **Password**: admin

### PostgreSQL Connection (for pgAdmin):

- **Host**: postgres
- **Port**: 5432
- **Database**: [project_name]\_db
- **Username**: [project_name]\_user
- **Password**: [project_name]\_password

### Redis Commander:

- **No login required**
- Direct access to Redis at http://localhost:8081

## 🛠️ Development

### Running Commands:

```bash
# Laravel commands
docker-compose exec app php artisan [command]

# Node.js commands
docker-compose exec node pnpm [command]

# Database commands
docker-compose exec postgres psql -U [project_name]_user -d [project_name]_db
```

### Building Assets:

```bash
docker-compose exec node pnpm run build
docker-compose exec node pnpm run dev
```

## 📁 Template Structure

```
laravel-template/
├── docker/                 # Docker configuration
│   ├── app/               # PHP-FPM configuration
│   ├── nginx/             # Nginx configuration
│   ├── node/              # Node.js configuration
│   └── postgres/          # PostgreSQL configuration
├── docker-compose.yml     # Docker services
├── .dockerignore          # Docker ignore file
├── env.example            # Environment template
├── setup-new-project.sh   # Project creation script
├── dev.sh                 # Start development
├── stop.sh                # Stop services
├── restart.sh             # Restart services
├── logs.sh                # View logs
├── Makefile               # Common commands
└── README.md              # This file
```

## 🔧 Configuration

The template includes:

- **Laravel** (PHP 8.2-fpm-alpine)
- **React** (with Vite and laravel-vite-plugin)
- **PostgreSQL** 15-alpine
- **Redis** 7-alpine
- **Nginx** (web server)
- **pgAdmin** (PostgreSQL GUI)
- **Redis Commander** (Redis GUI)
- **Mailpit** (email testing)
- **Node.js** 18-alpine (for frontend)

## 🐳 Docker Services

- **app**: Laravel application (PHP-FPM)
- **nginx**: Web server
- **postgres**: PostgreSQL database
- **redis**: Redis cache
- **node**: Node.js for frontend
- **pgadmin**: PostgreSQL management
- **redis-commander**: Redis management
- **mailpit**: Email testing

## 📝 Features

- ✅ **Alpine Linux** - Smaller, faster Docker images
- ✅ **pnpm** - Fast Node.js package management
- ✅ **Tailwind CSS** - Utility-first CSS framework
- ✅ **Web-based DB Management** - pgAdmin + Redis Commander
- ✅ **Email Testing** - Mailpit for development
- ✅ **Hot Reload** - Vite for fast development
- ✅ **Production Ready** - Optimized for deployment
- ✅ **Easy Setup** - One-command project creation

## 🚀 Usage Examples

### Create Multiple Projects:

```bash
# Create project 1
./setup-new-project.sh ecommerce-app

# Create project 2
./setup-new-project.sh blog-platform

# Create project 3
./setup-new-project.sh api-service
```

### Custom Ports:

Edit `docker-compose.yml` to change ports:

```yaml
ports:
  - "8080:80" # Laravel
  - "5050:80" # pgAdmin
  - "8081:8081" # Redis Commander
  - "8025:8025" # Mailpit
```

### Add Services:

Add new services to `docker-compose.yml`:

```yaml
# Example: Add Elasticsearch
elasticsearch:
  image: elasticsearch:8.11-alpine
  container_name: [project_name]_elasticsearch
  environment:
    - discovery.type=single-node
  ports:
    - "9200:9200"
  networks:
    - [project_name]_network
```

## 🔄 Maintenance

### Update Template:

```bash
git pull origin main
```

### Clean Up:

```bash
# Remove all containers and volumes
docker-compose down -v

# Remove all images
docker system prune -a
```

## 📚 Resources

- [Laravel Documentation](https://laravel.com/docs)
- [React Documentation](https://react.dev)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [Redis Documentation](https://redis.io/documentation)
- [Docker Documentation](https://docs.docker.com)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This template is open source and available under the [MIT License](LICENSE).

---

**Happy coding! 🎉**
