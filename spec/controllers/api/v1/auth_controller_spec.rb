require "rails_helper"

RSpec.describe Api::V1::AuthController, type: :controller do
  describe "#login" do
    let!(:user) { create(:user, username: "testuser", password: "password", name: "Test User") }
    let(:jwt_secret) { "test_secret" }

    before do
      stub_const("ENV", ENV.to_hash.merge("JWT_SECRET_KEY" => jwt_secret))
    end

    context "when valid credentials are provided" do
      it "returns a JWT token and success message" do
        post :login, params: { username: user.username, password: "password" }

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response).to have_key("token")
        expect(json_response["message"]).to eq("Login successful")

        decoded_token = JWT.decode(json_response["token"], jwt_secret, true, algorithm: "HS256").first
        expect(decoded_token["username"]).to eq(user.username)
      end
    end

    context "when invalid username is provided" do
      it "returns an unauthorized error" do
        post :login, params: { username: "wronguser", password: "password" }

        expect(response).to have_http_status(:unauthorized)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("unauthorized")
        expect(json_response["error"]["message"]).to eq("Invalid username or password")
      end
    end

    context "when invalid password is provided" do
      it "returns an unauthorized error" do
        post :login, params: { username: user.username, password: "wrongpassword" }

        expect(response).to have_http_status(:unauthorized)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("unauthorized")
        expect(json_response["error"]["message"]).to eq("Invalid username or password")
      end
    end

    context "when username parameter is missing" do
      it "returns a bad request error" do
        post :login, params: { password: "password" }

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("parameter_missing")
        expect(json_response["error"]["message"]).to include("username")
      end
    end

    context "when password parameter is missing" do
      it "returns a bad request error" do
        post :login, params: { username: user.username }

        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body
        expect(json_response["error"]["code"]).to eq("parameter_missing")
        expect(json_response["error"]["message"]).to include("password")
      end
    end
  end
end
