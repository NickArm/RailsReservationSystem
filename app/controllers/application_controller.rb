class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_settings
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_countries

  private

  def redirect_to_admin_dashboard
    redirect_to admin_path if request.path == root_path
  end

  def load_settings
    @settings = Setting.first_or_initialize
  end

  protected

 def set_countries
    @countries = ISO3166::Country.all.map { |country| [ country.translations[I18n.locale.to_s] || country.name, country.alpha2 ] }.sort_by { |c| c[0] }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone, :address, :country, :city, :zip_code ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :phone, :address, :country, :city, :zip_code ])
  end
end
