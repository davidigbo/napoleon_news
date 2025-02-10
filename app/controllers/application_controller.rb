class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :configure_permitted_parameters, :force_html_format, if: :devise_controller?
  before_action :set_nav_link_variables,:set_active_contest

  around_action :set_time_zone

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def set_nav_link_variables
    @all_categories = Category.all#pluck(:name, :id).to_h.transform_keys(&:downcase)
  end

  def set_active_contest
    @active_contest = Contest.first
  end


  private

  def set_time_zone
    timezone = cookies[:timezone] || 'UTC'
    Time.use_zone(timezone) { yield }
  rescue ArgumentError
    Time.use_zone('UTC') { yield }
  end

  def force_html_format
    request.format = :html if request.format.symbol.nil?
  end
end
