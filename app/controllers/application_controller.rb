class ApplicationController < ActionController::Base
    # run these methods before every other controller action.
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: devise_controller?

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name image])
      devise_parameter_sanitizer.permit(:account_updatek, keys: %i[first_name last_name image])
    end
end
