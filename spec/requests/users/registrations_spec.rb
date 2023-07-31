# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :request do
  let(:new_customer_registration_path) { "/register/customer" }
  let(:new_event_organizer_registration_path) { "/register/event_organizer" }

  describe "GET #new_customer" do
    it "renders the new_customer template" do
      get new_customer_registration_path
      expect(response).to render_template(:new_customer)
    end
  end

  describe "GET #new_event_organizer" do
    it "renders the new_event_organizer template" do
      get new_event_organizer_registration_path
      expect(response).to render_template(:new_event_organizer)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        user: {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password",
          username: "testuser",
          firstname: "John",
          lastname: "Doe",
          birthdate: Date.new(1990, 1, 1)
        }
      }
    end

    context "with valid params" do
      it "creates a new User and associated Customer" do
        expect do
          post new_customer_registration_path, params: valid_params.merge(user_type: :customer)
        end.to change(User, :count).by(1).and change(Customer, :count).by(1)

        user = User.last
        expect(user.customer).to be_present
      end

      it "creates a new User and associated EventOrganizer" do
        expect do
          post new_event_organizer_registration_path, params: valid_params.merge(user_type: :event_organizer)
        end.to change(User, :count).by(1).and change(EventOrganizer, :count).by(1)

        user = User.last
        expect(user.event_organizer).to be_present
      end

      it "redirects to the appropriate path after successful sign-up for customer" do
        post new_customer_registration_path, params: valid_params.merge(user_type: :customer)
        expect(response).to redirect_to(root_path)
        flash[:notice].should == "Welcome! You have signed up successfully."
      end

      it "redirects to the appropriate path after successful sign-up for event organizer" do
        post new_event_organizer_registration_path, params: valid_params.merge(user_type: :event_organizer)
        expect(response).to redirect_to(root_path)
        flash[:notice].should == "Welcome! You have signed up successfully."
      end
    end

    context "with invalid params" do
      let(:invalid_params) { valid_params.merge(user: { email: "" }) }

      it "does not create a new User for customer" do
        expect do
          post new_customer_registration_path, params: invalid_params.merge(user_type: :customer)
        end.not_to change(User, :count)
      end

      it "does not create a new User for event organizer" do
        expect do
          post new_event_organizer_registration_path, params: invalid_params.merge(user_type: :event_organizer)
        end.not_to change(User, :count)
      end

      it "renders the new_customer template for customer" do
        post new_customer_registration_path, params: invalid_params.merge(user_type: :customer)
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to(new_customer_registration_path)
      end

      it "renders the new_event_organizer template for event organizer" do
        post new_event_organizer_registration_path, params: invalid_params.merge(user_type: :event_organizer)
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to(new_event_organizer_registration_path)
      end
    end
  end
end
