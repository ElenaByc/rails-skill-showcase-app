require "rails_helper"

RSpec.describe "Authentication protection", type: :request do
  describe "dashboard" do
    it "returns 403 when unauthenticated (JSON)" do
      get dashboard_path, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "skills" do
    it "index returns 403 when unauthenticated (JSON)" do
      get skills_path, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "new returns 403 when unauthenticated (JSON)" do
      get new_skill_path, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "create returns 403 when unauthenticated (JSON)" do
      post skills_path, params: { skill: { name: "X", description: "Y" } }, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "issuers" do
    it "index returns 403 when unauthenticated (JSON)" do
      get issuers_path, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "new returns 403 when unauthenticated (JSON)" do
      get new_issuer_path, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "certificates" do
    it "new returns 403 when unauthenticated (JSON)" do
      get new_certificate_path, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "create returns 403 when unauthenticated (JSON)" do
      post certificates_path, params: { certificate: { name: "C", issued_on: Date.today } }, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
