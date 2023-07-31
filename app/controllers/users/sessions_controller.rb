# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # DELETE /users/sign_out
    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out if signed_out
      yield if block_given?
      respond_to_on_destroy
    end

    protected

    def respond_to_on_destroy
      # Redirect to the root_path after signing out
      redirect_to root_path
    end
  end
end
