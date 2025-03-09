Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = "ActionController::API"
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.ignore_actions = ["HealthController#index"]

  config.lograge.custom_payload do |controller|
    {
      request_id: controller.request.request_id,
      remote_ip: controller.request.remote_ip
    }
  end

  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    {
      request_id: event.payload[:request_id],
      remote_ip: event.payload[:remote_ip],
      params: event.payload[:params].except(*exceptions)
    }
  end
end
