require "rails_helper"

RSpec.describe LoggerService do
  let(:logger) { instance_double(Logger) }

  before do
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe ".error" do
    it "logs an error message" do
      expect(logger).to receive(:error).with("CUSTOM_LOG:Test error message")
      described_class.error("Test error message")
    end
  end

  describe ".info" do
    it "logs an info message" do
      expect(logger).to receive(:info).with("CUSTOM_LOG:Test info message")
      described_class.info("Test info message")
    end
  end

  describe ".warn" do
    it "logs a warning message" do
      expect(logger).to receive(:warn).with("CUSTOM_LOG:Test warning message")
      described_class.warn("Test warning message")
    end
  end

  describe ".debug" do
    it "logs a debug message" do
      expect(logger).to receive(:debug).with("CUSTOM_LOG:Test debug message")
      described_class.debug("Test debug message")
    end
  end

  describe "format_message" do
    it "formats hash messages as JSON" do
      hash_message = { key: "value" }
      formatted_message = described_class.send(:format_message, hash_message)
      expect(formatted_message).to eq("CUSTOM_LOG:{\"key\":\"value\"}")
    end

    it "formats array messages as JSON" do
      array_message = [1, 2, 3]
      formatted_message = described_class.send(:format_message, array_message)
      expect(formatted_message).to eq("CUSTOM_LOG:[1,2,3]")
    end

    it "formats string messages as string" do
      string_message = "plain text"
      formatted_message = described_class.send(:format_message, string_message)
      expect(formatted_message).to eq("CUSTOM_LOG:plain text")
    end
  end
end
