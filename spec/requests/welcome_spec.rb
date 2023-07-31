require 'rails_helper'

RSpec.describe "Welcomes", type: :request do
  describe "GET #index" do
    it "renders the index template" do
      get '/'
      expect(response).to render_template(:index)
    end
  end

  describe "GET #disclaimer" do
    it "renders the disclaimer template" do
      get '/disclaimer'
      expect(response).to render_template(:disclaimer)
    end
  end

end
