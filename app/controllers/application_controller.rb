class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def redirect_to_admin_dashboard
    redirect_to admin_path if request.path == root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :password, :password_confirmation ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :email, :password, :password_confirmation ])
  end
end
