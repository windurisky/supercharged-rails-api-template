# Rails Microservice

A Ruby on Rails API-only microservice with the following specifications:
- Rails 7.2.1
- Ruby 3.3.0
- MySQL 8.0.40
- Redis 7.0

## Development with GitHub Codespaces

This project is configured to work with GitHub Codespaces, which provides a complete development environment in the cloud.

### Getting Started

1. Click on the "Code" button in your GitHub repository
2. Select the "Codespaces" tab
3. Click "Create codespace on main"

The codespace will automatically:
- Set up a development container with Ruby 3.3.0
- Install Rails 7.2.1
- Set up MySQL 8.0.40 and Redis 7.0
- Install all the necessary extensions for VS Code
- Run `bundle install` to install all dependencies
- Create the development database

### Available VS Code Extensions

The devcontainer comes with these pre-installed extensions:
- GitLens
- Ruby LSP
- Solargraph
- Ruby
- Endwise
- Ruby Rubocop
- YAML
- Rainbow CSV
- Docker
- ESLint
- Prettier

### Development Workflow

1. Once the Codespace is started, you can run Rails commands in the terminal:

```bash
# Setup .env file
cp .env.sample .env

# Start the Rails server
rails s

# Run a console
rails c

# Generate components with rails (examples)
rails generate migration create_users
rails generate model user username:string name:string
rails generate controller Api::V1::Users
```

2. The following ports are forwarded:
   - 3000: Rails server
   - 3306: MySQL
   - 6379: Redis

3. Database commands:

```bash
# Create the database, load schema, and seed data
rails db:setup
```

### Services

- **MySQL**: Available at `db:3306` with default username `root` and default password `password`
- **Redis**: Available at `redis:6379`

## Project Structure

This is an API-only Rails application. The main existing components are:

- `app/controllers/api`: Contains API controllers
- `app/models`: Data models
- `app/services`: Service objects for business logic
- `app/jobs`: Sidekiq background jobs

## Testing

This project uses RSpec for testing:

```bash
# Run all tests
rspec

# Run specific tests
rspec spec/models/user_spec.rb
```

## API Documentation

API documentation is generated using RSwag:

```bash
# Generate API documentation
rails rswag:specs:swaggerize
```

After generating, the API documentation is available at `/api-docs` once the server is started.

## Additional Information

- Simple token-based login & authentication features are ready to use.
- User passwords are already hashed using BCrypt.
- API documentation for existing endpoints are available through Swagger.
- Logging with JSON format is enabled with lograge.