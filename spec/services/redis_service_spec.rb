require "rails_helper"

RSpec.describe RedisService do
  let(:mock_redis) { instance_double(RedisClient) }

  before do
    allow(described_class).to receive(:with_redis).and_yield(mock_redis)
  end

  describe ".get and .set" do
    it "stores and retrieves a value" do
      expect(mock_redis).to receive(:call).with("SET", "test_key", "test_value").and_return("OK")
      expect(mock_redis).to receive(:call).with("GET", "test_key").and_return("test_value")

      described_class.set("test_key", "test_value")
      expect(described_class.get("test_key")).to eq("test_value")
    end
  end

  describe ".delete" do
    it "removes a key" do
      expect(mock_redis).to receive(:call).with("DEL", "test_key").and_return(1)

      described_class.delete("test_key")
    end
  end

  describe ".exists?" do
    it "checks if a key exists" do
      expect(mock_redis).to receive(:call).with("EXISTS", "test_key").and_return(1)

      expect(described_class.exists?("test_key")).to be true
    end
  end

  describe ".increment" do
    it "increments a counter" do
      expect(mock_redis).to receive(:call).with("INCRBY", "counter", 2).and_return(3)

      expect(described_class.increment("counter", by: 2)).to eq(3)
    end
  end

  describe ".push_to_list and .pop_from_list" do
    it "pushes and pops from a list" do
      expect(mock_redis).to receive(:call).with("RPUSH", "test_list", "value1").and_return(1)
      expect(mock_redis).to receive(:call).with("RPUSH", "test_list", "value2").and_return(2)
      expect(mock_redis).to receive(:call).with("LPOP", "test_list").and_return("value1")
      expect(mock_redis).to receive(:call).with("LPOP", "test_list").and_return("value2")

      described_class.push_to_list("test_list", "value1")
      described_class.push_to_list("test_list", "value2")
      expect(described_class.pop_from_list("test_list")).to eq("value1")
      expect(described_class.pop_from_list("test_list")).to eq("value2")
    end
  end

  describe ".set_hash_field and .get_hash_field" do
    it "stores and retrieves a hash field" do
      expect(mock_redis).to receive(:call).with("HSET", "test_hash", "field1", "value1").and_return(1)
      expect(mock_redis).to receive(:call).with("HGET", "test_hash", "field1").and_return("value1")

      described_class.set_hash_field("test_hash", "field1", "value1")
      expect(described_class.get_hash_field("test_hash", "field1")).to eq("value1")
    end
  end

  describe ".publish" do
    it "publishes a message to a channel" do
      expect(mock_redis).to receive(:call).with("PUBLISH", "test_channel", "hello").and_return(1)

      described_class.publish("test_channel", "hello")
    end
  end
end
