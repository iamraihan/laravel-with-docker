#!/bin/bash

# Laravel + React + PostgreSQL + Redis + Docker Setup Script
# This script creates a new Laravel project with full Docker setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Laravel + React + PostgreSQL + Redis + Docker Setup${NC}"
echo "=================================================="

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Please provide a project name${NC}"
    echo "Usage: ./setup-new-project.sh <project-name>"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="./$PROJECT_NAME"

echo -e "${YELLOW}📁 Creating project: $PROJECT_NAME${NC}"

# Check if directory already exists
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: Directory $PROJECT_DIR already exists${NC}"
    exit 1
fi

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo -e "${GREEN}✅ Project directory created${NC}"

# Copy Docker configuration files
echo -e "${YELLOW}📋 Copying Docker configuration...${NC}"
cp -r ../docker ./
cp ../docker-compose.yml ./
cp ../.dockerignore ./
cp ../env.example ./

# Update docker-compose.yml with project name
sed -i "s/laravel_app/${PROJECT_NAME}_app/g" docker-compose.yml
sed -i "s/laravel_nginx/${PROJECT_NAME}_nginx/g" docker-compose.yml
sed -i "s/laravel_postgres/${PROJECT_NAME}_postgres/g" docker-compose.yml
sed -i "s/laravel_redis/${PROJECT_NAME}_redis/g" docker-compose.yml
sed -i "s/laravel_node/${PROJECT_NAME}_node/g" docker-compose.yml
sed -i "s/laravel_pgadmin/${PROJECT_NAME}_pgadmin/g" docker-compose.yml
sed -i "s/laravel_redis_commander/${PROJECT_NAME}_redis_commander/g" docker-compose.yml
sed -i "s/laravel_mailpit/${PROJECT_NAME}_mailpit/g" docker-compose.yml
sed -i "s/laravel_network/${PROJECT_NAME}_network/g" docker-compose.yml

# Update database name
sed -i "s/laravel_db/${PROJECT_NAME}_db/g" docker-compose.yml
sed -i "s/laravel_user/${PROJECT_NAME}_user/g" docker-compose.yml
sed -i "s/laravel_password/${PROJECT_NAME}_password/g" docker-compose.yml

# Update env.example
sed -i "s/laravel_db/${PROJECT_NAME}_db/g" env.example
sed -i "s/laravel_user/${PROJECT_NAME}_user/g" env.example
sed -i "s/laravel_password/${PROJECT_NAME}_password/g" env.example

echo -e "${GREEN}✅ Docker configuration copied and updated${NC}"

# Create .env file
echo -e "${YELLOW}📝 Creating .env file...${NC}"
cp env.example .env

echo -e "${GREEN}✅ Environment file created${NC}"

# Start Docker services
echo -e "${YELLOW}🐳 Starting Docker services...${NC}"
docker-compose up -d

echo -e "${GREEN}✅ Docker services started${NC}"

# Wait for services to be ready
echo -e "${YELLOW}⏳ Waiting for services to be ready...${NC}"
sleep 10

# Install Laravel
echo -e "${YELLOW}📦 Installing Laravel...${NC}"
docker-compose exec app composer create-project laravel/laravel . --prefer-dist

echo -e "${GREEN}✅ Laravel installed${NC}"

# Set proper permissions
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
docker-compose exec app chown -R www-data:www-data /var/www/storage
docker-compose exec app chown -R www-data:www-data /var/www/bootstrap/cache
docker-compose exec app chmod -R 775 /var/www/storage
docker-compose exec app chmod -R 775 /var/www/bootstrap/cache

echo -e "${GREEN}✅ Permissions set${NC}"

# Generate Laravel key
echo -e "${YELLOW}🔑 Generating Laravel application key...${NC}"
docker-compose exec app php artisan key:generate

echo -e "${GREEN}✅ Laravel key generated${NC}"

# Install Node.js dependencies
echo -e "${YELLOW}📦 Installing Node.js dependencies...${NC}"
docker-compose exec node pnpm install

echo -e "${GREEN}✅ Node.js dependencies installed${NC}"

# Build frontend assets
echo -e "${YELLOW}🔨 Building frontend assets...${NC}"
docker-compose exec node pnpm run build

echo -e "${GREEN}✅ Frontend assets built${NC}"

# Run migrations
echo -e "${YELLOW}🗄️ Running database migrations...${NC}"
docker-compose exec app php artisan migrate

echo -e "${GREEN}✅ Database migrations completed${NC}"

# Create helper scripts
echo -e "${YELLOW}📜 Creating helper scripts...${NC}"

cat > dev.sh << 'EOF'
#!/bin/bash
# Development helper script
echo "🚀 Starting development environment..."
docker-compose up -d
echo "✅ Services started!"
echo ""
echo "🌐 Access Points:"
echo "  Laravel App: http://localhost:8080"
echo "  pgAdmin: http://localhost:5050"
echo "  Redis Commander: http://localhost:8081"
echo "  Mailpit: http://localhost:8025"
echo ""
echo "🔑 pgAdmin Login: admin@admin.com / admin"
echo "📋 PostgreSQL Host: postgres (for pgAdmin connection)"
EOF

