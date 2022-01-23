class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_locale
    # %w で配列を定義する
    if %w(ja en).include?(session[:locale])
      I18n.locale = session[:locale]
    end
  end
end
