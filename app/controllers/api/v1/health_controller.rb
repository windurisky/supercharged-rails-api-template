module Api
  module V1
    class HealthController < Api::V1::BaseController
      # Typically used for service health check
      def index
        render json: { status: :ok }
      end
    end
  end
end
