module LoggerService
  class << self
    def error(message)
      Rails.logger.error(format_message(message))
    end

    def info(message)
      Rails.logger.info(format_message(message))
    end

    def warn(message)
      Rails.logger.warn(format_message(message))
    end

    def debug(message)
      Rails.logger.debug(format_message(message))
    end

    private

    def format_message(message)
      message = if message.is_a?(Hash) || message.is_a?(Array)
                  message.to_json
                else
                  message.to_s
                end

      "CUSTOM_LOG:#{message}"
    end
  end
end
