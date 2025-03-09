# Example Redis service using redis-client
class RedisService
  class << self
    # Get a value from Redis
    def get(key)
      with_redis { |redis| redis.call("GET", key) }
    end

    # Set a value in Redis
    def set(key, value, expires_in: nil)
      with_redis do |redis|
        if expires_in
          redis.call("SETEX", key, expires_in.to_i, value.to_s)
        else
          redis.call("SET", key, value.to_s)
        end
      end
    end

    # Delete a key from Redis
    def delete(key)
      with_redis { |redis| redis.call("DEL", key) }
    end

    # Check if a key exists in Redis
    def exists?(key)
      with_redis { |redis| redis.call("EXISTS", key) == 1 }
    end

    # Increment a counter
    def increment(key, by: 1)
      with_redis { |redis| redis.call("INCRBY", key, by) }
    end

    # Add a member to a set
    def add_to_set(set_name, member)
      with_redis { |redis| redis.call("SADD", set_name, member) }
    end

    # Get all members of a set
    def members_of_set(set_name)
      with_redis { |redis| redis.call("SMEMBERS", set_name) }
    end

    # Add to a sorted set with score
    def add_to_sorted_set(set_name, score, member)
      with_redis { |redis| redis.call("ZADD", set_name, score, member) }
    end

    # Get range from sorted set
    def range_from_sorted_set(set_name, start, stop)
      with_redis { |redis| redis.call("ZRANGE", set_name, start, stop) }
    end

    # Push to a list
    def push_to_list(list_name, value)
      with_redis { |redis| redis.call("RPUSH", list_name, value) }
    end

    # Pop from a list
    def pop_from_list(list_name)
      with_redis { |redis| redis.call("LPOP", list_name) }
    end

    # Get list range
    def list_range(list_name, start, stop)
      with_redis { |redis| redis.call("LRANGE", list_name, start, stop) }
    end

    # Set hash field
    def set_hash_field(hash_name, field, value)
      with_redis { |redis| redis.call("HSET", hash_name, field, value) }
    end

    # Get hash field
    def get_hash_field(hash_name, field)
      with_redis { |redis| redis.call("HGET", hash_name, field) }
    end

    # Get all hash fields and values
    def get_hash_all(hash_name)
      with_redis do |redis|
        result = redis.call("HGETALL", hash_name)
        # Convert flat array to hash: ["key1", "val1", "key2", "val2"] -> {"key1" => "val1", "key2" => "val2"}
        result.each_slice(2).to_h
      end
    end

    # Publish a message to a channel
    def publish(channel, message)
      with_redis { |redis| redis.call("PUBLISH", channel, message) }
    end

    # Execute a Lua script
    def eval_script(script, keys = [], args = [])
      with_redis { |redis| redis.call("EVAL", script, keys.length, *keys, *args) }
    end

    # Clear cache by pattern (CAREFUL: This is an expensive operation)
    def clear_by_pattern(pattern)
      with_redis do |redis|
        cursor = "0"
        loop do
          cursor, keys = redis.call("SCAN", cursor, "MATCH", pattern, "COUNT", 1000)
          redis.call("DEL", *keys) unless keys.empty?
          break if cursor == "0"
        end
      end
    end
  end
end
