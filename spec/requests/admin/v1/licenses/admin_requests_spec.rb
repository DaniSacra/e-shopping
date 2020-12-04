require 'rails_helper'

RSpec.describe "Admin::V1::Licenses", type: :request do

  context "GET /index" do
    it "returns http success" do
      get "/admin/v1/licenses/index"
      expect(response).to have_http_status(:success)
    end
  end

  context "GET /show" do
    it "returns http success" do
      get "/admin/v1/licenses/show"
      expect(response).to have_http_status(:success)
    end
  end

  context "GET /create" do
    it "returns http success" do
      get "/admin/v1/licenses/create"
      expect(response).to have_http_status(:success)
    end
  end

  context "GET /update" do
    it "returns http success" do
      get "/admin/v1/licenses/update"
      expect(response).to have_http_status(:success)
    end
  end

  context "GET /destroy" do
    it "returns http success" do
      get "/admin/v1/licenses/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
