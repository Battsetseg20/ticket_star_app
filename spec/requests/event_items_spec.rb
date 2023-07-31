# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventItemsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:customer) { create(:customer) }
  let(:event_organizer) { create(:event_organizer) }
  let(:event_item) { create(:event_item, :with_ticket, event_organizer: event_organizer) }

  describe "GET #index" do
    before do
      sign_in event_organizer.user
      get :index
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before do
      sign_in event_organizer.user
      get :show, params: { id: event_item.id }
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "assigns the requested event item to @event_item" do
      expect(assigns(:event_item)).to eq(event_item)
    end
  end

  describe "GET #new" do
    context "when user is an event organizer" do
      before do
        sign_in event_organizer.user
        get :new
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "assigns a new event item to @event_item" do
        expect(assigns(:event_item)).to be_a_new(EventItem)
      end
    end

    context "when user is a customer" do
      before do
        sign_in customer.user
        get :new
      end
      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets the flash alert message" do
        expect(flash[:alert]).to eq("You don't have permission to do this action")
      end
    end

    context "when user is not logged in" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when user is an event organizer" do
      before { sign_in event_organizer.user }

      context "with valid parameters" do
        it "creates a new event item" do
          expect do
            post :create,
                 params: { event_item: attributes_for(:event_item).merge(ticket_attributes: attributes_for(:ticket)) }
          end.to change(EventItem, :count).by(1).and change(Ticket, :count).by(1)
        end

        it "redirects to the created event item" do
          post :create,
               params: { event_item: attributes_for(:event_item).merge(ticket_attributes: attributes_for(:ticket)) }
          expect(response).to redirect_to(EventItem.last)
        end

        it "sets the flash notice message" do
          post :create,
               params: { event_item: attributes_for(:event_item).merge(ticket_attributes: attributes_for(:ticket)) }
          expect(flash[:notice]).to include("Your event #{EventItem.last.title} was successfully created.")
        end
      end

      context "with invalid parameters" do
        it "does not create a new event item" do
          expect do
            post :create, params: { event_item: attributes_for(:event_item, title: "") }
          end.not_to change(EventItem, :count)
        end

        it "renders the new template" do
          post :create, params: { event_item: attributes_for(:event_item, title: "") }
          expect(response).to redirect_to(new_event_item_path)
        end
      end
    end

    context "when user is a customer" do
      before { sign_in customer.user }

      it "does not create a new event item" do
        expect do
          post :create, params: { event_item: attributes_for(:event_item) }
        end.not_to change(EventItem, :count)
      end

      it "redirects to the root path" do
        post :create, params: { event_item: attributes_for(:event_item) }
        expect(response).to redirect_to(root_path)
      end

      it "sets the flash alert message" do
        post :create, params: { event_item: attributes_for(:event_item) }
        expect(flash[:alert]).to eq("You don't have permission to do this action")
      end
    end

    context "when user is not logged in" do
      it "does not create a new event item" do
        expect do
          post :create, params: { event_item: attributes_for(:event_item) }
        end.not_to change(EventItem, :count)
      end

      it "redirects to the sign in page" do
        post :create, params: { event_item: attributes_for(:event_item) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user is an event organizer" do
      before do
        sign_in event_organizer.user
        allow(controller).to receive(:editable_event?).and_return(true)
      end

      it "renders the edit template" do
        get :edit, params: { id: event_item.id }
        expect(response).to render_template(:edit)
      end

      it "assigns the requested event item to @event_item" do
        get :edit, params: { id: event_item.id }
        expect(assigns(:event_item)).to eq(event_item)
      end
    end

    context "when user is a customer" do
      before do
        sign_in customer.user
        get :edit, params: { id: event_item.id }
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets the flash alert message" do
        expect(flash[:alert]).to eq("You don't have permission to do this action")
      end
    end

    context "when user is not logged in" do
      it "redirects to the sign in page" do
        get :edit, params: { id: event_item.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user is an event organizer" do
      before { sign_in event_organizer.user }

      context "with valid parameters" do
        it "updates the event item" do
          patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
          event_item.reload
          expect(event_item.title).to eq("Updated Title")
        end

        it "redirects to the updated event item" do
          patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
          expect(response).to redirect_to(event_item)
        end

        it "sets the flash notice message" do
          patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
          expect(flash[:notice]).to eq("Your event was successfully updated.")
        end
      end

      context "with invalid parameters" do
        it "does not update the event item" do
          patch :update, params: { id: event_item.id, event_item: { title: "" } }
          event_item.reload
          expect(event_item.title).not_to eq("")
        end

        it "renders the edit template" do
          patch :update, params: { id: event_item.id, event_item: { title: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user is a customer" do
      before { sign_in customer.user }

      it "does not update the event item" do
        patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
        event_item.reload
        expect(event_item.title).not_to eq("Updated Title")
      end

      it "redirects to the root path" do
        patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
        expect(response).to redirect_to(root_path)
      end

      it "sets the flash alert message" do
        patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
        expect(flash[:alert]).to eq("You don't have permission to do this action")
      end
    end

    context "when user is not logged in" do
      it "does not update the event item" do
        patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
        event_item.reload
        expect(event_item.title).not_to eq("Updated Title")
      end

      it "redirects to the sign in page" do
        patch :update, params: { id: event_item.id, event_item: { title: "Updated Title" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is an event organizer" do
      before do
        sign_in event_organizer.user
        allow(controller).to receive(:can_destroy_event_item?).and_return(true)
      end

      it "destroys the event item" do
        event_item_to_destroy = create(:event_item, event_organizer: event_organizer)
        expect do
          delete :destroy, params: { id: event_item_to_destroy.id }
        end.to change(EventItem, :count).by(-1)
      end

      it "redirects to the event items index" do
        delete :destroy, params: { id: event_item.id }
        expect(response).to redirect_to(event_organizer_events_event_items_path)
      end

      it "sets the flash notice message" do
        delete :destroy, params: { id: event_item.id }
        expect(flash[:notice]).to eq("Your event was successfully destroyed.")
      end
    end

    context "when user is a customer" do
      before { sign_in customer.user }

      it "does not destroy the event item" do
        event_item_to_destroy = create(:event_item, event_organizer: event_organizer)
        expect do
          delete :destroy, params: { id: event_item_to_destroy.id }
        end.not_to change(EventItem, :count)
      end

      it "redirects to the event items index" do
        delete :destroy, params: { id: event_item.id }
        expect(response).to redirect_to(root_path)
      end

      it "sets the flash alert message" do
        delete :destroy, params: { id: event_item.id }
        expect(flash[:alert]).to eq("You don't have permission to do this action")
      end
    end

    context "when user is not logged in" do
      it "does not destroy the event item" do
        event_item_to_destroy = create(:event_item, event_organizer: event_organizer)
        expect do
          delete :destroy, params: { id: event_item_to_destroy.id }
        end.not_to change(EventItem, :count)
      end

      it "redirects to the sign in page" do
        delete :destroy, params: { id: event_item.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
