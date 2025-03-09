module Api
  module V1
    class BaseController < ApplicationController
      include ActionController::MimeResponds

      before_action :set_default_format

      rescue_from StandardError, with: :render_internal_server_error
      rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature, with: :render_unauthorized_access

      private

      def set_default_format
        request.format = :json unless params[:format]
      end

      def authenticate_user!
        token = request.headers["Authorization"]&.split&.last
        return render_unauthorized_access unless token

        decoded_token = JWT.decode(token, ENV.fetch("JWT_SECRET_KEY", nil))
        @current_user = User.find_by(username: decoded_token.first["username"])

        render_unauthorized_access unless @current_user
      end

      attr_reader :current_user

      def render_not_found(error)
        render json: {
          error: {
            code: "not_found",
            message: error.message
          }
        }, status: :not_found
      end

      def render_parameter_missing(error)
        render json: {
          error: {
            code: "parameter_missing",
            message: error.message
          }
        }, status: :bad_request
      end

      def render_unprocessable_entity(error)
        render json: {
          error: {
            code: "unprocessable_entity",
            message: error.message,
            details: error.record.errors.full_messages
          }
        }, status: :unprocessable_entity
      end

      def render_internal_server_error(error)
        log_error(error)

        render json: {
          error: {
            code: "internal_server_error",
            message: "Unexpected error has occurred"
          }
        }, status: :internal_server_error
      end

      def render_unauthorized_access(error = nil, message: "Invalid or missing authentication token")
        log_error(error) if error.present?

        render json: {
          error: {
            code: "unauthorized",
            message: message
          }
        }, status: :unauthorized
      end

      def log_error(error)
        log_content = {
          request_id: request.request_id,
          error: {
            class: error.class.name,
            message: error.message,
            backtrace: error.backtrace.first(5)
          }
        }
        LoggerService.error(log_content)
      end
    end
  end
end