cat > stop.sh << 'EOF'
#!/bin/bash
# Stop development environment
echo "🛑 Stopping development environment..."
docker-compose down
echo "✅ Services stopped!"
EOF

cat > restart.sh << 'EOF'
#!/bin/bash
# Restart development environment
echo "🔄 Restarting development environment..."
docker-compose down
docker-compose up -d
echo "✅ Services restarted!"
EOF

cat > logs.sh << 'EOF'
#!/bin/bash
# View logs
echo "📋 Viewing logs..."
docker-compose logs -f
EOF

chmod +x dev.sh stop.sh restart.sh logs.sh

echo -e "${GREEN}✅ Helper scripts created${NC}"

# Create README
cat > README.md << EOF
# $PROJECT_NAME

A Laravel + React + PostgreSQL + Redis project with Docker setup.

## 🚀 Quick Start

1. **Start the project:**
   \`\`\`bash
   ./dev.sh
   \`\`\`

2. **Stop the project:**
   \`\`\`bash
   ./stop.sh
   \`\`\`

3. **Restart the project:**
   \`\`\`bash
   ./restart.sh
   \`\`\`

4. **View logs:**
   \`\`\`bash
   ./logs.sh
   \`\`\`

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
- **Database**: ${PROJECT_NAME}_db
- **Username**: ${PROJECT_NAME}_user
- **Password**: ${PROJECT_NAME}_password

### Redis Commander:
- **No login required**
- Direct access to Redis at http://localhost:8081

## 🛠️ Development

### Running Commands:
\`\`\`bash
# Laravel commands
docker-compose exec app php artisan [command]

# Node.js commands
docker-compose exec node pnpm [command]

# Database commands
docker-compose exec postgres psql -U ${PROJECT_NAME}_user -d ${PROJECT_NAME}_db
\`\`\`

### Building Assets:
\`\`\`bash
docker-compose exec node pnpm run build
docker-compose exec node pnpm run dev
\`\`\`

## 📁 Project Structure

\`\`\`
$PROJECT_NAME/
├── docker/                 # Docker configuration
├── app/                    # Laravel application
├── resources/              # Frontend resources
├── public/                 # Public assets
├── database/               # Database migrations
├── routes/                 # Laravel routes
├── config/                 # Laravel configuration
├── storage/                # Laravel storage
├── tests/                  # Tests
├── vendor/                 # Composer dependencies
├── node_modules/           # Node.js dependencies
├── docker-compose.yml      # Docker services
├── .env                    # Environment variables
├── dev.sh                  # Start development
├── stop.sh                 # Stop services
├── restart.sh              # Restart services
└── logs.sh                 # View logs
\`\`\`

## 🔧 Configuration

The project uses:
- **Laravel** (PHP 8.2)
- **React** (with Vite)
- **PostgreSQL** 15
- **Redis** 7
- **Nginx** (web server)
- **pgAdmin** (PostgreSQL GUI)
- **Redis Commander** (Redis GUI)
- **Mailpit** (email testing)

## 🐳 Docker Services

- **app**: Laravel application (PHP-FPM)
- **nginx**: Web server
- **postgres**: PostgreSQL database
- **redis**: Redis cache
- **node**: Node.js for frontend
- **pgadmin**: PostgreSQL management
- **redis-commander**: Redis management
- **mailpit**: Email testing

## 📝 Notes

- All services are configured with Alpine Linux for smaller images
- Uses pnpm for Node.js package management
- Includes Tailwind CSS for styling
- Configured for local development
EOF

echo -e "${GREEN}✅ README created${NC}"

# Final status
echo ""
echo -e "${GREEN}🎉 Project setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}📁 Project created in: $PROJECT_DIR${NC}"
echo ""
echo -e "${YELLOW}🌐 Access your application at:${NC}"
echo -e "  Laravel App: ${GREEN}http://localhost:8080${NC}"
echo -e "  pgAdmin: ${GREEN}http://localhost:5050${NC}"
echo -e "  Redis Commander: ${GREEN}http://localhost:8081${NC}"
echo -e "  Mailpit: ${GREEN}http://localhost:8025${NC}"
echo ""
echo -e "${YELLOW}🔑 pgAdmin Login:${NC}"
echo -e "  Email: ${GREEN}admin@admin.com${NC}"
echo -e "  Password: ${GREEN}admin${NC}"
echo ""
echo -e "${YELLOW}📋 PostgreSQL Connection (for pgAdmin):${NC}"
echo -e "  Host: ${GREEN}postgres${NC}"
echo -e "  Database: ${GREEN}${PROJECT_NAME}_db${NC}"
echo -e "  Username: ${GREEN}${PROJECT_NAME}_user${NC}"
echo -e "  Password: ${GREEN}${PROJECT_NAME}_password${NC}"
echo ""
echo -e "${BLUE}🚀 To start development:${NC}"
echo -e "  cd $PROJECT_NAME"
echo -e "  ./dev.sh"
echo "" 