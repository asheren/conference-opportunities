require "rails_helper"

RSpec.describe StylesController do
  render_views

  describe "GET #index" do
    it "succeeds" do
      get :index
      expect(response).to be_success
    end

    it "renders the header" do
      get :index
      expect(assigns(:styles)).to include(
        'application' => [Rails.root.join("app/views/styles/application/_header.html.erb").to_s]
      )
    end
  end
end
