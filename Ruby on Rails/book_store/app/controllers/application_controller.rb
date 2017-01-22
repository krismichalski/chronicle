class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  include HttpAcceptLanguage::AutoLocale

  protected

  def configure_permitted_parameters
    keys = [:name, :surname, :pesel, :address, :worker] if current_user && (current_user.admin? || current_user.worker?)
    # keys.insert(:worker) if current_user && current_user.admin?
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
  end
end
