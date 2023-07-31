# Users::RegistrationsController
# Controller responsible for user registrations. It overrides registration controller of the Devise gem
# The create action saves the user based on the provided sign-up parameters,
# creates the associated customer or event organizer object,
# and handles the appropriate redirection (dedicated Dashboard for customer and event organizer) and authentication logic

module Users
  class RegistrationsController < Devise::RegistrationsController
    def new_customer
      build_resource({})
      respond_with resource, location: new_customer_registration_path
    end

    def new_event_organizer
      build_resource({})
      respond_with resource, location: new_event_organizer_registration_path
    end

    def create
      build_resource(sign_up_params)

      if resource.save
        if params[:user_type].to_sym == :customer
          resource.create_customer
        elsif params[:user_type].to_sym == :event_organizer
          resource.create_event_organizer
        end

        yield resource if block_given?

        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      elsif resource.errors.any?
        if params[:user_type].to_sym == :customer
         # flash[:error] = resource.errors.full_messages.join(", ")
          set_flash_message! :notice, :"custom_errors", errors: resource.errors.full_messages.join(", ")
          redirect_to new_customer_registration_path
        elsif params[:user_type].to_sym == :event_organizer
         # flash[:error] = resource.errors.full_messages.join(", ")
          set_flash_message! :notice, :"custom_errors", errors: resource.errors.full_messages.join(", ")
          redirect_to new_event_organizer_registration_path
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource, location: root_path
      end
    end

    protected

    def sign_up_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :username,
        :firstname,
        :lastname,
        :birthdate
      )
    end

    def after_sign_up_path_for(resource)
      if resource.is_a?(User) && resource.customer.present?
        # Redirect to customer dashboard after customer registration
        root_path
      elsif resource.is_a?(User) && resource.event_organizer.present?
        # Redirect to event organizer dashboard after event organizer registration
        root_path
      else
        super
      end
    end
  end
end
