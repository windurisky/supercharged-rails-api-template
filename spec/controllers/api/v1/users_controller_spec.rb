require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "#me" do
    let(:jwt_secret) { "test_secret" }

    before do
      stub_const("ENV", ENV.to_hash.merge("JWT_SECRET_KEY" => jwt_secret))
    end

    context "when authenticated user requests their own data" do
      let!(:user) { create(:user, username: "testuser", name: "Test User") }
      let(:token) { JWT.encode({ username: user.username }, jwt_secret) }

      before do
        request.headers["Authorization"] = "Bearer #{token}"
      end

      it "returns the user's data" do
        get :me

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response["username"]).to eq(user.username)
        expect(json_response["name"]).to eq(user.name)
        expect(json_response["created_at"]).to eq(user.created_at.iso8601)
      end
    end

    context "when no token is provided" do
      before do
        request.headers["Authorization"] = nil
      end

      it "returns unauthorized status" do
        get :me

        expect(response).to have_http_status(:unauthorized)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("unauthorized")
      end
    end

    context "when invalid token is provided" do
      before do
        request.headers["Authorization"] = "Bearer invalid_token"
      end

      it "returns unauthorized status" do
        get :me

        expect(response).to have_http_status(:unauthorized)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("unauthorized")
      end
    end

    context "when a user with the username from the token does not exist" do
      before do
        invalid_token = JWT.encode({ username: "nonexistentuser" }, jwt_secret)
        request.headers["Authorization"] = "Bearer #{invalid_token}"
      end

      it "returns unauthorized status" do
        get :me

        expect(response).to have_http_status(:unauthorized)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("unauthorized")
      end
    end
  end
end
