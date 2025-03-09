require 'sidekiq'
# require 'sidekiq/web'

SIDEKIQ_REDIS_URL = ENV.fetch('SIDEKIQ_REDIS_URL', REDIS_URL)
redis_config = {
  url: REDIS_URL,
  driver: :hiredis,
  connect_timeout: ENV.fetch('REDIS_CONNECT_TIMEOUT', 1).to_f,
  read_timeout: ENV.fetch('REDIS_READ_TIMEOUT', 1).to_f,
  write_timeout: ENV.fetch('REDIS_WRITE_TIMEOUT', 1).to_f,
  pool_timeout: ENV.fetch('SIDEKIQ_POOL_TIMEOUT', 3).to_f
}


Sidekiq.configure_server do |config|
  config.redis = redis_config.merge(
    size: ENV.fetch('SIDEKIQ_SERVER_POOL_SIZE', 10).to_i
  )

  # Configure server middleware if needed
  # config.server_middleware do |chain|
  #   chain.add MyCustomMiddleware
  # end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config.merge(
    size: ENV.fetch('SIDEKIQ_CLIENT_POOL_SIZE', 10).to_i
  )

  # Configure client middleware if needed
  # config.client_middleware do |chain|
  #   chain.add MyClientMiddleware
  # end
end

# Set up Web UI security if used in production
# if Rails.env.production?
#   Sidekiq::Web.use Rack::Auth::Basic do |username, password|
#     # Replace with proper secure comparison
#     ActiveSupport::SecurityUtils.secure_compare(
#       ::Digest::SHA256.hexdigest(username),
#       ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_WEB_USERNAME'])
#     ) &
#     ActiveSupport::SecurityUtils.secure_compare(
#       ::Digest::SHA256.hexdigest(password),
#       ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_WEB_PASSWORD'])
#     )
#   end
# end
