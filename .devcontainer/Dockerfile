FROM mcr.microsoft.com/devcontainers/ruby:3.3

# Install Rails
RUN gem install rails -v 7.2.1

# Install dependencies for building native extensions
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    default-mysql-client \
    git \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    curl \
    gnupg2 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and Yarn for Rails asset pipeline (for fullstack Rails)
# RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
#     && apt-get update && apt-get install -y nodejs \
#     && npm install -g yarn

# Set working directory
WORKDIR /workspace

# Install bundler for gem management
RUN gem install bundler

# Install solargraph for Ruby language server
RUN gem install solargraph

# Install debugging tools
RUN gem install debug

# Install linters and formatters
RUN gem install rubocop rubocop-rails rubocop-performance
