class ApplicationController < ActionController::Base
  # http_basic_authenticate_with name: "da", password: "qwerty444"

  before_action :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :subtract_www_subdomain

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      raise
    else
      flash[:alert] = t('devise.failure.unauthenticated')
      session[:requested_url] = request.url
      redirect_to new_user_session_path
    end
  end

  private
    def subtract_www_subdomain
      if request.host.split('.')[0] == 'www'
        redirect_to 'https://' + request.host.gsub('www.',''), status: 301
      end
    end

  protected
    def configure_permitted_parameters
      attributes = %i[login email]
      devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
      devise_parameter_sanitizer.permit(:account_update, keys: attributes)
    end
end
