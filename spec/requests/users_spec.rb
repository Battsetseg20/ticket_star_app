require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST #create" do
    let(:user_params) { attributes_for(:user) }

    it "creates a new user" do
      expect {
        post :create, params: { user: user_params }
      }.to change(User, :count).by(1)
    end
  end
end

