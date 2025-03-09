require "redis-client"
require "connection_pool"

REDIS_URL = ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0")

# Create a Redis connection pool with hiredis driver
REDIS_POOL = ConnectionPool.new(size: ENV.fetch("REDIS_POOL_SIZE", 5), timeout: ENV.fetch("REDIS_POOL_TIMEOUT", 3)) do
  RedisClient.config(
    url: REDIS_URL,
    driver: :hiredis,
    connect_timeout: ENV.fetch("REDIS_CONNECT_TIMEOUT", 1),
    read_timeout: ENV.fetch("REDIS_READ_TIMEOUT", 1),
    write_timeout: ENV.fetch("REDIS_WRITE_TIMEOUT", 1),
    reconnect_attempts: 3
  ).new_client
end

# Helper method to execute Redis commands within a pool
def with_redis(&block)
  REDIS_POOL.with(&block)
end

# Example usage:
# with_redis do |redis|
#   redis.call("GET", "my_key")
#   redis.call("SET", "my_key", "my_value")
#   redis.call("EXPIRE", "my_key", 60)
# end
