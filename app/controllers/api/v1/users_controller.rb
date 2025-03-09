module Api
  module V1
    class UsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def me
        render json: {
          username: current_user.username,
          name: current_user.name,
          created_at: current_user.created_at.iso8601
        }, status: :ok
      end
    end
  end
end
