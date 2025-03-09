require "jwt"

module Api
  module V1
    class AuthController < Api::V1::BaseController
      def login
        login_params = validate_login_params!

        user = User.find_by(username: login_params[:username])

        if user&.authenticate(login_params[:password])
          token = generate_jwt(user)
          render json: { token: token, message: "Login successful" }, status: :ok
        else
          render_unauthorized_access(nil, message: "Invalid username or password")
        end
      end

      private

      def validate_login_params!
        params.require(:username)
        params.require(:password)
        params.permit(:username, :password)
      end

      def generate_jwt(user)
        payload = {
          username: user.username,
          exp: 2.hours.from_now.to_i # Token expires in 24 hours
        }

        JWT.encode(payload, ENV.fetch("JWT_SECRET_KEY", nil))
      end
    end
  end
end
